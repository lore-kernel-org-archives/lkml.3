Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754260Ab3GAOJ1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 10:09:27 -0400
Received: from mail.active-venture.com ([67.228.131.205]:52500 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753975Ab3GAOJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 10:09:25 -0400
X-Originating-IP: 108.223.40.66
Date: Mon, 1 Jul 2013 07:09:25 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: [GIT PULL] hwmon updates for 3.11
Message-ID: <20130701140925.GA30297@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="y0ulUmNC+osPPQO6"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--y0ulUmNC+osPPQO6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

Please pull hwmon updates for Linux 3.11 from signed tag:

    git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.git hwmon-for-linus

Thanks,
Guenter
------

The following changes since commit 7d132055814ef17a6c7b69f342244c410a5e000f:

  Linux 3.10-rc6 (2013-06-15 11:51:07 -1000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.git tags/hwmon-for-linus

for you to fetch changes up to a50d9a4d9ad3c71341788099d733e4151b8a511b:

  hwmon: (ds1621) Fix temperature rounding operations (2013-06-28 06:43:55 -0700)

----------------------------------------------------------------
New driver to support GMT G762/G763 pwm fan controllers
Add support for DS1631, DS1721, and DS1731 to ds1621 driver
Remove detect function from ds1621 driver as unreliable
Bug fixes in nct6775, iio_hwmon, and adm1021 drivers
Remove redundant platform_set_drvdata in various drivers
Add device tree support to ina2xx driver

----------------------------------------------------------------
Arnaud Ebalard (1):
      Add support for GMT G762/G763 PWM fan controllers

Guenter Roeck (4):
      hwmon: (adm1021) Do not create min sysfs attributes for LM84
      hwmon: (nct6775) Fix temperature alarm attributes
      hwmon: (nct6775) Drop unsupported fan alarm attributes for NCT6775
      hwmon: (ds1621) Fix temperature rounding operations

Robert Coulson (6):
      hwmon: (ds1621) Add ds1721 chip support
      hwmon: (ds1621) Add ds1721 update interval sysfs attribute
      hwmon: (ds1621) Add ds1631 chip support to ds1621 driver and documentation
      hwmon: (ds1621) Remove detect function
      hwmon: (ds1621) Add DS1731 chip support to ds1621 driver
      hwmon: (ds1621) Update documentation

Sachin Kamat (5):
      hwmon: (abituguru3) Remove redundant platform_set_drvdata()
      hwmon: (coretemp) Remove redundant platform_set_drvdata()
      hwmon: (i5k_amb) Remove redundant platform_set_drvdata()
      hwmon: (ntc_thermistor) Remove redundant platform_set_drvdata()
      hwmon: (w83627ehf) Remove redundant platform_set_drvdata()

Sebastian Andrzej Siewior (1):
      hwmon: (iio_hwmon) add alias table

Tang Yuantian (1):
      hwmon: (ina2xx) Add device tree support to pass the shunt resistor

 Documentation/devicetree/bindings/hwmon/g762.txt |   47 +
 Documentation/devicetree/bindings/i2c/ina2xx.txt |   22 +
 Documentation/hwmon/ds1621                       |  144 ++-
 Documentation/hwmon/g762                         |   65 ++
 Documentation/hwmon/ina2xx                       |    4 +-
 drivers/hwmon/Kconfig                            |   21 +-
 drivers/hwmon/Makefile                           |    1 +
 drivers/hwmon/abituguru3.c                       |    1 -
 drivers/hwmon/adm1021.c                          |   32 +-
 drivers/hwmon/coretemp.c                         |    2 -
 drivers/hwmon/ds1621.c                           |  226 ++++-
 drivers/hwmon/g762.c                             | 1149 ++++++++++++++++++++++
 drivers/hwmon/i5k_amb.c                          |    2 -
 drivers/hwmon/iio_hwmon.c                        |    1 +
 drivers/hwmon/ina2xx.c                           |    5 +
 drivers/hwmon/nct6775.c                          |   92 +-
 drivers/hwmon/ntc_thermistor.c                   |    1 -
 drivers/hwmon/w83627ehf.c                        |    2 -
 include/linux/platform_data/g762.h               |   37 +
 19 files changed, 1743 insertions(+), 111 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/hwmon/g762.txt
 create mode 100644 Documentation/devicetree/bindings/i2c/ina2xx.txt
 create mode 100644 Documentation/hwmon/g762
 create mode 100644 drivers/hwmon/g762.c
 create mode 100644 include/linux/platform_data/g762.h

--y0ulUmNC+osPPQO6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR0Y2VAAoJEMsfJm/On5mBo48P/2NyHO5Bx4wFSB3O7m1/0rrr
FWZOk+Z+PihPEE2KSq+xY05OsexUU6PVy24BVA1mlcrue4mcnRFNE26XCw41rjx9
E8fVh3rwMGzis75dmFABtP3e3gytYA0jEL3Ygge8IEyfvYtGGxycah6pgTr2nBRN
rZPmlerk/aZUuERGvQ+h/wYSPAijE5DBuHeKQQ9Mlo5aMGCFvEQZWc7bnSpkqWXV
e8wUGFxYKU1gTUorRzaR6Nb+WQCz/aeiRvZZL3iQmb7VMPcjJK7x8yADgY3kUc5+
LJVbj+yIhNPbFur+p4S3dD3Jdp9NgdN5bslMILM5F07oy3NvKQTPc7qnLaIT7/dQ
y0gZ374ZIuUKMiFPSIaQJG8R4EdnDQAapiMSkmA4Qe9U4SjlcBqxCo7AYVrOI4vN
2F7SO2ncy7nAQNnl3iCcFZXaTvGojUKFBYO3QLwWa2Ps2SLwIESXNXb2zNyvmfBt
nU3c6167hpU8hB5GQhyOHCuOorp/+2lbBDr0MzLhPh5/u+ivHgMVgGbGFxnGqG5n
o/1cK7UqZhYfWjTkSprwN78uEE6sQIk524PwYvHVmAIq22v2ZmzxiwF8VPb6R0iX
VPTbObd+xY8MlIL792DVLhzd2WmvPU7qU09SvOVrxH8Jm/fxeUVd+OwQVGvGOjzT
BxuMMET8EErSS16xDeBS
=MJg0
-----END PGP SIGNATURE-----

--y0ulUmNC+osPPQO6--
