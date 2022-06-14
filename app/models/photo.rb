# frozen_string_literal: true

require_relative 'album'

module DFans
  # Behaviors of the currently logged in account
  class Photo
    attr_reader :id, :filename, :image_data, :description, # basic info
                :album # full details

    def initialize(info)
      process_attributes(info['attributes'])
      process_included(info['include'])
    end

    private

    def process_attributes(attributes)
      @id             = attributes['id']
      @filename       = attributes['filename']
      @image_data     = attributes['image_data']
      @description    = attributes['description']
    end

    def process_included(included)
      @album = Album.new(included['album'])
    end
  end
end
