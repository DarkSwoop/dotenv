require 'dotenv'
begin
  require 'spring/watcher'
rescue LoadError
  # Spring is not available
end

module Dotenv
  class Railtie < Rails::Railtie
    config.before_configuration { load }
    config.after_initialize { configure_spring }

    # Public: Load dotenv
    #
    # This will get called during the `before_configuration` callback, but you
    # can manually call `Dotenv::Railtie.load` if you needed it sooner.
    def load
      Dotenv.load *env_files
    end

    def configure_spring
      Spring.watch *env_files if defined?(Spring)
    end

    # Rails uses `#method_missing` to delegate all class methods to the
    # instance, which means `Kernel#load` gets called here. We don't want that.
    def self.load
      instance.load
    end

    private
    def env_files
      base_path = Rails.root
      [base_path.join('.env'), base_path.join(".env.#{Rails.env}")]
    end
  end
end
