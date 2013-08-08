Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757750Ab3HHKnI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 06:43:08 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:49936 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751429Ab3HHKnG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 06:43:06 -0400
Date: Thu, 8 Aug 2013 11:42:43 +0100
From: Mark Brown <broonie@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lgirdwood@gmail.com>
Message-ID: <20130808104243.GX6427@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KISHs/FnjYvFOG5B"
Content-Disposition: inline
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [GIT PULL] regulator fixes for v3.11
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--KISHs/FnjYvFOG5B
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit ad81f0545ef01ea651886dddac4bef6cec930092:

  Linux 3.11-rc1 (2013-07-14 15:18:27 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regulator.git tags/regulator-v3.11-rc4

for you to fetch changes up to 386c90ac747913f1a31a0cdacb14f2347114474d:

  regulator: palmas-pmic: doc: remove ti,tstep (2013-07-17 11:05:58 +0100)

----------------------------------------------------------------
regulator: DT binding fixes for v3.11

A couple of fixes to bring the DT binding documentation for Palmas into
sync with the code.

----------------------------------------------------------------
Nishanth Menon (2):
      regulator: palmas-pmic: doc: fix typo for sleep-mode
      regulator: palmas-pmic: doc: remove ti,tstep

 Documentation/devicetree/bindings/regulator/palmas-pmic.txt | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--KISHs/FnjYvFOG5B
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJSA3YgAAoJELSic+t+oim9if4P/3qyU1omFcclAUGygpgBUTSe
mLiipE1N4jK8sKILTRriDACPGPXXqRlKgcZ78lS4zzd98cdiryg9O0bB+/kaTmAl
VBz1VRZQxuzGnZise9qDayMvagqlrpiz8n2Gu/tH5+xT7huU5NZGH3sFJM4PafHq
93EO6e/nD6Zi/Z9/6MFgAI7OpAgVpU1nfpZGm6fL6cNajo5JtESZWPhyx5KJdO08
iKmlxCkZQKlXt8lL5cUD8oQr/+CxI/BdnszANcsa1X8a3hYGCLL8UrHZh4D+ad5K
KX7GsrracKKcoJsAvA7YEYWmRyTlV1QuCA3juE1s1fYOeMmYTkFbD2U2eFcJw7GW
AfpooCLySUhr8QXKc53BbH5/qrETHakKZ31OStmYiCvLZOEWqHP81iqp/9x5ldgR
ON/nS5ile8Sg60sb1zpVZ28QToOPKBnhedm/m5UBYLKRlLLA61eYc6Pqog1aAcYM
zj1aUTebIovvFcS+KEGrekkIooR1JsiSO6sjrzbb664Z54U/bURV8osexnuX49nX
Hyiz+8DZ34684gW/WcbeTCW5w1WDKJDiBa3I1A4YEH7IlX6c5z9MEE4T677WdATF
NE05wbgjHwW55m3lDeamKbQ/zy34dlud9bf56zyhXEuIUbaJzqWNcqWv052gtrDQ
/LAAEXsTA0kcN6FaeleJ
=iRQI
-----END PGP SIGNATURE-----

--KISHs/FnjYvFOG5B--
