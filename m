Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753490Ab3D2PDY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 11:03:24 -0400
Received: from nm14.access.bullet.mail.sp2.yahoo.com ([98.139.44.141]:26390
	"EHLO nm14.access.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751688Ab3D2PDU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 11:03:20 -0400
X-Yahoo-Newman-Id: 956483.40847.bm@smtp111.sbc.mail.gq1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 8mBo_n0VM1niHFpNTHdnUF2fDIPRIrmtoXnq7kA55gE_8VP
 5zCmeyGDwAghMubBzdWiHdv7zhcQ0AaHfKtpRjAIW4sSqPe6NC0qpVfjQM45
 1oBv7gn6njdG88jpLYjmGDgh3oNCGW4WZftnE6sxaSxDY1V8PLQa2p2lzWYf
 7VlBBKEHShe_l8wrpOrXmF69JUSbJd.8Qq3QECOEr22KAIDiyNs96mcTuvF0
 Xao4J.Vly9iCIAvC9aFBiIDW5938hxHm1jRlSKVjmkyNSslH.cmaynfJT.OB
 7Om3ps5Q3GPzhsaLwVvxtwSx2KurkE1crQ3XWJbVZhhpnUIa2xGmWDYaWbJK
 z4RdTbg5Q40CQT2tiPmTwGvNmpTRbJdToD.imG67sgNjHdc0lEjFbo9ZE62T
 E5MibG44UH2TSa9dc1SwL5B8RBjlBKo.sZHSJZhnmkssRT.vvUIFOF5NIbiE
 xKqnX19XXxC5IP5.zuvLVqOQuD7OEITTgdjNzhd9LOvuOZLtdAELGvWjOrix
 85n42AkpTGBj5lNhKYw_vxQweVurSD02B3d1fUb1fjDE6q7OBW7ivxXQEzgP
 U6vE5O35VR_e0_hfz_OUsJEG3n7S2kKritMcb
X-Yahoo-SMTP: zfeO.4KswBCc_PdwTE8HfYDCQ1aNmIcSvQHkDP4uSDBNBSXeKQ--
X-Rocket-Received: from localhost (linux@108.223.40.66 with plain)
        by smtp111.sbc.mail.gq1.yahoo.com with SMTP; 29 Apr 2013 14:57:26 +0000 UTC
Date: Mon, 29 Apr 2013 07:57:27 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: [GIT PULL] hwmon changes for 3.10
Message-ID: <20130429145727.GA7967@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6c2NcOVqGQ03X4Wi"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--6c2NcOVqGQ03X4Wi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

Please pull hwmon changes for Linux 3.10 from signed tag:

    git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.git hwmon-for-linus

Thanks,
Guenter
------

The following changes since commit 31880c37c11e28cb81c70757e38392b42e695dc6:

  Linux 3.9-rc6 (2013-04-07 20:49:54 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.git tags/hwmon-for-linus

for you to fetch changes up to 6445e6600fa632448cac64e71119310378464ad9:

  hwmon: (nct6775) Fix coding style problems (2013-04-21 09:42:52 -0700)

----------------------------------------------------------------
New drivers for NCT6775, NCT6776, NCT6779, and LM95234.
Added support for LTC2974, LTC3883, LM25056, TMP431, TMP432,
ADT7310, and ADT7320 to existing drivers.
Various code cleanups and minor improvements.

----------------------------------------------------------------
Guenter Roeck (47):
      hwmon: checkpatch cleanup: Replace printk with pr_debug or dev_dbg as appropriate
      hwmon: Fix 'Macros with complex values' checkpatch errors
      hwmon: Driver for Nuvoton NCT6775F, NCT6776F, and NCT6779D
      hwmon: (nct6775) Add case open detection
      hwmon: (nct6775) Add support for temperature sensors
      hwmon: (nct6775) Add support for fan speed attributes
      hwmon: (nct6775) Add support for fanX_pulses sysfs attribute
      hwmon: (nct6775) Add support for fan debounce module parameter
      hwmon: (nct6775) Add power management support
      hwmon: (nct6775) Add support for pwm, pwm_mode, and pwm_enable
      hwmon: (nct6775) Add support for automatic fan control
      hwmon: (nct6775) Add support for weighted fan control
      hwmon: (nct6775) Detect and report additional temperature sources
      hwmon: (nct6775) Only report VID if supported and enabled
      hwmon: (nct6775) Drop read/write lock
      hwmon: Fix CamelCase checkpatch warnings
      hwmon: Fix checkpatch warning 'quoted string split across lines'
      hwmon: (ina2xx) Fix 'Avoid unnecessary line continuations' checkpatch warning
      hwmon: (ltc4151) Fix 'Avoid unnecessary line continuations' checkpatch warning
      hwmon: (ltc4215) Fix 'Macros with complex values' checkpatch error
      hwmon: (ltc4245) Fix 'Macros with complex values' checkpatch error
      hwmon: (ltc4261) Fix 'Macros with complex values' checkpatch error
      hwmon: (pmbus/ltc2978) Code cleanup
      hwmon: (pmbus/ltc2978) Clean up documentation
      hwmon: (pmbus/ltc2978) Add support for LTC2974 and LTC3883
      hwmon: (adt7310) Fix sparse warning
      hwmon: (max6697) Use is_visible and sysfs_create_group
      hwmon: (pmbus/lm25066) Report VAUX as vmon
      hwmon: (pmbus/lm25066) Clamp limit attributes
      hwmon: (pmbus/lm25066) Refactor device specific coefficients
      hwmon: (pmbus/lm25066) Add support for LM25056
      hwmon: (tmp401) Add support for TMP431
      hwmon: Add driver for LM95234
      hwmon: (tmp401) Fix device detection for TMP411B and TMP411C
      hwmon: (gpio-fan) Use is_visible to determine if attributes should be created
      hwmon: (nct6775) Expand scope of supported chips
      MAINTAINERS: Add myself as maintainer for the NCT6775 driver
      hwmon: (nct6775) Enable both AUXTIN and VIN3 on NCT6776
      hwmon: (nct6775) Use ARRAY_SIZE for loops where possible
      hwmon: (tmp401) Drop unused defines, use BIT for bit masks
      hwmon: (tmp401) Use sysfs_create_group / sysfs_remove_group
      hwmon: (tmp401) Simplification and cleanup
      hwmon: (tmp401) Reset valid flag when resetting temperature history
      hwmon: (tmp401) Add support for update_interval attribute
      hwmon: (tmp401) Add support for TMP432
      hwmon: (nct6775) Constify strings
      hwmon: (nct6775) Fix coding style problems

Jingoo Han (2):
      hwmon: (mc13783-adc.c) use module_platform_driver_probe()
      hwmon: (ad7314) use spi_get_drvdata() and spi_set_drvdata()

Lars-Peter Clausen (3):
      hwmon: (adt7410) Don't re-read non-volatile registers
      hwmon: (adt7410) Add support for the adt7310/adt7320
      hwmon: (adt7x10) Add alarm interrupt support

Masanari Iida (1):
      documentation: hwmon: Fix typo in documentation/hwmon

Naveen Krishna Chatradhi (1):
      hwmon: (ntc_thermistor) Add DT with IIO support to NTC thermistor driver

 .../devicetree/bindings/hwmon/ntc_thermistor.txt   |   29 +
 Documentation/hwmon/adt7410                        |   47 +-
 Documentation/hwmon/lm25066                        |   34 +-
 Documentation/hwmon/lm95234                        |   36 +
 Documentation/hwmon/ltc2978                        |  143 +-
 Documentation/hwmon/nct6775                        |  188 +
 Documentation/hwmon/sht15                          |    2 +-
 Documentation/hwmon/tmp401                         |   25 +-
 Documentation/hwmon/zl6100                         |    2 +-
 MAINTAINERS                                        |    7 +
 drivers/hwmon/Kconfig                              |   48 +-
 drivers/hwmon/Makefile                             |    4 +
 drivers/hwmon/abituguru.c                          |   11 +-
 drivers/hwmon/abituguru3.c                         |   10 +-
 drivers/hwmon/ad7314.c                             |    7 +-
 drivers/hwmon/adm1021.c                            |   11 +-
 drivers/hwmon/adm1026.c                            |   53 +-
 drivers/hwmon/adm1029.c                            |    9 +-
 drivers/hwmon/adm9240.c                            |    9 +-
 drivers/hwmon/ads7871.c                            |   42 +-
 drivers/hwmon/adt7310.c                            |  123 +
 drivers/hwmon/adt7410.c                            |  442 +--
 drivers/hwmon/adt7411.c                            |   10 +-
 drivers/hwmon/adt7x10.c                            |  511 +++
 drivers/hwmon/adt7x10.h                            |   37 +
 drivers/hwmon/applesmc.c                           |    2 +-
 drivers/hwmon/asb100.c                             |   23 +-
 drivers/hwmon/asc7621.c                            |   56 +-
 drivers/hwmon/coretemp.c                           |    3 +-
 drivers/hwmon/da9052-hwmon.c                       |   14 +-
 drivers/hwmon/da9055-hwmon.c                       |    4 +-
 drivers/hwmon/dme1737.c                            |   68 +-
 drivers/hwmon/f71805f.c                            |    3 +-
 drivers/hwmon/fam15h_power.c                       |    4 +-
 drivers/hwmon/fschmd.c                             |    9 +-
 drivers/hwmon/gl518sm.c                            |    5 +-
 drivers/hwmon/gpio-fan.c                           |  106 +-
 drivers/hwmon/ibmaem.c                             |   21 +-
 drivers/hwmon/ibmpex.c                             |   17 +-
 drivers/hwmon/ina2xx.c                             |   16 +-
 drivers/hwmon/it87.c                               |   24 +-
 drivers/hwmon/k8temp.c                             |    4 +-
 drivers/hwmon/lm78.c                               |   10 +-
 drivers/hwmon/lm80.c                               |    5 +-
 drivers/hwmon/lm85.c                               |    4 +-
 drivers/hwmon/lm93.c                               |   74 +-
 drivers/hwmon/lm95234.c                            |  769 ++++
 drivers/hwmon/ltc4151.c                            |   12 +-
 drivers/hwmon/ltc4215.c                            |   46 +-
 drivers/hwmon/ltc4245.c                            |  116 +-
 drivers/hwmon/ltc4261.c                            |   38 +-
 drivers/hwmon/max6697.c                            |  209 +-
 drivers/hwmon/mc13783-adc.c                        |   13 +-
 drivers/hwmon/nct6775.c                            | 4191 ++++++++++++++++++++
 drivers/hwmon/ntc_thermistor.c                     |  353 +-
 drivers/hwmon/pc87360.c                            |   25 +-
 drivers/hwmon/pc87427.c                            |   13 +-
 drivers/hwmon/pmbus/Kconfig                        |    6 +-
 drivers/hwmon/pmbus/lm25066.c                      |  414 +-
 drivers/hwmon/pmbus/ltc2978.c                      |  170 +-
 drivers/hwmon/s3c-hwmon.c                          |   19 +-
 drivers/hwmon/sch56xx-common.c                     |   12 +-
 drivers/hwmon/sis5595.c                            |    5 +-
 drivers/hwmon/thmc50.c                             |    7 +-
 drivers/hwmon/tmp102.c                             |    4 +-
 drivers/hwmon/tmp401.c                             |  728 ++--
 drivers/hwmon/tmp421.c                             |    7 +-
 drivers/hwmon/via686a.c                            |   47 +-
 drivers/hwmon/vt1211.c                             |   23 +-
 drivers/hwmon/vt8231.c                             |    5 +-
 drivers/hwmon/w83627ehf.c                          |   31 +-
 drivers/hwmon/w83781d.c                            |   36 +-
 drivers/hwmon/w83791d.c                            |    4 +-
 drivers/hwmon/w83792d.c                            |   13 +-
 drivers/hwmon/w83793.c                             |    8 +-
 drivers/hwmon/w83795.c                             |    9 +-
 include/linux/platform_data/ntc_thermistor.h       |   10 +-
 77 files changed, 7862 insertions(+), 1793 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/hwmon/ntc_thermistor.txt
 create mode 100644 Documentation/hwmon/lm95234
 create mode 100644 Documentation/hwmon/nct6775
 create mode 100644 drivers/hwmon/adt7310.c
 create mode 100644 drivers/hwmon/adt7x10.c
 create mode 100644 drivers/hwmon/adt7x10.h
 create mode 100644 drivers/hwmon/lm95234.c
 create mode 100644 drivers/hwmon/nct6775.c

--6c2NcOVqGQ03X4Wi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJRfopXAAoJEMsfJm/On5mBNJMP/13UVePmRKEjoUA2aYaPEyv9
lFkAp69+LouxyVMV4dVU0kC8JfFtNn48549ADaue4hLfoLd6AHF4LJdOCPJViq1w
JHyRADQfuh7PwQl9R/zKhlIDf212ivDSeH8hZhgqfv8q860BwBKBMu5lMPnKfhBm
MV93O+GaKljPP+gGuqcOKhSB8QaVRYI0Mdem4CtWGrl11N0ZwwwNPVBVRWIWEYIg
sQH9FN2ahsfbMHE+ZYbJaDNP9RxJPenRKPBKL4ox2KihidQYK8V5aSMp8ToOLyHE
Po86AZvnbrHMjlTB93GkKAXeqM5iDYGTXsO7WhzTwNusXg7cq+Jst+N8/IthflWN
uYl4swYrqMomJgUtBJBbPPSUBd0GH5Jo9lknsc6BhXVvu1KyzMG/+ywxKywEJUyF
L80pbPkZbAm+ZbZUxIUlz6+0hLRBHFU+IXMpHkR3tgMVwIUeQj/91OvVXNz38KSt
itbd3q8Eb9RagfvJPSgeqMHV87J/mkIJC9o4NDt4rHQcqjp6qPnV1+6gRokx16uh
6pXdnOkjJ2wOlaxRB1L3Py8KzIBMyGtjyp4K2O5ebFMw1C6tQD07JnHrTYtwQyJ8
KLQTgFX1zg+zfilIl/IdF+lsnAPMnfd5wtwYN2FMMILGkYYJiYiVxsKW1GMirICv
Ah9fu/PwwoZLHPiJbW8t
=rOB7
-----END PGP SIGNATURE-----

--6c2NcOVqGQ03X4Wi--
