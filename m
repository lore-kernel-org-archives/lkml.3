Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756022Ab3KFCfl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 21:35:41 -0500
Received: from mail-pb0-f47.google.com ([209.85.160.47]:64938 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755949Ab3KFCfj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 21:35:39 -0500
Date: Tue, 5 Nov 2013 18:14:13 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.4.68
Message-ID: <20131106021413.GA6931@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4Ckj6UjgE2iN1+kY"
Content-Disposition: inline
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--4Ckj6UjgE2iN1+kY
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.4.68 kernel.

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

 Makefile                                        |    2=20
 drivers/connector/cn_proc.c                     |   16 ++
 drivers/connector/connector.c                   |    7 -
 drivers/md/dm-snap-persistent.c                 |   18 +-
 drivers/net/can/dev.c                           |   10 -
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c |    1=20
 drivers/net/ethernet/marvell/mv643xx_eth.c      |    6=20
 drivers/net/ethernet/ti/davinci_emac.c          |    3=20
 drivers/net/wan/farsync.c                       |    1=20
 drivers/net/wan/wanxl.c                         |    1=20
 drivers/usb/serial/option.c                     |    9 +
 drivers/usb/serial/ti_usb_3410_5052.c           |    1=20
 fs/ext3/dir.c                                   |  167 +++++++++++++++++--=
-----
 fs/ext3/ext3.h                                  |    6=20
 fs/ext3/hash.c                                  |    4=20
 include/linux/skbuff.h                          |   15 ++
 include/net/cipso_ipv4.h                        |    6=20
 include/net/dst.h                               |   12 +
 mm/page-writeback.c                             |   10 -
 net/8021q/vlan_netlink.c                        |    2=20
 net/bridge/br_stp_if.c                          |    2=20
 net/compat.c                                    |    2=20
 net/ipv4/inet_hashtables.c                      |    2=20
 net/ipv4/ip_output.c                            |    2=20
 net/ipv4/route.c                                |    2=20
 net/ipv4/tcp_input.c                            |    5=20
 net/ipv4/tcp_output.c                           |    9 -
 net/ipv6/inet6_hashtables.c                     |    2=20
 net/ipv6/ip6_output.c                           |    2=20
 net/ipv6/route.c                                |   11 +
 net/l2tp/l2tp_ppp.c                             |    4=20
 net/sctp/output.c                               |    3=20
 net/socket.c                                    |   24 ++-
 net/unix/af_unix.c                              |   10 +
 net/unix/diag.c                                 |    1=20
 net/wireless/radiotap.c                         |    7 -
 36 files changed, 287 insertions(+), 98 deletions(-)

Dan Carpenter (1):
      net: heap overflow in __audit_sockaddr()

Daniel Borkmann (1):
      net: unix: inherit SOCK_PASS{CRED, SEC} flags from socket to fix race

Diego Elio Petten=F2 (1):
      USB: serial: ti_usb_3410_5052: add Abbott strip port ID to combined t=
able as well.

Enrico Mioso (1):
      usb: serial: option: blacklist Olivetti Olicard200

Eric Dumazet (5):
      tcp: must unclone packets before mangling them
      tcp: do not forget FIN in tcp_shifted_skb()
      net: do not call sock_put() on TIMEWAIT sockets
      l2tp: must disable bh before calling l2tp_xmit_skb()
      bnx2x: record rx queue for LRO packets

Eric Sandeen (1):
      ext3: return 32/64-bit dir name hash according to usage type

Fan Du (1):
      sctp: Use software crc32 checksum when xfrm transform will happen.

Fengguang Wu (1):
      writeback: fix negative bdi max pause

Greg Kroah-Hartman (2):
      USB: serial: option: add support for Inovia SEW858 device
      Linux 3.4.68

Hannes Frederic Sowa (1):
      inet: fix possible memory corruption with UDP_CORK and UFO

Jiri Benc (1):
      ipv4: fix ineffective source address selection

Johannes Berg (1):
      wireless: radiotap: fix parsing buffer overrun

Marc Kleine-Budde (2):
      can: dev: fix nlmsg size calculation in can_get_size()
      net: vlan: fix nlmsg size calculation in vlan_get_size()

Marcelo Ricardo Leitner (1):
      ipv6: restrict neighbor entry creation to output flow

Mariusz Ceier (1):
      davinci_emac.c: Fix IFF_ALLMULTI setup

Mathias Krause (3):
      proc connector: fix info leaks
      unix_diag: fix info leak
      connector: use nlmsg_len() to check message length

Mikulas Patocka (1):
      dm snapshot: fix data corruption

Salva Peir=F3 (2):
      farsync: fix info leak in ioctl
      wanxl: fix info leak in ioctl

Sebastian Hesselbarth (2):
      net: mv643xx_eth: update statistics timer from timer context only
      net: mv643xx_eth: fix orphaned statistics timer crash

Seif Mazareeb (1):
      net: fix cipso packet validation when !NETLABEL

Vlad Yasevich (3):
      bridge: Correctly clamp MAX forward_delay when enabling STP
      net: dst: provide accessor function to dst->xfrm
      sctp: Perform software checksum if packet has to be fragmented.


--4Ckj6UjgE2iN1+kY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSeaX1AAoJEDjbvchgkmk+ZJgQAKFUK48MsIt1I0t47hKV7+O6
1n7RGPv/+aueLthNvh1953VV8PEC6DD7wAZw45+7cqFKSk0MmeP7Y9od40MhZQ1u
up579xSlWPrvV8c7gQPiN0ze8To30oRiUpriMIXRd3yZqiBbLQ9ej1igKlzgJr7E
iTYncOSZw9k8LzoU+/u5dIcOsU7s3LTOQtjFeIzip18pJ9Mzrxq7NnzJab/Ulmlq
YTost5eVcmutpY/Mi0eLhnZIvF2eIhdvk6YTS4oxHZkuFIVvJoCdjBLcX6aZBepV
nRWDuQFEEWI6cJq7pbZWva0RdHAgK5QxHsWoZG8KXq4mNkmQdDkosUHZIHgYG7ea
ywnWBhPJs/0TM2vEIxd8g9mOjwQcDfQzlWYv8n/aLa6VcVZUFvwLvU4e4MRmRSrB
E3BausOLktjIj51xRo5NTjVn/3kIBZ3sZQIZGlsjDXWCmyWNyBf9IeVyUdr1vUb8
DBrNn2rtnwJPgo5JzsVKfKkjYNgzdTILCMPGeKRdUHkSfeY+GQmNTdHqTvcQ2YbM
GPIyPH+1YFo7HEmmaWEp/H3zFlL7rckwaDS5YBzCwS0qvPPTzdC7wlw6T+EILvEj
eESTOsGgU7zTWW+jMCPMVl1jvG9qPNLR1po+w/xNUMPvnANQvtaeuDxO8bmDx/Tu
N8krxaieIZYw8ZP5eVqA
=qRb5
-----END PGP SIGNATURE-----

--4Ckj6UjgE2iN1+kY--
