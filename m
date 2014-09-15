Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759969AbaIOXEr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 19:04:47 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:43951 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756021AbaIOXEp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 19:04:45 -0400
Date: Mon, 15 Sep 2014 16:04:29 -0700
From: Mark Brown <broonie@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Message-ID: <20140915230429.GJ7960@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ISYO4r/TCluGLnhR"
Content-Disposition: inline
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 70.35.38.154
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [GIT PULL] regmap fix for v3.17-rc5
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ISYO4r/TCluGLnhR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit 7d1311b93e58ed55f3a31cc8f94c4b8fe988a2b9:

  Linux 3.17-rc1 (2014-08-16 10:40:26 -0600)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regmap.git tags/regmap-v3.17-rc5

for you to fetch changes up to ffff7a12ace24c54220631b79abb02ab65780b5a:

  regmap: Fix debugfs-file 'registers' mode (2014-09-08 12:16:19 +0100)

----------------------------------------------------------------
regmap: Fix registers file debugfs

Ensure that the mode reported for the registers file in debugfs is
accurate by marking it as read only when the define to enable writes has
not been set.  This is on the edge of being a bug fix but it's debugfs
and it makes it much easier for users to spot what's going wrong when
they forget to enable writeability.

----------------------------------------------------------------
Markus Pargmann (1):
      regmap: Fix debugfs-file 'registers' mode

 drivers/base/regmap/regmap-debugfs.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--ISYO4r/TCluGLnhR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUF3B5AAoJECTWi3JdVIfQLiQH/i6HENqrRYN4BTyzSh3JCp5A
7kmMqaQw5jNMSVbHy3ufiNnGc+WQDYQDGSNSXMh3rBqM9XpTbAleWuHugojun54q
0fBqfu7wxtpRlu2/JiaeKir8WrQ8csLO/TNfQdEshFYcOAuAL4yuARGB9jwLLzWZ
MltLfkr+ZuUDQwC1k0jpjCENDSEaMZV9VDGF+bWx7KCI4On5wnTfcTIm1BJqsN5x
U74lVs2yEgt9MTkUqT9SG2A5fgrQNwy35fZG59nyQEP7QxKY7OZVUEjOh5OSPJoc
aSycFVMd2mjmE9Oe4KsA4xVWMkuRcAMREr5hRkEM5IOIS9a+Brvcn1PvsOH0a2I=
=OB8d
-----END PGP SIGNATURE-----

--ISYO4r/TCluGLnhR--
