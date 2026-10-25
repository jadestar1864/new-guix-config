(define-module (config home-environments jaden base packages)
  #:use-module (gnu packages gnupg)
  #:use-module (gnu packages ssh)
  #:use-module (gnu packages text-editors)
  #:use-module (gnu packages tmux)
  #:use-module (gnu packages version-control)

  #:export (development))

(define development
  (list
    #|gnupg          |# gnupg pinentry
    #|ssh            |# openssh
    #|text-editors   |# helix
    #|tmux           |# tmux
    #|version-control|# git))
