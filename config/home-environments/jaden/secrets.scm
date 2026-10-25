(define-module (config home-environments jaden secrets)
  #:use-module (sops secrets)

  #:use-module (guix gexp)

  #:export (%jaden-sops-secrets))

;(define secrets.yaml
;  (local-file "secrets/secrets.yaml"))

(define %jaden-sops-secrets
  (list))
