(define-module (config packages audio)
  #:use-module (guix)
  #:use-module (guix git-download)
  #:use-module (guix build-system copy)
  #:use-module ((guix licenses) #:prefix license:))

(define-public easyeffects-presets-git
  (package
    (name "easyeffects-presets-git")
    (version "0.0.0-1.1ac92c9")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/JackHack96/EasyEffects-Presets")
             (commit "1ac92c9be57bdfccec3fb9820924f9a870a9d56f")))
       (sha256
        (base32 "0g0smkzpzka3x3h5iidzx0kp0ihjxcbs97z5bpjbmjlr10x0ppim"))))
    (build-system copy-build-system)
    (arguments
     (list
      #:install-plan
      #~'(("."   "share/easyeffects/output" #:include-regexp ("\\.json$"))
          ("irs" "share/easyeffects/irs" #:include-regexp ("\\.irs$")))))
    (home-page "https://github.com/JackHack96/EasyEffects-Presets")
    (synopsis "Collection of EasyEffects presets.")
    (description "A collection of presets for EasyEffects.")
    (license license:expat)))
