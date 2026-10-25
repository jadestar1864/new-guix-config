(define-module (config home-environments base)
  #:use-module (gnu home)

  #:use-module (gnu home services)
  #:use-module (gnu home services desktop)
  #:use-module (gnu home services fontutils)
  #:use-module (gnu home services guix)
  #:use-module (gnu home services shells)
  #:use-module (gnu home services sound)
  #:use-module (gnu home services xdg)

  #:use-module (gnu packages gnome)

  #:use-module (gnu services)

  #:use-module (guix gexp)

  #:use-module ((config channels)
                #:prefix channels:)
  #:use-module ((config home-environments shared mime-types)
                #:prefix mime-types:)
  #:use-module ((config home-environments shared packages)
                #:prefix packages:)

  #:export (base))

(define base
  (home-environment
    (packages
      (append
        packages:desktop
        packages:fonts))
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

        (simple-service 'default-fonts
                        home-fontconfig-service-type
                        (list
                          '(alias
                            (family "monospace")
                            (prefer
                              (family "Symbols Nerd Font")
                              (family "Noto Color Emoji")
                              (family "Fira Mono")))
                          '(alias
                            (family "serif")
                            (prefer
                              (family "Symbols Nerd Font")
                              (family "Noto Color Emoji")
                              (family "Source Serif Pro")))
                          '(alias
                            (family "sans")
                            (prefer
                              (family "Symbols Nerd Font")
                              (family "Noto Color Emoji")
                              (family "Source Sans Pro")))))

        (simple-service 'dark-mode
                        home-activation-service-type
                        #~(system* #$(file-append dconf "/bin/dconf")
                                   "write"
                                   "/org/gnome/desktop/interface/color-scheme"
                                   "\"prefer-dark\""))

        (simple-service 'base-xdg-config-files
                        home-xdg-configuration-files-service-type
                        `(("xdg-desktop-portal/portals.conf" ,(local-file "shared/portals.conf"))))


        (service home-xdg-mime-applications-service-type
          (home-xdg-mime-applications-configuration
            (default
              (let ((make-pairs (lambda (value keys)
                                  (map (lambda (key) (cons key value)) keys))))
                (append
                  (make-pairs 'zen.desktop              mime-types:browser)
                  (make-pairs 'org.kde.kate.desktop     mime-types:editor)
                  (make-pairs 'thunar.desktop           mime-types:file-manager)
                  (make-pairs 'mpv.desktop              mime-types:audio-video)
                  (make-pairs 'org.kde.gwenview.desktop mime-types:image)
                  (make-pairs 'org.pwmt.zathura.desktop mime-types:pdf))))))

        (service home-fish-service-type
          (home-fish-configuration
            (environment-variables
              `(("GPG_TTY" . "$(tty)")))
            (aliases
              `(
                 ("ls"     . "ls -lhFv --group-directories-first --color=auto")
                 ("reboot" . "doas reboot")
                 ("halt"   . "doas halt")))))

        (service home-pipewire-service-type)
        (service home-dbus-service-type)

        %base-home-services))))
