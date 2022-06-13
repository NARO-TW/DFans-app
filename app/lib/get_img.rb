require 'base64'

class GetImg
    def self.get_img(param)
        tempfile = param["file"][:tempfile]

        # Open the file you wish to encode
        data = File.open(tempfile.path).read

        # Encode the puppy
        encoded = Base64.encode64(data)
        param["file"][:file] = encoded

        param["file"].delete(:tempfile)

        tempfile.close
        tempfile.unlink  # deletes the temp file

        return param
    end
end
