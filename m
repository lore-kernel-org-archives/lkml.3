Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753863AbaA0Oh1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 09:37:27 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:60185 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753380AbaA0Oh0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 09:37:26 -0500
Date: Mon, 27 Jan 2014 15:37:22 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-pwm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] pwm: Changes for v3.14-rc1
Message-ID: <20140127143721.GA9942@ulmo.nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pf9I7BMVVzbSWLtt"
Content-Disposition: inline
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--pf9I7BMVVzbSWLtt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

The following changes since commit 6ce4eac1f600b34f2f7f58f9cd8f0503d79e42ae:

  Linux 3.13-rc1 (2013-11-22 11:30:55 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/thierry.reding/linux-pwm.git tags/pwm/for-3.14-rc1

for you to fetch changes up to 6691a19966f04dd81e60505f9630c1a7cf148507:

  pwm: tiecap: Remove duplicate put_sync call (2014-01-23 15:19:18 +0100)

Thanks,
Thierry

----------------------------------------------------------------
pwm: Changes for v3.14-rc1

The patches for this release cycle include various enhancements (device
tree support, better compile coverage, ...) for existing drivers. There
is a new driver for Atmel SoCs.

Various drivers as well as the sysfs support received minor fixes and
cleanups.

----------------------------------------------------------------
Axel Lin (2):
      pwm: sysfs: Convert to use ATTRIBUTE_GROUPS macro
      pwm: pca9685: depends on I2C rather than REGMAP_I2C

Bo Shen (3):
      pwm: atmel-pwm: Add Atmel PWM controller driver
      of: Add Atmel PWM controller device tree binding
      pwm: atmel-pwm: Do not unprepare clock after successful registration

Fabio Estevam (1):
      backlight: pwm_bl: Remove error message upon devm_kzalloc() failure

Jingoo Han (4):
      pwm: use seq_puts() instead of seq_printf()
      pwm: ep93xx: split module author names
      pwm: pxa: remove unnecessary space before tabs
      pwm: tiehrpwm: use dev_err() instead of pr_err()

Lars-Peter Clausen (2):
      pwm: jz4740: Pass device to clk_get()
      pwm: jz4740: Use devm_clk_get()

Laurent Pinchart (1):
      pwm: renesas-tpu: Enable driver compilation with COMPILE_TEST

Mike Dunn (1):
      pwm: pxa: Add device tree support

Sourav Poddar (1):
      pwm: tiecap: Remove duplicate put_sync call

 .../devicetree/bindings/pwm/atmel-pwm.txt          |  33 ++
 Documentation/devicetree/bindings/pwm/pxa-pwm.txt  |  30 ++
 drivers/pwm/Kconfig                                |  14 +-
 drivers/pwm/Makefile                               |   1 +
 drivers/pwm/core.c                                 |   6 +-
 drivers/pwm/pwm-atmel.c                            | 395 +++++++++++++++++++++
 drivers/pwm/pwm-ep93xx.c                           |   4 +-
 drivers/pwm/pwm-jz4740.c                           |  20 +-
 drivers/pwm/pwm-pxa.c                              |  55 ++-
 drivers/pwm/pwm-tiecap.c                           |   1 -
 drivers/pwm/pwm-tiehrpwm.c                         |   4 +-
 drivers/pwm/sysfs.c                                |  12 +-
 drivers/video/backlight/pwm_bl.c                   |   1 -
 13 files changed, 537 insertions(+), 39 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/pwm/atmel-pwm.txt
 create mode 100644 Documentation/devicetree/bindings/pwm/pxa-pwm.txt
 create mode 100644 drivers/pwm/pwm-atmel.c

--pf9I7BMVVzbSWLtt
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS5m8hAAoJEN0jrNd/PrOhnygP/jWMdZU6EuuMRjgjL5iiHwhO
qglmweUAIGzCstFD2iMbhbDwMv74c5e3H/qqkhzKdO+WurGtXW8ZBlr/296lTBH6
V6uIILyA1XrIWrQW3EYI1A+wkeuOU/SD6RYXtTuGkG4g35YCogzW6ULaWf/c18/K
UlYkFHX3ciL1uBwO4EDT2it2aIO25CHzgl45H+MdzgUPocn3+Z8YZs6TI1jKSZ62
gFtHGURl7Ngm7uq/gAgWMD/ql3I17VwDbBf2yB7Joqyk03wOJ69/1AYWDN/ayroN
+ML/39hl6F17k2WqK2HOiIo8sxginuNrrkLRm2uBA4mZ0T9xNqwBHfk5j7FHGZ/J
SA/SucMXFfYWjFmztXuRnGOQ3mlADlGdbm7qmmcK3EmWcLTsNIhrw0KxZaGJl+uk
cAb0nfKvQP5bZT9UiWLfSuKNdkdkFqLX8cVUycjbKlpNz53m5WzTfj946p7y73MW
MYOzMgGu/efRILA6MBt3AactVA9B9eDJyfjb9bIenMMKbsBZmsRxTucPYVq9BXWb
v5Vo3cZZ/sT0IvAKz9G6XTZd8teNAguooyPssbCG6IBc0x42koFSkimraBfgdr3B
g5uMl+cdSdjfhQmV3kjjxMZTL6vQE0ah1ujPisalSWWRjEbBLaACruJLFlF5yQuT
fkzzwxxkLNpgphRWLi9Z
=Ch9l
-----END PGP SIGNATURE-----

--pf9I7BMVVzbSWLtt--
