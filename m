Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753854Ab3AWNXH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 08:23:07 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:52871 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750887Ab3AWNXE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 08:23:04 -0500
Date: Wed, 23 Jan 2013 14:23:01 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        Jean Delvare <khali@linux-fr.org>, Ben Dooks <ben-linux@fluff.org>
Subject: [PULL REQUEST] i2c for 3.8
Message-ID: <20130123132301.GA18005@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7AUc2qLy4jB3hD7Z"
Content-Disposition: inline
X-Mutt-PGP: S<0x7D7F551B>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7AUc2qLy4jB3hD7Z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Linus,

here are a few, typical driver fixes for the I2C subsystem. Please pull.

Thanks,

   Wolfram


The following changes since commit 7d1f9aeff1ee4a20b1aeb377dd0f579fe9647619:

  Linux 3.8-rc4 (2013-01-17 19:25:45 -0800)

are available in the git repository at:

  git://git.pengutronix.de/git/wsa/linux.git i2c-embedded/for-current

for you to fetch changes up to 9dd3162deb67e9d2dc08af8bedea61c41fae85a8:

  i2c-designware: add missing MODULE_LICENSE (2013-01-22 16:43:34 +0100)

----------------------------------------------------------------
Aaro Koskinen (2):
      i2c: omap: errata i462: fix incorrect ack for arbitration lost interr=
upt
      i2c: omap: fix draining irq handling

Barry Song (1):
      i2c: sirf: register i2c_client from dt child-nodes in probe entry

Fabio Estevam (1):
      i2c: mxs: Fix type of error code

Laurent Navet (1):
      i2c: muxes: fix wrong use of sizeof(ptr)

Marek Vasut (1):
      i2c: mxs: Fix misuse init_completion

Mika Westerberg (1):
      i2c-designware: add missing MODULE_LICENSE

 drivers/i2c/busses/i2c-designware-core.c |    4 ++++
 drivers/i2c/busses/i2c-mxs.c             |    6 ++++--
 drivers/i2c/busses/i2c-omap.c            |    6 +++---
 drivers/i2c/busses/i2c-sirf.c            |    4 ++++
 drivers/i2c/muxes/i2c-mux-pinctrl.c      |    2 +-
 5 files changed, 16 insertions(+), 6 deletions(-)

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--7AUc2qLy4jB3hD7Z
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlD/5DUACgkQD27XaX1/VRt5qwCfUisVfXBxKaIby+oc3dSMP+cQ
NRUAnA03Hta7H07pBdt+x/ZFYMDK3WpB
=z2vQ
-----END PGP SIGNATURE-----

--7AUc2qLy4jB3hD7Z--
