#!/usr/bin/env ruby
require 'rack'
require 'erb'
require 'sqlite3'

class Albums

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

    get_values = request.GET()

    sort = get_values['sortBy']
    rank = get_values['rank']

    database = SQLite3::Database.new("albums.sqlite3.db")
    database.results_as_hash = true
    albums = database.execute("SELECT * FROM albums ORDER BY #{sort}")

    response = Rack::Response.new(ERB.new(File.read("sortedList.html.erb")).result(binding))
  	response.finish
  end

end

Rack::Handler::WEBrick.run Albums.new, :Port => 8080