Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752608AbaCIJGj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2014 05:06:39 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:55979 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751398AbaCIJGi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2014 05:06:38 -0400
Date: Sun, 9 Mar 2014 09:06:32 +0000
From: Mark Brown <broonie@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-spi@vger.kernel.org
Message-ID: <20140309090632.GX28112@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8i1mnYwBm74ExquZ"
Content-Disposition: inline
X-Cookie: Oh no, not again.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.89.236
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [GIT PULL] spi fixes for v3.14
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--8i1mnYwBm74ExquZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

The following changes since commit 0414855fdc4a40da05221fc6062cccbc0c30f169:

  Linux 3.14-rc5 (2014-03-02 18:56:16 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/spi.git tags/spi-v3=
=2E14-rc5

for you to fetch changes up to d930acfdb021f9d61e156c4f53d42043305f5bf6:

  Merge remote-tracking branches 'spi/fix/ath79', 'spi/fix/atmel', 'spi/fix=
/coldfire', 'spi/fix/fsl-dspi', 'spi/fix/imx' and 'spi/fix/topcliff-pch' in=
to spi-linus (2014-03-07 11:08:13 +0800)

Your e-mail address really does bring out the typos...

----------------------------------------------------------------

spi: Fixes for v3.14

A scattering of driver specific fixes here.  The fixes from Axel cover
bitrot in apparently unmaintained drivers, the at79 bug is fixing a
glitch on /CS during initialisation of some devices which could break
some slaves and the remainder are fixes for recently introduced bugs
=66rom the past release cycle or so.

----------------------------------------------------------------
Alexander Stein (2):
      spi/topcliff-pch: Fix DMA channel
      spi-topcliff-pch: Fix probing when DMA mode is used

Axel Lin (2):
      spi: fsl-dspi: Fix getting correct address for master
      spi: coldfire-qspi: Fix getting correct address for *mcfqspi

Gabor Juhos (1):
      spi: spi-ath79: fix initial GPIO CS line setup

Mark Brown (1):
      Merge remote-tracking branches 'spi/fix/ath79', 'spi/fix/atmel', 'spi=
/fix/coldfire', 'spi/fix/fsl-dspi', 'spi/fix/imx' and 'spi/fix/topcliff-pch=
' into spi-linus

Philippe De Muyter (1):
      spi: spi-imx: spi_imx_remove: do not disable disabled clocks

Wenyou Yang (1):
      spi: atmel: add missing spi_master_{resume,suspend} calls to PM callb=
acks

 drivers/spi/spi-ath79.c         |  4 ++--
 drivers/spi/spi-atmel.c         | 17 ++++++++++++++++-
 drivers/spi/spi-coldfire-qspi.c |  6 ++++--
 drivers/spi/spi-fsl-dspi.c      |  6 +++---
 drivers/spi/spi-imx.c           |  4 ++--
 drivers/spi/spi-topcliff-pch.c  | 15 ++++++++-------
 6 files changed, 35 insertions(+), 17 deletions(-)

--8i1mnYwBm74ExquZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTHC8VAAoJELSic+t+oim9zrkP/A6y1TFbSyK99k1BUElxlKQR
+uzEliBrUfAvGiZ1HwvY3SuOvVXUaX9z243R2bF6JqeAFABCop+Qn5yepZB8RGIc
KMJv/kw+8N7qRmy5KhJtoP6yFlvdpolYJV0qbtZE/As+n/Cy8yTBMYPwMJkPxsKr
MzmZ3SvrISF3SX2n/dcWOJ2BBIWqD08KC8M1eiKMmOAPmyjUMSSpP3gelcTMiPJQ
wcbAort3Jaeq+SNNaFd0n2wAMjYzG5EmyI5UPfkCkKUUA6ACB+Wi6clZC9FQZbpn
lZnOJG0U/z/mXevw9o27EhLW3I6SJt5UYItpnSPVM6vu2UiLjmk2jHEaNgk3lS5R
NsZdE2RXCHdW6tm73oL0MD0/KzwdBThfvTzQBckANzJK9WxOAWgQePBtlSxRE1H5
7tlQQQNQmwpwSBN0OB3sPrIcswKFOCCeSbchYbhpGGlrDJqzl06DmyuxUGsYzirm
TKxQRPwg8hJv6QDHR02qyCUQXMUWXV4g/kQ9ykHs/QRWRM/W5Yf/9kWtoO6JTxfS
e0EAtE4Lkh5TuPxNpCXU2OTXnx9ykQsxHszWdUWdDQ1HWaQPEP5DurquDIUqymBb
Swkyc5ULQCuf46Pu+SkHBeSjgqDe//0oS/rgmkegBJRLpkgp2DmjyhXamAJN2HYF
9aZuJTRFDS/4XCDYkDVo
=Vgxg
-----END PGP SIGNATURE-----

--8i1mnYwBm74ExquZ--
