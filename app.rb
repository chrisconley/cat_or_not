class CatOrNot < Sinatra::Base
  helpers Sinatra::UrlForHelper
  register Sinatra::StaticAssets
  enable :sessions
  use Rack::Flash

  get '/' do
    @images = Image.all(:limit => 10, :order => [:id.desc])
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
    @image = Image.get(params[:id])
    @image.update(:flagged => params[:flagged])
  end
end