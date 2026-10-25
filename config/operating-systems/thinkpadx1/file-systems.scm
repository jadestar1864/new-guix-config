(define-module (config operating-systems thinkpadx1 file-systems)
  #:use-module (gnu system file-systems)
  #:use-module (gnu system mapped-devices)

  #:export (%volumes
            %mapped-devices))

(define %mapped-devices
  (list
    (mapped-device
      (source (uuid "FA7F07D5-166E-4632-B359-7A5960AA6EF4"))
      (target "cryptroot")
      (type luks-device-mapping)
      (arguments '(#:allow-discards? #t)))))

(define boot-efi
  (file-system
    (device "/dev/nvme0n1p1")
    (type "vfat")
    (mount-point "/boot/efi")
    (options "umask=0077")))

(define boot
  (file-system
    (device "/dev/mapper/cryptroot")
    (type "btrfs")
    (mount-point "/boot")
    (needed-for-boot? #t)
    (options "compress-force=zstd,space_cache=v2,subvol=@boot,discard=async,ssd")
    (dependencies %mapped-devices)))

(define root
  (file-system
    (device "/dev/mapper/cryptroot")
    (type "btrfs")
    (mount-point "/")
    (flags '(no-atime))
    (needed-for-boot? #t)
    (options "compress-force=zstd,space_cache=v2,subvol=@,discard=async,ssd")
    (dependencies %mapped-devices)))

(define home
  (file-system
    (device "/dev/mapper/cryptroot")
    (type "btrfs")
    (mount-point "/home")
    (flags '(no-atime no-dev))
    (options "compress-force=zstd,space_cache=v2,subvol=@home,discard=async,ssd")
    (dependencies %mapped-devices)))

(define gnu
  (file-system
    (device "/dev/mapper/cryptroot")
    (type "btrfs")
    (mount-point "/gnu")
    (flags '(no-atime))
    (options "compress-force=zstd,space_cache=v2,subvol=@gnu,discard=async,ssd")
    (dependencies %mapped-devices)))

(define var
  (file-system
    (device "/dev/mapper/cryptroot")
    (type "btrfs")
    (mount-point "/var")
    (flags '(no-atime))
    (options "compress-force=zstd,space_cache=v2,subvol=@var,discard=async,ssd")
    (dependencies %mapped-devices)))

(define var-log
  (file-system
    (device "/dev/mapper/cryptroot")
    (type "btrfs")
    (mount-point "/var/log")
    (flags '(no-atime))
    (options "compress-force=zstd,space_cache=v2,subvol=@varlog,discard=async,ssd")
    (dependencies %mapped-devices)))

(define var-tmp
  (file-system
    (device "/dev/mapper/cryptroot")
    (type "btrfs")
    (mount-point "/var/tmp")
    (flags '(no-atime no-dev no-suid))
    (options "compress-force=zstd,space_cache=v2,subvol=@vartmp,discard=async,ssd")
    (dependencies %mapped-devices)))

(define swap
  (file-system
    (device "/dev/mapper/cryptroot")
    (type "btrfs")
    (mount-point "/swap")
    (flags '(no-atime))
    (options "subvol=@swap,discard=async,ssd")
    (dependencies %mapped-devices)))

(define %volumes
  (cons* boot-efi
         boot
         root
         home
         gnu
         var
         var-log
         var-tmp
         swap
         %base-file-systems))
