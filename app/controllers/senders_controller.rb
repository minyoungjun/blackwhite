#coding: utf-8
class SendersController < ApplicationController

  def game_start

    room = Room.find(params[:id])
  if room.players.where(:user_id => current_user.id).count == 1 && room.players.count == 2
    game = Game.new
    game.room_id = room.id
    game.save
    turn  = Turn.new
    turn.game_id = game.id
    turn.save
    room.players.each do |player|
       player.game_id = game.id
       player.save
       if player.user_id == current_user.id
         player.is_first = true
         player.save
        else
        Pusher["#{player.token}"].trigger('starter', {
          data: true })
           player.is_first = false
           player.save
       end
    end
    render :json => {:success => true, :wow => false}
    else
      render :json => {:success => false, :wow => false}
    end

  end

  def enemy_action
    room = Room.find(params[:id])
    game = room.games.last
    player = room.players.where(:user_id => current_user.id).first
    enemy = room.players.where.not(user_id: current_user.id).first
    if enemy.points.count == 0
      enemy_point = 0
    else
      enemy_point = enemy.points.last.amount.to_i
    end
    if 0 <= enemy_point && enemy_point <= 9
      is_black = 1 #9이하
    elsif 10 <= enemy_point
      is_black = 0 #10이상
    else
      is_black = -1
    end
    enemy_num = enemy.has_point/20
    player_num = player.has_point/20
    render :json => {"success" => true, "is_first" => player.is_first, "player_real" => player.has_point, "player_num" => player_num, "enemy_num" => enemy_num, "my_win" => player.turns.count, "enemy_win" => enemy.turns.count, "is_black" => is_black }

  end

  def player_action
    room = Room.find(params[:id])
    game = room.games.last
    player = room.players.where(:user_id => current_user.id).first
    player.has_point = player.has_point - params[:amount].to_i
    player.save
    turn = game.turns.last

    if 0 <= params[:amount].to_i && params[:amount].to_i <= 9
      is_black = 1 #9이하
    else
      is_black = 0 #10이상
    end

    player_num = ((player.has_point.to_i)/20).to_i
    
    if player.is_first && turn.points.count == 0
      point = Point.new
      point.amount = params[:amount]
      point.player_id = player.id
      point.turn_id = turn.id
      point.save
      
      enemy = game.players.where(:is_first => false).first
      enemy_num = ((enemy.has_point.to_i)/20).to_i

      Pusher["#{enemy.token}"].trigger('reminder', {
        data: true })

      render :json => {"success" => true, "is_first" => player.is_first , "player_real" => player.has_point, "player_num" => player_num, "enemy_num" => enemy_num, "my_win" => player.turns.count, "enemy_win" => enemy.turns.count, "is_black" => is_black}

    elsif !(player.is_first) && turn.points.count == 1
      enemy = turn.points.first.player
      enemy_num = ((enemy.has_point.to_i)/20).to_i
      point = Point.new
      point.amount = params[:amount]
      point.player_id = player.id
      point.turn_id = turn.id
      point.save

       player.is_first = true
       player.save
       enemy.is_first = false
       enemy.save

      sec_turn = Turn.new
      sec_turn.game_id = game.id
      sec_turn.save

      if point.amount > turn.points.first.amount
        turn.player_id = player.id
        turn.save

      Pusher["#{enemy.token}"].trigger('is_first_result', {
      win: true })

        render :json => {"success" => true, "is_first" => false , "player_real" => player.has_point, "player_num" => player_num, "enemy_num" => enemy_num, "my_win" => player.turns.count, "enemy_win" => enemy.turns.count, "is_black" => is_black ,"win" => true}

      else
        turn.player_id = enemy.id
        turn.save

      Pusher["#{enemy.token}"].trigger('is_first_result', {
      win: false })
        render :json => {"success" => true, "is_first" => false , "player_real" => player.has_point, "player_num" => player_num, "enemy_num" => enemy_num, "my_win" => player.turns.count, "enemy_win" => enemy.turns.count, "is_black" => is_black, "win"=> false}
      end

    end

  end
end
