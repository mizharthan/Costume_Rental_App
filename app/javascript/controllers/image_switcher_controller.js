import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["main", "thumbnail"]

  switch(event) {
    this.mainTarget.src = event.target.src
  }
}
