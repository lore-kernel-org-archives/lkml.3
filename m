Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751724Ab3COFjj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 01:39:39 -0400
Received: from mail.active-venture.com ([67.228.131.205]:62849 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903Ab3COFji (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 01:39:38 -0400
X-Originating-IP: 108.223.40.66
Date: Thu, 14 Mar 2013 22:39:44 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: [GIT PULL] hwmon patches for 3.9-rc3
Message-ID: <20130315053944.GA26887@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="a8Wt8u1KmwUX3Y2C"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--a8Wt8u1KmwUX3Y2C
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

Please pull hwmon patches for Linux 3.9-rc3 from signed tag:

    git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.git hwmon-for-linus

Thanks,
Guenter

------

The following changes since commit f6161aa153581da4a3867a2d1a7caf4be19b6ec9:

  Linux 3.9-rc2 (2013-03-10 16:54:19 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.git tags/hwmon-for-linus

for you to fetch changes up to 8c958c703ef8804093437959221951eaf0e1e664:

  hwmon: (pmbus/ltc2978) Fix temperature reporting (2013-03-14 09:03:51 -0700)

----------------------------------------------------------------
Bug fixes for pmbus, ltc2978, and lineage-pem drivers
Added specific maintainer for some hwmon drivers

----------------------------------------------------------------
Axel Lin (1):
      hwmon: (lineage-pem) Add missing terminating entry for pem_[input|fan]_attributes

David Woodhouse (1):
      hwmon: (pmbus) Fix krealloc() misuse in pmbus_add_attribute()

Guenter Roeck (2):
      MAINTAINERS: Add maintainer for MAX6697, INA209, and INA2XX drivers
      hwmon: (pmbus/ltc2978) Fix temperature reporting

 MAINTAINERS                      |   25 +++++++++++++++++++++++++
 drivers/hwmon/lineage-pem.c      |    2 ++
 drivers/hwmon/pmbus/ltc2978.c    |   14 ++++++++------
 drivers/hwmon/pmbus/pmbus_core.c |   12 +++++++-----
 4 files changed, 42 insertions(+), 11 deletions(-)

--a8Wt8u1KmwUX3Y2C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJRQrQfAAoJEMsfJm/On5mBN9oQAKdsABx3xPzm67lc8D8eydtJ
JTJpkM6bM3P8CHGGxRGO8mrkc8bXmCQ1OAo2GDaf6RLL9zOF8t9XnxocnHLML1Cf
WI2j6se93gyCPSQL6PFDlE8Wg4mfPpH44U03QcbKvEXXmkZJVkGcAgZXfssxuFKD
lXQAVxBNU+otnpprj0pNNOVbLBnxmQWqpMPoXFoZrCCgF0xVP5IFUKZnqgmet25U
Gq3iqRz5FzuXl1Q5ZkN6AfJ9iWYtcefba3nwuIReBGjYc9d4pseq6bvrX8F4JKY9
wBZCun+Kf8KOaNc/mLqEMui2sbo25EoDW7bBwKGv2wmGpGdU6rtcNrmd8Wmh7LgB
SJZZQF/nwqOAiiM5Ibk+WVQctOhEvdywxBMTyMGtiPNMS3zB66j73orvFdinXRpQ
bZzAruP0aQvz5NN8xg8AzuE+/GJSqn+nmEG/tjmYz4yRmDxgkU/qwvyiQgN7snud
e6LWevZgLKNz51QAFbV4HTsz+9u5Mo7+gPqLC5hy5lZc4n0WF20K0YF7iaTU+hmM
HhEmFDKz0Jf7ixHCTTL3G7+Mg7bEdJD3/oHWRo9+Q/Tfu/ZrM9/8ITUYRkpE/1Oa
GQ3nBUSWrGz/w0XDLNuerDJ9mUYZXZSHnn0vpiCw0wXdLStTI+arfNdj+LOHJR+Q
wt+k8C82EGaJIJ980ZR2
=AbTY
-----END PGP SIGNATURE-----

--a8Wt8u1KmwUX3Y2C--
