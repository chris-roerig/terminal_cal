module TerminalCal
  module CalendarParsers
    class IcsParserWrapper
      def self.events(content)
        IcsParser.from_string(content).events
      end
    end
  end
end
