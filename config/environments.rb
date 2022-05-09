# frozen_string_literal: true

require 'roda'
require 'figaro'
require 'logger'

<<<<<<< HEAD
module DFans
=======
module Dfans
>>>>>>> 7593546add82e5c38b46f3d72c2fb5ebfacc280a
  # Configuration for the API
  class App < Roda
    plugin :environments

    # Environment variables setup
    Figaro.application = Figaro::Application.new(
<<<<<<< HEAD
      environment: environment,
      path: File.expand_path('config/secrets.yml')
=======
      environment:true,
      path:File.expand_path('config/secrets.yml')
>>>>>>> 7593546add82e5c38b46f3d72c2fb5ebfacc280a
    )
    Figaro.load
    def self.config
      Figaro.env
    end
    
    # Logger setup
    LOGGER = Logger.new($stderr)
    def self.logger
      LOGGER
    end

    configure :development, :test do
      require 'pry'

      # Allows running reload! in pry to restart entire app
      def self.reload!
        exec 'pry -r ./spec/test_load_all'
      end
    end
  end
end
