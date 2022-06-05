# frozen_string_literal: true

require 'http'

module DFans
  # Returns all albums belonging to an account
  class GetPhoto
    def initialize(config)
      @config = config
    end

    def call(user, pho_id)
      response = HTTP.auth("Bearer #{user.auth_token}")
                    .get("#{@config.API_URL}/photos/#{pho_id}")

      response.code == 200 ? JSON.parse(response.body.to_s)['data'] : nil
    end
  end
end
