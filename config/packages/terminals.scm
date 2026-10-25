(define-module (config packages terminals)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix gexp)
  #:use-module ((guix licenses) #:prefix license:)

  #:use-module (nonguix build-system binary)

  #:export (carapace-bin))

(define carapace-bin
  (package
    (name "carapace-bin")
    (version "1.8.2")
    (source
     (origin
       (method url-fetch)
       (uri (string-append
             "https://github.com/carapace-sh/carapace-bin/releases/download/"
             "v" version "/carapace-bin_" version "_linux_amd64.deb"))
       (sha256
        (base32 "0q8h2ial6vqbzly7z6k55x9iraip9kcc5saaapjl7hs19ajmi4bm"))))
    (build-system binary-build-system)
    (arguments
     (list
      #:install-plan
      #~'(("usr/bin" "bin" #:include ("carapace")))))
    (home-page "https://github.com/carapace-sh/carapace-bin")
    (synopsis "Argument completion for multiple shells.")
    (description "Carapace-bin provides argument completion for multiple CLI commands, and works across multiple POSIX and non-POSIX shells.")
    (license license:expat)
    (supported-systems '("x86_64-linux"))))
