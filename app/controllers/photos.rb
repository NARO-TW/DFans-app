# frozen_string_literal: true

require 'roda'

module DFans
  # Web controller for DFans API
  class App < Roda
    route('photos') do |routing|
      routing.redirect '/auth/login' unless @current_account.logged_in?

      # GET /photos/[pho_id]
      routing.get(String) do |pho_id|
        pho_info = GetPhoto.new(App.config)
                              .call(@current_account, pho_id)
        photo = Photo.new(pho_info)
        view :photo, locals: {
          current_account: @current_account, photo: photo
          ## photo:
          # filename: string
          # filetype: image/png
          # image_data: base64 encoded string
          # description: string
        }
      end
    end
  end
end
