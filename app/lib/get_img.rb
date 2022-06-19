# frozen_string_literal: true

require 'base64'
require 'rbnacl'

# Prcoess the image
class ProcessImg
  def self.process(param)
    param['filetype'] = param['image_data'][:type]
    param['enc_type'] = !param['enc_key'].empty?
    readfile(param)
    param
  end

  def self.readfile(param)
    tempfile = param['image_data'][:tempfile]

    # Open the file you wish to encode
    data = File.read(tempfile.path)

    # Encode the puppy
    encoded = Base64.strict_encode64(data)
    param['image_data'].delete(:tempfile)
    tempfile.close
    tempfile.unlink  # deletes the temp file
    param['image_data'] = param['enc_key'].empty? ? encoded : encrypt(encoded, param['enc_key'])
  end

  def self.encrypt(plaintext, base64_key)
    return nil unless plaintext

    key = Base64.strict_decode64(base64_key)

    simple_box = RbNaCl::SimpleBox.from_secret_key(key)
    ciphertext = simple_box.encrypt(plaintext)

    Base64.urlsafe_encode64(ciphertext)
  end
end
