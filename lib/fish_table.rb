class FishTable

  def initialize(database_connection)
    @database_connection = database_connection
  end

  def create_fish(fish_name, wikipage, user_id)
    create_fish = <<-SQL
    INSERT INTO fish (fish_name, wikipage, user_id)
    VALUES ('#{fish_name}','#{wikipage}', '#{user_id.to_i}')
    SQL
    @database_connection.sql(create_fish)
  end

  def find_fish(user_id)
    find_fish = <<-SQL
    select * from fish where user_id=(#{user_id})
    SQL
    @database_connection.sql(find_fish)
  end



end