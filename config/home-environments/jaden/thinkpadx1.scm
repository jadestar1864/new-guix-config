(define-module (config home-environments jaden thinkpadx1)
  #:use-module (gnu home)

  #:use-module (gnu home services)
  #:use-module (gnu home services shells)

  #:use-module (gnu services)

  #:use-module (sops home services sops)

  #:use-module (config home-environments jaden base)
  #:use-module ((config home-environments jaden base packages)
                #:prefix packages:)
  #:use-module ((config home-environments jaden base secrets)
                #:prefix secrets:)

  #:export (jaden-home-thinkpadx1))

(define jaden-home-thinkpadx1
  (home-environment
    (inherit base)
    (packages
      (append
        packages:development))
    (services
      (cons*
        (service home-fish-service-type
          (home-fish-configuration
            (aliases
              `(
                 ("ls"     . "ls -lhFv --group-directories-first --color=auto")
                 ("reboot" . "doas reboot")
                 ("halt"   . "doas halt")))))
        (simple-service 'environment-variables
                        home-environment-variables-service-type
          `(
             ("EDITOR" . "hx")))

        (service home-sops-secrets-service-type
          (home-sops-secrets-configuration
            (secrets
              (cons*
                secrets:thinkpadx1-github-access-key
                secrets:%jaden-sops-secrets))))

        (home-environment-user-services base)))))

jaden-home-thinkpadx1
