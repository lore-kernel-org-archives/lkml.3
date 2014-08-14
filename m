Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753820AbaHNEFw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 00:05:52 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53529 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753581AbaHNEFv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 00:05:51 -0400
Date: Thu, 14 Aug 2014 12:05:04 +0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.16.1
Message-ID: <20140814040504.GA7306@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lrZ03NoBR/3+SXJZ"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--lrZ03NoBR/3+SXJZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

I'm announcing the release of the 3.16.1 kernel.

All users of the 3.16 kernel series must upgrade.

The updated 3.16.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-3.16.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                |    4 ++--
 arch/sparc/include/asm/tlbflush_64.h    |   12 ++----------
 arch/sparc/kernel/ldc.c                 |    2 +-
 arch/sparc/math-emu/math_32.c           |    2 +-
 arch/sparc/mm/init_64.c                 |   31 +++++++++++++++++++++++++++++++
 drivers/net/ethernet/broadcom/tg3.c     |   22 ++++++++++++----------
 drivers/net/ethernet/brocade/bna/bnad.c |    2 +-
 drivers/net/macvlan.c                   |    1 +
 drivers/net/phy/mdio_bus.c              |    1 -
 drivers/sbus/char/bbc_envctrl.c         |    6 ++++++
 drivers/sbus/char/bbc_i2c.c             |   11 ++++++++---
 drivers/tty/serial/sunsab.c             |    9 +++++++++
 include/net/ip_tunnels.h                |    1 +
 lib/iovec.c                             |    4 ++++
 net/batman-adv/fragmentation.c          |   10 +++++++---
 net/core/skbuff.c                       |    2 +-
 net/ipv4/ip_tunnel.c                    |   29 ++++++++++++++++++-----------
 net/ipv4/tcp_vegas.c                    |    3 ++-
 net/ipv4/tcp_veno.c                     |    2 +-
 net/sctp/output.c                       |    2 +-
 20 files changed, 109 insertions(+), 47 deletions(-)

Andrey Utkin (1):
      arch/sparc/math-emu/math_32.c: drop stray break operator

Christoph Paasch (2):
      tcp: Fix integer-overflows in TCP veno
      tcp: Fix integer-overflow in TCP vegas

Christopher Alexander Tobias Schulze (2):
      bbc-i2c: Fix BBC I2C envctrl on SunBlade 2000
      sunsab: Fix detection of BREAK on sunsab serial console

David S. Miller (2):
      sparc64: Do not insert non-valid PTEs into the TSB hash table.
      sparc64: Guard against flushing openfirmware mappings.

Dmitry Popov (1):
      ip_tunnel(ipv4): fix tunnels with "local any remote $remote_ip"

Eric Dumazet (1):
      sctp: fix possible seqlock seadlock in sctp_packet_transmit()

Fabio Estevam (1):
      Revert "net: phy: Set the driver when registering an MDIO bus device"

Greg Kroah-Hartman (1):
      Linux 3.16.1

Ivan Vecera (1):
      bna: fix performance regression

Prashant Sreedharan (1):
      tg3: Modify tg3_tso_bug() to handle multiple TX rings

Sasha Levin (1):
      iovec: make sure the caller actually wants anything in memcpy_fromiovecend

Sowmini Varadhan (1):
      sparc64: ldc_connect() should not return EINVAL when handshake is in progress.

Sven Eckelmann (1):
      batman-adv: Fix out-of-order fragmentation support

Vlad Yasevich (2):
      macvlan: Initialize vlan_features to turn on offload support.
      net: Correctly set segment mac_len in skb_segment().


--lrZ03NoBR/3+SXJZ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT7DVwAAoJEDjbvchgkmk+o7UQANWKCGvH4t2tqpqPHaCG52By
8eWP+BeTygeNk3fk7x6x3w1o+QWAvlxWB/jxqEetqsBtH7TVCZw38fDr+Jn46HMM
DiYjWtwLv8BT2X6dkyRiTzu3XaSOe5HtNNZcCryJZTnlXeWtlrlP66KQBFQdSksY
YzEbLAY3DMlEJWnNucUVfhxiMXdPt7IKTvtrqOtvnuvA7h55APW+onEWoYn9vUum
/GG8W+kahVvv2TB94J8jUmtXhswzhEsUXl8V1YYoeKtgW3tIrZlyOMVw9+Bc6aQI
WyqQ4ArBFO2IvuUSJcvXA+EVRe0d8pV3updT8weYLmFnEeYKEptvcIrsfFpmLAk4
qYn7FoABXdMWIGJy/YxBa14sXnvyYsqZ3YBtzTyJesYkudrmxJ26WBMDvFQOGclm
UoaE7hQTwM/6jmjmdhATQvRZFfJMmWxvxMEmOCm3X31xc9zGPtHau4/RKznj3qaG
b7iOXj+sJfE8oRlQRtIFO+SokvUIDqxVFxftTKWxuNjcyNNKM+hP6AbYwYjciooa
WEQNfX3SOHoeDWmscpXs6rVtaMNqO9xwzabFRpZd8QZEjq7OkQ9ZRrocHa7tqiBf
zVuuYxStwlMu/TbMOmBXPxzvUZQSS0POITbo4U1jd7cnDSM+iC/kRfVSbZxjWXnU
cplePDvMKIzJsCoaaDJ5
=/ZHS
-----END PGP SIGNATURE-----

--lrZ03NoBR/3+SXJZ--
