Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752562Ab3IFTNG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 15:13:06 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:38765 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059Ab3IFTNA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 15:13:00 -0400
From: Olof Johansson <olof@lixom.net>
To: torvalds@linux-foundation.org
Cc: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Olof Johansson <olof@lixom.net>
Subject: [GIT PULL 3/5] ARM: SoC DT updates for 3.12
Date: Fri,  6 Sep 2013 12:10:03 -0700
Message-Id: <1378494605-14990-4-git-send-email-olof@lixom.net>
X-Mailer: git-send-email 1.8.1.192.gc4361b8
In-Reply-To: <1378494605-14990-1-git-send-email-olof@lixom.net>
References: <1378494605-14990-1-git-send-email-olof@lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Device tree and bindings updates for 3.12.

General additions of various on-chip and on-board peripherals on various
platforms as support gets added. Some of the bigger changes are:

- Addition of (new) PCI-e support on Tegra.
- More Tegra4 support, including PMC configuration for Dalmore.
- Addition of a new board for Exynos4 (trats2) and more bindings for 4x12 IP.
- Addition of Allwinner A20 and A31 SoC and board files.
- Move of the ST Ericsson device tree files to now use ste-* prefix.
- More move of hardware description of shmobile platforms to DT.
- Two new board dts files for Freescale MXs.


Conflicts:
- Small conflicts with a 3.11 fix for tegra. Keep the branch version
  but move over the regulator-* properties.

----------------------------------------------------------------

The following changes since commit c4a76db1d8a31f7d25b9bd5b45a822a15366ec83:

  Merge tag 'cleanup-for-linus' into test-merge

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/dt-for-linus

for you to fetch changes up to 56e9e0f3a3c558b42db2dd5120d3a839e4beb282:

  Merge branch 'socfpga/dt' into next/dt

----------------------------------------------------------------

Alexandre Belloni (6):
      ARM: mxs: dt: cfa10037: make hogpins grabbed by respective drivers
      ARM: mxs: dt: cfa10049: make hogpins grabbed by respective drivers
      ARM: mxs: dt: cfa10055: make hogpins grabbed by respective drivers
      ARM: mxs: dt: cfa10057: remove hogpins
      ARM: mxs: dt: cfa10036: make hogpins grabbed by respective drivers
      ARM: at91: Add PMU support for sama5d3

Amit Daniel Kachhap (1):
      ARM: dts: Add device tree node for exynos5440 TMU controller

Andrew Bresticker (1):
      ARM: dts: add audio clock controller for exynos5420

Andrzej Hajda (3):
      ARM: dts: Add SPI1 controller and s5c73m3 sensor node for TRATS2
      ARM: dts: Add Exynos4210 SoC camera port pinctrl nodes
      ARM: dts: Add S5K5BA sensor regulator definitions for Trats board

Arun Kumar K (4):
      ARM: dts: Update clocks entry in MFC binding documentation
      ARM: dts: Remove unsused MFC clock from exynos4
      ARM: dts: Update 5250 MFC node
      ARM: dts: Add MFC node for exynos 5420

Bill Huang (1):
      ARM: tegra: configure power off for Dalmore

Brian Lilly (2):
      ARM: mxs: dt: Add Crystalfontz CFA-10056 device tree
      ARM: mxs: dt: Add Crystalfontz CFA-10058 device tree

Christian Daudt (3):
      ARM: dts: align sdio numbers to HW definition
      ARM: dts: add sdio blocks to bcm28155-ap board
      ARM: DT: binding fixup to align with vendor-prefixes.txt (DT)

Daniel Mack (2):
      ARM: pxa: fix DT auxdata for pxa3xx-gpio
      ARM: pxa: DTS: override gpio node in pxa3xx.dtsi

Dinh Nguyen (3):
      of: add vendor prefix for Altera Corp.
      dts: Deprecate ALTR as a vendor prefix
      dts: Rename DW APB timer compatible strings

Dongjin Kim (1):
      ARM: dts: Add USB host node for Exynos4

Emilio López (6):
      ARM: sun5i: dt: Add I2C muxings for sun5i A10S
      ARM: sun5i: dt: Add I2C controller nodes to the A10S dtsi
      ARM: sun5i: dt: Enable I2C controllers on A10S-OLinuXino-Micro
      ARM: sun5i: dt: Add AT24 device on A10S-OLinuXino-Micro
      ARM: sunxi: make the leds' names conform to the current naming convention
      ARM: sunxi: dt: Add device tree for Mele A1000

Fabio Estevam (1):
      ARM: dts: mxs: Add spi alias

Gabriel Fernandez (2):
      ARM: u8540: Add Pinctrl Device Tree settings for uart0, uart2
      ARM: u8540: DT: Set pinctrl mapping to i2c0,1,2,4 & 5

Guennadi Liakhovetski (4):
      ARM: shmobile: r8a73a4: add I2C controller DT nodes
      ARM: shmobile: ape6evm: add CPUFreq support
      ARM: shmobile: r8a73a4: add MMCIF and SDHI DT templates
      ARM: shmobile: r8a7790: add MMCIF and SDHI DT templates

Jacek Anaszewski (1):
      ARM: dts: Add AK8975 device node for Exynos4412 TRATS2 board

Jay Agarwal (2):
      ARM: tegra: Enable PCIe controller on Cardhu
      ARM: dts: tegra: Increase prefetchable PCI memory space

Jean-Christophe PLAGNIOL-VILLARD (3):
      ARM: at91: at91sam9260: add missing pinctrl-names on mmc
      ARM: at91: at91rm9200: set default mmc0 pinctrl-names
      ARM: at91/dt: add at91rm9200 PQFP package version

Joseph Lo (3):
      ARM: tegra: dalmore: add PM configurations for PMC
      ARM: tegra: dalmore: fix the irq trigger type of Palmas MFD device
      ARM: tegra: enable LP1 suspend mode

Kevin Hilman (10):
      Merge branch 'pxa/dt' into next/dt
      Merge branch 'zynq/dt' into next/dt
      Merge tag 'ux500-devicetree-for-v3.12-1' of git://git.kernel.org/.../linusw/linux-stericsson into next/dt
      Merge tag 'tegra-for-3.12-dt' of git://git.kernel.org/.../swarren/linux-tegra into next/dt
      Merge tag 'sunxi-dt-for-3.12' of https://github.com/mripard/linux into next/dt
      Merge tag 'sunxi-dt-for-3.12-2' of https://github.com/mripard/linux into next/dt
      Merge tag 'samsung-dt-1' of git://git.kernel.org/.../kgene/linux-samsung into next/dt
      Merge tag 'nomadik-i2c-for-arm-soc' of git://git.kernel.org/.../linusw/linux-nomadik into next/dt
      Merge tag 'at91-dt' of git://github.com/at91linux/linux-at91 into next/dt
      Merge tag 'mxs-dt-3.12' of git://git.linaro.org/people/shawnguo/linux-2.6 into next/dt

Kukjin Kim (1):
      ARM: dts: re-ordering exynos dtbs in Makefile

Laurent Pinchart (19):
      ARM: shmobile: r8a73a4: Add pin control device to device tree
      ARM: shmobile: r8a7740: Add pin control device to device tree
      ARM: shmobile: r8a7778: Add pin control device to device tree
      ARM: shmobile: r8a7778: Add GPIO controller devices to device tree
      ARM: shmobile: r8a7779: Add pin control device to device tree
      ARM: shmobile: r8a7779: Add GPIO controller devices to device tree
      ARM: shmobile: r8a7790: Add pin control device to device tree
      ARM: shmobile: r8a7790: Add GPIO controller devices to device tree
      ARM: shmobile: sh7372: Add pin control device to device tree
      ARM: shmobile: sh73a0: Add pin control device to device tree
      ARM: shmobile: armadillo-reference: Move pinctrl mappings to device tree
      ARM: shmobile: armadillo-reference: Add st1232 pin mappings
      ARM: shmobile: armadillo-reference: Move st1232 reset GPIO to DT
      ARM: shmobile: armadillo-reference: Add LED1-LED4 to the device tree
      ARM: shmobile: marzen-reference: Move pinctrl mappings to device tree
      ARM: shmobile: marzen-reference: Add LED2-LED4 to the device tree
      ARM: shmobile: kzm9g-reference: Move pinctrl mappings to device tree
      ARM: shmobile: kzm9g-reference: Move SDHI regulators to DT
      ARM: shmobile: kzm9g-reference: Add LED1-LED4 to the device tree

Laxman Dewangan (3):
      ARM: tegra: enable gpio-keys on Dalmore
      ARM: tegra: enable palmas device for dalmore
      ARM: tegra: define valid function names in DT document

Lee Jones (19):
      ARM: ux500: Fix trivial whitespace/tabbing issue
      ARM: ux500: Add Device Tree nodes for AB8500 External regulators
      ARM: ux500: Provide a supply name for the AB8500 AUX regulators to use
      ARM: ux500: Supply external regulator names for Snowball's DT
      Documentation: Update binding for Nomadik and DBx5x based platforms
      ARM: ux500: Stop passing MMC's platform data for Device Tree boots
      ARM: ux500: Remove Toshiba TC35892 I/O Expander's DT entry from Snowball's DTS
      ARM: ux500: Remove Snowball DTS entry for National Semiconductor LP5521 LED chip
      ARM: ux500: Remove Snowball DTS entry for TPS61052 chip
      ARM: ux500: Remove Snowball DTS entry for ROHM BH1780GLI ambient light sensor
      ARM: ux500: Apply a ste-* prefix onto snowball.dts
      ARM: ux500: Apply a ste-* prefix onto ccu8540.dts
      ARM: ux500: Apply a ste-* prefix onto ccu9540.dts
      ARM: ux500: Apply a ste-* prefix onto href.dtsi
      ARM: ux500: Apply a ste-* prefix onto hrefprev60.dts Signed-off-by: Lee Jones <lee.jones@linaro.org>
      ARM: ux500: Apply a ste-* prefix onto hrefv60plus.dts
      ARM: ux500: Apply a ste-* prefix onto stuib.dtsi
      ARM: ux500: Apply a ste-* prefix onto dbx5x0.dtsi
      ARM: ux500: Remove u9540.dts as it's been replaced

Linus Walleij (2):
      ARM: nomadik: switch to use the Nomadik I2C driver
      ARM: ux500: fix devicetree builds

Lothar Waßmann (5):
      ARM: dts: mxs: whitespace cleanup
      ARM: dts: mxs: add labels to most nodes for easier reference
      ARM: dts: mxs: add another set of saif0_pins (without MCLK)
      ARM: dts: mxs: add pin config for SSP3 interface
      ARM: dts: mxs: add pin config for LCD sync and clock pins

Magnus Damm (11):
      ARM: shmobile: Update KZM9D dts command line
      ARM: shmobile: Add GIO to EMEV2 dtsi
      ARM: shmobile: Use DT for GIC on EMEV2 and KZM9D
      ARM: shmobile: Use DT for SMP on EMEV2 and KZM9D
      ARM: shmobile: EMEV2 map_io update
      ARM: shmobile: KZM9D DT reference implementation
      ARM: shmobile: Add SMSC ethernet chip to KZM9D DT reference
      ARM: shmobile: Only build clocks when COMMON_CLK=n
      ARM: shmobile: Introduce ARCH_SHMOBILE_MULTI
      ARM: shmobile: Add EMEV2 and KZM9D to ARCH_SHMOBILE_MULTI
      ARM: shmobile: Allow ARCH_SHMOBILE_MULTI timer configuration

Marek Vasut (1):
      ARM: mxs: Add backlight support for M28EVK

Mark Brown (6):
      ARM: dts: Hook up IRQ for PMIC on Arndale
      ARM: dts: Put Arndale fixed voltage regulators on a simple-bus
      ARM: dts: Hook up supplies for Arndale S5M8767
      ARM: dts: Add WM1811A audio CODEC to Arndale bindings
      ARM: dts: Enable USB hub on Arndale
      ARM: dts: Hook up internal PHY on Arndale

Markus Mayer (2):
      ARM: bcm281xx: Adding bcm28155-ap.dts
      ARM: bcm281xx: DT changes for reboot code

Maxime Ripard (10):
      ARM: sun4i: a10: Remove useless simple-bus reg property
      ARM: sun4i: dt: Fix A10 SoC bus base address
      ARM: sun5i: a10s: Remove useless simple-bus reg property
      ARM: sun5i: dt: Fix A10s SoC bus base address
      ARM: sun5i: a13: Remove useless simple-bus reg property
      ARM: sun5i: dt: Fix A13 SoC bus base address
      ARM: sunxi: Add Allwinner A31 DTSI
      ARM: sun6i: Add WITS Colombus A31 evaluation kit support
      ARM: sun7i: Add Allwinner A20 DTSI
      ARM: sun7i: Add Olimex A20-Olinuxino-Micro support

Mikko Perttunen (1):
      ARM: tegra: add USB DT entries for Tegra114, Dalmore

Olof Johansson (5):
      Merge tag 'renesas-dt-for-v3.12' of git://git.kernel.org/.../horms/renesas into next/dt
      Merge tag 'renesas-pinmux-for-v3.12' of git://git.kernel.org/.../horms/renesas into next/dt
      Merge tag 'renesas-multiplatform-for-v3.12' of git://git.kernel.org/.../horms/renesas into next/dt
      Merge branch 'armsoc/for-3.12/dt' of git://github.com/broadcom/bcm11351 into next/dt
      Merge branch 'socfpga/dt' into next/dt

Otavio Salvador (3):
      ARM: dts: imx23-evk: enable USB PHY and controller
      ARM: dts: imx23-evk: enable Low Resolution ADC
      ARM: dts: imx23-olinuxino: enable Low Resolution ADC

Padmavathi Venna (1):
      ARM: dts: Correct the /include entry on exynos5420 dtsi file

Richard Genoud (4):
      ARM: at91/dt: sam9x5: add SSC DMA parameters
      ARM: at91/dt: sam9x5ek: add WM8731 codec
      ARM: at91/dt: sam9x5ek: enable SSC
      ARM: at91/dt: sam9x5ek: add sound configuration

Sachin Kamat (1):
      ARM: dts: Add G2D support to exynos5250

Shawn Guo (1):
      ARM: dts: mxs: remove old DMA binding data from client nodes

Soren Brinkmann (1):
      arm: zynq: dt: Set correct L2 ram latencies

Stephen Warren (6):
      ARM: tegra: fix DT node ordering in Tegra30 Cardhu
      ARM: tegra: remove tegra114-pluto.dts
      ARM: tegra: use TEGRA_GPIO() in a couple more places
      ARM: tegra: Fix Beaver's PCIe lane configuration
      ARM: tegra: add Mic Jack to Beaver device tree
      ARM: tegra: add Mic Jack to Dalmore device tree

Sylwester Nawrocki (9):
      ARM: dts: Correct camera pinctrl nodes for Exynos4x12 SoCs
      ARM: dts: Add pinctrl entries for Exynos4x12 FIMC-IS peripherals
      ARM: dts: Add ISP power domain node for Exynos4x12
      ARM: dts: Use generic DMA bindings for Exynos4 SPI devices
      ARM: dts: Add camera subsystem device nodes to exynos4.dtsi
      ARM: dts: Add camera subsystem nodes to exynos4x12.dtsi
      ARM: dts: Add camera device nodes for Exynos4412 TRATS2 board
      ARM: dts: Add camera device nodes for Exynos4210 SoCs
      ARM: dts: Add FIMC nodes for Exynos4210 Trats board

Thierry Reding (8):
      ARM: tegra: beaver: Enable HDMI output
      ARM: tegra: Add Tegra20 PCIe support to DT
      ARM: tegra: tamonten: Add PCIe support
      ARM: tegra: tec: Add PCIe support
      ARM: tegra: harmony: Initialize PCIe from DT
      ARM: tegra: trimslice: Initialize PCIe from DT
      ARM: tegra: Add Tegra30 PCIe support
      ARM: tegra: Enable PCIe controller on Beaver

Tomasz Figa (1):
      ARM: dts: Add basic dts for Exynos4412-based Trats 2 board

Tuomas Tynkkynen (1):
      ARM: tegra: add USB DT entries for Tegra30

Tushar Behera (1):
      ARM: dts: Add secure-firmware boot support for OrigenQaud board

Vikas Sajjan (6):
      ARM: dts: Move display-timing information inside FIMD DT node for exynos5250
      ARM: dts: Update FIMD DT node for Exynos5 SoCs
      ARM: dts: Add FIMD DT node to exynos5420 DTS files
      ARM: dts: Update DP controller DT Node for Exynos5 based SoCs
      ARM: dts: Add DP controller DT node to exynos5420 SoC
      ARM: dts: Add pin state information for DP HPD support to Exynos5420

Wei Ni (1):
      ARM: tegra: add DT entry for nct1008 to Cardhu

Yadwinder Singh Brar (1):
      ARM: dts: Add basic PM domains for EXYNOS5420

voice (3):
      ARM: at91: at91sam9n12: add pinctrl of TWI
      ARM: at91: at91sam9n12: add qt1070 support
      ARM: at91: at91sam9n12: correct pin number of gpio-key


 .../devicetree/bindings/arm/bcm/bcm11351.txt    |   3 +-
 .../bcm/{bcm,kona-timer.txt => kona-timer.txt}  |   5 +-
 .../devicetree/bindings/arm/bcm/kona-wdt.txt    |  15 +
 .../devicetree/bindings/media/s5p-mfc.txt       |  10 +-
 Documentation/devicetree/bindings/misc/smc.txt  |   5 +-
 .../mmc/{bcm,kona-sdhci.txt => kona-sdhci.txt}  |   5 +-
 .../bindings/pinctrl/nvidia,tegra114-pinmux.txt |  11 +
 .../bindings/pinctrl/nvidia,tegra20-pinmux.txt  |  11 +
 .../bindings/pinctrl/nvidia,tegra30-pinmux.txt  |  12 +
 .../devicetree/bindings/pinctrl/ste,nomadik.txt |   6 +-
 .../devicetree/bindings/rtc/dw-apb.txt          |  34 +-
 .../bindings/serial/altera_jtaguart.txt         |   3 +-
 .../devicetree/bindings/serial/altera_uart.txt  |   3 +-
 .../devicetree/bindings/serio/altera_ps2.txt    |   3 +-
 .../devicetree/bindings/spi/spi_altera.txt      |   3 +-
 .../devicetree/bindings/vendor-prefixes.txt     |   1 +
 arch/arm/Makefile                               |   1 +
 arch/arm/boot/dts/Makefile                      |  30 +-
 arch/arm/boot/dts/at91rm9200.dtsi               |   1 +
 arch/arm/boot/dts/at91rm9200_pqfp.dtsi          |  17 +
 arch/arm/boot/dts/at91sam9260.dtsi              |   1 +
 arch/arm/boot/dts/at91sam9n12.dtsi              |  20 +
 arch/arm/boot/dts/at91sam9n12ek.dts             |  18 +-
 arch/arm/boot/dts/at91sam9x5.dtsi               |   3 +
 arch/arm/boot/dts/at91sam9x5ek.dtsi             |  24 +
 arch/arm/boot/dts/bcm11351-brt.dts              |   8 +-
 arch/arm/boot/dts/bcm11351.dtsi                 |  33 +-
 arch/arm/boot/dts/bcm28155-ap.dts               |  45 ++
 arch/arm/boot/dts/ccu8540.dts                   |  41 --
 arch/arm/boot/dts/emev2-kzm9d-reference.dts     |  57 ++
 arch/arm/boot/dts/emev2-kzm9d.dts               |   2 +-
 arch/arm/boot/dts/emev2.dtsi                    |  59 ++
 arch/arm/boot/dts/exynos4.dtsi                  | 122 +++-
 arch/arm/boot/dts/exynos4210-pinctrl.dtsi       |  23 +
 arch/arm/boot/dts/exynos4210-trats.dts          | 100 +++-
 arch/arm/boot/dts/exynos4210.dtsi               |  30 +
 arch/arm/boot/dts/exynos4412-origen.dts         |   5 +
 arch/arm/boot/dts/exynos4412-trats2.dts         | 579 +++++++++++++++++++
 arch/arm/boot/dts/exynos4x12-pinctrl.dtsi       |  61 +-
 arch/arm/boot/dts/exynos4x12.dtsi               | 103 ++++
 arch/arm/boot/dts/exynos5.dtsi                  |  19 +
 arch/arm/boot/dts/exynos5250-arndale.dts        | 105 +++-
 arch/arm/boot/dts/exynos5250-smdk5250.dts       |  32 +-
 arch/arm/boot/dts/exynos5250.dtsi               |  38 +-
 arch/arm/boot/dts/exynos5420-pinctrl.dtsi       |   7 +
 arch/arm/boot/dts/exynos5420-smdk5420.dts       |  31 +
 arch/arm/boot/dts/exynos5420.dtsi               |  75 ++-
 arch/arm/boot/dts/exynos5440.dtsi               |  27 +
 arch/arm/boot/dts/imx23-evk.dts                 |  15 +
 arch/arm/boot/dts/imx23-olinuxino.dts           |   4 +
 arch/arm/boot/dts/imx23.dtsi                    |  17 +-
 arch/arm/boot/dts/imx28-cfa10036.dts            |   7 +-
 arch/arm/boot/dts/imx28-cfa10037.dts            |  19 +-
 arch/arm/boot/dts/imx28-cfa10049.dts            |  73 ++-
 arch/arm/boot/dts/imx28-cfa10055.dts            |  38 +-
 arch/arm/boot/dts/imx28-cfa10056.dts            | 119 ++++
 arch/arm/boot/dts/imx28-cfa10057.dts            |  23 +-
 arch/arm/boot/dts/imx28-cfa10058.dts            | 141 +++++
 arch/arm/boot/dts/imx28-m28evk.dts              |  13 +
 arch/arm/boot/dts/imx28.dtsi                    | 143 +++--
 arch/arm/boot/dts/pxa3xx.dtsi                   |  11 +
 arch/arm/boot/dts/r8a73a4-ape6evm.dts           |  22 +
 arch/arm/boot/dts/r8a73a4.dtsi                  | 133 +++++
 .../dts/r8a7740-armadillo800eva-reference.dts   |  34 ++
 arch/arm/boot/dts/r8a7740.dtsi                  |   8 +
 arch/arm/boot/dts/r8a7778.dtsi                  |  66 +++
 arch/arm/boot/dts/r8a7779-marzen-reference.dts  |  49 ++
 arch/arm/boot/dts/r8a7779.dtsi                  |  90 +++
 arch/arm/boot/dts/r8a7790.dtsi                  | 132 +++++
 arch/arm/boot/dts/sama5d3.dtsi                  |   5 +
 arch/arm/boot/dts/sh7372.dtsi                   |   8 +
 arch/arm/boot/dts/sh73a0-kzm9g-reference.dts    |  90 ++-
 arch/arm/boot/dts/sh73a0.dtsi                   |   8 +
 arch/arm/boot/dts/socfpga.dtsi                  |   8 +-
 arch/arm/boot/dts/ste-ccu8540-pinctrl.dtsi      | 196 +++++++
 arch/arm/boot/dts/ste-ccu8540.dts               |  86 +++
 .../boot/dts/{ccu9540.dts => ste-ccu9540.dts}   |   2 +-
 .../boot/dts/{dbx5x0.dtsi => ste-dbx5x0.dtsi}   |  30 +-
 arch/arm/boot/dts/{href.dtsi => ste-href.dtsi}  |   2 +-
 .../dts/{hrefprev60.dts => ste-hrefprev60.dts}  |   6 +-
 .../{hrefv60plus.dts => ste-hrefv60plus.dts}    |   6 +-
 arch/arm/boot/dts/ste-nomadik-pinctrl.dtsi      |  95 +++
 arch/arm/boot/dts/ste-nomadik-stn8815.dtsi      |  42 +-
 .../boot/dts/{snowball.dts => ste-snowball.dts} |  44 +-
 .../arm/boot/dts/{stuib.dtsi => ste-stuib.dtsi} |   0
 arch/arm/boot/dts/sun4i-a10-a1000.dts           | 101 ++++
 arch/arm/boot/dts/sun4i-a10-cubieboard.dts      |   6 +-
 arch/arm/boot/dts/sun4i-a10-hackberry.dts       |   2 +-
 arch/arm/boot/dts/sun4i-a10-mini-xplus.dts      |   2 +-
 arch/arm/boot/dts/sun4i-a10.dtsi                |   3 +-
 .../arm/boot/dts/sun5i-a10s-olinuxino-micro.dts |  27 +-
 arch/arm/boot/dts/sun5i-a10s.dtsi               |  57 +-
 arch/arm/boot/dts/sun5i-a13-olinuxino.dts       |   2 +-
 arch/arm/boot/dts/sun5i-a13.dtsi                |   3 +-
 arch/arm/boot/dts/sun6i-a31-colombus.dts        |  30 +
 arch/arm/boot/dts/sun6i-a31.dtsi                | 156 +++++
 arch/arm/boot/dts/sun7i-a20-olinuxino-micro.dts |  34 ++
 arch/arm/boot/dts/sun7i-a20.dtsi                | 172 ++++++
 arch/arm/boot/dts/tegra114-dalmore.dts          | 237 +++++++-
 arch/arm/boot/dts/tegra114-pluto.dts            |  33 --
 arch/arm/boot/dts/tegra114.dtsi                 |  62 ++
 arch/arm/boot/dts/tegra20-colibri-512.dtsi      |   2 +-
 arch/arm/boot/dts/tegra20-harmony.dts           |  22 +-
 arch/arm/boot/dts/tegra20-paz00.dts             |   2 +-
 arch/arm/boot/dts/tegra20-seaboard.dts          |   4 +-
 arch/arm/boot/dts/tegra20-tamonten.dtsi         |  19 +-
 arch/arm/boot/dts/tegra20-tec.dts               |   8 +
 arch/arm/boot/dts/tegra20-trimslice.dts         |  32 +-
 arch/arm/boot/dts/tegra20-ventana.dts           |   2 +-
 arch/arm/boot/dts/tegra20-whistler.dts          |   2 +-
 arch/arm/boot/dts/tegra20.dtsi                  |  55 ++
 arch/arm/boot/dts/tegra30-beaver.dts            |  64 +-
 arch/arm/boot/dts/tegra30-cardhu.dtsi           |  64 +-
 arch/arm/boot/dts/tegra30.dtsi                  | 156 +++++
 arch/arm/boot/dts/u9540.dts                     |  72 ---
 arch/arm/boot/dts/zynq-7000.dtsi                |   4 +-
 arch/arm/mach-nomadik/Kconfig                   |   1 +
 arch/arm/mach-pxa/pxa-dt.c                      |   2 +-
 arch/arm/mach-shmobile/Kconfig                  |  64 +-
 arch/arm/mach-shmobile/Makefile                 |  34 +-
 arch/arm/mach-shmobile/Makefile.boot            |   1 +
 .../board-armadillo800eva-reference.c           |  18 +-
 arch/arm/mach-shmobile/board-kzm9d-reference.c  |  47 ++
 arch/arm/mach-shmobile/board-kzm9d.c            |   2 -
 arch/arm/mach-shmobile/board-kzm9g-reference.c  |  47 --
 arch/arm/mach-shmobile/board-marzen-reference.c |  28 -
 arch/arm/mach-shmobile/include/mach/emev2.h     |   1 -
 arch/arm/mach-shmobile/setup-emev2.c            |  26 +-
 arch/arm/mach-shmobile/smp-emev2.c              |  17 +-
 arch/arm/mach-ux500/cpu-db8500.c                |   8 +-
 drivers/input/serio/altera_ps2.c                |   1 +
 drivers/spi/spi-altera.c                        |   1 +
 drivers/tty/serial/altera_jtaguart.c            |   1 +
 drivers/tty/serial/altera_uart.c                |   1 +
 include/dt-bindings/pinctrl/nomadik.h           |  36 ++
 135 files changed, 4721 insertions(+), 682 deletions(-)
 rename Documentation/devicetree/bindings/arm/bcm/{bcm,kona-timer.txt => kona-timer.txt} (80%)
 create mode 100644 Documentation/devicetree/bindings/arm/bcm/kona-wdt.txt
 rename Documentation/devicetree/bindings/mmc/{bcm,kona-sdhci.txt => kona-sdhci.txt} (67%)
 create mode 100644 arch/arm/boot/dts/at91rm9200_pqfp.dtsi
 create mode 100644 arch/arm/boot/dts/bcm28155-ap.dts
 delete mode 100644 arch/arm/boot/dts/ccu8540.dts
 create mode 100644 arch/arm/boot/dts/emev2-kzm9d-reference.dts
 create mode 100644 arch/arm/boot/dts/exynos4412-trats2.dts
 create mode 100644 arch/arm/boot/dts/imx28-cfa10056.dts
 create mode 100644 arch/arm/boot/dts/imx28-cfa10058.dts
 create mode 100644 arch/arm/boot/dts/ste-ccu8540-pinctrl.dtsi
 create mode 100644 arch/arm/boot/dts/ste-ccu8540.dts
 rename arch/arm/boot/dts/{ccu9540.dts => ste-ccu9540.dts} (98%)
 rename arch/arm/boot/dts/{dbx5x0.dtsi => ste-dbx5x0.dtsi} (96%)
 rename arch/arm/boot/dts/{href.dtsi => ste-href.dtsi} (99%)
 rename arch/arm/boot/dts/{hrefprev60.dts => ste-hrefprev60.dts} (92%)
 rename arch/arm/boot/dts/{hrefv60plus.dts => ste-hrefv60plus.dts} (98%)
 create mode 100644 arch/arm/boot/dts/ste-nomadik-pinctrl.dtsi
 rename arch/arm/boot/dts/{snowball.dts => ste-snowball.dts} (93%)
 rename arch/arm/boot/dts/{stuib.dtsi => ste-stuib.dtsi} (100%)
 create mode 100644 arch/arm/boot/dts/sun4i-a10-a1000.dts
 create mode 100644 arch/arm/boot/dts/sun6i-a31-colombus.dts
 create mode 100644 arch/arm/boot/dts/sun6i-a31.dtsi
 create mode 100644 arch/arm/boot/dts/sun7i-a20-olinuxino-micro.dts
 create mode 100644 arch/arm/boot/dts/sun7i-a20.dtsi
 delete mode 100644 arch/arm/boot/dts/tegra114-pluto.dts
 delete mode 100644 arch/arm/boot/dts/u9540.dts
 create mode 100644 arch/arm/mach-shmobile/board-kzm9d-reference.c
 create mode 100644 include/dt-bindings/pinctrl/nomadik.h
