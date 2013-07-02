Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754419Ab3GBTSj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 15:18:39 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:54055 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752277Ab3GBTSh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 15:18:37 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL 1/7] ARM SoC non-cricitical bug fixes
Date: Tue, 2 Jul 2013 20:59:08 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arm@kernel.org
References: <201307022055.50717.arnd@arndb.de>
In-Reply-To: <201307022055.50717.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201307022059.09216.arnd@arndb.de>
X-Provags-ID: V02:K0:XsA/cFVS9a+tlVAE1S0PkIYpKHWFuHfZPC819OjIuMH
 YDT5LxnWMOWYM2DirvEj+aC3O0eOz3YshFtQEAf5mCfna106DC
 vKMZ7DDYDfKIqa+py5SszodsuAQuyi4QiMmCYuSoCxniuRRoBI
 2MccnF2oaaVuCda6OHx/GJ+P3C1u22Y3L02ij1WYe9NEs4Pg64
 wjW6BNByOpwON5Ddi3exZLaHM4IIUM6jH+/1rmFEyPAbV+8bSZ
 5NCH9pplhBhCjyFF0RbEhp7li6GRcZsed9R2aHntEn7/94B4r7
 +lq0nXX6n+oocCq2uFT18ZepMwFJRjHqhQfz/bxFzNTuIMZGAm
 2/a+d91N7BYZU1Gse4mU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 317ddd256b9c24b0d78fa8018f80f1e495481a10:

  Linux 3.10-rc5 (2013-06-08 17:41:04 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/fixes-non-critical-for-linus

for you to fetch changes up to 6b9a39de73490abb93a0b48a5e6c417c518f3a59:

  Merge tag 'at91-fixes' of git://github.com/at91linux/linux-at91 into next/fixes-non-critical (2013-06-27 15:03:13 +0200)

----------------------------------------------------------------

ARM SoC non-critical bug fixes

These are various bug fixes that were not considered important enough
for merging into 3.10. The majority of the ARM fixes are for the OMAP
and at91 platforms, and there is another set of bug fixes for device
drivers that resolve 'randconfig' build errors and that the subsystem
maintainers either did not pick up or preferred to get merged through
the arm-soc tree.

----------------------------------------------------------------
Alexandre Belloni (1):
      ARM: at91: Fix link breakage when !CONFIG_PHYLIB

Arnd Bergmann (12):
      hwrng: bcm2835: fix MODULE_LICENSE tag
      [SCSI] nsp32: use mdelay instead of large udelay constants
      mtd: omap2: allow bulding as a module
      X.509: do not emit any informational output
      clocksource: kona: adapt to CLOCKSOURCE_OF_DECLARE change
      ARM: sirf: use CONFIG_SIRF rather than CONFIG_PRIMA2 where necessary
      Merge tag 'at91-fixes' of git://github.com/at91linux/linux-at91 into next/fixes-non-critical
      Merge tag 'non-critical-fixes-1' of git://git.kernel.org/.../kgene/linux-samsung into next/fixes-non-critical
      cpuidle: calxeda: select ARM_CPU_SUSPEND
      ARM: mxs: stub out mxs_pm_init for !CONFIG_PM
      ARM: mxs: don't select HAVE_PWM
      Merge tag 'at91-fixes' of git://github.com/at91linux/linux-at91 into next/fixes-non-critical

Axel Lin (1):
      irqchip: renesas-irqc: Fix irqc_probe error handling

Barry Song (3):
      ARM: prima2: fix a checkpatch issue
      arm: prima2: use of_platform_populate instead of of_platform_bus_probe
      MAINTAINERS: ARM: SIRF: add the source code tree path

Bastian Hecht (1):
      irqchip: Add irqchip_init dummy function

Chen Gang (1):
      arch: arm: mach-msm: using strlcpy instead of strncpy

Daniel Lezcano (1):
      ARM: at91: cpuidle: Fix target_residency

Doug Anderson (1):
      MAINTAINERS: Add exynos filename match to ARM/S5P EXYNOS ARM ARCHITECTURES

Ezequiel Garcia (1):
      ARM: mvebu: fix length of ethernet registers in mv78260 dtsi

Hugo Villeneuve (1):
      ARM: davinci: remove stale SFFSDR maintainer name

Jean-Christophe PLAGNIOL-VILLARD (1):
      ARM: at91: fix at91_extern_irq usage for non-dt boards

Nicolas Ferre (4):
      ARM: at91/PMC: sama5d3 family doesn't have a PLLB
      ARM: at91/PMC: at91sam9n12 family has a PLLB
      ARM: at91/PMC: fix at91sam9n12 USB FS init
      ARM: at91/PMC: use at91_usb_rate() for UTMI PLL

Olof Johansson (7):
      Merge tag 'fixes-non-3.11-1' of git://git.infradead.org/users/jcooper/linux into next/fixes-non-critical
      Merge tag 'sirf-arm-soc-v3.10-fixes' of git://gitorious.org/sirfprima2-kernel/sirfprima2-kernel into next/fixes-non-critical
      Merge tag 'renesas-intc-external-irq-for-v3.11' of git://git.kernel.org/.../horms/renesas into next/fixes-non-critical
      Merge tag 'omap-for-v3.11/fixes-non-critical-signed' of git://git.kernel.org/.../tmlind/linux-omap into next/fixes-non-critical
      Merge tag 'davinci-for-v3.11/board' of git://git.kernel.org/.../nsekhar/linux-davinci into next/fixes-non-critical
      Merge tag 'msm-fix-for-3.11' of git://git.kernel.org/.../davidb/linux-msm into next/fixes-non-critical
      Merge tag 'fixes-non-3.11-2' of git://git.infradead.org/users/jcooper/linux into next/fixes-non-critical

Peter Ujfalusi (3):
      ARM: OMAP2+: devices: Do not print error when McPDM hwmod lookup fails
      ARM: OMAP2+: devices: Do not print error when DMIC hwmod lookup fails
      ARM: OMAP2+: devices: Do not print error when dss_hdmi hwmod lookup fails

Roger Quadros (1):
      ARM: OMAP2+: omap-usb-host: Fix memory leaks

Sebastian Andrzej Siewior (1):
      arm/omap: use const char properly

Stephen Boyd (3):
      ARM: dts: msm: Fix bad register addresses
      mfd: ssbi: Add MODULE_DEVICE_TABLE
      gpio: msm-v1: Remove errant __devinit to fix compile

Stephen Warren (1):
      ARM: tegra: fix section mismatch in tegra_pmc_parse_dt

Suman Anna (1):
      ARM: OMAP2+: control: add OMAP5 support for dsp boot programming

Syam Sidhardhan (1):
      ARM: prima2: Replace include linux/module.h with linux/export.h

Thomas Petazzoni (2):
      arm: mvebu: fix length of SATA registers area in .dtsi
      arm: mvebu: fix length of Ethernet registers area in .dtsi

Tomi Valkeinen (3):
      ARM: OMAP: fix dsi regulator names
      ARM: OMAP: add vdds_dsi supply for omapdss_dpi.0
      ARM: OMAP: add vdds_sdi supply for omapdss_sdi.0

Tony Lindgren (2):
      Merge branch 'dss-regulator' into omap-for-v3.11/fixes-non-critical
      ARM: OMAP2+: Fix serial init for device tree based booting

Wenyou Yang (1):
      ARM: at91: Change the internal SRAM memory type MT_MEMORY_NONCACHED

 MAINTAINERS                                  |   2 +
 arch/arm/Makefile                            |   2 +-
 arch/arm/boot/dts/armada-370-xp.dtsi         |   6 +-
 arch/arm/boot/dts/armada-xp-mv78260.dtsi     |   2 +-
 arch/arm/boot/dts/armada-xp-mv78460.dtsi     |   2 +-
 arch/arm/boot/dts/armada-xp.dtsi             |   2 +-
 arch/arm/boot/dts/msm8660-surf.dts           |   4 +-
 arch/arm/boot/dts/msm8960-cdp.dts            |   2 +-
 arch/arm/mach-at91/Kconfig                   |   1 +
 arch/arm/mach-at91/at91rm9200.c              |   8 +-
 arch/arm/mach-at91/at91sam9260.c             |   4 +-
 arch/arm/mach-at91/at91sam9261.c             |   4 +-
 arch/arm/mach-at91/at91sam9263.c             |   2 +-
 arch/arm/mach-at91/at91sam9g45.c             |   2 +-
 arch/arm/mach-at91/at91sam9rl.c              |   2 +-
 arch/arm/mach-at91/at91x40.c                 |   7 +-
 arch/arm/mach-at91/board-dt-sama5.c          |   3 +-
 arch/arm/mach-at91/clock.c                   |  30 ++++++--
 arch/arm/mach-at91/cpuidle.c                 |   2 +-
 arch/arm/mach-at91/generic.h                 |   2 +-
 arch/arm/mach-at91/include/mach/at91_pmc.h   |   3 +
 arch/arm/mach-at91/irq.c                     |   9 ++-
 arch/arm/mach-at91/pm.c                      |   2 +-
 arch/arm/mach-at91/setup.c                   |   4 +-
 arch/arm/mach-at91/soc.h                     |   1 +
 arch/arm/mach-davinci/board-sffsdr.c         |   1 -
 arch/arm/mach-msm/clock-debug.c              |   2 +-
 arch/arm/mach-mxs/Kconfig                    |   2 -
 arch/arm/mach-mxs/pm.h                       |   4 +
 arch/arm/mach-omap2/board-cm-t35.c           |   3 +-
 arch/arm/mach-omap2/board-devkit8000.c       |   1 +
 arch/arm/mach-omap2/board-ldp.c              |   3 +-
 arch/arm/mach-omap2/board-omap3pandora.c     |   1 +
 arch/arm/mach-omap2/board-rx51-peripherals.c |   1 +
 arch/arm/mach-omap2/control.c                |   1 +
 arch/arm/mach-omap2/devices.c                |  12 +--
 arch/arm/mach-omap2/id.c                     |   2 +-
 arch/arm/mach-omap2/serial.c                 |   3 +
 arch/arm/mach-omap2/twl-common.c             |   1 +
 arch/arm/mach-omap2/usb-host.c               | 106 ++++++++++++++-------------
 arch/arm/mach-prima2/common.c                |  17 +----
 arch/arm/mach-prima2/pm.c                    |   2 +-
 arch/arm/mach-tegra/pmc.c                    |   2 +-
 drivers/char/hw_random/bcm2835-rng.c         |   2 +-
 drivers/clk/Makefile                         |   2 +-
 drivers/clocksource/bcm_kona_timer.c         |  15 +---
 drivers/cpuidle/Kconfig                      |   1 +
 drivers/gpio/gpio-msm-v1.c                   |   2 +-
 drivers/i2c/busses/Kconfig                   |   2 +-
 drivers/irqchip/irq-renesas-irqc.c           |   4 +-
 drivers/mtd/nand/Kconfig                     |   2 +-
 drivers/scsi/nsp32.c                         |   2 +-
 drivers/spi/Kconfig                          |   2 +-
 drivers/ssbi/ssbi.c                          |   1 +
 drivers/tty/serial/Kconfig                   |   2 +-
 include/linux/irqchip.h                      |   4 +
 lib/build_OID_registry                       |   2 -
 57 files changed, 170 insertions(+), 145 deletions(-)
