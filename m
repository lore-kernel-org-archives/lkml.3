Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752970AbaF1Nd6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 09:33:58 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:34367 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752760AbaF1Nd4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 09:33:56 -0400
Date: Sat, 28 Jun 2014 14:33:04 +0100
From: Mark Brown <broonie@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lgirdwood@gmail.com>
Message-ID: <20140628133304.GV2520@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pJYAKWPIlN1lq59k"
Content-Disposition: inline
X-Cookie: Your lucky color has faded.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 92.40.248.217
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [GIT PULL] regulator fixes for v3.16
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--pJYAKWPIlN1lq59k
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit a497c3ba1d97fc69c1e78e7b96435ba8c2cb42ee:

  Linux 3.16-rc2 (2014-06-21 19:02:54 -1000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regulator.git tags/regulator-v3.16-rc2

for you to fetch changes up to 11767484b81926280bfcca66ddcad875a8b7e41c:

  Merge remote-tracking branches 'regulator/fix/bcm590xx', 'regulator/fix/palmas' and 'regulator/fix/tps65218' into regulator-linus (2014-06-28 14:01:04 +0100)

----------------------------------------------------------------

regulator: Fixes for v3.16

Several driver specific fixes here, the palmas fixes being especially
important for a range of boards - the recent updates to support new
devices have introduced several regressions.

----------------------------------------------------------------
Graham Williams (1):
      regulator: bcm590xx: fix vbus name

Keerthy (2):
      regulator: tps65218: Add the missing of_node assignment in probe
      regulator: tps65218: Correct the the config register for LDO1

Mark Brown (1):
      Merge remote-tracking branches 'regulator/fix/bcm590xx', 'regulator/fix/palmas' and 'regulator/fix/tps65218' into regulator-linus

Nishanth Menon (1):
      regulator: palmas: Fix SMPS enable/disable/is_enabled

Stephen Warren (1):
      regulator: palmas: fix typo in enable_reg calculation

 drivers/regulator/bcm590xx-regulator.c |  5 +++++
 drivers/regulator/palmas-regulator.c   | 12 ++++++++++++
 drivers/regulator/tps65218-regulator.c |  3 ++-
 3 files changed, 19 insertions(+), 1 deletion(-)

--pJYAKWPIlN1lq59k
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTrsQNAAoJELSic+t+oim9d2kP/jDFSB8oWINmJYDsn0LWfgTJ
us5lrosGAbaX9lXGNfW0MFsAUDBxUmyDesrWM/qRcTV0UWgSZayhO9yc1oue3F3m
uLqsVC8Zx3FG+9Ol+qhpBzlMlbNBJu8Tmvag0gIHshqGC/i9+//fl8N2eqKikdab
eBnD2HypLqButR7RzJm9UkqdzRFmihqnP1eSOuzoA6VEmtTPhNNhP5KTkSHXpAxd
QKjItar9EuvfHq57uL/Vj/jgJlAwYETrEYY7quasIZDobYV3HDo+SshfMP2QZ9++
+Ul5p6Njemj6z0EjtOI8L6TFp1HU1br36cF7lFzRT+HUohfLW41ZizdNNfR7/177
a8PMn6P2kHRXo1suYKxJTw+mupX92i7fJYaX42q9tBO+cCAn1a+xsLYmwT5r/T7c
NXvjMjzFWqc6HdCUBGDkO49YfV0eLeW1LU4zyWTnyA7WchlSRBN7inVTAsj+rm0Z
8+RQGML4B/2W9FTKdn3dx0cUsjTPJKCxaGGgowKkhgPpJ03l675pEW0nHG/CZdbH
x6Ad8g7vyRKw4ek2QYxext6h4YK6TBZsKPynvLlU2H9jwJJ9nNtKOT52sP2WDv55
5o1Q2DBm9eswlL4r2Ywp4bFRUcl29Df/yC8Wui8eR5STaUh9stNVT9gmAdI4dCxA
PJazzobbXRDtTT1P/R7n
=bAVm
-----END PGP SIGNATURE-----

--pJYAKWPIlN1lq59k--
