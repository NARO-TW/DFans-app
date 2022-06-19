# frozen_string_literal: true

require 'roda'
require 'base64'
require 'rbnacl'

module DFans
  # Web controller for DFans API
  class App < Roda
    route('photos') do |routing|
      routing.redirect '/auth/login' unless @current_account.logged_in?

      routing.on(String) do |pho_id|
        # GET /photos/[pho_id]
        routing.get do
          pho_info = GetPhoto.new(App.config).call(@current_account, pho_id)
          photo = Photo.new(pho_info)
          view :photo, locals: {
            current_account: @current_account, photo:
            ## photo:
            # filename: string
            # filetype: image/png
            # image_data: base64 encoded string
            # description: string
            # enc_type: true/false
          }
        end

        # POST /photos/[pho_id]/decrypt
        routing.post('decrypt') do
          encrypted_pho_info = GetPhoto.new(App.config).call(@current_account, pho_id)

          begin
            result = DecryptionHelper.decrypt(encrypted_pho_info['attributes']['image_data'], routing.params['dec_key'])
            encrypted_pho_info['attributes']['image_data'] = result
            encrypted_pho_info['attributes']['enc_type='] = 'false'
          rescue EncodingError => e
            puts "ERROR DECRYPTING PHOTO: #{e.inspect}"
            flash[:error] = 'Could not decrypt photo, perhaps wrong key format'
            routing.redirect "/photos/#{pho_id}"
          rescue RbNaCl::CryptoError => e
            puts "ERROR DECRYPTING PHOTO: #{e.inspect}"
            flash[:error] = 'Wrong Decryption Key'
            routing.redirect "/photos/#{pho_id}"
          rescue StandardError => e
            puts "ERROR DECRYPTING PHOTO: #{e.inspect}"
            flash[:error] = 'Could not decrypt photo, Somethinig Wrong'
            routing.redirect "/photos/#{pho_id}"
          end

          decrypted_photo = Photo.new(encrypted_pho_info)

          view :photo_decrypted, locals: {
            current_account: @current_account, photo: decrypted_photo
          }
        end
      end
    end
  end

  # Decryption Helper for photos
  class DecryptionHelper
    def self.decrypt(base64_plaintext, base64_key)
      return nil unless base64_plaintext

      key = Base64.strict_decode64(base64_key)
      ciphertext = Base64.urlsafe_decode64(base64_plaintext)

      simple_box = RbNaCl::SimpleBox.from_secret_key(key)
      simple_box.decrypt(ciphertext)
    end
  end
end
