(define-module (config operating-systems thinkpadx1 opendoas)
  #:use-module (gnu services admin)

  #:export (iwd))

(define iwd
  (map (lambda (action)
         (opendoas-permit-rule
           (identity ":wheel")
           (nopass? #t)
           (command "herd")
           (args `(,action "iwd"))))
       `("start" "stop" "restart" "status" "enable" "disable" "doc")))
