class CreateChats < ActiveRecord::Migration
  def change
    create_table :chats do |t|
      t.integer :user_id
      t.integer :room_id
      t.text  :content
      t.timestamps
    end
  end
end
