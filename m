Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752568Ab3FXLr0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 07:47:26 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:53377 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751952Ab3FXLrZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 07:47:25 -0400
Date: Mon, 24 Jun 2013 12:47:18 +0100
From: Mark Brown <broonie@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Grant Likely <grant.likely@linaro.org>, linux-spi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <20130624114718.GJ27646@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="s7VmGO2m7mcnuX8Q"
Content-Disposition: inline
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [GIT PULL] SPI updates for v3.10
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--s7VmGO2m7mcnuX8Q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit 9e895ace5d82df8929b16f58e9f515f6d54ab82d:

  Linux 3.10-rc7 (2013-06-22 09:47:31 -1000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/spi.git tags/spi-v3.10-rc7

for you to fetch changes up to 332ec81d413bd4e7375c25d628e7f658c37138f6:

  Merge remote-tracking branch 'spi/fix/s3c64xx' into spi-linus (2013-06-24 12:28:29 +0100)

----------------------------------------------------------------

spi: Updates for v3.10

A few last minute SPI updates: fix a missized allocation and use atomic
allocations in atomic context in the PXA driver, and fix the checking of
return codes in the S3C64xx driver which caused spurious errors under
heavy load.

----------------------------------------------------------------
Mark Brown (2):
      Merge remote-tracking branch 'spi/fix/pxa' into spi-linus
      Merge remote-tracking branch 'spi/fix/s3c64xx' into spi-linus

Mika Westerberg (2):
      spi/pxa2xx: use GFP_ATOMIC in sg table allocation
      spi/pxa2xx: fix memory corruption due to wrong size used in devm_kzalloc()

Sylwester Nawrocki (1):
      spi: s3c64xx: Fix pm_runtime_get_sync() return value check

 drivers/spi/spi-pxa2xx-dma.c | 2 +-
 drivers/spi/spi-pxa2xx.c     | 2 +-
 drivers/spi/spi-s3c64xx.c    | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

--s7VmGO2m7mcnuX8Q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRyDHCAAoJELSic+t+oim98LYQAIM3wBanMD/dO/ZYEJvgZS2h
lu6Lr/6Z/585VMogtklGcfsNctOPJj+JJxDfUmCkpC6MNLfiGG+D0n+SBRCgEMdw
Isw//dEtKXRzlEmDEBtu1KK8q6qBOqbdJWbCdM7JGCTz+K4A+VDho0YgLyBhox3K
2izmpmvCzm0VG7AIRAaWTsdwKM9yY3irzF4pZNW4kAYkQ1A8blcQpg05OF3BeJ91
WIQBlO3fmId1A50sSIMrOFfjm5B7enbMC2wV0V1Ss2VnMLo0KgqMtMOBh7/wUZLB
Ke4MsJIRchbteScPOvJBMtG8r1vSo4WqevfMEGfgetaIkFO4fZxfaml5k+tQUebT
WzcT1Sru4m+k78uIsks5Hpw4Th5TCzfBnOM+BIMgerKDWPlBy7wEoHtzLmFuy3iH
mjt0MUOA8wWaABl1Ddw/LHcbK+n0D7PhE3jtuqbCf7QdI1cNw2hwevYVXCCCl9Bn
OAgPbO6CnI+9qrDc+CYaGLt4f8jjH90TlJ29oSmBvMz6Aac1qqw+BP/s5d/V4lGr
Q90QJSgt2yqa8L3+YPMd8gxBMkHOasy5tUzQ6V69nXKGaZTki+wQ1fj/dxD3QavD
N2B7MNdab6XYCtzYRwEZgl3z7aHtaULniESKn1PQ4PagPvaAoEDbOVvxjBaoxeGB
ukdEe3qwT1w/BM9pFDqI
=fZIO
-----END PGP SIGNATURE-----

--s7VmGO2m7mcnuX8Q--
