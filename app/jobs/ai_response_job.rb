require "gemini-ai"

class AiResponseJob < ApplicationJob
  queue_as :default

  def perform(chat, prompt_message)
    @chat = chat
    @prompt_message = prompt_message

    call_ai
  end

  private

  def call_ai
    client = Gemini.new(
      credentials: {
        service: "generative-language-api",
        api_key: ENV["GOOGLE_API_KEY"]
      },
      options: {
        model: "gemini-2.0-flash",
        server_sent_events: false # Disable streaming for more consistent responses
      }
    )

    begin
      result = client.generate_content({
        contents: {
          role: "user",
          parts: { text: @prompt_message }
        }
      })

      result_content = result&.dig("candidates", 0, "content")
      @response = result_content&.dig("parts", 0, "text")

      @response ||= "I'm sorry, I couldn't generate a proper response."

      @chat.messages.create(
        role: "assistant",
        content: @response
      )
    rescue => e
      puts "Error in AI Response Job: #{e.message}"

      @chat.messages.create(
        role: "assistant",
        content: "I'm sorry, I couldn't respond to that at this time."
      )
    end
  end
end
