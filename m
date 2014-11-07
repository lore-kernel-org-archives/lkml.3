Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751867AbaKGLGk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 06:06:40 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:48364 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751843AbaKGLGi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 06:06:38 -0500
Date: Fri, 7 Nov 2014 11:06:15 +0000
From: Mark Brown <broonie@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lgirdwood@gmail.com>
Message-ID: <20141107110615.GI8509@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GCRJOSQGwEYxR+j1"
Content-Disposition: inline
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 188.29.165.208
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [GIT PULL] regulator fixes for v3.18
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--GCRJOSQGwEYxR+j1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit 0df1f2487d2f0d04703f142813d53615d62a1da4:

  Linux 3.18-rc3 (2014-11-02 15:01:51 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regulator.git tags/regulator-v3.18-rc3

for you to fetch changes up to 2a7509b187cab859cbc80e399e1d7c79c589d7ca:

  Merge remote-tracking branches 'regulator/fix/max1586', 'regulator/fix/max77686', 'regulator/fix/max77693', 'regulator/fix/max77802', 'regulator/fix/max8860' and 'regulator/fix/s2mpa01' into regulator-linus (2014-11-05 14:59:25 +0000)

----------------------------------------------------------------
regulator: Fixes for v3.18

More changes than I'd like here, most of them for a single bug repeated
in a bunch of drivers with data not being initialized correctly, plus a
fix to lower the severity of a warning introduced in the last merge
window which can legitimately go off so we don't want to alarm users
excessively.

----------------------------------------------------------------
Javier Martinez Canillas (5):
      regulator: max1586: zero-initialize regulator match table array
      regulator: max77686: zero-initialize regulator match table
      regulator: max77802: zero-initialize regulator match table
      regulator: max8660: zero-initialize regulator match table array
      regulator: s2mpa01: zero-initialize regulator match table array

Krzysztof Kozlowski (1):
      regulator: max77693: Fix use of uninitialized regulator config

Mark Brown (3):
      regulator: of: Lower the severity of the error with no container
      Merge remote-tracking branch 'regulator/fix/core' into regulator-linus
      Merge remote-tracking branches 'regulator/fix/max1586', 'regulator/fix/max77686', 'regulator/fix/max77693', 'regulator/fix/max77802', 'regulator/fix/max8860' and 'regulator/fix/s2mpa01' into regulator-linus

 drivers/regulator/max1586.c      | 2 +-
 drivers/regulator/max77686.c     | 2 +-
 drivers/regulator/max77693.c     | 2 +-
 drivers/regulator/max77802.c     | 2 +-
 drivers/regulator/max8660.c      | 2 +-
 drivers/regulator/of_regulator.c | 3 ++-
 drivers/regulator/s2mpa01.c      | 2 +-
 7 files changed, 8 insertions(+), 7 deletions(-)

--GCRJOSQGwEYxR+j1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUXKemAAoJECTWi3JdVIfQbDsH/2fQsm4L/NxX7/KP+RLkEe/y
OIjJA/3aPnuIotvLu0dp4cIIFM6Q5enxKeVTrnemAppNrh8na4nRmW1O9V6tZWio
4fsWVRd5Awj7d9TVbiApr26CtDmVt2xsoYPuYE2aRYslKEWVd9ZJ7WkPh8P81xHJ
tTizrSivnjrNt1Hx19hjLBKmKtUARFyXZKZMoOYX/netN0o4a4oB9vS67SV5qD2/
OtHUJVWjyHoZp2XAbDGe3QLlm2XfRgO19iDOarAyYQ5YcQkcx/lr6xkxHUydLsmf
2k6GAWfbhu4EUx07gSz+Bg28gP7p1kw0WBl/VFs69nDoqQj1cOGb1byIqaSZ0Ok=
=EFM4
-----END PGP SIGNATURE-----

--GCRJOSQGwEYxR+j1--
