Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965031Ab3HHK25 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 06:28:57 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:40415 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964991Ab3HHK2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 06:28:55 -0400
Date: Thu, 8 Aug 2013 11:28:32 +0100
From: Mark Brown <broonie@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-spi@vger.kernel.org
Message-ID: <20130808102832.GT6427@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FxsMg9mYBDvYslEH"
Content-Disposition: inline
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [GIT PULL] spi fix for v3.11
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--FxsMg9mYBDvYslEH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit 5ae90d8e467e625e447000cb4335c4db973b1095:

  Linux 3.11-rc3 (2013-07-28 20:53:33 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/spi.git tags/spi-v3.11-rc4

for you to fetch changes up to 89c66ee890af18500fa4598db300cc07c267f900:

  spi: spi-davinci: Fix direction in dma_map_single() (2013-07-29 20:27:54 +0100)

----------------------------------------------------------------
spi: Simple fix for davinci

Just one update for SPI, a simple fix to the davinci driver to correct
the direction for which DMA is mapped following the dmaengine
conversion.

----------------------------------------------------------------
Christian Eggers (1):
      spi: spi-davinci: Fix direction in dma_map_single()

 drivers/spi/spi-davinci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--FxsMg9mYBDvYslEH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJSA3LNAAoJELSic+t+oim93S8QAIrszkekJv8twZY+yo9uadYD
R0NPlst/u0miF/y00NGzhifuFQsy+FjtZNDZHNlwkdzxrL+qTkXpWsoz1xNPOQI+
0+J8S3LnCwTYp43yl6XXzJw3m3nLPphGs9NzVIYP1iKr36Cns40MnZMgcV+jY0hG
hDON7gRrfQYtfhEG3oGDDGSB9gueDhli+1WENA+j0fMeIRL6aSsX5xgf+7+lLRoM
Zje8uQd4YRv2nAAZCPeh1qL9E3JgN/uRUtAVLk1KgFLqQIw3c9hgx5tlGFl4W1t1
eY05AGiAi727QxKAJQJClaxeqFXd+eCzg7aELu9MkcBNMp6rb+/DPxLG6sigd0o2
xOWMoGBEvOy+8nUHucEi7+cSkQ55fnn9WEx/PDE4aIVNPinzenBUyHi42/UF6C3X
5H4ZpUoOScYhuC4PG5HY4GIqSHUB8GEUDIVhBKoOvOf//cSKJ6XPZha9MFKnNd7w
qqniGYPG9J4g+L5c8ZDbSOp79vqdgFKEPp2loJ6A6IMIf53uIxpXzLFjo/SoxYzc
uwJrjymtO9lbOFLaCMRaNG29qqV2vnjDJC2dyZATqVNajGcMAyWXmzWE2G2J4BHs
ik0foTZxUxdrYJuZ4qclUHmGvEO1NVz5oGIjQWPL2j6t4p9dO4WW0zxzVldX8lld
usCAHKXmvfwbLl5hAv+5
=uhrL
-----END PGP SIGNATURE-----

--FxsMg9mYBDvYslEH--
