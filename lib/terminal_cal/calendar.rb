module TerminalCal
  class Calendar
    DATE_FMT = '%m/%d'.freeze
    TIME_FMT = '%I:%M %p'.freeze

    attr_reader :source, :name, :cache_life_minutes

    def initialize(options = {})
      @config = options[:config]
      @parser = TerminalCal::CalendarParserFactory.new(options[:parser]).parser

      @source = @config[:source]
      @name   = @config[:name].to_s
      @cache  = @config[:cache] || true
      @cache_life_minutes = @config[:cache_life_minutes] || 10
      @now    = Time.now
      @today  = @now.strftime(DATE_FMT)

      @content = ''
    end

    def cache?
      return false unless [true, false].include?(@cache)
      @cache
    end

    def update_cache?
      return false unless cache?
      return true unless File.exist?(cache_path)
      (Time.now - File.atime(cache_path)) > (@cache_life_minutes * 60)
    end

    def events
      content = 
        if update_cache?
          fetch_events_from_source
        else
          fetch_events_from_cache
        end

      @parser.events(content)
    end

    def fetch_events_from_source
      source = @config[:source]
      content = open(source) { |f| f.read } 

      if cache?
        cache!(content)
      end

      content
    rescue ::SocketError => error
      raise TerminalCal::Errors::Error, error.message
    end

    def fetch_events_from_cache
      File.read(cache_path)
    end

    def cache_path
      filename = "#{@config[:name]}-cached-.ics".downcase
      File.join(TerminalCal::Config::APP_DIR, filename)
    end

    def cache!(content)
      File.open(cache_path, 'w+') do |file|
        file.write(content)
      end
    end

    def todays_events
      events.sort_by { |e| e.starts_at.to_i }.map do |event|
        next unless event.starts_at.strftime(DATE_FMT) == @today
        next if event.ends_at < @now

        Event.new(date: event.starts_at.strftime(DATE_FMT),
                  start_time: event.starts_at.strftime(TIME_FMT),
                  end_time: event.ends_at.strftime(TIME_FMT),
                  summary: event.summary)
      end.compact
    end
  end
end
