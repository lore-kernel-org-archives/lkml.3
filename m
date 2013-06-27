Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754130Ab3F0SeF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 14:34:05 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36413 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753671Ab3F0SeD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 14:34:03 -0400
Date: Thu, 27 Jun 2013 11:34:01 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.4.51
Message-ID: <20130627183401.GA27968@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="17pEHd4RhPHOinZp"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--17pEHd4RhPHOinZp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.4.51 kernel.

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

 Makefile                                     |    2=20
 arch/tile/lib/exports.c                      |    2=20
 arch/x86/kvm/x86.c                           |    5 -
 drivers/clk/clk.c                            |    1=20
 drivers/input/touchscreen/cyttsp_core.c      |    2=20
 drivers/net/bonding/bond_alb.c               |    6 ++
 drivers/net/bonding/bonding.h                |   13 +++++
 drivers/net/ethernet/freescale/gianfar_ptp.c |    1=20
 drivers/net/ethernet/realtek/8139cp.c        |    1=20
 drivers/net/ethernet/realtek/r8169.c         |   41 ++++++++++------
 drivers/net/team/team_mode_roundrobin.c      |    2=20
 drivers/target/iscsi/iscsi_target_erl0.c     |    4 -
 drivers/usb/serial/ti_usb_3410_5052.c        |    3 -
 drivers/usb/serial/ti_usb_3410_5052.h        |    4 +
 fs/notify/inotify/inotify_user.c             |    6 +-
 include/linux/rculist_nulls.h                |    7 ++
 include/linux/socket.h                       |    3 +
 net/compat.c                                 |   13 ++++-
 net/ipv4/ip_gre.c                            |    2=20
 net/ipv4/ipip.c                              |    2=20
 net/ipv4/tcp.c                               |    7 +-
 net/ipv4/tcp_input.c                         |   23 +++++----
 net/ipv4/tcp_output.c                        |   10 ++-
 net/ipv6/addrconf.c                          |    4 +
 net/ipv6/ip6_output.c                        |    2=20
 net/l2tp/l2tp_ppp.c                          |    6 +-
 net/netlabel/netlabel_domainhash.c           |   69 ++++++++++++++++++++++=
+++++
 net/packet/af_packet.c                       |    5 -
 net/sctp/socket.c                            |    6 ++
 net/socket.c                                 |   67 +++++++++++++++++-----=
----
 sound/usb/card.c                             |   22 +++++++-
 sound/usb/mixer.c                            |    1=20
 32 files changed, 264 insertions(+), 78 deletions(-)

Anders Hammarquist (1):
      USB: serial: ti_usb_3410_5052: new device id for Abbot strip port cab=
le

Andy Lutomirski (1):
      net: Block MSG_CMSG_COMPAT in send(m)msg and recv(m)msg

Chris Metcalf (1):
      tilepro: work around module link error with gcc 4.7

Clemens Ladisch (1):
      ALSA: usb-audio: work around Android accessory firmware bug

Daniel Borkmann (2):
      net: sctp: fix NULL pointer dereference in socket destruction
      packet: packet_getname_spkt: make sure string is always 0-terminated

Eric Dumazet (5):
      tcp: fix tcp_md5_hash_skb_data()
      ipv6: fix possible crashes in ip6_cork_release()
      tcp: xps: fix reordering issues
      ip_tunnel: fix kernel panic with icmp_dest_unreach
      net: force a reload of first item in hlist_nulls_for_each_entry_rcu

Ferruh Yigit (1):
      Input: cyttsp - fix memcpy size param

Francois Romieu (1):
      r8169: fix offloaded tx checksum for small packets.

Gao feng (1):
      ipv6: assign rt6_info to inet6_ifaddr in init_loopback

Greg Kroah-Hartman (1):
      Linux 3.4.51

Guillaume Nault (2):
      l2tp: Fix PPP header erasure and memory leak
      l2tp: Fix sendmsg() return value

Jiri Pirko (1):
      team: check return value of team_get_port_by_index_rcu() for NULL

Joern Engel (1):
      target/iscsi: don't corrupt bh_count in iscsit_stop_time2retain_timer=
()

Lai Jiangshan (1):
      clk: remove notifier from list before freeing it

Nandita Dukkipati (1):
      tcp: bug fix in proportional rate reduction.

Paul Moore (1):
      netlabel: improve domain mapping validation

Takashi Iwai (1):
      ALSA: usb-audio: Fix invalid volume resolution for Logitech HD Webcam=
 c310

Wei Yongjun (1):
      gianfar: add missing iounmap() on error in gianfar_ptp_probe()

Zhanghaoyu (A) (1):
      KVM: x86: remove vcpu's CPL check in host-invoked XCR set

Zhao Hongjiang (1):
      inotify: invalid mask should return a error number but not set it

Zheng Li (1):
      bonding: rlb mode of bond should not alter ARP originating via bridge

stephen hemminger (1):
      8139cp: reset BQL when ring tx ring cleared


--17pEHd4RhPHOinZp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRzIWZAAoJEDjbvchgkmk+74EQAIsZc3YhTfui8sYVWgeJaYOB
7y4mSXbbC/FozNyjgLqJoS9ZRqXuSh4nmeYNuSZMmDYLVVylpKadBDBsR4lfW4Yk
KlLam9fDKGIUdlRTPDXCiiUUl4AGrG5awrZ1pHYcKNGU2PJUXCtVi3ptcY6oQA/3
FSYKdya4ppIidMegXTZmhqhQzDZRgxksYoIqrbl8BFwzYqD5027hLCLOHry10FjX
8nSLgV6zL7x6aFdV0uhYhkfJwSVcfxrQgyPq0xynY3NdPpVv6mCZ+YEEia3GsYrK
EJxjcNpe5R/WJKE/t7G/vJJJSXLiu4bK3lNn9HJxknHeL+yjyKafVnyUEu3ixVDz
GZqohAWvDzIN82icTSn7PzCR/nA9Ltr/fTjbtJxy1Zt8v/AJfvQLnn4K0O5jJ1pI
xj5vTc2LCRBrVyH3FWO49Qyt9bnNbBqaSl7sfCW6dbVyR4xMpUKM9irehCOIm82z
lG+OA3P1F2PNkyQjdUOYr6jh0ml7iFSnM3BE/UKvD/nbk1WLKa58q/fBd8X0cVh2
CdmIP1q+k6u/0LUZVQUJ7ttZv0pOjNmoL0rQBWO7GegSQW2IJXcTnv/Cp1W1AMZu
EI1OGnb3hdExMI33SQ5JNpuPH2SKUtr2k4IXTmPjvjqT9vmGg30KGNK+cyvf+9G9
6xhXc/WyVEVu76dCLwMK
=S81x
-----END PGP SIGNATURE-----

--17pEHd4RhPHOinZp--
