Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753449AbaHKRuE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 13:50:04 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:52848 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751874AbaHKRuB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 13:50:01 -0400
Date: Mon, 11 Aug 2014 10:49:57 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: [GIT PULL] hwmon updates for 3.17 (part 2)
Message-ID: <20140811174957.GA24677@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zYM0uCDKw75PZbzx"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--zYM0uCDKw75PZbzx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

Please pull hwmon updates for Linux 3.17 from signed tag:

    git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.git hwmon-for-linus

Thanks,
Guenter
------

The following changes since commit f4d33337eac4007793ca11fd1ab68d91ce7aa762:

  Merge branch 'v4l_for_linus' of git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media (2014-08-05 16:36:30 -0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.git tags/hwmon-for-linus

for you to fetch changes up to 6ddd855c13bcd324a2d9756134e6b57c659cfde6:

  hwmon: (tmp103) Remove duplicate test for I2C_FUNC_SMBUS_BYTE_DATA functionality (2014-08-10 07:51:42 -0700)

----------------------------------------------------------------
Several bug fixes in various drivers, plus a minor cleanup
in the tmp103 driver.

----------------------------------------------------------------
Axel Lin (14):
      hwmon: (lm92) Prevent overflow problem when writing large limits
      hwmon: (ads1015) Fix out-of-bounds array access
      hwmon: (dme1737) Prevent overflow problem when writing large limits
      hwmon: (hih6130) Fix missing hih6130->write_length setting
      hwmon: (adm1025) Fix vrm write operation
      hwmon: (adm1026) Fix vrm write operation
      hwmon: (asb100) Fix vrm write operation
      hwmon: (lm87) Fix vrm write operation
      hwmon: (pc87360) Fix vrm write operation
      hwmon: (vt1211) Fix vrm write operation
      hwmon: (w83627hf) Fix vrm write operation
      hwmon: (w83791d) Fix vrm write operation
      hwmon: (w83793) Fix vrm write operation
      hwmon: (tmp103) Remove duplicate test for I2C_FUNC_SMBUS_BYTE_DATA functionality

Guenter Roeck (1):
      hwmon: (emc6w201) Fix temperature limit range

 drivers/hwmon/adm1025.c  |  3 +++
 drivers/hwmon/adm1026.c  |  3 +++
 drivers/hwmon/ads1015.c  |  2 ++
 drivers/hwmon/asb100.c   |  4 ++++
 drivers/hwmon/dme1737.c  | 33 ++++++++++++++++++---------------
 drivers/hwmon/emc6w201.c |  4 ++--
 drivers/hwmon/hih6130.c  |  3 +++
 drivers/hwmon/lm87.c     |  4 ++++
 drivers/hwmon/lm92.c     | 13 ++++++-------
 drivers/hwmon/pc87360.c  |  3 +++
 drivers/hwmon/tmp103.c   |  7 -------
 drivers/hwmon/vt1211.c   |  3 +++
 drivers/hwmon/w83627hf.c |  3 +++
 drivers/hwmon/w83791d.c  |  3 +++
 drivers/hwmon/w83793.c   |  3 +++
 15 files changed, 60 insertions(+), 31 deletions(-)

--zYM0uCDKw75PZbzx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJT6QJFAAoJEMsfJm/On5mBpgwP/jjq6YvZspromQbrKJtCbeVL
GvjnbAAymIziopwz903f1ud7RDex/NoQbnQTEqPbckb4y3YnFQ49l/w5zKFLxSlK
L2+zaEpWD0IyGslXlqsSCbozvPOto9A5Q+ye2+Vn+RPTjQblmbrdhJ6mxjMmKrpD
q6MXQRIHt+192H5mtFYrLFkeReqZ3yk4tDKCQIUmp8exvzwQpEOuBLmh9XpraY83
FquePMPSGYsMqhrSo+U748+x347Ptcuhi22quMXDf44an+qFxcGbaClWuKp0zER9
J0kZJ0V2jXop0e0G5ICRyUvNuu/a5tT2PJsbv96HONIN7h65Zog9nKgmzl2S4bsX
H26iBDI0qy4FPYBTp0gLb6wbtD8pMg3/Ede5bfyjtgtMJAsYGFZqsE6hvZE7adma
WOzR8yn6N+qWMUsCGUygsy9UnIdRR/+AzsrNBkFPDVQR832zGioUArqrK5OCF/bS
vc2SDxw14KsP49EsVge42NLW2yw7m+C0fSsPBLgHD8vaNgbdo8NB6As3MCCzqPEV
9EJN9akhMILIklM/hPB7xPb+FILSpxHD/8GF6Q+ZjJ3TVU1vhliTG30cdeQIdopZ
ziRN35ldAGTGagNv83ULcktEl4XfpfWX7bvko8qhE3R4yJ59DH8Ys20nnRqkfB3J
GmmJfRWwjx2uMPbEM0uH
=x1bn
-----END PGP SIGNATURE-----

--zYM0uCDKw75PZbzx--
