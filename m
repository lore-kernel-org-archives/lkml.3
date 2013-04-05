Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162088Ab3DERCx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 13:02:53 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60608 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1162028Ab3DERCw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 13:02:52 -0400
Date: Fri, 5 Apr 2013 18:02:50 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org
Subject: [GIT PULL] SPI updates for v3.9
Message-ID: <20130405170250.GN6597@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="R92lf0Oi2sxyK3LA"
Content-Disposition: inline
X-Cookie: Make a wish, it might come true.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--R92lf0Oi2sxyK3LA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit f6161aa153581da4a3867a2d1a7caf4be19b6ec9:

  Linux 3.9-rc2 (2013-03-10 16:54:19 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/misc.git tags/spi-fix-v3.9-rc5

for you to fetch changes up to 1ad849aee5f53353ed88d9cd3d68a51b03a7d44f:

  spi/mpc512x-psc: optionally keep PSC SS asserted across xfer segmensts (2013-04-01 14:30:26 +0100)

----------------------------------------------------------------
spi: Fixes for v3.9

A bunch of small driver fixes plus a fix for error handling in the core
- nothing too exciting overall.

----------------------------------------------------------------
Anatolij Gustschin (1):
      spi/mpc512x-psc: optionally keep PSC SS asserted across xfer segmensts

Bryan Freed (1):
      spi: Unlock a spinlock before calling into the controller driver.

Girish K S (1):
      spi/s3c64xx: modified error interrupt handling and init

Jonas Gorski (1):
      spi/bcm63xx: don't disable non enabled clocks in probe error path

Kevin Cernekee (1):
      spi/bcm63xx: Remove unused variable

Laxman Dewangan (1):
      spi: slink-tegra20: move runtime pm calls to transfer_one_message

 drivers/spi/spi-bcm63xx.c       |    3 +--
 drivers/spi/spi-mpc512x-psc.c   |    2 +-
 drivers/spi/spi-s3c64xx.c       |   41 ++++++++++++++++++++++++---------------
 drivers/spi/spi-tegra20-slink.c |   25 ++++++++----------------
 drivers/spi/spi.c               |   15 +++++++-------
 5 files changed, 42 insertions(+), 44 deletions(-)

--R92lf0Oi2sxyK3LA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRXwOyAAoJELSic+t+oim95UYP/1gNw7+YHlx42g1Hmt8km81H
X3nJpNbUoafkw2JNw0nyHLA2JvPq6OEOwNa8CYalhoBX+Tnrkr25F3pYZa2HLfpI
Hz3dBnH3u1wdpDQlE7qirHFNmAv6gQXh4R7Skf1Zsb8aFi/tkCooYg1jZMVXa12c
TAightVHVqYltFLmqPUQkljlPtfK4Oz61aa6NR4eXpwTgXjRKGJ0NrQ7PFE14XwC
vjzKWHBkCBXGSnURZ+Gi8OxbpLntgIuNvcLdXWImUfma/g0GmhUGwUNLNzLC567z
U+Lrm7UaDnHnnztJ+tUq1Zejed85CdK+WeHCtIIZb8hj6N0CwcJ/ZGJ+6etD5phc
0BlKnpVSLxim6mPCrLPnmRBY0Q+jLjlN1OFLCmbrPK2UHeBNLqsUnkDXWDB+8gn+
jHKmXwUXh57QObjJfDHz6Lg2/O74mxzOh6/jpS17PiIEZhDbz98dt7C1XKomnels
5Icc5FOhgwDIF+dn0yWPesg/dc5XWyEbuap8v3Cz2yD4fZyruvkccGWxzK2f+ojm
6WJm7/JMHU2o+J97wCtWzX/S02bNelPQFDSq+zKjKSk0ITqirWMo0w2mzXnMD6le
PPFIt5JU4peqqo/r4am9gySPl90QYNyGn2yB+/o5y7M6a5RZOge1m05mNM5LOM7j
Aw80sOgDU0hy9eOrvDYj
=Bo3X
-----END PGP SIGNATURE-----

--R92lf0Oi2sxyK3LA--
