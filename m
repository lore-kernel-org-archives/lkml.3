Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753798Ab3H0Pdn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 11:33:43 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:60356 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751596Ab3H0Pdm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 11:33:42 -0400
Date: Tue, 27 Aug 2013 16:33:17 +0100
From: Mark Brown <broonie@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Message-ID: <20130827153317.GB10783@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fGPQ8TN6VVAOY/Hs"
Content-Disposition: inline
X-Cookie: Snow Day -- stay home.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 176.12.107.140
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [GIT PULL] regmap updates for v3.11
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--fGPQ8TN6VVAOY/Hs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit b36f4be3de1b123d8601de062e7dbfc904f305fb:

  Linux 3.11-rc6 (2013-08-18 14:36:53 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regmap.git tags/regmap-v3.11-rc7

for you to fetch changes up to 7f242bd889f49f5447bc4fd1eb5e437159e905b6:

  Merge remote-tracking branch 'regmap/fix/rbtree' into regmap-linus (2013-08-21 17:08:17 +0100)

----------------------------------------------------------------

regmap: Updates for v3.11

Two changes here:

 - Fix a bug in the rbtree code which could cause it to create two
   different cache entries for the same register by adding a single
   register at a time to the cache.  This isn't awesome for performance
   but it's non-invasive which we need for this late in the release
   cycle and the I/O costs we're trying to avoid are high.

 - Add another header used in the !CONFIG_REGMAP stubs where we had been
   relying on implicit inclusion.

----------------------------------------------------------------
David Jander (1):
      regmap: rbtree: Fix overlapping rbnodes.

Kevin Hilman (1):
      regmap: Add another missing header for !CONFIG_REGMAP stubs

Mark Brown (2):
      Merge remote-tracking branch 'regmap/fix/header' into regmap-linus
      Merge remote-tracking branch 'regmap/fix/rbtree' into regmap-linus

 drivers/base/regmap/regcache-rbtree.c | 2 +-
 include/linux/regmap.h                | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

--fGPQ8TN6VVAOY/Hs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJSHMa5AAoJELSic+t+oim9/kcP/jWnnJO/wVMxJ8vyxNVbQBzM
k+/UdrWYga97fBiyWwlgFa5fTM/meGrfaLTxRdJb1SsU2HyQyF5CUWpy25vHPUKs
D73JUR5t7CC7i+G9RtsZlhbf4pJf64jMQn4FIeVBhNXmcYts/0+yq2Rv/XwfjSTm
miEVCu/EpQcIsNUf3cj2v99TMSEp6B3ZQjyoAKiQpxk6t+h8ScAieXL8LWT6dFYf
CoCEuXbOoywcbtTG4m4EK0WYUceFPPPebtxEeEzLowt6An8V3pSLg7fwZC+qPE/g
LHDepaKNj1sJ0eWQAwsAWko7zEypb26VBbkgeho86i6WiBlbhN4A24pGq1YbPsq7
ELYb1+ILulckIjSGV+KaNgeuvzEQPpVTtUF/LTPIBN1A7Qv4iirERlv8JcabKxyN
25yKeNIflUi4SXt0OzgvZvBS9+TFYIO9MjnTpiBoLGeKqsqqsoZTWOS9iv53HJdy
4q2qW1x1w8ofe0nfrdmaaLYvIKwEXlvmA9c6HdGdPES/S+9opZbJ//B4yuPg9B9y
ErDg3abznZk861AFMvbiEPhoFVR7rQB9D+PPQKelK33b7xUaz37Uyig13T0PPez/
4YFwybxASfC3xLNFd5XwPM8X1WWOxAWrHY+Xg0dnbmEmwSv7XbFgxzcM549C6yqk
QrjtgczlSnhTbLZlIyR7
=veBu
-----END PGP SIGNATURE-----

--fGPQ8TN6VVAOY/Hs--
