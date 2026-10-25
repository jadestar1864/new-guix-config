(define-module (config operating-systems thinkpadx1)
  #:use-module (guix gexp)
  #:use-module (srfi srfi-1)

  #:use-module (gnu bootloader)
  #:use-module (gnu bootloader grub)

  #:use-module (gnu services)
  #:use-module (gnu services admin)
  #:use-module (gnu services guix)
  #:use-module (gnu services linux)
  #:use-module (gnu services networking)
  #:use-module (gnu services pm)
  #:use-module (gnu services security-token)

  #:use-module (gnu system)
  #:use-module (gnu system file-systems)

  #:use-module (nongnu packages linux)
  #:use-module (nongnu system linux-initrd)

  #:use-module (config operating-systems base)

  #:use-module ((config home-environments jaden thinkpadx1)
                #:prefix home:)
  #:use-module ((config operating-systems thinkpadx1 file-systems)
                #:prefix file-systems:)
  #:use-module ((config operating-systems thinkpadx1 opendoas)
                #:prefix rules:))

(define thinkpadx1
  (operating-system
    (inherit base)
    (host-name "thinkpadx1")
    (timezone "America/Chicago")
    (bootloader
      (bootloader-configuration
        (bootloader grub-efi-bootloader)
        (targets '("/boot/efi"))
        (timeout 1)))
    (initrd microcode-initrd)

    (firmware
      (list
        sof-firmware
        linux-firmware))

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
              (list (user-cache (user "jaden"))))))
        (service guix-home-service-type
          `(("jaden" ,home:jaden-home-thinkpadx1)))

        (service zram-device-service-type
          (zram-device-configuration
            (priority 100)
            (size "16GB")
            (compression-algorithm 'lz4)))

        #|Smart card services|#
        (service pcscd-service-type)

        #|Power management services|#
        (service tlp-service-type
          (tlp-configuration
            (start-charge-thresh-bat0 70)
            (stop-charge-thresh-bat0 90)))

        #|Networking services|#
        (service iwd-service-type)

        (service network-manager-service-type
          (network-manager-configuration
            (extra-configuration-files
              `(("001-iwd.conf"
                 ,(plain-file "nm-iwd.conf"
                              "[device]\nwifi.backend=iwd\n"))))))

        (modify-services (operating-system-user-services base)
          (opendoas-service-type
            config =>
            (opendoas-configuration
              (inherit config)
              (rules
                (append rules:iwd
                        (opendoas-configuration-rules config))))))))))

thinkpadx1
