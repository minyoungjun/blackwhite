class Room < ActiveRecord::Base
  has_many :chats
  has_many :games
  has_many :players
end
