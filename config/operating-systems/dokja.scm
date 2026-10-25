(define-module (config operating-systems dokja)
  #:use-module (gnu system)

  #:use-module (gnu services)
  #:use-module (gnu services base)
  #:use-module (gnu services networking)
  #:use-module (gnu services security)
  #:use-module (gnu services ssh)
  #:use-module (gnu services vpn)

  #:use-module (config operating-systems base))

#;(define dokja
  (operating-system
    (inherit base)
    (services
      (cons*
        (service static-networking-service-type
          (cons*
            (static-networking
              (addresses
                (list
                  (network-address
                    (device "ens6")
                    (value "66.179.137.242/24"))))
              (routes
                (list
                  (network-route
                    (destination "default")
                    (gateway "66.179.137.1"))))
              (name-servers '("9.9.9.9" "149.112.112.112" "1.1.1.1" "1.0.0.1")))
            %loopback-static-networking))

        (service fail2ban-service-type)

        (service
          (fail2ban-jail-service
           openssh-service-type
           (fail2ban-jail-configuration
            (name "sshd")
            (enabled? #t))))

        (service wireguard-service-type
          (wireguard-configuration
            (addresses '("10.169.0.1/32"))))
           
        (modify-services (operating-system-user-services base)
          (delete static-networking-service-type)
          )))
  ))

#;dokja
