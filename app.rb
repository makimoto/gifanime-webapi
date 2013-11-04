require "sinatra/base"
require "RMagick"
require "haml"

class GifAnime < Sinatra::Base
  get "/" do
    haml :index
  end

  post "/" do
    begin
      files = params[:files].map {|file| file[:tempfile] }
    rescue
      halt 401, "401: invalid parameters, maybe\n"
    end

    begin
      image = Magick::ImageList.new(*files.map(&:path))
    rescue
      halt 405, "405: invalid image files, maybe\n"
    end
    content_type "image/gif"
    tempfile = Pathname.new(Tempfile.new(["", ".gif"]))
    image.write(tempfile)
    tempfile.read
  end
end
