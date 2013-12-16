Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755267Ab3LPSmF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 13:42:05 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:59482 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754897Ab3LPSmC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 13:42:02 -0500
Date: Mon, 16 Dec 2013 18:41:37 +0000
From: Mark Brown <broonie@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lgirdwood@gmail.com>
Message-ID: <20131216184137.GM3185@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Pz/qqzCPDfGwIFOg"
Content-Disposition: inline
X-Cookie: Yow!  I threw up on my window!
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: regulator/clk fix for v3.13-rc4
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Pz/qqzCPDfGwIFOg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit 319e2e3f63c348a9b66db4667efa73178e18b17d:

  Linux 3.13-rc4 (2013-12-15 12:31:33 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regulator.git tags/s2mps11-build

for you to fetch changes up to 1b1ccee1e821e59c2a45c95b007aeb2c9dafd9be:

  mfd: s2mps11: Fix build after regmap field rename in sec-core.c (2013-12-16 11:30:39 +0000)

I verified this locally but it's not been in -next yet.

----------------------------------------------------------------
regulator/clk: Fix s2mps11 build

This patch fixes a build failure that appeared in v3.13-rc4 due to an
RTC/MFD update merged via -mm.

----------------------------------------------------------------
Krzysztof Kozlowski (1):
      mfd: s2mps11: Fix build after regmap field rename in sec-core.c

 drivers/clk/clk-s2mps11.c   | 6 +++---
 drivers/regulator/s2mps11.c | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

--Pz/qqzCPDfGwIFOg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSr0leAAoJELSic+t+oim9Kz8P/itzDnH4O1mnbZ31igfYcDDt
+tg9CBRxGNPQuNcRkIdbxbxOKWKtimk94nG+NqMUfy6UVb21y6JrSfTfvKQR3A1E
6U0fcQMokXR+8MujJ6BqrtKZ9HK6P9jyjdrnEenoKfTsnXjVtbnJJcKWnDn0ZofZ
DOneXKmkwdRI/q/31TW8ZLXiWUNQQJopuudJZ7Szj5kVFhusrGhZ1EZ5hKh78kXq
aqnIuth2N+E7haJkcUgb8c8+c488acNxrua4EVswkP8FOYLDIVYHdUspnI9Q1maW
2hZfz1v6qNfxrvhcAWxjfZLCOBY4MhEKo5U9F2l5r1dQZiBpcY4PmCZesv3H1D77
ucVWSxH9HxAyfZs0Mv6oX3G/TDi3B1mNfDJI4H1ZMkCTlIroUpZEAhKtmVelHty+
ZVggJrIX72Td89sSia5zU5lfTrKfXOsjNIEWoflP/AgV7sxnPgdMNdAhMj0ssB5z
w70xyVDkJOQiwEDgmJfj0YFVjyPBBnMCY85frs/uU/5re19/bWQszh7R4pRxzco8
CzDmCbPBvB2uV82ArYeeKd99XUDThO7NUFsmYjNrjsNCPudjWmCFtghNRsIXNSkw
xSZQZIHQ6+tRlMyhItY0OD0ePiszEkrEFFYvfDKXN7/b6tVqCsCk7Jg5hgsXGpeP
QB+v81hDiMWwiLCl6pS5
=L3XX
-----END PGP SIGNATURE-----

--Pz/qqzCPDfGwIFOg--
