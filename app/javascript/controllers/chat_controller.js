import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.scrollToBottom()
  }

  messageAdded() {
    this.scrollToBottom()
  }

  scrollToBottom() {
    const messagesContainer = document.getElementById("messages")
    messagesContainer.scrollTop = messagesContainer.scrollHeight
  }
}
