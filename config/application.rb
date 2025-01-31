require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

# Include middleware
require './lib/middleware/bad_multipart_form_data_sanitizer'

module Ozfortress
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.0

    # Use new serialization format
    config.active_support.cache_format_version = 7.0

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'Sydney'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Make view helpers, view specific
    config.action_controller.include_all_helpers = false

    # New lookup logic
    config.add_autoload_paths_to_load_path = false

    # Use dynamic error pages
    config.exceptions_app = self.routes

    # News config file
    config.news = config_for(:news).with_indifferent_access

    # config.middleware.use 'BadMultipartFormDataSanitizer'
    config.middleware.insert_before Rack::Runtime, BadMultipartFormDataSanitizer
  end
end
