module TerminalCal
  class CalendarParserFactory
    DEFAULT_PARSER = TerminalCal::CalendarParsers::IcsParserWrapper

    attr_reader :parser

    def initialize(parser)
      @parser = parser || DEFAULT_PARSER
    end
  end
end
