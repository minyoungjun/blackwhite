#coding:utf-8

class SendMessage
  include Sidekiq::Worker
  sidekiq_options :retry => false

  def perform(room_id, user_id, chat_content)

    room = Room.find(room_id)
    chat = Chat.new
    chat.user_id = user_id
    chat.room_id = room.id
    chat.content = chat_content
    chat.save
    room.players.each do |player|
      Pusher["#{player.token}"].trigger('chat', {
        message: chat.content })
    end

  end
end
