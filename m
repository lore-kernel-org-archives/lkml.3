Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751859AbaFCECA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 00:02:00 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:59819 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751032AbaFCEB7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 00:01:59 -0400
Date: Mon, 2 Jun 2014 21:01:53 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: [GIT PULL] hwmon changes for 3.16
Message-ID: <20140603040153.GA9921@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RnlQjJ0d97Da+TV1"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--RnlQjJ0d97Da+TV1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

Please pull hwmon changes for Linux 3.16 from signed tag:

    git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.git hwmon-for-linus

Thanks,
Guenter
------

The following changes since commit 4b660a7f5c8099d88d1a43d8ae138965112592c7:

  Linux 3.15-rc6 (2014-05-22 06:42:02 +0900)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.git tags/hwmon-for-linus

for you to fetch changes up to 9d311eddf3565ed0e05b3cb5a22db41fa74d9d86:

  hwmon: (nct6775) Fix probe unwind paths to properly unregister platform devices (2014-05-24 08:30:29 -0700)

----------------------------------------------------------------
New driver for NCT6683D

New chip support to existing drivers:
	Add support for STTS2004 and AT30TSE004 to jc42 driver
	Add support for EMC1402/EMC1412/EMC1422 to emc1403 driver

Other notable changes:
	Document hwmon kernel API
	Convert jc42, lm70, lm75, lm77, lm83, lm92, max1619, tmp421,
	and tmp102 drivers to use new hwmon API functions
	Replace function macros in lm80, lm92, and jc42 drivers with
	real code
	Convert emc1403 driver to use regmap, add support for additional
	attributes, and add device IDs for EMC1412, EMC1413, and EMC1414
	Various additional cleanup and minor bug fixes in several drivers

----------------------------------------------------------------
Axel Lin (2):
      hwmon: (nct6683) Fix probe unwind paths to properly unregister platform devices
      hwmon: (nct6775) Fix probe unwind paths to properly unregister platform devices

Guenter Roeck (43):
      hwmon: (lm70) Convert to use devm_hwmon_device_register_with_groups
      hwmon: (tmp102) Introduce dev variable in probe function
      hwmon: (tmp102) Convert to use hwmon_device_register_with_groups
      hwmon: (tmp421) Convert to use devm_hwmon_device_register_with_groups
      hwmon: (lm77) Drop FSF mailing address
      hwmon: (lm77) Rearrange code to no longer require forward declarations
      hwmon: (lm77) Do not preserve hysteresis when updating critical temp limit
      hwmon: (lm77) Drop function macros
      hwmon: (lm77) Convert to use devm_hwmon_device_register_with_groups
      hwmon: (lm75) Convert to use hwmon_device_register_with_groups
      hwmon: (lm92) Drop unnecessary forward declaration
      hwmon: (lm92) Drop FSF mailing address
      hwmon: (lm92) Drop function macros
      hwmon: (lm92) Convert to use devm_hwmon_device_register_with_groups
      hwmon: (ltc2945) Fix 1st comment line
      hwmon: Document hwmon kernel API
      hwmon: (emc1403) Add driver documentation
      hwmon: (emc1403) Convert to use regmap
      hwmon: (emc1403) Report external diode fault status
      hwmon: (emc1403) Add support for alarm and diode fault status on EMC14x2
      hwmon: (emc1403) Make all hyst attributes except for temp1_crit_hyst read-only
      hwmon: (emc1403) Relax hysteresis limit write checks
      hwmon: (emc1403) Add support for max_hyst attributes
      hwmon: (emc1403) Add support for min_hyst attributes
      hwmon: (emc1403) Add device IDs for EMC1412, EMC1413, and EMC1414
      hwmon: (jc42) Rearrange code to avoid forward declarations
      hwmon: (jc42) Convert function macros into functions
      hwmon: (jc42) Add support for STTS2004 and AT30TSE004
      hwmon: (max1619) Fix critical alarm display
      hwmon: (max1619) Drop FSF address
      hwmon: (max1619) Rearrange code to avoid forward declarations
      hwmon: (max1619) Drop function macros
      hwmon: (max1619) Convert to use devm_hwmon_device_register_with_groups
      hwmon: (lm83) Drop FSF address
      hwmon: (lm83) Rearange code to avoid forward declarations
      hwmon: (lm83) Convert to use devm_hwmon_device_register_with_groups
      hwmon: (lm80) Simplify TEMP_FROM_REG
      hwmon: (lm80) Normalize all temperature values to 16 bit
      hwmon: (lm80) Convert temperature display function macros into functions
      hwmon: (lm80) Convert voltage display function macros into functions
      hwmon: (lm80) Convert fan display function macros into functions
      hwmon: (lm80) Rearrange code to avoid forward declarations
      hwmon: Driver for NCT6683D

Himangi Saraogi (1):
      hwmon: (ultra45_env) Introduce managed version of kzalloc

Jingoo Han (11):
      hwmon: (f71805f) remove unnecessary OOM messages
      hwmon: (ibmpex) remove unnecessary OOM messages
      hwmon: (lm93) remove unnecessary OOM messages
      hwmon: (max1111) remove unnecessary OOM messages
      hwmon: (max197) remove unnecessary OOM messages
      hwmon: (pc87427) remove unnecessary OOM messages
      hwmon: (s3c-hwmon) remove unnecessary OOM messages
      hwmon: (vt1211) remove unnecessary OOM messages
      hwmon: (g762) Make of_device_id array const
      hwmon: (gpio-fan) Make of_device_id array const
      hwmon: (iio_hwmon) Make of_device_id array const

Josef Gajdusek (1):
      hwmon: (emc1403) Add support for emc14x2

LABBE Corentin (2):
      MAINTAINERS: Update Corentin Labbe's email
      hwmon: (adm1029) Update Corentin Labbe's email

 Documentation/hwmon/emc1403              |   59 ++
 Documentation/hwmon/hwmon-kernel-api.txt |  107 +++
 Documentation/hwmon/jc42                 |   16 +-
 Documentation/hwmon/lm77                 |   20 +-
 Documentation/hwmon/nct6683              |   57 ++
 MAINTAINERS                              |    2 +-
 drivers/hwmon/Kconfig                    |   10 +
 drivers/hwmon/Makefile                   |    1 +
 drivers/hwmon/adm1029.c                  |    4 +-
 drivers/hwmon/emc1403.c                  |  267 ++++--
 drivers/hwmon/f71805f.c                  |    4 +-
 drivers/hwmon/g762.c                     |    2 +-
 drivers/hwmon/gpio-fan.c                 |    2 +-
 drivers/hwmon/ibmpex.c                   |    4 +-
 drivers/hwmon/iio_hwmon.c                |    2 +-
 drivers/hwmon/jc42.c                     |  315 +++----
 drivers/hwmon/lm70.c                     |   62 +-
 drivers/hwmon/lm75.c                     |   51 +-
 drivers/hwmon/lm77.c                     |  374 +++-----
 drivers/hwmon/lm80.c                     |  640 +++++++------
 drivers/hwmon/lm83.c                     |  168 ++--
 drivers/hwmon/lm92.c                     |  224 ++---
 drivers/hwmon/lm93.c                     |    4 +-
 drivers/hwmon/ltc2945.c                  |    2 +-
 drivers/hwmon/max1111.c                  |    4 +-
 drivers/hwmon/max1619.c                  |  304 +++----
 drivers/hwmon/max197.c                   |    4 +-
 drivers/hwmon/nct6683.c                  | 1457 ++++++++++++++++++++++++++++++
 drivers/hwmon/nct6775.c                  |    8 +-
 drivers/hwmon/pc87427.c                  |    4 +-
 drivers/hwmon/s3c-hwmon.c                |    4 +-
 drivers/hwmon/tmp102.c                   |   62 +-
 drivers/hwmon/tmp421.c                   |   47 +-
 drivers/hwmon/ultra45_env.c              |    7 +-
 drivers/hwmon/vt1211.c                   |    4 +-
 35 files changed, 2885 insertions(+), 1417 deletions(-)
 create mode 100644 Documentation/hwmon/emc1403
 create mode 100644 Documentation/hwmon/hwmon-kernel-api.txt
 create mode 100644 Documentation/hwmon/nct6683
 create mode 100644 drivers/hwmon/nct6683.c

--RnlQjJ0d97Da+TV1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTjUixAAoJEMsfJm/On5mBl7QQAJz1Is/925/FfTPBukKt9SG9
GeQwgC/SUCDZEjtRtK3seKgfBy2mr8fBdsmnQ0hNAapyDxvoEKCSPJgB12gUKcfC
cyxhCfASezfe+Q/ymoEN7T4ugd3Sww2TXS5CEU4Cvs7h3FqLWfpCQAk7kSVJgZYT
IbLLXbQNxQxtk42DByaaCFdFxqB4R75DUDTDg0hadt/Lbrub/8oPAvuUS/Vxmksr
Y/GF0yYE05lWbGY3FAD9uMp8HqhT4UY8c8Z3XRZKF6tEG/FT0koUNg8vRUskNaCm
y5Sbp5vj8vcqY/9Zvk3peFC3KxPfWZ6ePfEx8SYkAtTxV/9dlnnvmJS25Z4AT5mh
T88qnkvQCC5997MX51YaCAyvRJNTcmHM1SBSXnByeown4S1epGQbI5Xd9M+ZB7jG
1DZkkD49Lw0C72iwQD4qBZp/XM5CPJuGRoSMaoscMI+K1QnBlGIPI3eCKdIzFOJE
IS45Crt4/MP1qA1lXtn3OHNbMuMLKhhXzi3T//9hpSJaLLmb9xrOzyoePt5Ccdh/
4W3bIMETgfCg3qfxnbcIeaV36NDIzWyA3k8rJ9SCYi76HzEBz4b1ChPsH2GamSbb
XG+WeNnpwxREaTcgOU9dvdMAQV7LxEgjwob0cVQkybGzpyxX4Bp76Ru/luwo2CwC
49qB9D8NYfLmymYdTAw6
=0SHc
-----END PGP SIGNATURE-----

--RnlQjJ0d97Da+TV1--
