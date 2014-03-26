Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755505AbaCZSeT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 14:34:19 -0400
Received: from mail-yh0-f41.google.com ([209.85.213.41]:35441 "EHLO
	mail-yh0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330AbaCZSeR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 14:34:17 -0400
Date: Wed, 26 Mar 2014 15:34:11 -0300
From: Gustavo Padovan <gustavo@padovan.org>
To: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: pull request: bluetooth-next 2014-03-24
Message-ID: <20140326183411.GB1741@joana>
Mail-Followup-To: Gustavo Padovan <gustavo@padovan.org>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20140324173332.GA2214@joana>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0F1p//8PRICkK4MW"
Content-Disposition: inline
In-Reply-To: <20140324173332.GA2214@joana>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0F1p//8PRICkK4MW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi John,

2014-03-24 Gustavo Padovan <gustavo@padovan.org>:

> Hi John,
>=20
> Here follow another set of patches to 3.15. This is mostly a bug fix pull
> request with the exception of one commit from Marcel which adds tracking =
to
> the current configured LE scan type parameter.

There is one more fix that we want to include in this pull request. Here
follows a new pull request, please pull, Thanks.=20

	Gustavo

--
The following changes since commit 40b552aa5a0bfa785bc7ddb5c2d7965b1e0bb08d:

  Bluetooth: Enforce strict Secure Connections Only mode security (2014-03-=
19 23:30:32 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next.gi=
t for-upstream

for you to fetch changes up to e8b1ab9e6d30394e0df3e4f60bf56c4dc9bf0863:

  Bluetooth: Fix returning peer address in pending connect state (2014-03-2=
6 09:31:33 -0700)

----------------------------------------------------------------
Amitkumar Karwar (1):
      Bluetooth: btmrvl: don't consume all vendor specific events

Johan Hedberg (11):
      Bluetooth: Fix passkey endianess in user_confirm and notify_passkey
      Bluetooth: Fix address value for early disconnection events
      Bluetooth: Fix potential NULL pointer dereference in SMP
      Bluetooth: Add missing cmd_status handler for LE_Start_Encryption
      Bluetooth: Fix SMP confirmation callback handling
      Bluetooth: Add SMP flag to track which side is the initiator
      Bluetooth: Don't try to confirm locally initiated SMP pairing
      Bluetooth: Remove LTK re-encryption procedure
      Bluetooth: Fix potential NULL pointer dereference in smp_conn_security
      Bluetooth: Remove unnecessary assignment in SMP
      Bluetooth: Fix returning peer address in pending connect state

Marcel Holtmann (1):
      Bluetooth: Track current configured LE scan type parameter

Thomas Gleixner (1):
      Bluetooth: bluecard: Use del_timer_sync() in teardown path

 drivers/bluetooth/bluecard_cs.c  |  2 +-
 drivers/bluetooth/btmrvl_main.c  | 11 +++---
 include/net/bluetooth/hci_core.h |  3 +-
 net/bluetooth/hci_event.c        | 63 +++++++++++++++++++++++++++++++-
 net/bluetooth/l2cap_sock.c       |  3 +-
 net/bluetooth/mgmt.c             | 20 ++--------
 net/bluetooth/rfcomm/sock.c      |  3 +-
 net/bluetooth/smp.c              | 87 ++++++++++++++++++------------------=
--------
 net/bluetooth/smp.h              |  7 +---
 9 files changed, 115 insertions(+), 84 deletions(-)


--0F1p//8PRICkK4MW
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTMx2iAAoJEPs3PUX4s20o0+kP/RMuRIbvYaOEUPfJe5QUrLEL
AKtM+6lHuBR8T7eUTB4iYhZ2TBAuNNmwlHuRspG+Tku1lS4fbFwDdF+QYKketCU6
QbMcbvk302Bz6+Bi7Y4QvX+LHH+KTQ7biUbpCwqTKzXD/VJGDFeLpR/vxH02zxxW
GLGYwa3hAL9b/tgUllFl/67eAaomEiSrQh/Hwi5X/MpuEhIwlrv0ouOIqGZ0VxJh
edRiF2h7QiFTO6FcigX5+yeTfNu0OmKEvK1qOJALNsHYQVHf3ffAQn8vTKwnUcuR
lIG9m7Gw3JGuN7kcACgMB2MSDsfKWvTM/NbQLyZklPneJPsuLSfCPsP10vZGR6kX
43LJJMr8ANinJ2+t8haIJrqjjsfFVGJ++MzLFXjjiJJk16IRndQ6nAgxa7ekMELj
3aZHvKnZMQhrz1/VTqbcFv2+AShJF/JAGV00BY1QrsiboX5VjTgpPE71dLQDNDXU
4e4l4FBCX5Lcv2SM1tA1f2wz5fWxrraH1CPaL3PBV2K5icFy+tU1HrrtpTWns0UP
ZSNmB7DZJHA3N3ELMj7KBscV2SS2pIH3gJTZD0ntatpuQGI8IHfU6Sqn6A+FKSDt
VFJM/7UvDEEdmGAAzFA3bNkGIS8b7S/5BlD/hZTHac+aI5zuZHlodVUV4vsq0077
mLkZrV8k+DZEBT0Id9AN
=qkBQ
-----END PGP SIGNATURE-----

--0F1p//8PRICkK4MW--
