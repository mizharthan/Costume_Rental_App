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

    const start = this.extractDateFrom("startDate")
    const end = this.extractDateFrom("endDate")

    if (start && end) {
      const utcStart = Date.UTC(start.getFullYear(), start.getMonth(), start.getDate())
      const utcEnd = Date.UTC(end.getFullYear(), end.getMonth(), end.getDate())

      const days = Math.floor((utcEnd - utcStart) / (1000 * 60 * 60 * 24))

      if (days > 0) {
        const total = (days * this.pricePerDayValue).toFixed(2)
        this.totalPriceTarget.textContent = total
        console.log(`✅ ${days} day(s), €${total}`)
      } else {
        this.totalPriceTarget.textContent = "0.00"
        console.log("⚠️ End date is before start date")
      }
    } else {
      this.totalPriceTarget.textContent = "0.00"
      console.log("⚠️ Couldn’t parse dates")
    }
  }

  extractDateFrom(targetName) {
    const wrapper = this[`${targetName}Target`]
    if (!wrapper) return null

    const year = wrapper.querySelector(`[name*="(1i)"]`)?.value
    const month = wrapper.querySelector(`[name*="(2i)"]`)?.value
    const day = wrapper.querySelector(`[name*="(3i)"]`)?.value

    if (year && month && day) {
      return new Date(Number(year), Number(month) - 1, Number(day)) // Month is 0-indexed
    }

    return null
  }


}
