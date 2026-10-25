(define-module (config packages cups)
  #:use-module (gnu packages autotools)
  #:use-module (gnu packages cups)
  #:use-module (gnu packages package-management)

  #:use-module (guix build-system gnu)
  #:use-module (guix download)
  #:use-module (guix gexp)
  #:use-module (guix git-download)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix packages))

(define-public epson-inkjet-printer-escpr2
  (package
    (name "epson-inkjet-printer-escpr2")
    (version "1.2.37")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "https://download-center.epson.com/f/module/1316b6b0-77cd-438c-95e1-c71e760a7579/epson-inkjet-printer-escpr2-"
                           version "-1.tar.gz"))
       (sha256
        (base32 "038xjcjnx5bv32n1k671bq2affg5acfi5gph4yc41xzqaqfpca4d"))
       ;; Fixes "implicit declaration of function" errors
       (patches
        (list
          (origin
            (method url-fetch)
            (uri "https://aur.archlinux.org/cgit/aur.git/plain/bug_x86_64.patch?h=epson-inkjet-printer-escpr2&id=8fbca325d6d39fa3ffe001f90a432380bdeacc2f")
            (file-name "epson-escpr2-fix-implicit-declaration-of-functions.patch")
            (sha256
              (base32 "02j3c2ykngkcqw3hq3bwlkhbhraxgq23l10zwgbp7j7aglms7isp")))))))
    (build-system gnu-build-system)
    (arguments
     (list
      #:configure-flags
      #~(list (string-append "--with-cupsfilterdir="
                             #$output "/lib/cups/filter")
              (string-append "--with-cupsppddir="
                             #$output "/share/cups/model"))
      #:phases
      #~(modify-phases %standard-phases
          (add-after 'unpack 'bootstrap
            (lambda _
              (invoke "autoreconf" "-vfi"))))))
    (native-inputs
     (list autoconf automake libtool))
    (inputs
     (list cups))
    (synopsis "ESC/P-R 2 driver for Epson inkjet printers")
    (description
     "Epson Inkjet Printer Driver 2 (ESC/P-R 2) for Linux and the corresponding PPD files.  Refer to the description of epson-escpr for usage.")
    (home-page "http://download.ebz.epson.net/dsc/search/01/search/")
    (license license:gpl2+)))
