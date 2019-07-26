module TerminalCal
  class App
    DATE_FMT = '%m/%d'.freeze
    TIME_FMT = '%I:%M %p'.freeze

    def initialize
      @config = Config.load
      @today = Time.now.strftime(DATE_FMT)
      @events = []
      @parser = IcsParser
    end

    def self.run
      new.run
    end

    def run
      config_check
      load_events
      print_events
    end

    private

    def config_check
      @ics = @config[:ics]

      if @ics.to_s.empty?
        puts "no ics path defined in #{Config::CONFIG_PATH}"
        exit
      end
    end

    def load_events
      now = Time.now
      events = @parser.from_string(read_cal_file).events

      events.sort_by { |e| e.starts_at.to_i }.each do |event|
        next unless event.starts_at.strftime(DATE_FMT) == @today

          if (event.starts_at..event.ends_at).include?(now)
            active = "==="
          end


          @events << Event.new(date: event.starts_at.strftime(DATE_FMT),
                               start_time: event.starts_at.strftime(TIME_FMT),
                               end_time: "#{event.ends_at.strftime(TIME_FMT)} #{active}",
                               summary: event.summary)
      #  end
      end
    end

    def print_events
      unless @events.empty?
        tp @events
      else
        puts "No events scheduled yet."
      end
    end

    def read_cal_file
      cal = Tempfile.new
      cal.write(open(@ics) { |f| f.read } )
      cal.rewind
      cal.read
    ensure
      cal.close
    end
  end
end
