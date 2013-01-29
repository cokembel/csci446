#!/usr/bin/env ruby
require 'rack'

class Albums
  
  @values 

  def initialize
  	@values = IO.readlines('top_100_albums.txt')

  	@values.each { |line| line.chomp

  	 }
  	@values.each { |line| line.split(",",2)
  		puts line[0]
  	}

  end

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
  	 response = Rack::Response.new
  	File.open("sortedList.html", "rb") { |form| response.write(form.read)}

  	get_values = request.GET()

  	sort = get_values['sortBy']
  	rank = get_values['rank']

  	response.write("<h3>Sorted By #{sort}</h3>");

    response.write("<ol>")

  	#sorted_values = sortAlbums(sort,rank)

 	@values.each { |x| 
  		response.write("<li> #{x.values[0]}   #{x.values[1]} </li>")
  	}

  	response.write("</ol>")
  	response.write("</body></html>")
  	response.finish
  end
=begin
  def sortAlbums(sort,rank)

  	case sort
  	when "rank" then return @values
  	when "name" then return @values#.sort { |x,y| x[0] < y[0]}
  	when "year" then return @values#.sort { |x,y| x[1] < y[1]}
  	end 
   end
=end
  
	  	
end

Rack::Handler::WEBrick.run Albums.new, :Port => 8080