Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756688Ab3BUVPS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 16:15:18 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:49217 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753998Ab3BUVMz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 16:12:55 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [GIT PULL 01/09] arm-soc: non-critical bug fixes
Date: Thu, 21 Feb 2013 21:12:21 +0000
Message-Id: <1361481149-27559-2-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1361481149-27559-1-git-send-email-arnd@arndb.de>
References: <1361481149-27559-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:NOaHG255L43bV1c8n7y/S/Tchdm7D49qvg8o3HRutYh
 H1oFHWBevBTRMeU/XeLyWI0uLjnnV/q7Cqbl2NucwlusVytp1J
 bcDjYUoqr0CbpQROknivBeebSeRs2OexWMnvGjyepAS8TAGY5S
 tsMWwQjPHtBnsZ+y1nrDJtKbUn5p5Ebd8PmNi6XOYoQu3AvwH8
 kxBaUnv+a84/obIWbE742X6g5W2lbgpLYS6YAQUaTcLUJX/8EQ
 IMadUwRuAdkFHeFKbzJm/MGRU4Ha7YXCxMZRYXCbQUIrAIzKGG
 KRkT3UWhZFfHFM5uv2cY58py2dbUUYqlWEW2EsGinNlAEiqQJ1
 jVPW269KmKN/YrA9MxBtG7NOPjbYZPogXwSxIRz3Q
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 88b62b915b0b7e25870eb0604ed9a92ba4bfc9f7:

  Linux 3.8-rc6 (2013-02-01 12:08:14 +1100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/fixes-non-critical

for you to fetch changes up to be8fd292f9b1ed787a04cb4437f7faef16c4afef:

  Merge tag 'arm-imx-clk-fixes' of git://git.pengutronix.de/git/imx/linux-2.6 into next/fixes-non-critical (2013-02-19 22:45:33 +0100)

----------------------------------------------------------------

arm-soc: non-critical bug fixes

Bug fixes that did not make it into v3.8, mostly because they were not
considered important enough, and in some cases because bugs only show
up in combination with other patches destined for 3.9.
This includes a few larger patches for GPIO on the Marvell PXA platform
and a lot of Samsung specific bug fixes, as well as a series from Arnd
to fix older build warnings.

----------------------------------------------------------------
Abhilash Kesavan (1):
      ARM: SAMSUNG: Gracefully exit on suspend failure

Alexander Shiyan (1):
      ARM: S3C24XX: Fix compile breakage for SMDK2410

Alexey Galakhov (1):
      ARM: S5PV210: Fix early uart output in fifo mode

Arnd Bergmann (17):
      mfd/vexpress: vexpress_sysreg_setup must not be __init
      ARM: msm: proc_comm_boot_wait should not be __init
      ARM: disable virt_to_bus/virt_to_bus almost everywhere
      ARM: samsung: fix assembly syntax for new gas
      ARM: w90x900: fix legacy assembly syntax
      ARM: shmobile: fix defconfig warning on CONFIG_USB
      ARM: sa1100: don't warn about mach/ide.h
      ARM: integrator/versatile: fix NOMMU warnings
      ARM: integrator: fix build with INTEGRATOR_AP off
      ARM: pick Versatile by default for !MMU
      ARM: mvebu: allow selecting mvebu without Armada XP
      ARM: s3c: i2c: add platform_device forward declaration
      scripts/sortextable: silence script output
      Merge branch 'warning-fixes' into next/fixes-non-critical
      ARM: imx: MACH_MX31ADS_WM1133_EV1 needs REGULATOR_WM8350
      Merge tag 'arm-imx-clk-fixes' of git://git.pengutronix.de/git/imx/linux-2.6 into next/fixes-non-critical

Chen Gang (3):
      ARM: SAMSUNG: using vsnprintf instead of vsprintf for the limit buffer length 256
      ARM: OMAP: Fix the use of uninitialized dma_lch_count
      ARM: OMAP2+: using strlcpy instead of strncpy

Cong Ding (1):
      ARM: S3C24XX: fix uninitialized variable warning

Douglas Gilbert (1):
      ARM: at91/at91sam9x5.dtsi: fix usart3 TXD

Frank Li (1):
      ARM: dts: imx6: fix fec ptp clock slow 10 time

Gerlando Falauto (1):
      arm: plat-orion: fix printing of "MPP config unavailable on this hardware"

Giridhar Maruthy (1):
      ARM: dts: fix tick and alarm irq numbers for exynos5440

Gregory CLEMENT (1):
      arm: mvebu: i2c come back in defconfig

Gwenhael Goavec-Merou (1):
      ARM: imx27: clk-imx27: SPI: Rename IPG clock and add PER clock

Heiko Stuebner (2):
      ARM: S3C24XX: let S3C2412_PM select S3C2412_PM_SLEEP
      ARM: S3C24XX: add missing platform_device.h include for osiris

Igor Grinberg (1):
      ARM: PXA3xx: program the CSMSADRCFG register

Jean-Francois Moine (1):
      Dove: activate GPIO interrupts in DT

Jon Hunter (1):
      ARM: OMAP2+: Fix selection of clockevent timer when using device-tree

Kukjin Kim (1):
      ARM: dts: fix compatible value for exynos pinctrl

Lee Jones (2):
      ARM: ux500: Disable Power Supply and Battery Management by default
      ARM: ux500: Fix u9540 booting issues

Mark Rutland (1):
      ARM: vexpress: Fix wdt interrupt in ca15{-tc1,_a7} dts

Marko Katic (1):
      ARM: pxa: Minor naming fixes in spitz.c

Michal Simek (1):
      MAINTAINERS: Add ARM/Zynq architecture entry

Mike Dunn (2):
      ARM: palmtreo: fix lcd initilialization on treo680
      ARM: palmtreo: fix #ifdefs for leds-gpio device

Nicolas Ferre (1):
      ARM: at91/DT: remove atmel,use-dma-* from 9x5 and 9n12 USART nodes

Olof Johansson (12):
      Merge branch 'armsoc/fix' of git://github.com/hzhuang1/linux into next/fixes-non-critical
      Merge tag 'ux500-fixes-for-v3.8' of http://git.kernel.org/.../linusw/linux-stericsson into fixes
      Merge branch 'v3.8-samsung-fixes-4' of git://git.kernel.org/.../kgene/linux-samsung into fixes
      Merge tag 'mvebu_fixes_for_v3.8-rc6' of git://git.infradead.org/users/jcooper/linux into fixes
      Merge tag 'vexpress/fixes-for-3.9' of git://git.linaro.org/people/pawelmoll/linux into next/fixes-non-critical
      Merge tag 'at91-fixes' of git://github.com/at91linux/linux-at91 into fixes
      Merge tag 'highbank-fixes-for-3.8' of git://sources.calxeda.com/kernel/linux into fixes
      Merge tag 'imx-fixes-3.8-4' of git://git.linaro.org/people/shawnguo/linux-2.6 into fixes
      Merge tag 'omap-for-v3.9/fixes-non-critical-signed-v2' of git://git.kernel.org/.../tmlind/linux-omap into next/fixes-non-critical
      Merge branch 'fixes-for-3.9' into next/fixes-non-critical
      Merge tag 'at91-fixes' of git://github.com/at91linux/linux-at91 into next/fixes-non-critical
      Merge branch 'next/fixes-samsung' of git://git.kernel.org/.../kgene/linux-samsung into next/fixes-non-critical

Robert Nelson (1):
      ARM: at91: at91sam9x5: fix usart3 pinctrl name

Sachin Kamat (3):
      ARM: S3C24XX: Make 'clk_msysclk' static
      ARM: SAMSUNG: Silence empty switch warning in sdhci.h
      ARM: SAMSUNG: Silence empty switch warning in fimc-core.h

Shirish S (1):
      ARM: dts: Correct pin configuration of SD 4 for exynos4x12-pinctrl

Steffen Trumtrar (1):
      ARM: i.MX25: clk: parent per5_clk to AHB clock

Steve Zhan (1):
      ARM: ux500: add spin_unlock(&master_lock).

Thomas Abraham (2):
      ARM: dts: Fix compatible value of pinctrl module on EXYNOS5440
      ARM: EXYNOS: Fix crash on soft reset on EXYNOS5440

Thomas Gleixner (1):
      ARM: OMAP: make wakeupgen_lock raw

Tony Prisk (1):
      arm: vt8500: Update MAINTAINERS entry for arch-vt8500

Viresh Kumar (1):
      ARM: SPEAr13xx: Enable CONFIG_ARCH_HAS_CPUFREQ

Will Deacon (1):
      ARM: integrator: ensure ap_syscon_base is initialised when !CONFIG_MMU

 .../bindings/pinctrl/samsung-pinctrl.txt           | 12 ++--
 MAINTAINERS                                        | 19 +++++-
 arch/arm/Kconfig                                   |  7 ++-
 arch/arm/arm-soc-for-next-contents.txt             | 10 +++-
 arch/arm/boot/dts/at91sam9n12.dtsi                 |  8 ---
 arch/arm/boot/dts/at91sam9x5.dtsi                  | 10 +---
 arch/arm/boot/dts/dove.dtsi                        |  2 +
 arch/arm/boot/dts/exynos4210.dtsi                  |  6 +-
 arch/arm/boot/dts/exynos4x12-pinctrl.dtsi          |  2 +-
 arch/arm/boot/dts/exynos4x12.dtsi                  |  8 +--
 arch/arm/boot/dts/exynos5440.dtsi                  |  4 +-
 arch/arm/boot/dts/imx6q.dtsi                       |  2 +-
 arch/arm/boot/dts/vexpress-v2p-ca15-tc1.dts        |  2 +-
 arch/arm/boot/dts/vexpress-v2p-ca15_a7.dts         |  2 +-
 arch/arm/configs/marzen_defconfig                  |  1 -
 arch/arm/configs/mvebu_defconfig                   |  2 +
 arch/arm/configs/shark_defconfig                   |  1 -
 arch/arm/configs/u8500_defconfig                   |  6 +-
 arch/arm/include/asm/dma.h                         |  2 +-
 arch/arm/include/asm/memory.h                      |  2 +
 arch/arm/mach-exynos/common.c                      | 10 ++--
 arch/arm/mach-exynos/pm.c                          |  6 +-
 arch/arm/mach-imx/Kconfig                          |  2 +-
 arch/arm/mach-imx/clk-imx25.c                      |  3 +
 arch/arm/mach-imx/clk-imx27.c                      |  9 ++-
 arch/arm/mach-integrator/common.h                  |  5 --
 arch/arm/mach-integrator/core.c                    |  2 +-
 arch/arm/mach-integrator/integrator_ap.c           |  4 +-
 arch/arm/mach-integrator/integrator_cp.c           |  2 +-
 arch/arm/mach-msm/proc_comm.h                      |  2 +-
 arch/arm/mach-mvebu/Makefile                       |  5 +-
 arch/arm/mach-omap2/omap-wakeupgen.c               | 14 ++---
 arch/arm/mach-omap2/timer.c                        |  2 +-
 arch/arm/mach-omap2/twl-common.c                   |  3 +-
 arch/arm/mach-pxa/include/mach/palmtreo.h          |  5 +-
 arch/arm/mach-pxa/include/mach/smemc.h             |  1 +
 arch/arm/mach-pxa/palmtreo.c                       | 70 ++++++++++++++++++----
 arch/arm/mach-pxa/smemc.c                          | 15 ++++-
 arch/arm/mach-pxa/spitz.c                          |  4 +-
 arch/arm/mach-s3c24xx/Kconfig                      |  2 +
 arch/arm/mach-s3c24xx/common-s3c2443.c             |  2 +-
 arch/arm/mach-s3c24xx/common.c                     |  2 +-
 arch/arm/mach-s3c24xx/include/mach/debug-macro.S   | 12 ++--
 arch/arm/mach-s3c24xx/include/mach/entry-macro.S   |  4 +-
 arch/arm/mach-s3c24xx/mach-osiris.c                |  1 +
 arch/arm/mach-s3c24xx/pm-h1940.S                   |  2 +-
 arch/arm/mach-s3c24xx/pm-s3c2412.c                 |  3 +-
 arch/arm/mach-s3c24xx/pm-s3c2416.c                 |  3 +-
 arch/arm/mach-s3c24xx/sleep-s3c2410.S              | 12 ++--
 arch/arm/mach-s3c24xx/sleep-s3c2412.S              | 12 ++--
 arch/arm/mach-s3c64xx/pm.c                         |  3 +-
 arch/arm/mach-s5p64x0/pm.c                         |  4 +-
 arch/arm/mach-s5pv210/include/mach/uncompress.h    |  2 +
 arch/arm/mach-s5pv210/pm.c                         |  4 +-
 arch/arm/mach-sa1100/lart.c                        |  3 -
 arch/arm/mach-ux500/cpu.c                          |  6 +-
 arch/arm/mach-ux500/cpuidle.c                      |  4 +-
 arch/arm/mach-versatile/Kconfig                    |  5 ++
 arch/arm/mach-versatile/core.c                     |  2 +-
 arch/arm/mach-w90x900/include/mach/entry-macro.S   |  4 +-
 arch/arm/plat-omap/dma.c                           |  2 +-
 arch/arm/plat-orion/mpp.c                          |  2 +-
 arch/arm/plat-samsung/include/plat/debug-macro.S   | 18 +++---
 arch/arm/plat-samsung/include/plat/fimc-core.h     |  2 +
 arch/arm/plat-samsung/include/plat/sdhci.h         |  2 +
 arch/arm/plat-samsung/pm.c                         |  7 ++-
 arch/arm/plat-spear/Kconfig                        |  1 +
 drivers/gpio/gpio-samsung.c                        |  6 +-
 drivers/mfd/vexpress-sysreg.c                      |  2 +-
 drivers/pinctrl/pinctrl-samsung.c                  |  4 +-
 include/linux/platform_data/i2c-s3c2410.h          |  2 +
 scripts/sortextable.h                              |  2 +-
 72 files changed, 261 insertions(+), 153 deletions(-)
