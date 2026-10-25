(define-module (config operating-systems nebula-arcanum)
  #:use-module (gnu bootloader)
  #:use-module (gnu bootloader grub)

  #:use-module (gnu packages window-management)

  #:use-module (gnu services)
  #:use-module (gnu services admin)
  #:use-module (gnu services guix)
  #:use-module (gnu services linux)
  #:use-module (gnu services networking)
  #:use-module (gnu services pm)

  #:use-module (gnu system)
  #:use-module (gnu system file-systems)

  #:use-module (nongnu packages linux)
  #:use-module (nongnu system linux-initrd)

  #:use-module (surface packages linux)

  #:use-module (config operating-systems base-desktop)
  #:use-module ((config operating-systems shared files)
                #:prefix files:)
  #:use-module ((config operating-systems shared users)
                #:prefix user:)
  #:use-module ((config operating-systems nebula-arcanum file-systems)
                #:prefix file-systems:)
  #:use-module ((config operating-systems shared opendoas)
                #:prefix rules:)

  ;; Imports for ethan home because importing both homes makes one of them unbound FOR SOME REASON
  #:use-module (gnu home)
  #:use-module (gnu home services)

  #:use-module ((config home-environments base)
                #:prefix home:))

;; REMINDER: KEEP UPDATED WITH config/home-environments/ethan.scm
(define-public home-ethan
  (home-environment
    (inherit home:base)
    (services
      (cons*
        (simple-service 'ethan-env-vars
                        home-environment-variables-service-type
                        `(("BROWSER" . "zen")))
        (home-environment-user-services home:base)))))

(define-public nebula-arcanum
  (operating-system
    (inherit base-desktop)
    (host-name "nebula-arcanum")

    (timezone "America/Chicago")

    (bootloader
      (bootloader-configuration
        (bootloader grub-efi-bootloader)
        (targets '("/boot/efi"))
        (timeout 1)))

    (kernel linux-surface)
    (initrd microcode-initrd)
    (firmware (list linux-firmware))

    (packages
      (cons*
        #|window-management|# niri
        (operating-system-packages base-desktop)))

    (users
      (cons*
        user:ethan
        (operating-system-users base-desktop)))
  
    (mapped-devices file-systems:%mapped-devices)

    (file-systems file-systems:%volumes)

    (swap-devices
      (list
        (swap-space
          (target "/swap/swapfile")
          (dependencies (filter (file-system-mount-point-predicate "/swap")
                                file-systems)))))

    (services
      (cons*
        #|Guix services|#
        (service shared-cache-service-type
          (shared-cache-configuration
            (users
              (list
                (user-cache (user "jaden"))
                (user-cache (user "ethan"))))))
        (simple-service 'ethan-home
                        guix-home-service-type
                        `(("ethan" ,home-ethan)))

        (service zram-device-service-type
          (zram-device-configuration
            (priority 100)
            (size "16GB")
            (compression-algorithm 'lz4)))

        #|Power management services|#
        (service tlp-service-type
          (tlp-configuration
            (start-charge-thresh-bat0 70)
            (stop-charge-thresh-bat0 90)))

        #|Networking services|#
        (service iwd-service-type)

        (service nftables-service-type
          (nftables-configuration
            (ruleset (files:nftables-conf-file #:mdns #t))))

        (modify-services (operating-system-user-services base-desktop)
          (delete nftables-service-type)
          (opendoas-service-type
            config =>
            (opendoas-configuration
              (inherit config)
              (rules
                (append rules:iwd
                        (opendoas-configuration-rules config)))))
          (network-manager-service-type
            config =>
            (network-manager-configuration
              (inherit config)
              (extra-configuration-files
                (cons*
                  files:network-manager-iwd-conf
                  files:%base-network-manager-extra-configuration-files)))))))))

nebula-arcanum
