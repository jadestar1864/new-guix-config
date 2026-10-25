(define-module (config operating-systems base opendoas)
  #:use-module (gnu services admin)
  #:export (general
            power-management
            service-management))

(define general
  (list (opendoas-permit-rule
          (identity ":wheel")
          (setenv
            `(("GUILE_LOAD_PATH" . #t)
              ("GUILE_LOAD_COMPILED_PATH" . #t)
              ("TERM" . "linux"))))))

(define power-management
  (map (lambda (cmd)
         (opendoas-permit-rule
           (identity ":wheel")
           (nopass? #t)
           (command cmd)
           (args '())))
       `("zzz" "halt" "reboot")))

(define service-management
  (map (lambda (action)
        (opendoas-permit-rule
          (identity ":wheel")
          (nopass? #t)
          (command "herd")
          (args (list action))))
       `("status" "detailed-status")))
