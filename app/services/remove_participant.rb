# frozen_string_literal: true

module DFans
  # Service to add participant to album
  class RemoveParticipant
    class ParticipantNotRemoved < StandardError; end

    def initialize(config)
      @config = config
    end

    def api_url
      @config.API_URL
    end

    def call(current_account:, participant:, album_id:)
      response = HTTP.auth("Bearer #{current_account.auth_token}")
                     .delete("#{api_url}/albums/#{album_id}/participants",
                             json: { email: participant[:email] })

      raise ParticipantNotRemoved unless response.code == 200
    end
  end
end
