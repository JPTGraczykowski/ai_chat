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

      response_message = @chat.messages.create(
        role: "assistant",
        content: @response
      )

      Turbo::StreamsChannel.broadcast_render_to(
        [@chat, :messages],
        partial: "messages/ai_response",
        locals: { message: response_message }
      )
    rescue => e
      puts "Error in AI Response Job: #{e.message}"

      error_message = @chat.messages.create(
        role: "assistant",
        content: "I'm sorry, I couldn't respond to that at this time."
      )

      Turbo::StreamsChannel.broadcast_render_to(
        [@chat, :messages],
        partial: "messages/ai_response",
        locals: { message: error_message }
      )
    end
  end
end
