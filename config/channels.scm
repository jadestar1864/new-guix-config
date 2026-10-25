(define-module (config channels)
  #:use-module (guix channels)
  #:export (%config-channels))

(define guix
  (channel
    (name 'guix)
    (url "https://codeberg.org/guix/guix")
    (branch "master")
    (introduction
      (make-channel-introduction
        "9edb3f66fd807b096b48283debdcddccfea34bad"
        (openpgp-fingerprint
          "BBB0 2DDF 2CEA F6A8 0D1D  E643 A2A0 6DF2 A33A 54FA")))))

(define guix-surface
  (channel
    (name 'surface)
    (url "https://codeberg.org/Dariqq/guix-surface")
    (branch "master")
    (introduction
     (make-channel-introduction
      "9d0cdec8faa1450afc6f437c088bc8929ccdc0a3"
      (openpgp-fingerprint
       "12F3 9DE4 3608 FC37 F146 407A 8386 A528 1605 3118")))))

(define nonguix
  (channel
    (name 'nonguix)
    (url "https://gitlab.com/nonguix/nonguix")
    (branch "master")
    (introduction
      (make-channel-introduction
        "897c1a470da759236cc11798f4e0a5f7d4d59fbc"
        (openpgp-fingerprint
          "2A39 3FFF 68F4 EF7A 3D29  12AF 6F51 20A0 22FB B2D5")))))

(define sops-guix
  (channel
    (name 'sops-guix)
    (url "https://github.com/fishinthecalculator/sops-guix.git")
    (branch "main")
    (introduction
      (make-channel-introduction
        "0bbaf1fdd25266c7df790f65640aaa01e6d2dbc9"
        (openpgp-fingerprint
          "8D10 60B9 6BB8 292E 829B  7249 AED4 1CC1 93B7 01E2")))))

;; For Niri configuration file
(define rosenthal
    (channel
    (name 'rosenthal)
    (url "https://codeberg.org/hako/rosenthal.git")
    (branch "trunk")
    (introduction
      (make-channel-introduction
        "7677db76330121a901604dfbad19077893865f35"
        (openpgp-fingerprint
          "13E7 6CD6 E649 C28C 3385  4DF5 5E5A A665 6149 17F7")))))

;; For Zen Browser
(define saayix
  (channel
    (name 'saayix)
    (branch "main")
    (url "https://codeberg.org/look/saayix.git")
    (introduction
      (make-channel-introduction
        "12540f593092e9a177eb8a974a57bb4892327752"
        (openpgp-fingerprint
          "3FFA 7335 973E 0A49 47FC  0A8C 38D5 96BE 07D3 34AB")))))

(define pantherx
  (channel
    (name 'pantherx)
    (url "https://codeberg.org/gofranz/panther.git")
    ;; Enable signature verification
    (introduction
     (make-channel-introduction
      "54b4056ac571611892c743b65f4c47dc298c49da"
      (openpgp-fingerprint
       "A36A D41E ECC7 A871 1003  5D24 524F EB1A 9D33 C9CB")))))

(define %config-channels
  (list
    guix
    guix-surface
    nonguix
    sops-guix
    rosenthal
    saayix
    pantherx))

%config-channels
