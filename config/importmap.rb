# Pin npm packages by running ./bin/importmap

pin "application"
pin "bootstrap", to: "bootstrap/dist/js/bootstrap.bundle.min.js", preload: true
pin "@popperjs/core", to: "@popperjs/core/dist/umd/popper.min.js", preload: true
