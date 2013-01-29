#!/usr/bin/env ruby
require 'rack'

class Albums
  
  def call(env)
  	request = Rack::Request.new(env)


  	case request.path
  	when "/form" then render_form(request)
  	when "/display_list" then render_list(request)
  	end
  	

  #[200, {"Content-Type" => "text/plain"}, ["Hello from Rack!"]]
  end

  def render_form(request)
  	  	response = Rack::Response.new
  	File.open("albumForm.html", "rb") { |form| response.write(form.read)}
  	response.finish
  end

  def render_list(request)
  	response = Rack::Response.new(request.path)
  	response.finish
  end

  

end

Rack::Handler::WEBrick.run Albums.new, :Port => 8080