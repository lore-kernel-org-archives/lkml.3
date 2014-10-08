Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754810AbaJHUbO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 16:31:14 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:51938 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753164AbaJHUbM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 16:31:12 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: torvalds@linux-foundation.org
Cc: linux-arm-kernel@lists.infradead.org, arm@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL 4/7] ARM:  SoC DT updates for 3.18
Date: Wed, 08 Oct 2014 22:30:34 +0200
Message-ID: <3472855.pbEy2f4JJ8@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1922034.HH2lvbiFi0@wuerfel>
References: <1922034.HH2lvbiFi0@wuerfel>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
X-Provags-ID: V02:K0:EuIspDD7tdKbXp8n6JP6cnX/Jxund21GvgRoZGjJOoh
 MtEtvKh5wuWad1A+J6ZblWiZJWt2IOUy5fCqmgGDkv60hwT723
 d667wj0Drn8c0xRmWx920Fx25jJ+j7gIPQ+wQg0MMndnOIKQSZ
 EkvxzNyezAD6j4hTJZbN49OP9456kJTZgU8i6LBn6Q04LJo4cY
 XbUZt6Twr6J84FjJfU2P3bQTSdB4YkR28uQ78lo+9vBNLCGoXV
 QjhU0BxBiIv52gkbtPRwhtTSyEVy3iSS/tA6g9VkoSwoDws3Zm
 c2dM/6xDlyFKE8rgrUKrL8hEpvr1hf+6BmGWnMIMM9DRxRB5dT
 6YW679xaKGMt8xEnBPiw=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 69e273c0b0a3c337a521d083374c918dc52c666f:

  Linux 3.17-rc3 (2014-08-31 18:23:04 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/dt-for-linus

for you to fetch changes up to ee48874d4aa50d9c4921b44a38dc33110b90638b:

  Merge tag 'meson-wdt-dt-3.18' of https://github.com/carlocaione/linux-meson into next/dt (2014-10-08 21:19:21 +0200)

----------------------------------------------------------------
ARM: SoC DT updates for 3.18

As usual, this is the largest branch, though this time a little under
half of the total changes with 307 individual non-merge changesets.

The largest changes are the addition of new machines, in particular
the Tegra based Chromebook, the Renesas r8a7794 SoC, and DT support
for the old i.MX1 platform.

Other changes include
- at91: various sam9 and sama5 updates
- exynos: much extended Peach Pi/Pit (Chromebook 2) support
- keystone: new peripherals
- meson: added DT for meson6 SoC
- mvebu: new device support for Armada 370/375
- qcom: improved support for IPQ8064 and MSM8x60
- rockchip: much improved support for rk3288
- shmobile: lots of updates all over the place
- sunxi: dts license change
- sunxi: more a23 device support
- vexpress: CLCD DT description

----------------------------------------------------------------

Addy Ke (1):
      ARM: dts: Add sdio0 and sdio1 to the rk3288

Ajay Kumar (3):
      ARM: dts: update display related nodes for exynos5250-snow
      ARM: dts: update display related nodes for exynos5420-peach-pit
      ARM: dts: update display related nodes for exynos5800-peach-pi

Alexander Shiyan (4):
      ARM: dts: i.MX1: Add i.MX1 template
      ARM: i.MX: dts: Add support for the Freescale i.MX1 ADS board
      ARM: i.MX: dts: Add simple-card support
      ARM: dts: Add support for the i.MX1 Armadeus APF9328 board

Alexandre Belloni (4):
      ARM: at91/dt: sama5d3: define mpddr clock and ramc clocks
      ARM: at91/dt: at91sam9: use ddrck in ramc
      ARM: at91/dt: sam9x5: fix ADC compatible string
      ARM: at91/dt: sama5d3: add the nfc clock

Andreas Faerber (2):
      ARM: dts: Fix MMC pinctrl for exynos5250-snow
      ARM: dts: Fold exynos5250-cros-common into exynos5250-snow

Anson Huang (2):
      ARM: dts: add thermal sensor support for i.mx6sl
      ARM: dts: imx6: make gpt per clock can be from OSC

Arnd Bergmann (24):
      Merge tag 'v3.18-rockchip-dts1' of git://git.kernel.org/.../mmind/linux-rockchip into next/dt
      Merge tag 'v3.18-rockchip-dma' of git://git.kernel.org/.../mmind/linux-rockchip into next/dt
      Merge tag 'renesas-dt-for-v3.18' of git://git.kernel.org/.../horms/renesas into next/dt
      Merge tag 'renesas-dt2-for-v3.18' of git://git.kernel.org/.../horms/renesas into next/dt
      Merge tag 'renesas-dt3-for-v3.18' of git://git.kernel.org/.../horms/renesas into next/dt
      Merge tag 'at91-dt' of git://github.com/at91linux/linux-at91 into next/dt
      Merge tag 'at91-dt2' of git://github.com/at91linux/linux-at91 into next/dt
      Merge tag 'davinci-for-v3.18/dt' of git://git.kernel.org/.../nsekhar/linux-davinci into next/dt
      Merge tag 'socfpga_update_for_v3.18' of git://git.rocketboards.org/linux-socfpga-next into next/dt
      Merge tag 'renesas-dt4-for-v3.18' of git://git.kernel.org/.../horms/renesas into next/dt
      Merge tag 'zynq-dt-for-3.18' of git://git.xilinx.com/linux-xlnx into next/dt
      Merge tag 'at91-dt3' of git://github.com/at91linux/linux-at91 into next/dt
      Merge tag 'tegra-for-3.18-dt' of git://git.kernel.org/.../swarren/linux-tegra into next/dt
      Merge tag 'pxa-fix-abi' of https://git.kernel.org/.../hzhuang1/linux into next/dt
      Merge tag 'renesas-dt5-for-v3.18' of git://git.kernel.org/.../horms/renesas into next/dt
      Merge tag 'sunxi-dt-for-3.18' of git://git.kernel.org/.../mripard/linux into next/dt
      Merge tag 'hix5hd2-dt-for-3.18' of git://github.com/hisilicon/linux-hisi into next/dt
      Merge tag 'dt-part2-v2-for-v3.18' of git://git.kernel.org/.../tmlind/linux-omap into next/dt
      Merge tag 'keystone-dts' of git://git.kernel.org/.../ssantosh/linux-keystone into next/dt
      Merge tag 'samsung-dt' of git://git.kernel.org/.../kgene/linux-samsung into next/dt
      Revert "Merge tag 'hix5hd2-dt-for-3.18' of git://github.com/hisilicon/linux-hisi into next/dt"
      Merge tag 'keystone-dts-fixes' of git://git.kernel.org/.../ssantosh/linux-keystone into next/dt
      Merge tag 'mvebu-dt-3.18-2' of git://git.infradead.org/linux-mvebu into next/dt
      Merge branch 'next/dt' into HEAD

Bartlomiej Zolnierkiewicz (2):
      ARM: dts: remove old USB2 PHY node hook for exynos5250-arndale
      ARM: dts: remove old USB2 PHY node for exynos5250

Ben Dooks (2):
      ARM: shmobile: r8a7790: add VIN device nodes
      ARM: shmobile: lager: add VIN1/ADV7180 device nodes

Bill Pringlemeir (1):
      ARM: dts: vf610-twr: Add ttyLP2 device.

Bo Shen (4):
      ARM: at91/dt: sam9n12ek: ohci: add port and vbus property
      ARM: at91: sama5d3xek: reserve dma channel for audio
      ARM: at91/dt: at91sam9rl: switch ssc compatible string
      ARM: at91/dt: at91sam9g20: switch ssc compatible string

Boris BREZILLON (3):
      ARM: at91/dt: describe rgmii ethernet phy connected to sama5d3xek boards
      ARM: at91: remove phy fixup for sama5d3xek boards
      ARM: at91/dt: declare sckc node on at91sam9g45

Carlo Caione (2):
      ARM: meson: dts: add basic Meson/Meson6/Meson6-atv1200 DTSI/DTS
      ARM: meson: documentation: add bindings documentation

Chen-Yu Tsai (18):
      ARM: dts: sun8i: add rtc device node
      ARM: dts: sun6i: add rtc device node
      ARM: dts: sun8i: Add PIO controller node to the sun8i dtsi
      ARM: dts: sun8i: Add R_PIO controller node to the dtsi
      ARM: dts: sun8i: Add pinmux set for uart0
      ARM: dts: sun8i: Add pin muxing option for R_UART
      ARM: dts: sun8i: ippo-q8h: Add pinctrl properties for R_UART
      ARM: dts: sun8i: Add mmc clocks to the dtsi
      ARM: dts: sun8i: Add pin-muxing info for the mmc controllers
      ARM: dts: sun8i: Add mmc controller nodes
      ARM: dts: sun8i: Enable mmc controller on ippo-q8h-v5
      ARM: dts: sun8i: Add pin-muxing info for the i2c controllers
      ARM: dts: sun8i: Add i2c controller nodes
      ARM: dts: sun8i: Enable i2c controllers on ippo-q8h-v5
      ARM: dt: sunxi: Remove i2c controller clock-frequency that matches default
      ARM: dts: sunxi: Add fixed 5V regulator
      ARM: dts: sun5i: Add DT for HSG H702 tablet board
      ARM: dts: sun8i: Add DMA controller node

Daniel Drake (2):
      ARM: dts: Enable PMIC interrupts for exynos4412-odroid-common
      ARM: dts: ODROID i2c improvements for exynos4412-odroid-common

Daniel Mack (2):
      ARM: pxa: dts: fix mmc controller compatible string
      ARM: pxa: dts: fix ohci controller compatible string

David Dueck (1):
      ARM: at91/dt: Fix typo regarding can0_clk

Dinh Nguyen (4):
      MAINTAINERS: update entries for ARM/SOCFPGA platform
      ARM: dts: socfpga: remove extra alias in the ArriaV devkit
      ARM: dts: socfpga: Add SD card detect
      ARM: dts: socfpga: memreserve first 4KB for future system use

Dmitry Lifshitz (7):
      ARM: dts: sbc-t54: fix model property
      ARM: dts: sbc-t54: fix mux mode comment style
      ARM: dts: cm-t54: fix mux mode comment style
      ARM: dts: cm-t54: add HDMI/DVI display data
      ARM: dts: cm-t54: add Startek LCD support
      ARM: dts: cm-t54: add ADS7846 touchscreen support
      ARM: dts: cm-t54: setup omap_dwc3

Doug Anderson (8):
      ARM: dts: Add emmc and sdmmc to the rk3288 device tree
      ARM: dts: Enable emmc and sdmmc on the rk3288-evb boards
      ARM: dts: Move the PMIC interrupt pinctrl line to rk3288-evb common
      ARM: dts: Add main PWM info to rk3288
      ARM: dts: Enable PWM backlight on rk3288-evb
      ARM: dts: Add mshc aliases for rk3288
      ARM: dts: Add rk808 PMIC to rk3288-evb-rk808
      ARM: dts: Switch i2c0 to 400kHz on rk3288-evb-rk808

Dylan Reid (2):
      ARM: tegra: Move pwm and dpaux labels to tegra124.dtsi
      ARM: tegra: add Acer Chromebook 13 device tree

Emilio López (6):
      ARM: sun4i: dt: Add node to represent the DMA controller
      ARM: sun5i: dt: Add nodes to represent the DMA controllers
      ARM: sun7i: dt: Add node to represent the DMA controller
      ARM: sun4i: dt: enable DMA on SPI
      ARM: sun5i: dt: enable DMA on SPI
      ARM: sun7i: dt: enable DMA on SPI

Erik van Luijk (1):
      ARM: at91/dt: at91sam9m10g45ek add rtc node

Ezequiel Garcia (6):
      ARM: mvebu: Add network pin mux configuration for the Armada 370 SoC
      ARM: mvebu: Add proper pin muxing on Globalscale Mirabox board
      ARM: mvebu: Add proper pin muxing on the Armada 370 DB board
      ARM: mvebu: Add proper pin muxing on Netgear ReadyNAS 102
      ARM: mvebu: Add proper pin muxing on Netgear ReadyNAS 104
      ARM: mvebu: Add proper pin muxing on Armada 370 RD board

Ezra Savard (1):
      ARM: zynq: DT: Add LEDs to zc702 DT

FUKAUMI Naoki (1):
      ARM: sun7i: Add support for Olimex A20-OLinuXino-LIME

Fabio Estevam (14):
      ARM: dts: imx6sl-evk.dts: Keep pinctrl nodes sorted
      ARM: dts: imx6sl-evk: Add LCD support
      ARM: dts: imx6sx: Add LCDIF compatible strings
      ARM: dts: imx6x-sdb: Add LCD support
      ARM: dts: imx28-evk: Fix display duplicate name warning
      ARM: dts: imx23-evk: Fix display duplicate name warning
      ARM: dts: imx6sl-evk: Fix display duplicate name warning
      ARM: dts: imx28-apx4devkit: Fix display duplicate name warning
      ARM: dts: imx28-apf28dev: Fix display duplicate name warning
      ARM: dts: imx28-cfa100: Fix display duplicate name warning
      ARM: dts: imx28-m28cu: Fix display duplicate name warning
      ARM: dts: imx28-tx28: Fix display duplicate name warning
      ARM: dts: imx28-m28evk: Fix display duplicate name warning
      ARM: dts: imx6qdl-sabresd: Configure the pins locally

Geert Uytterhoeven (15):
      ARM: shmobile: r8a7791 dtsi: Enable DMA for QSPI
      ARM: shmobile: r8a7791 dtsi: Enable DMA for MSIOF
      ARM: shmobile: r8a7790 dtsi: Enable DMA for QSPI
      ARM: shmobile: r8a7790 dtsi: Enable DMA for MSIOF
      ARM: shmobile: r8a7779 dtsi: Remove superfluous interrupt-parent
      ARM: shmobile: r8a7790 dtsi: Remove superfluous interrupt-parent
      ARM: shmobile: r8a7791 dtsi: Remove superfluous interrupt-parent
      ARM: shmobile: sh73a0 dtsi: Move interrupt-parent to the top
      ARM: shmobile: r8a7779 dtsi: Add SoC-specific thermal compatible property
      ARM: shmobile: r8a73a4 dtsi: Add SoC-specific thermal compatible property
      ARM: shmobile: Add platform device tree bindings documentation
      ARM: shmobile: r8a7779 dtsi: Use tabs for indentation
      ARM: shmobile: kzm9g-reference dts: Use tabs for indentation
      ARM: shmobile: r8a73a4 dtsi: Add SoC-specific irqc compatible property
      ARM: shmobile: Add manufacturer for KZM boards

Georgi Djakov (4):
      ARM: dts: qcom: Add APQ8084 Global Clock Controller DT node
      ARM: dts: qcom: Add APQ8084 serial port DT node
      ARM: dts: qcom: Add initial IFC6540 board device tree
      ARM: dts: qcom: Add TLMM DT node for APQ8084

Greg Ungerer (1):
      ARM: mvebu: use improved armada spi device tree compatible name

Gregory CLEMENT (2):
      ARM: mvebu: Add RTC support for Armada 375
      ARM: mvebu: add SSCG to Armada 370 Device Tree

Grygorii Strashko (6):
      ARM: dts: keystone: add keystone irq controller node
      ARM: dts: keystone: add dsp gpio controllers nodes
      ARM: dts: keystone: fix io range for usb_phy0
      ARM: dts: keystone-k2e: update usb1 node for dma properties
      ARM: dts: keystone-k2e: fix mdio io start address
      ARM: dts: keystone-k2l: fix mdio io start address

Heiko Stuebner (8):
      ARM: dts: rockchip: remove rockchip,bus-index from rk3xxx i2c0
      ARM: dts: rockchip: add dwc2 controllers for rk3066 and rk3188
      ARM: dts: rockchip: enable usb ports on Radxa Rock
      ARM: dts: rockchip: add Cortex-A9 SPI controller nodes
      ARM: dts: rockchip: add emmc nodes for rk3066 and rk3188
      ARM: dts: rockchip: clean up rk3xxx mmc nodes
      ARM: dts: rockchip: fix swapped Radxa Rock pinctrl references
      ARM: dts: rockchip: fix rk3188 emmc pull references

Heiko Stübner (5):
      ARM: dts: rockchip: add hym8563 rtc to Radxa Rock board
      ARM: dts: rockchip: add saradc nodes
      ARM: rockchip: enable the AMBA bus
      ARM: dts: rockchip: add rk3288 dma controllers
      ARM: dts: rockchip: add rk3066 and rk3188 dma controllers

Jaehoon Chung (3):
      ARM: dts: rockchip: unuse the slot-node and deprecate the supports-highspeed for dw-mmc
      ARM: dts: unuse the slot-node and deprecate the supports-highspeed for dw-mmc in exynos
      ARM: dts: socfpga: unuse the slot-node and deprecate the supports-highspeed for     dw-mmc

Javier Martinez Canillas (5):
      ARM: dts: Improve Peach Pit and Pi power scheme
      ARM: dts: Add support max77802 PMIC for exynos based Peach boards
      ARM: dts: Add ISL29018 sensor for exynos based Peach boards
      ARM: dts: Set i2c7 clock at 400kHz for exynos based Peach boards
      ARM: dts: Add support Atmel touchpad for exynos5800-peach-pi

Jianqun (1):
      ARM: dts: add rk3288 i2s controller

Karicheri Muralidharan (1):
      ARM: dts: keystone: k2l: Fix chip selects for SPI devices

Karicheri, Muralidharan (1):
      ARM: dts: keystone: fix bindings for pcie and usb clock nodes

Keerthy J (2):
      ARM: dts: dra72-evm: Enable I2C1 node
      ARM: dts: dra72-evm: Add tps65917 PMIC node

Kever Yang (2):
      ARM: dts: add rk3288 dwc2 controller support
      ARM: dts: Enable USB host1(dwc) on rk3288-evb

Kumar Gala (1):
      ARM: qcom: Add initial IPQ8064 SoC and AP148 device trees

Laurent Pinchart (3):
      ARM: shmobile: r8a7790: Add DMAC clocks to DT
      ARM: shmobile: r8a7790: Add DMAC devices to DT
      ARM: shmobile: r8a7791: Add DMAC devices to DT

Lothar Waßmann (4):
      ARM: dts: imx28-tx28: remove spidev labels and add third instance of spidev
      ARM: dts: imx28-tx28: use GPIO flags
      ARM: dts: imx28-tx28: add spi-gpio as alternative for spi-mxs
      ARM: dts: imx28-tx28: add alias for CAN XCVR regulator

Lucas Stach (2):
      ARM: dts: imx6qdl-sabresd: add always on pcie regulator
      ARM: imx6: add pci config space as platform resource

Lucas Weaver (1):
      ARM: dts: DRA7: Add PMU nodes

Ludovic Desroches (1):
      ARM: at91: sama5d3: add usart dma configurations

Marc Kleine-Budde (1):
      ARM: dts: imx28: add pinmuxing for mmc1

Marek Belisko (10):
      ARM: dts: omap3-gta04: Add nand support
      ARM: dts: omap3-gta04: Fix magnetometer model
      ARM: dts: omap3-gta04: Add wifi reset node
      ARM: dts: omap3-gta04: Move spi gpio pins to pmx_core2
      ARM: dts: omap3-gta04: Add USB host support
      ARM: dts: omap3-gta04: Add display alias
      ARM: dts: omap3-gta04: Add twl4030 regulators parameters
      ARM: dts: omap3-gta04: Rename gta04.dts to gta04.dtsi and add a4 model
      ARM: dts: Add gta04a3 model
      ARM: dts: Add gta04a5 model

Marek Roszko (1):
      ARM: at91/dt: sama5d3: use new pinctrl compatible string

Mark Brown (3):
      ARM: dts: am335x-boneblack: Add names for remaining regulators
      ARM: zynq: Add ISL9305 regulator on Parallella board
      ARM: bcm2835: add I2S pinctrl to device tree

Markus Pargmann (1):
      ARM: dts: imx25: remove imx35-sdma compatible

Matthias Brugger (5):
      ARM: dts: Build dtb for Mediatek board
      ARM: dts: mt6589: Fix typo in GIC unit address
      ARM: dts: mt6589-aquaris5: Add boot argument earlyprintk
      ARM: dts: mediatek: Add compatible property for aquaris5
      ARM: dts: mt6589: Change compatible string for GIC

Maxime Ripard (5):
      ARM: at91/dt: Declare a second ram controller when relevant
      ARM: at91/dt: sama5d3: Add shutdown controller
      ARM: sun6i: Relicense the A31 DTSI under GPLv2/X11
      ARM: sun7i: Relicense the A20 DTSI under GPLv2/X11
      ARM: sun8i: Relicense the A23 DTSI under GPLv2/X11

Michael Grzeschik (1):
      ARM: dts: imx25-pinfunc: Add several pin configurations

Michael Olbrich (2):
      ARM: dts: nitrogen6x: add i2c2
      ARM: dts: nitrogen6x: add hdmi

Michal Simek (5):
      ARM: zynq: DT: Update years in header
      ARM: zynq: DT: Use 0x prefix for memory nodes
      ARM: zynq: DT: Extend compatible string for zedboard
      ARM: zynq: DT: Describe interrupt-names for pl330
      ARM: zynq: DT: Fix coding style issues in dtsi

Mikhail Ulyanov (2):
      ARM: shmobile: r8a7790: Add JPU clock dt and CPG define.
      ARM: shmobile: r8a7791: Add JPU clock dt and CPG define.

Mikko Perttunen (2):
      ARM: tegra: Add SATA controller to Tegra124 device tree
      ARM: tegra: Add SATA and SATA power to Jetson TK1 device tree

Naveen Krishna Chatradhi (1):
      ARM: dts: Add thermistor dts fragment used by exynos based Peach boards

Nicolas Ferre (1):
      Merge tag 'at91-dt-for-3.17' of git://git.kernel.org/.../mripard/linux

Nishanth Menon (6):
      ARM: OMAP2+: board-generic: add support for AM57xx family
      ARM: dts: OMAP5: switch to compatible pinctrl
      ARM: dts: DRA7: switch to compatible pinctrl
      ARM: dts: AM437x: switch to compatible pinctrl
      ARM: dts: OMAP5 / DRA7: switch over to interrupts-extended property for UART
      ARM: dts: dra7-evm: Mark uart1 rxd as wakeup capable

Olof Johansson (7):
      Merge tag 'dt-for-v3.18' of git://git.kernel.org/.../tmlind/linux-omap into next/dt
      Merge tag 'qcom-dt-for-3.18' of git://git.kernel.org/.../galak/linux-qcom into next/dt
      Merge tag 'qcom-dt-for-3.18-2' of git://git.kernel.org/.../galak/linux-qcom into next/dt
      Merge tag 'v3.18-rockchip-dts2-v2' of git://git.kernel.org/.../mmind/linux-rockchip into next/dt
      Merge tag 'mvebu-dt-3.18' of git://git.infradead.org/linux-mvebu into next/dt
      Merge tag 'imx-dt-3.18' of git://git.kernel.org/.../shawnguo/linux into next/dt
      Revert "ARM: dts: hix5hd2: add wdg node"

Pawel Moll (1):
      ARM: vexpress: Add CLCD Device Tree properties

Peter Ujfalusi (6):
      ARM: davinci: da8xx-dt: add OF_DEV_AUXDATA entry for mcasp0
      ARM: DTS: da850: Add node for edma0
      ARM: DTS: da850: Add node for McASP
      ARM: DTS: da850-evm: Enable McASP via DT boot
      ARM: DTS: da850-evm: Add node for tlv320aic3106 codec
      ARM: DTS: da850-evm: Enable audio via simple-card

Philipp Zabel (3):
      ARM: mvebu: Change vendor prefix for Intersil Corporation to isil
      ARM: dts: nitrogen6x: add i2c3
      ARM: dts: nitrogen6x: Add Intersil ISL1208 RTC

Philippe Reynes (1):
      ARM: dts: apf27dev: add max1027 in the dts

Pramod Gurav (2):
      ARM: DT: APQ8064: Add pinctrl support
      ARM: DT: APQ8064: Add node for ps_hold function in pinctrl

Rabeeh Khoury (3):
      ARM: dts: hummingboard: Split HummingBoard DT to support s/dl and d/q
      ARM: dts: hummingboard: add mSATA support for iMX6 quad/dual HummingBoard
      ARM: dts: hummingboard: gpio-ir on gpio 3,5

Rahul Sharma (2):
      ARM: dts: add hdmi regulators for exynos5800-peach-pi
      ARM: dts: add hdmi regulators for exynos5420-peach-pit

Romain Perier (1):
      ARM: dts: rockchip: Remove "regulator-always-on" in vcc_rmii for Radxa Rock

Russell King (1):
      ARM: dts: hummingboard: fix configuration of IR input

Sergei Shtylyov (2):
      ARM: shmobile: r8a7791: add VIN DT support
      ARM: shmobile: henninger: add VIN0/ADV7180 DT support

Shawn Guo (2):
      Merge tag 'ib-mfd-arm-v3.18' into imx/dt
      Merge branch 'imx/soc' into imx/dt

Shengjiu Wang (2):
      ARM: dts: imx6qdl: add baud clock and clock-names for ssi
      ARM: dts: imx6sl: add baud clock and clock-names for ssi

Simon Horman (1):
      ARM: shmobile: lager: correct memory map

Sjoerd Simons (1):
      ARM: dts: Add support Atmel touchpad for exynos5420-peach-pit

Soren Brinkmann (3):
      ARM: zynq: DT: Fix Ethernet phy modes
      ARM: zynq: DT: Move size/address properties to dtsi
      ARM: zynq: DT: Add Ethernet phys

Srinivas Kandagatla (3):
      ARM: DT: apq8064: Add sdcc support via mcci driver.
      ARM: DT: QCOM: apq8064: Add dma support for sdcc node
      ARM: DT: apq8064: add support to sdcc4 for wlan.

Stefan Agner (5):
      ARM: dts: vf610-colibri: split device tree for carrier boards
      ARM: dts: vf610: Add USB PHY and controller
      ARM: dts: vf610: Add usbmisc for non-core registers
      ARM: dts: vf610-colibri: Add USB support
      ARM: dts: vf610-twr: Add USB support

Stefan Roese (4):
      ARM: OMAP2+: tao3530: Add pdata-quirk for the mmc2 internal clock
      ARM: dts: omap3: Add Technexion TAO3530 SOM omap3-tao3530.dtsi
      ARM: dts: omap3: Add Technexion Thunder support (TAO3530 SOM based)
      ARM: dts: omap3: Add HEAD acoustics omap3-ha.dts and omap3-ha-lcd.dts (TAO3530 based)

Steffen Trumtrar (1):
      ARM: dts: i.MX53: add pmu node

Stephen Boyd (5):
      ARM: dts: msm: Add 8921 PMIC to ssbi bus
      ARM: dts: msm: Add 8058 PMIC to ssbi bus
      ARM: dts: qcom: Add 8064 multimedia clock controller node
      ARM: DT: msm8660: Add sdcc nodes
      ARM: DT: msm8960: Add sdcc nodes

Stephen Warren (3):
      ARM: tegra: add PCIe-related pins to the Jetson TK1 pinmux tables
      ARM: tegra: add touchpad to Venice2 DT
      ARM: tegra: rely on bootloader pinmux programming on Tegra124

Steve Twiss (1):
      devicetree: Dialog Semiconductor consolidate existing vendor prefixes to standardise on 'dlg'

Suman Anna (1):
      ARM: dts: OMAP2+: Add sub mailboxes device node information

Thierry Reding (3):
      ARM: tegra: Add device tree nodes for flow controller
      ARM: tegra: add PCIe to Tegra124 DT
      ARM: tegra: enable PCIe in Jetson TK1 DT

Thomas Petazzoni (4):
      ARM: mvebu: add gpio fan support to Armada 370 RD
      ARM: mvebu: add user LED support of Armada 370 RD
      Documentation: arm: add hardware datasheet reference for Marvell Armada XP
      ARM: mvebu: switch the Armada 370 RD board to internal registers at 0xf1000000

Thor Thayer (1):
      arm: dts: Add Altera SDRAM EDAC bindings & devicetree entries.

Tim Harvey (7):
      ARM: dts: Gateworks GW5520 support (i.MX6)
      ARM: dts: imx: ventana: remove unsupported dt nodes
      ARM: dts: imx: ventana: remove unused aliases
      ARM: dts: imx: ventana: use gpio constants
      ARM: dts: imx: ventana: configure padconf for all pins
      ARM: dts: imx: ventana: cleanup pinctrl groups
      ARM: dts: imx: ventana: add canbus support for GW52xx

Tomi Valkeinen (1):
      ARM: dts: omap5.dtsi: add DSS RFBI node

Tony Lindgren (7):
      Merge branch 'omap-for-v3.17/dt' into omap-for-v3.18/dt
      Merge branch 'pull/v3.18/for-dt-pinctrl-updates' of https://github.com/nmenon/linux-2.6-playground into omap-for-v3.18/dt
      ARM: dts: omap3-overo: Fix UART wake-up events
      ARM: dts: omap: Remove WAKEUPENABLE mux options for UARTs
      ARM: dts: Do not set pulls for I2C lines
      ARM: dts: Add support for Ethernet on some N900 macro boards
      ARM: dts: Enable PMIC idle configuration for LDP

Ulrich Hecht (3):
      ARM: shmobile: r8a7740: clock register bits
      ARM: shmobile: Initial r8a7794 SoC device tree
      ARM: shmobile: Initial Alt board device tree

Uwe Kleine-König (1):
      ARM: dts: imx28: add alternative pinmuxing for i2c1

Wills Wang (2):
      ARM: dts: sun7i: Add uart3/4/5, i2c3 and spi2 pinmux
      ARM: dts: sun7i: Add Merrii A20 Hummingbird board

Zhangfei Gao (6):
      ARM: dts: hix5hd2: add gmac node
      ARM: dts: hix5hd2: add mmc node
      ARM: dts: hix5hd2: add usb node
      ARM: dts: hix5hd2: add sata node
      ARM: dts: hix5hd2: add gpio node
      ARM: dts: hix5hd2: add wdg node

huang lin (1):
      ARM: dts: Add SPI nodes to rk3288

kiran.padwal@smartplayin.com (2):
      ARM: dts: qcom: Add I2C dt node for MSM8974 and DB8074 board
      ARM: DT: apq8064: Add i2c device nodes

sergei.shtylyov@cogentembedded.com (1):
      ARM: shmobile: koelsch: add VIN1/ADV7180 DT support


 Documentation/arm/Marvell/README                   |    4 +
 .../bindings/arm/altera/socfpga-sdram-edac.txt     |   15 +
 Documentation/devicetree/bindings/arm/amlogic.txt  |    8 +
 .../devicetree/bindings/arm/geniatech.txt          |    5 +
 Documentation/devicetree/bindings/arm/mediatek.txt |    6 +
 .../devicetree/bindings/arm/omap/omap.txt          |   12 +
 Documentation/devicetree/bindings/arm/shmobile.txt |   71 ++
 .../devicetree/bindings/i2c/trivial-devices.txt    |    2 +-
 .../devicetree/bindings/pci/fsl,imx6q-pcie.txt     |    4 +-
 .../devicetree/bindings/regulator/da9210.txt       |    4 +-
 .../devicetree/bindings/vendor-prefixes.txt        |    3 +
 MAINTAINERS                                        |    7 +-
 arch/arm/boot/dts/Makefile                         |   25 +-
 arch/arm/boot/dts/am335x-bone-common.dtsi          |    5 +
 arch/arm/boot/dts/am33xx.dtsi                      |    4 +
 arch/arm/boot/dts/am4372.dtsi                      |    8 +-
 arch/arm/boot/dts/armada-370-db.dts                |    6 +
 arch/arm/boot/dts/armada-370-mirabox.dts           |    6 +
 arch/arm/boot/dts/armada-370-netgear-rn102.dts     |    6 +-
 arch/arm/boot/dts/armada-370-netgear-rn104.dts     |    8 +-
 arch/arm/boot/dts/armada-370-rd.dts                |   47 +-
 arch/arm/boot/dts/armada-370-xp.dtsi               |    4 +-
 arch/arm/boot/dts/armada-370.dtsi                  |   23 +
 arch/arm/boot/dts/armada-375.dtsi                  |    6 +
 arch/arm/boot/dts/armada-xp-netgear-rn2120.dts     |    2 +-
 arch/arm/boot/dts/at91sam9263.dtsi                 |   10 +-
 arch/arm/boot/dts/at91sam9g20.dtsi                 |    4 +
 arch/arm/boot/dts/at91sam9g45.dtsi                 |   47 +-
 arch/arm/boot/dts/at91sam9m10g45ek.dts             |    4 +
 arch/arm/boot/dts/at91sam9n12.dtsi                 |    2 +
 arch/arm/boot/dts/at91sam9n12ek.dts                |    2 +
 arch/arm/boot/dts/at91sam9rl.dtsi                  |    4 +-
 arch/arm/boot/dts/at91sam9x5.dtsi                  |    4 +-
 arch/arm/boot/dts/bcm2835-rpi-b.dts                |    8 +-
 arch/arm/boot/dts/bcm2835.dtsi                     |    1 +
 arch/arm/boot/dts/cros-adc-thermistors.dtsi        |   44 +
 arch/arm/boot/dts/da850-evm.dts                    |   72 ++
 arch/arm/boot/dts/da850.dtsi                       |   19 +
 arch/arm/boot/dts/dra7-evm.dts                     |    2 +
 arch/arm/boot/dts/dra7.dtsi                        |   24 +-
 arch/arm/boot/dts/dra72-evm.dts                    |  120 +++
 arch/arm/boot/dts/dra72x.dtsi                      |    5 +
 arch/arm/boot/dts/dra74x.dtsi                      |    6 +
 arch/arm/boot/dts/exynos4412-odroid-common.dtsi    |    8 +-
 arch/arm/boot/dts/exynos4412-origen.dts            |    8 +-
 arch/arm/boot/dts/exynos4412-trats2.dts            |    8 +-
 arch/arm/boot/dts/exynos5250-arndale.dts           |   22 +-
 arch/arm/boot/dts/exynos5250-cros-common.dtsi      |  164 ---
 arch/arm/boot/dts/exynos5250-smdk5250.dts          |   18 +-
 arch/arm/boot/dts/exynos5250-snow.dts              |  195 +++-
 arch/arm/boot/dts/exynos5250.dtsi                  |   15 -
 arch/arm/boot/dts/exynos5260-xyref5260.dts         |   18 +-
 arch/arm/boot/dts/exynos5410-smdk5410.dts          |   18 +-
 arch/arm/boot/dts/exynos5420-arndale-octa.dts      |   16 +-
 arch/arm/boot/dts/exynos5420-peach-pit.dts         |  482 ++++++++-
 arch/arm/boot/dts/exynos5420-smdk5420.dts          |   16 +-
 arch/arm/boot/dts/exynos5800-peach-pi.dts          |  472 +++++++-
 arch/arm/boot/dts/imx1-ads.dts                     |  152 +++
 arch/arm/boot/dts/imx1-apf9328.dts                 |  129 +++
 arch/arm/boot/dts/imx1-pinfunc.h                   |  302 ++++++
 arch/arm/boot/dts/imx1.dtsi                        |  266 +++++
 arch/arm/boot/dts/imx23-evk.dts                    |    4 +-
 arch/arm/boot/dts/imx25-pinfunc.h                  |   33 +-
 arch/arm/boot/dts/imx25.dtsi                       |    4 +-
 arch/arm/boot/dts/imx27-apf27dev.dts               |   17 +
 arch/arm/boot/dts/imx28-apf28dev.dts               |    4 +-
 arch/arm/boot/dts/imx28-apx4devkit.dts             |    4 +-
 arch/arm/boot/dts/imx28-cfa10049.dts               |    4 +-
 arch/arm/boot/dts/imx28-cfa10055.dts               |    4 +-
 arch/arm/boot/dts/imx28-cfa10056.dts               |    4 +-
 arch/arm/boot/dts/imx28-cfa10057.dts               |    4 +-
 arch/arm/boot/dts/imx28-cfa10058.dts               |    4 +-
 arch/arm/boot/dts/imx28-evk.dts                    |    4 +-
 arch/arm/boot/dts/imx28-m28cu3.dts                 |    4 +-
 arch/arm/boot/dts/imx28-m28evk.dts                 |    4 +-
 arch/arm/boot/dts/imx28-tx28.dts                   |  107 +-
 arch/arm/boot/dts/imx28.dtsi                       |   43 +
 arch/arm/boot/dts/imx35.dtsi                       |    1 +
 arch/arm/boot/dts/imx50.dtsi                       |    2 +
 arch/arm/boot/dts/imx51.dtsi                       |    3 +
 arch/arm/boot/dts/imx53-smd.dts                    |    2 +-
 arch/arm/boot/dts/imx53.dtsi                       |    8 +
 arch/arm/boot/dts/imx6dl-gw552x.dts                |   20 +
 arch/arm/boot/dts/imx6dl-hummingboard.dts          |  203 +---
 arch/arm/boot/dts/imx6q-gw5400-a.dts               |  203 ++--
 arch/arm/boot/dts/imx6q-gw552x.dts                 |   24 +
 arch/arm/boot/dts/imx6q-hummingboard.dts           |   21 +
 arch/arm/boot/dts/imx6qdl-gw51xx.dtsi              |  192 ++--
 arch/arm/boot/dts/imx6qdl-gw52xx.dtsi              |  314 +++---
 arch/arm/boot/dts/imx6qdl-gw53xx.dtsi              |  338 +++---
 arch/arm/boot/dts/imx6qdl-gw54xx.dtsi              |  278 +++--
 arch/arm/boot/dts/imx6qdl-gw552x.dtsi              |  267 +++++
 arch/arm/boot/dts/imx6qdl-hummingboard.dtsi        |  200 ++++
 arch/arm/boot/dts/imx6qdl-nitrogen6x.dtsi          |   38 +
 arch/arm/boot/dts/imx6qdl-phytec-pfla02.dtsi       |    2 +-
 arch/arm/boot/dts/imx6qdl-sabresd.dtsi             |   45 +-
 arch/arm/boot/dts/imx6qdl.dtsi                     |   24 +-
 arch/arm/boot/dts/imx6sl-evk.dts                   |  104 +-
 arch/arm/boot/dts/imx6sl.dtsi                      |   31 +-
 arch/arm/boot/dts/imx6sx-sdb.dts                   |   93 ++
 arch/arm/boot/dts/imx6sx.dtsi                      |    7 +-
 arch/arm/boot/dts/k2e.dtsi                         |   13 +
 arch/arm/boot/dts/k2hk.dtsi                        |   56 +
 arch/arm/boot/dts/k2l.dtsi                         |   46 +
 arch/arm/boot/dts/keystone.dtsi                    |   10 +-
 arch/arm/boot/dts/meson.dtsi                       |  105 ++
 arch/arm/boot/dts/meson6-atv1200.dts               |   66 ++
 arch/arm/boot/dts/meson6.dtsi                      |   78 ++
 arch/arm/boot/dts/mt6589-aquaris5.dts              |    5 +
 arch/arm/boot/dts/mt6589.dtsi                      |    4 +-
 arch/arm/boot/dts/omap2420.dtsi                    |    8 +
 arch/arm/boot/dts/omap2430.dtsi                    |    4 +
 arch/arm/boot/dts/omap3-beagle-xm.dts              |    4 +-
 .../boot/dts/{omap3-gta04.dts => omap3-gta04.dtsi} |  150 ++-
 arch/arm/boot/dts/omap3-gta04a3.dts                |   48 +
 arch/arm/boot/dts/omap3-gta04a4.dts                |   13 +
 arch/arm/boot/dts/omap3-gta04a5.dts                |   17 +
 arch/arm/boot/dts/omap3-ha-common.dtsi             |   88 ++
 arch/arm/boot/dts/omap3-ha-lcd.dts                 |  165 +++
 arch/arm/boot/dts/omap3-ha.dts                     |   28 +
 arch/arm/boot/dts/omap3-ldp.dts                    |    5 +
 arch/arm/boot/dts/omap3-n900.dts                   |   54 +-
 .../boot/dts/omap3-overo-common-peripherals.dtsi   |    5 +-
 arch/arm/boot/dts/omap3-tao3530.dtsi               |  337 ++++++
 arch/arm/boot/dts/omap3-thunder.dts                |  129 +++
 arch/arm/boot/dts/omap3.dtsi                       |    4 +
 arch/arm/boot/dts/omap4.dtsi                       |    8 +
 arch/arm/boot/dts/omap5-cm-t54.dts                 |  272 ++++-
 arch/arm/boot/dts/omap5-sbc-t54.dts                |    8 +-
 arch/arm/boot/dts/omap5.dtsi                       |   37 +-
 arch/arm/boot/dts/pxa2xx.dtsi                      |    4 +-
 arch/arm/boot/dts/qcom-apq8064-ifc6410.dts         |   43 +
 arch/arm/boot/dts/qcom-apq8064.dtsi                |  183 ++++
 arch/arm/boot/dts/qcom-apq8074-dragonboard.dts     |   21 +
 arch/arm/boot/dts/qcom-apq8084-ifc6540.dts         |   23 +
 arch/arm/boot/dts/qcom-apq8084-mtp.dts             |    6 +
 arch/arm/boot/dts/qcom-apq8084.dtsi                |   51 +
 arch/arm/boot/dts/qcom-ipq8064-ap148.dts           |   85 ++
 arch/arm/boot/dts/qcom-ipq8064-v1.0.dtsi           |    1 +
 arch/arm/boot/dts/qcom-ipq8064.dtsi                |  250 +++++
 arch/arm/boot/dts/qcom-msm8660-surf.dts            |   42 +
 arch/arm/boot/dts/qcom-msm8660.dtsi                |   93 ++
 arch/arm/boot/dts/qcom-msm8960-cdp.dts             |   27 +
 arch/arm/boot/dts/qcom-msm8960.dtsi                |   87 ++
 arch/arm/boot/dts/qcom-msm8974.dtsi                |   15 +-
 arch/arm/boot/dts/r8a73a4.dtsi                     |    6 +-
 arch/arm/boot/dts/r8a7779.dtsi                     |   16 +-
 arch/arm/boot/dts/r8a7790-lager.dts                |   40 +-
 arch/arm/boot/dts/r8a7790.dtsi                     |  127 ++-
 arch/arm/boot/dts/r8a7791-henninger.dts            |   35 +
 arch/arm/boot/dts/r8a7791-koelsch.dts              |   37 +-
 arch/arm/boot/dts/r8a7791.dtsi                     |  108 +-
 arch/arm/boot/dts/r8a7794-alt.dts                  |   47 +
 arch/arm/boot/dts/r8a7794.dtsi                     |  531 +++++++++
 arch/arm/boot/dts/rk3066a-bqcurie2.dts             |   15 +-
 arch/arm/boot/dts/rk3066a.dtsi                     |   67 ++
 arch/arm/boot/dts/rk3188-radxarock.dts             |   68 +-
 arch/arm/boot/dts/rk3188.dtsi                      |   69 ++
 arch/arm/boot/dts/rk3288-evb-act8846.dts           |   10 +-
 arch/arm/boot/dts/rk3288-evb-rk808.dts             |  132 +++
 arch/arm/boot/dts/rk3288-evb.dtsi                  |   87 ++
 arch/arm/boot/dts/rk3288.dtsi                      |  380 +++++++
 arch/arm/boot/dts/rk3xxx.dtsi                      |  109 +-
 arch/arm/boot/dts/sama5d3.dtsi                     |   37 +-
 arch/arm/boot/dts/sama5d3_can.dtsi                 |    2 +-
 arch/arm/boot/dts/sama5d3xcm.dtsi                  |   30 +
 arch/arm/boot/dts/sama5d3xmb.dtsi                  |    4 +
 arch/arm/boot/dts/sh73a0-kzm9g-reference.dts       |    4 +-
 arch/arm/boot/dts/sh73a0.dtsi                      |   24 +-
 arch/arm/boot/dts/socfpga.dtsi                     |   11 +
 arch/arm/boot/dts/socfpga_arria5.dtsi              |   11 +-
 arch/arm/boot/dts/socfpga_arria5_socdk.dts         |    7 -
 arch/arm/boot/dts/socfpga_cyclone5.dtsi            |   13 +-
 arch/arm/boot/dts/socfpga_cyclone5_socdk.dts       |    4 +
 arch/arm/boot/dts/socfpga_vt.dts                   |    9 +-
 arch/arm/boot/dts/sun4i-a10.dtsi                   |   19 +-
 arch/arm/boot/dts/sun5i-a10s.dtsi                  |   17 +-
 arch/arm/boot/dts/sun5i-a13-hsg-h702.dts           |  130 +++
 arch/arm/boot/dts/sun5i-a13.dtsi                   |   17 +-
 arch/arm/boot/dts/sun6i-a31.dtsi                   |   56 +-
 arch/arm/boot/dts/sun7i-a20-hummingbird.dts        |  236 ++++
 arch/arm/boot/dts/sun7i-a20-olinuxino-lime.dts     |  137 +++
 arch/arm/boot/dts/sun7i-a20.dtsi                   |  102 +-
 arch/arm/boot/dts/sun8i-a23-ippo-q8h-v5.dts        |   41 +
 arch/arm/boot/dts/sun8i-a23.dtsi                   |  237 +++-
 arch/arm/boot/dts/sunxi-common-regulators.dtsi     |    7 +
 arch/arm/boot/dts/tegra114.dtsi                    |    5 +
 arch/arm/boot/dts/tegra124-jetson-tk1.dts          |   98 +-
 arch/arm/boot/dts/tegra124-nyan-big.dts            | 1136 ++++++++++++++++++++
 arch/arm/boot/dts/tegra124-venice2.dts             |   18 +-
 arch/arm/boot/dts/tegra124.dtsi                    |  100 +-
 arch/arm/boot/dts/tegra20.dtsi                     |    5 +
 arch/arm/boot/dts/tegra30.dtsi                     |    5 +
 arch/arm/boot/dts/vexpress-v2m-rs1.dtsi            |   36 +-
 arch/arm/boot/dts/vexpress-v2m.dtsi                |   36 +-
 arch/arm/boot/dts/vexpress-v2p-ca9.dts             |   31 +
 arch/arm/boot/dts/vf610-colibri-eval-v3.dts        |   46 +
 .../dts/{vf610-colibri.dts => vf610-colibri.dtsi}  |   22 +-
 arch/arm/boot/dts/vf610-twr.dts                    |   25 +-
 arch/arm/boot/dts/vf610.dtsi                       |   60 +-
 arch/arm/boot/dts/zynq-7000.dtsi                   |   14 +-
 arch/arm/boot/dts/zynq-parallella.dts              |   27 +-
 arch/arm/boot/dts/zynq-zc702.dts                   |   18 +-
 arch/arm/boot/dts/zynq-zc706.dts                   |   12 +-
 arch/arm/boot/dts/zynq-zed.dts                     |   14 +-
 arch/arm/mach-at91/board-dt-sama5.c                |   22 -
 arch/arm/mach-davinci/da8xx-dt.c                   |    1 +
 arch/arm/mach-omap2/board-generic.c                |    4 +
 arch/arm/mach-omap2/pdata-quirks.c                 |    9 +
 arch/arm/mach-qcom/board.c                         |    2 +
 arch/arm/mach-rockchip/Kconfig                     |    1 +
 drivers/mfd/da9055-core.c                          |   26 +-
 include/dt-bindings/clock/r8a7790-clock.h          |    1 +
 include/dt-bindings/clock/r8a7791-clock.h          |    1 +
 include/dt-bindings/clock/r8a7794-clock.h          |   80 ++
 215 files changed, 11480 insertions(+), 1758 deletions(-)


