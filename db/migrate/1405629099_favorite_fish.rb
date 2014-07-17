class FavoriteFish < ActiveRecord::Migration
  def up
    create_table :favorite_fish do |t|
      t.integer :user_id
      t.integer :fish_id
    end
  end

  def down
    drop_table :favorite_fish
  end
end