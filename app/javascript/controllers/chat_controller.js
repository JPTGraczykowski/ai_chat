import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.scrollToBottom()
    this.setupTurboStreamListener()
  }

  disconnect() {
    this.removeTurboStreamListener()
  }

  setupTurboStreamListener() {
    this.beforeStreamRenderHandler = this.handleBeforeStreamRender.bind(this)
    document.addEventListener("turbo:before-stream-render", this.beforeStreamRenderHandler)
  }

  removeTurboStreamListener() {
    document.removeEventListener("turbo:before-stream-render", this.beforeStreamRenderHandler)
  }

  handleBeforeStreamRender(event) {
    if (event.target.action === "append") {
      setTimeout(() => {
        this.scrollToBottom()
      }, 100)
    }
  }

  scrollToBottom() {
    const messagesContainer = document.getElementById("messages")
    if (messagesContainer) {
      messagesContainer.scrollTop = messagesContainer.scrollHeight
    }
  }
}
