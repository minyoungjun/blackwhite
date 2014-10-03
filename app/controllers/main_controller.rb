#coding: utf-8
class MainController < ApplicationController

  def turn_action

    room = Room.find(params[:id])
    game = room.games.last
    player = room.players.where(:user_id => current_user.id).first
    player.has_point = player.has_point - params[:amount].to_i
    player.save
    turn = game.turns.last
      if 0 <= params[:amount].to_i && params[:amount].to_i <= 9
        small = "black"
      else
        small = "white"
      end

    if player.is_first && turn.points.count == 0
      point = Point.new
      point.amount = params[:amount]
      point.player_id = player.id
      point.turn_id = turn.id
      point.save

      enemy = game.players.where(:is_first => false ).first

      case ((enemy.has_point.to_i)/20).to_i
      when 0

      enemy_num ="0~19"
      when 1

      enemy_num ="20~39"
      when 2
      enemy_num ="40~59"
      when 3 
      enemy_num ="60~79"
      when 4
      enemy_num = "80_99"
      end

      case ((player.has_point.to_i)/20).to_i
      when 0
      player_num ="0~19"
      when 1

      player_num ="20~39"
      when 2
      player_num ="40~59"
      when 3 
      player_num ="60~79"
      when 4
      player_num = "80_99"
      end



        Pusher["#{enemy.token}"].trigger('my_event', {
          message: '상대가 제출을 완료하였습니다. 당신도 내세요.', start: false, turn: 1, ene: player_num, sma: small, myp: enemy_num, my_win: "a", ene_win: "a"
        })
        Pusher["#{player.token}"].trigger('my_event', {
          message: '제출완료. 상대방의 선택을 기다립니다.', start: false, turn: 0, ene: player_num, sma: "a", myp: enemy_num, my_win: "a", ene_win: "a"})


    elsif !(player.is_first) && turn.points.count == 1
      enemy = turn.points.first.player
      
      case ((enemy.has_point.to_i)/20).to_i
      when 0

      enemy_num ="0~19"
      when 1

      enemy_num ="20~39"
      when 2
      enemy_num ="40~59"
      when 3 
      enemy_num ="60~79"
      when 4
      enemy_num = "80_99"
      end

      case ((player.has_point.to_i)/20).to_i
      when 0

      player_num ="0~19"
      when 1

      player_num ="20~39"
      when 2
      player_num ="40~59"
      when 3 
      player_num ="60~79"
      when 4
      player_num = "80_99"
      end

      point = Point.new
      point.amount = params[:amount]
      point.player_id = player.id
      point.turn_id = turn.id
      point.save

      if point.amount > turn.points.first.amount
        turn.player_id = player.id
        turn.save
        my_win = game.turns.where(:player_id => player.id).count
        ene_win = game.turns.where(:player_id => enemy.id).count

        0.upto(2) do |x|
        Pusher["#{player.token}"].trigger('my_event', {
          message: '당신이 승점 1점을 얻었습니다. 이번은 당신이 선공입니다.', start: false, turn: 1, ene: enemy_num, myp: player_num, my_win: my_win, ene_win: ene_win
        })

      Pusher["#{enemy.token}"].trigger('my_event', {
        message: '상대방이 승점 1점을 얻었습니다. 이번은 당신이 후공입니다.', start: false, turn: 0, ene: player_num, sma: small, myp: enemy_num, my_win: ene_win, ene_win: my_win 
      })
      end

      else
        turn.player_id = enemy.id
        turn.save
        my_win = game.turns.where(:player_id => player.id).count
        ene_win = game.turns.where(:player_id => enemy.id).count

        Pusher["#{player.token}"].trigger('my_event', {
          message: '상대방이 승점 1점을 얻었습니다. 이번은 당신이 선공입니다.', start: false, turn: 1, ene: enemy_num, sma: "a", myp: player_num, my_win: my_win, ene_win: ene_win
        })
      Pusher["#{enemy.token}"].trigger('my_event', {
        message: '당신이 승점 1점을 얻었습니다. 이번은 당신이 후공입니다.', start: false, turn: 0, ene: player_num, sma: small, myp: enemy_num, my_win: ene_win, ene_win: my_win
      })
      end
     player.is_first = true
     player.save
     enemy.is_first = false
     enemy.save
     sec_turn = Turn.new
     sec_turn.game_id = game.id
     sec_turn.save


    end

      render :json => ["success"]

  end

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
       if player.user_id == current_user.id
         player.is_first = true
         player.save
      Pusher["#{player.token}"].trigger('my_event', {
        message: '게임을 시작하겠습니다. 당신이 선입니다.', start: true, turn: 1, sma: "a", ene: "a", myp: "a", my_win: "a", enemy_win: "a"
      })
       else

      Pusher["#{player.token}"].trigger('my_event', {
        message: '게임을 시작합니다. 당신이 후공입니다.', start: true, turn: 0, sma: "a", ene: "a", myp: "a", my_win: "a", enemy_win: "a"})
         player.is_first = false
         player.save
       end
    end
      render :json => ["success"]
    else
      render :json => ["fail"]
    end

  end

  def index
  @rooms = Room.all

  end

  def hello
    Pusher['test_channel'].trigger('my_event', {
      message: '남민수 개병신'
    })
    render :text => 'success'

  end

  def new_room
     room = Room.new
     room.user_id = current_user.id
     room.save
     room.title = "#{room.id}번 방"
     room.save

     player = Player.new
     player.room_id = room.id
     player.user_id = current_user.id
     player.token = SecureRandom.hex(10)
     player.save

     redirect_to :action => "room", "id" => room.id
  end

  def room
    @room = Room.find(params[:id])
    if @room.players.first.user == current_user
      @player = @room.players.first
    elsif @room.players.where(user_id: current_user.id).count == 0 && @room.players.count == 1
      player = Player.new
      player.room_id = @room.id
      player.user_id = current_user.id
      player.token = SecureRandom.hex(10)
      player.save
    end
    @player = @room.players.where(:user_id => current_user).last
  end

end
