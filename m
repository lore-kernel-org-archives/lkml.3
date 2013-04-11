Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935138Ab3DKQpL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 12:45:11 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58291 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762512Ab3DKQpJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 12:45:09 -0400
Date: Thu, 11 Apr 2013 17:45:02 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] regmap update for v3.9
Message-ID: <20130411164502.GJ9243@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="633Qqqc8nwy7lrt9"
Content-Disposition: inline
X-Cookie: Your love life will be... interesting.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--633Qqqc8nwy7lrt9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit 31880c37c11e28cb81c70757e38392b42e695dc6:

  Linux 3.9-rc6 (2013-04-07 20:49:54 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regmap.git tags/regmap-v3.9-rc6

for you to fetch changes up to 51a246aa5c0a14b3d34a5c6d3c9e271c784b127f:

  regmap: Back out work buffer fix (2013-04-09 18:03:25 +0100)

----------------------------------------------------------------
regmap: Back out work buffer fix

This reverts commit bc8ce4 (regmap: don't corrupt work buffer in
_regmap_raw_write()) since it turns out that it can cause issues when
taken in isolation from the other changes in -next that lead to its
discovery.  On the basis that nobody noticed the problems for quite some
time without that subsequent work let's drop it from v3.9.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

----------------------------------------------------------------
Mark Brown (1):
      regmap: Back out work buffer fix

 drivers/base/regmap/regmap.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--633Qqqc8nwy7lrt9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRZuiFAAoJELSic+t+oim9F8kP/2mvDYlm5Yh/G/DPr5MoTJL5
U5YnYWuhvYJzXuIZsKe1qlDqX9tMKrOVZo70LAhXQZb/Pxu6wJrnPnSHr4BgFlC8
hHQdW/S99eS0/wY/lzGPlVGrhLRsIHo4n8pVpVm3HXEtWN76Iq1i/Roq/uO1GDBT
pHMNmRqRx8kHI43govBHPdPufMNIDNI0avSeLHL1T/fmf+vMoK649UMeC9hifybu
OxtLcMDZ2nKh7jiLofp5o2i4dw6ljYdWiRpVJy8BWHpsIV7sQYesVrTOwnexuruB
GwFxUzAB68PuO+1Gk6FF+nfdsE934j6pCk6V5YPEOvG56/RpOZ7DFok8g9mFyaBg
upTfYV8UGrj9llJg6xiKbfnEys3wDat0ZO6IpLpL2wLKYRiULwQIib5YO4bx7uqd
9z84V8FEMKJXXMKnFm4sp05OyT4Hp9xfkeC4uFx4q2t/r7wH+H9yF/aTltFkaiM9
gfh+zX1uy8usoaF0PQ0arr5haq3Wj4mrByVnBj0jOPr5zYjbSM4NelaTX+egsemP
gLuBrYqjPgintwQOmx213h6+yd8PcWMTFcQmJibxGPa6D7iBxvfoxqNzkTp7r2QW
owelYrKe4PX+S1g5ll4HDav8je6xt3ymBP2ZQMlanXlmUjO8sfTOvyZ6jrvPpm+Y
rioHbVZR0g9nm/ID8HPp
=hFjG
-----END PGP SIGNATURE-----

--633Qqqc8nwy7lrt9--
