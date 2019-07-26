module TerminalCal
  class Config
    CONFIG_DIR = File.join(Dir.home, '.terminal_cal')
    CONFIG_FILE = 'config.yaml'.freeze
    CONFIG_PATH = File.join(CONFIG_DIR, CONFIG_FILE)

    def self.load
      unless File.exist?(CONFIG_PATH)
        FileUtils.mkdir_p(CONFIG_DIR)
        FileUtils.touch(CONFIG_PATH)
      end

      config = self.read

      if config[:ics].to_s.empty?
        self.write(:ics, '')
      end

      config
    end

    def self.write(key, value)
      config = self.read
      config[key] = value
      File.write(CONFIG_PATH, config.to_yaml)
    end

    def self.read
      YAML.load_file(CONFIG_PATH) || {}
    end
  end
end
