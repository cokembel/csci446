#!/usr/bin/env ruby
require 'rack'

class Albums
  
  @albums = Array.new;

  def call(env)
  	request = Rack::Request.new(env)
  	case request.path 
  	when "/display_list" then render_list(request)
  	end

    #[200, {"Content-Type" => "text/plain"}, ["Hello from Rack!"]]
  end

  def render_list(request)
  	response = Rack::Response.new(request.path)
  	response.finish
  end

  def readAlbums
  	albums = File.read('top_100_albums.txt')
  
  end
end

Rack::Handler::WEBrick.run Albums.new, :Port => 8080