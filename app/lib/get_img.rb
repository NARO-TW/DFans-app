require 'base64'

class GetImg
    def self.get_img(param)
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
        param["image_data"] = encoded

        return param
    end
end
