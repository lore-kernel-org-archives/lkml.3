Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755441AbaDNS5B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 14:57:01 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48904 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755422AbaDNS4x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 14:56:53 -0400
Date: Mon, 14 Apr 2014 11:59:51 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.13.10
Message-ID: <20140414185951.GA25168@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bp/iNruPH9dso1Pn"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--bp/iNruPH9dso1Pn
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

NOTE

This is going to be the next-to-last 3.13.y kernel release.  Please move
to 3.14.y as soon as possible.

--------------


I'm announcing the release of the 3.13.10 kernel.

All users of the 3.13 kernel series must upgrade.

The updated 3.13.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-3.13.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dsu=
mmary

thanks,

greg k-h

------------

 Documentation/devicetree/bindings/net/micrel-ks8851.txt |    1=20
 Makefile                                                |    2=20
 arch/arc/boot/dts/nsimosci.dts                          |   12 -
 arch/arc/configs/nsimosci_defconfig                     |    1=20
 arch/m68k/Kconfig                                       |    1=20
 arch/s390/Kconfig                                       |    1=20
 arch/x86/crypto/ghash-clmulni-intel_asm.S               |   29 ---
 arch/x86/crypto/ghash-clmulni-intel_glue.c              |   14 +
 drivers/cpufreq/powernow-k6.c                           |  147 +++++++++++=
++---
 drivers/isdn/isdnloop/isdnloop.c                        |   23 +-
 drivers/net/bonding/bond_alb.c                          |    2=20
 drivers/net/ethernet/broadcom/bnx2.c                    |   37 +++-
 drivers/net/ethernet/broadcom/bnx2.h                    |    5=20
 drivers/net/ethernet/broadcom/tg3.c                     |    5=20
 drivers/net/ethernet/freescale/fec_main.c               |   14 -
 drivers/net/ethernet/micrel/ks8851.c                    |   30 +++
 drivers/net/ethernet/sfc/ef10.c                         |    7=20
 drivers/net/ethernet/sfc/efx.c                          |    3=20
 drivers/net/usb/cdc_ncm.c                               |   48 ++---
 drivers/net/usb/usbnet.c                                |   33 ++-
 drivers/net/virtio_net.c                                |    6=20
 drivers/net/vxlan.c                                     |  136 +++++++++++=
++-
 drivers/net/xen-netback/common.h                        |    5=20
 drivers/net/xen-netback/interface.c                     |   11 +
 drivers/net/xen-netback/netback.c                       |   54 +++--
 drivers/vhost/net.c                                     |   20 ++
 include/linux/futex.h                                   |    4=20
 include/linux/usb/cdc_ncm.h                             |    1=20
 include/linux/usb/usbnet.h                              |    2=20
 include/net/sock.h                                      |    5=20
 include/net/tcp.h                                       |   11 -
 init/Kconfig                                            |    7=20
 kernel/futex.c                                          |   14 +
 lib/nlattr.c                                            |   10 -
 net/8021q/vlan.c                                        |    4=20
 net/8021q/vlan_dev.c                                    |    6=20
 net/bridge/br_multicast.c                               |   33 +++
 net/core/netpoll.c                                      |    2=20
 net/core/rtnetlink.c                                    |   10 -
 net/core/skbuff.c                                       |  105 +++++------
 net/core/sock.c                                         |    5=20
 net/ipv4/gre_demux.c                                    |    8=20
 net/ipv4/inet_fragment.c                                |    5=20
 net/ipv4/ip_tunnel.c                                    |    3=20
 net/ipv4/ip_tunnel_core.c                               |    1=20
 net/ipv4/ipmr.c                                         |   13 -
 net/ipv4/tcp_ipv4.c                                     |    2=20
 net/ipv4/tcp_output.c                                   |   11 +
 net/ipv6/addrconf.c                                     |    5=20
 net/ipv6/exthdrs_offload.c                              |    4=20
 net/ipv6/icmp.c                                         |    2=20
 net/ipv6/ip6_output.c                                   |   18 -
 net/ipv6/ip6mr.c                                        |   13 -
 net/ipv6/mcast.c                                        |   11 -
 net/ipv6/ping.c                                         |    4=20
 net/ipv6/route.c                                        |    2=20
 net/rds/iw.c                                            |    3=20
 net/sched/sch_fq.c                                      |   28 ++-
 net/sctp/sm_make_chunk.c                                |    4=20
 net/sctp/sm_statefuns.c                                 |    5=20
 net/socket.c                                            |    4=20
 net/tipc/config.c                                       |    9=20
 net/tipc/handler.c                                      |    1=20
 net/tipc/name_table.c                                   |   37 +++-
 net/tipc/server.c                                       |   14 -
 net/tipc/subscr.c                                       |   48 +----
 net/unix/af_unix.c                                      |   17 +
 security/selinux/hooks.c                                |   36 ++-
 68 files changed, 814 insertions(+), 360 deletions(-)

Annie Li (1):
      Xen-netback: Fix issue caused by using gso_type wrongly

Anton Nayshtut (1):
      ipv6: Fix exthdrs offload registration.

Ard Biesheuvel (1):
      crypto: ghash-clmulni-intel - use C implementation for setkey()

Bj=F8rn Mork (1):
      net: cdc_ncm: fix control message ordering

Dan Carpenter (1):
      isdnloop: several buffer overflows

Daniel Borkmann (1):
      net: sctp: fix skb leakage in COOKIE ECHO path of chunk->auth_chunk

Daniel Pieczko (1):
      Call efx_set_channels() before efx->type->dimension_resources()

David Stevens (2):
      vxlan: fix potential NULL dereference in arp_reduce()
      vxlan: fix nonfunctional neigh_reduce()

Eric Dumazet (5):
      net: unix: non blocking recvmsg() should not return -EINTR
      pkt_sched: fq: do not hold qdisc lock while allocating memory
      tcp: tcp_release_cb() should release socket ownership
      tcp: syncookies: do not use getnstimeofday()
      tcp: fix get_timewait4_sock() delay computation on 64bit

Erik Hugne (4):
      tipc: drop subscriber connection id invalidation
      tipc: fix memory leak during module removal
      tipc: don't log disabled tasklet handler errors
      tipc: fix spinlock recursion bug for failed subscriptions

Finn Thain (1):
      m68k: Skip futex_atomic_cmpxchg_inatomic() test

Florian Westphal (1):
      inet: frag: make sure forced eviction removes all frags

Greg Kroah-Hartman (1):
      Linux 3.13.10

Hannes Frederic Sowa (1):
      ipv6: some ipv6 statistic counters failed to disable bh

Heiko Carstens (1):
      futex: Allow architectures to skip futex_atomic_cmpxchg_inatomic() te=
st

Heiner Kallweit (1):
      ipv6: Avoid unnecessary temporary addresses being generated

Jason Wang (1):
      virtio-net: correct error handling of virtqueue_kick()

Li RongQing (1):
      netpoll: fix the skb check in pkt_is_ns

Linus L=FCssing (3):
      bridge: multicast: add sanity check for query source addresses
      bridge: multicast: add sanity check for general query destination
      bridge: multicast: enable snooping on general queries only

Matthew Leach (1):
      net: socket: error on a negative msg_namelen

Michael Chan (1):
      bnx2: Fix shutdown sequence

Michael S. Tsirkin (7):
      skbuff: skb_segment: s/frag/nskb_frag/
      skbuff: skb_segment: s/skb_frag/frag/
      skbuff: skb_segment: s/skb/head_skb/
      skbuff: skb_segment: s/fskb/list_skb/
      skbuff: skb_segment: orphan frags before copying
      vhost: fix total length when packets are too short
      vhost: validate vhost_get_vq_desc return value

Mike Rapoport (1):
      net: vxlan: fix crash when interface is created with no group

Mikulas Patocka (3):
      powernow-k6: disable cache when changing frequency
      powernow-k6: correctly initialize default parameters
      powernow-k6: reorder frequencies

Mischa Jonker (1):
      ARC: [nsimosci] Change .dts to use generic 8250 UART

Nicolas Dichtel (3):
      rtnetlink: fix fdb notification flags
      ipmr: fix mfc notification flags
      ip6mr: fix mfc notification flags

Nikolay Aleksandrov (1):
      net: fix for a race condition in the inet frag code

Nishanth Menon (1):
      net: micrel : ks8851-ml: add vdd-supply support

Oliver Neukum (1):
      usbnet: include wait queue head in device structure

Pablo Neira (1):
      netlink: don't compare the nul-termination in nla_strcmp

Paul Durrant (1):
      xen-netback: remove pointless clause from if statement

Paul Moore (1):
      selinux: correctly label /proc inodes in use before the policy is loa=
ded

Peter Bostr=F6m (1):
      vlan: Set correct source MAC address with TX VLAN offload enabled

Pravin B Shelar (1):
      ip_tunnel: Fix dst ref-count.

Sabrina Dubroca (1):
      ipv6: don't set DST_NOCOUNT for remotely added routes

Sasha Levin (1):
      rds: prevent dereference of a NULL device in rds_iw_laddr_check

Stefan Wahren (1):
      eth: fec: Fix lost promiscuous mode after reconnecting cable

Vineet Gupta (1):
      ARC: [nsimosci] Unbork console

Vlad Yasevich (2):
      tg3: Do not include vlan acceleration features in vlan_features
      vlan: Set hard_header_len according to available acceleration

Wei Liu (1):
      xen-netback: disable rogue vif in kthread context

YOSHIFUJI Hideaki (1):
      isdnloop: Validate NUL-terminated strings from user.

Ying Xue (2):
      tipc: allow connection shutdown callback to be invoked in advance
      tipc: fix connection refcount leak

dingtianhong (1):
      bonding: set correct vlan id for alb xmit path

lucien (1):
      ipv6: ip6_append_data_mtu do not handle the mtu of the second fragmen=
t properly


--bp/iNruPH9dso1Pn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTTDAnAAoJEDjbvchgkmk+LRQQAMLFalpg8qk+HMeTpzZoGC+9
OifMGCGbRD8EtALnSk1NhVTNhazt+Odfi/YMPxJrF6ETRHGPToTEbqR0irqY5NfY
3REyy8L6KtBVLeoYzDiglhuL+BbrRaFlmUy1mzg7a4/fTwUWMUWcVKp1Yf8IYMRq
cLe4CdqIBv7bs1NqnyoCc5nkOre2rP3NKlTGJzW4Tr+RtlrEsoAWt4T3HNCrvdm2
Ph+P1Qacs6GhHnMI8ek0XPfGSY7bnxESUv2inEGcwljfkt2C5J0uNwYZsou5w28Y
ow39Zb+4MBr6rJ/8C46peK7vCbOR8g1f3j+kLXhFBLpx6kY8OtQo5/69c4mBsgfB
duDcIIFwD4a/ciTd/zlj2CogYtiIX3N75YdewPo0BZffua/UdGtEu8MyU5lqoKOo
uxbjGHpFh8hhZz7BkPlK7VJS6Tvjm0H2JSGhVQ+P77yrSE2kNl73L+HbiZpxshaW
bgfDqiucYJ09lVmpJFEMamu69IlYzx6gbN4zy+D6neYQEd0JcELW+36bliRqVXd8
WakziolnCsvUK9fWpT5wn2tyrv08IT5oJIK5gwjuh5cUaLikTz27vXGCIuS/Fz/s
BcFPpjP2WjJxWkZqUiNgNbjuRMkOz9jbPQX7dH+CN7BfoolwjjaOFez7FKkB6Enq
3ueOMoWrUY9htyzTr3K4
=5RP6
-----END PGP SIGNATURE-----

--bp/iNruPH9dso1Pn--
