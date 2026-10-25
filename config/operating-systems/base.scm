(define-module (config operating-systems base)
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
  #:use-module (gnu services desktop)
  #:use-module (gnu services linux)
  #:use-module (gnu services networking)
  #:use-module (gnu services shepherd)
  #:use-module (gnu services sysctl)

  #:use-module (gnu system keyboard)

  #:use-module (nongnu packages linux)

  #:use-module ((config channels)
                #:prefix channels:)
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
      (cons*
        (service guix-service-type
          (guix-configuration
            (channels channels:%config-channels)
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

        #|Garbage collector job|#
        (simple-service 'guix-gc-timer
                        shepherd-root-service-type
                        (list garbage-collection-timer))

        #|Doas config service|#
        (service opendoas-service-type
          (opendoas-configuration
            (rules
              (append
                rules:general
                rules:power-management
                rules:service-management))))

        #|Memory management services|#
        (service earlyoom-service-type
            (earlyoom-configuration
             (minimum-available-memory 10) ;; percent of RAM
             (minimum-free-swap 2))) ;; percent of swap

        #|Networking services|#
        (service nftables-service-type)

        (modify-services %base-services
          (delete guix-service-type)
          (sysctl-service-type
            config =>
            (sysctl-configuration
              (inherit config)
              (settings
                (append
                  (sysctl-configuration-settings config)
                  `(("vm.max_map_count"       . "1048576")))))))))))
