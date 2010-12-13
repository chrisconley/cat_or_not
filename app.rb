require 'rubygems' if RUBY_VERSION < "1.9"
require 'sinatra'

class CatOrNot < Sinatra::Base
  helpers Sinatra::UrlForHelper
  register Sinatra::StaticAssets
  enable :sessions
  use Rack::Flash

  get '/' do
    @images = Image.all(:is_cat => 'yes', :limit => 10, :order => [:id.desc])
    erb :index
  end

  post '/images' do
    @image = Image.new(params[:image])
    if @image.save
      flash[:notice] = "Thanks for submitting an image. It will show up just as soon as it has been reviewed by our staff."
    else
      flash[:notice] = "We're sorry, but there was an error in saving your image. Please try again."
    end
    redirect '/'
  end

  post '/images/:id/houdini_postbacks' do
    puts params.inspect
    @image = Image.get(params[:id])
    @image.update(:is_cat => params[:answer])
  end
end