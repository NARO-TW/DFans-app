require 'base64'

class GetImg
    def self.get_img(param)
        tempfile = param["image_data"][:tempfile]

        # Open the file you wish to encode
        data = File.open(tempfile.path).read

        # Encode the puppy
        encoded = Base64.strict_encode64(data)
        param["image_data"] = encoded

        get_type(param)

        param["file"].delete(:tempfile)
        tempfile.close
        tempfile.unlink  # deletes the temp file

        return param
    end

    def self.get_type(param)
        param["filetype"] = param["file"][:type]
    end
end
