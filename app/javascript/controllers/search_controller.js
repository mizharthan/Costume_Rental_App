import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "wearer", "results"]

  search() {
    const query = this.InputTarget.value
    const wearer = this.WearerTarget?.value || ""

    fetch(`/search?query=${encodeURIComponent(query)}&wearer=${encodeURIComponent(wearer)}`, {
      headers: { "Accept": "text/vnd.turbo-stream.html" }
    })

    .then(response => response.text())
    .then(html => {
      this.resultsTarget.innerHTML = html
    })
  }
}
