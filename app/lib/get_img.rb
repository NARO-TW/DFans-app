require 'base64'
require 'rbnacl'

# Prcoess the image
class ProcessImg
    def self.process(param)
        tempfile = param["image_data"][:tempfile]
        filetype = param["image_data"][:type]

        # Open the file you wish to encode
        data = File.open(tempfile.path).read
        # Encode the puppy
        encoded = Base64.strict_encode64(data)

        param["image_data"].delete(:tempfile)
        tempfile.close
        tempfile.unlink  # deletes the temp file

        param["filetype"] = filetype
        param["enc_type"] = param["enc_key"].empty? ? false : true
        param["image_data"] = param["enc_key"].empty? ? encoded : encrypt(encoded, param["enc_key"])
        
        return param
    end

    def self.encrypt(plaintext, base64_key)
        return nil unless plaintext

        key = Base64.strict_decode64(base64_key)

        simple_box = RbNaCl::SimpleBox.from_secret_key(key)
        ciphertext = simple_box.encrypt(plaintext)

        Base64.urlsafe_encode64(ciphertext)
    end
end
