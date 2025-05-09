class ChatsController < ApplicationController
  def index
    @chats = Chat.all
  end

  def show
    @chat = Chat.find(params[:id])
    @messages = @chat.messages
    @message = Message.new
  end

  def new
    @chat = Chat.new
  end

  def create
    service = Chats::Create.new(chat_params)
    service.call

    if service.success
      redirect_to service.chat
    else
      @chat = service.chat
      render :new, status: :unprocessable_entity
    end
  end

  private

  def chat_params
    params.require(:chat).permit(:title)
  end
end
