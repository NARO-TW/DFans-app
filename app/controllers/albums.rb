# frozen_string_literal: true

require 'roda'

module DFans
  # Web controller for DFans API
  class App < Roda
    route('albums') do |routing|
      routing.on do
        routing.redirect '/auth/login' unless @current_account.logged_in?
        @albums_route = '/albums'

        routing.on(String) do |album_id|
          @album_route = "#{@albums_route}/#{album_id}"

          # GET /albums/[album_id]
          routing.get do
            album_info = GetAlbum.new(App.config).call(
              @current_account, album_id
            )
            album = Album.new(album_info)
            view :album, locals: {
              current_account: @current_account, album: album
            }
          rescue StandardError => e
            puts "#{e.inspect}\n#{e.backtrace}"
            flash[:error] = 'Album not found'
            routing.redirect @albums_route
          end

          # POST /albums/[album_id]/participants
          routing.post('participants') do
            action = routing.params['action']
            participant_info = Form::ParticipantEmail.new.call(routing.params)
            if participant_info.failure?
              flash[:error] = Form.validation_errors(participant_info)
              routing.halt
            end

            task_list = {
              'add' => { service: AddParticipant,
                         message: 'Added new participant to album' },
              'remove' => { service: RemoveParticipant,
                            message: 'Removed participant from album' }
            }

            task = task_list[action]
            task[:service].new(App.config).call(
              current_account: @current_account,
              participant: participant_info,
              album_id: album_id
            )
            flash[:notice] = task[:message]

          rescue StandardError
            flash[:error] = 'Could not find participant'
          ensure
            routing.redirect @album_route
          end

          # POST /albums/[album_id]/photos/
          routing.post('photos') do
            result = GetImg.get_img(routing.params)
            photo_data = Form::NewPhoto.new.call(result)
            if photo_data.failure?
              flash[:error] = Form.message_values(photo_data)
              routing.halt
            end
            
            CreateNewPhoto.new(App.config).call(
              current_account: @current_account,
              album_id: album_id,
              photo_data: photo_data.to_h
            )

            flash[:notice] = 'Your photo was added'
          rescue StandardError => e
            puts "ERROR CREATING PHOTO: #{e.inspect}"
            flash[:error] = 'Could not add photo'
          ensure
            routing.redirect @album_route
          end
        end

        # GET /albums/
        routing.get do
          album_list = GetAllAlbums.new(App.config).call(@current_account)

          albums = Albums.new(album_list)

          view :albums_all, locals: {
            current_account: @current_account, albums: albums
          }
        end

        # POST /albums/
        routing.post do
          routing.redirect '/auth/login' unless @current_account.logged_in?
          album_data = Form::NewAlbum.new.call(routing.params)
          if album_data.failure?
            flash[:error] = Form.message_values(album_data)
            routing.halt
          end

          CreateNewAlbum.new(App.config).call(
            current_account: @current_account,
            album_data: album_data.to_h
          )

          flash[:notice] = 'Add photos and participants to your new album'
        rescue StandardError => e
          puts "FAILURE Creating Album: #{e.inspect}"
          flash[:error] = 'Could not create album'
        ensure
          routing.redirect @albums_route
        end
      end
    end
  end
end
