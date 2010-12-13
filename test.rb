require 'test/unit'
require 'mocha'
require 'rack/test'

ENV['RACK_ENV'] = 'test'

class AppTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    eval "Rack::Builder.new {( " + File.read(File.dirname(__FILE__) + '/config.ru') + "\n )}"
  end

  def create_image(params)
    @image = ::Image.new(params)
    @image.expects(:moderate_image)
    @image.save
  end

  def test_home_page
    create_image(:url => 'http://example.com/image.jpg', :is_cat => "yes")
    get '/'
    assert last_response.body.include?('Submit the url of your favorite lolcat')
    assert last_response.body.include?('http://example.com/image.jpg')
  ensure
    ::Image.destroy
  end

  def test_create_image
    Net::HTTP.stubs(:post_form)
    post '/images', :image => {:url => 'http://example.com/image.jpg'}
    assert_equal 1, ::Image.count
    assert_equal ::Image.first.url, 'http://example.com/image.jpg'
  ensure
    ::Image.destroy
  end

  def test_houdini_postback
    create_image(:url => 'http://example.com/image.jpg', :is_cat => nil)
    post "/images/#{@image.id}/houdini_postbacks", :answer => 'yes'
    assert_equal 'yes', ::Image.first.is_cat
  ensure
    ::Image.destroy
  end
end