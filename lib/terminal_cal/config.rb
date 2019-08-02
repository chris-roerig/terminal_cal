module TerminalCal
  class Config
    APP_DIR     = File.join(Dir.home, '.terminal_cal')
    CONFIG_FILE = 'config.yaml'.freeze
    CONFIG_PATH = File.join(APP_DIR, CONFIG_FILE)

    def self.load
      unless File.exist?(CONFIG_PATH)
        FileUtils.mkdir_p(APP_DIR)
        File.write(CONFIG_PATH, config_template)
        FileUtils.touch(CONFIG_PATH)

        msg = <<~MSG
          New config generated at #{CONFIG_PATH}
          Please update config and then try again.
        MSG

        raise TerminalCal::Errors::AppExit, msg
      end

      self.read
    end

    def self.read
      YAML.load_file(CONFIG_PATH) || {}
    end

    def self.write(key, value)
      config = self.read
      config[key] = value
      File.write(CONFIG_PATH, config.to_yaml)
    end

    def self.calendars
      read[:calendars] || []
    end

    def self.clobber
      File.delete(CONFIG_PATH)
    end

    def self.config_template
      { calendars: [
          { name: 'Some Calendar',
            source: 'Some URL or file path',
            cache: true,
            cache_life_minutes: 30
          }
        ]
      }.to_yaml
    end
  end
end
