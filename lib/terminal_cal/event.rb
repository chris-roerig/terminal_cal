module TerminalCal
  class Event
    attr_reader :date, :start_time, :end_time, :summary

    def initialize(options)
      @date       = options[:date]
      @start_time = options[:start_time]
      @end_time   = options[:end_time]
      @summary    = options[:summary]
    end
  end
end
