class UsersTable
  def initialize(database_connection)
    @database_connection = database_connection
  end

  def create(username, password)
    insert_user_sql = <<-SQL
      INSERT INTO users (username, password)
      VALUES ('#{username}', '#{password}')
      RETURNING id
    SQL

    @database_connection.sql(insert_user_sql).first["id"]
  end

  def alphabetize(order)
    alphabetize = <<-SQL
      SELECT username FROM users ORDER BY username #{session[order]}
    SQL

  @database_connection.sql(alphabetize).collect { |hash| hash["username"] }
  end

  def find_user(username, password)
    find_user = <<-SQL
    SELECT *
    FROM users
    WHERE username = '#{username.downcase}' AND password = '#{password.downcase}'

    SQL

    @database_connection.sql(find_user).first
  end

  def user_setter
    user_setter = <<-SQL
    SELECT username FROM users
    SQL
    @database_connection.sql(user_setter).collect { |hash| hash["username"] }
  end

  def delete_user(username)
    delete_user = <<-SQL
    DELETE FROM users WHERE username = '#{username}'
    SQL
    @database_connection.sql(delete_user).first
  end

  #
  #
  # def find(id)
  #   find_sql = <<-SQL
  #     SELECT * FROM users
  #     WHERE id = #{id}
  #   SQL
  #
  #   @database_connection.sql(find_sql).first
  # end
  #
  def find_by(username, password)
    find_by_sql = <<-SQL
      SELECT * FROM users
      WHERE username = '#{username}'
      AND password = '#{password}'
    SQL

    @database_connection.sql(find_by_sql).first
  end

  def find_username(username)
    find_username_sql = <<-SQL
      SELECT * FROM users
      WHERE username = '#{username}'
    SQL

    @database_connection.sql(find_username_sql).first
  end


end
