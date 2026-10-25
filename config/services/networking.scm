(define-module (config services networking)
  #:use-module (gnu services)
  #:use-module (gnu services dbus)
  #:use-module (gnu services shepherd)

  #:use-module (gnu system accounts)
  #:use-module (gnu system shadow)

  #:use-module (guix gexp)

  #:use-module (config packages networking)
  
  #:export (nym-vpn-service-type))

(define (nym-vpn-profile-packages _config)
  (list
    nym-vpnc-bin
    nym-vpnd-bin
    nym-vpn-app-bin))

(define (nym-vpn-shepherd-service _config)
  (list
   (shepherd-service
     (documentation "Run the NymVPN daemon.")
     (provision '(nym-vpn))
     (requirement '(NetworkManager user-processes))
     (respawn? #t)
     (respawn-limit #~'(6 . 24))
     (respawn-delay 2)
     (start #~(make-forkexec-constructor
                (list #$(file-append nym-vpnd-bin "/bin/nym-vpnd")
                      "-v" "run-as-service")))
     (stop #~(make-kill-destructor)))))

;; Taken from the polkit action nym-vpnd installs at runtime
(define nym-polkit-policy
  (plain-file
   "com.nymvpn.vpnd.unix-access.policy"
   "<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<policyconfig>
  <action id=\"com.nymvpn.vpnd.unix-access\">
    <description>Connect via unix socket</description>
    <message>Authentication is required to connect to the daemon</message>
    <defaults>
      <allow_any>auth_admin</allow_any>
      <allow_inactive>auth_admin</allow_inactive>
      <allow_active>auth_self</allow_active>
    </defaults>
  </action>
</policyconfig>
"))

(define nym-polkit-files
  (file-union
   "nym-polkit"
   `(("share/polkit-1/actions/com.nymvpn.vpnd.unix-access.policy"
      ,nym-polkit-policy))))

(define nym-vpn-service-type
  (service-type
   (name 'nym-vpn)
   (extensions
    (list
      (service-extension shepherd-root-service-type
                         nym-vpn-shepherd-service)
      (service-extension profile-service-type
                         nym-vpn-profile-packages)
      (service-extension account-service-type
                         (const (list
                                 (user-group
                                  (name "nym-vpn")))))
      (service-extension polkit-service-type
                         (const (list nym-polkit-files)))))
   (default-value #f)
   (description "Run the NymVPN daemon and packages to the system profile.")))
