Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932105Ab3INOME (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Sep 2013 10:12:04 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43170 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756512Ab3INOMC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Sep 2013 10:12:02 -0400
Date: Sat, 14 Sep 2013 07:12:18 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.0.96
Message-ID: <20130914141218.GA11904@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mYCpIKhGyMATD0i+"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mYCpIKhGyMATD0i+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

I'm announcing the release of the 3.0.96 kernel.

All users of the 3.0 kernel series must upgrade.

The updated 3.0.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-3.0.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                           |    2 +-
 arch/m32r/boot/compressed/Makefile |    6 +++---
 arch/m32r/boot/compressed/misc.c   |   12 +++++++++++-
 arch/s390/kvm/kvm-s390.c           |   17 +++++++++++------
 drivers/net/tun.c                  |    6 ++++--
 drivers/parisc/iommu-helpers.h     |    2 ++
 drivers/pci/Makefile               |    1 +
 include/linux/icmpv6.h             |    2 ++
 include/linux/ipv6.h               |    1 +
 net/bridge/br_multicast.c          |    3 ++-
 net/core/sysctl_net_core.c         |    7 ++++++-
 net/ipv4/fib_trie.c                |    5 +----
 net/ipv4/tcp_cubic.c               |   12 +++++++-----
 net/ipv6/addrconf.c                |   10 ++++------
 net/ipv6/icmp.c                    |   10 +++++++++-
 net/ipv6/ip6_fib.c                 |   16 ++++++++++++----
 net/ipv6/ndisc.c                   |   16 +++++++++-------
 net/ipv6/reassembly.c              |    5 +++++
 net/sched/sch_htb.c                |    2 +-
 net/tipc/eth_media.c               |   15 ++++++++++++++-
 20 files changed, 106 insertions(+), 44 deletions(-)

Cong Wang (1):
      PARISC: include <linux/prefetch.h> in drivers/parisc/iommu-helpers.h

Dan Carpenter (1):
      tun: signedness bug in tun_get_user()

Daniel Borkmann (1):
      net: bridge: convert MLDv2 Query MRC into msecs_to_jiffies for max_delay

Dominik Dingel (1):
      KVM: s390: move kvm_guest_enter,exit closer to sie

Eric Dumazet (3):
      fib_trie: remove potential out of bound access
      tcp: cubic: fix overflow error in bictcp_update()
      tcp: cubic: fix bug in bictcp_acked()

Geert Uytterhoeven (3):
      m32r: consistently use "suffix-$(...)"
      m32r: add memcpy() for CONFIG_KERNEL_GZIP=y
      m32r: make memset() global for CONFIG_KERNEL_BZIP2=y

Greg Kroah-Hartman (1):
      Linux 3.0.96

Hannes Frederic Sowa (3):
      ipv6: don't stop backtracking in fib6_lookup_1 if subtree does not match
      ipv6: remove max_addresses check from ipv6_create_tempaddr
      ipv6: drop packets with multiple fragmentation headers

Jiri Bohac (1):
      ICMPv6: treat dest unreachable codes 5 and 6 as EACCES, not EPROTO

Paul Gortmaker (1):
      pci: frv architecture needs generic setup-bus infrastructure

Roman Gushchin (1):
      net: check net.core.somaxconn sysctl values

Thomas Graf (1):
      ipv6: Don't depend on per socket memory for neighbour discovery messages

Ying Xue (1):
      tipc: fix lockdep warning during bearer initialization

stephen hemminger (1):
      htb: fix sign extension bug


--mYCpIKhGyMATD0i+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSNG7CAAoJEDjbvchgkmk+PdoP/RpjFtZ9F1P8iaqHt91INsR8
dnX3cJ8uWwNkNtxVTunIlwNGPRPqKZCQBUIzLSBflZsBKIepIOk4xAoNyAbCNOd/
QvNH3Pem/G69vTzyJTRPQMew80iXWb+/4YHz5r10cHvVFAvgCwu6O41f/4jMW8Nc
Toub3N8rVCodUzw/HdR920Q9HvI4FqbpmzNeB2iRFIe1fw8u4ZX4kT9IatKqA20S
WbHzpZQ6jWNtsHF6Ab+7VDOJ6Siw+zxWRgTjkRnvkNSQARyAbDOy3gANm/Ge21PC
tOV7z1msbjeu4Ip+y2GrsSws1CknRNC3xUWlowcIyXf6MPrenYz2/QfnxkYxYsdV
fchmEvdsAOMDHn/fgu9xveLh16gGQchnj4NxSMGWdzsl0EUSIopx/x3KAHK/93Lc
+qESFJm6Vo/hjL3mCGbpU23x6UZMs3VhUYX1Fx7qQBqcBdQ2q0fL0Zm1qdZokqYJ
d8qLbgqaXmg+F34OlldAhyhj87y70SyjVslZnCTNAmrnOKX2atdTyamiOR6wGZYM
au5WRNiNVuCz0FASl3+2LX615Yx+vEgvqtNDx7rlnHTn9sRKMUjvHbqb1KUZzqzl
HxB57cTcTNhQgBTEfFK3rLkU0g6Y6mPNcq7Lp7GwJc8mZcGH28sl642u/uwLuAbc
wrbbKdJbg5WGaFmSW6AO
=0ioZ
-----END PGP SIGNATURE-----

--mYCpIKhGyMATD0i+--
