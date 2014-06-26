Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751874AbaFZEgj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 00:36:39 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:35228 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770AbaFZEgi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 00:36:38 -0400
Date: Wed, 25 Jun 2014 21:36:34 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: torvalds@linux-foundation.org
Cc: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] hwmon fixes for 3.16-rc3
Message-ID: <20140626043634.GA4242@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BXVAT5kNtrzKuDFl"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--BXVAT5kNtrzKuDFl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

Please pull hwmon fixes for Linux 3.16-rc3 from signed tag:

    git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.git hwmon-for-linus

Thanks,
Guenter
------

The following changes since commit a497c3ba1d97fc69c1e78e7b96435ba8c2cb42ee:

  Linux 3.16-rc2 (2014-06-21 19:02:54 -1000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.git tags/hwmon-for-linus

for you to fetch changes up to d26e0da783adbb94977f60dec9a035b427813b83:

  hwmon: (gpio-fan) Change name used in hwmon_device_register_with_groups (2014-06-25 15:16:09 -0700)

----------------------------------------------------------------
Various minor fixes

----------------------------------------------------------------
Axel Lin (1):
      hwmon: (w83l786ng) Report correct minimum fan speed

Josef Gajdusek (1):
      hwmon: (emc1403) Fix missing 'select REGMAP_I2C' in Kconfig

Julien D'Ascenzio (1):
      hwmon: (gpio-fan) Change name used in hwmon_device_register_with_groups

Naveen Krishna Chatradhi (2):
      devicetree: bindings: Document murata vendor prefix
      hwmon: (ntc_thermistor) Use the manufacturer name properly

 .../devicetree/bindings/arm/samsung/exynos-adc.txt   |  2 +-
 .../devicetree/bindings/hwmon/ntc_thermistor.txt     | 20 ++++++++++++++------
 .../devicetree/bindings/vendor-prefixes.txt          |  1 +
 Documentation/hwmon/ntc_thermistor                   |  8 ++++----
 drivers/hwmon/Kconfig                                |  6 ++++--
 drivers/hwmon/gpio-fan.c                             |  2 +-
 drivers/hwmon/ntc_thermistor.c                       | 14 +++++++++++++-
 drivers/hwmon/w83l786ng.c                            |  2 +-
 8 files changed, 39 insertions(+), 16 deletions(-)

--BXVAT5kNtrzKuDFl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTq6NSAAoJEMsfJm/On5mBNo4P/AjkFjGcDtYmvzvI2l6qXPLM
EAZ7GmX8fTRUNHm6mX0uZEUUm2aGtcouFjteCfiia2NMqJfiKCEuwSNnsc9FBbZr
Kd4UQEilmRHJxuB0qe2quTm+4DBYOp/sHGJJd3U0EY8HdZtMjQW+Zhnd/hS6mSXM
5VYs05kREvAOJ4gdqgbaarwOzUleI8gYOwnEend/ECDBlmNT6y4FlovsDJaWt4am
lG4uLHKiG8Zcp20VHpTDNoHlsIGd3U9o42+Z/Z7X/N75BXVXALQix3I3F3Cr2Grp
l2Pcqdc2ARKs7oE3MeT+GXm2SPzHDZ7EQhzzeVQJkyJPLOiHlAnKftrueI5+vE7C
tQGaBWIDMX2PpGkPoLmUP2ZlyxcmeeBZnknfdoMf2e/UlJ6k3cNQCZUmLc9g1b9g
xTrGNa+LBrod2QClY2RaKsj5oQSXDg8blbr4XnNk8+mshhXweWBEWZCWPGfnFzs/
lkGEU4v2A+Yl2ipf7L7TBEeJJapHcqwTrJ99Sn/wfiY4YXKUt/2xgJMBzYwKaw4B
bN0cZ7hMEXCNsaXnC/+jyAXBaDqW4OEaGQUcZ85OAMRzA+Nzot+ZQ6Vx6YXYBJrA
4kwZ5DfuGjXZ/7m+Lrjq2E4DI2Mlgsv10LWqCGHv9A4Kq9GSi1RmMs0FWuM7a+YM
K8YyH3oEBwjBi09a/oAn
=+3Bk
-----END PGP SIGNATURE-----

--BXVAT5kNtrzKuDFl--
