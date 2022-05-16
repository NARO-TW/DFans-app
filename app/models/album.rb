# frozen_string_literal: true

module Dfans
  # Behaviors of the currently logged in account
  class Album
    attr_reader :id, :name, :repo_url
  
    def initialize(alb_info)
      @id = alb_info['attributes']['id']
      @name = alb_info['attributes']['name']
      @repo_url = alb_info['attributes']['repo_url']
    end
  end
end

