Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754086AbaATPwG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 10:52:06 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:57159 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753890AbaATPwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 10:52:04 -0500
Date: Mon, 20 Jan 2014 15:51:57 +0000
From: Mark Brown <broonie@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Message-ID: <20140120155157.GP17314@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pnwJnpr18esoRWH7"
Content-Disposition: inline
X-Cookie: We have DIFFERENT amounts of HAIR --
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [GIT PULL] regmap updates for v3.14
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--pnwJnpr18esoRWH7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit d6e0a2dd12f4067a5bcefb8bbd8ddbeff800afbc:

  Linux 3.13-rc7 (2014-01-04 15:12:14 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regmap.git tags/regmap-v3.14

for you to fetch changes up to 86776fc174973e556be7d668763f509a81124f8b:

  Merge remote-tracking branch 'regmap/topic/ack' into regmap-next (2014-01-09 14:34:13 +0000)

----------------------------------------------------------------

regmap: Updates for v3.14

Nothing terribly exciting with regmap this release, mainly a few small
extensions to allow more devices to be supported:

 - Allow the bulk I/O APIs to be used with no-bus regmaps.
 - Support interrupt controllers with zero ack base.
 - Warning and spelling fixes.

----------------------------------------------------------------
Alexander Shiyan (1):
      regmap: irq: Allow using zero value for ack_base

Cai Zhiyong (1):
      regmap: Fix 'ret' would return an uninitialized value

Laszlo Papp (1):
      regmap: fix a couple of typos

Mark Brown (3):
      Merge tag 'v3.13-rc4' into regmap-core
      Merge remote-tracking branch 'regmap/topic/core' into regmap-next
      Merge remote-tracking branch 'regmap/topic/ack' into regmap-next

Stephen Boyd (2):
      regmap: Allow regmap_bulk_read() to work for "no-bus" regmaps
      regmap: Allow regmap_bulk_write() to work for "no-bus" regmaps

 drivers/base/regmap/regmap-irq.c |  6 ++--
 drivers/base/regmap/regmap.c     | 72 +++++++++++++++++++++++-----------------
 include/linux/regmap.h           | 15 +++++----
 3 files changed, 54 insertions(+), 39 deletions(-)

--pnwJnpr18esoRWH7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS3UYaAAoJELSic+t+oim9vgYP+QFGXDsRxfgcgrUAkD7adm2P
v1qinGBt+3bxRno+8n6wT9B+3UZK6XCJFQPHuWmcAw69Lq7/DUIen2yy69ztuXKx
UqAdkJ288dCknLIrrF1aVbI2ikPZYfjZeUh+C36D9I7hWglWWpgS7uO/1IfWsU9y
JJPeZk0uWJP7XDA7RMVSOTIyCWGJ69kisqnaRmxRuVHYuQ3McekWSagNniu10kPC
vD7utuzVk3EFjX/kLmH5iRQycAWiZMiC1KEvPGDSHlE0GbTGfjZZh2bzrXacvp4R
ajCCnhrDzcnPgTLr5kLRNdXr3E6FhTZm4KYN5hXswRm4rzSL4sR2WmU4E8djslEJ
ElqiHqzbqpbSPdkNNex3MUIm43aOSrpo9enaJssE10rI+0ldQxajY6lWs2lvbbhy
dxcyMuQnIq+WqefvIjxa7qgUR7GTb9SmI/YCPpJyOGp5DHty38ZAvMJsYgqs//rB
L+gDAhbsFHsaD2tlJOQPi8lqzGQZCyJBuQLlEJDBgoyVJ7WH1K/CzmEa8NJ5/kLq
BVgeYH5YshzTYr7DYRCXfEbbYQ/3xhiyt3cPaixFx/12lTqDWWsILNcvbzzYUCb+
rZ7PRC204oPBWgxxGzkZTYawRvYRNyBtyBjqBzYmFaMS9srdFw2btNWJtDW1fsJo
exND3tjVwAKBa922fXcF
=OkLG
-----END PGP SIGNATURE-----

--pnwJnpr18esoRWH7--
