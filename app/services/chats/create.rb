module Chats
  class Create
    attr_reader :success, :chat

    def initialize(params)
      @params = params
      @success = false
    end

    def call
      @chat = Chat.new(@params)

      if @chat.save
        create_welcome_message
        @success = true
      end
    end

    private

    def create_welcome_message
      @chat.messages.create(content: "Hello, how can I help you today?", role: "assistant")
    end
  end
end
