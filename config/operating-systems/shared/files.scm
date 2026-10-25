(define-module (config operating-systems shared files)
  #:use-module (guix gexp)
  
  #:export (%base-network-manager-extra-configuration-files
            network-manager-iwd-conf
            nftables-conf-file))

(define %base-network-manager-extra-configuration-files
  `(("rc-manager.conf"
     ,(plain-file "nm-rc-manager.conf"
                  "[main]\nrc-manager=resolvconf\n"))))

(define network-manager-iwd-conf
  (list
    "001-iwd.conf"
    (plain-file "nm-iwd.conf"
                "[device]\nwifi.backend=iwd\n")))

(define* (nftables-conf-file #:key (ssh #t) (mdns #f))
  (plain-file "nftables.conf" (string-append
    "\
table inet filter {
	chain input {
		type filter hook input priority 0; policy drop;

		ct state invalid drop comment \"Drop invalid connections\"

		ct state { established, related } accept comment \"Accept traffic originated from us\"

		iif lo accept comment \"Accept any localhost traffic\"
    iif != lo ip daddr 127.0.0.1/8 drop comment \"Drop connections to localhost not from localhost\"
    iif != lo ip6 daddr ::1/128 drop comment \"Drop connections to localhost not from localhost\"

		meta l4proto { icmp, ipv6-icmp } accept comment \"Accept ICMP\""

    (if mdns
      "
    udp dport mdns ip6 daddr ff02::fb accept comment \"Accept mDNS\"
		udp dport mdns ip daddr 224.0.0.251 accept comment \"Accept mDNS\""
      "")

    (if ssh
      "
		tcp dport ssh accept comment \"allow sshd\""
      "")

    "
		counter comment \"Count any other traffic\"

    reject with icmpx type port-unreachable
	}

	chain forward {
    # Drop forwarded packets because we do not forward
		type filter hook forward priority 0; policy drop;
	}

	chain output {
		# Accept every outbound connection
		type filter hook output priority 0; policy accept;
	}
}")))
