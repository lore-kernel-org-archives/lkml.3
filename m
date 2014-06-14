Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754877AbaFNPSC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2014 11:18:02 -0400
Received: from mail.kernel.org ([198.145.19.201]:44340 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754710AbaFNPR5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2014 11:17:57 -0400
Date: Sat, 14 Jun 2014 17:17:47 +0200
From: Sebastian Reichel <sre@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] HSI fixes for 3.16
Message-ID: <20140614151734.GA10835@earth.universe>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="YZ5djTAD1cGYuMQK"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--YZ5djTAD1cGYuMQK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

The following changes since commit eafaebd987fcd001e2c123c050939a29c625d673:

  HSI: Introduce Nokia N900 modem driver (2014-05-16 00:55:42 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/sre/linux-hsi.git tags/hsi-for-3.16-fixes1

for you to fetch changes up to b357d7b58f379ebe8038cd97b6204f2f5c52220d:

  hsi: omap_ssi_port: use normal module refcounting (2014-06-05 00:59:05 +0200)

----------------------------------------------------------------
HSI Fixes for the v3.16 series:

* Tighten Dependency between ssi-protocol and omap-ssi
  to fix build failures with randconfig.
* Use normal module refcounting in omap driver to fix
  build with disabled module support.

----------------------------------------------------------------
Arnd Bergmann (2):
      HSI: fix omap ssi driver dependency
      hsi: omap_ssi_port: use normal module refcounting

 drivers/hsi/clients/Kconfig             | 2 +-
 drivers/hsi/controllers/omap_ssi_port.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

-- Sebastian

--YZ5djTAD1cGYuMQK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJTnGeOAAoJENju1/PIO/qaDr8QAJL7hLKsuiAZod7tJ2rJj4ca
GbGGr7WSdEHHdqonzt9fVjTLWY6T4KJAiGdo/1cE140WoFnYcGaUENrlLeLAy4ui
9CKAJtTZRZDTo3DM4nqE/aL4lM2OGQ42naid9VQ4R4Dh246YG0ww/OYAPaeFY0KR
Tl/vbfm21jpUxb5MuEWc3tw6/ELQCEteYHfdDuR/jzTb/FdjsjViCOXQehtJX6bm
cJETuGt+s8RPAtXXiKARtXbmbH5k89VGxHs/85+sSE3pTlOlvIToVhN5b9co0CSn
5sFIRPNA5E5f/SuusNwficR+UtNCiSUNqjCoq3iqKFstws93N+OLH4GCRDjtEfaO
GSJYdk4zesjKYZllXWjy6KUG6TjgwB3W5fErSfGAFXZjKRAqgMexdMEEhz1qSRoR
SmI3A+yNSB+uT8WOrMA+nSUrUOokyX1m+4RlUrhmkHT7d7r6eCixfGJAaJcrtrL8
hjC2QzLyaRe+tlJB3ojN2nWzc55w+U+dnxwq2JKRRbdISZLUPGWUn1GCb+Styjc4
aeBVJcU03fesKUlaHMTU5oEPhQ2lYzOCiLxkm5c7Y7jdBFLlh3DCB0VVYcY6HY54
Yk8p0VuWScq9hnkBxors8vaRzmGGp+PLQGWW0tDNOddM5YhndcNtiIEdyBwsfme5
6QzYCGYl4hd1NnSK+dhM
=gLSf
-----END PGP SIGNATURE-----

--YZ5djTAD1cGYuMQK--
