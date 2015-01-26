Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754159AbbAZLuv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 06:50:51 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:34538 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753152AbbAZLuu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 06:50:50 -0500
Date: Mon, 26 Jan 2015 11:50:46 +0000
From: Mark Brown <broonie@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lgirdwood@gmail.com>
Message-ID: <20150126115046.GA21293@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="0Zc0bQF+fxzVVQOT"
Content-Disposition: inline
X-Cookie: My LESLIE GORE record is BROKEN ...
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [GIT PULL] regulator fixes for v3.19
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0Zc0bQF+fxzVVQOT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit eaa27f34e91a14cdceed26ed6c6793ec1d186115:

  linux 3.19-rc4 (2015-01-11 12:44:53 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regulator.git tags/regulator-v3.19-rc6

for you to fetch changes up to 113620bb89a580d72a1dd78e677c0c8aac45cf0c:

  Merge remote-tracking branch 'regulator/fix/s2mps11' into regulator-linus (2015-01-16 12:05:35 +0000)

----------------------------------------------------------------
regulator: Fixes for v3.19

One correctness fix here for the s2mps11 driver which would have
resulted in some of the regulators being completely broken together with
a fix for locking in regualtor_put() (which is fortunately rarely called
at all in practical systems).

----------------------------------------------------------------
Ashay Jaiswal (1):
      regulator: core: fix race condition in regulator_put()

Jonghwa Lee (1):
      regulator: s2mps11: Fix wrong calculation of register offset

Mark Brown (2):
      Merge remote-tracking branch 'regulator/fix/core' into regulator-linus
      Merge remote-tracking branch 'regulator/fix/s2mps11' into regulator-linus

 drivers/regulator/core.c            |  4 +++-
 drivers/regulator/s2mps11.c         | 42 +++++++++++++++++++++++++++++++++----
 include/linux/mfd/samsung/s2mps13.h |  2 ++
 3 files changed, 43 insertions(+), 5 deletions(-)

--0Zc0bQF+fxzVVQOT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJUxioVAAoJECTWi3JdVIfQLpgH/ieAJymcwUWt2xCF7XS8vNG2
nhTvmLzsFL9ji6LnVjgKcO3NAd+4XEyNqVXw/BsYSiyA6r5sGis6/BvSRf9f0bu7
NzMfG47rgJoG3hRhQzki+rwyFcPsmd/DymJXNqcQZPTKmbOhzAdrc7yFbroeSfh9
O2NzJJYa9b2uAoCb38uN9/J7n592o0LJf2nFgP1J9hzCipmJTIzCDHhv91ZiEUrk
119nt2Rk8unCcwNv7q0khaNuCnMW2byQfsrB5JpL6Tdm/gEnAVlEEeqTcL3gBFLZ
0Lm1DOXhMwthqngx1JtE6SwaSdlLcKBMcyKEA511HFCPHIWB7vY603NB14nTECc=
=01wQ
-----END PGP SIGNATURE-----

--0Zc0bQF+fxzVVQOT--
