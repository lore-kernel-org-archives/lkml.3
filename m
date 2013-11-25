Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757067Ab3KYRkl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 12:40:41 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:58869 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754591Ab3KYRkk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 12:40:40 -0500
Date: Mon, 25 Nov 2013 17:40:37 +0000
From: Mark Brown <broonie@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lgirdwood@gmail.com>
Message-ID: <20131125174037.GR14725@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gKaPnVNVpyX08bAX"
Content-Disposition: inline
X-Cookie: Your supervisor is thinking about you.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [GIT PULL] regulator updates for v3.13-rc1
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gKaPnVNVpyX08bAX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit 6ce4eac1f600b34f2f7f58f9cd8f0503d79e42ae:

  Linux 3.13-rc1 (2013-11-22 11:30:55 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regulator.git tags/regulator-v3.13-rc1

for you to fetch changes up to 90ba0813db2c96c82e9ba24f30fb96a24a2cd3a8:

  Merge remote-tracking branch 'regulator/fix/pfuze100' into regulator-linus (2013-11-24 14:02:50 +0000)

----------------------------------------------------------------

regulator: Fixes for v3.13

A bunch of fixes, a few driver specific ones and a framework fix for
voltage enumeration on fixed voltage regulators which had previously
worked but had been misplaced during some refactoring causing problems
for users that needed to know the voltage.

----------------------------------------------------------------
Charles Keepax (1):
      regulator: arizona-micsupp: Correct wm5110 voltage selection

Guennadi Liakhovetski (1):
      regulator: fixed: fix regulator_list_voltage() for regression

Laurent Pinchart (1):
      regulator: gpio-regulator: Don't oops on missing regulator-type property

Mark Brown (4):
      Merge remote-tracking branch 'regulator/fix/arizona' into regulator-linus
      Merge remote-tracking branch 'regulator/fix/fixed' into regulator-linus
      Merge remote-tracking branch 'regulator/fix/gpio' into regulator-linus
      Merge remote-tracking branch 'regulator/fix/pfuze100' into regulator-linus

Tim Harvey (1):
      regulator: pfuze100: allow misprogrammed ID

 drivers/regulator/arizona-micsupp.c    | 54 ++++++++++++++++++++++++++++++++--
 drivers/regulator/core.c               |  3 ++
 drivers/regulator/gpio-regulator.c     |  7 ++++-
 drivers/regulator/pfuze100-regulator.c | 12 ++++++--
 4 files changed, 70 insertions(+), 6 deletions(-)

--gKaPnVNVpyX08bAX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSk4uSAAoJELSic+t+oim9FUgP/ithSUy53VBFjWahsie45pKg
lcEFhdcq9iqa+lZ4kl+IEwR0bgVloTOcBjrR1fBX9wgaux1uuHnw9fu/Gd2y7ler
UMcDNqlnkjFmTLkOTKBDptVYsIeYTqECtUZ5c76GMRTb0m/pCeIZ+58AbXVWd1q0
/vyWxNPY8GK2WcVmneuO98jbWOOdghadAGAJbHtTdAx8/CGqFCFslC++PkuRBbOK
/t5JdkVxxE5jTG/2wLV+ZhuL+53MaZVtk9J8JuQObEHQXhjrRpk9MTw9MCEz8JOz
Xpr/xKaXonhPhlJLimwKN3mMmoLcPv4qI4oWWpHexYH7FSNACkMSwFVsR9bI4ZnC
trnmCbfLBlSziI5Lz/KHpW6BprDWDlwkgwOy8UFgI/55tcA09AYTY/FWuKI3wk10
XyTr4rgNzHRYljwx5zy59fJ11v26fzms1No9wh+8oRcX/QSXdFO1FGzbeWmHgHQy
VYSNXPv4k5cj1KgbdApdGB7/oFuQtLt0igjex/rAUXbHqOYQo6cSzM2S9JHePCnC
UPZtEoPdHyZjzeTR7Gybr9oLJ3AUVu0k6anu/Pm2xirpkFAuAy3Xtl4f1PqlSdTb
n3U62fbXyEitQ6cYeIdKeTYZ4a3uLA05SaJw8854NeJ7ty4jWxWQO85t22ScdZS3
mHIdyqcLCMuMygCR4Nbl
=Itt4
-----END PGP SIGNATURE-----

--gKaPnVNVpyX08bAX--
