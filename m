Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756261AbaFQLr1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 07:47:27 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:45588 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755804AbaFQLr0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 07:47:26 -0400
Date: Tue, 17 Jun 2014 12:47:10 +0100
From: Mark Brown <broonie@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lgirdwood@gmail.com>
Message-ID: <20140617114710.GO5099@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xowHwAye8tkBAj6Y"
Content-Disposition: inline
X-Cookie: Ditat Deus.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [GIT PULL] regulator fixes for v3.16-rc1
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--xowHwAye8tkBAj6Y
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit 7171511eaec5bf23fb06078f59784a3a0626b38f:

  Linux 3.16-rc1 (2014-06-15 17:45:28 -1000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regulator.git tags/regulator-v3.16-rc1

for you to fetch changes up to c9ac065928d887e26da33a84210a3e3610052d31:

  Merge remote-tracking branches 'regulator/fix/as3722', 'regulator/fix/ltc3589' and 'regulator/fix/palmas' into regulator-linus (2014-06-16 16:05:57 +0100)

----------------------------------------------------------------

regulator: Fixes for v3.16

A few small fixes:

 - Fixes for bugs in Palmas and as3722 exposed by recent changes in the
   core - the drivers weren't allowing the current configuration to be
   read sometimes.
 - Provide a stub for regulator_can_change_voltage() for !REGULATOR.
 - Make sure ltc3589 only looks at its child nodes in the device tree
   rather than searching the whole tree.

----------------------------------------------------------------
Arnd Bergmann (1):
      regulator: add regulator_can_change_voltage stub

Axel Lin (1):
      regulator: ltc3589: Use of_get_child_by_name

Mark Brown (2):
      Merge remote-tracking branch 'regulator/fix/core' into regulator-linus
      Merge remote-tracking branches 'regulator/fix/as3722', 'regulator/fix/ltc3589' and 'regulator/fix/palmas' into regulator-linus

Nishanth Menon (1):
      regulator: palmas: Fix SMPS list for 0V

Thierry Reding (1):
      regulator: as3722: Make 0 a valid selector

 drivers/regulator/as3722-regulator.c | 2 ++
 drivers/regulator/ltc3589.c          | 2 +-
 drivers/regulator/palmas-regulator.c | 2 ++
 include/linux/regulator/consumer.h   | 5 +++++
 4 files changed, 10 insertions(+), 1 deletion(-)

--xowHwAye8tkBAj6Y
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJToCq7AAoJELSic+t+oim9KAkP/RwTrrcWG/vNg93gOS6E2AIF
Ql5gNoE9sJsg8A3Rcl7/ThFJnHIWtNzyA4eoZgrkYGvsKjsm705kSgDMo+uVV923
B037yFkDKpEiPLH128VQSfdmMMA+X77vMDMs8u9O2X5ByubnAkCBJZppMBybL7KJ
hRlpOOag//+2Yjzp1tRnX3KF/NXnOK0+Z9+5x3ioGLwrzyx5Jy4eEwc/Yp0gOoEz
SFOOpTyVONqgWcApIMyf4ZoRyv8xpmSQP01L8NGvfR2oY96JmeN2URbFtvQDHxSp
ttl9geAQHVRAYd8KxC/ezSzExm6PPnEkP/vtIPWDlwQbk8UyDFSD1UTMGm1u354e
YXCaphHXcsIxTriM7qzbg295mDm5w7I4w6bYZAzZUGQbl2hAmvL2hzYF6MIgvBmg
RFI8XzmaYXyIEo7AHllG7bbFWDAyohB6fHiePfXRACO/rokSGkEG2DNeMV0ybIsR
rhSJNOoxtWsKV/9dd4VjrpztM1tUeYUG8VXNytpi4J86iy53b0p+7tJJ+4ZB6Vig
lk787S+7x3CWlQCynf4BlMT+JrRZnrkuPI5MtrlONfOY3EPyvlbSm9+T+wAozJe+
ECFurcP/jdWvZZ0fgalcvOo9OY/HHoTLNwIUekAv3jNnSca4oGonitaQu6kFwYUg
3iPntsZUn6GCLduFn8Kq
=3/A+
-----END PGP SIGNATURE-----

--xowHwAye8tkBAj6Y--
