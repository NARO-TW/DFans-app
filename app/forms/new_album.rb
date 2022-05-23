# frozen_string_literal: true

require_relative 'form_base'

module DFans
  module Form
    class NewAlbum < Dry::Validation::Contract
      config.messages.load_paths << File.join(__dir__, 'errors/new_album.yml')

      params do
        required(:name).filled
        required(:description).maybe(:string)
      end
    end
  end
end
