Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756759Ab3INOPU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Sep 2013 10:15:20 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43189 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756710Ab3INOPS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Sep 2013 10:15:18 -0400
Date: Sat, 14 Sep 2013 07:15:35 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.10.12
Message-ID: <20130914141535.GA12088@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NzB8fVQJ5HfG6fxh"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--NzB8fVQJ5HfG6fxh
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.10.12 kernel.

All users of the 3.10 kernel series must upgrade.

The updated 3.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-3.10.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dsu=
mmary

thanks,

greg k-h

------------

 Makefile                                    |    2=20
 arch/arm/boot/dts/at91sam9260.dtsi          |   10 ++++
 arch/x86/include/asm/xor_avx.h              |    4 -
 drivers/net/bonding/bond_main.c             |    8 ++-
 drivers/net/ethernet/broadcom/tg3.c         |   18 ++++++-
 drivers/net/ethernet/emulex/benet/be_main.c |    2=20
 drivers/net/ethernet/marvell/mvneta.c       |   13 +++++
 drivers/net/ethernet/realtek/8139cp.c       |    1=20
 drivers/net/ethernet/sfc/filter.c           |    2=20
 drivers/net/macvlan.c                       |    4 +
 drivers/net/tun.c                           |    6 +-
 drivers/net/usb/cdc_mbim.c                  |    4 +
 drivers/net/vxlan.c                         |    2=20
 drivers/net/wireless/mwifiex/main.c         |   14 -----
 drivers/rtc/rtc-max77686.c                  |    4 -
 drivers/vhost/net.c                         |    9 ++-
 include/linux/ipv6.h                        |    1=20
 include/net/genetlink.h                     |   20 +++++++-
 include/net/ip_tunnels.h                    |   14 -----
 include/net/sch_generic.h                   |    9 +++
 include/uapi/linux/icmpv6.h                 |    2=20
 include/uapi/linux/pkt_sched.h              |   10 +++-
 net/bridge/br_fdb.c                         |   10 ++--
 net/bridge/br_multicast.c                   |    5 +-
 net/bridge/br_netlink.c                     |    4 -
 net/bridge/br_vlan.c                        |    4 -
 net/core/flow_dissector.c                   |   11 +---
 net/core/neighbour.c                        |   10 ++--
 net/core/rtnetlink.c                        |    4 -
 net/core/sysctl_net_core.c                  |    6 ++
 net/ipv4/devinet.c                          |    4 +
 net/ipv4/fib_trie.c                         |    5 --
 net/ipv4/ip_gre.c                           |    2=20
 net/ipv4/ip_tunnel.c                        |    2=20
 net/ipv4/raw.c                              |    3 -
 net/ipv4/tcp.c                              |    7 ++
 net/ipv4/tcp_cubic.c                        |   12 ++---
 net/ipv4/tcp_input.c                        |    9 ++-
 net/ipv4/tcp_output.c                       |    4 +
 net/ipv6/addrconf.c                         |   10 +---
 net/ipv6/addrlabel.c                        |   48 +++++++++-----------
 net/ipv6/icmp.c                             |   10 +++-
 net/ipv6/ip6_fib.c                          |   16 +++++-
 net/ipv6/ndisc.c                            |   14 +++--
 net/ipv6/reassembly.c                       |    5 ++
 net/ipv6/tcp_ipv6.c                         |    2=20
 net/netlink/genetlink.c                     |   67 ++++++++++++++++++++++-=
-----
 net/packet/af_packet.c                      |    2=20
 net/sched/sch_api.c                         |   41 +++++++++++++++++
 net/sched/sch_generic.c                     |    1=20
 net/sched/sch_htb.c                         |   15 +++++-
 net/tipc/socket.c                           |    4 -
 52 files changed, 345 insertions(+), 151 deletions(-)

Andrew Vagin (2):
      tcp: initialize rcv_tstamp for restored sockets
      tcp: don't apply tsoffset if rcv_tsecr is zero

Andrey Vagin (1):
      tcp: set timestamps for restored skb-s

Asbjoern Sloth Toennesen (1):
      rtnetlink: rtnl_bridge_getlink: Call nlmsg_find_attr() with ifinfomsg=
 header

Ben Hutchings (1):
      sfc: Fix lookup of default RX MAC filters when steered using ethtool

Bing Zhao (1):
      mwifiex: do not create AP and P2P interfaces upon driver loading

Chris Clark (1):
      ipv4: sendto/hdrincl: don't use destination address found in header

Dan Carpenter (1):
      tun: signedness bug in tun_get_user()

Daniel Borkmann (3):
      net: rtm_to_ifaddr: free ifa if ifa_cacheinfo processing fails
      net: bridge: convert MLDv2 Query MRC into msecs_to_jiffies for max_de=
lay
      net: ipv6: tcp: fix potential use after free in tcp_v6_do_rcv

Dave Jones (1):
      8139cp: Fix skb leak in rx_status_loop failure path.

Eric Dumazet (4):
      fib_trie: remove potential out of bound access
      tcp: cubic: fix overflow error in bictcp_update()
      tcp: cubic: fix bug in bictcp_acked()
      net: revert 8728c544a9c ("net: dev_pick_tx() fix")

Erik Hugne (1):
      tipc: set sk_err correctly when connection fails

Greg Kroah-Hartman (1):
      Linux 3.10.12

Hannes Frederic Sowa (4):
      ipv6: don't stop backtracking in fib6_lookup_1 if subtree does not ma=
tch
      ipv6: remove max_addresses check from ipv6_create_tempaddr
      ipv6: drop packets with multiple fragmentation headers
      ipv6: fix null pointer dereference in __ip6addrlbl_add

Jason Wang (1):
      vhost_net: poll vhost queue after marking DMA is done

Jean-Christophe PLAGNIOL-VILLARD (1):
      ARM: at91: dt: sam9260: add i2c gpio pinctrl

Jesper Dangaard Brouer (1):
      net_sched: restore "linklayer atm" handling

Jiri Bohac (1):
      ICMPv6: treat dest unreachable codes 5 and 6 as EACCES, not EPROTO

John Haxby (1):
      crypto: xor - Check for osxsave as well as avx in crypto/xor

Linus L=FCssing (1):
      bridge: don't try to update timers in case of broken MLD queries

Michael S. Tsirkin (1):
      macvlan: validate flags

Nithin Sujir (1):
      tg3: Don't turn off led on 5719 serdes port 0

Phil Oester (1):
      tcp: tcp_make_synack() should use sock_wmalloc

Pravin B Shelar (3):
      genl: Fix genl dumpit() locking.
      genl: Hold reference on correct module while netlink-dump.
      ip_tunnel: Do not use inner ip-header-id for tunnel ip-header-id.

Rob Gardner (1):
      net: usb: Add HP hs2434 device to ZLP exception table

Roman Gushchin (1):
      net: check net.core.somaxconn sysctl values

Sangjung Woo (1):
      drivers/rtc/rtc-max77686.c: Fix wrong register

Sathya Perla (1):
      be2net: fix disabling TX in be_close()

Sridhar Samudrala (1):
      rtnetlink: Fix inverted check in ndo_dflt_fdb_del()

Thomas Graf (1):
      ipv6: Don't depend on per socket memory for neighbour discovery messa=
ges

Thomas Petazzoni (1):
      net: mvneta: properly disable HW PHY polling and ensure adjust_link()=
 works

Timo Ter=E4s (1):
      ip_gre: fix ipgre_header to return correct offset MIME-Version: 1.0

Toshiaki Makita (1):
      bridge: Use the correct bit length for bitmap functions in the VLAN c=
ode

Veaceslav Falico (2):
      neighbour: populate neigh_parms on alloc before calling ndo_neigh_set=
up
      bonding: modify only neigh_parms owned by us

Willem de Bruijn (1):
      packet: restore packet statistics tp_packets to include drops

stephen hemminger (1):
      htb: fix sign extension bug


--NzB8fVQJ5HfG6fxh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSNG+HAAoJEDjbvchgkmk+j+YP/jvO+xuWFwLl6QvmyEgO8FKf
imOoxdxLgEBdqG/nJIKoYKK5ijMv1CNNf7FAyab6KVPoIM2+/Ro6bU0zvK8+yAz4
w3ChK8AvADbNSQUiueVT999JWc1+C0QWN/3sbqriViHohiboDwwNsM9AmkY45hId
7w1fApIj6GkI84AioWPeWkp2X7fFM1uovGopqsltRPyLiIX7TZkp08hjBRWrSjX/
eY2gkduWVUgHJXlMKVaO1Dd2EFP2qWwGrYbtPjF8QHDbTfpwexelHzxDmsnS3IW+
rrUahD8xEGt+JAYolTm7RFOmgT7c0BZA9IiAX7faRjGwj2YHB+MO975Cf2GG+mox
2ye+rKgWO9P/j2hfxP8VEYpQKI6Bce+RU3QuflqSd5oIH4jkbgQzhmmUQQ97NhW9
mqZBAVjjGbRSrCfxJWWlFwPeZgQsOv/+gWWi/P2PDnlKzACNksLTfZLlf4s/qlu2
QW9qo8y9Bp9MnuU7cRtxQkYZi/RtXlEqe5gqEZGXqXXi/EIAzLib4E5bjZ57+uHg
5weBV0x6HSPlznmpqZdlvVTRjRqzNHjqMQaupdFczYPZx+Q0fkuU2UIsqFToqN0g
/lakk/WitFrIw1bUp1ZFdmG50g2I31G9GpVDoaXgkqdc2VZIDdyUpSgUMKgcen7t
LifHuA9944HHYbpWzwAB
=r+TP
-----END PGP SIGNATURE-----

--NzB8fVQJ5HfG6fxh--
