require "sinatra"
require "active_record"
require "./lib/database_connection"
require "rack-flash"

class App < Sinatra::Application
  enable :sessions
  use Rack::Flash

  def initialize
    super
    @database_connection = DatabaseConnection.establish(ENV["RACK_ENV"])
  end

  get "/" do
    @users = user_setter
    @users = @database_connection.sql("SELECT username from users ORDER BY username #{session[:order]}").collect { |hash| hash["username"] } if session[:order]
    @fishlist = fish_getter
    erb :signed_out, :locals => {:users => @users, :fishlist => @fishlist}
  end

  get '/register' do
    erb :registrations
  end

  get "/sessions" do

  end

  get "/see/:fishuser" do
    fishuser = @database_connection.sql("SELECT * FROM users WHERE username = '#{params[:fishuser]}'")
    session[:fishuserid] = (fishuser == [] ? nil : fishuser)
    redirect "/"
  end

  post "/register" do
    if (params[:username] || params[:password]) == ""
      flash[:error] = "Please fill in all fields."
      redirect "/register"
    elsif  @database_connection.sql("SELECT * FROM users WHERE username = '#{params[:username].downcase}'") != []
      flash[:error] = "Username is already taken."
      redirect "/register"
    end

    @database_connection.sql("INSERT INTO users (username, password) VALUES ('#{params[:username].downcase}', '#{params[:password].downcase}')")
    flash[:notice] = "Thanks for registering!"
    redirect "/"
  end

  post '/sessions' do
    user = find_user(params[:username], params[:password])[0]
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
    session.delete(:fishuserid)
    redirect "/"
  end

  post '/order' do
    session[:order] = params[:alphabetize]
    redirect "/"
  end

  post '/delete' do
    @database_connection.sql("DELETE FROM users WHERE username = '#{params[:username_to_delete].downcase}'")
    redirect "/"
  end

  post '/fish' do
    @database_connection.sql("INSERT INTO fish (fishname, fishwiki, user_id) VALUES ('#{params[:fishname]}', '#{params[:fishwiki]}', '#{session[:user]["id"].to_i}')")
    redirect "/"
  end

  def find_user(username, password)
    @database_connection.sql("SELECT * FROM users WHERE username = '#{username.downcase}' AND password = '#{password.downcase}'")
  end

  def user_setter
    @database_connection.sql("SELECT username from users").collect { |hash| hash["username"] }
  end

  def fish_getter
    @database_connection.sql("SELECT * from fish")
  end

  def database_cleaner
    @database_connection.sql("DELETE FROM users WHERE username = 'User'")
  end
end
