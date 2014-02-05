Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752755AbaBEPQL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 10:16:11 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:36333 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751333AbaBEPQJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 10:16:09 -0500
Date: Wed, 5 Feb 2014 15:16:02 +0000
From: Mark Brown <broonie@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lgirdwood@gmail.com>
Message-ID: <20140205151602.GB32298@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yEPQxsgoJgBvi8ip"
Content-Disposition: inline
X-Cookie: Take it easy, we're in a hurry.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [GIT PULL] regulator fixes for v3.14
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--yEPQxsgoJgBvi8ip
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit 38dbfb59d1175ef458d006556061adeaa8751b72:

  Linus 3.14-rc1 (2014-02-02 16:42:13 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regulator.git tags/regulator-v3.14-rc1

for you to fetch changes up to a6a671e1b6f6e68b642445ad3cac46f8ffb46f5c:

  Merge remote-tracking branches 'regulator/fix/ab3100' and 'regulator/fix/s2mps11' into regulator-linus (2014-02-04 12:58:19 +0000)

----------------------------------------------------------------

regulator: Fixes for v3.14

A couple of driver fixes here but the main thing is a fix to the checks
for deferred probe non-DT systems with fully specified regulators which
had been broken by a device tree fix which meant that we wouldn't insert
optional regulators.  This had slipped through the cracks since very few
systems do that in the first place and those that do it in mainline
don't need optional regulators anyway.

----------------------------------------------------------------
Krzysztof Kozlowski (1):
      regulator: s2mps11: Fix NULL pointer of_node value when using platform data

Linus Walleij (1):
      regulator: ab3100: cast fix

Mark Brown (3):
      regulator: core: Correct default return value for full constraints
      Merge remote-tracking branch 'regulator/fix/core' into regulator-linus
      Merge remote-tracking branches 'regulator/fix/ab3100' and 'regulator/fix/s2mps11' into regulator-linus

 drivers/regulator/ab3100.c  | 4 ++--
 drivers/regulator/core.c    | 9 ++++++++-
 drivers/regulator/s2mps11.c | 1 +
 3 files changed, 11 insertions(+), 3 deletions(-)

--yEPQxsgoJgBvi8ip
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS8lWvAAoJELSic+t+oim9v18P/AuvC7oKYv+KN8XSSYLVJi/B
PKvOavM6tzHqdcQYGb2Pb9BUx8xboTBDts2ZdooAuYO3/gnNcCBiVFSW6L3AMM62
dk76ULADtx+Q9Ad8mPCpXVKL3A71uPqLnjrh1v7AC38YSgWy4cqMw8zgJP9xEiiW
GZeI8RpgPidCC6BiNM332w3qCZ3z0dMjYrU3geXE1y8PeQhj41fLOrM8YbwcD+fK
xJMOnosbW0eINNH3qvUQjh0ukmz5MtX8YtF/wt1Gb6F5hqOeN6n20DlEC3SRJ9Q1
tT5ofZqHHf2BuD+XD2dgTGnbl6rtcj+y42Xjh3aDHAEtm2dVvWAO4bd/n8RYmCON
eJBwxWzncOBeEYDRl0680QIkpwNAqoMu7dhd3toqHr4sNPQnd9mjyVH0s0+dQBMY
Ye5GoLrYlHIwXGv3ORZdJp9gHwXKgzdjg+KMR3SC7vz4QHWIMgJWavfshmLV/O5r
HZydfSz0lamz+5n9M72jZUty53opCvLmZ9LdKo5o9NetpT6X2HlWwn+r05G8Ungk
dP8yx2vySJad42qG/nFPUUZchVdXlfulMindcGABwhNOIZlpKJOoUDmDfdRIcoV2
2URBRS5v6PEZjBlga1bs/iY6mKeRKFN8sxWbRqHx2cJ19NnpM6Chzz4e2/c/QpeC
OolDWeXMkPyYYEOT/eH7
=6KgC
-----END PGP SIGNATURE-----

--yEPQxsgoJgBvi8ip--
