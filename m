Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751468AbaKGKsl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 05:48:41 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:48255 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151AbaKGKsi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 05:48:38 -0500
Date: Fri, 7 Nov 2014 10:48:17 +0000
From: Mark Brown <broonie@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-spi@vger.kernel.org
Message-ID: <20141107104817.GH8509@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1IOMu5+WhZnpLp54"
Content-Disposition: inline
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 188.29.165.192
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [GIT PULL] SPI fixes for v3.18
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--1IOMu5+WhZnpLp54
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit 0df1f2487d2f0d04703f142813d53615d62a1da4:

  Linux 3.18-rc3 (2014-11-02 15:01:51 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/spi.git tags/spi-v3.18-rc3

for you to fetch changes up to 4e72b4278dbc228e4dc453d4dfeca997e521d9af:

  Merge remote-tracking branches 'spi/fix/fsl-dspi' and 'spi/fix/pxa2xx' into spi-linus (2014-11-06 12:58:46 +0000)

----------------------------------------------------------------
spi: Bug fixes for v3.18

A couple of small driver fixes for v3.18, both quite problematic if you
hit a use case that's affected.

----------------------------------------------------------------
Alexander Stein (1):
      spi: fsl-dspi: Fix CTAR selection

Dmitry Eremin-Solenikov (1):
      spi: pxa2xx: toggle clocks on suspend if not disabled by runtime PM

Mark Brown (1):
      Merge remote-tracking branches 'spi/fix/fsl-dspi' and 'spi/fix/pxa2xx' into spi-linus

 drivers/spi/spi-fsl-dspi.c | 4 ++--
 drivers/spi/spi-pxa2xx.c   | 7 +++++--
 2 files changed, 7 insertions(+), 4 deletions(-)

--1IOMu5+WhZnpLp54
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUXKNwAAoJECTWi3JdVIfQrBoH/i4D82DBWJKQC83bNbng3Qb+
26W0Pk3ZnWs5mWR6Rlgx4fl/P843D8ogsMDp0rRXWzKg46qM6845MG1tYNyuFqOH
2FMPMJQqcGllM8Hfjv0Nc4A5oDboZonCJZS6wtg6DrgH/LdHJK45ngzRwzaqMPU4
2hBUaEJUx/cPeKrZz0mO6ylNpJaZ//ryxH43c314/IHP2AfMCG2BUh31YxMENbeY
VkAwxa3bOWVNwQQfifCehGZ4jaT6E1xVOu8mz3Js8U8fkTtg6sJ0AXMGvDRdDGoS
sB0V72htq5QRGumVrtWXyG0syHULHFXOfuM0GDfkBwx2vcK6k1AlCYt+3xgXWX4=
=b8Un
-----END PGP SIGNATURE-----

--1IOMu5+WhZnpLp54--
