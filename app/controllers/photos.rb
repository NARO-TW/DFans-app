# frozen_string_literal: true

require 'roda'

module DFans
  # Web controller for Credence API
  class App < Roda
    route('photos') do |routing|
      routing.redirect '/auth/login' unless @current_account.logged_in?

      # GET /photos/[doc_id]
      routing.get(String) do |doc_id|
        doc_info = GetPhoto.new(App.config)
                              .call(@current_account, doc_id)
        photo = Photo.new(doc_info)

        view :photo, locals: {
          current_account: @current_account, photo: photo
        }
      end
    end
  end
end
