require 'sinatra'
require 'data_mapper'
require_relative 'album'

DataMapper.setup(:default, "sqlite://{Dir.pwd}/albums.sqlite3.db")

set :port, 8080

get "/form" do 
	"Sinatra is working"
end