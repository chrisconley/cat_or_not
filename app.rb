require 'rubygems'
require 'sinatra'

get '/images' do
  @images = Image.all
  haml :index
end

get '/images/new' do
  @image = Image.new
  haml :new
end

post '/images' do
  @image = Image.new(params[:image])
  if @image.save
    redirect '/images'
  else
    haml :new
  end
end

post '/images/:id/houdini_postbacks' do
  @image = Image.find(params[:id])
  @image.flagged = params[:houdini_postback][:flagged]
  @image.save!
end

require 'dm-core'
require  'dm-migrations'
DataMapper.setup(:default, "sqlite3::memory:")

class Image
  include DataMapper::Resource
  property :id,           Serial
  property :image_url,    Text
  property :flagged,       String
  auto_migrate!

  #after :create, :moderate_image

  def moderate_image
    Houdini.send_to_houdini({
      :api_key => 'YOUR_API_KEY',
      :price => '0.01',
      :title => "Please moderate the image for Frank Sinatra",
      :form_html => Houdini.render_form(self, 'view/houdini_templates/image.html.erb'),
      :postback_url => "http://houdini-sinatra-example.com/images/#{id}/houdini_postbacks"
    })
  end
end

require 'net/http'
require 'uri'

class Houdini
  def self.send_to_houdini(params)
    url = URI.parse("http://houdinihq.com/api/v0/simple/tasks/")
    response, body = Net::HTTP.post_form(url, params)
  end

  def self.render_form(object, template)
    # ...
  end
end