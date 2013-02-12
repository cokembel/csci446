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
  	response = Rack::Response.new(ERB.new(File.read("albumForm.html.erb")).result(binding))
  	response.finish
  end

  def render_list(request)

  	response = Rack::Response.new

  	File.open("sortedList.html", "rb") { |form| response.write(form.read)}

  	get_values = request.GET()

  	sort = get_values['sortBy']
  	rank = get_values['rank']

  	response.write("<h3>Sorted By #{sort}</h3>");

    response.write("<table>")

    database = SQLite3::Database.new("albums.sqlite3.db")
    database.results_as_hash = true

    database.execute("SELECT * FROM albums ORDER BY #{sort}") do |album|
      if album['rank'].to_i == rank.to_i

        response.write("<tr style=\"background-color:yellow\"><td>#{album[0]}</td><td>#{album[1]}</td><td>#{album[2]}</td></tr>")
      else
        response.write("<tr><td>#{album['rank']}</td><td>#{album['title']}</td><td>#{album['year']}</td></tr>")
      end
    end

  	response.write("</table>")
  	response.write("</body></html>")
  	response.finish
  end

end

Rack::Handler::WEBrick.run Albums.new, :Port => 8080