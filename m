Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754067AbaATQnf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 11:43:35 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:57221 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751825AbaATQnc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 11:43:32 -0500
Date: Mon, 20 Jan 2014 16:43:26 +0000
From: Mark Brown <broonie@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lgirdwood@gmail.com>
Message-ID: <20140120164326.GU17314@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7oqf3GZ7P06zs6V6"
Content-Disposition: inline
X-Cookie: We have DIFFERENT amounts of HAIR --
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [GIT PULL] regulator updates for v3.14
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7oqf3GZ7P06zs6V6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit 7e22e91102c6b9df7c4ae2168910e19d2bb14cd6:

  Linux 3.13-rc8 (2014-01-12 17:04:18 +0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regulator.git tags/regulator-v3.14

for you to fetch changes up to 616f8a482a7cb3c39cb1ee0086b8a7ed6dcbb0c4:

  Merge remote-tracking branches 'regulator/topic/ab8500', 'regulator/topic/act8865', 'regulator/topic/anatop', 'regulator/topic/arizona', 'regulator/topic/as3722', 'regulator/topic/db8500', 'regulator/topic/gpio', 'regulator/topic/lp3971', 'regulator/topic/lp3972', 'regulator/topic/max14577', 'regulator/topic/max77693', 'regulator/topic/mc13892', 'regulator/topic/pcf50633', 'regulator/topic/pfuze100', 'regulator/topic/s2mps11', 'regulator/topic/s5m8767', 'regulator/topic/stw481x-vmmc', 'regulator/topic/tps51632', 'regulator/topic/tps62360', 'regulator/topic/tps65910', 'regulator/topic/twl' and 'regulator/topic/wm831x' into regulator-next (2014-01-15 11:48:46 +0000)

----------------------------------------------------------------

regulator: Updates for v3.14

A quiet release for the regulator API, quite a large number of small
improvements all over but other than the addition of new drivers for the
AS3722 and MAX14577 there is nothing of substantial non-local impact.

----------------------------------------------------------------
Andrew Bresticker (1):
      regulator: as3722: detect SD0 low-voltage mode

Axel Lin (10):
      regulator: lp3971: Convert to devm_regulator_register
      regulator: lp3972: Convert to devm_regulator_register
      mfd: pcf50633: Correct device name for pcf50633 regulator
      regulator: as3722: Don't set min_uV/uV_step/linear_min_sel for linear_ranges
      regulator: max14577: Add module alias to support module auto-loading
      regulator: max77693: Add missing .owner field in regulator_desc
      regulator: tps65910: Simplify setting enable_mask for regulators
      regulator: act8865: Remove unneeded regulator_unregister() calls
      regulator: act8865: Remove set_suspend_[en|dis]able implementation
      regulator: act8865: Fix build error when !OF

Charles Keepax (1):
      regulator: arizona-micsupp: Convert to use linear ranges

David Howells (1):
      regulator: tps62360: Fix up a pointer-integer size mismatch warning

Fabio Estevam (7):
      regulator: tps51632-regulator: Fix spelling
      regulator: pfuze100: Improve PFUZE100 entry text
      regulator: anatop-regulator: Add MODULE_ALIAS()
      regulator: wm831x-dcdc: Remove unneeded 'err' label
      regulator: anatop-regulator: Remove unneeded kstrdup()
      regulator: anatop-regulator: Remove unneeded memset()
      regulator: pfuze100-regulator: Fix some checkpatch complaints

Hans de Goede (1):
      regulator: core: don't print an error when no regulator is found

Jingoo Han (7):
      regulator: mc13892: Fix checkpatch issue
      regulator: stw481x-vmmc: use devm_regulator_register()
      regulator: ab8500: use devm_regulator_register()
      regulator: db8500-prcmu: use devm_regulator_register()
      regulator: pfuze100: use devm_regulator_register()
      regulator: core: Fix checkpatch issue
      regulator: twl: Fix checkpatch issue

Krzysztof Kozlowski (6):
      regulator: s5m8767: Define symbol for buck control mask
      regulator: s5m8767: Implement voltage setting for BUCK7/8 regulators
      regulator: s5m8767: Add symbols for hard-coded DVS_RAMP register
      regulator: s5m8767: Do not use sec_reg* regmap helpers
      mfd: sec: Remove sec_reg* regmap helpers
      regulator: max14577: Add regulator driver for Maxim 14577

Linus Walleij (1):
      regulator: ab8500: delete non-devicetree probe path

Mark Brown (7):
      regulator: gpio: Don't require a regulator-type property
      regulator: gpio: Warn if an invalid regulator-type is supplied
      Merge tag 's2mps11-build' into regulator-s5m8767 since a following patch     depend on it.
      Merge tag 'v3.13-rc4' into regulator-pfuze100
      Merge remote-tracking branch 'regulator/fix/s5m8767' into regulator-linus
      Merge remote-tracking branch 'regulator/topic/core' into regulator-next
      Merge remote-tracking branches 'regulator/topic/ab8500', 'regulator/topic/act8865', 'regulator/topic/anatop', 'regulator/topic/arizona', 'regulator/topic/as3722', 'regulator/topic/db8500', 'regulator/topic/gpio', 'regulator/topic/lp3971', 'regulator/topic/lp3972', 'regulator/topic/max14577', 'regulator/topic/max77693', 'regulator/topic/mc13892', 'regulator/topic/pcf50633', 'regulator/topic/pfuze100', 'regulator/topic/s2mps11', 'regulator/topic/s5m8767', 'regulator/topic/stw481x-vmmc', 'regulator/topic/tps51632', 'regulator/topic/tps62360', 'regulator/topic/tps65910', 'regulator/topic/twl' and 'regulator/topic/wm831x' into regulator-next

Markus Pargmann (1):
      regulator: tps65910: Add backup battery regulator

Mikko Perttunen (1):
      regulator: tps51632: Get regulator name from i2c_client

Sachin Kamat (2):
      regulator: s2mps11: Clean up redundant code
      regulator: s5m8767: Update LDO index in s5m8767-regulator.txt

Vince Hsu (1):
      regulator: as3722: set enable time for SD0/1/6

Wenyou Yang (4):
      regulator: act8865: add PMIC act8865 driver
      regulator: act8865: add device tree binding doc
      regulator: act8865: fix incorrect devm_kzalloc for act8865
      regulator: act8865: register all regulators regardless of how many are used

 Documentation/devicetree/bindings/mfd/tps65910.txt |   4 +-
 .../bindings/regulator/act8865-regulator.txt       |  60 ++++
 .../bindings/regulator/s5m8767-regulator.txt       |   2 +-
 .../devicetree/bindings/vendor-prefixes.txt        |   1 +
 drivers/mfd/pcf50633-core.c                        |   2 +-
 drivers/mfd/sec-core.c                             |  30 --
 drivers/regulator/Kconfig                          |  17 +-
 drivers/regulator/Makefile                         |   2 +
 drivers/regulator/ab8500.c                         | 126 +-------
 drivers/regulator/act8865-regulator.c              | 349 +++++++++++++++++++++
 drivers/regulator/anatop-regulator.c               |  36 +--
 drivers/regulator/arizona-micsupp.c                |  52 +--
 drivers/regulator/as3722-regulator.c               |  34 +-
 drivers/regulator/core.c                           |  15 +-
 drivers/regulator/db8500-prcmu.c                   |  20 +-
 drivers/regulator/gpio-regulator.c                 |  17 +-
 drivers/regulator/lp3971.c                         |  43 +--
 drivers/regulator/lp3972.c                         |  41 +--
 drivers/regulator/max14577.c                       | 273 ++++++++++++++++
 drivers/regulator/max77693.c                       |   1 +
 drivers/regulator/mc13892-regulator.c              |  24 +-
 drivers/regulator/pcf50633-regulator.c             |   2 +-
 drivers/regulator/pfuze100-regulator.c             |  39 +--
 drivers/regulator/s2mps11.c                        |   2 -
 drivers/regulator/s5m8767.c                        |  99 +++---
 drivers/regulator/stw481x-vmmc.c                   |  12 +-
 drivers/regulator/tps51632-regulator.c             |  30 +-
 drivers/regulator/tps62360-regulator.c             |   2 +-
 drivers/regulator/tps65910-regulator.c             |  40 +++
 drivers/regulator/twl-regulator.c                  |   4 +-
 drivers/regulator/wm831x-dcdc.c                    |  10 +-
 include/linux/mfd/as3722.h                         |   4 +
 include/linux/mfd/samsung/core.h                   |   6 -
 include/linux/mfd/samsung/s5m8767.h                |  18 +-
 include/linux/mfd/tps65910.h                       |   5 +-
 include/linux/regulator/act8865.h                  |  53 ++++
 36 files changed, 1016 insertions(+), 459 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/regulator/act8865-regulator.txt
 create mode 100644 drivers/regulator/act8865-regulator.c
 create mode 100644 drivers/regulator/max14577.c
 create mode 100644 include/linux/regulator/act8865.h

--7oqf3GZ7P06zs6V6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS3VIrAAoJELSic+t+oim9U3UP/A/KtaHc5yZ3OBQPtFMV1Du/
UoITsw3kYRs+xQ5WvDJPzCQGGj1PAzN3Mg31Jq5mHit1rC6ffe4vcfl9LWlDP8EJ
Qm1aqdBK+E7Alte77rA0pqZnwkEF1YX4AQDlp7E5Dj4idyaQrCv6ul2DaVxGnD4+
OSIcVXvBPBqVB4zKOYpKQ82Lh1k9p2bSZ7pSrmQs4CIBQ5KSzO5Hu1X8qOtn9RTC
S7VWuqdKiUmxn+Npy8LfY1UB+nfoGOqOItkD+fRPz+/L+Wg45rB229HgIMmvZgqY
BRZWtH2DwukaBAZRh/Eyrt/IMXixS817u06YIZ92YJ+FQk0lodG6ZQ6pFAkYRE4F
Iau9sjSOIrN/U6VBW5RhWtoRiT0gvHFvfzdUgaz3OGd0kZUnZqcuvai8TlK/u1kz
Wl3dkDMmQX35GO0GTVXOuLJz6Ibu1Jhv/No8K6G7vkJoIHpT5NVnKaV1v+dYUIfM
+ar5zhjr7IsV5AMpYwcjQtHWV4SbRPSdO6Byu/ztw191qbpO9wtKL4LqOFiwJ0Kr
pJ7BW44r9QfmKVgmdm1mlU5Ur2ZDBX8Iq0j3ux+eOlCE5dFRHllfCQT6Ks5rzso/
bEmQB7HpLhEL6iwWuQOqt3LVf7vLLL8u7yVQzSECYJzifd9OKbIXu5rZO61vAZea
A1w4vj/qxdiLmmCSwAkF
=sZOT
-----END PGP SIGNATURE-----

--7oqf3GZ7P06zs6V6--
