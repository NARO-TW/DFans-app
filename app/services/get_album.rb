# frozen_string_literal: true

require 'http'

module DFans
  # Returns all albums belonging to an account
  class GetAlbum
    def initialize(config)
      @config = config
    end

    def call(current_account, album_id)
      response = HTTP.auth("Bearer #{current_account.auth_token}")
                     .get("#{@config.API_URL}/albums/#{album_id}")

      response.code == 200 ? JSON.parse(response.body.to_s)['data'] : nil
    end
  end
end
