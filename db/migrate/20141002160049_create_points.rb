class CreatePoints < ActiveRecord::Migration
  def change
    create_table :points do |t|
      t.integer :turn_id
      t.integer :player_id
      t.integer :amount
      t.timestamps
    end
  end
end
