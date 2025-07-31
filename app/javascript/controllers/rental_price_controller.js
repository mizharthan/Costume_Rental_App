import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="rental-price"
export default class extends Controller {
  static targets = ["startDate", "endDate", "totalPrice"]
  static values = { pricePerDay: Number }

  connect() {
    console.log("✅ RentalPriceController connected!")
    this.calculate()
  }

  calculate() {
    console.log("🔁 Triggered calculation")

    const startDateStr = this.startDateTarget.value
    const endDateStr = this.endDateTarget.value

    if (startDateStr && endDateStr) {
      const start = new Date(startDateStr)
      const end = new Date(endDateStr)

      const utcStart = Date.UTC(start.getFullYear(), start.getMonth(), start.getDate())
      const utcEnd = Date.UTC(end.getFullYear(), end.getMonth(), end.getDate())

      const days = Math.floor((utcEnd - utcStart) / (1000 * 60 * 60 * 24))

      if (days > 0) {
        const total = (days * this.pricePerDayValue).toFixed(2)
        this.totalPriceTarget.textContent = total
        console.log(`✅ ${days} day(s), €${total}`)
      } else {
        this.totalPriceTarget.textContent = "0.00"
        console.log("⚠️ End date is before or same as start date")
      }
    } else {
      this.totalPriceTarget.textContent = "0.00"
      console.log("⚠️ One or both date fields are blank")
    }
  }
}
