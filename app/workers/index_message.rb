#coding:utf-8

class IndexMessage
  include Sidekiq::Worker
  sidekiq_options :retry => false

  def perform(user_id, chat_content)
    chat = Chat.new
    chat.room_id = 0
    chat.user_id = user_id
    chat.save
    Pusher["indexchat"].trigger('say', {
      message: chat_content })

  end
end
