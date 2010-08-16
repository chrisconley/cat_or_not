require 'app'
require 'test/unit'
require 'rack/test'

ENV['RACK_ENV'] = 'test'

class AppTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def test_it_returns_root
    get '/images'
    puts last_response.body.inspect
    assert last_response.ok?
  end
end