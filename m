Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752397Ab3FZPgy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 11:36:54 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:52470 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751380Ab3FZPgx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 11:36:53 -0400
Date: Wed, 26 Jun 2013 16:36:24 +0100
From: Mark Brown <broonie@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Message-ID: <20130626153624.GT27646@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="W8kijDWvHeraQFS8"
Content-Disposition: inline
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [GIT PULL] regulator update for v3.10
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--W8kijDWvHeraQFS8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit 317ddd256b9c24b0d78fa8018f80f1e495481a10:

  Linux 3.10-rc5 (2013-06-08 17:41:04 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regulator.git tags/regulator-v3.10-rc7

for you to fetch changes up to ec8da805c43a6cc0252dad0ff6e348c731e0b138:

  mfd: tps6586x: correct device name of the regulator cell (2013-06-24 12:37:47 +0100)

----------------------------------------------------------------
regulator: Fix module loading for tps6586x

A simple one liner fix to make module loading work for distros (product
specific kernels tend to have things built in).

----------------------------------------------------------------
Marc Dietrich (1):
      mfd: tps6586x: correct device name of the regulator cell

 drivers/mfd/tps6586x.c                 | 2 +-
 drivers/regulator/tps6586x-regulator.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--W8kijDWvHeraQFS8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRywp1AAoJELSic+t+oim9Y2UQAIt5rrE4WslVjn+yoYgljpF5
NIltvXaq6qp4oPL/t6TEcpOP9NDRu60ghfBRkghOg2odi+9tRFQmkxFwIOEkBuvu
z+hLkuSMQj3DZbxxj4rt0DyKEdDAjlx/9BK7doSkLc7twMeJ1BWGis4u5+f2/zRi
/oa8jKVDMYqj0Qim5cysq5LjZH+o+/PsxGehb0SkJYrWpz3fhEiPmynEX1+/JNid
M1TRw38jKSB45S/aX4rVU5YMeuxNDL5YFMjf3jLMMNRAPKBc84SY7mAdgSAaBbRu
vH8zlLVygLfIHFO3wnB7OCGXYdTcygRJJr1ggkq+oI8ijUIvhDEhSq1pMRux9U5s
b+h3MbJkt65/kVzssRI8hvsRLd4ac3qKRvnpTe7WsHJKJWnqkZcC2PKcsaKpXuYq
W8o7Gh6NoysTmVgs0lu56eIAyCt/JeXDLZDCTE53da5jbI5JsbIfR4hRmCnSY7xY
WS0evw+xz2tuNLGulG2m2GhLCV9efZpvJ35aTOPI/xZRwHEdyBfo82rYq0Hq3wxX
9NU7ONrWhho+k1AB9x0Fb9m1ebr7uue6q/jUSDOHECEhzszbmsVhdbp+sqDkl4MS
ZAEq8uc+I/csbtEfdmWT6qCV5VywJJlVlp6UPYURguIeQrW15EypaH/v3eXHlbLm
AGd2+LcgYw6KCPB/hQGC
=1muV
-----END PGP SIGNATURE-----

--W8kijDWvHeraQFS8--
