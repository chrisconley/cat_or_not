require 'rubygems'
require 'sinatra'
require 'rack-flash'
require 'image'

class CatOrNot < Sinatra::Base
  enable :sessions
  use Rack::Flash

  get '/' do
    @images = Image.all
    erb :index
  end

  post '/images' do
    @image = Image.new(params[:image])
    if @image.save
      flash[:success] = "Thanks for submitting an image. It will show up just as soon as it has been reviewed by our staff."
    else
      flash[:error] = "We're sorry, but there was an error in saving your image. Please try again."
    end
    redirect '/'
  end

  post '/images/:id/houdini_postbacks' do
    @image = Image.get(params[:id])
    @image.update(:flagged => params[:flagged])
  end

end