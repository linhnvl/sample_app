require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you"ve limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module SampleApp
  class Application < Rails::Application

    # Initialize configuration defaults for originally generated Rails version.
    Bundler.require(*Rails.groups)
    Config::Integrations::Rails::Railtie.preload
    config.load_defaults 5.1
    config.i18n.load_path += Dir[Rails.root.join("config", "locales",
      "**", "*.{rb,yml}")]
    config.i18n.default_locale = :en

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Include the authenticity token in remote forms.
    config.action_view.embed_authenticity_token_in_remote_forms = true
    config.assets.initialize_on_precompile = false
  end
end
