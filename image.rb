require 'net/http'
require 'uri'

class Image
  include DataMapper::Resource
  property :id,        Serial
  property :url,       Text,   :required => true, :format => :url
  property :flagged,   String
  auto_migrate!

  after :create, :moderate_image

  def moderate_image
    uri = URI.parse("http://houdiniapi.com/image_moderation/tasks/")
    response, body = Net::HTTP.post_form(uri, {
      :api_key => 'YOUR_API_KEY',
      :image_url => self.url,
      :postback_url => "http://tunnlr.com:9901/images/#{self.id}/houdini_postbacks"
    })
  end
end