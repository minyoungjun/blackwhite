class Point < ActiveRecord::Base
  belongs_to :player
  belongs_to :turn
end
