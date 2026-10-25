(define-module (config home-environments jaden thinkpadx1)
  #:use-module (gnu home)

  #:use-module ((config home-environments jaden base packages)
                #:prefix packages:)

  #:export (jaden-home-thinkpadx1))

(define jaden-home-thinkpadx1
  (home-environment
    (packages
      (append
        packages:development))))
