require "sinatra"
require "active_record"
require "./lib/database_connection"

class App < Sinatra::Application
  def initialize
    super
    @database_connection = DatabaseConnection.new(ENV["RACK_ENV"])
  end

  get "/" do

    erb :signed_out
    end


end