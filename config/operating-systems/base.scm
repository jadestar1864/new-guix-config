(define-module (config operating-systems base)
  #:use-module (guix channels)
  #:use-module (guix gexp)
  #:use-module (srfi srfi-1)

  #:use-module (gnu)

  #:use-module (gnu packages)
  #:use-module (gnu packages admin)
  #:use-module (gnu packages base)
  #:use-module (gnu packages bash)
  #:use-module (gnu packages linux)

  #:use-module (gnu services)
  #:use-module (gnu services admin)
  #:use-module (gnu services base)
  #:use-module (gnu services desktop)
  #:use-module (gnu services linux)
  #:use-module (gnu services networking)
  #:use-module (gnu services shepherd)
  #:use-module (gnu services sysctl)

  #:use-module (gnu system keyboard)

  #:use-module (nongnu packages linux)

  #:use-module ((config operating-systems base users)
                #:prefix user:)
  #:use-module ((config operating-systems base opendoas)
                #:prefix rules:)
  #:use-module ((config substitute-keys)
                #:prefix substitute-keys:)

  #:export (base))

(define garbage-collection-timer
  ;; Run 'guix gc' everyday at 5AM.
  (shepherd-timer '(garbage-collection)
    #~(calendar-event #:hours '(5) #:minutes '(0))
    #~("/run/current-system/profile/bin/guix"
       "gc" "-F" "10G")
    #:requirement '(guix-daemon)))

(define %base-channels
  (append
    (list
      (channel
        (name 'nonguix)
        (url "https://gitlab.com/nonguix/nonguix")
        (introduction
          (make-channel-introduction
            "897c1a470da759236cc11798f4e0a5f7d4d59fbc"
            (openpgp-fingerprint "2A39 3FFF 68F4 EF7A 3D29  12AF 6F51 20A0 22FB B2D5")))))
    %default-channels))

(define base
  (operating-system
    (host-name "base")
    (locale "en_US.utf8")
    (keyboard-layout (keyboard-layout "us"))
    (kernel linux)
    (file-systems '())
    (bootloader #f)
    (users
      (cons*
        user:jaden
        user:root
        %base-user-accounts))
    (services
      (list
        (service guix-service-type
          (guix-configuration
            (channels %base-channels)
            (authorized-keys
              (list
                substitute-keys:moe.pub
                substitute-keys:guix.pub
                substitute-keys:bordeaux.pub))
            (substitute-urls
              (list
                "https://cache-us-lax.guix.moe"
                "https://ci.guix.gnu.org"
                "https://bordeaux.guix.gnu.org"))
            (privileged? #f)))

        #|Login services|#
        (service virtual-terminal-service-type)

        (service console-font-service-type
          `(("tty1" . ,%default-console-font)
            ("tty2" . ,%default-console-font)
            ("tty3" . ,%default-console-font)))

        (service seatd-service-type)
        (service greetd-service-type
          (greetd-configuration
            (greeter-supplementary-groups `("video" "input" "seat"))
            (terminals
              (map
                (lambda (x)
                  (greetd-terminal-configuration
                    (terminal-vt (number->string x))
                    (terminal-switch (= x 1))
                    (default-session-command
                      (greetd-agreety-session
                        (command
                          (greetd-user-session
                            (command #~(getenv "SHELL"))))))))
                (iota 3 1)))))

        #|Garbage collector job|#
        (simple-service 'guix-gc-timer
                        shepherd-root-service-type
                        (list garbage-collection-timer))

        #|Log services|#
        (service log-rotation-service-type)

        (service shepherd-system-log-service-type)

        (service log-cleanup-service-type
          (log-cleanup-configuration
            (directory "/var/log/guix/drvs")
            (expiry (* 3 30 24 3600))))

        #|Doas config service|#
        (service opendoas-service-type
          (opendoas-configuration
            (rules
              (append
                rules:general
                rules:power-management
                rules:service-management))))

        #|Device management services|#
        (service udev-service-type)

        #|Memory management services|#
        (service earlyoom-service-type
            (earlyoom-configuration
             (minimum-available-memory 10) ;; percent of RAM
             (minimum-free-swap 2))) ;; percent of swap

        #|Networking services|#
        (service static-networking-service-type
          (list %loopback-static-networking))

        #|NTPD service|#
        (service ntp-service-type)

        #|Miscellaneous services|#
        (service nscd-service-type)

        (service urandom-seed-service-type)

        (service special-files-service-type
          `(("/bin/sh"      ,(file-append bash      "/bin/bash"))
            ("/usr/bin/env" ,(file-append coreutils "/bin/env"))))

        (service sysctl-service-type
          (sysctl-configuration
            (sysctl (file-append procps "/sbin/sysctl"))
            (settings
              `(("fs.protected_hardlinks" . "1")
                ("fs.protected_symlinks"  . "1")
                ("vm.max_map_count"     . "1048576")))))))))
