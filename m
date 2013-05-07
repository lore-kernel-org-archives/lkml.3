Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758768Ab3EGQCT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 12:02:19 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:55340 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757063Ab3EGQCP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 12:02:15 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: torvalds@linux-foundation.org
Cc: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [GIT PULL] ARM: arm-soc device tree changes, part 2
Date: Tue,  7 May 2013 18:02:12 +0200
Message-Id: <1367942534-2934003-4-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1367942534-2934003-1-git-send-email-arnd@arndb.de>
References: <1367942534-2934003-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:rRh8BzaWppUHDZ5PiYs9KThQ+O2ezNbnPembJRXT+Bv
 629i+LlOdDKPDqTiLg8LCyzdlLcWDivCNept+KxLykbhjY5M89
 C0RppGgwqu+9rxkx2viCAVVimKVxKPxxxUyE0Yc4c+oPul7oci
 mfOC9ZdCbgRyWQOlaHyq4Fb8rhn80tbqH5ugkIUFHnUygxYSBE
 jDT+RfclsFHgn12+K8Vb6Naq0KBNYlz7R9nggN3aFelrrpZNnp
 Os+8h1JAeWU36BjhjuCbUQPM0XFbNL+aYY+JiDbv+ckORf7EQj
 g8LIUIlz3xo/Uw5//6UGA2sBUPJPrIkmSiqKxJv5liiXPMLNU1
 SaGPrJfdwErttTmXcpLJF2/i7BZfwbnDsIjjrUTh0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These are mostly new device tree bindings for existing drivers, as well
as changes to the device tree source files to add support for those
devices, and a couple of new boards, most notably Samsung's Exynos5
based Chromebook.

The changes depend on earlier platform specific updates and touch
the usual platforms: omap, exynos, tegra, mxs, mvebu and davinci.

Conflicts:
 Simple add/add conflicts in arch/arm/boot/dts/exynos5250.dtsi and
 arch/arm/mach-omap2/omap_hwmod.c. In the former, be careful to
 include the closing curly braces and semicolon.


-------------------------------------------------------------

The following changes since commit

   9822346 Merge tag 'soc-for-linus-3' into for-next

are available in the git repository at

   git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/dt-for-linus-2

you to fetch changes up to

   4183bef Merge branch 'late/dt' into next/dt2


-------------------------------------------------------------

Alexander Graf (2):
      ARM: dts: Declare the gic as a15 compatible for exynos5250
      ARM: dts: Add architected timer nodes for exynos5250

Alexandre Belloni (3):
      ARM: cfa10036: add one wire bitbanging to the cfa10049
      pinctrl: pinctrl-mxs: document the missing pull-ups
      ARM: dts: cfa10036: Add touchscreen support to the CFA-10049

Alexandre Pereira da Silva (1):
      ARM: dts: imx23-olinuxino: mark sdcard cd as broken

Amit Daniel Kachhap (2):
      ARM: dts: Add PMIC node entry for Arndale board
      ARM: dts: Add cpufreq controller node for Exynos5440 SoC

Andrew Chew (2):
      ARM: tegra: fix the status of PWM DT nodes
      ARM: tegra: add PWM nodes to Tegra114 DT

Anil Kumar (3):
      ARM: dts: Add minimal DT support for DevKit8000
      ARM: dts: omap3-devkit8000: Enable audio support
      ARM: dts: omap3-devkit8000: Add NAND DT node

AnilKumar Ch (3):
      ARM: dts: AM33XX: Rename I2C and GPIO nodes
      ARM: dts: AM33XX: Add d_can instances to aliases
      ARM: dts: AM33XX: Add memory resource to d_can node

Arnd Bergmann (6):
      Merge branch 'mxs/cleanup' into next/dt2
      Merge tag 'mxs-dt-3.10' of git://git.linaro.org/people/shawnguo/linux-2.6 into next/dt2
      Merge branch 'tegra/clk' into next/dt2
      Merge tag 'tegra-for-3.10-dt' of git://git.kernel.org/.../swarren/linux-tegra into next/dt2
      Merge branch 'late/dt' into next/dt2
      Merge tag 'dt-for-linus-2' into for-next

Benoit Cousson (1):
      Merge tag 'omap-devel-b-for-3.10' of git://git.kernel.org/.../pjw/omap-pending into for_3.10/dts_merged

Byungho An (1):
      ARM: dts: Add node for GMAC for exynos5440

Christoph Fritz (1):
      ARM/dts: OMAP3: fix pinctrl-single configuration

Doug Anderson (4):
      ARM: dts: add usb 2.0 clock references to exynos5250 device tree
      ARM: dts: Document usb clocks in samsung,exynos4210-ehci/ohci bindings
      ARM: dts: Add i2c-arbitrator bus for exynos5250-snow
      ARM: dts: Add sbs-battery for exynos5250-snow

Fabio Estevam (1):
      video: mxsfb: Introduce regulator support

Felipe Balbi (1):
      ARM: dts: OMAP5: Add SPI nodes

Florian Vaussard (3):
      ARM: dts: omap3-overo: Add support for pwm-leds
      ARM: dts: omap3-overo: Add audio support
      ARM: dts: OMAP3: Add GPMC controller

Giridhar Maruthy (1):
      ARM: dts: Add virtual GIC DT bindings for exynos5440

Gregory CLEMENT (3):
      ARM: dts: mvebu: Convert all the mvebu files to use the range property
      ARM: dts: mvebu: introduce internal-regs node
      ARM: dts: mvebu: Convert mvebu device tree files to 64 bits

Jason Cooper (2):
      Merge tag 'tags/mvebu_fixes_for_v3.9_round3' into mvebu/dt
      Merge tag 'tags/soc_for_v3.10' into mvebu/dt

Javier Martinez Canillas (5):
      ARM: dts: omap3: Add generic DT support for IGEP devices
      ARM: dts: omap3: Add support for IGEPv2 board
      ARM: dts: omap3: Add support for IGEP COM Module
      ARM: dts: OMAP3: reduce GPMC mapped registers address space
      Documentation: dt: gpio-omap: Move interrupt-controller from #interrupt-cells description

Jon Hunter (16):
      ARM: OMAP2+: Prepare for device-tree PMU support
      ARM: dts: OMAP2+: Add PMU nodes
      ARM: dts: OMAP2+: Add SDMA controller bindings and nodes
      ARM: dts: Add GPMC node for OMAP2, OMAP4 and OMAP5
      ARM: dts: Add OMAP2 gpio bindings
      ARM: dts: OMAP3+: Correct gpio #interrupts-cells property
      ARM: dts: OMAP3: Add reg and interrupt properties for gpio
      ARM: dts: OMAP3: Add support for OMAP3430 SDP board
      ARM: OMAP: Force dmtimer restore if context loss is not detectable
      ARM: OMAP: Add function to request timer by node
      ARM: dts: OMAP2+: Update DMTIMER compatibility property
      ARM: OMAP2+: Populate DMTIMER errata when using device-tree
      ARM: dts: OMAP2+: Identify GPIO banks that are always powered
      ARM: dts: Update OMAP3430 SDP NAND and ONENAND properties
      ARM: dts: Add NOR flash bindings for OMAP2420 H4
      ARM: dts: Add OMAP3430 SDP NOR flash memory binding

Joseph Lo (4):
      ARM: tegra: add power gpio keys to DT
      ARM: tegra: whistler: add wakeup source for KBC
      ARM: tegra: add non-removable and keep-power-in-suspend property for MMC
      ARM: dts: tegra: add the PM configurations of PMC

Kishon Vijay Abraham I (7):
      ARM: dts: OMAP4: Add omap control usb data
      ARM: dts: OMAP4: Add omap-usb2 data
      ARM: dts: OMAP: Add usb_otg and glue data to OMAP3+ boards
      ARM: dts: OMAP5: Add OMAP control usb data
      ARM: dts: OMAP5: Add ocp2scp data
      ARM: dts: OMAP5: Add omap-usb3 and omap-usb2 data
      ARM: dts: OMAP5: add dwc3 omap and dwc3 core data

Kukjin Kim (1):
      ARM: dts: add device tree file for SD5v1 board

Laxman Dewangan (9):
      ARM: tegra: add APB DMA nodes to Tegra114 DT
      ARM: tegra: add I2C nodes to Tegra114 DT
      ARM: tegra: add aliases and DMA requestor for serial nodes of Tegra114
      ARM: tegra: add KBC nodes to Tegra114 DT
      ARM: tegra: add SPI nodes to Tegra114 DT
      ARM: tegra: add DT binding for i2c-tegra
      ARM: tegra: dalmore: add cpu regulator node
      ARM: tegra: dalmore: add TPS65090 node
      ARM: tegra: dalmore: add fixed regulator node

Leela Krishna Amudala (2):
      ARM: dts: Add FIMD node to exynos5
      ARM: dts: Add display timing node to exynos5250-smdk5250.dts

Lokesh Vutla (1):
      ARM: dts: OMAP5: Add watchdog timer node

Manjunathappa, Prakash (4):
      spi/davinci: no wildcards in DT compatible property
      ARM: davinci: da850: add SPI1 DT node
      ARM: davinci: da850: override SPI DT node device name
      ARM: davinci: da850-evm: add SPI flash support

Matthias Brugger (1):
      ARM: dts: omap3-igep: Add uart1 and uart2 to igep boards

Murali Karicheri (1):
      spi/davinci: add DT binding documentation

NeilBrown (1):
      ARM: OMAP: Simplify dmtimer context-loss handling

Nishanth Menon (6):
      ARM: dts: OMAP34xx/35xx: Add CPU OPP table
      ARM: dts: OMAP36xx: Add CPU OPP table
      ARM: dts: OMAP3: use twl4030 vdd1 regulator for CPU
      ARM: dts: OMAP443x: Add CPU OPP table
      ARM: dts: omap4-panda: move generic sections to panda-common
      ARM: dts: OMAP4460: Add CPU OPP table

Olof Johansson (10):
      Merge branch 'omap/fixes-non-critical' into next/dt2
      Merge branch 'omap/usb' into next/dt2
      Merge tag 'omap-for-v3.10/dt-signed-v2' of git://git.kernel.org/.../tmlind/linux-omap into next/dt2
      Merge tag 'dt-exynos-for-v3.10' of git://git.kernel.org/.../kgene/linux-samsung into next/dt2
      Merge tag 'dt-3.10-4' of git://git.infradead.org/users/jcooper/linux into next/dt2
      Merge tag 'davinci-for-v3.10/dt-2-v2' of git://git.kernel.org/.../nsekhar/linux-davinci into next/dt2
      Merge branch 'samsung/pinctrl-exynos' into late/dt
      Merge branch 'exynos/dt' into late/dt
      ARM: exynos: dts: cros5250: add EC device
      Merge tag 'late-exynos-v3-for-v3.10' of git://git.kernel.org/.../kgene/linux-samsung into late/dt

Peter Ujfalusi (5):
      ARM: dts: twl4030: Add PWM support
      ARM: dts: twl6030: Add PWM support
      ARM: dts: omap3-beagle-xm: Use pwm-leds for pmu_stat LED
      ARM: dts: omap4-sdp: Add support for pwm-leds (keypad and charging LED)
      ARM: dts: omap4-sdp: Add support for pwm-backlight

Philip Avinash (2):
      ARM: dts: AM33XX: Corrects typo in interrupt field in SPI node
      ARM: davinci: da850: add EHRPWM & ECAP DT node

Prashant Gaikwad (1):
      clk: tegra: Fix cdev1 and cdev2 IDs

Pritesh Raithatha (2):
      ARM: tegra: add default pinctrl nodes for Dalmore
      ARM: tegra: add SDHCI nodes with common properties

Rajendra Nayak (1):
      ARM: dts: OMAP5: Specify nonsecure PPI IRQ for arch timer

Rhyland Klein (2):
      ARM: tegra: add SDHCI support for Dalmore
      ARM: tegra: Add sbs-battery node to Dalmore

Sachin Kamat (11):
      ARM: dts: Add G2D node to exynos4210.dtsi
      ARM: dts: Add G2D node to SMDKV310
      ARM: dts: Add G2D node to exynos4210-origen
      ARM: dts: Add G2D node to exynos4x12.dtsi
      ARM: dts: Add G2D node to SMDK4412
      ARM: dts: Add G2D node to exynos4412-origen
      ARM: dts: Add Samsung G2D DT bindings documentation
      ARM: dts: Add disable-wp for card slot on exynos5250-arndale
      ARM: dts: Add vmmc regulator support for Arndale board
      ARM: dts: Add MFC codec support for Arndale board
      ARM: dts: Add HDMI HPD and regulator node for Arndale board

Santosh Shilimkar (9):
      ARM: dts: omap5-evm: Update available memory to 2032 MB
      ARM: dts: OMAP5: Align the local timer dt node as per the current binding code
      ARM: dts: OMAP5: Move the gic node out of ocp space
      ARM: dts: OMAP5: Update the timer and GIC nodes for HYP kernel support
      ARM: dts: OMAP5: Update keypad reg property
      Documentation: dt: OMAP: l3-noc: Add *reg* in required properties
      ARM: dts: OMAP4/5: Update l3-noc DT nodes
      ARM: OMAP2+: hwmod: extract module address space from DT blob
      ARM: OMAP2+: hwmod: Don't call _init_mpu_rt_base if no sysc

Sebastien Guiriec (1):
      ARM: dts: OMAP2+: Add SDMA Audio IPs bindings

Shawn Guo (16):
      net: fec: handle optional clk_ptp more gracefully
      ARM: mxs: remove unneeded enet_out clk initialization
      video: mxsfb: use devm_* managed functions
      video: mxsfb: remove fb_phys/fb_size from platform_data
      video: mxsfb: remove dotclk_delay from platform_data
      video: mxsfb: get display timings from device tree
      ARM: mxs: move display timing configurations into device tree
      video: mxsfb: remove mxsfb_platform_data
      ARM: dts: add generic DMA device tree binding for mxs-dma
      dma: mxs-dma: use devm_* managed functions
      dma: mxs-dma: move to generic device tree binding
      mmc: mxs-mmc: move to use generic DMA helper
      spi: mxs-spi: move to use generic DMA helper
      i2c: i2c-mxs: move to use generic DMA helper
      mtd: gpmi: move to use generic DMA helper
      serial: mxs-auart: move to use generic DMA helper

Sourav Poddar (4):
      ARM: dts: omap4-sdp: Add I2c pinctrl data
      ARM: dts: omap5-evm: Add I2c pinctrl data
      ARM: dts: omap4-panda: Add I2c pinctrl data
      ARM: dts: omap5-evm: Add mcspi data

Stephen Warren (5):
      ARM: tegra: device tree whitespace cleanup
      ARM: tegra: fix sort order of USB PHY nodes
      ARM: tegra: add clocks property to sound nodes
      ARM: tegra: add clocks property to AC'97 sound nodes
      ARM: tegra: keep power on to SD slot on Dalmore

Subash Patel (3):
      ARM: dts: add PMU support in exynos5440
      ARM: dts: update bootargs to boot from sda2 for exynos5440-ssdk5440
      ARM: dts: add PDMA0 changes for exynos5440

Sylwester Nawrocki (1):
      ARM: dts: Add SYSREG block node for S5P/Exynos4 SoC series

Thomas Abraham (7):
      ARM: dts: add pin state information in client nodes for Exynos4 platforms
      ARM: dts: add pin state information in client nodes for Exynos5 platforms
      ARM: dts: list the interrupts generated by pin-controller on Exynos5440
      ARM: dts: Fix gmac clock ids due to changes in Exynos5440
      ARM: EXYNOS: Create virtual I/O mapping for Chip-ID controller using device tree
      ARM: dts: Add chip-id controller node on Exynos4/5 SoC
      ARM: dts: add mshc controller node for Exynos4x12 SoCs

Thomas Petazzoni (2):
      ARM: dts: mvebu: fix cpus section indentation
      ARM: dts: mvebu: move all peripherals inside soc

Tony Lindgren (1):
      Merge branch 'for_3.10/dts' of git://git.kernel.org/.../bcousson/linux-omap-dt into omap-for-v3.10/dt

Tushar Behera (2):
      ARM: dts: Add pin-control related changes for Arndale board
      ARM: dts: Add gpio-button entries for Arndale board

Vikas Sajjan (3):
      ARM: dts: Add FIMD node to exynos4
      ARM: dts: Add FIMD node and display timing node to exynos4412-origen.dts
      ARM: dts: Add FIMD DT binding Documentation

Wolfram Sang (2):
      net: freescale: fec: add support for optional enet_out clk
      ARM: dts: mxs: add enet_out clock to devicetree

 .../devicetree/bindings/arm/omap/l3-noc.txt        |   1 +
 .../devicetree/bindings/arm/omap/timer.txt         |  17 +-
 .../devicetree/bindings/arm/samsung/sysreg.txt     |   7 +
 .../devicetree/bindings/dma/fsl-mxs-dma.txt        |  49 +-
 Documentation/devicetree/bindings/fb/mxsfb.txt     |  36 +-
 .../devicetree/bindings/gpio/gpio-omap.txt         |   8 +-
 .../devicetree/bindings/gpu/samsung-g2d.txt        |  20 +
 Documentation/devicetree/bindings/i2c/i2c-mxs.txt  |  12 +-
 .../devicetree/bindings/i2c/nvidia,tegra20-i2c.txt |  60 ++
 Documentation/devicetree/bindings/mmc/mxs-mmc.txt  |  12 +-
 .../devicetree/bindings/mtd/gpmi-nand.txt          |  17 +-
 .../bindings/pinctrl/fsl,mxs-pinctrl.txt           |   4 +
 .../bindings/sound/nvidia,tegra-audio-alc5632.txt  |   8 +
 .../sound/nvidia,tegra-audio-trimslice.txt         |   7 +
 .../bindings/sound/nvidia,tegra-audio-wm8753.txt   |   8 +
 .../bindings/sound/nvidia,tegra-audio-wm8903.txt   |   8 +
 .../bindings/sound/nvidia,tegra-audio-wm9712.txt   |   8 +
 Documentation/devicetree/bindings/spi/mxs-spi.txt  |  12 +-
 .../devicetree/bindings/spi/spi-davinci.txt        |  51 ++
 .../bindings/tty/serial/fsl-mxs-auart.txt          |  16 +-
 .../devicetree/bindings/usb/exynos-usb.txt         |  10 +
 Documentation/devicetree/bindings/usb/omap-usb.txt |   1 +
 .../devicetree/bindings/video/samsung-fimd.txt     |  65 ++
 arch/arm/boot/dts/Makefile                         |   5 +
 arch/arm/boot/dts/am335x-bone.dts                  |  10 +-
 arch/arm/boot/dts/am335x-evm.dts                   |  18 +-
 arch/arm/boot/dts/am335x-evmsk.dts                 |  18 +-
 arch/arm/boot/dts/am33xx.dtsi                      |  40 +-
 arch/arm/boot/dts/am3517-evm.dts                   |   2 +-
 arch/arm/boot/dts/am3517_mt_ventoux.dts            |   2 +-
 arch/arm/boot/dts/armada-370-db.dts                | 134 ++--
 arch/arm/boot/dts/armada-370-mirabox.dts           | 176 ++--
 arch/arm/boot/dts/armada-370-rd.dts                |  96 +--
 arch/arm/boot/dts/armada-370-xp.dtsi               | 336 ++++----
 arch/arm/boot/dts/armada-370.dtsi                  | 330 ++++----
 arch/arm/boot/dts/armada-xp-db.dts                 | 202 ++---
 arch/arm/boot/dts/armada-xp-gp.dts                 | 222 ++---
 arch/arm/boot/dts/armada-xp-mv78230.dtsi           | 284 +++----
 arch/arm/boot/dts/armada-xp-mv78260.dtsi           | 342 ++++----
 arch/arm/boot/dts/armada-xp-mv78460.dtsi           | 484 +++++------
 arch/arm/boot/dts/armada-xp-openblocks-ax3-4.dts   | 262 +++---
 arch/arm/boot/dts/armada-xp.dtsi                   | 202 ++---
 arch/arm/boot/dts/cros5250-common.dtsi             |  54 +-
 arch/arm/boot/dts/da850-evm.dts                    |  40 +
 arch/arm/boot/dts/da850.dtsi                       |  94 +++
 arch/arm/boot/dts/exynos4.dtsi                     |  32 +
 arch/arm/boot/dts/exynos4210-origen.dts            |   4 +
 arch/arm/boot/dts/exynos4210-smdkv310.dts          |  57 +-
 arch/arm/boot/dts/exynos4210.dtsi                  |   7 +
 arch/arm/boot/dts/exynos4412-origen.dts            |  21 +
 arch/arm/boot/dts/exynos4412-smdk4412.dts          |   8 +
 arch/arm/boot/dts/exynos4412.dtsi                  |   8 +
 arch/arm/boot/dts/exynos4x12.dtsi                  |   7 +
 arch/arm/boot/dts/exynos5250-arndale.dts           | 343 +++++++-
 arch/arm/boot/dts/exynos5250-pinctrl.dtsi          | 783 ++++++++++++++++++
 arch/arm/boot/dts/exynos5250-smdk5250.dts          |  49 +-
 arch/arm/boot/dts/exynos5250-snow.dts              | 149 +++-
 arch/arm/boot/dts/exynos5250.dtsi                  | 348 +++-----
 arch/arm/boot/dts/exynos5440-sd5v1.dts             |  39 +
 arch/arm/boot/dts/exynos5440-ssdk5440.dts          |   6 +-
 arch/arm/boot/dts/exynos5440.dtsi                  |  55 +-
 arch/arm/boot/dts/imx23-evk.dts                    |  36 +-
 arch/arm/boot/dts/imx23-olinuxino.dts              |   1 +
 arch/arm/boot/dts/imx23.dtsi                       |  42 +-
 arch/arm/boot/dts/imx28-apf28dev.dts               |  25 +
 arch/arm/boot/dts/imx28-apx4devkit.dts             |  25 +
 arch/arm/boot/dts/imx28-cfa10049.dts               |  50 +-
 arch/arm/boot/dts/imx28-evk.dts                    |  36 +-
 arch/arm/boot/dts/imx28-m28evk.dts                 |  27 +
 arch/arm/boot/dts/imx28.dtsi                       |  62 +-
 arch/arm/boot/dts/imx6qdl.dtsi                     |   8 +-
 arch/arm/boot/dts/omap2.dtsi                       |  39 +-
 arch/arm/boot/dts/omap2420-h4.dts                  |  46 ++
 arch/arm/boot/dts/omap2420.dtsi                    |  67 +-
 arch/arm/boot/dts/omap2430.dtsi                    |  87 +-
 arch/arm/boot/dts/omap3-beagle-xm.dts              |  26 +-
 arch/arm/boot/dts/omap3-beagle.dts                 |   8 +-
 arch/arm/boot/dts/omap3-devkit8000.dts             | 169 ++++
 arch/arm/boot/dts/omap3-evm.dts                    |  14 +-
 arch/arm/boot/dts/omap3-igep.dtsi                  | 122 +++
 arch/arm/boot/dts/omap3-igep0020.dts               |  56 ++
 arch/arm/boot/dts/omap3-igep0030.dts               |  44 +
 arch/arm/boot/dts/omap3-overo.dtsi                 |  31 +-
 arch/arm/boot/dts/omap3.dtsi                       | 142 +++-
 arch/arm/boot/dts/omap3430-sdp.dts                 | 190 +++++
 arch/arm/boot/dts/omap34xx.dtsi                    |  28 +
 arch/arm/boot/dts/omap36xx.dtsi                    |  13 +
 arch/arm/boot/dts/omap4-panda-a4.dts               |   5 +-
 arch/arm/boot/dts/omap4-panda-common.dtsi          | 251 ++++++
 arch/arm/boot/dts/omap4-panda-es.dts               |   5 +-
 arch/arm/boot/dts/omap4-panda.dts                  | 201 +----
 arch/arm/boot/dts/omap4-sdp.dts                    |  74 +-
 arch/arm/boot/dts/omap4-var-som.dts                |   2 +-
 arch/arm/boot/dts/omap4.dtsi                       | 135 +++-
 arch/arm/boot/dts/omap443x.dtsi                    |  27 +
 arch/arm/boot/dts/omap4460.dtsi                    |  32 +
 arch/arm/boot/dts/omap5-evm.dts                    | 110 ++-
 arch/arm/boot/dts/omap5.dtsi                       | 245 +++++-
 arch/arm/boot/dts/tegra114-dalmore.dts             | 891 +++++++++++++++++++++
 arch/arm/boot/dts/tegra114.dtsi                    | 240 +++++-
 arch/arm/boot/dts/tegra20-colibri-512.dtsi         |  12 +
 arch/arm/boot/dts/tegra20-harmony.dts              |  20 +
 arch/arm/boot/dts/tegra20-medcom-wide.dts          |   7 +
 arch/arm/boot/dts/tegra20-paz00.dts                |  10 +
 arch/arm/boot/dts/tegra20-plutux.dts               |   3 +
 arch/arm/boot/dts/tegra20-seaboard.dts             |  11 +
 arch/arm/boot/dts/tegra20-tamonten.dtsi            |   6 +
 arch/arm/boot/dts/tegra20-tec.dts                  |   3 +
 arch/arm/boot/dts/tegra20-trimslice.dts            |  23 +
 arch/arm/boot/dts/tegra20-ventana.dts              |  22 +
 arch/arm/boot/dts/tegra20-whistler.dts             |  13 +
 arch/arm/boot/dts/tegra20.dtsi                     |  53 +-
 arch/arm/boot/dts/tegra30-beaver.dts               |   8 +
 arch/arm/boot/dts/tegra30-cardhu-a02.dts           |   1 +
 arch/arm/boot/dts/tegra30-cardhu-a04.dts           |   1 +
 arch/arm/boot/dts/tegra30-cardhu.dtsi              |  11 +
 arch/arm/boot/dts/tegra30.dtsi                     |   1 +
 arch/arm/boot/dts/twl4030.dtsi                     |  18 +-
 arch/arm/boot/dts/twl6030.dtsi                     |  12 +
 arch/arm/mach-davinci/da8xx-dt.c                   |   6 +
 arch/arm/mach-exynos/common.c                      |  53 +-
 arch/arm/mach-exynos/include/mach/map.h            |   1 -
 arch/arm/mach-mxs/mach-mxs.c                       | 170 ----
 arch/arm/mach-omap2/board-generic.c                |   1 +
 arch/arm/mach-omap2/omap_hwmod.c                   |  48 +-
 arch/arm/mach-omap2/pmu.c                          |  14 +-
 arch/arm/mach-omap2/timer.c                        |   7 +-
 arch/arm/plat-omap/dmtimer.c                       | 241 +++---
 arch/arm/plat-omap/include/plat/dmtimer.h          |   1 +
 drivers/dma/mxs-dma.c                              | 109 ++-
 drivers/i2c/busses/i2c-mxs.c                       |  40 +-
 drivers/mmc/host/mxs-mmc.c                         |  48 +-
 drivers/mtd/nand/gpmi-nand/gpmi-nand.c             |  51 +-
 drivers/mtd/nand/gpmi-nand/gpmi-nand.h             |   3 +-
 drivers/net/ethernet/freescale/fec.h               |   1 +
 drivers/net/ethernet/freescale/fec_main.c          |  18 +-
 drivers/spi/spi-davinci.c                          |   4 +-
 drivers/spi/spi-mxs.c                              |  60 +-
 drivers/tty/serial/mxs-auart.c                     |  52 +-
 drivers/video/Kconfig                              |   2 +
 drivers/video/mxsfb.c                              | 260 +++---
 include/linux/mxsfb.h                              |  52 --
 include/linux/spi/mxs-spi.h                        |   4 +-
 143 files changed, 7751 insertions(+), 3048 deletions(-)
