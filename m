Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756177Ab3IIWnD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 18:43:03 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:50379 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755807Ab3IIWmq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 18:42:46 -0400
From: Kevin Hilman <khilman@linaro.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL 3/3] ARM: SoC late changes for v3.12
Date: Mon,  9 Sep 2013 15:42:35 -0700
Message-Id: <1378766555-9679-4-git-send-email-khilman@linaro.org>
X-Mailer: git-send-email 1.8.3
In-Reply-To: <1378766555-9679-1-git-send-email-khilman@linaro.org>
References: <1378766555-9679-1-git-send-email-khilman@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These are changes that arrived a little late before the merge window,
or had dependencies on previous branches.

Highlights:
- ux500: misc. cleanup, fixup I2C devices
- exynos: DT updates for RTC; PM updates
- at91: DT updates for NAND; new platforms added to generic defconfig
- sunxi: DT updates: cubieboard2, pinctrl driver, gated clocks
- highbank: LPAE fixes, select necessary ARM errata
- omap: PM fixes and improvements; OMAP5 mailbox support
- omap: basic support for new DRA7xx SoCs

----------------------------------------------------------------

The following changes since commit 5d96cd70c979a7b93d8a4806c91a1af329833a64:

  Merge tag 'renesas-for-linus' into test-merge2

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/late-for-linus

for you to fetch changes up to a2bdc32a527e817fdfa6c56eaa6c70f217da6c6c:

  ARM: dts: vexpress: Add CCI node to TC2 device-tree

----------------------------------------------------------------

Aida Mynzhasova (1):
      ARM: OMAP: TI81XX: add always-on powerdomain for TI81XX

Ambresh K (7):
      ARM: OMAP: DRA7: PRM: Add DRA7XX register definitions
      ARM: OMAP: DRA7: CM: Add DRA7XX register defines
      ARM: OMAP: DRA7: PRCM: Add DRA7XX local MPU PRCM regsiters
      ARM: OMAP: DRA7: clockdomain: Add DRA7XX data and update header
      ARM: OMAP: DRA7: powerdomain: Add DRA7XX data and update header
      ARM: OMAP: DRA7: hwmod: Create initial DRA7XX SoC data
      ARM: OMAP: DRA7: Enable PM framework initializations

Amit Daniel Kachhap (2):
      ARM: EXYNOS: enable ARCH_HAS_BANDGAP
      ARM: EXYNOS: Skip C1 cpuidle state for exynos5440

Andre Przywara (2):
      DMA: fix AMBA PL08x compilation issue with 64bit DMA address type
      DMA: fix printk warning in AMBA PL08x DMA driver

Bartlomiej Zolnierkiewicz (1):
      ARM: EXYNOS: always enable PM domains support for EXYNOS4X12

Bo Shen (4):
      ARM: at91: sama5d3: add definition for usart base address
      ARM: at91: include sama5d3.h into hardware.h
      ARM: at91: sama5: enable kernel uncompress info output
      ARM: at91: sam9n12: enable kernel uncompress info output

Haojian Zhuang (4):
      irqchip: move mmp irq driver
      irqchip: mmp: support irqchip
      ARM: mmp: avoid to include head file in mach-mmp
      irqchip: mmp: avoid to include irqs head file

Jean-Christophe PLAGNIOL-VILLARD (1):
      ARM: at91: at91_dt_defconfig: enable rm9200 support

Jon Hunter (1):
      ARM: OMAP2+: Only write the sysconfig on idle when necessary

Jon Medhurst (Tixy) (1):
      ARM: dts: vexpress: Add CCI node to TC2 device-tree

Josh Wu (3):
      ARM: at91/dt: sama5d3xek: remove the useless NFC dt parameters
      ARM: at91/dt: sama5d3xek: Enable NFC support in dts
      ARM: at91/dt: sama5d3xek: reduce the ROM code mapping for pmecc lookup table

Julia Lawall (1):
      arch/arm/mach-ux500/cpu-db8500.c: Avoid using ARRAY_AND_SIZE(e) as a function argument

Linus Walleij (2):
      ARM: ux500: delete oldschool pin defines
      ARM: ux500: fix up the I2C devices

Lokesh Vutla (1):
      ARM: OMAP: AM33xx: clock: Add RNG clock data

Maxime Ripard (11):
      ARM: sunxi: dt: Add PIO controller to A31 DTSI
      ARM: sun6i: Add UART0 muxing options
      ARM: sun6i: colombus: Add uart0 muxing
      ARM: sun7i: Add the PIO controller node to the DTSI
      ARM: sun7i: DT: Add UART muxing options to the DTSI
      ARM: sun7i: a20-olinuxino: Enable UARTs muxing
      ARM: sun7i: a20-olinuxino: Enable the user LED
      ARM: sun7i: Add Cubieboard2 Device Tree
      ARM: sun5i: dt: Use the A10s gates in the DTSI
      ARM: sun6i: Enable clock support in the DTSI
      ARM: sun7i: Enable the A20 clocks in the DTSI

Naveen Krishna Chatradhi (1):
      ARM: dts: add ADC device tree node for exynos5420/5250

Olof Johansson (10):
      Merge tag 'ux500-core-for-arm-soc-2' of git://git.kernel.org/.../linusw/linux-stericsson into late/all
      Merge tag 'mmp-irq' of git://git.kernel.org/.../hzhuang1/linux into late/all
      Merge tag 'samsung-dt-2' of git://git.kernel.org/.../kgene/linux-samsung into late/all
      Merge tag 'samsung-mach-exynos-v2' of git://git.kernel.org/.../kgene/linux-samsung into late/all
      Merge tag 'at91-dt' of git://github.com/at91linux/linux-at91 into late/all
      Merge tag 'sunxi-dt-for-3.12-4' of https://github.com/mripard/linux into late/all
      Merge tag 'at91-soc' of git://github.com/at91linux/linux-at91 into late/all
      Merge tag 'highbank-for-3.12' of git://sources.calxeda.com/kernel/linux into late/all
      Merge tag 'omap-for-v3.12/prcm-signed' of git://git.kernel.org/.../tmlind/linux-omap into late/all
      Merge tag 'omap-for-v3.12/dra7xx-prcm' of git://git.kernel.org/.../tmlind/linux-omap into late/all

Paul Walmsley (1):
      Merge branches 'hwmod_devel_v3.12', 'prcm_devel_v3.12' and 'am33xx_devel_v3.12' into prcm_a_for_v3.12

Rajendra Nayak (4):
      ARM: OMAP: DRA7: CM: Add minimal regbit shifts
      ARM: OMAP: DRA7: powerdomain: Handle missing vc/vp
      ARM: OMAP: DRA7: Reuse the omap44xx_restart and fix the device instance
      ARM: OMAP4: clock: Lock PLLs in the right sequence

Rob Herring (8):
      ARM: use phys_addr_t for DMA zone sizes
      ARM: highbank: enable DMA zone for LPAE
      ARM: highbank: select ARCH_HAS_HOLES_MEMORYMODEL
      ARM: highbank: select required errata work-arounds
      ARM: highbank: select ARCH_DMA_ADDR_T_64BIT for LPAE
      ARM: move outer_cache declaration out of ifdef
      ARM: highbank: avoid L2 cache smc calls when PL310 is not present
      ARM: highbank: clean-up some unused includes

Suman Anna (1):
      ARM: OMAP5: hwmod data: Add mailbox data

Tony Lindgren (2):
      Merge tag 'for-v3.12/dra7xx' of git://git.kernel.org/.../pjw/omap-pending into omap-for-v3.12/soc
      Merge tag 'for-v3.12/omap-prcm-hwmod' of git://git.kernel.org/.../pjw/omap-pending into omap-for-v3.12/prcm

Vaibhav Hiremath (1):
      ARM: OMAP: AM33XX: hwmod: Add hwmod data for debugSS

Vikas Sajjan (3):
      ARM: dts: Fix the RTC DT node name for Exynos5250
      ARM: dts: Update the "status" property of RTC DT node for Exynos5250 SoC
      ARM: dts: Add RTC DT node to Exynos5420 SoC


 arch/arm/Kconfig                                |    1 +
 arch/arm/boot/dts/Makefile                      |    1 +
 arch/arm/boot/dts/exynos5.dtsi                  |    2 +-
 arch/arm/boot/dts/exynos5250-arndale.dts        |    4 -
 arch/arm/boot/dts/exynos5250-snow.dts           |    4 -
 arch/arm/boot/dts/exynos5250.dtsi               |   14 +-
 arch/arm/boot/dts/exynos5420.dtsi               |   17 +
 arch/arm/boot/dts/sama5d3.dtsi                  |   19 +-
 arch/arm/boot/dts/sama5d3xcm.dtsi               |    2 -
 arch/arm/boot/dts/sun5i-a10s.dtsi               |   36 +-
 arch/arm/boot/dts/sun6i-a31-colombus.dts        |    2 +
 arch/arm/boot/dts/sun6i-a31.dtsi                |  161 +-
 arch/arm/boot/dts/sun7i-a20-cubieboard2.dts     |   53 +
 arch/arm/boot/dts/sun7i-a20-olinuxino-micro.dts |   27 +
 arch/arm/boot/dts/sun7i-a20.dtsi                |  157 +-
 arch/arm/boot/dts/vexpress-v2p-ca15_a7.dts      |   25 +
 arch/arm/configs/at91_dt_defconfig              |    4 +-
 arch/arm/include/asm/mach/arch.h                |    2 +-
 arch/arm/include/asm/outercache.h               |    4 +-
 arch/arm/mach-at91/include/mach/hardware.h      |    1 +
 arch/arm/mach-at91/include/mach/sama5d3.h       |    8 +
 arch/arm/mach-at91/include/mach/uncompress.h    |   13 +
 arch/arm/mach-exynos/Kconfig                    |    7 +
 arch/arm/mach-exynos/cpuidle.c                  |    3 +
 arch/arm/mach-highbank/Kconfig                  |    6 +
 arch/arm/mach-highbank/highbank.c               |   20 +-
 arch/arm/mach-mmp/Makefile                      |    2 +-
 arch/arm/mach-mmp/common.h                      |    1 -
 arch/arm/mach-mmp/include/mach/entry-macro.S    |   26 -
 arch/arm/mach-mmp/include/mach/pxa168.h         |    1 +
 arch/arm/mach-mmp/include/mach/pxa910.h         |    1 +
 arch/arm/mach-mmp/mmp-dt.c                      |    8 +-
 arch/arm/mach-mmp/mmp2-dt.c                     |    8 +-
 arch/arm/mach-mmp/mmp2.c                        |    6 +
 arch/arm/mach-mmp/pxa910.c                      |    7 +
 arch/arm/mach-omap2/Makefile                    |    4 +
 arch/arm/mach-omap2/board-generic.c             |    1 +
 arch/arm/mach-omap2/cclock33xx_data.c           |    5 +
 arch/arm/mach-omap2/cclock44xx_data.c           |   20 +-
 arch/arm/mach-omap2/clockdomain.h               |    1 +
 arch/arm/mach-omap2/clockdomains7xx_data.c      |  740 +++++
 arch/arm/mach-omap2/cm-regbits-7xx.h            |   51 +
 arch/arm/mach-omap2/cm1_7xx.h                   |  324 +++
 arch/arm/mach-omap2/cm2_7xx.h                   |  513 ++++
 arch/arm/mach-omap2/io.c                        |    5 +
 arch/arm/mach-omap2/omap_hwmod.c                |    4 +-
 arch/arm/mach-omap2/omap_hwmod.h                |    1 +
 arch/arm/mach-omap2/omap_hwmod_33xx_data.c      |   69 +-
 arch/arm/mach-omap2/omap_hwmod_54xx_data.c      |   42 +
 arch/arm/mach-omap2/omap_hwmod_7xx_data.c       | 2724 ++++++++++++++++++
 arch/arm/mach-omap2/powerdomain.h               |    1 +
 arch/arm/mach-omap2/powerdomains3xxx_data.c     |    8 +
 arch/arm/mach-omap2/powerdomains7xx_data.c      |  454 +++
 arch/arm/mach-omap2/prcm-common.h               |    1 +
 arch/arm/mach-omap2/prcm44xx.h                  |    5 +
 arch/arm/mach-omap2/prcm_mpu7xx.h               |   78 +
 arch/arm/mach-omap2/prm44xx.c                   |   12 +-
 arch/arm/mach-omap2/prm7xx.h                    |  678 +++++
 arch/arm/mach-omap2/prminst44xx.c               |   20 +-
 arch/arm/mach-ux500/board-mop500-audio.c        |    1 -
 arch/arm/mach-ux500/board-mop500-pins.c         |    1 -
 arch/arm/mach-ux500/board-mop500.c              |   33 +-
 arch/arm/mach-ux500/cpu-db8500.c                |    3 +-
 arch/arm/mach-ux500/pins-db8500.h               |  746 -----
 arch/arm/mm/init.c                              |    2 +-
 drivers/dma/amba-pl08x.c                        |   23 +-
 drivers/irqchip/Makefile                        |    1 +
 .../mach-mmp/irq.c => drivers/irqchip/irq-mmp.c |  338 ++-
 include/linux/irqchip/mmp.h                     |    6 +
 69 files changed, 6486 insertions(+), 1082 deletions(-)
 create mode 100644 arch/arm/boot/dts/sun7i-a20-cubieboard2.dts
 delete mode 100644 arch/arm/mach-mmp/include/mach/entry-macro.S
 create mode 100644 arch/arm/mach-omap2/clockdomains7xx_data.c
 create mode 100644 arch/arm/mach-omap2/cm-regbits-7xx.h
 create mode 100644 arch/arm/mach-omap2/cm1_7xx.h
 create mode 100644 arch/arm/mach-omap2/cm2_7xx.h
 create mode 100644 arch/arm/mach-omap2/omap_hwmod_7xx_data.c
 create mode 100644 arch/arm/mach-omap2/powerdomains7xx_data.c
 create mode 100644 arch/arm/mach-omap2/prcm_mpu7xx.h
 create mode 100644 arch/arm/mach-omap2/prm7xx.h
 delete mode 100644 arch/arm/mach-ux500/pins-db8500.h
 rename arch/arm/mach-mmp/irq.c => drivers/irqchip/irq-mmp.c (63%)
 create mode 100644 include/linux/irqchip/mmp.h
