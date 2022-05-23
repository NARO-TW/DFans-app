# frozen_string_literal: true

module DFans
  # Behaviors of the currently logged in account
  class Album
    attr_reader :id, :name, :description, # basic info
                :owner, :participants, :photos, :policies # full details

    def initialize(album_info)
      process_attributes(album_info['attributes'])
      process_relationships(album_info['relationships'])
      process_policies(album_info['policies'])
    end

    private

    def process_attributes(attributes)
      @id = attributes['id']
      @name = attributes['name']
      @description = attributes['description']
    end

    def process_relationships(relationships)
      return unless relationships

      @owner = Account.new(relationships['owner'])
      @participants = process_participants(relationships['participants'])
      @photos = process_photos(relationships['photos'])
    end

    def process_policies(policies)
      @policies = OpenStruct.new(policies)
    end

    def process_photos(photos_info)
      return nil unless photos_info

      photos_info.map { |pho_info| Photo.new(pho_info) }
    end

    def process_participants(participants)
      return nil unless participants

      participants.map { |account_info| Account.new(account_info) }
    end
  end
end
