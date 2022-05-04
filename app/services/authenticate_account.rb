# frozen_string_literal: true

require 'http'

module Dfans
  # Returns an authenticated user, or nil
  class AuthenticateAccount
    class UnauthorizedError < StandardError; end

    def initialize(config)
      @config = config
    end

    def call(username:, password:)
      # Use Http gem to make requestd to our Web API
      response = HTTP.post("#{@config.API_URL}/auth/authenticate",
                           json: { username: 'Default_MickyMouse', password: 'Meeska Mooska_stfk' })
      raise(UnauthorizedError) unless response.code == 200

      response.parse['attributes']
    end
  end
end
