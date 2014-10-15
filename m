Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752537AbaJOKjH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 06:39:07 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57815 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752243AbaJOKjE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 06:39:04 -0400
Date: Wed, 15 Oct 2014 12:37:58 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.14.22
Message-ID: <20141015103758.GA30879@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZPt4rx8FFjLCG7dd"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ZPt4rx8FFjLCG7dd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.14.22 kernel.

All users of the 3.14 kernel series must upgrade.

The updated 3.14.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-3.14.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dsu=
mmary

thanks,

greg k-h

------------

 Makefile                                         |    2=20
 drivers/crypto/caam/caamhash.c                   |    6 -
 drivers/net/bonding/bond_main.c                  |   17 +++-
 drivers/net/ethernet/broadcom/tg3.c              |   23 +++++-
 drivers/net/ethernet/cadence/macb.c              |   11 --
 drivers/net/ethernet/intel/i40e/i40e_main.c      |    8 +-
 drivers/net/ethernet/myricom/myri10ge/myri10ge.c |   88 +++++++++++++++---=
-----
 drivers/net/hyperv/netvsc_drv.c                  |    3=20
 drivers/net/macvlan.c                            |    1=20
 drivers/net/macvtap.c                            |   18 ++--
 drivers/net/team/team.c                          |    4 -
 drivers/net/vxlan.c                              |    8 +-
 drivers/tty/serial/8250/8250_pci.c               |   21 +++++
 drivers/usb/core/hub.c                           |    6 +
 drivers/usb/core/quirks.c                        |    4 +
 drivers/usb/musb/musb_dsps.c                     |    2=20
 drivers/usb/serial/cp210x.c                      |    2=20
 include/linux/if_vlan.h                          |    6 -
 include/linux/skbuff.h                           |    1=20
 include/linux/usb/quirks.h                       |    3=20
 include/net/dst.h                                |   16 +++-
 include/net/inet_connection_sock.h               |    1=20
 include/net/sctp/command.h                       |    2=20
 include/net/sock.h                               |    1=20
 include/net/tcp.h                                |    5 +
 net/8021q/vlan_core.c                            |   53 -------------
 net/bridge/br_private.h                          |    3=20
 net/bridge/br_vlan.c                             |   15 ++-
 net/core/dev.c                                   |    2=20
 net/core/netpoll.c                               |    2=20
 net/core/rtnetlink.c                             |    3=20
 net/core/skbuff.c                                |   56 ++++++++++++++
 net/ipv4/route.c                                 |    6 -
 net/ipv4/tcp.c                                   |   14 +--
 net/ipv4/tcp_input.c                             |    8 --
 net/ipv4/tcp_ipv4.c                              |    5 -
 net/ipv4/tcp_output.c                            |   11 +-
 net/ipv6/addrconf.c                              |   15 +--
 net/ipv6/anycast.c                               |   10 ++
 net/ipv6/ip6_gre.c                               |    4 -
 net/ipv6/ip6_output.c                            |    4 -
 net/ipv6/mcast.c                                 |   14 +++
 net/ipv6/sit.c                                   |    6 -
 net/ipv6/tcp_ipv6.c                              |    3=20
 net/l2tp/l2tp_ppp.c                              |    3=20
 net/netlink/af_netlink.c                         |    2=20
 net/openvswitch/actions.c                        |    5 +
 net/packet/af_packet.c                           |   17 ++++
 net/packet/internal.h                            |    1=20
 net/sctp/sm_statefuns.c                          |   19 ++++
 net/xfrm/xfrm_policy.c                           |   48 ++++++++++--
 51 files changed, 391 insertions(+), 197 deletions(-)

Andreas Bomholtz (1):
      USB: cp210x: add support for Seluxit USB dongle

Andrey Vagin (1):
      tcp: don't use timestamp from repaired skb-s to calculate RTT (v2)

Bryan O'Donoghue (1):
      serial: 8250: Add Quark X1000 to 8250_pci.c

Cristian Stoica (1):
      crypto: caam - fix addressing of struct member

Daniel Borkmann (1):
      netlink: reset network header before passing to taps

Eric Dumazet (2):
      packet: handle too big packets for PACKET_V3
      gro: fix aggregation for skb using frag_list

Felipe Balbi (1):
      usb: musb: dsps: kill OTG timer on suspend

Francesco Ruggeri (1):
      net: allow macvlans to move to net namespace

Gerhard Stenzel (1):
      vxlan: fix incorrect initializer in union vxlan_addr

Greg Kroah-Hartman (1):
      Linux 3.14.22

Guillaume Nault (1):
      l2tp: fix race while getting PMTU on PPP pseudo-wire

Jiri Benc (2):
      rtnetlink: fix VF info size
      openvswitch: fix panic with multiple vlan headers

Joe Lawrence (1):
      team: avoid race condition in scheduling delayed work

Joe Savage (1):
      USB: serial: cp210x: added Ketra N1 wireless interface support

KY Srinivasan (1):
      hyperv: Fix a bug in netvsc_start_xmit()

Lu Baolu (1):
      USB: Add device quirk for ASUS T100 Base Station keyboard

Neal Cardwell (2):
      tcp: fix tcp_release_cb() to dispatch via address family for mtu_redu=
ced()
      tcp: fix ssthresh and undo for consecutive short FRTO episodes

Neerav Parikh (1):
      i40e: Don't stop driver probe when querying DCB config fails

Nicolas Dichtel (1):
      ip6_gre: fix flowi6_proto value in xmit path

Nikolay Aleksandrov (1):
      bonding: fix div by zero while enslaving and transmitting

Per Hurtig (1):
      tcp: fixing TLP's FIN recovery

Sabrina Dubroca (1):
      ipv6: fix rtnl locking in setsockopt for anycast and multicast

Shmulik Ladkani (1):
      sit: Fix ipip6_tunnel_lookup device matching criteria

Soren Brinkmann (1):
      Revert "net/macb: add pinctrl consumer support"

Stanislaw Gruszka (1):
      myri10ge: check for DMA mapping errors

Steffen Klassert (2):
      xfrm: Generate blackhole routes only from route lookup functions
      xfrm: Generate queueing routes only from route lookup functions

Vlad Yasevich (7):
      net: Always untag vlan-tagged traffic on input.
      bridge: Check if vlan filtering is enabled only once.
      bridge: Fix br_should_learn to check vlan_enabled
      tg3: Work around HW/FW limitations with vlan encapsulated frames
      tg3: Allow for recieve of full-size 8021AD frames
      macvtap: Fix race between device delete and open.
      sctp: handle association restarts when the socket is closed.

WANG Cong (1):
      ipv6: restore the behavior of ipv6_sock_ac_drop()


--ZPt4rx8FFjLCG7dd
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUPk6GAAoJEDjbvchgkmk+2LMP/1D/l0M1rmDrbULDMlTS+6YL
E3Bw9LN69wspSNs7bJ6twyLxZmO49CVAVnw+QL/Icec+FZz3VGQyJvFN4iTrfC8+
ykKMo7Sv7MNuO1ThWrsHAwXMI0yV45JK1/hqL5P/MJDvxm+najqEBTf8FBy9OOiY
Z9doeB4Tlel5329h2Nxm/3BFAebGI12iwA6PKfsCfBRwTXIbEq/lHNwFFnQ+RgBI
Kw03lWCAfjtysw5yy6WWKiyOuWhEsMWoeuccpEkzqUi0rMWlAnLzBqkDWsSXHWMb
YybwgTqKRnBBJmo+/YfzWC/XWM0t32Z9enY1KzT6Ii5wWjWOV+sSOUDqhoRlnLPr
TnBxNdzGTNAdhKFB2pMkrwUyNUc9PurAYZfR0KSmtlQhgTiOnjCOdBGvWmR3hgwD
rOJEr+laFjNKtElcKFnhkkt12fJ6PmzNPW2KxQj9UQ3HVIEsAcjZ73Z4eXE9gZE7
Ct2JR83kQyvhkhRf9/ZS9eABFwwSlQ5eaxN6DkPKugquFlIiNN6PKOoRWIM772Jz
PuKJXx2P/D/QTKWji0NCz8hXLDzzzVbRn3l/QYzotB4+clNQUQh8WGt0Vq5pi1os
oaWaD+nafIXufCFZ0S3ojc3vYb3adIENdMg/a3n1b20DykNPk7wrkh6RRRy7Pt4p
Ca2w5u0kKLMNUz4hCc6M
=QalL
-----END PGP SIGNATURE-----

--ZPt4rx8FFjLCG7dd--
