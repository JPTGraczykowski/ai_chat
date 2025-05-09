module Messages
  class Respond
    attr_reader :success

    def initialize(chat, prompt_message)
      @chat = chat
      @prompt_message = prompt_message
      @success = false
    end

    def call
      message = @chat.messages.new(
        content: "AI Response placeholder",
        role: "assistant"
      )

      @success = message.save
    end
  end
end
