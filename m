Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752535AbaCIJAs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2014 05:00:48 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:55973 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751398AbaCIJAp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2014 05:00:45 -0400
Date: Sun, 9 Mar 2014 09:00:40 +0000
From: Mark Brown <broonie@kernel.org>
To: Linus Torvalds <torvalds@linux0foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-spi@vger.kernel.org
Message-ID: <20140309090040.GW28112@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fbLRCyggVpgIMbCc"
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


--fbLRCyggVpgIMbCc
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

It seems there's something about your e-mail address that stops me
typing properly...

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

--fbLRCyggVpgIMbCc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTHC21AAoJELSic+t+oim911YP/3GQGuyVlFtFCGZZ/aKfFxhN
1QZfiLVa7heRjGXWcURSXFaEShERg067f0o5j8sZybHZ4Q5nz96oZ8w4V32jugnS
b63S+cKlucPEM7Kh90c0kDOP3m4+yvWqck8hPsGH13NDLBRsqTjxJuHS+qYrCgJJ
7NP7cS79rmJHowtxMN/Fr4neqOoWm3NWshqm5y3CWZI/7gNeqcl8vKwvanbQfv1d
xz9qGI9BWQtFnzobPxixJgDR+PVFAFxXo7Z2agBuDi4Fo8xp714uTVEJgZHfGdUD
VaffdKPOT563U8QGTRn7870plomS8J4iaWET+nraIeChIF+n8WOaWdcsgSlzNSqg
jEhrBnfIa9zexH8MDUp6e2EWp17PASKl5PkvTATTcxnBSc/R1Fe+l5v13wRaLeOr
kpT6BrUvzq28VrKkac5hU0Cn/EkNb4czXwvsXAW+bJaOGTvgoTiu9s3SvvNiK+9F
nXU90pCGqJxN7nwtmMGvq92HcqJg7R0yf9CWFB66KQjD1kL8yMTbnEUXRCLSgM85
Xpuyn2/l1WCfBU/+17Q0nNoNOge8mMvMlbbjAucMi0QhQ2Mf7lmVxbL3/ju5ddmY
9aitUaER6iLW51grTYUS7sCjUR0uL7v0JrfmctBS+2C9l/5LAoas6j7wElrgiy2/
6xn4saHvX7UVUX+6rMkX
=urvR
-----END PGP SIGNATURE-----

--fbLRCyggVpgIMbCc--
