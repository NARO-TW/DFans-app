# frozen_string_literal: true

require_relative 'album'

module DFans
  # Behaviors of the currently logged in account
  class Albums
    attr_reader :all

    def initialize(albums_list)
      @all = albums_list.map do |alb|
        Album.new(alb)
      end
    end
  end
end
