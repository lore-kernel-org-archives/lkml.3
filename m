Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752272AbaJOKje (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 06:39:34 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57826 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752040AbaJOKjc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 06:39:32 -0400
Date: Wed, 15 Oct 2014 12:38:26 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.10.58
Message-ID: <20141015103826.GA30956@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wac7ysb48OaltWcw"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wac7ysb48OaltWcw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.10.58 kernel.

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

 Makefile                                         |    2=20
 drivers/net/ethernet/broadcom/tg3.c              |   23 +++++-
 drivers/net/ethernet/myricom/myri10ge/myri10ge.c |   88 +++++++++++++++---=
-----
 drivers/net/hyperv/netvsc_drv.c                  |    3=20
 drivers/usb/core/hub.c                           |    6 +
 drivers/usb/core/quirks.c                        |    4 +
 drivers/usb/serial/cp210x.c                      |    2=20
 include/linux/usb/quirks.h                       |    3=20
 include/net/inet_connection_sock.h               |    1=20
 include/net/sctp/command.h                       |    2=20
 include/net/sock.h                               |    1=20
 include/net/tcp.h                                |    1=20
 net/ipv4/tcp_ipv4.c                              |    5 -
 net/ipv4/tcp_output.c                            |    6 -
 net/ipv6/addrconf.c                              |   14 +++
 net/ipv6/ip6_gre.c                               |    4 -
 net/ipv6/sit.c                                   |    6 -
 net/ipv6/tcp_ipv6.c                              |    3=20
 net/l2tp/l2tp_ppp.c                              |    3=20
 net/openvswitch/actions.c                        |    5 +
 net/packet/af_packet.c                           |   17 ++++
 net/packet/internal.h                            |    1=20
 net/sctp/sm_statefuns.c                          |   19 ++++
 23 files changed, 162 insertions(+), 57 deletions(-)

Andreas Bomholtz (1):
      USB: cp210x: add support for Seluxit USB dongle

Eric Dumazet (1):
      packet: handle too big packets for PACKET_V3

Gao feng (1):
      ipv6: reallocate addrconf router for ipv6 address when lo device up

Greg Kroah-Hartman (1):
      Linux 3.10.58

Guillaume Nault (1):
      l2tp: fix race while getting PMTU on PPP pseudo-wire

Jiri Benc (1):
      openvswitch: fix panic with multiple vlan headers

Joe Savage (1):
      USB: serial: cp210x: added Ketra N1 wireless interface support

KY Srinivasan (1):
      hyperv: Fix a bug in netvsc_start_xmit()

Lu Baolu (1):
      USB: Add device quirk for ASUS T100 Base Station keyboard

Neal Cardwell (1):
      tcp: fix tcp_release_cb() to dispatch via address family for mtu_redu=
ced()

Nicolas Dichtel (1):
      ip6_gre: fix flowi6_proto value in xmit path

Per Hurtig (1):
      tcp: fixing TLP's FIN recovery

Shmulik Ladkani (1):
      sit: Fix ipip6_tunnel_lookup device matching criteria

Stanislaw Gruszka (1):
      myri10ge: check for DMA mapping errors

Vlad Yasevich (3):
      tg3: Work around HW/FW limitations with vlan encapsulated frames
      tg3: Allow for recieve of full-size 8021AD frames
      sctp: handle association restarts when the socket is closed.


--wac7ysb48OaltWcw
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUPk6iAAoJEDjbvchgkmk+wIYP/jvpd9dWLp0ns7WPKoe53cJB
QJL/9KZtyVItudziU6oxMiZzoqFO/t/glJOh8nNBieM4VFBj8DFgjprKGuKYnQ0B
y0zeRtXfiNvVB4qIjvSwEPiU6Xr4W82waH9RaxQCBX6WhGJO+TyrcoVx+1vCFK0g
4TBJwEm4n0AujBl7yf7Typ3+0Wqc9r9YWJ5DenreTTRC1cR8X5HCRksJTeLdeSgB
xBRoO2AQcVDEwOvRLM/N8oAKIdArM+P9SdVC7T7B3EYcoS6J4oJFxubHnlEO3i8w
9VIoV37zVGbvmNi3EEg2FVyxOgnYK48yu75atKluKOi/wgZTfo33dNgmKdKi7cCP
Ou4Mj0ChEPIsodyFib1YSiyrf9ioHCIPFCUQR+UhNjz+X0gkj3y7xE0odsPJJ1kB
VQLEeU6idFZhKmKMcMxtJUE2Gpghx4wN+v65Cl/GI4Bi6qtWUMJ59AJqtqs1ACZ3
gHv1QyqZTXg1iy4JftErMQ+NvRIODao5dFxDU4o7DZS119uAjle8pQ/P2L62mHGc
v1z1GcQSuwPW5XhnsYUdTPRF5TcfHxLcrxt74Koj3ERkf+FxAMsiya//Hp8aHl/X
zMBeZBCe0f95WwLlkGIHq6rzDG46KOb4HCa9joigdY5f6lZxa+4REp+sydtgI+ql
pbThQcEMa8tdvTNC5snB
=xCOS
-----END PGP SIGNATURE-----

--wac7ysb48OaltWcw--
