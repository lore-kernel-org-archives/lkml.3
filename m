Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753351AbaFMQH0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 12:07:26 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:60035 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752166AbaFMQHZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 12:07:25 -0400
Date: Fri, 13 Jun 2014 09:07:14 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: [GIT PULL] hwmon updates for 3.16 (take two)
Message-ID: <20140613160714.GA16162@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0OAP2g/MAC+5xKAE"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0OAP2g/MAC+5xKAE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

Please pull the second round of hwmon updates for Linux 3.16 from signed tag:

    git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.git hwmon-for-linus

Thanks,
Guenter
------

The following changes since commit 5c02c392cd2320e8d612376d6b72b6548a680923:

  Merge tag 'virtio-next-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/rusty/linux (2014-06-11 21:10:33 -0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.git tags/hwmon-for-linus

for you to fetch changes up to 78cebd0889c7b8b92f43e7667efc16636b858c34:

  hwmon: vexpress: Use devm helper for hwmon device registration (2014-06-12 08:36:50 -0700)

----------------------------------------------------------------
New driver for Sensirion SHTC1 humidity / temperature sensor
Convert ltc4151 and vexpress drivers to use devm functions
Drop generic chip detection from lm85 driver
Avoid forward declarations in atxp1 driver
Fix sign extensions in ina2xx driver

----------------------------------------------------------------
Axel Lin (2):
      hwmon: (ltc4151) Convert to devm_hwmon_device_register_with_groups
      hwmon: (atxp1) Avoid forward declaration

Fabio Baltieri (1):
      hwmon: (ina2xx) Cast to s16 on shunt and current regs

Jean Delvare (1):
      hwmon: (lm85) Drop generic detection

Pawel Moll (1):
      hwmon: vexpress: Use devm helper for hwmon device registration

Tomas Pop (1):
      hwmon: add support for Sensirion SHTC1 sensor

 Documentation/hwmon/shtc1           |  43 ++++++
 drivers/hwmon/Kconfig               |  10 ++
 drivers/hwmon/Makefile              |   1 +
 drivers/hwmon/atxp1.c               |  42 +++---
 drivers/hwmon/ina2xx.c              |   7 +-
 drivers/hwmon/lm85.c                |  33 ++---
 drivers/hwmon/ltc4151.c             |  51 ++------
 drivers/hwmon/shtc1.c               | 251 ++++++++++++++++++++++++++++++++++++
 drivers/hwmon/vexpress.c            |  82 ++++--------
 include/linux/platform_data/shtc1.h |  23 ++++
 10 files changed, 401 insertions(+), 142 deletions(-)
 create mode 100644 Documentation/hwmon/shtc1
 create mode 100644 drivers/hwmon/shtc1.c
 create mode 100644 include/linux/platform_data/shtc1.h

--0OAP2g/MAC+5xKAE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTmyGxAAoJEMsfJm/On5mBWWEP/23ODeHy2HxG1l7zwSFR/nMx
K5cuhDjK6BzYBzTWjyBmpSaIigJVoo9B8S9PcYyOkblLbhH8VlhP7I1FOsrnDaSj
0AYetbBQJL5/oho5Ydd/D1rlFSTNHOrFw/s2aJIovnfeRgmHNwf0wSGOEwHRCp9K
JE/BQxkyq0Y1/q5kRCJhTV9q8A42OWoLWUAdOuYfjEtn7Ir27VZoEPxkv1CNS8nY
dC9fm8M87hy5LTuC9f1Ueb/axenX6Rs2HuFmRfifSbpTsd1Xeq3UrO4G+Y1ybLPo
eSiOHYhiW2shf9VQ5hQ4zXEwWuOTIZH8TbDj+JkmiT+5SmmlJgHauNxTI87WamEv
K6ctzAGdyEdn0teQQG4YXZCDboFeKHdJfRqU7jAfIi6iSMAX6HmuZvwCVEQyy4eY
CjDeLrmnieX9B8/5IrhgLVO9j9N3dyaHZUynHo/YpbDLb/RSSdPUTy+Ul8hpGiMf
KfuarBSJLAkkI8gkB6tA3h102c+OtHWCTqYB26iusN7CQybvBUDFjZUnpeJ2RRzX
buUaOPzLCu9Ea43VJtI5Seu80/8mheKfCm3iPWgbVDDTvUbJ80ycNd7jVQWapUxB
l+kMEriyroDnnFPHXbfcnwINO5eece+awdPUoMTygCI9nEa2x9UjemnouI+QLhyC
ciap2GYkGPSQxvJb1UOh
=Tdsi
-----END PGP SIGNATURE-----

--0OAP2g/MAC+5xKAE--
