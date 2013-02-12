#!/usr/bin/env ruby
require 'rack'
require 'erb'
require 'sqlite3'

class Albums
  
  @album_hash 

  def initialize
    @album_hash = Hash.new
  	values = IO.readlines('top_100_albums.txt')

  	values.each { |line| line.chomp }

  	values.each { |line| line = line.split(",")
      @album_hash[line.at(0)] = line.at(1)
  	}

  end

  def call(env)
  	request = Rack::Request.new(env)


  	case request.path
  	when "/form" then render_form(request)
  	when "/display_list" then render_list(request)
  	end
  	
  end

  def render_form(request)
  	response = Rack::Response.new

    lines = IO.readlines('albumForm.html')

    lines.each do |line|
      if line.include? "<<option>>"
        puts "HERE"
        (1..100).each do |i| 
          response.write("<option value=\"#{i}\">#{i}</option>")
        end
      else
        response.write(line)
      end
    end

=begin
  	File.open("albumForm.html", "rb") { |form| 
      if ( form.include? "")
      response.write(form.read)


    }
=end
  	response.finish
  end

  def render_list(request)

=begin
  	response = Rack::Response.new

  	File.open("sortedList.html", "rb") { |form| response.write(form.read)}

  	get_values = request.GET()

  	sort = get_values['sortBy']
  	rank = get_values['rank']

  	response.write("<h3>Sorted By #{sort}</h3>");

    response.write("<table>")

  	sorted_values = sortAlbums(sort,rank)

    count = 1;
    sorted_values.each do |album_name, year|
      if count == rank.to_i
        response.write("<tr style=\"background-color:yellow\"><td>#{count}</td><td>#{album_name}</td><td>#{year}</td></tr>")
      else 
        response.write("<tr><td>#{count}</td><td>#{album_name}</td><td>#{year}</td></tr>")
      end

      count += 1
    end
=end
    database = SQLite3::Database.new("albus.sqlite3")

    database.execute("SELECT * FROM albums") do |album|
      response.write("<tr><td>#{count}</td><td>#{album}</td><td>#{year}</td></tr>")
    end

  	response.write("</table>")
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