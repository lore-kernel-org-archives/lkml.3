Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752068AbaJ0LiL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 07:38:11 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:51009 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751832AbaJ0LiJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 07:38:09 -0400
Date: Mon, 27 Oct 2014 11:37:37 +0000
From: Mark Brown <broonie@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lgirdwood@gmail.com>
Message-ID: <20141027113737.GV18557@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PoKbPPFu8MuDl6RC"
Content-Disposition: inline
X-Cookie: FORCE YOURSELF TO RELAX!
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [GIT PULL] regulator fixes for v3.18
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--PoKbPPFu8MuDl6RC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit cac7f2429872d3733dc3f9915857b1691da2eb2f:

  Linux 3.18-rc2 (2014-10-26 16:48:41 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regulator.git tags/regulator-v3.18-rc2

for you to fetch changes up to bc02871b4583ac2fc2567d9d1826b2857cf169ac:

  Merge remote-tracking branch 'regulator/fix/rk808' into regulator-linus (2014-10-27 11:26:24 +0000)

----------------------------------------------------------------
regulator: Fixes for v3.18

A couple of fixes for v3.18, one fix for an incorrect voltage to
register mapping in the rk808 driver and a fix for a build failure in
some SH defconfigs.

----------------------------------------------------------------
Chris Zhong (1):
      regulator: rk808: Fix min_uV for DCDC1 & DCDC2

Guenter Roeck (1):
      regulator: Include err.h from consumer.h to fix build failure

Mark Brown (2):
      Merge remote-tracking branch 'regulator/fix/core' into regulator-linus
      Merge remote-tracking branch 'regulator/fix/rk808' into regulator-linus

 drivers/regulator/rk808-regulator.c | 2 +-
 include/linux/regulator/consumer.h  | 2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

--PoKbPPFu8MuDl6RC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUTi6AAAoJECTWi3JdVIfQ29UH/jZmx8nP3Nlu8z5bnjO35QUQ
m0mE4rvSHsLNNZVieDRhGkti2Dkm5YoYiqt7H/uw6uNrPJM2AxIL5q/+imFvolj4
9SvpK+GtsfvzfxcvpiIJjwRKm+RJbHfF2SM40l0dv6FR7/lFE+K3VDybMF+re0j2
3gS4p+VVrEqCzgu5gtMCseX/K7QNulIwYhRWt/aR2Vo845msf9b82HSgrzVDEp9F
sJTYyT4vDclAL6fvZQU+JpIEt14exzPKsaQE9Ym8Hnx2x+h5F5RE5AkqEdyTGcJs
8dcu7BFtTqHrqX0VRcL3YHUgYzBwBFiUB9yNKRLotmaf1N3mkU/sLKO1MjEGWHw=
=nAOP
-----END PGP SIGNATURE-----

--PoKbPPFu8MuDl6RC--
