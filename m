Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753409AbaFCKTQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 06:19:16 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:51676 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753301AbaFCKTN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 06:19:13 -0400
Date: Tue, 3 Jun 2014 11:18:52 +0100
From: Mark Brown <broonie@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Message-ID: <20140603101852.GV31751@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6qFdnjy6dKaiDX/E"
Content-Disposition: inline
X-Cookie: Big book, big bore.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 109.148.252.180
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [GIT PULL] regmap updates for v3.16
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--6qFdnjy6dKaiDX/E
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit fad01e866afdbe01a1f3ec06a39c3a8b9e197014:

  Linux 3.15-rc8 (2014-06-01 19:12:24 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regmap.git regmap-v3.16

for you to fetch changes up to ef98ae45e6b3ea17d3ed27cec9afdd7e46f916ae:

  Merge remote-tracking branch 'regmap/topic/smbus' into regmap-next (2014-06-02 17:07:42 +0100)

----------------------------------------------------------------

regmap: Updates for v3.16

Another fairly quiet release, a few bug fixes and a couple of new
features:

 - Support for I2C devices connected to SMBus rather than full I2C
   controllers contributed by Boris Brezillon.  If the controller is
   only capable of SMBus operation the framework will transparently
   fall back to that.
 - Suport for little endian values, contributed by Xiubo Li.

----------------------------------------------------------------
Boris BREZILLON (2):
      regmap: add reg_read/reg_write callbacks to regmap_bus struct
      regmap: i2c: fallback to SMBus if the adapter does not support standard I2C

Geert Uytterhoeven (1):
      regmap: Add missing initialization of this_page

Jean-Christophe PINCE (1):
      regmap: rbtree: improve 64bits memory alignment

Mark Brown (3):
      Merge remote-tracking branch 'regmap/topic/core' into regmap-next
      Merge remote-tracking branches 'regmap/topic/irq', 'regmap/topic/le', 'regmap/topic/mmio' and 'regmap/topic/rbtree' into regmap-next
      Merge remote-tracking branch 'regmap/topic/smbus' into regmap-next

Philipp Zabel (1):
      regmap: mmio: Fix regmap_mmio_write for uneven counts

Xiubo Li (4):
      regmap: implement LE formatting/parsing for 16/32-bit values.
      regmap: mmio: Fix the bug of 'offset' value parsing.
      regmap: Fix possible ZERO_SIZE_PTR pointer dereferencing error.
      regmap: irq: Fix possible ZERO_SIZE_PTR pointer dereferencing error.

 drivers/base/regmap/regcache-rbtree.c |   8 +--
 drivers/base/regmap/regmap-i2c.c      | 104 +++++++++++++++++++++++++++++++++-
 drivers/base/regmap/regmap-irq.c      |   9 ++-
 drivers/base/regmap/regmap-mmio.c     |  35 +++++++++---
 drivers/base/regmap/regmap.c          |  83 ++++++++++++++++++++++++++-
 include/linux/regmap.h                |   6 ++
 6 files changed, 227 insertions(+), 18 deletions(-)

--6qFdnjy6dKaiDX/E
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTjaEJAAoJELSic+t+oim9piEP/0k5cSKqtHtZSq6ViyA4EIPI
24/Ovw+eiBnl5u+NznGsaIXpblPsRKpw8q/PDMjhgSw/79XjBYqt7yds+veD3EQZ
QXL4MsLYpU4fE2wUmWGo1mAaX3ZC6k757BF2sFdvSFmJkD1wnVWslDNO7ox3XQSl
SyFCiciecOG+qOLw8Ztr2UX0WKG4Rx+G2sdjpshE+m8kQyhhdyMgFaqU5rAST4+O
JFSJInLx853dOyqoE7+n7R3dD0LgJpMtX3w6XsJRprd6fU/pc24OXCBUWeh2ZHsq
mBTjysubqh4lH2VWEW/GFI5mfuRpTtZke/8xozA90VHkNxct01qbIYqzLb+NbLer
1CR6F1auobKPfGaJGM06FQWqhlmINESQV17y8TLnPfVN7quISy4hoBpljqUhO+2h
kzit7tePvmg35yTU19ZiNr1rvu4jiTEtdhYK6aBtzNvRyZufDPI4MMPMjq4FW9Zo
SOm1NQQejZn1CHAAAfft18x9RxK+8JqSQlx+xkMXxbbUw/p4c8BLY54SeBCemJDn
YPwiGiQhnaB8dRqP+HFEJeIabl3U5V4IXkO0v+5jAkHkeZ/GGps04zX8k6Q9kZRH
FgioZYaAZHDtBgsDZMPPyzvvBCn/Z9RI0TDGxk5jRNtQKd5wnf3SBuOizj0aZr7e
BqF2qlGlapSFu2uXMra+
=z0bu
-----END PGP SIGNATURE-----

--6qFdnjy6dKaiDX/E--
