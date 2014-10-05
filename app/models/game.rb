class Game < ActiveRecord::Base
  belongs_to :winner, :class_name =>  "User", :foreign_key =>  "winner_id"
  belongs_to :loser, :class_name => "User", :foreign_key => "loser_id"
  belongs_to :room
  has_many :turns
  has_many  :players

  def self.game_start(room_id, user_id, first_game)
    room = Room.find(room_id)
    game = Game.new
    game.room_id = room_id
    game.save
    turn  = Turn.new
    turn.game_id = game.id
    turn.save
    room.players.each do |player|
      if !(first_game)
        player.turns.each do |p_turn|
          p_turn.delete
        end
       player.has_point = 99
      end
       player.game_id = game.id
       player.save
       if player.user_id == user_id
         player.is_first = true
         player.save
        else
        Pusher["#{player.token}"].trigger('starter', {
          data: true })
           player.is_first = false
           player.save
         end
      end
  end
end
