Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752160AbaL2QUY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 11:20:24 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:54371 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751321AbaL2QUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 11:20:23 -0500
Date: Mon, 29 Dec 2014 16:20:04 +0000
From: Mark Brown <broonie@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Message-ID: <20141229162004.GW17800@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hsoAP4Wa+/L9NF1J"
Content-Disposition: inline
X-Cookie: You have no real enemies.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 86.128.155.20
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [GIT PULL] regulator fixes for v3.19
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--hsoAP4Wa+/L9NF1J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit b2776bf7149bddd1f4161f14f79520f17fc1d71d:

  Linux 3.18 (2014-12-07 14:21:05 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regulator.git tags/regulator-v3.19-rc2

for you to fetch changes up to 1222d8fe578cd28a6c7f5e4e6c6b664c56abfdc0:

  regulator: s2mps11: Fix dw_mmc failure on Gear 2 (2014-12-12 13:04:39 +0000)

----------------------------------------------------------------
regulator: Fix for v3.19

One fix here, a fix for the voltage mapping on one of the s2mps11
regulators which broke systems using it including apparently the Gear 2
smartwatches.

----------------------------------------------------------------
Krzysztof Kozlowski (1):
      regulator: s2mps11: Fix dw_mmc failure on Gear 2

 drivers/regulator/s2mps11.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

--hsoAP4Wa+/L9NF1J
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUoX8zAAoJECTWi3JdVIfQ8FAIAIHmETbU7ilk/pcvkpjY7w2Q
CNmW27ALAZrEm/ZVNTD3dE7UhiWCX8IL0oaTJXjK8rXbO7zjO1+JqhzyBS/XYGlA
sZr0ssn7y8g+7QoJdB9ICtkHXCDnp4VoE0oz20Fg6rwemd7j3mEo4boxzb8c3DYl
oB14xANgnrtn89coH0PnaXiYXxMmU4uuspMGQTU3yze0bys1gZoP+sY8y2m5suf8
+tEUc0Tx7GpRKCkguqdOVRtBQS0oRoqjdJtLy71CPFuDx9TbnZLOE7AZXbquhTzm
J5xc+qNiSIEOuzy1l21gA51QTNZLk42L0EX+o6+aQmGtBB6prP8kewf+xaF5u7I=
=GsFr
-----END PGP SIGNATURE-----

--hsoAP4Wa+/L9NF1J--
