Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755394Ab3I3Lwh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 07:52:37 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:40872 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754790Ab3I3Lwf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 07:52:35 -0400
Date: Mon, 30 Sep 2013 12:52:10 +0100
From: Mark Brown <broonie@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Message-ID: <20130930115210.GA19304@sirena.org.uk>
References: <20130930114735.GZ19304@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WbkWELb8d/6oR4nB"
Content-Disposition: inline
In-Reply-To: <20130930114735.GZ19304@sirena.org.uk>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [GIT PULL] regulator updates for v3.12
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--WbkWELb8d/6oR4nB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit 15c03dd4859ab16f9212238f29dd315654aa94f6:

  Linux 3.12-rc3 (2013-09-29 15:02:38 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regulator.git tags/regulator-v3.12-rc3

for you to fetch changes up to f3d17a7e4d9ea9301fd2608c25de7802239e5fbb:

  Merge remote-tracking branch 'regulator/fix/wm8350' into regulator-linus (2013-09-30 12:04:33 +0100)

----------------------------------------------------------------

regulator: Fixes for v3.12

Quite a few fixes here, mostly small driver specific ones.  The stand
out thing is a fix for errors generating the documentation from Randy
Dunlap, otherwise unless you're using the driver in question there
should be no impact.

----------------------------------------------------------------
Axel Lin (2):
      regulator: palmas: Remove wrong comment for the equation calculating num_voltages
      regulator: wm831x-ldo: Fix max_uV for gp_ldo and aldo linear range settings

Geert Uytterhoeven (1):
      regulator: da9063: Fix PTR_ERR/ERR_PTR mismatch

Laxman Dewangan (3):
      regulator: palmas: fix the n_voltages for smps to 122
      regulator: palmas: configure enable time for LDOs
      regulator: wm8350: correct the max_uV of LDO

Mark Brown (6):
      Merge remote-tracking branch 'regulator/fix/da9063' into regulator-linus
      Merge remote-tracking branch 'regulator/fix/doc' into regulator-linus
      Merge remote-tracking branch 'regulator/fix/palmas' into regulator-linus
      Merge remote-tracking branch 'regulator/fix/ti-abb' into regulator-linus
      Merge remote-tracking branch 'regulator/fix/wm831x' into regulator-linus
      Merge remote-tracking branch 'regulator/fix/wm8350' into regulator-linus

Nishanth Menon (1):
      regulator: ti-abb: Fix bias voltage glitch in transition to bypass mode

Randy Dunlap (1):
      regulator: fix fatal kernel-doc error

 drivers/regulator/da9063-regulator.c |  2 +-
 drivers/regulator/palmas-regulator.c | 14 +++++++-------
 drivers/regulator/ti-abb-regulator.c | 16 ++++++++++++++--
 drivers/regulator/wm831x-ldo.c       |  4 ++--
 drivers/regulator/wm8350-regulator.c |  2 +-
 include/linux/regulator/driver.h     |  2 ++
 6 files changed, 27 insertions(+), 13 deletions(-)

--WbkWELb8d/6oR4nB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSSWXnAAoJELSic+t+oim9/CgP/230QwJiE+9eoq7DVCnJ9iiB
JKcop5iTk41BFl4kFq+KOgEkQsMuBom2VwzhEWN//4d6K8XM8EM1IU9BiQetrPvi
hvI4MJXHQA356tggQMryFKXGv/WDs5pCspqsA1nhKRDwCTsMSYQ8tqdsV1qhVRfY
HI5HBQsKS2JgnNplF5vRjkquCoyzW6wxCQzo11m46WzIL5B99iE+GhQhfR+iy6BS
aUw84Y1wpire6TuxUUsa6fNlsSPUXlF4kRskxO4VTSgqlSzutj/KuGvF8wGji3LQ
f7TAZtpCG8JKTwdJp7SMb5ihUZrE/f48DlV93/XsoU+dA+Heyy/aSXGCVhgWH697
wu0dh3yHB4/nAYbK39/I8keiK8/5R5KPn+z5Vo47sQ7qd3MlzDHyeEalvM/PPTOh
2+PYr70AofpfXUzotklXgedHtC8onOnehlbMYrrIXhcwfEf7srGyE52aSVjuFzYw
jJvgVS3AAtyMj1iNhUK+RvHrekmXiQZOh+GJb1/UvVcm0iXK7XFddl0pOFyGiyzd
3sqCXfxM4QgKIEnbmhW+CwOhtnKVZiI76oxMPuTLdtZlQJoPtxgSfQlLVgU3yqXR
eblUno8rdNN/Cx+YDwzuEncwQ/nwMlqYCIgWscHPiu6ecSQZENNMdQbQ2c0GAPeU
hQDBDnf5GMc4n1ppz5hS
=Sl1i
-----END PGP SIGNATURE-----

--WbkWELb8d/6oR4nB--
