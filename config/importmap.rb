# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin "theme-change", to: "https://cdn.jsdelivr.net/npm/theme-change@2.0.2/index.js"
pin_all_from "app/javascript/controllers", under: "controllers"
