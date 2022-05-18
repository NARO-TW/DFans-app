# frozen_string_literal: true

require 'http'

module DFans
  # Returns an authenticated user, or nil
  class AuthenticateAccount
    class UnauthorizedError < StandardError; end

    class ApiServerError < StandardError; end

    def initialize(config)
      @config = config
    end

    def call(username:, password:)
      # Use Http gem to make requestd to our Web API
      response = HTTP.post("#{@config.API_URL}/auth/authenticate",
                           json: { username: username, password: password})

      raise(UnauthorizedError) if response.code == 403
      raise(ApiServerError) if response.code != 200

      account_info = JSON.parse(response.to_s)['attributes']
      { account: account_info['account']['attributes'],
        auth_token: account_info['auth_token'] }
    rescue HTTP::ConnectionError
      raise ApiServerError
    end
  end
end
