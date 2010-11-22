require 'rubygems'
require 'bundler'
Bundler.setup

require 'sinatra'
require 'rack-flash'

set :views, File.join(File.dirname(__FILE__), 'views')

require 'dm-core'
require 'dm-migrations'
require 'dm-validations'
DataMapper.setup(:default, "sqlite3::memory:")

require 'app'
require 'image'
run CatOrNot