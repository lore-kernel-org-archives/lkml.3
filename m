Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753486AbaHECWO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 22:22:14 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:58422 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753290AbaHECWN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 22:22:13 -0400
Date: Mon, 4 Aug 2014 19:22:09 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: [GIT PULL] hwmon updates for 3.17
Message-ID: <20140805022209.GA13813@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cNdxnHkX5QqsyA0e"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--cNdxnHkX5QqsyA0e
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

Please pull hwmon updates for Linux 3.17 from signed tag:

    git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.git hwmon-for-linus

Thanks,
Guenter
------

The following changes since commit 64aa90f26c06e1cb2aacfb98a7d0eccfbd6c1a91:

  Linux 3.16-rc7 (2014-07-27 12:41:55 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.git tags/hwmon-for-linus

for you to fetch changes up to fce9626cd93abaf1ef21b361f8a0fa493cc855b2:

  hwmon: (g762) Use of_property_read_u32 at appropriate place (2014-08-04 11:35:40 -0700)

----------------------------------------------------------------
Notable changes:

Heiko Schocher provided a driver for TI TMP103.
Kamil Debski provided a driver for pwm-controlled fans.
Neelesh Gupta provided a driver for power, fan rpm, voltage and temperature
	reporting on powerpc/powernv systems.
Scott Kanowitz provided a driver supporting Lattice's POWR1220 power manager IC.
Richard Zhu provided a pmbus front-end driver for TPS40422.
Frans Klaver added support for TMP112 to the lm75 driver.
Johannes Pointner added support for EPCOS B57330V2103 to the ntc_thermistor
	driver.
Guenter Roeck added support for TMP441 and TMP442 to the tmp421 driver.
Axel Lin converted several drivers to the new hwmon API (36 of them, if I
	counted correctly), and cleaned up many of the drivers along the way.

There are also a number of patches fixing bugs discovered while testing
Axel's changes.

----------------------------------------------------------------
Aravind Gopalakrishnan (1):
      hwmon: (fam15h_power) Remove needless pci dev id

Axel Lin (72):
      hwmon: (ads1015) Fix off-by-one for valid channel index checking
      hwmon: (amc6821) Fix possible race condition bug
      hwmon: (lm77) Prevent overflow problem when writing large limits
      hwmon: (twl4030-madc-hwmon) Convert to devm_hwmon_device_register_with_groups
      hwmon: (gpio-fan) Convert to devm_hwmon_device_register_with_groups
      hwmon: (atxp1) Convert to devm_hwmon_device_register_with_groups
      hwmon: (ads7828) Convert to devm_hwmon_device_register_with_groups
      hwmon: (wm831x) Convert to devm_hwmon_device_register_with_groups
      hwmon: (wm8350) Convert to devm_hwmon_device_register_with_groups
      hwmon: (fam15h_power) Convert to devm_hwmon_device_register_with_groups
      hwmon: (w83l786ng) Avoid forward declaration
      hwmon: (w83l786ng) Convert to devm_hwmon_device_register_with_groups
      hwmon: (tmp103) Add missing i2c_set_clientdata call in tmp103_probe
      hwmon: (hih6130) Convert to devm_hwmon_device_register_with_groups
      hwmon: (ad7414) Convert to devm_hwmon_device_register_with_groups
      hwmon: (ad7418) Avoid forward declaration
      hwmon: (ad7418) Convert to devm_hwmon_device_register_with_groups
      hwmon: (adm1029) Avoid forward declarations
      hwmon: (adm1029) Convert to devm_hwmon_device_register_with_groups
      hwmon: (amc6821) Avoid forward declaration
      hwmon: (amc6821) Convert to devm_hwmon_device_register_with_groups
      hwmon: (emc6w201) Convert to devm_hwmon_device_register_with_groups
      hwmon: (htu21) Convert to devm_hwmon_device_register_with_groups
      hwmon: Make regmap configs const
      hwmon: (lm93) Convert to devm_hwmon_device_register_with_groups
      hwmon: (gl518sm) Avoid forward declaration
      hwmon: (gl518sm) Convert to devm_hwmon_device_register_with_groups
      hwmon: (gl520sm) Avoid forward declaration
      hwmon: (gl520sm) Convert to devm_hwmon_device_register_with_groups
      hwmon: (adm1021) Avoid forward declaration
      hwmon: (adm1025) Avoid forward declaration
      hwmon: (adm1025) Convert to devm_hwmon_device_register_with_groups
      hwmon: (adm1026) Avoid forward declaration
      hwmon: (adm1026) Convert to devm_hwmon_device_register_with_groups
      hwmon: (adm1031) Avoid forward declaration
      hwmon: (adm1031) Convert to devm_hwmon_device_register_with_groups
      hwmon: (adm9240) Avoid forward declaration
      hwmon: (smm665) Convert to devm_hwmon_device_register_with_groups
      hwmon: (lineage-pem) Convert to devm_hwmon_device_register_with_groups
      hwmon: (adm9240) Convert to devm_hwmon_device_register_with_groups
      hwmon: (g760a) Avoid forward declaration
      hwmon: (g760a) Convert to devm_hwmon_device_register_with_groups
      hwmon: (sht21) Convert to devm_hwmon_device_register_with_groups
      hwmon: (max16065) Use PTR_ERR_OR_ZERO
      hwmon: (ds620) Convert to devm_hwmon_device_register_with_groups
      hwmon: (asc7621) Make map tables const
      hwmon: (adt7462) Avoid forward declaration
      hwmon: (adt7462) Convert to devm_hwmon_device_register_with_groups
      hwmon: (adt7470) Avoid forward declaration
      hwmon: (adt7470) Convert to devm_hwmon_device_register_with_groups
      hwmon: (thmc50) Avoid forward declaration
      hwmon: (thmc50) Convert to devm_hwmon_device_register_with_groups
      hwmon: (max6639) Make normal_i2c array const
      hwmon: (max1668) Make max1668_addr_list array const
      hwmon: (smsc47m192) Avoid forward declaration
      hwmon: (smsc47m192) Convert to devm_hwmon_device_register_with_groups
      hwmon: (smsc47m1) Avoid forward declaration
      hwmon: (emc2103) Convert to devm_hwmon_device_register_with_groups
      hwmon: (g762) Convert to hwmon_device_register_with_groups
      hwmon: (adt7411) Convert to devm_hwmon_device_register_with_groups
      hwmon: (nct6775) Update module description and Kconfig for NCT6106D and NCT6791D
      hwmon: (nct6775) Remove num_attr_groups from struct nct6775_data
      hwmon: (pwm-fan) Remove duplicate dev_set_drvdata call
      hwmon: (pwm-fan) Make SENSORS_PWM_FAN depend on OF
      hwmon: (max6697) Use of_property_read_bool at appropriate places
      hwmon: (lm78) Convert to devm_hwmon_device_register_with_groups
      hwmon: (lm85) Avoid forward declaration
      hwmon: (lm85) Convert to devm_hwmon_device_register_with_groups
      hwmon: (ibmpowernv) Use of_property_read_u32 at appropriate place
      hwmon: (gpio-fan) Prevent overflow problem when writing large limits
      hwmon: (sis5595) Prevent overflow problem when writing large limits
      hwmon: (g762) Use of_property_read_u32 at appropriate place

Frans Klaver (1):
      hwmon: (lm75) Add support for TMP112

Guenter Roeck (7):
      hwmon: (lm85) Fix various errors on attribute writes
      hwmon: (lm78) Fix overflow problems seen when writing large temperature limits
      hwmon: (lm63) Fix smatch warnings
      hwmon: (w83791d) Fix smatch warning
      hwmon: (tmp421) Strengthen detect function
      hwmon: (tmp421) Add support for TMP441 and TMP442
      hwmon: (tmp421) Drop FSF mailing address

Heiko Schocher (1):
      hwmon: Driver for TI TMP103 temperature sensor

Johannes Pointner (2):
      devicetree: Add vendor prefix "epcos" to vendor-prefixes.txt
      hwmon: (ntc_thermistor) Support B57330V2103 from EPCOS

Kamil Debski (1):
      hwmon: Add pwm-fan driver

Neelesh Gupta (1):
      hwmon: (powerpc/powernv) hwmon driver for power, fan rpm, voltage and temperature

Scott Kanowitz (1):
      hwmon: Add support for Lattice's POWR1220 power manager IC

Zhu, Richard \(NSN - CN/Beijing\) (1):
      hwmon: (pmbus) Add tps40422 front-end driver

 .../devicetree/bindings/hwmon/ibmpowernv.txt       |  23 +
 .../devicetree/bindings/hwmon/ntc_thermistor.txt   |   1 +
 .../devicetree/bindings/hwmon/pwm-fan.txt          |  12 +
 .../devicetree/bindings/i2c/trivial-devices.txt    |   1 +
 .../devicetree/bindings/vendor-prefixes.txt        |   1 +
 Documentation/hwmon/ibmpowernv                     |  41 ++
 Documentation/hwmon/lm75                           |   5 +-
 Documentation/hwmon/ntc_thermistor                 |   5 +
 Documentation/hwmon/pmbus                          |   5 +-
 Documentation/hwmon/powr1220                       |  45 ++
 Documentation/hwmon/pwm-fan                        |  17 +
 Documentation/hwmon/tmp103                         |  28 +
 Documentation/hwmon/tmp421                         |  26 +-
 Documentation/hwmon/tps40422                       |  64 ++
 drivers/hwmon/Kconfig                              |  57 +-
 drivers/hwmon/Makefile                             |   4 +
 drivers/hwmon/ad7414.c                             |  57 +-
 drivers/hwmon/ad7418.c                             | 133 ++---
 drivers/hwmon/adm1021.c                            | 175 +++---
 drivers/hwmon/adm1025.c                            | 231 +++-----
 drivers/hwmon/adm1026.c                            | 588 +++++++++---------
 drivers/hwmon/adm1029.c                            | 208 +++----
 drivers/hwmon/adm1031.c                            | 349 +++++------
 drivers/hwmon/adm9240.c                            | 339 +++++------
 drivers/hwmon/ads1015.c                            |   2 +-
 drivers/hwmon/ads7828.c                            |  52 +-
 drivers/hwmon/adt7411.c                            |  59 +-
 drivers/hwmon/adt7462.c                            | 142 ++---
 drivers/hwmon/adt7470.c                            | 163 +++--
 drivers/hwmon/amc6821.c                            | 397 ++++++-------
 drivers/hwmon/asc7621.c                            |  14 +-
 drivers/hwmon/atxp1.c                              |  76 +--
 drivers/hwmon/ds620.c                              |  60 +-
 drivers/hwmon/emc1403.c                            |   2 +-
 drivers/hwmon/emc2103.c                            |  89 +--
 drivers/hwmon/emc6w201.c                           |  64 +-
 drivers/hwmon/fam15h_power.c                       |  54 +-
 drivers/hwmon/g760a.c                              |  84 +--
 drivers/hwmon/g762.c                               |  78 +--
 drivers/hwmon/gl518sm.c                            | 319 +++++-----
 drivers/hwmon/gl520sm.c                            | 353 +++++------
 drivers/hwmon/gpio-fan.c                           |  19 +-
 drivers/hwmon/hih6130.c                            |  88 +--
 drivers/hwmon/htu21.c                              |  69 +--
 drivers/hwmon/ibmpowernv.c                         | 363 ++++++++++++
 drivers/hwmon/lineage-pem.c                        |  66 +--
 drivers/hwmon/lm63.c                               |  27 +-
 drivers/hwmon/lm75.c                               |   8 +
 drivers/hwmon/lm77.c                               |  11 +-
 drivers/hwmon/lm78.c                               | 100 +---
 drivers/hwmon/lm85.c                               | 660 ++++++++++-----------
 drivers/hwmon/lm93.c                               | 154 +++--
 drivers/hwmon/ltc2945.c                            |   2 +-
 drivers/hwmon/ltc4222.c                            |   2 +-
 drivers/hwmon/ltc4260.c                            |   2 +-
 drivers/hwmon/max16065.c                           |   5 +-
 drivers/hwmon/max1668.c                            |   2 +-
 drivers/hwmon/max6639.c                            |   2 +-
 drivers/hwmon/max6697.c                            |  16 +-
 drivers/hwmon/nct6775.c                            |  14 +-
 drivers/hwmon/ntc_thermistor.c                     |  50 +-
 drivers/hwmon/pmbus/Kconfig                        |  13 +-
 drivers/hwmon/pmbus/Makefile                       |   1 +
 drivers/hwmon/pmbus/pmbus.c                        |   1 -
 drivers/hwmon/pmbus/tps40422.c                     |  64 ++
 drivers/hwmon/powr1220.c                           | 391 ++++++++++++
 drivers/hwmon/pwm-fan.c                            | 193 ++++++
 drivers/hwmon/sht21.c                              |  82 +--
 drivers/hwmon/sis5595.c                            |   2 +-
 drivers/hwmon/smm665.c                             |  44 +-
 drivers/hwmon/smsc47m1.c                           | 115 ++--
 drivers/hwmon/smsc47m192.c                         | 232 ++++----
 drivers/hwmon/thmc50.c                             | 212 +++----
 drivers/hwmon/tmp103.c                             | 206 +++++++
 drivers/hwmon/tmp421.c                             |  39 +-
 drivers/hwmon/twl4030-madc-hwmon.c                 |  38 +-
 drivers/hwmon/w83791d.c                            |  15 +-
 drivers/hwmon/w83l786ng.c                          | 289 ++++-----
 drivers/hwmon/wm831x-hwmon.c                       |  72 +--
 drivers/hwmon/wm8350-hwmon.c                       |  50 +-
 include/linux/platform_data/ntc_thermistor.h       |   1 +
 81 files changed, 4258 insertions(+), 3885 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/hwmon/ibmpowernv.txt
 create mode 100644 Documentation/devicetree/bindings/hwmon/pwm-fan.txt
 create mode 100644 Documentation/hwmon/ibmpowernv
 create mode 100644 Documentation/hwmon/powr1220
 create mode 100644 Documentation/hwmon/pwm-fan
 create mode 100644 Documentation/hwmon/tmp103
 create mode 100644 Documentation/hwmon/tps40422
 create mode 100644 drivers/hwmon/ibmpowernv.c
 create mode 100644 drivers/hwmon/pmbus/tps40422.c
 create mode 100644 drivers/hwmon/powr1220.c
 create mode 100644 drivers/hwmon/pwm-fan.c
 create mode 100644 drivers/hwmon/tmp103.c

--cNdxnHkX5QqsyA0e
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJT4D/RAAoJEMsfJm/On5mBvVkP/1/Rvzs13M5iqoTUluW5Cusu
DsVH5W9iP9zznJ2yRZBVkASU+DGDJsSAHgHHaTv4sJONO/kGoCeJdbL0IDYkySts
/a24HtC2+W7fqsLYz3KJELngcOrx0R9kqcrJ/PjHvrvIMJjx4EFSipzxHKhmAsUX
F9KBkrFWVNtAyZxNRl/pimBzTFgoNbO2jZlNdubnWAh94oCDIKn3UVLJv2mKdLPk
/JWQ12JzlSHRGQK+cJQhb68a40lTVXav53O4sGUiupF5gc0VxJg8dtkzgKXoOMfJ
aBrJNLOq1wMBz4JnpHlHZNCVXPN3ZiooJXBAYu+UBktcwtbAtoJ/VfOpq/wy/aYG
lki81Mg0N1A0+exuf3NPomxjkuz+96bmAJTDvfXux2lq9rfsm81QVXBhkfKib1zb
eXBkweKR7TuIjXspr+oGn0eCQkwX+vCmgGlNxClcFmIA2hP13rWIMDzhWV0gfhcT
yYfqa8P/nFbev+kw0RwY5kppj6KAT1pkLqO8vhV36huOPHzHBEAdf7LY/9O8Ho3S
hMme6RSVQ9Neg06qNH4yzUl2czWiUTYdoaOZQOTORwLvlsdb3zvuG77Xn4QN9Ri9
ZhgCRakmUW53wF5sqIwVlaZaKT9bESWdYWLNgK3rQWfedXGwcSxln7leokyUJZoS
0latkEx0STCfr+CDPnBH
=fiJE
-----END PGP SIGNATURE-----

--cNdxnHkX5QqsyA0e--
