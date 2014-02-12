Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753392AbaBLQvy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 11:51:54 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:40934 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751638AbaBLQvx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 11:51:53 -0500
Date: Wed, 12 Feb 2014 16:51:46 +0000
From: Mark Brown <broonie@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lgirdwood@gmail.com>
Message-ID: <20140212165146.GF28112@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="E+SuQPWxZ0J/gtME"
Content-Disposition: inline
X-Cookie: Oh no, not again.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [GIT PULL] regulator fixes for v3.14
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--E+SuQPWxZ0J/gtME
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit b28a960c42fcd9cfc987441fa6d1c1a471f0f9ed:

  Linux 3.14-rc2 (2014-02-09 18:15:47 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regulator.git tags/regulator-v3.14-rc2

for you to fetch changes up to 5c306c8ab5dac69714f6e38bed95cfb6bd7758ed:

  Merge remote-tracking branches 'regulator/fix/da9055' and 'regulator/fix/max14577' into regulator-linus (2014-02-12 11:47:33 +0000)

----------------------------------------------------------------

regulator: Fixes for v3.14

Two driver fixes, one fixing the mapping of interrupts on da9055 (which
previously wouldn't have worked at all) and a fix for reference counting
OF nodes in the max14577 driver.

----------------------------------------------------------------
Adam Thomson (1):
      regulator: da9055: Remove use of regmap_irq_get_virq()

Krzysztof Kozlowski (1):
      regulator: max14577: Add missing of_node_put

Mark Brown (1):
      Merge remote-tracking branches 'regulator/fix/da9055' and 'regulator/fix/max14577' into regulator-linus

 drivers/regulator/da9055-regulator.c | 4 +++-
 drivers/regulator/max14577.c         | 5 +++--
 2 files changed, 6 insertions(+), 3 deletions(-)

--E+SuQPWxZ0J/gtME
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS+6aeAAoJELSic+t+oim9zyMP/RH67flyS9sprY/PtTBR4YQq
WLvdhE34TjiKxEOdiOkV22LSg75lqMzVTIi2ab3OxigECtZTa6FFwCE/g4K4U5dh
oDzpts0RNK2GvpHwXeqmBDOKgSLsLyC8jV8RgXlYz1mvnD2MI+iENFH5W+indJnb
oHtWJcOwiNaffcj/p3w4329fwZVB7jOxvDWc/Ypx5TM+MlHo+bPZuP2Xp8hiNo09
BLYvRFdYcHKROwsq7Hh0FoG2CFG5QfkH6QiSQVU0YpaqxMSg6XS2IcoJFSYXgbia
HHZWkKzrEVFxhAF+13A/aRkUrEs43xpecTWbDpGG5523dqtYKAW6SiIxiLuytXNO
10bSCMbz23kB1teW1jxncn2LyOTfq+q0PRWloutgFRJgirxzu9b1osYyixQcNZTp
uMgkXCw/WWo5Ws1qdRzDweVNjpcgO563HlZ6VnDRd1FLhvsqrTB7IVQ5gWaTa79j
mrbn8KkNb8byxf2T0Xj34ABewsKofKlE83oPtGgcJGbDr+LIQqT16DeEeY+OdNdn
UqCDbnJzDee10s4GoAXnHYP+bDF0PVkmKarc5ee+eU3M2vgyWjgZAWA6sEFWGvTm
P5bbJhzNllGAMIIIgJubQGq6tH/UxW+wmB9C/mg9JbpTbZCMjZovXuhrOoqtPuQN
CDGjOlLJu5jE0p6ZRetT
=1w4W
-----END PGP SIGNATURE-----

--E+SuQPWxZ0J/gtME--
