Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753707Ab3F0R6L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 13:58:11 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35878 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752593Ab3F0R6K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 13:58:10 -0400
Date: Thu, 27 Jun 2013 10:58:08 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.0.84
Message-ID: <20130627175808.GA23830@kroah.com>
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

I'm announcing the release of the 3.0.84 kernel.

All users of the 3.0 kernel series must upgrade.

The updated 3.0.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-3.0.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dsu=
mmary

thanks,

greg k-h

------------

 Makefile                              |    2=20
 arch/tile/lib/exports.c               |    2=20
 arch/x86/kvm/x86.c                    |    5 --
 drivers/net/gianfar_ptp.c             |    1=20
 drivers/usb/serial/ti_usb_3410_5052.c |    3 -
 drivers/usb/serial/ti_usb_3410_5052.h |    4 +
 include/linux/rculist_nulls.h         |    7 ++-
 include/linux/socket.h                |    3 +
 net/compat.c                          |   13 +++++-
 net/ipv4/ip_gre.c                     |    2=20
 net/ipv4/ipip.c                       |    2=20
 net/ipv4/tcp.c                        |    6 ++
 net/ipv4/tcp_output.c                 |   10 ++--
 net/ipv6/addrconf.c                   |    4 +
 net/ipv6/ip6_output.c                 |    2=20
 net/l2tp/l2tp_ppp.c                   |    6 +-
 net/netlabel/netlabel_domainhash.c    |   69 +++++++++++++++++++++++++++++=
+++++
 net/packet/af_packet.c                |    5 --
 net/sctp/socket.c                     |    6 ++
 net/socket.c                          |   67 ++++++++++++++++++++++-------=
----
 sound/usb/card.c                      |   22 +++++++++-
 21 files changed, 193 insertions(+), 48 deletions(-)

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

Gao feng (1):
      ipv6: assign rt6_info to inet6_ifaddr in init_loopback

Greg Kroah-Hartman (1):
      Linux 3.0.84

Guillaume Nault (2):
      l2tp: Fix PPP header erasure and memory leak
      l2tp: Fix sendmsg() return value

Paul Moore (1):
      netlabel: improve domain mapping validation

Wei Yongjun (1):
      gianfar: add missing iounmap() on error in gianfar_ptp_probe()

Zhanghaoyu (A) (1):
      KVM: x86: remove vcpu's CPL check in host-invoked XCR set


--17pEHd4RhPHOinZp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRzH0wAAoJEDjbvchgkmk+RKcP/RVcrcok0MTti0IoMa0Ac4MB
ljQyZJ1VyvD2vvkMFWYZlrCPSNjFwdvgQrUYWMkjrsXSZ97WmFHuLsdMIV7Ubytx
Th1pRFpQezCq1dHAn0/Ks7QQISVTfgltjvq7bkMO+oPwvjBDfC+O6aKapOjeu2dZ
9rC99NqvIcpmme2/Ts0D/V9hVACvswPn1IOSKTOA3FsH1n86ln+WnJHFJjubRypd
CVJKXJf6pEwMPmF70NGIHxQ5vFOpt6ljcFHwLv1XPp2XtuGIzId6aeEorgCbGjPM
5ROe9yXWzI0FmoKHHS+aNTcmljXEEWfJ1O3HYwtl5sHjVTadJv2ya7De7OKUzdBI
/bYT0FCMgDOrHwVjo5aSZ/FCJDDW75sdOHSMma/CpFy8utIYVzjM8oRQAn+CFPMW
j57Cwo23W/enjemrNRIKLtIjEDv286Lnajrb0WLPluZQzacNPit+u62H0O/M5API
t1X+UWWducIbraIjrbANHszZqmw6PfL7GoNgnvbhs+RzlGfSMyY13y++hfouuTAw
Q7OwPipAGsLKTqHhxHb7BtSLrGhWCjsf8PRGcJGl09BjWA7817CpjnDe+VGUMbVm
XkU51WX+1Kwu45VJTw9RhGOJG1yfDQCIYiJU8Md0gfHfyptsp/idtNGOLJ3t1M8e
xkwzySbMc9VxiXgJtkWZ
=TUq2
-----END PGP SIGNATURE-----

--17pEHd4RhPHOinZp--
