class Message < ApplicationRecord
  belongs_to :chat

  validates :content, presence: true
  validates :role, presence: true, inclusion: { in: %w[user assistant] }

  after_create_commit -> { broadcast_append_to chat, :messages }
end
