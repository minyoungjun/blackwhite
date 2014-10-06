#coding: utf-8연락
class MainController < ApplicationController
  def help
  end 
  def feedback
    letter = Letter.new
    if user_signed_in?
      letter.user_id = current_user.id 
    end
    letter.content = params[:content]
    letter.save

    render :text => "<h1>만든 사람에게 전달하였습니다.</h1><p>#{letter.content}</p>"

  end
  def read

    if user_signed_in?
      @letters = Letter.all
    else
      render :text => "error"
    end
  end

  def index

  @rooms = Room.all
  @user = current_user
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

    if user_signed_in?
    @user = current_user
    else
      user = User.new({
        email: "anonymous@#{SecureRandom.hex(10)}.com",
      password: 'password',
      password_confirmation: 'password'})
      user.save
      sign_in user
      @user = user
    end

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
          message: "#{@player.user.email}님(전적:#{@player.user.victories.count}승/#{@player.user.loses.count}패)께서 입장하셨습니다." })
      else
        render :text => "이미 2명이 있는 방입니다."
      end
    end
  end
end
