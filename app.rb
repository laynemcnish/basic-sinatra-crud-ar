require "sinatra"
require "active_record"
require "./lib/database_connection"
require "rack-flash"

class App < Sinatra::Application
  enable :sessions
  use Rack::Flash

  def initialize
    super
    @database_connection = DatabaseConnection.new(ENV["RACK_ENV"])
  end

  get "/" do
    @users = user_setter
    @users = @database_connection.sql("SELECT username from users ORDER BY username ASC").collect { |hash| hash["username"] } if session[:order]
    erb :signed_out, :locals => {:users => @users}
  end

  get '/register' do
    erb :registrations
  end

  get "/sessions" do

  end

  post "/register" do
    if (params[:username] || params[:password]) == ""
      flash[:error] = "Please fill in all fields."
      redirect "/register"
    elsif  @database_connection.sql("SELECT * FROM users WHERE username = '#{params[:username.downcase]}'") != []
      flash[:error] = "Username is already taken."
      redirect "/register"
    end

    @database_connection.sql("INSERT INTO users (username, password) VALUES ('#{params[:username].downcase}', '#{params[:password]}')")
    flash[:notice] = "Thanks for registering!"
    redirect "/"
  end

  post '/sessions' do
    user = find_user(params[:username].downcase, params[:password])[0]
    if user == nil
      flash[:notice] = "Login info incorrect!"
    else
      session[:user] = user
    end
    redirect "/"
  end

  get '/log_out' do

  end

  post '/log_out' do
    session.delete(:user)
    session.delete(:order)
    redirect "/"
  end

  def find_user(username, password)
    @database_connection.sql("SELECT * FROM users WHERE username = '#{username.downcase}' AND password = '#{password}'")
  end

  post '/order' do
    session[:order] = true
    redirect "/"
  end

  def user_setter
    @database_connection.sql("SELECT username from users").collect { |hash| hash["username"] }
  end

end
