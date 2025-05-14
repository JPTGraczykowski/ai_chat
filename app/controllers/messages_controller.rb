class MessagesController < ApplicationController
  def create
    @message = Message.new(message_params)
    @message.role = "user"
    @chat = @message.chat

    if @message.save
      AiResponseJob.perform_later(@chat, @message.content)

      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to @chat }
      end
    else
      @messages = @chat.messages
      render "chats/show", status: :unprocessable_entity
    end
  end

  private

  def message_params
    params.require(:message).permit(:chat_id, :content)
  end
end
