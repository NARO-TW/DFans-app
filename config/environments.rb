# frozen_string_literal: true

require 'delegate'
require 'roda'
require 'figaro'
require 'logger'
require 'rack/ssl-enforcer'
require 'rack/session/redis'
require_relative '../require_app'

require_app('lib')

module DFans
  # Configuration for the API
  class App < Roda
    plugin :environments

    # Environment variables setup
    Figaro.application = Figaro::Application.new(
      environment:,
      path: File.expand_path('config/secrets.yml')
    )
    Figaro.load
    def self.config
      Figaro.env
    end
    # Logger setup
    LOGGER = Logger.new($stderr)
    def self.logger
      LOGGER
    end
    ONE_MONTH = 30 * 24 * 60 * 60

    configure do
      SecureMessage.setup(ENV.delete('MSG_KEY'))
    end

    configure :production do
      # :production: using header HSTS to redirect HTTP to HTTPS ,which enforced TLS/SSL and avoid it go back again
      # Strict-Transport-Security: max-age=31536000
      # (Do not use devlopment, we will get locked out from local pc to server for a year)
      # If we got locked out, we maybe have to refresh the cache or reinstall the chrome or sth
      SecureSession.setup(ENV.fetch('REDIS_TLS_URL')) # REDIS_TLS_URL used again below

      use Rack::SslEnforcer, hsts: true

      use Rack::Session::Redis,
          expire_after: ONE_MONTH,
          redis_server: {
            url: ENV.delete('REDIS_TLS_URL'),
            ssl_params: { verify_mode: OpenSSL::SSL::VERIFY_NONE }
          }
    end

    configure :development, :test do
      require 'pry'

      # NOTE: env var REDIS_URL only used to wipe the session store (ok to be nil)
      SecureSession.setup(ENV.fetch('REDIS_URL', nil)) # REDIS_URL used again below

      # use Rack::Session::Cookie,
      #     expire_after: ONE_MONTH, secret: config.SESSION_SECRET

      use Rack::Session::Pool,
          expire_after: ONE_MONTH

      # use Rack::Session::Redis,
      #     expire_after: ONE_MONTH,
      #     redis_server: {
      #       url: ENV.delete('REDIS_URL')
      #     }
    end

    configure :development, :test do
      require 'pry'

      # Allows running reload! in pry to restart entire app
      def self.reload!
        exec 'pry -r ./spec/test_load_all'
      end
    end
  end
end
