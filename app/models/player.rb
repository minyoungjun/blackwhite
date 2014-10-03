class Player < ActiveRecord::Base
  belongs_to :user
  belongs_to :room
  belongs_to :game
  has_many :turns
  has_many :points
end
