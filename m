Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752092AbaCGFER (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 00:04:17 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:57201 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751545AbaCGFEO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 00:04:14 -0500
Date: Fri, 7 Mar 2014 13:04:09 +0800
From: Mark Brown <broonie@kernel.org>
To: Linus Torvalds <torvalds@linux.foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-spi@vger.kernel.org
Message-ID: <20140307050409.GC13126@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ObnMMNQzBhsQt0AA"
Content-Disposition: inline
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 202.175.88.218
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [GIT PULL] spi fixes for v3.14
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ObnMMNQzBhsQt0AA
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

--ObnMMNQzBhsQt0AA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTGVNGAAoJELSic+t+oim9rxoP/3jkhbAbDMlY+EPInEqRFOlI
Iob7DPhGNa+ped37ls+TWJ8wuIFKo6zahEwfct/voxTe6u3aMeh4D/5gqYh29GMS
VJhtx6VfkEL85rLuyM7/WO6GcyAgLBdaZ4BjbqND7Gxs90USB0cjLXEjA0MbzOAE
eoSs6ybdGCn0h5MD91gJKDI4hs+HlJUo2B2abWo9V1K+VzVFhkJatNSvDIcPlBKm
oIh22SbFuGigXQLmfqwQxY8VNxq4duQpKFDkURIpZj7zFl1QiKIFMgs/k7rhvl8f
aOFv0Jj7/nHKoPxRvuZdqDl23jE8OpF2VA7gg1mubr3zLUlGNxyoM5lKHIivJr6B
C6YHhgfG5pSKz/0LuwPUqX4XEom90AGg0DYr8QtKKkM+hoNrlYZFYxWF0tTNn2/0
B7zvCYeJg1x3QwfT0ZWlx9z8JywGCX2HpgN/tL3YFUL9QKDazPVZP3fpy9JeTrVE
SAi1Awy7lbLIjK4XGizYFwnrmVzE6b3R1CSDyZLCcdQPUU891cCqrA5E9QmZarPq
PJSnv8/ReMMM1UJHSVYTbuKqqCUoqjwl3sdUaYbIt1YJRbf5P2Q1Gqwb1HkV1D1E
umHyZI+tK0M9hGqppgcCpJVpH6dgJxilRMDvdfgwfTInpEByQ2X/g6hpI0cuGtIM
7utzg3H+jUbru/MnWgfW
=ld+d
-----END PGP SIGNATURE-----

--ObnMMNQzBhsQt0AA--
