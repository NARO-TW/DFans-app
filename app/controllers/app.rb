# frozen_string_literal: true

require 'roda'
require 'slim'

module DFans
  # Base class for DFans Web Application
  class App < Roda
    plugin :render, engine: 'slim', views: 'app/presentation/views'
    plugin :assets, css: 'style.css', path: 'app/presentation/assets'
    plugin :public, root: 'app/presentation/public'
    plugin :multi_route
    plugin :flash

    route do |routing|
      response['Content-Type'] = 'text/html; charset=utf-8'
      #@current_account = SecureSession.new(session).get(:current_account)
      @current_account = CurrentSession.new(session).current_account

      # inject routes for public files and assets
      routing.public
      routing.assets
      routing.multi_route

      # GET /
      routing.root do
        view 'home', locals: { current_account: @current_account }
      end
    end
  end
end
