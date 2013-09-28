Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754279Ab3I1Ohm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 10:37:42 -0400
Received: from sauhun.de ([89.238.76.85]:53408 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753836Ab3I1Ohk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 10:37:40 -0400
Date: Sat, 28 Sep 2013 16:37:35 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jean Delvare <khali@linux-fr.org>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PULL REQUEST] i2c for 3.12
Message-ID: <20130928143729.GA8755@katana>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SLDf9lqlvOQaIe6s"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--SLDf9lqlvOQaIe6s
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Linus,

here are some driver bugfixes for the I2C subsystem. Please pull.

Thanks,

   Wolfram


The following changes since commit 4a10c2ac2f368583138b774ca41fac4207911983:

  Linux 3.12-rc2 (2013-09-23 15:41:09 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/wsa/linux.git i2c/for-current

for you to fetch changes up to bf4169100c909667ede6af67668b3ecce6928343:

  i2c: ismt: initialize DMA buffer (2013-09-28 16:32:12 +0200)

----------------------------------------------------------------
Chew, Chiau Ee (1):
      i2c: designware: 10-bit addressing mode enabling if I2C_DYNAMIC_TAR_UPDATE is set

James Ralston (1):
      i2c: ismt: initialize DMA buffer

Kim Phillips (1):
      i2c: s3c2410: fix clk_disable/clk_unprepare WARNings

Thierry Reding (2):
      i2c: mv64xxx: Fix some build warnings
      i2c: mv64xxx: Do not use writel_relaxed()

 drivers/i2c/busses/i2c-designware-core.c |   26 ++++++++++++++++++++------
 drivers/i2c/busses/i2c-ismt.c            |    3 +++
 drivers/i2c/busses/i2c-mv64xxx.c         |   16 +++++++++-------
 drivers/i2c/busses/i2c-s3c2410.c         |    2 --
 4 files changed, 32 insertions(+), 15 deletions(-)

--SLDf9lqlvOQaIe6s
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSRumpAAoJEBQN5MwUoCm2odEP/3GxqD0Uoni9dPI3uSex+rsb
AqAyUeua6RcjTe2WMRc0JoxglmcTfaqy1g8jw6gN0U00OS3cDGBUGZn64Dv9TPH5
5dpjYG5LJj3NM/yDzxiGYwqj0SY4AeryteZ/43EF22gegMC7kZLcoplGoB2wW4xa
r+PnSLVGDcy3m8+AQ63k0KvygiipHAXjgPc3uP2bQ9HtgIByQxYbIAt42LH6yTKD
aPxP8vJULWI3BebyBhzM03BXFtT5IzEzOfzeTy9l3AfwtUIe3YPYxVRFmzr3oy/K
27f/iq+w89zMLRGewBLWqhyCi4sJ2RQZCqYXmaUT6MoXqhoYWXBHM4BEMjojtJYN
4vbsDA/j5X9ib1oih1wUCCjydlEuuR87M2p0jKcD7SLM8MCnz9smr5zJEkJEYGB4
4G+9vPNz9D0N82Oqhh2HAxlR891mnSI1+7zkWtVUDYJPT/UMEbHDHXILTPhs6mjM
tlQ+qb48PcHJ9X0zpcZS6NG/I1bmiTqJiFotMzIjzabJD2HS7ko3LhlWmSI0uwxt
NLZmPe0IKZ+wuYB+nUQAT3xIjN/3/hrA76RF/NaPpt2xwI/rabWqjiMAT9f8mzCF
yMHPiptHt1LdV7lx95AEvsVnYB+CvY2ng++cJS/jXZ/URz9YCFAbR+wZ/xdOBqT9
bx13WuOwJOdn4pi9d7jF
=B09b
-----END PGP SIGNATURE-----

--SLDf9lqlvOQaIe6s--
