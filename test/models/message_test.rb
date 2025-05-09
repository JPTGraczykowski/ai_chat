require "test_helper"

class MessageTest < ActiveSupport::TestCase
  test "should belong to a chat" do
    message = Message.new
    assert_respond_to message, :chat
    assert_equal Message.reflect_on_association(:chat).macro, :belongs_to
  end

  test "should validate presence of content" do
    message = Message.new
    assert_not message.valid?
    assert_includes message.errors.full_messages, "Content can't be blank"
  end

  test "should validate presence of role" do
    message = Message.new
    assert_not message.valid?
    assert_includes message.errors.full_messages, "Role can't be blank"
  end

  test "should validate role inclusion" do
    message = Message.new(role: "invalid")
    assert_not message.valid?
    assert_includes message.errors.full_messages, "Role is not included in the list"
  end
end
