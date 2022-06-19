# frozen_string_literal: true

require_relative 'form_base'

module DFans
  module Form
    # NewPhoto
    class NewPhoto < Dry::Validation::Contract
      config.messages.load_paths << File.join(__dir__, 'errors/new_photo.yml')

      params do
        required(:filename).filled(max_size?: 256, format?: FILENAME_REGEX)
        required(:description).maybe(:string)
        required(:image_data).filled(:string)
        required(:filetype).filled(:string)
        required(:enc_type).filled(:bool)
      end
    end
  end
end
