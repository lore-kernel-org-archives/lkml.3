Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751918Ab3GHLsl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 07:48:41 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:42314 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751642Ab3GHLsk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 07:48:40 -0400
Date: Mon, 8 Jul 2013 12:48:12 +0100
From: Mark Brown <broonie@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lgirdwood@gmail.com>
Message-ID: <20130708114812.GV27646@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="o7uAeVo2HayWuXRE"
Content-Disposition: inline
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 193.120.41.118
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [GIT PULL] regulator fixes for v3.11
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--o7uAeVo2HayWuXRE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit 70083c4c8c60d9ddc188f51e0960574badc919af:

  Merge remote-tracking branch 'regulator/topic/tps62360' into regulator-next (2013-07-01 11:17:11 +0100)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regulator.git tags/regulator-v3.11-2

for you to fetch changes up to 37c3f0144c806e026b8d1ce0f41a5f57b25e44f5:

  Merge remote-tracking branch 'regulator/fix/sec' into regulator-linus (2013-07-04 11:14:13 +0100)

----------------------------------------------------------------

regulator: Fixes for the merge window

A set of small fixes for issues noticed during the merge window, all
very much non-invasive.

----------------------------------------------------------------
Mark Brown (3):
      Merge remote-tracking branch 'regulator/fix/max8997' into regulator-linus
      Merge remote-tracking branch 'regulator/fix/s5m8767' into regulator-linus
      Merge remote-tracking branch 'regulator/fix/sec' into regulator-linus

Sachin Kamat (4):
      regulator: s5m8767: Update s5m8767-regulator bindings document
      regulator: s5m8767: Fix a trivial typo in documentation
      regulator: max8997: Fix a trivial typo in documentation
      MAINTAINERS: Update git repository

Yadwinder Singh Brar (1):
      regulator: s2mps11: Convert ramp rate to uV/us and set default ramp rate

 .../devicetree/bindings/regulator/max8997-regulator.txt    |  2 +-
 .../devicetree/bindings/regulator/s5m8767-regulator.txt    | 14 +++++++-------
 MAINTAINERS                                                |  2 +-
 drivers/regulator/s2mps11.c                                |  7 ++++++-
 include/linux/mfd/samsung/s2mps11.h                        |  1 +
 5 files changed, 16 insertions(+), 10 deletions(-)

--o7uAeVo2HayWuXRE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR2qb5AAoJELSic+t+oim9QMEQAIqqen/lzkCc1bWHS8klnZkr
0P3+jGvZGzgeqMjZH8yvIqoXwlNeoRrkaDn5zhdRn+AO+OTWL2kNDC3BrUz0Lg9G
jcnUMjSlGUhcIKMX92CYk4ONt9sRHv5vNcNrSNyKJP21mGlAhibm5FhwRhm5yU+n
dhLDFwrOCNZoyGwVZipjs0BpziowteoC2ae6sBJtdWu9EiN+wriK6K0lmA8SqRzE
0mXaoYEuOnmM+Ql+zndT9Wbu+1MIWb4tCiuZH7TU42btNfBlalNjBinaH3oRIv2h
geSRDUI01biCCMjFCXjuIdw3ESTkjGxwUmRI3CmLMyS3sbZBKcoW6iLey8NbIb/j
W2KJethqxEz9wHpnAjzw2j2xJKyq1ZwmTvoKQdmeoGhgOJrq1FA6Hh+qed6BY0C6
YPfWR7OP/cSPv2R3ZifDqeHnDNxmOlGvIBnpvbG1ibp2qAu5iAtAN0mk8tZLJTvQ
foVDfZixfVpZiVXIjpSXiNQ9heZJXKJCgnA0M6hhqeSAQRJ0SMaxSjACirivzREr
DffvrFjpM+2kQknHuxuDVn33dzcyELvwOgV5zHuk8tO7KizcyMvRcSEJUmsuf9Jl
cKHefG2y4QC75yFj00lHjFg4lgFHs81fYeqTb/n35CFS/ZIkP/SGKublKgpe9Sv/
j8D55/bkoRE92Oz3UkHy
=xZNR
-----END PGP SIGNATURE-----

--o7uAeVo2HayWuXRE--
