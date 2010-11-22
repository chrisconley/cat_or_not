require 'dm-core'
require  'dm-migrations'
require 'net/http'
require 'uri'
DataMapper.setup(:default, "sqlite3::memory:")

HOUDINI_API_KEY = 'YOUR_API_KEY'

class Image
  include DataMapper::Resource
  property :id,        Serial
  property :url, Text
  property :flagged,   String
  auto_migrate!

  after :create, :moderate_image

  def moderate_image
    template = Tilt.new('views/houdini_template.erb')
    form_html = template.render(self, :image => self)

    uri = URI.parse("http://v0.houdiniapi.com/simple/tasks/")
    response, body = Net::HTTP.post_form(uri, {
      :api_key => HOUDINI_API_KEY,
      :identifier => 'Sinatra Image Moderation',
      :price => '0.01',
      :title => "Please moderate the image for Frank Sinatra",
      :form_html => form_html,
      :postback_url => "http://tunnlr.com:9901/images/#{self.id}/houdini_postbacks"
    })
  end
end