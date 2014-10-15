Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752496AbaJOKiQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 06:38:16 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57808 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752472AbaJOKiN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 06:38:13 -0400
Date: Wed, 15 Oct 2014 12:37:05 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.16.6
Message-ID: <20141015103705.GA30808@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="x+6KMIRAuhnl3hBn"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--x+6KMIRAuhnl3hBn
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.16.6 kernel.

All users of the 3.16 kernel series must upgrade.

The updated 3.16.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-3.16.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dsu=
mmary

thanks,

greg k-h

------------

 Documentation/kernel-parameters.txt              |    4 +
 Makefile                                         |    2=20
 drivers/base/node.c                              |    1=20
 drivers/crypto/caam/caamhash.c                   |    6 -
 drivers/net/bonding/bond_main.c                  |   17 +++-
 drivers/net/ethernet/broadcom/bcmsysport.c       |   13 +--
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c |   92 ++++--------------=
-----
 drivers/net/ethernet/broadcom/tg3.c              |   23 +++++
 drivers/net/ethernet/cadence/macb.c              |   11 --
 drivers/net/ethernet/mellanox/mlx4/cmd.c         |   21 +++++
 drivers/net/ethernet/mellanox/mlx4/main.c        |    4 -
 drivers/net/ethernet/myricom/myri10ge/myri10ge.c |   88 ++++++++++++++----=
----
 drivers/net/hyperv/netvsc.c                      |   15 ++-
 drivers/net/hyperv/netvsc_drv.c                  |    3=20
 drivers/net/macvlan.c                            |   16 ++--
 drivers/net/macvtap.c                            |   18 ++--
 drivers/net/phy/smsc.c                           |   33 +++++---
 drivers/net/team/team.c                          |    4 -
 drivers/net/vxlan.c                              |    8 +-
 drivers/tty/serial/8250/8250_pci.c               |   21 +++++
 drivers/usb/core/hub.c                           |    6 +
 drivers/usb/core/quirks.c                        |    4 +
 drivers/usb/musb/musb_dsps.c                     |    2=20
 drivers/usb/serial/cp210x.c                      |    2=20
 drivers/usb/storage/uas.c                        |   17 ++++
 drivers/usb/storage/unusual_uas.h                |   45 ++++++++---
 drivers/usb/storage/usb.c                        |    9 ++
 include/linux/if_vlan.h                          |    6 -
 include/linux/skbuff.h                           |    1=20
 include/linux/usb/quirks.h                       |    3=20
 include/linux/usb_usual.h                        |    4 +
 include/net/dst.h                                |   16 +++-
 include/net/inet_connection_sock.h               |    1=20
 include/net/ip6_fib.h                            |    5 -
 include/net/net_namespace.h                      |   20 -----
 include/net/sctp/command.h                       |    2=20
 include/net/sock.h                               |    1=20
 include/net/tcp.h                                |    5 +
 net/8021q/vlan_core.c                            |   53 -------------
 net/bridge/br_private.h                          |    3=20
 net/bridge/br_vlan.c                             |   14 ++-
 net/core/dev.c                                   |   18 +++-
 net/core/filter.c                                |    1=20
 net/core/rtnetlink.c                             |    3=20
 net/core/skbuff.c                                |   56 ++++++++++++++
 net/ipv4/ip_tunnel.c                             |   11 ++
 net/ipv4/route.c                                 |    6 -
 net/ipv4/tcp.c                                   |   14 +--
 net/ipv4/tcp_input.c                             |    8 --
 net/ipv4/tcp_ipv4.c                              |    5 -
 net/ipv4/tcp_output.c                            |    7 +
 net/ipv6/addrconf.c                              |   18 +---
 net/ipv6/addrconf_core.c                         |    7 +
 net/ipv6/anycast.c                               |   10 ++
 net/ipv6/ip6_fib.c                               |   22 +++++
 net/ipv6/ip6_gre.c                               |    4 -
 net/ipv6/ip6_output.c                            |    4 -
 net/ipv6/mcast.c                                 |   14 +++
 net/ipv6/route.c                                 |    4 -
 net/ipv6/sit.c                                   |    6 -
 net/ipv6/tcp_ipv6.c                              |    3=20
 net/l2tp/l2tp_ppp.c                              |    3=20
 net/netlink/af_netlink.c                         |    2=20
 net/openvswitch/actions.c                        |    5 +
 net/packet/af_packet.c                           |   17 ++++
 net/packet/internal.h                            |    1=20
 net/sched/cls_api.c                              |    1=20
 net/sctp/sm_statefuns.c                          |   19 ++++
 net/tipc/port.h                                  |    5 +
 net/tipc/socket.c                                |    2=20
 net/xfrm/xfrm_policy.c                           |   48 ++++++++++--
 71 files changed, 597 insertions(+), 346 deletions(-)

Andreas Bomholtz (1):
      USB: cp210x: add support for Seluxit USB dongle

Andrey Vagin (1):
      tcp: don't use timestamp from repaired skb-s to calculate RTT (v2)

Benjamin Block (1):
      net: ipv6: fib: don't sleep inside atomic lock

Bryan O'Donoghue (1):
      serial: 8250: Add Quark X1000 to 8250_pci.c

Cristian Stoica (1):
      crypto: caam - fix addressing of struct member

Daniel Borkmann (1):
      netlink: reset network header before passing to taps

David S. Miller (1):
      Revert "macvlan: simplify the structure port"

Eric Dumazet (3):
      packet: handle too big packets for PACKET_V3
      net: filter: fix possible use after free
      gro: fix aggregation for skb using frag_list

Erik Hugne (1):
      tipc: fix message importance range check

Felipe Balbi (1):
      usb: musb: dsps: kill OTG timer on suspend

Florian Fainelli (1):
      net: systemport: fix bcm_sysport_insert_tsb()

Francesco Ruggeri (1):
      net: allow macvlans to move to net namespace

Gerhard Stenzel (1):
      vxlan: fix incorrect initializer in union vxlan_addr

Greg Kroah-Hartman (1):
      Linux 3.16.6

Guillaume Nault (1):
      l2tp: fix race while getting PMTU on PPP pseudo-wire

Gwenhael Goavec-Merou (1):
      net: phy: smsc: move smsc_phy_config_init reset part in a soft_reset =
function

Hannes Frederic Sowa (1):
      ipv6: remove rt6i_genid

Hans de Goede (4):
      uas: Add a quirk for rejecting ATA_12 and ATA_16 commands
      uas: Add no-report-opcodes quirk
      uas: Add US_FL_NO_ATA_1X quirk for Seagate (0bc2:ab20) drives
      uas: Add another ASM1051 usb-id to the uas blacklist

Jiri Benc (2):
      rtnetlink: fix VF info size
      openvswitch: fix panic with multiple vlan headers

Joe Lawrence (1):
      team: avoid race condition in scheduling delayed work

Joe Savage (1):
      USB: serial: cp210x: added Ketra N1 wireless interface support

KY Srinivasan (2):
      hyperv: Fix a bug in netvsc_start_xmit()
      hyperv: Fix a bug in netvsc_send()

Lu Baolu (1):
      USB: Add device quirk for ASUS T100 Base Station keyboard

Matan Barak (2):
      net/mlx4_core: Allow not to specify probe_vf in SRIOV IB mode
      net/mlx4: Correctly configure single ported VFs from the host

Michal Kube=C4=8Dek (1):
      net: fix checksum features handling in netif_skb_features()

Neal Cardwell (2):
      tcp: fix tcp_release_cb() to dispatch via address family for mtu_redu=
ced()
      tcp: fix ssthresh and undo for consecutive short FRTO episodes

Nicolas Dichtel (2):
      macvlan: allow to enqueue broadcast pkt on virtual device
      ip6_gre: fix flowi6_proto value in xmit path

Nikolay Aleksandrov (1):
      bonding: fix div by zero while enslaving and transmitting

Sabrina Dubroca (1):
      ipv6: fix rtnl locking in setsockopt for anycast and multicast

Shmulik Ladkani (1):
      sit: Fix ipip6_tunnel_lookup device matching criteria

Soren Brinkmann (1):
      Revert "net/macb: add pinctrl consumer support"

Stanislaw Gruszka (1):
      myri10ge: check for DMA mapping errors

Steffen Klassert (3):
      xfrm: Generate blackhole routes only from route lookup functions
      xfrm: Generate queueing routes only from route lookup functions
      ip_tunnel: Don't allow to add the same tunnel multiple times.

Vlad Yasevich (7):
      net: Always untag vlan-tagged traffic on input.
      bridge: Check if vlan filtering is enabled only once.
      bridge: Fix br_should_learn to check vlan_enabled
      tg3: Work around HW/FW limitations with vlan encapsulated frames
      tg3: Allow for recieve of full-size 8021AD frames
      macvtap: Fix race between device delete and open.
      sctp: handle association restarts when the socket is closed.

WANG Cong (2):
      ipv6: restore the behavior of ipv6_sock_ac_drop()
      net_sched: copy exts->type in tcf_exts_change()

Yasuaki Ishimatsu (1):
      driver/base/node: remove unnecessary kfree of node struct from unregi=
ster_one_node

Yuval Mintz (1):
      bnx2x: Revert UNDI flushing mechanism


--x+6KMIRAuhnl3hBn
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUPk5RAAoJEDjbvchgkmk+VmEP/j04+mhGvnHl/FKLz4tTkXvq
iUphlk4cnON88E5qqEzRvmksfM4OAzo1JZqED1/qCIXh8NzC5jHQcoZst7BuGgE8
lFREkABz4mghOGnR8L8dhXFvIIYz/sp7Tc7I/GvlQ/ZOX7Ow0EbFP1fT+iZ5WrqC
EppFUtapyIJROwHF8yIet223dvgTuHoNl0XS9c2BCQ2evyRgjqOf00QeYTKlVGFe
kfbCLaz0aHZnpilCIZDebtunGKmZnC38ncgzApbyrSoe+Mypslm2kiOEeBpHwVGk
QTfSU2G+LU1lqX7vyhrJ9UsIfGgSsikCgqZ9LRE4ODE2ITDaNDwKRVYJpj8Jjhd8
NH1uO9EO/E/JCFj2uWpNjMUIVF4VdSYOI694MKAm2GTd5ZjEvp9uz01hOBN/Gazk
yBslhCGY3xB16ZxyP2H8MC8U+ST2otzVw9vQvZejZJlQ46HSrE49bL5JoGnLgf53
Xf89bNmwgg9Jgn4rMaUzV+lc3Y59q9wLkNfMZAN2D2sNEnC6zyo6BvkBo/13yj0n
dImHJt8Dml3eYPTtNwdfV33Rfu0rXeern6P99PnxQuuF4SduqwUfV3DpvJzHtiPO
S3snp6dwFFJBapltqkFSEugCHfTtVZlBPkkD8Sq7zXA5JUbZhUDGFDbOZAKidul8
sXsO22dBdJ2UbRNQFvUI
=PCy+
-----END PGP SIGNATURE-----

--x+6KMIRAuhnl3hBn--
