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

  #:use-module (config packages networking)

  #:use-module (config home-environments base)
  #:use-module ((config home-environments jaden secrets)
                #:prefix secrets:)
  #:use-module ((config home-environments shared packages)
                #:prefix packages:)

  #:use-module (sops secrets)
  #:use-module (sops home services sops))

(define host-home-secrets-path
  (string-append (current-source-directory) "/jaden/secrets/" (gethostname) ".yaml"))

(define host-home-secrets.yaml
  (if (file-exists? host-home-secrets-path)
      (local-file host-home-secrets-path)
      #f))

(define host-gh-secrets
  (if host-home-secrets.yaml
      (list
        (sops-secret
          (key `("ssh_github_access_private_key"))
          (file host-home-secrets.yaml)
          (user "jaden")
          (group "users")
          (permissions #o400)))
      '()))
          
(define-public jaden
  (home-environment
    (inherit base)
    (packages
      (append
        packages:development
        (list
          )
        (home-environment-packages base)))
    (services
      (cons*
        (simple-service 'jaden-xdg-config-files
                        home-xdg-configuration-files-service-type
                        `(("jj/config.toml" ,(local-file "jaden/jj-config.toml"))
                          ("autostart/NymVPN.desktop" ,(file-append nym-vpn-app-bin "/share/applications/NymVPN.desktop"))
                          ("helix/config.toml" ,(local-file "jaden/helix-config.toml"))))

        (service home-sops-secrets-service-type
          (home-sops-service-configuration
            (secrets
              (append
                host-gh-secrets
                secrets:%jaden-sops-secrets))))

        (service home-gpg-agent-service-type)

        (simple-service 'jaden-env-vars
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
