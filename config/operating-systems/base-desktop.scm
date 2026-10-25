(define-module (config operating-systems base-desktop)
  #:use-module (gnu system)

  #:use-module (gnu packages admin)
  #:use-module (gnu packages cups)

  #:use-module (gnu services)
  #:use-module (gnu services avahi)
  #:use-module (gnu services base)
  #:use-module (gnu services cups)
  #:use-module (gnu services desktop)

  #:use-module (guix gexp)

  #:use-module (config operating-systems base)
  #:use-module ((config packages cups)
                #:prefix pkgs:)

  #:export (base-desktop))

(define base-desktop
  (operating-system
    (inherit base)
    (services
      (cons*
        #|Login services|#
        (service console-font-service-type
          `(("tty1" . ,%default-console-font)
            ("tty2" . ,%default-console-font)
            ("tty3" . ,%default-console-font)))

        (service seatd-service-type)
        (service greetd-service-type
          (greetd-configuration
            (terminals
              (cons*
                (greetd-terminal-configuration
                  (terminal-vt "1")
                  (terminal-switch #t)
                  (default-session-command
                    (file-append tuigreet "/bin/tuigreet")))
                (map
                  (lambda (x)
                    (greetd-terminal-configuration
                      (terminal-vt (number->string x))
                      (default-session-command
                        (greetd-agreety-session
                          (command
                            (greetd-user-session
                              (command #~(getenv "SHELL"))))))))
                  (iota 3 2))))))

        #|Networking services|#
        ;; For .local host name resolution for CUPS
        (service avahi-service-type)

        #|Gnome services|#
        (service gnome-keyring-service-type
          (gnome-keyring-configuration
            (pam-services
              `(("login"  . login)
                ("passwd" . passwd)))))

        #|Printing services|#
        (service cups-service-type
          (cups-configuration
            (web-interface? #t)
            (extensions
              (list cups-filters pkgs:epson-inkjet-printer-escpr2))))


        (modify-services (operating-system-user-services base)
          (delete console-font-service-type)
          (delete login-service-type)
          (delete mingetty-service-type)
          (delete agetty-service-type)
      )))
    ))
