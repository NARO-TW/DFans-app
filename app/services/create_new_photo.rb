# frozen_string_literal: true

require 'http'

module DFans
  # Create a new configuration file for a album
  class CreateNewPhoto
    def initialize(config)
      @config = config
    end

    def api_url
      @config.API_URL
    end

    def call(current_account:, album_id:, photo_data:)
      config_url = "#{api_url}/albums/#{album_id}/photos"
      response = HTTP.auth("Bearer #{current_account.auth_token}")
                     .post(config_url, json: photo_data)

      response.code == 201 ? JSON.parse(response.body.to_s) : raise
    end
  end
end
