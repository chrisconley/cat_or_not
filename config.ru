require 'rubygems'
require 'bundler'
Bundler.setup

require 'sinatra'

set :views, File.join(File.dirname(__FILE__), 'views')

require 'app'
run Sinatra::Application