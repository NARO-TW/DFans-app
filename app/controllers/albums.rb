# frozen_string_literal: true

require 'roda'

module DFans
  # Web controller for DFans API
  class App < Roda
    route('albums') do |routing|
      routing.on do
        # GET /albums/
        routing.get do
          if @current_account.logged_in?
            album_list = GetAllAlbums.new(App.config).call(@current_account)

            albums = Albums.new(album_list)

            view :albums_all,
                 locals: { current_user: @current_account, albums: albums}
          else
            routing.redirect '/auth/login'
          end
        end
      end
    end
  end
end
