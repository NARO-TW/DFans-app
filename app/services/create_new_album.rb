# frozen_string_literal: true

require 'http'

module DFans
  # Create a new configuration file for a album
  class CreateNewAlbum
    def initialize(config)
      @config = config
    end

    def api_url
      @config.API_URL
    end

    def call(current_account:, album_data:)
      config_url = "#{api_url}/albums"
      response = HTTP.auth("Bearer #{current_account.auth_token}")
                     .post(config_url, json: album_data)

      response.code == 201 ? JSON.parse(response.body.to_s) : raise
    end
  end
end
