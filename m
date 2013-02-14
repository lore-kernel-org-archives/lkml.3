Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030235Ab3BNTNa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 14:13:30 -0500
Received: from mail-da0-f50.google.com ([209.85.210.50]:65398 "EHLO
	mail-da0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932474Ab3BNTNZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 14:13:25 -0500
Date: Thu, 14 Feb 2013 11:13:23 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.0.64
Message-ID: <20130214191323.GA25737@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VbJkn9YxBvnuCH5J"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--VbJkn9YxBvnuCH5J
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.0.64 kernel.

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

 MAINTAINERS                         |    6 -
 Makefile                            |    2=20
 drivers/atm/iphase.h                |  146 ++++++++++++++++++-------------=
-----
 drivers/char/virtio_console.c       |    3=20
 drivers/isdn/gigaset/capi.c         |    2=20
 drivers/net/loopback.c              |    5 +
 drivers/net/r8169.c                 |    7 -
 drivers/net/tg3.c                   |   58 +++++++++-----
 drivers/net/wireless/rtlwifi/usb.c  |    4=20
 drivers/net/xen-netback/common.h    |    3=20
 drivers/net/xen-netback/interface.c |   23 +++--
 drivers/net/xen-netback/netback.c   |  117 +++++++++++++++++-----------
 fs/splice.c                         |    4=20
 kernel/resource.c                   |   50 +++++++++---
 net/bridge/br_netfilter.c           |    3=20
 net/core/pktgen.c                   |    9 +-
 net/ipv4/ip_sockglue.c              |    2=20
 net/ipv4/tcp_input.c                |    5 +
 net/ipv6/route.c                    |    3=20
 net/mac80211/ieee80211_i.h          |    6 -
 net/mac80211/offchannel.c           |   17 +---
 net/mac80211/scan.c                 |    6 -
 net/mac80211/work.c                 |    8 -
 net/packet/af_packet.c              |   10 +-
 net/sctp/endpointola.c              |    5 +
 net/sctp/outqueue.c                 |   12 +-
 net/sctp/socket.c                   |    2=20
 27 files changed, 306 insertions(+), 212 deletions(-)

Cong Wang (2):
      net: prevent setting ttl=3D0 via IP_TTL
      pktgen: correctly handle failures when adding a device

Daniel Borkmann (2):
      net: sctp: sctp_setsockopt_auth_key: use kzfree instead of kfree
      net: sctp: sctp_endpoint_free: zero out secret key data

Eric Dumazet (3):
      net: loopback: fix a dst refcounting issue
      tcp: frto should not set snd_cwnd to 0
      tcp: fix MSG_SENDPAGE_NOTLAST logic

Greg Kroah-Hartman (1):
      Linux 3.0.64

Heiko Carstens (1):
      atm/iphase: rename fregt_t -> ffreg_t

Ian Campbell (3):
      xen/netback: shutdown the ring if it contains garbage.
      xen/netback: free already allocated memory on failure in xen_netbk_ge=
t_requests
      netback: correct netbk_tx_err to handle wrap around.

Ilpo J=E4rvinen (1):
      tcp: fix for zero packets_in_flight was too broad

Larry Finger (1):
      rtlwifi: Fix the usage of the wrong variable in usb.c

Marcelo Ricardo Leitner (1):
      ipv6: do not create neighbor entries for local delivery

Matthew Daley (1):
      xen/netback: don't leak pages on failure in xen_netbk_tx_check_gop.

Neil Horman (1):
      sctp: refactor sctp_outq_teardown to insure proper re-initalization

Nithin Nayak Sujir (2):
      tg3: Avoid null pointer dereference in tg3_interrupt in netconsole mo=
de
      tg3: Fix crc errors on jumbo frame receive

Phil Sutter (1):
      packet: fix leakage of tx_ring memory

Sarveshwar Bandi (1):
      bridge: Pull ip header into skb->data before looking into ip header.

Sjur Br=E6ndeland (1):
      virtio_console: Don't access uninitialized data.

Stanislaw Gruszka (1):
      mac80211: synchronize scan off/on-channel and PS states

Stephen Hemminger (1):
      MAINTAINERS: Stephen Hemminger email change

T Makphaibulchoke (1):
      kernel/resource.c: fix stack overflow in __reserve_region_with_split()

Tilman Schmidt (1):
      isdn/gigaset: fix zero size border case in debug dump

Timo Ter=E4s (1):
      r8169: remove the obsolete and incorrect AMD workaround


--VbJkn9YxBvnuCH5J
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRHTdTAAoJEDjbvchgkmk+e/MP/iHMMIchiqOLyY7uVt19igtj
RE3NF9aW6ZDLfQ18bMeZptZg8vh3BhV3Mg+4DF+PnEqVjGCPiWxNapz+e8egWiHA
jXp4qjG7Toc/jM8HZHQ2b81dKFt8OYr50NKdG0fJYH937AzPiCCgNZaOQWGa5+oC
CbfNOx/Gn0J0aUNppI4WH3p1iHgaNm1G5lJqLcL/LBFk3oxCT9cL+OrJXiQQ8LXb
1A8xDAvMEB5qDTC9Da/K4tAzk+9AuCW4sgjT0D74llu2OS3PzQA6lWavKZI9T6dF
cVp/i3dDeKy4ALbonnsm9E8RvZlFnPDI1qVYo5l693AExqlHPF3U4cWhQbnm/uaW
BbpA1wCMJSOJ5Qkcn1ZEK/EfqRQ0HxTvxYCMZA9rv5BsPXNeOT8mLv3iBIZ/eyqx
hI9rcz8Kw3tdaLxPpqNdheQQV7V6H0jysTMwf/8xIpNeBjRF0Sk9qoahWvsvhlP3
IsCgmtca0Us4wNETQ8nGm848L6XJeYyGVf0XOK8Su6oA/iiMUWMuBuDr31xFDzii
DADcimyjnuAt9LGd4pXKflB2u1vgAr87br5teIAokfH69r62zzJCP8bDyLoxlDQu
WrnEyIteVpAoDxNZFYyP9FpgPUXczOfDHojeGQXGskPPpyD0PERhJT0v5SnHFs2l
ty3HY9GCTDjeXz+zdReN
=Ut3i
-----END PGP SIGNATURE-----

--VbJkn9YxBvnuCH5J--
