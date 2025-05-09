require "test_helper"

class Chats::CreateTest < ActiveSupport::TestCase
  test "creates a chat with valid parameters" do
    service = Chats::Create.new(title: "Test Chat")
    service.call

    assert service.success
    assert_not_nil service.chat
    assert service.chat.persisted?
    assert_equal "Test Chat", service.chat.title
  end

  test "creates a welcome message" do
    service = Chats::Create.new(title: "Test Chat")
    service.call

    welcome_message = service.chat.messages.first
    assert_not_nil welcome_message
    assert_equal "Hello, how can I help you today?", welcome_message.content
    assert_equal "assistant", welcome_message.role
  end

  test "does not create a chat with invalid parameters" do
    service = Chats::Create.new(title: "")
    service.call

    assert_not service.success
    assert_not service.chat.persisted?
    assert_not_empty service.chat.errors[:title]
  end
end
