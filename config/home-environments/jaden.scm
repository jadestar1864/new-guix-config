(define-module (config home-environments jaden)
  #:use-module (gnu home)

  #:use-module (gnu home services)
  #:use-module (gnu home services dotfiles)
  #:use-module (gnu home services gnupg)
  #:use-module (gnu home services guix)
  #:use-module (gnu home services ssh)
  #:use-module (gnu home services xdg)

  #:use-module (gnu packages gnupg)
  #:use-module (gnu packages window-management)

  #:use-module (gnu services)

  #:use-module (guix gexp)
  #:use-module (guix utils)

  #:use-module (config home-environments base)
  #:use-module ((config home-environments jaden secrets)
                #:prefix secrets:)
  #:use-module ((config home-environments shared file)
                #:prefix file:)
  #:use-module ((config home-environments shared packages)
                #:prefix packages:)

  #:use-module (sops secrets)
  #:use-module (sops home services sops)

  #:export (jaden))

(define host-home-secrets.yaml
  (local-file (string-append (current-source-directory) "/jaden/secrets/" (gethostname) ".yaml")))

(define gh-host-access-key
  (sops-secret
    (key `("ssh_github_access_private_key"))
    (file host-home-secrets.yaml)
    (user "jaden")
    (group "users")
    (permissions #o400)))

(define niri-file
  (file:niri-config))

(define jaden
  (home-environment
    (inherit base)
    (packages
      (append
        packages:development
        (home-environment-packages base)))
    (services
      (cons*
        (simple-service 'jaden-xdg-config-files
                        home-xdg-configuration-files-service-type
                        `(("niri/config.kdl" ,niri-file)
                          ("jj/config.toml" ,(local-file "jaden/jj-config.toml"))))

        (service home-sops-secrets-service-type
          (home-sops-service-configuration
            (secrets
              (cons*
                gh-host-access-key
                secrets:%jaden-sops-secrets))))

        (service home-gpg-agent-service-type)

        (simple-service 'base-env-vars
                        home-environment-variables-service-type
                        `(("EDITOR"  . "hx")
                          ("BROWSER" . "zen")))

        (service home-openssh-service-type
          (home-openssh-configuration
            (hosts
              (list
                (openssh-host
                  (name "gh-js")
                  (user "git")
                  (host-name "github.com")
                  (identity-file "/run/user/1000/secrets/ssh_github_access_private_key"))))))

        (home-environment-user-services base)))))

jaden
