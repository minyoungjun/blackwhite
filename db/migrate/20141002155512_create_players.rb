class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.integer :user_id
      t.integer :game_id
      t.integer :room_id
      t.boolean :is_first, default: true
      t.integer :has_point, default: 99
      t.integer :win
      t.string  :token
      t.timestamps
    end
  end
end
