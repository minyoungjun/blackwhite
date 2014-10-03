#coding: utf-8
class MainController < ApplicationController
  def index

  @rooms = Room.all

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
    @user = current_user
    if @room.games.count == 0 && @room.players.where(:user_id => current_user.id).count > 0
      @player = @room.players.where(:user_id => current_user.id).first
    else

      if @room.players.first.user == current_user
        @player = @room.players.first
      elsif @room.players.where(user_id: current_user.id).count == 0 && @room.players.count == 1
        player = Player.new
        player.room_id = @room.id
        player.user_id = current_user.id
        player.token = SecureRandom.hex(10)
        player.save
        @player = @room.players.where(:user_id => current_user).last
        Pusher["#{@room.players.where.not(user_id: current_user).first.token}"].trigger('come', {
          message: "#{@player.user.email}님께서 입장하셨습니다." })
      else
        render :text => "이미 2명이 있는 방입니다."
      end
    end
  end
end
