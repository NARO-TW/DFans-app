# frozen_string_literal: true

module DFans
  # Behaviors of the currently logged in account
  class Album
    attr_reader :id, :name, :description
  
    def initialize(alb_info)
      @id = alb_info['attributes']['id']
      @name = alb_info['attributes']['name']
      @description = alb_info['attributes']['description']
    end
  end
end

