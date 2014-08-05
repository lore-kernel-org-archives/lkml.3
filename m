Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754083AbaHEXwK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 19:52:10 -0400
Received: from ring0.de ([5.45.105.125]:41765 "EHLO ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750823AbaHEXwH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 19:52:07 -0400
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
	* -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from author's
	*       domain
	*  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
	*      valid
	* -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
	* -0.0 NO_RECEIVED Informational: message has no Received headers
Date: Wed, 6 Aug 2014 01:51:58 +0200
From: Sebastian Reichel <sre@ring0.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Subject: [GIT PULL] power supply changes for 3.17
Message-ID: <20140805235158.GA4157@earth.universe>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="0F1p//8PRICkK4MW"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0F1p//8PRICkK4MW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit f83971912231fe5390d2357442b6c25bb8076d9b:

  Merge tag 'gfs2-fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/steve/gfs2-3.0-fixes (2014-07-18 06:26:04 -1000)

are available in the git repository at:

  git://git.infradead.org/battery-2.6.git tags/for-v3.17

for you to fetch changes up to 5e37195f30cc31e6a1052cbc282254e127c1b8c7:

  ipaq_micro_battery: fix sparse non static symbol warning (2014-07-28 15:36:29 +0200)

----------------------------------------------------------------
power supply changes for the v3.17 series

 - Added iPaq h3xxx battery driver
 - Added Broadcom STB reset driver
 - DT support for rx51-battery
 - misc. fixes

----------------------------------------------------------------
Bjorn Helgaas (1):
      power/reset: Fix GPL v2 license string typo

Dmitry Artamonow (1):
      power: add driver for battery reading on iPaq h3xxx

Doug Anderson (1):
      charger: tps65090: Allow charger module to be used when no irq

Himangi Saraogi (1):
      bq27x00_battery: Introduce the use of the managed version of kzalloc

Jenny TC (1):
      power_supply: Add inlmt,iterm, min/max temp props

Linus Walleij (1):
      power: poweroff: gpio: convert to use descriptors

Marc Carino (1):
      power: reset: Add reboot driver for brcmstb

Marek Belisko (1):
      bq27000: report missing device better.

Nishanth Menon (1):
      power: twl4030_charger: detect battery presence prior to enabling charger

Sebastian Reichel (3):
      bq2415x_charger: Fix Atomic Sleep Bug
      rx51_battery: convert to iio consumer
      Documentation: DT: Document rx51-battery binding

Wei Yongjun (2):
      power_supply: Fix sparse non static symbol warning
      ipaq_micro_battery: fix sparse non static symbol warning

 Documentation/devicetree/bindings/power/rx51-battery.txt |  25 ++++++++++
 Documentation/power/power_supply_class.txt               |   6 +++
 drivers/power/Kconfig                                    |   7 +++
 drivers/power/Makefile                                   |   1 +
 drivers/power/bq2415x_charger.c                          |   8 +++-
 drivers/power/bq27x00_battery.c                          |  28 ++++-------
 drivers/power/ipaq_micro_battery.c                       | 290 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/power/power_supply_core.c                        |   3 +-
 drivers/power/power_supply_sysfs.c                       |   4 ++
 drivers/power/reset/Kconfig                              |  11 +++++
 drivers/power/reset/Makefile                             |   1 +
 drivers/power/reset/brcmstb-reboot.c                     | 120 +++++++++++++++++++++++++++++++++++++++++++++++
 drivers/power/reset/gpio-poweroff.c                      |  52 ++++++++-------------
 drivers/power/reset/restart-poweroff.c                   |   2 +-
 drivers/power/rx51_battery.c                             |  90 ++++++++++++++++++++++++++----------
 drivers/power/tps65090-charger.c                         |  76 +++++++++++++++++++++++-------
 drivers/power/twl4030_charger.c                          |  44 +++++++++++++++++-
 include/linux/power_supply.h                             |   4 ++
 18 files changed, 673 insertions(+), 99 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/power/rx51-battery.txt
 create mode 100644 drivers/power/ipaq_micro_battery.c
 create mode 100644 drivers/power/reset/brcmstb-reboot.c

--0F1p//8PRICkK4MW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJT4W4eAAoJENju1/PIO/qakFsP/1c2gH6DZyiSff8Ym2w5PVrx
Stv4EIh8I+ps7z+XXftnckHbP50fcDmsFYvWXo/idt9W3/hrPfxRgl28so+igDUW
Q8N1R9diDpUVU4zbM3nON+BuvGA/rxyxmJ798sfyJ2PCM1r4+aRpj1kEPCeuCkBR
2Ox+v2Z6SirWPE2cm2oXt8XE10ihj1wh0Ul3wc73LzXgl/5yKejsK3wYhMQnuaRF
LNduJuSr1gtwMHcI8eMeWAbWxXNtWfAvcilX3ahcMQqyK8UZc3C9WasogrRkrZsa
JOeUij94+PzrrVbGjVZ9eBTDWKwSdWQK2+axhlaqiNtU7UVBw5Iz2BefDH4aZaXe
6SAqkoxBTehq3zN6hwTLOOQlYP3tKxP50h3JQbNIo93CFwtQLEi/LP7SM7+gccOF
MM4/ydcfFrXDChOzPGFN11bkidRZNeO9YSRlgW8hkJ3lBvPaIZ+goOVzq4ytWgCd
Byo8ZwIz8aRthk+MzbSQwRrYnlcZUaZk2JuJynf8SlPJqiDpU2mGirRXzB567HBr
0tB0WXTI7lYhAt7jLwsJTqMxSQlKrY/Pc0yldnZx0KQ0NvSAuPVCG6jG62N0/Ath
32pjFC+iH7jyn0Df0sf+KHjXc/j1oCgo2K9wYfplSILsc4tfvly2ffjEQB+hK8sl
iHqIpJpsNME6jiLLAMRU
=fyph
-----END PGP SIGNATURE-----

--0F1p//8PRICkK4MW--
