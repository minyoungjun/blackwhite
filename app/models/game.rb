class Game < ActiveRecord::Base
  belongs_to :room
  has_many :turns
  has_many  :players
end
