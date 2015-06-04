require 'haml'
require 'bcrypt'
require 'dynamic_form'
require 'kaminari'
require 'ransack'
require 'counter_culture'

require 'nifty/utils'
require 'nifty/key_value_store'
require 'nifty/attachments'

module Tienda
  class << self

    # The path to the root of the Tienda application
    #
    # @return [String]
    def root
      File.expand_path('../../', __FILE__)
    end

    # Tienda settings as configured in the database
    #
    # @return [Tienda::Settings]
    def settings
      Thread.current[:tienda_settings] ||= Tienda::Settings.new(Tienda::Setting.to_hash)
    end

    # Clears the settings from the thread cache so they will be taken
    # from the database on next access
    #
    # @return [NilClass]
    def reset_settings
      Thread.current[:tienda_settings] = nil
    end

    # Defines a new set of settings which should be configrable from the settings page
    # in the Tienda UI.
    def add_settings_group(group, fields = [])
      settings_groups[group]  ||= []
      settings_groups[group]    = settings_groups[group] | fields
    end

    # All settings groups which are available for configuration on the settings page.
    #
    # @return [Hash]
    def settings_groups
      @settings_groups ||= {}
    end
  end
end

# Start your engines.
require 'tienda/engine'
