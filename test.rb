require 'app'
require 'test/unit'
require 'mocha'
require 'rack/test'

ENV['RACK_ENV'] = 'test'

class AppTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def create_image(params)
    image = Image.new(params)
    image.expects(:moderate_image)
    image.save
  end

  def test_root_redirects_to_images
    get "/"
    follow_redirect!

    assert_match /\/images$/, last_request.url
    assert last_response.ok?
  end

  def test_list_of_images
    create_image(:url => 'http://example.com/image.jpg', :flagged => "yes")
    get '/images'
    assert last_response.body.include?('Create New Image')
    assert last_response.body.include?('http://example.com/image.jpg')
    assert last_response.body.include?('yes')
  end

  def test_new_image
    get '/images/new'
    assert last_response.body.include?('New Image')
  end

  def test_create_image
    Houdini.stubs(:perform!)
    post '/images', :image => {:url => 'http://example.com/image.jpg'}
    assert_equal 1, Image.count
    assert_equal Image.first.url, 'http://example.com/image.jpg'
  end

  def test_houdini_postback
    create_image(:url => 'http://example.com/image.jpg', :flagged => nil)
    post '/images/1/houdini_postbacks', :flagged => 'yes'
    assert_equal 'yes', Image.first.flagged
  end
end