class FishTable

  def initialize(database_connection)
    @database_connection = database_connection
  end

  def fish_setter
  fish_setter = <<-SQL
    SELECT * FROM fish
  SQL
  @database_connection.sql(fish_setter)
  end

  def create_fish(fish_name, wikipage, user_id)
    create_fish = <<-SQL
    INSERT INTO fish (fish_name, wikipage, user_id)
    VALUES ('#{fish_name}','#{wikipage}', '#{user_id.to_i}')
    SQL
    @database_connection.sql(create_fish)
  end



end