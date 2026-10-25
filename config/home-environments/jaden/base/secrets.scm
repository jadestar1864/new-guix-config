(define-module (config home-environments jaden base secrets)
  #:use-module (sops secrets)

  #:use-module (guix gexp)

  #:export (thinkpadx1-github-access-key
            %jaden-sops-secrets))

(define secrets.yaml
  (local-file "secrets.yaml"))

(define thinkpadx1-github-access-key
  (sops-secret
    (key '("ssh_github_access_private_key"))
    (file secrets.yaml)
    (user "jaden")
    (group "users")
    (permissions #o400)))

(define jaden-sops-secrets
  (list))
