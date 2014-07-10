class Fish < ActiveRecord::Migration
  def up
    create_table :fish do |t|
      t.string :fishname
      t.string :fishwiki
      t.string :user_id
    end
  end

  def down
    drop_table :fish
  end
end