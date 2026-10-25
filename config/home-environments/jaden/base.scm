(define-module (config home-environments jaden base)
  #:use-module (gnu home)

  #:use-module (gnu home services guix)
  #:use-module (gnu home services xdg)

  #:use-module (gnu services)

  #:use-module ((config channels)
                #:prefix channels:)

  #:export (base))

(define base
  (home-environment
    (services
      (cons*
        (service home-channels-service-type channels:%config-channels)
        
        (service home-xdg-user-directories-service-type
          (home-xdg-user-directories-configuration
            (desktop   "$HOME/desktop/")
            (documents "$HOME/documents/")
            (download  "$HOME/downloads/")
            (music     "$HOME/music/")
            (pictures  "$HOME/images/")
            (videos    "$HOME/videos/")
            (projects  "$HOME/projects")
            (templates "")
            (publicshare "")))
        %base-home-services))))
