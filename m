Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756664Ab3INOOl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Sep 2013 10:14:41 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43181 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756510Ab3INOOk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Sep 2013 10:14:40 -0400
Date: Sat, 14 Sep 2013 07:14:56 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.4.62
Message-ID: <20130914141456.GA11969@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Q68bSM7Ycu6FN28Q"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Q68bSM7Ycu6FN28Q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.4.62 kernel.

All users of the 3.4 kernel series must upgrade.

The updated 3.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-3.4.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dsu=
mmary

thanks,

greg k-h

------------

 Makefile                              |    2 -
 arch/m32r/boot/compressed/Makefile    |    6 +--
 arch/m32r/boot/compressed/misc.c      |   12 ++++++
 arch/x86/kvm/emulate.c                |    4 --
 drivers/net/bonding/bond_main.c       |    8 +++-
 drivers/net/ethernet/realtek/8139cp.c |    1=20
 drivers/net/macvtap.c                 |   62 ++++++++++++++++++++---------=
-----
 drivers/net/tun.c                     |    6 ++-
 drivers/vhost/vhost.c                 |    1=20
 include/linux/icmpv6.h                |    2 +
 include/linux/ipv6.h                  |    1=20
 net/bridge/br_multicast.c             |    3 +
 net/core/neighbour.c                  |   10 +++--
 net/core/sysctl_net_core.c            |    7 +++
 net/ipv4/fib_trie.c                   |    5 --
 net/ipv4/tcp_cubic.c                  |   12 +++---
 net/ipv6/addrconf.c                   |   10 ++---
 net/ipv6/icmp.c                       |   10 ++++-
 net/ipv6/ip6_fib.c                    |   16 ++++++--
 net/ipv6/ndisc.c                      |   16 ++++----
 net/ipv6/reassembly.c                 |    5 ++
 net/ipv6/tcp_ipv6.c                   |    2 -
 net/sched/sch_htb.c                   |    2 -
 net/tipc/eth_media.c                  |   15 +++++++-
 24 files changed, 145 insertions(+), 73 deletions(-)

Dan Carpenter (1):
      tun: signedness bug in tun_get_user()

Daniel Borkmann (2):
      net: bridge: convert MLDv2 Query MRC into msecs_to_jiffies for max_de=
lay
      net: ipv6: tcp: fix potential use after free in tcp_v6_do_rcv

Dave Jones (1):
      8139cp: Fix skb leak in rx_status_loop failure path.

Eric Dumazet (3):
      fib_trie: remove potential out of bound access
      tcp: cubic: fix overflow error in bictcp_update()
      tcp: cubic: fix bug in bictcp_acked()

Geert Uytterhoeven (3):
      m32r: consistently use "suffix-$(...)"
      m32r: add memcpy() for CONFIG_KERNEL_GZIP=3Dy
      m32r: make memset() global for CONFIG_KERNEL_BZIP2=3Dy

Greg Kroah-Hartman (2):
      Revert "KVM: X86 emulator: fix source operand decoding for 8bit mov[z=
s]x instructions"
      Linux 3.4.62

Hannes Frederic Sowa (3):
      ipv6: don't stop backtracking in fib6_lookup_1 if subtree does not ma=
tch
      ipv6: remove max_addresses check from ipv6_create_tempaddr
      ipv6: drop packets with multiple fragmentation headers

Jason Wang (2):
      vhost: zerocopy: poll vq in zerocopy callback
      macvtap: do not zerocopy if iov needs more pages than MAX_SKB_FRAGS

Jiri Bohac (1):
      ICMPv6: treat dest unreachable codes 5 and 6 as EACCES, not EPROTO

Roman Gushchin (1):
      net: check net.core.somaxconn sysctl values

Thomas Graf (1):
      ipv6: Don't depend on per socket memory for neighbour discovery messa=
ges

Veaceslav Falico (2):
      neighbour: populate neigh_parms on alloc before calling ndo_neigh_set=
up
      bonding: modify only neigh_parms owned by us

Ying Xue (1):
      tipc: fix lockdep warning during bearer initialization

stephen hemminger (1):
      htb: fix sign extension bug


--Q68bSM7Ycu6FN28Q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSNG9gAAoJEDjbvchgkmk+cOwP/Atr/9S7mspEPAZMO3bdwX9p
EOQ/m9Kpg54NHyBxYlB5nhJE6/V3O4u2uqAq83vU9WxLq7a0x78f+3zmT/D6Qirl
2GctmcOK2oaE4FuYD3Zk3j/nMSZdbERJ272LAL4PsFkEZaKdetaxEkiaeF+aJBr5
M32jxp8UsU44beXCrhmDdOryX+uBGQYTNEaw1pGx7vMr1euIGVIsHAoug3yqZf4Z
FQkjIOjFNK8aeYeOhkMR47bDA//toYOo9fjX3t12RbKFuzMbX3MCR+7JIK1/MsZF
TVqS0JOGZENz64+WzFX95S/Kg7erD+7+UG6VBq/6Mmg7V/12bQNPnJUXznjtCqXV
wOdITgfkM/atzXuK74KUnMhoH6t1tt2QswHuAwy41IxLdVFe00z+mf41VxYdAdYD
k6QtYTdTqqKw9WkJCv1RmFRRmCrFqUikBSmC97GX3tCeQxOI5U0/jokg/q+nuUTE
2Ynbyb1klHczAr2p6IL6iMYFdnM9QSR9DiSnEwg7RJrPpTfapY25Tm6OnndxBypS
E16XmtNpIwI5H/YxhswIKVtfLIeTigahZI9NQARPC818c2hznoNTfGmurmJ9onFT
PiL7outTmPhACOiCayppe8J8aPuVQZpbK9Lg0t4QmoAB1xmsaR+WWuWc5A6bHqex
fWAPqh66czx7BHrEQdGW
=sn3S
-----END PGP SIGNATURE-----

--Q68bSM7Ycu6FN28Q--
