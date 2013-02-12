require 'sinatra'
require 'data_mapper'
require_relative 'album'

DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/albums.sqlite3.db")

set :port, 8080

get '/form' do
	erb :albumForm
end

post '/display_list' do
	@sort_by = params[:sortBy]
	@rank = params[:rank]
	@albums = Album.all(:order => @sort_by.intern.asc)
	erb :sortedList
end



