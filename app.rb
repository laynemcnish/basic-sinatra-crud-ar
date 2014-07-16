require "sinatra"
require "active_record"
require "rack-flash"
require "gschool_database_connection"
require "./lib/users_table"
require "./lib/fish_table"

class App < Sinatra::Application
  enable :sessions
  use Rack::Flash


  def initialize
    super
    @users_table = UsersTable.new(
      GschoolDatabaseConnection::DatabaseConnection.establish(ENV["RACK_ENV"])
    )
    @fish_table = FishTable.new(
      GschoolDatabaseConnection::DatabaseConnection.establish(ENV["RACK_ENV"])
    )
  end


  get "/" do
    @users = @users_table.user_setter
    @fish = @fish_table.fish_setter

    if session[:order]
      @users = @users_table.alphabetize(session[:order])
    end
    erb :root, :locals => {:users => @users, :fish => @fish}
  end

  get "/register" do
    erb :register
  end


  post "/sessions" do

    user = find_user(params[:username], params[:password])[0]

    if user != nil
      session[:user] = user
      redirect "/"

    elsif params[:username] == "" && params[:password] == ""
      flash[:error] = "Username and password required."
      redirect "/"

    elsif params[:username] == ""
      flash[:error] = "Username required."
      redirect "/"

    elsif params[:password] == ""
      flash[:error] = "Password required."
      redirect "/"

    elsif user == nil
      flash[:error] = "Login Info is incorrect"
      redirect "/"

    end
    session[:user] = user
    redirect "/"


  end

  post "/register" do

    if (params[:username] || params[:password]) == ""
      flash[:error] = "Please fill in all fields."
      redirect "/register"
    elsif  @database_connection.sql("SELECT * FROM users WHERE username = '#{params[:username].downcase}'") != []
      flash[:error] = " Username is already taken."
      redirect "/register"

    end

    flash[:notice] = "Thank you for registering"
    @database_connection.sql("INSERT INTO users (username, password) VALUES ('#{params[:username]}','#{params[:password]}')")
    redirect "/"
  end

  post "/logout" do
    session.delete(:user)
    redirect "/"
  end

  post "/order" do
    session[:order] = params[:alphabetize]
    redirect "/"
  end


  get "/delete/:username" do
    @database_connection.sql("DELETE FROM users WHERE username = '#{params[:username]}'")
    redirect "/"
  end

  post "/add_fish" do
    @fish_table.create_fish(params["fish_name"], params["wikipage"], session[:user]["id"])
    redirect "/"
  end

  get "/wikipedia/:fish_name" do
    @database_connection.sql("SELECT wikipage FROM fish WHERE fish_name = '#{params[:fish_name]}'")
  end


end