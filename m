Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756076Ab3KFCgA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 21:36:00 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:59508 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756057Ab3KFCf5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 21:35:57 -0500
Date: Tue, 5 Nov 2013 18:15:25 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.11.7
Message-ID: <20131106021525.GA7084@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mYCpIKhGyMATD0i+"
Content-Disposition: inline
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mYCpIKhGyMATD0i+
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.11.7 kernel.

All users of the 3.11 kernel series must upgrade.

The updated 3.11.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-3.11.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dsu=
mmary

thanks,

greg k-h

------------

 Documentation/networking/ip-sysctl.txt          |    9 ++++
 Makefile                                        |    2 -
 arch/arm/boot/dts/integratorcp.dts              |    9 ++--
 arch/arm/include/asm/syscall.h                  |    6 +++
 drivers/connector/cn_proc.c                     |   18 +++++++++
 drivers/connector/connector.c                   |    7 ++-
 drivers/gpio/gpio-lynxpoint.c                   |    5 +-
 drivers/i2c/busses/i2c-ismt.c                   |    3 +
 drivers/md/dm-snap-persistent.c                 |   18 ++++++---
 drivers/net/can/dev.c                           |   10 ++---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c |    1=20
 drivers/net/ethernet/emulex/benet/be_cmds.c     |    3 +
 drivers/net/ethernet/marvell/mv643xx_eth.c      |    6 +--
 drivers/net/ethernet/mellanox/mlx4/en_rx.c      |   41 ++++++++++++-------=
--
 drivers/net/ethernet/mellanox/mlx4/mlx4_en.h    |    4 +-
 drivers/net/ethernet/ti/davinci_emac.c          |    3 -
 drivers/net/virtio_net.c                        |   14 ++++++-
 drivers/net/wan/farsync.c                       |    1=20
 drivers/net/wan/wanxl.c                         |    1=20
 drivers/net/wireless/cw1200/cw1200_spi.c        |    2 +
 drivers/net/xen-netback/common.h                |    1=20
 drivers/net/xen-netback/interface.c             |   23 ++++--------
 drivers/net/xen-netback/xenbus.c                |   17 ++++++--
 drivers/tty/serial/vt8500_serial.c              |    5 +-
 drivers/usb/serial/option.c                     |    9 ++++
 drivers/usb/serial/ti_usb_3410_5052.c           |    1=20
 drivers/w1/w1.c                                 |    3 +
 fs/ext3/namei.c                                 |    5 +-
 fs/ext4/namei.c                                 |    5 +-
 include/linux/skbuff.h                          |    5 ++
 include/net/cipso_ipv4.h                        |    6 ++-
 include/net/dst.h                               |   12 ++++++
 include/net/ip6_route.h                         |    6 +--
 include/net/sock.h                              |    2 +
 include/net/tcp.h                               |    1=20
 mm/huge_memory.c                                |   10 ++++-
 mm/memory.c                                     |    2 +
 mm/migrate.c                                    |    2 +
 mm/mprotect.c                                   |    7 ++-
 mm/page-writeback.c                             |   10 ++---
 mm/zswap.c                                      |    4 ++
 net/8021q/vlan_netlink.c                        |    2 -
 net/batman-adv/main.c                           |    5 +-
 net/batman-adv/network-coding.c                 |   28 +++++++++-----
 net/batman-adv/network-coding.h                 |   14 +++++--
 net/bridge/br_mdb.c                             |    2 -
 net/bridge/br_multicast.c                       |   38 +++++++++++++------
 net/bridge/br_private.h                         |    1=20
 net/bridge/br_stp_if.c                          |    2 -
 net/compat.c                                    |    2 +
 net/core/secure_seq.c                           |    2 +
 net/core/sock.c                                 |    1=20
 net/ipv4/inet_hashtables.c                      |    2 -
 net/ipv4/ip_output.c                            |    2 -
 net/ipv4/ip_vti.c                               |   14 +++++--
 net/ipv4/route.c                                |    2 -
 net/ipv4/sysctl_net_ipv4.c                      |   10 +++++
 net/ipv4/tcp.c                                  |   28 ++++++++++++--
 net/ipv4/tcp_input.c                            |   41 +++++++++++++++++++=
--
 net/ipv4/tcp_output.c                           |   28 +++++++++-----
 net/ipv6/inet6_hashtables.c                     |    2 -
 net/ipv6/ip6_output.c                           |    6 +--
 net/ipv6/route.c                                |   46 +++++++++++++++++++=
-----
 net/ipv6/sit.c                                  |    1=20
 net/l2tp/l2tp_core.c                            |   36 +++++++++++++++---
 net/l2tp/l2tp_core.h                            |    3 +
 net/l2tp/l2tp_ppp.c                             |    4 ++
 net/netfilter/nf_conntrack_h323_main.c          |    4 +-
 net/sched/sch_netem.c                           |   17 ++++++++
 net/sctp/output.c                               |    3 +
 net/socket.c                                    |   24 ++++++++++--
 net/unix/af_unix.c                              |   10 +++++
 net/unix/diag.c                                 |    1=20
 net/wireless/radiotap.c                         |    7 +++
 sound/pci/hda/hda_generic.c                     |    2 -
 sound/usb/usx2y/us122l.c                        |    4 +-
 76 files changed, 515 insertions(+), 178 deletions(-)

AKASHI Takahiro (1):
      ARM: 7851/1: check for number of arguments in syscall_get/set_argumen=
ts()

Amir Vadai (2):
      net/mlx4_en: Rename name of mlx4_en_rx_alloc members
      net/mlx4_en: Fix pages never dma unmapped on rx

Christophe Gouault (1):
      vti: get rid of nf mark rule in prerouting

Cyrill Gorcunov (1):
      mm: migration: do not lose soft dirty bit if page is in migration sta=
te

Dan Carpenter (1):
      net: heap overflow in __audit_sockaddr()

Daniel Borkmann (1):
      net: unix: inherit SOCK_PASS{CRED, SEC} flags from socket to fix race

David Henningsson (1):
      ALSA: hda - Fix inverted internal mic not indicated on some machines

David S. Miller (1):
      l2tp: Fix build warning with ipv6 disabled.

Diego Elio Petten=F2 (1):
      USB: serial: ti_usb_3410_5052: add Abbott strip port ID to combined t=
able as well.

Enrico Mioso (1):
      usb: serial: option: blacklist Olivetti Olicard200

Eric Dumazet (7):
      tcp: TSO packets automatic sizing
      tcp: TSQ can use a dynamic limit
      tcp: must unclone packets before mangling them
      tcp: do not forget FIN in tcp_shifted_skb()
      net: do not call sock_put() on TIMEWAIT sockets
      l2tp: must disable bh before calling l2tp_xmit_skb()
      bnx2x: record rx queue for LRO packets

Fabio Estevam (1):
      net: secure_seq: Fix warning when CONFIG_IPV6 and CONFIG_INET are not=
 selected

Fan Du (1):
      sctp: Use software crc32 checksum when xfrm transform will happen.

Fengguang Wu (1):
      writeback: fix negative bdi max pause

Fran=E7ois CACHEREUL (1):
      l2tp: fix kernel panic when using IPv4-mapped IPv6 addresses

Greg Kroah-Hartman (2):
      USB: serial: option: add support for Inovia SEW858 device
      Linux 3.11.7

Hannes Frederic Sowa (2):
      inet: fix possible memory corruption with UDP_CORK and UFO
      ipv6: probe routes asynchronous in rt6_probe

Hans-Frieder Vogt (1):
      w1 - call request_module with w1 master mutex unlocked

Hugh Dickins (1):
      mm: fix BUG in __split_huge_page_pmd

James Ralston (1):
      i2c: ismt: initialize DMA buffer

Jason Wang (2):
      virtio-net: don't respond to cpu hotplug notifier if we're not ready
      virtio-net: refill only when device is up during setting queues

Jiri Benc (1):
      ipv4: fix ineffective source address selection

Johannes Berg (1):
      wireless: radiotap: fix parsing buffer overrun

Julian Anastasov (3):
      ipv6: always prefer rt6i_gateway if present
      ipv6: fill rt6i_gateway with nexthop address
      netfilter: nf_conntrack: fix rt6i_gateway checks for H.323 helper

Linus L=FCssing (1):
      Revert "bridge: only expire the mdb entry when query is received"

Linus Walleij (1):
      ARM: integrator: deactivate timer0 on the Integrator/CP

Marc Kleine-Budde (2):
      can: dev: fix nlmsg size calculation in can_get_size()
      net: vlan: fix nlmsg size calculation in vlan_get_size()

Mariusz Ceier (1):
      davinci_emac.c: Fix IFF_ALLMULTI setup

Mathias Krause (3):
      proc connector: fix info leaks
      unix_diag: fix info leak
      connector: use nlmsg_len() to check message length

Matthias Schiffer (1):
      batman-adv: set up network coding packet handlers during module init

Mika Westerberg (1):
      gpio/lynxpoint: check if the interrupt is enabled in IRQ handler

Miklos Szeredi (1):
      ext[34]: fix double put in tmpfile

Mikulas Patocka (1):
      dm snapshot: fix data corruption

Paul Durrant (1):
      xen-netback: Don't destroy the netdev until the vif is shut down

Roel Kluin (1):
      serial: vt8500: add missing braces

Salva Peir=F3 (2):
      farsync: fix info leak in ioctl
      wanxl: fix info leak in ioctl

Sebastian Hesselbarth (2):
      net: mv643xx_eth: update statistics timer from timer context only
      net: mv643xx_eth: fix orphaned statistics timer crash

Seif Mazareeb (1):
      net: fix cipso packet validation when !NETLABEL

Solomon Peachy (1):
      wireless: cw1200: acquire hwbus lock around cw1200_irq_handler() call.

Takashi Iwai (1):
      ALSA: us122l: Fix pcm_usb_stream mmapping regression

Vasundhara Volam (1):
      be2net: pass if_id for v1 and V2 versions of TX_CREATE cmd

Vlad Yasevich (4):
      bridge: update mdb expiration timer upon reports.
      bridge: Correctly clamp MAX forward_delay when enabling STP
      net: dst: provide accessor function to dst->xfrm
      sctp: Perform software checksum if packet has to be fragmented.

Weijie Yang (1):
      mm/zswap: bugfix: memory leak when re-swapon

Willem de Bruijn (1):
      sit: amend "allow to use rtnl ops on fb tunnel"

Yuchung Cheng (1):
      tcp: fix incorrect ca_state in tail loss probe

stephen hemminger (2):
      netem: update backlog after drop
      netem: free skb's in tree on reset


--mYCpIKhGyMATD0i+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSeaY9AAoJEDjbvchgkmk+xOgP/iKuF+98niV/youqGSXkFcH3
XlD/s6/2sNG+h9KYjt/A3HaO7Bq5DqxmLoJ26bdQ/qzt+AXmgEjKmKJKpOvlXl3c
ymTAZ20GBaokLk2JbmUV8W/d2wePR/YhAVNEYtS2aIA2xsrOknZ2QbkBcf6Cb313
LG9EpJx7A+adru8dllFo4pgVaR1LcwK1wRikaldOBaxvuipugCSqtO/+SF2/Qjfl
eR17HT6CBhVDhiWo5MJ7bWtXfMzlGDuf10RefRM57LvXAyAW3q67g9HaNEtP8lGi
F03mWi7dlsUixjuk6qX41vCiAC9aQU8il8X5KtqIbfkFI8mLUAM90gRqMAEFCKvV
sgZUlsa2JcOEtJLiMNK421Ito7CgwTl3otwUs9zVbWB7M1V8RpmofQ5TKALPq5L4
z1QKxn2ANxHaaOP+GJpi8qVI+yUHRER1ZrHrO+I3qzJTcHv1YcG92y2yQoJqrXiF
VLAl6zYdbVgIxrugkP3vfnIWsrtiMA9eUWC5yDIMWSMIXJumdZ+7bg7S0wpYGCcX
9LUarvSyGvS/ogC2Ua4olc2uG18cJeWEbUQJFKjIf6E8D5E2cW5PZLWbGr29THMA
LLsplBimI1q+/3ITBTH9VXQ81LjwWhH05Gv2Eu83KT5++rN/PodTvdRGuZEFSBnF
OiKaVkdGtbjU+aKsvmXS
=UDEV
-----END PGP SIGNATURE-----

--mYCpIKhGyMATD0i+--
