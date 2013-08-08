Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965174Ab3HHKk1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 06:40:27 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:60531 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965156Ab3HHKkX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 06:40:23 -0400
Date: Thu, 8 Aug 2013 11:40:18 +0100
From: Mark Brown <broonie@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Message-ID: <20130808104018.GW6427@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bD34TO62teEVCiRb"
Content-Disposition: inline
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [GIT PULL] regmap fixes for v3.11
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--bD34TO62teEVCiRb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit c095ba7224d8edc71dcef0d655911399a8bd4a3f:

  Linux 3.11-rc4 (2013-08-04 13:46:46 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regmap.git tags/regmap-v3.11-rc4

for you to fetch changes up to 4f57f8ec238db29c5dd4ce42a6c0fbb2956a6645:

  Merge remote-tracking branch 'regmap/fix/disable' into regmap-linus (2013-08-06 19:50:34 +0100)

----------------------------------------------------------------

regmap: Fixes for v3.11

Two things here, one is a fix for a nasty issue where we were failing to
sync the last register in a block when using raw writes and the other
fixes a missing header for the !REGMAP stubs so that we don't rely on
implicit includes in that case.

----------------------------------------------------------------
Lars-Peter Clausen (1):
      regmap: cache: Make sure to sync the last register in a block

Mark Brown (1):
      Merge remote-tracking branch 'regmap/fix/disable' into regmap-linus

Mateusz Krawczuk (1):
      regmap: Add missing header for !CONFIG_REGMAP stubs

 drivers/base/regmap/regcache.c | 3 ++-
 include/linux/regmap.h         | 1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

--bD34TO62teEVCiRb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJSA3WPAAoJELSic+t+oim99qMP/RtJ2Ix63PeGHNIH8xn08SXb
0/LsmQMk6OBev7PVBqJ1ORAdqT1E+mGGqKCwHgXTBF847zP0mgs50tYzIusEQfiC
4SbJqsDNNapVpffRib/T6OLxtr941F8Lf0K82xkR/g30stRAmk/gtcM4hRS7Cuon
WiYoWWboTWZoIkkChzdEYj6tX6Ia4TAshtf6YPhL0XduecZrtIgZVafBRWqOGl/z
5ffkVow0CCpBoBkOkiLFeCsQDLp5UJ3NVdQEsJt/AgJuZaPW/fx2EdOslMMQSbmT
ffVmfqch7k3Tw0IJvRtg6sBHBPXA5HoJWAypCNfUwBpLd9X+yYhrzmcS/fdNmw9j
3UGWs4K7MYLe5RTdPe7mkG0shJSNtHlCKxVQk11DoOEXAIXiLNt3gFtN0UIT4t4d
BOY4cRdHdMsisXSiBfBOhUw6XDuiE5ZbhBtz/hOCqeidp79yiTxCFRmSqWfR3rhc
6sZarGboe49okGlwpyi230oivZt/TmfVfrf4R4LHVQAjphHrvpm3NhgIedEeQduj
x9pgLk7DhC4lPHClGfcBIaTi7mbqiae6eIcOL+A9qp3h4dushQrVXCURhlIT+WHQ
Dt/F9pGS7fM4V1Qh8HqkiRKIuS10kmVfuX65jupdPY8ecVH388wmxsLKLV2+lLk9
TBlxSoZYWadP+5pI7Waq
=VS1Z
-----END PGP SIGNATURE-----

--bD34TO62teEVCiRb--
