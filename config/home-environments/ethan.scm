(define-module (config home-environments ethan)
  #:use-module (gnu home)
  #:use-module (gnu home services)

  #:use-module (gnu services)

  #:use-module (config home-environments base))

;; REMINDER: Keep updated with config/operating-systems/nebula-arcanum.scm
(define-public ethan
  (home-environment
    (inherit base)
    (services
      (cons*
        (simple-service 'ethan-env-vars
                        home-environment-variables-service-type
                        `(("BROWSER" . "zen")))
        (home-environment-user-services base)))))

ethan
