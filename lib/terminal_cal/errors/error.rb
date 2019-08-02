module TerminalCal
  # Namespace for TerminalCal errors
  module Errors
    # General gem errors
    class Error < StandardError; end

    # Graceful application quitting
    class AppExit < StandardError; end
  end
end
