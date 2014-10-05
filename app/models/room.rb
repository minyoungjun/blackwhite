class Room < ActiveRecord::Base
  belongs_to :user
  has_many :chats
  has_many :games
  has_many :players
end
