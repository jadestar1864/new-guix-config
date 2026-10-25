(define-module (config packages xdisorg)
  #:use-module (guix)
  #:use-module (guix git-download)
  #:use-module (guix build-system copy))

(define-public rofi-themes-collection-git
  (package
    (name "rofi-themes-collection-git")
    (version "0.0.0-1.911cc27")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/newmanls/rofi-themes-collection")
             (commit "911cc27afe9c66d7e2cb06a47c905d046ea3dfd2")))
       (sha256
        (base32 "02pln6551vy1pc2rg14za4n8xxrblamvqzsxphjgmzaldb72xnv1"))))
    (build-system copy-build-system)
    (arguments
     (list
      #:install-plan
      #~'(("themes" "share/rofi/themes"))))
    (home-page "https://github.com/newmanls/rofi-themes-collection")
    (synopsis "Themes for Rofi")
    (description "A collection of themes for the Rofi application.")
    (license #f)))
