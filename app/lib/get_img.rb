require 'base64'

class GetImg
    def self.get_img(param)
        tempfile = param["image_data"][:tempfile]

        # Open the file you wish to encode
        data = File.open(tempfile.path).read

        # Encode the puppy
        encoded = Base64.encode64(data)
        param["image_data"][:file] = encoded

        param["image_data"].delete(:tempfile)

        param["image_data"] = encoded

        tempfile.close
        tempfile.unlink  # deletes the temp file

        return param
    end
end
