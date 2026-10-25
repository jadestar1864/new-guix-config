(define-module (config operating-systems base users)
  #:use-module (gnu system accounts)
  #:use-module (gnu packages bash)
  #:use-module (gnu packages shells)
  #:use-module (guix gexp)

  #:export (jaden
            root))

(define jaden
  (user-account
    (name "jaden")
    (password "$6$KWeB7vGKZetq2.TB$Sp3sd/9IDd5LYJQyANCxuzBWiIdSouMGgkkg8AQVl30/3I6yMoBmExm43CtSxua3K6uQHRvMbvUyVNYwy.Ld70")
    (home-directory "/home/jaden")
    (shell (file-append fish "/bin/fish"))
    (uid 1000)
    (group "users")
    (supplementary-groups
      (list "audio"
             "seat"
             "input"
             "video"
             "wheel"
             "kvm"))))

(define root
  (user-account
    (name "root")
    (password "$6$R6ihjXS6c1RQi1hm$zfUmZ7L90LrXMRJARUM8YevJWtI.Vz.x65ngkqNcFTtjv5isXZlnA7pOEf5ps31nu9oCmGCZbVy2gYoOiiGuT1")
    (home-directory "/root")
    (shell (file-append bash "/bin/bash"))
    (uid 0)
    (group "root")))
