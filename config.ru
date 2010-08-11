require 'rubygems'
require 'sinatra.rb'

set :views, File.join(File.dirname(__FILE__), 'views')

require 'app'
run Sinatra::Application