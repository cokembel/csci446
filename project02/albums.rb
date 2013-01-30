#!/usr/bin/env ruby
require 'rack'

class Albums
  
  @album_hash 

  def initialize
    @album_hash = Hash.new
  	values = IO.readlines('top_100_albums.txt')

  	values.each { |line| line.chomp }

  	values.each { |line| line = line.split(",")
  		puts line.at(0)  + line.at(1)
      @album_hash[line.at(0)] = line.at(1)
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

  	sorted_values = sortAlbums(sort,rank)

    sorted_values.each { |album_name, year| 
      response.write("<li>" + album_name + year + "</li>")
    }
=begin
 	@values.each { |x| 
  		response.write("<li>" + x.at(0) + x.at(1) + "</li>")
  	}
=end
  	response.write("</ol>")
  	response.write("</body></html>")
  	response.finish
  end

  def sortAlbums(sort,rank)

  	case sort
  	when "rank" then return @album_hash
  	when "name" then return @album_hash.sort_by { |x,y| x}
  	when "year" then return @album_hash.sort_by { |x,y| y}
  	end 
   end

  
	  	
end

Rack::Handler::WEBrick.run Albums.new, :Port => 8080