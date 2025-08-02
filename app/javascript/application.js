// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import "@popperjs/core"
import "bootstrap"
import flatpickr from "flatpickr";

document.addEventListener("turbo:load", () => {
  console.log("Initializing flatpickr");
  flatpickr("#start-date", { dateFormat: "Y-m-d" });
  flatpickr("#end-date", { dateFormat: "Y-m-d" });
});
