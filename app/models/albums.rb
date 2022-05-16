# frozen_string_literal: true

require_relative 'album'

module Dfans
  # Behaviors of the currently logged in account
  class Albums
    attr_reader :all

    def initialize(albums_list)
      @all = albums_list.map do |alb|
        Album.new(proj)
      end
    end
  end
end
