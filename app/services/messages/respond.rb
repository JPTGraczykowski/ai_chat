module Messages
  class Respond
    attr_reader :success, :ai_message

    def initialize(chat, prompt_message)
      @chat = chat
      @prompt_message = prompt_message
      @success = false
    end

    def call
      @ai_message = @chat.messages.new(
        content: "AI Response placeholder",
        role: "assistant"
      )

      @success = @ai_message.save
    end
  end
end
