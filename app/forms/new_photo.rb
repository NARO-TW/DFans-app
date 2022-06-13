# frozen_string_literal: true

require_relative 'form_base'

module DFans
  module Form
    class NewPhoto < Dry::Validation::Contract
      config.messages.load_paths << File.join(__dir__, 'errors/new_photo.yml')

      params do
        required(:filename).filled(max_size?: 256, format?: FILENAME_REGEX)
        required(:image_data).maybe(:string)
        required(:description).maybe(:string)
      end
    end
  end
end
