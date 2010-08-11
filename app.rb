require 'rubygems'
require 'sinatra'

require 'dm-core'
require 'houdini'

DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{File.dirname(__FILE__)}/development.db")

get '/images' do
  @images = Image.all
  haml :index
end

get '/images/new' do
  @image = Image.new
  haml :new
end

post '/images' do
  @image => Post.new(params[:image])
  if @image.save
    redirect_to '/images'
  else
    haml :new
  end
end

post '/images/:id/houdini_postbacks' do
  @image = Image.find(params[:id])
  @image.flagged = params[:houdini_postback][:flagged]
  @image.save!
end

class Image
  include DataMapper::Resource
  property :id,           Integer, :serial=>true
  property :image_url,    Text
  property :flagged,       String

  after :create, :moderate_image

  def moderate_image
    Houdini.send_to_houdini(
    :api_key => Houdini::KEY,
    :price => '0.01',
    :title => "Please moderate the image for Frank Sinatra",
    :form_template => 'view/houdini_templates/image.html.erb',
    :postback_url => "http://houdini-sinatra-example.com/images/#{id}/houdini_postbacks")
  end
end