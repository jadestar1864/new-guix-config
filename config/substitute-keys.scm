(define-module (config substitute-keys)
  #:use-module (gnu)
  #:export (guix.pub
            bordeaux.pub
            moe.pub
            nonguix.pub))

(define guix.pub
  (plain-file "guix.pub"
    "(public-key
       (ecc
         (curve Ed25519)
         (q #8D156F295D24B0D9A86FA5741A840FF2D24F60F7B6C4134814AD55625971B394#)))"))

(define bordeaux.pub
  (plain-file "bordeaux.pub"
    "(public-key
       (ecc
         (curve Ed25519)
         (q #7D602902D3A2DBB83F8A0FB98602A754C5493B0B778C8D1DD4E0F41DE14DE34F#)))"))

(define moe.pub
  (plain-file "guix.moe.pub"
    "(public-key
       (ecc
         (curve Ed25519)
         (q #C1FD53E5D4CE971933EC50C9F307AE2171A2D3B52C804642A7A35F84F3A4EA98#)))"))
