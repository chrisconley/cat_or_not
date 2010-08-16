require 'rubygems'
require 'sinatra'

HOUDINI_API_KEY = 'YOUR_API_KEY' # change me
SINATRA_HOST = 'http://your_domain.com' #change me (tunnlr.com is great for testing locally)
HOUDINI_HOST = :sandbox # Work is not completed on sandbox. Use :production if you want responses to be returned

get '/' do
  redirect '/images'
end

get '/images' do
  @images = Image.all
  erb :index
end

get '/images/new' do
  @image = Image.new
  erb :new
end

post '/images' do
  @image = Image.new(params[:image])
  if @image.save
    redirect '/images'
  else
    erb :new
  end
end

post '/images/:id/houdini_postbacks' do
  @image = Image.get(params[:id])
  @image.update(:flagged => params[:flagged])
end

require 'dm-core'
require  'dm-migrations'
DataMapper.setup(:default, "sqlite3::memory:")

class Image
  include DataMapper::Resource
  property :id,        Serial
  property :image_url, Text
  property :flagged,   String
  auto_migrate!

  after :create, :moderate_image

  def moderate_image
    Houdini.perform!({
      :api_key => HOUDINI_API_KEY,
      :identifier => 'Sinatra Image Moderation',
      :price => '0.01',
      :title => "Please moderate the image for Frank Sinatra",
      :form_html => Houdini.render_form(self, 'views/houdini_template.erb'),
      :postback_url => "#{SINATRA_HOST}/images/#{id}/houdini_postbacks"
    })
  end
end

require 'net/http'
require 'uri'

class Houdini
  class ApiKeyError < StandardError; end;

  HOUDINI_URL = HOUDINI_HOST == :production ? 'http://houdinihq.com' : 'http://houdini-sandbox.heroku.com'

  def self.perform!(params)
    url = URI.parse("#{HOUDINI_URL}/api/v0/simple/tasks/")
    response, body = Net::HTTP.post_form(url, params)
    raise(ApiKeyError, "invalid api key") if response.code == '403'
  end

  def self.render_form(object, template)
    template = Tilt.new(template)
    template.render(object, object.class.name.downcase.to_sym => object)
  end
end
