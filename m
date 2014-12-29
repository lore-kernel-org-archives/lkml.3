Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752284AbaL2QWv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 11:22:51 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:54385 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752141AbaL2QWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 11:22:50 -0500
Date: Mon, 29 Dec 2014 16:22:34 +0000
From: Mark Brown <broonie@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <20141229162234.GX17800@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PeEtTtIyPIoxp38l"
Content-Disposition: inline
X-Cookie: You have no real enemies.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 86.128.155.20
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [GIT PULL] spi fixes for v3.19
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--PeEtTtIyPIoxp38l
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit 97bf6af1f928216fd6c5a66e8a57bfa95a659672:

  Linux 3.19-rc1 (2014-12-20 17:08:50 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/spi.git tags/spi-v3.19-rc2

for you to fetch changes up to ee4629f5b2f3dda7c83fa816068a67073abb55d9:

  Merge remote-tracking branches 'spi/fix/img-spfi' and 'spi/fix/msiof' into spi-linus (2014-12-24 12:57:54 +0000)

----------------------------------------------------------------
spi: Fixes for v3.19

A few driver specific fixes here, the DMA burst size increase in the
spfi driver is a fix to make the hardware happier in some situations.

----------------------------------------------------------------
Andrew Bresticker (2):
      spi: img-spfi: Enable controller before starting TX DMA
      spi: img-spfi: Increase DMA burst size

Hisashi Nakamura (1):
      spi: sh-msiof: Add runtime PM lock in initializing

Mark Brown (1):
      Merge remote-tracking branches 'spi/fix/img-spfi' and 'spi/fix/msiof' into spi-linus

 drivers/spi/spi-img-spfi.c | 8 ++++----
 drivers/spi/spi-sh-msiof.c | 5 +++++
 2 files changed, 9 insertions(+), 4 deletions(-)

--PeEtTtIyPIoxp38l
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUoX/KAAoJECTWi3JdVIfQEQgH/3GzO1IF5/oSw5YNywyIcu7w
sAyUVp6d6pkfJi4313dNVzXpdTKwJsanBK837NX2W8aYJjGseTtRzIkhFpYejy8T
cTLTrEbInlLi+r/pwuoupPJ/Xvfr1Xss1gi0Lx3yfaYqOgMs8r0o3aNe0cW6lJyq
/X0hVGrJSnQjxpj5JKhv2AQfgKsLdv8Cp7kGVhM+HWcR9NSSniPkg5as/dKkRzcP
7ODzIGq59eOOyTEIutc0PpVusWqGh9Ba9fI3F8onT3QOMxLlK9wUaL4dQHTi5Z39
RN/r15K3gR0B1xk6kw+Av7f8BhNLOqJ56kpOVH6iS57t6FEs1VphKmJvDFgHDXI=
=Pv9i
-----END PGP SIGNATURE-----

--PeEtTtIyPIoxp38l--
