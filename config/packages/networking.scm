(define-module (config packages networking)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix gexp)
  #:use-module ((guix licenses) #:prefix license:)

  #:use-module (nonguix build-system binary)

  #:use-module (gnu packages base)
  #:use-module (gnu packages gcc)
  #:use-module (gnu packages glib)
  #:use-module (gnu packages gnome)
  #:use-module (gnu packages gtk)
  #:use-module (gnu packages linux)
  #:use-module (gnu packages tls)
  #:use-module (gnu packages webkit)

  #:use-module (saayix packages gtk)

  #:export (nym-vpnc-bin
            nym-vpnd-bin
            nym-vpn-app-bin))

(define nym-vpnc-bin
  (package
    (name "nym-vpnc-bin")
    (version "2026.16.0-beta.2")
    ;; They used a dot instead of a hyphen for this package specifically -_-
    #;(source
     (origin
       (method url-fetch)
       (uri (string-append
             "https://github.com/nymtech/nym-vpn-client/releases/download/"
             "nym-vpn-v" version "/nym-vpnc_" version "_amd64.deb"))
       (sha256
        (base32 ""))))
    (source
     (origin
       (method url-fetch)
       (uri (string-append
             "https://github.com/nymtech/nym-vpn-client/releases/download/"
             "nym-vpn-" version "/nym-vpnc_2026.16.0.beta.2_amd64.deb"))
       (sha256
        (base32 "1435p8ys86a5f9g6xmqdndwg3l70n6hc6mpam8lh5ajvaqwhy76h"))))
    (build-system binary-build-system)
    (arguments
     (list
      #:patchelf-plan
      #~'(("usr/bin/nym-vpnc" ("gcc:lib" "glibc")))
      #:install-plan
      #~'(("usr/bin" "bin" #:include ("nym-vpnc"))
          ("usr/share/" "share"))))
    ;; Runtime dependencies
    (inputs
     `(("gcc:lib" ,gcc "lib")
       ("glibc" ,glibc)))
    (home-page "https://github.com/nymtech/nym-vpn-client")
    (synopsis "NymVPN command line tool.")
    (description "NymVPN command line tool.")
    (license license:gpl3)
    (supported-systems '("x86_64-linux"))))

(define nym-vpnd-bin
  (package
    (name "nym-vpnd-bin")
    (version "2026.16.0-beta.2")
    ;; They used a dot instead of a hyphen for this package specifically -_-
    #;(source
     (origin
       (method url-fetch)
       (uri (string-append
             "https://github.com/nymtech/nym-vpn-client/releases/download/"
             "nym-vpn-v" version "/nym-vpnd_" version "_amd64.deb"))
       (sha256
        (base32 ""))))
    (source
     (origin
       (method url-fetch)
       (uri (string-append
             "https://github.com/nymtech/nym-vpn-client/releases/download/"
             "nym-vpn-" version "/nym-vpnd_2026.16.0.beta.2_amd64.deb"))
       (sha256
        (base32 "1c022mzf3bh9rfx7ji6d25iy0zayg7z9q256jmdilkbfh0msf8lp"))))
    (build-system binary-build-system)
    (arguments
     (list
      #:patchelf-plan
      #~'(("usr/bin/nym-vpnd"
           ("dbus" "libmnl" "libnftnl" "gcc:lib" "glibc"))
          ("usr/bin/nym-exclude" ("gcc:lib" "glibc"))
          ("usr/bin/nym-socks5-proxy" ("gcc:lib" "glibc")))
      #:install-plan
      #~'(("usr/bin" "bin"
           #:include ("nym-vpnd" "nym-socks5-proxy" "nym-exclude"))
          ("usr/share/" "share"))))
    ;; Runtime dependencies
    (inputs
     `(("dbus" ,dbus)
       ("libmnl" ,libmnl)
       ("libnftnl" ,libnftnl)
       ("gcc:lib" ,gcc "lib")
       ("glibc" ,glibc)))
    (home-page "https://github.com/nymtech/nym-vpn-client")
    (synopsis "NymVPN daemon")
    (description "NymVPN daemon.")
    (license license:gpl3)
    (supported-systems '("x86_64-linux"))))


(define nym-vpn-app-bin
  (package
    (name "nym-vpn-app-bin")
    (version "2026.16.0-beta.2")
    (source
     (origin
       (method url-fetch)
       (uri (string-append
             "https://github.com/nymtech/nym-vpn-client/releases/download/"
             "nym-vpn-v" version "/nym-vpn-app_" version "_amd64.deb"))
       (sha256
        (base32 "1bylhnfrc3xxm875jl4rhc6531napjnvy14synrlba1lrnx1883a"))))
    (build-system binary-build-system)
    (arguments
     (list
      #:patchelf-plan
      #~'(("usr/bin/nym-vpn-app"
           ("ayatana-appindicator" "cairo" "dbus" "gcc:lib" "gdk-pixbuf"
            "glib" "glibc" "gtk+" "libsoup" "openssl" "webkitgtk")))
      #:install-plan
      #~'(("usr/bin" "bin" #:include ("nym-vpn-app"))
          ("usr/share/" "share"))))
    ;; Runtime dependencies
    (inputs
     `(("ayatana-appindicator" ,libayatana-appindicator)
       ("cairo" ,cairo)
       ("dbus" ,dbus)
       ("gcc:lib" ,gcc "lib")
       ("gdk-pixbuf" ,gdk-pixbuf)
       ("glib" ,glib)
       ("glibc" ,glibc)
       ("gtk+" ,gtk+)
       ("libsoup" ,libsoup)
       ("openssl" ,openssl)
       ("webkitgtk" ,webkitgtk-for-gtk3)))
    (home-page "https://github.com/nymtech/nym-vpn-client")
    (synopsis "NymVPN desktop client")
    (description
     "The NymVPN desktop client.  It requires the separate NymVPN daemon
(@code{nym-vpnd}) to connect.")
    (license license:gpl3)
    (supported-systems '("x86_64-linux"))))
