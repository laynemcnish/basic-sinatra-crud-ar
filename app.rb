require "sinatra"
require "active_record"
require "rack-flash"
require "gschool_database_connection"

class App < Sinatra::Application
  enable :sessions
  use Rack::Flash


  def initialize
    super

    @database_connection = GschoolDatabaseConnection::DatabaseConnection.establish(ENV["RACK_ENV"])
  end


  get "/" do
    @users = user_setter
    @fish = fish_setter

    @users = @database_connection.sql("SELECT username FROM users ORDER BY username #{session[:order]}").collect {|hash| hash["username"]} if session[:order]
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
    user = @database_connection.sql("select * from users where username = '#{params[:username]}' and password = '#{params[:password]}'").first
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
    @database_connection.sql("INSERT INTO fish (fish_name, wikipage, user_id) VALUES ('#{params[:fish_name]}','#{params[:wikipage]}', '#{session[:user]["id"].to_i}')")
    redirect "/"
  end

  private

  def find_user(username, password)
    @database_connection.sql("SELECT * FROM users WHERE username = '#{username.downcase}' AND password = '#{password.downcase}'")
  end

  def user_setter
    @database_connection.sql("SELECT username FROM users").collect { |hash| hash["username"] }
  end

  def fish_setter
    @database_connection.sql("SELECT * FROM fish")
  end

  def delete_user
    @database_connection.sql("DELETE FROM users WHERE username = '#{}'")
  end

end
