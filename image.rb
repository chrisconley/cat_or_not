class Image
  include DataMapper::Resource
  property :id,     Serial
  property :url,    Text,   :required => true, :format => :url
  property :is_cat, String
  auto_upgrade!

  after :create, :moderate_image

  def moderate_image
    uri = URI.parse("http://api.houdiniapi.com/v0/image_moderation/tasks/")
    response, body = Net::HTTP.post_form(uri, {
      :api_key => ::HOUDINI_API_KEY,
      :image_url => self.url,
      :postback_url => "#{::APP_HOST}images/#{self.id}/houdini_postbacks",
      :instructions => "Does this picture contain any cats?",
      :possible_answers => "{'yes':'Yes', 'no':'No'}"
    })
    puts response.code
    puts body
  end
end