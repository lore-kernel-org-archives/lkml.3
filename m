Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753806Ab3A2DmI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 22:42:08 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47087 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750874Ab3A2DmE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 22:42:04 -0500
Date: Tue, 29 Jan 2013 11:41:49 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>
Subject: [GIT PULL] regulator updates for v3.8
Message-ID: <20130129034142.GB6878@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rS8CxjVDS/+yyDmU"
Content-Disposition: inline
X-Cookie: Make a wish, it might come true.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--rS8CxjVDS/+yyDmU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit 949db153b6466c6f7cad5a427ecea94985927311:

  Linux 3.8-rc5 (2013-01-25 11:57:28 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regulator.git tags/regulator-3.8-rc5

for you to fetch changes up to 51b919bae5ea1a14083c54f494f68b6bee737716:

  Merge remote-tracking branch 'regulator/fix/lrg' into tmp (2013-01-29 11:14:41 +0800)

----------------------------------------------------------------

regulator: Fixes for v3.8-rc5

Fairly small stuff - a build failure fix for ST platforms, an error
checking fix and an update to the MAINTAINERS file for Liam.

----------------------------------------------------------------
Axel Lin (1):
      regulator: tps80031: Use IS_ERR to check return value of regulator_register()

Liam Girdwood (1):
      regulator: MAINTAINERS: update email address

Mark Brown (3):
      Merge remote-tracking branch 'regulator/fix/db8500' into tmp
      Merge remote-tracking branch 'regulator/fix/tps80031' into tmp
      Merge remote-tracking branch 'regulator/fix/lrg' into tmp

Steven Rostedt (1):
      regulators: db8500: Fix compile failure for drivers/regulator/dbx500-prcmu.c

 MAINTAINERS                            |    2 +-
 drivers/regulator/dbx500-prcmu.c       |    1 +
 drivers/regulator/tps80031-regulator.c |    2 +-
 3 files changed, 3 insertions(+), 2 deletions(-)

--rS8CxjVDS/+yyDmU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRB0TuAAoJELSic+t+oim9cWIP/isb9WXkQegHh7AmdbQ5dYio
QH2g1uUXuMbY9oO7y6JH7NeXYv8vG+Q8e9iB5VKmy+GZUiYwHCLU9Uish5eK6YdS
Ls5PXyagJVESKyrlYlYhRCTFiBKlimimf8ocICyjs1DmNtk47JeTPMqTzMQ9JZ/O
Y6U4msOGgSNprEjAgosn2UNtWZX6vsEJ0sas1LK/mCLBDzNs+sIFIXxSr4eiemAz
yifKfCH6LbtP06fIQrIJafN9XWdInCnydqsU+QRd8JkPwYcTc1CQq5dbxee3z154
UdBwTWMbsVa3xlo6KLTZiRMtjCvfBP/tg/lWIYx7tAPmrqYJU3a6Ye83uRvQ7eGJ
drbTnk47MBgGMFppk4YRLLLRCHqs6/FgCGbbom12Lo8zrZu39twuiK6iFyCW7Hg4
h9U9epCg37BOgLv/DMzKcVC5prqh3XQgYtGpZi1ylL9lrb0gZO67HeWzRuRBh6gB
MzwdL4zdqrrafFJ5n6G8xa+zCKRs4md9zk64YF1VsYN/JTDRn4HgE74zQPxg/Jln
hS8LumfrK9ZraS/wWjsDuil5lOW9mmp+7IJGPdmB15z/0u9ltsJXYMGFU/r7q4V7
s2S0G9T8vk6zqgIepkBjWNRRn1SwCPkiBDvi6/dXopHVsu6vRKkK7fXddBwBecly
3ffcVDU6I5pQ7FmwQhvI
=32Fw
-----END PGP SIGNATURE-----

--rS8CxjVDS/+yyDmU--
