module TerminalCal
  class App
    def initialize(options = {})
      @config     = options[:config] || TerminalCal::Config.load
      @now        = Time.now
      @calendars  = []
      @events     = []
    end

    def self.run
      new.run
    end

    def run
      load_calendars
      load_events
      print_events
    rescue => error
      raise TerminalCal::Errors::Error, error
    end

    private

    def load_calendars
      @calendars = @config[:calendars].to_a.map do |config|
        TerminalCal::Calendar.new(config: config)
      end
    end

    def load_events
      @events = @calendars.map do |calendar|
        calendar.todays_events
      end
    end

    def print_events
      unless @events.empty?
        tp @events.flatten
      else
        puts "No events scheduled yet."
      end
    end
  end
end
