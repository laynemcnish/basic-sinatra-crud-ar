class FavoriteFishTable
  def initialize(database_connection)
    @database_connection = database_connection
  end

  def add_favorite(user_id, fish_id)
    insert_fish_sql = <<-SQL
      INSERT INTO favorite_fish (user_id, fish_id)
      VALUES (#{user_id}, #{fish_id})
    SQL

    @database_connection.sql(insert_fish_sql)
  end

  def delete_favorite(user_id, fish_id)
      delete_fish = <<-SQL
    DELETE FROM favorite_fish WHERE user_id = #{user_id} and fish_id = #{fish_id}
      SQL
      @database_connection.sql(delete_fish)
    end

  end
