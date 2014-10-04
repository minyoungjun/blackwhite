class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :victories, :class_name => "Game", :foreign_key => "winner_id"

  has_many :loses, :class_name => "Game", :foreign_key => "loser_id"
  has_many :chats
   has_many :games
   has_many :players
   has_many :letters
  
end
