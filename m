Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754729Ab3BFN3H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 08:29:07 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:34956 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751707Ab3BFN3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 08:29:04 -0500
Date: Wed, 6 Feb 2013 13:29:01 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Liam Girdwood <Liam.R.Girdwood@intel.com>, linux-kernel@vger.kernel.org
Subject: [GIT PULL] regulator updates for v3.8
Message-ID: <20130206132901.GL4720@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2DT8m24oj8Onh3Jp"
Content-Disposition: inline
X-Cookie: Your domestic life may be harmonious.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2DT8m24oj8Onh3Jp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit 88b62b915b0b7e25870eb0604ed9a92ba4bfc9f7:

  Linux 3.8-rc6 (2013-02-01 12:08:14 +1100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regulator.git tags/regulator-v3.8-rc6

for you to fetch changes up to 53e5da79fa5222f2b810da7bf145e3a9f018dcc2:

  Merge remote-tracking branch 'regulator/fix/tps65910' into tmp (2013-02-06 11:28:53 +0000)

----------------------------------------------------------------

regulator: Fixes for v3.8-rc7

Mostly driver specific fixes here, though one of them uncovered the
issue Stephen Warren fixed with multiple OF matches getting upset due to
a lack of cleanup.

----------------------------------------------------------------
Alim Akhtar (1):
      regulator: s2mps11: fix incorrect register for buck10

Axel Lin (5):
      regulator: tps65217: Fix using wrong dev argument for calling of_regulator_match
      regulator: tps65910: Fix using wrong dev argument for calling of_regulator_match
      regulator: max8907: Fix using wrong dev argument for calling of_regulator_match
      regulator: max77686: Fix using wrong dev argument at various places
      regulator: max8997: Fix using wrong dev argument at various places

Marek Szyprowski (1):
      regulator: max8998: fix incorrect min_uV value for ldo10

Mark Brown (8):
      Merge remote-tracking branch 'regulator/fix/max77686' into tmp
      Merge remote-tracking branch 'regulator/fix/max8907' into tmp
      Merge remote-tracking branch 'regulator/fix/max8997' into tmp
      Merge remote-tracking branch 'regulator/fix/max8998' into tmp
      Merge remote-tracking branch 'regulator/fix/of' into tmp
      Merge remote-tracking branch 'regulator/fix/s2mps11' into tmp
      Merge remote-tracking branch 'regulator/fix/tps65217' into tmp
      Merge remote-tracking branch 'regulator/fix/tps65910' into tmp

Stephen Warren (1):
      regulator: clear state each invocation of of_regulator_match

 drivers/regulator/max77686.c           |   15 ++++++------
 drivers/regulator/max8907-regulator.c  |    3 +--
 drivers/regulator/max8997.c            |   39 ++++++++++++++++----------------
 drivers/regulator/max8998.c            |    2 +-
 drivers/regulator/of_regulator.c       |    6 +++++
 drivers/regulator/s2mps11.c            |    4 ++--
 drivers/regulator/tps65217-regulator.c |    4 ++--
 drivers/regulator/tps65910-regulator.c |    2 +-
 8 files changed, 40 insertions(+), 35 deletions(-)

--2DT8m24oj8Onh3Jp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRElqQAAoJELSic+t+oim9A0AP/27ZFqIJ+7xGE8lK+efZNlA5
57lIV01f3DUUYVIMIET9/4SO6lvKoKZRKvV2aOJy81MrjVYVZdusXp5qA/5434OK
ti92zlIKgfJ03qw2H8/2MLg1c9vnPU7P/b85v1V14tREz3bvbXp9jmXzG8wCwQoY
KEP+AAL93dLYrzrWKJpy4mmbP8sZiC9gW8wAqpfGh2evKyU9p2ApZ3xvY/Rt5Qd6
CzsFTe8jhYbG11j8bx2JRPOUdOdK2exI2hXBqmCzHOXagPJ1bfaQrMLe1FD05Rxr
2HPzIkNW0UKDwEtISuvAtZngspkA1/cs1gnlEGFoTFEpaGzTe/gGbUpN6UVJKIdg
VO6zYSZ+VkkUwMgX83cU+j067WAlBHs93NsbsG3jGTR4vXIH+2HuGcur9/7MagpS
VpYkQuFvDRDuxHVx3b6nopuyzSEGxGBQhE8vD1aTWjwKNyA7pOBSHORX+1dEQ95E
LK4Ptpou+ofYcBLY0DeGhvZCaU9QUC1o8bgEeeu/3iXQv8j+vpMkEsKAZxK4sg6s
eQML7uIzMTf6S5gnDroaXJLlvtThj0dvoAw8iMS6FepsKFWLBy6VaD/uro0yHqNC
r93Wz3K6yhUSbT9A9tGVm6rYJafbsFvKYM1rzBp3hG8BHClEaLAIG9fAZqzirz1o
4tLIJjE17s3qE5S4O4vE
=styP
-----END PGP SIGNATURE-----

--2DT8m24oj8Onh3Jp--
