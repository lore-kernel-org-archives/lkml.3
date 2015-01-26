Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753599AbbAZLqr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 06:46:47 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:34530 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753430AbbAZLqg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 06:46:36 -0500
Date: Mon, 26 Jan 2015 11:46:31 +0000
From: Mark Brown <broonie@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-spi@vger.kernel.org
Message-ID: <20150126114631.GZ21293@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="EH85xkKza2NXtwkF"
Content-Disposition: inline
X-Cookie: My LESLIE GORE record is BROKEN ...
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [GIT PULL] spi fixes for v3.19
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--EH85xkKza2NXtwkF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit ec6f34e5b552fb0a52e6aae1a5afbbb1605cc6cc:

  Linux 3.19-rc5 (2015-01-18 18:02:20 +1200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/spi.git tags/spi-v3.19-rc6

for you to fetch changes up to 06a5687f82bd7f1fbf56363351c47e8c337302fc:

  Merge remote-tracking branches 'spi/fix/dw', 'spi/fix/msiof' and 'spi/fix/pxa2xx' into spi-linus (2015-01-26 11:16:27 +0000)

----------------------------------------------------------------
spi: Fixes for v3.19

A few driver specific fixes here, some fixes for issues introduced and
discovered during recent work on the DesignWare driver (which has been
getting a lot of attention recently) and a couple of other drivers.  All
serious things for people who run into them.

----------------------------------------------------------------
Andy Shevchenko (2):
      spi: dw-mid: fix FIFO size
      spi: dw: amend warning message

Axel Lin (1):
      spi: dw: Fix detecting FIFO depth

Mark Brown (1):
      Merge remote-tracking branches 'spi/fix/dw', 'spi/fix/msiof' and 'spi/fix/pxa2xx' into spi-linus

Mika Westerberg (1):
      spi/pxa2xx: Clear cur_chip pointer before starting next message

Yoshihiro Shimoda (1):
      spi: sh-msiof: fix MDR1_FLD_MASK value

 drivers/spi/spi-dw-mid.c   | 1 -
 drivers/spi/spi-dw.c       | 6 +++---
 drivers/spi/spi-pxa2xx.c   | 2 +-
 drivers/spi/spi-sh-msiof.c | 2 +-
 4 files changed, 5 insertions(+), 6 deletions(-)

--EH85xkKza2NXtwkF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJUxikWAAoJECTWi3JdVIfQRrMH/0AwlRphAMjV1pyb0StsVwFw
1TksoMu33c+/DHRotjx3rOFoFSgo+XDs7IM6ZoFAzTA/WeJ5nl5P0tlrVa5zCaqI
ZQ3KK2F10m65tjaJONi1TnFomsX4pKh8Pa5smLE5h/cLnHaFK86b17L39nDReNuF
xMMZoTgLeheeoEeUQ/f9Edmv4hjYeisTumANO1ajqwBfhA3E7oHD7fbxMyXshtTI
ns8lbwVXJ3XpS3pOBw1XgGqoERwypNwjfEOIKWP6x0OsNSh6saLbtLht1p4UY2OC
nrM+YGO/EGeBEGOhAmpWbBYEDgmrnl6EEFN1uRbxXlvyMawnkp7jy11+x5l9iEw=
=aix3
-----END PGP SIGNATURE-----

--EH85xkKza2NXtwkF--
