require 'rubygems'
require 'bundler'
Bundler.setup

require 'sinatra'
require 'sinatra/static_assets'
require 'rack-flash'

set :views, File.join(File.dirname(__FILE__), 'views')

require 'dm-core'
require 'dm-migrations'
require 'dm-validations'
DataMapper.setup(:default, {
  :adapter  => 'sqlite3',
  :host     => 'localhost',
  :username => '',
  :password => '',
  :database => 'db/cat_or_not'
})

require 'net/http'
require 'uri'

::HOUDINI_API_KEY = 'Changeme'
::APP_HOST = "Changeme"
require 'app'
require 'image'

use Rack::Static, :urls => ["/stylesheets"], :root => "public"

run CatOrNot