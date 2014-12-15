Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751752AbaLOPdh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 10:33:37 -0500
Received: from mail.kernel.org ([198.145.19.201]:33735 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751122AbaLOPdf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 10:33:35 -0500
Date: Mon, 15 Dec 2014 16:33:27 +0100
From: Sebastian Reichel <sre@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Subject: [GIT PULL] power supply changes for 3.19
Message-ID: <20141215153326.GA23477@earth.universe>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="cWoXeonUoKmBZSoM"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--cWoXeonUoKmBZSoM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

The following changes since commit fc14f9c1272f62c3e8d01300f52467c0d9af50f9:

  Linux 3.18-rc5 (2014-11-16 16:36:20 -0800)

are available in the git repository at:

  git://git.infradead.org/battery-2.6.git tags/for-v3.19

for you to fetch changes up to b81180b3fd4814af0459a5b6aeb1ee188fea98dc:

  power: reset: adjust priority of simple syscon reboot driver (2014-12-03 20:38:30 +0100)

----------------------------------------------------------------
power supply and reset changes for the v3.19 series

* update power/reset drivers to use kernel restart handler
* add power off driver for i.mx6
* add DT support for gpio-charger

----------------------------------------------------------------
Fabio Estevam (1):
      power: ds2782_battery: Simplify the PM hooks

Guenter Roeck (10):
      power/reset: vexpress: Register with kernel restart handler
      power/reset: xgene: Return -ENOMEM if out of memory
      power/reset: xgene: Drop devm_kfree
      power/reset: xgene: Use local variable dev instead of pdev->dev
      power/reset: xgene: Use mdelay instead of jiffies based timeout
      power/reset: xgene: Register with kernel restart handler
      power/reset: axxia: Register with kernel restart handler
      power/reset: keystone: Register with kernel restart handler
      power/reset: hisi: Register with kernel restart handler
      power/reset: brcmstb: Register with kernel restart handler

Heiko Stuebner (2):
      dt-bindings: document gpio-charger bindings
      power: gpio-charger: add device tree support

Robin Gong (1):
      power: reset: imx-snvs-poweroff: add power off driver for i.mx6

Stefan Agner (1):
      power: reset: adjust priority of simple syscon reboot driver

 Documentation/devicetree/bindings/power_supply/gpio-charger.txt      | 27 +++++++++++++++++++++++++++
 Documentation/devicetree/bindings/power_supply/imx-snvs-poweroff.txt | 23 +++++++++++++++++++++++
 drivers/power/ds2782_battery.c                                       |  8 ++------
 drivers/power/gpio-charger.c                                         | 72 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
 drivers/power/reset/Kconfig                                          |  9 +++++++++
 drivers/power/reset/Makefile                                         |  1 +
 drivers/power/reset/axxia-reset.c                                    | 21 +++++++++++++++------
 drivers/power/reset/brcmstb-reboot.c                                 | 28 +++++++++++++++++++---------
 drivers/power/reset/hisi-reboot.c                                    | 20 ++++++++++++++++----
 drivers/power/reset/imx-snvs-poweroff.c                              | 66 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/power/reset/keystone-reset.c                                 | 20 +++++++++++++++-----
 drivers/power/reset/syscon-reboot.c                                  |  2 +-
 drivers/power/reset/vexpress-poweroff.c                              | 40 ++++++++++++++++++++++++++++++----------
 drivers/power/reset/xgene-reboot.c                                   | 56 ++++++++++++++++++++++++++++++--------------------------
 14 files changed, 324 insertions(+), 69 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/power_supply/gpio-charger.txt
 create mode 100644 Documentation/devicetree/bindings/power_supply/imx-snvs-poweroff.txt
 create mode 100644 drivers/power/reset/imx-snvs-poweroff.c

-- Sebastian

--cWoXeonUoKmBZSoM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJUjv9GAAoJENju1/PIO/qauccP/2Yc9j9h7RyAHiJPjucV9HqP
IRa/xHsK7Lftq+XGo+f4Qho7lkHfDfJ2Xz/dCdkPGbmNbYiq2p/b9KKY/BvZcP9/
sogp0bfJEHcTbF+JIl/K9Xj2orkscBWUJNOpQVgV5ZuHKzGJV+7yE/cNubbLViWk
jTbwBbndf7R3BAWTnIPcYm8rxm4lZKyDLlo3TgzYFUKOJUpgTYFHQUvPl4Bf8CfK
TnnVqT9srP6Oi8eC2F7mL31H/1MpTZi4kNUqgPDSuFtEGlESaxddLy7CfgEWK4DK
FfcXwyEv336POLR04F5FJSoQhClGNkVKc1mfuRgp3n6EAw0GhCkrgXir4F+nZOvl
2QcsGaG4BA7l8jSqLTrqRxAAlO+V6WYt+H5Gzi//DTzvqZN5kLSdcEy2STxPx30S
XF42BOK2KyjlOhFZqreCwNHJp5I9Bonkq71NAeOyYIcx6nZTglSCmdzIqyd5/H+X
rRxF4ANbgkWqSZa6GqmP3nFjMgArx0kAloN8/wFX32OvVKJy6JWYj2d5JYFEEQZ/
bjaWGwZV+PcX1gVHfWgA7L/snps4Iluy/phkwTZwn/SYsgCHUaAVanbKEMAv2Uv/
8rmYebf+AxLdXPJMjHE544e/WfXzFBK6UufmY+xCgGYcZeUqHXYa5HsS9pkAPvIm
RlsLF7ruBJ2DF0fNakTX
=1+3A
-----END PGP SIGNATURE-----

--cWoXeonUoKmBZSoM--
