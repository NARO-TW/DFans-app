# frozen_string_literal: true

require 'http'

module Dfans
  # Returns an authenticated user, or nil
  class VerifyRegistration
    class VerificationError < StandardError; end
    class ApiServerError < StandardError; end

    # def from_email() = ENV['SENDGRID_FROM_EMAIL']
    # def mail_api_key() = ENV['SENDGRID_API_KEY']
    # def mail_url() = 'https://api.sendgrid.com/v3/mail/send'
    # end

    def initialize(config)
      @config = config
    end

    def call(registration_data)
      registration_token = SecureMessage.encrypt(registration_data)
      registration_data['verification_url'] =
        "#{@config.APP_URL}/auth/register/#{registration_token}"

      response = HTTP.post("#{@config.API_URL}/auth/register",
                           json: registration_data)
      raise(VerificationError) unless response.code == 202 # Status 202 suggests the start of a process

      JSON.parse(response.to_s)
    rescue HTTP::ConnectionError
      raise(ApiServerError)
    end
  end
end
