require "test_helper"

class ChatTest < ActiveSupport::TestCase
  test "should have many messages" do
    chat = Chat.new
    assert_respond_to chat, :messages
    assert_equal Chat.reflect_on_association(:messages).macro, :has_many
  end

  test "should validate presence of title" do
    chat = Chat.new
    assert_not chat.valid?
    assert_includes chat.errors.full_messages, "Title can't be blank"
  end
end
