Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752701Ab3LMNoc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 08:44:32 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:55256 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752171Ab3LMNob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 08:44:31 -0500
Date: Fri, 13 Dec 2013 13:44:28 +0000
From: Mark Brown <broonie@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Message-ID: <20131213134428.GC11044@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Hmb9n29fjuiORm2l"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [GIT PULL] regmap fixes for v3.13
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Hmb9n29fjuiORm2l
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit 6ce4eac1f600b34f2f7f58f9cd8f0503d79e42ae:

  Linux 3.13-rc1 (2013-11-22 11:30:55 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regmap.git tags/regmap-v3.13-rc3

for you to fetch changes up to 652787ab1aca35e5e85e644757f7ea2cc00681d1:

  Merge remote-tracking branches 'regmap/fix/doc' and 'regmap/fix/mmio' into regmap-linus (2013-11-26 13:16:56 +0000)

----------------------------------------------------------------

regmap: Fixes for v3.13

Two small changes to fix some error handling and checking (both of which
would be quite serious if the errors trigger) plus a trivial
documentation fix.

----------------------------------------------------------------
Courtney Cavin (1):
      regmap: make sure we unlock on failure in regmap_bulk_write

Gerhard Sittig (1):
      regmap: trivial comment fix (copy'n'paste error)

Mark Brown (2):
      Merge remote-tracking branch 'regmap/fix/core' into regmap-linus
      Merge remote-tracking branches 'regmap/fix/doc' and 'regmap/fix/mmio' into regmap-linus

Stephen Warren (1):
      regmap: use IS_ERR() to check clk_get() results

 drivers/base/regmap/regmap-mmio.c | 11 ++++++-----
 drivers/base/regmap/regmap.c      |  8 ++++----
 2 files changed, 10 insertions(+), 9 deletions(-)

--Hmb9n29fjuiORm2l
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSqw85AAoJELSic+t+oim9ai8P/282z5X4QMy+Ax/nz8ttZWm7
oRpf7/ZP5vTSBSQg9N0IrESqMf6nj1L5HwsgCmPQpFgQ234xYynW8odDtimTGfwW
XIxXYEKk/FhQaYhpqnvoEghrW3LSd/HtFFh7BlWr2trhCNxR3Lvj5EEujJp81qwV
SgtGWt8byW2+gUgTv58oVBH8thGToIawGLTdBKRZGcMe3e9r5fcRR7mB2sGtFoEQ
69pJUlHXeHc86uOVGehArzTM3o48d64DRImNYGS+wU+BCbEXz9DFi05x53Szn5QY
X09c1MrVphaexCiP4ILgQbV5+pmbzuADRaPChuTEJbKcTj3iF4d7YRU6KXw6lHh7
BRp4h0w0J7RfaHrpfqglU2waNiIzhC458+UMFQ+JOlJO4Dfj2kVsT917IMWTFtHY
chTb3d+YJQfYwjGfTChbFyK0BpMuV9fDyb2MsoCEjsqosKH7DRTw7U2UECbweBAG
iAiFPge3OR5pvs6qxJUHLDcrr9/VGI3lISthDVPT/dbPlTlFRZzhPv7a5MoT1wqj
RPnxhNNd75WSZ0mTKwuII9jAnOMwfb9WKcqPMt6L3n3T7n02lwDod1Mf3ViRe5xe
SOtss4aZ96B+bJHZUZDbGO8TdtW/903TPaSCZlNTkjhWah7YYVzsbMxjyxnhMZnQ
l3mZVvazIQ5CMki5uQiE
=9pkX
-----END PGP SIGNATURE-----

--Hmb9n29fjuiORm2l--
