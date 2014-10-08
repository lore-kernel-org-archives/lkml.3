Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754745AbaJHU2j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 16:28:39 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:61323 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752084AbaJHU2h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 16:28:37 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: torvalds@linux-foundation.org
Cc: linux-arm-kernel@lists.infradead.org, arm@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL 3/7] ARM: SoC platform changes for 3.18
Date: Wed, 08 Oct 2014 22:28:03 +0200
Message-ID: <4025255.OsxNyNF2Ct@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1922034.HH2lvbiFi0@wuerfel>
References: <1922034.HH2lvbiFi0@wuerfel>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
X-Provags-ID: V02:K0:vlm1NM6uAW1g50q07a0zxPRUFtdnDJ7X1R/4MdYSvd9
 hhyapsi+OjzS4yxtT4jKUPiXCsjeMddoHKR2KCokz6/Z/3rDIc
 r5EKZmBYDZaEP7aPElmm3Fyivhozj/w4prSBhXPhlmBF9nsBYy
 bPssxWv/nIxRewi80OVK9K2Nb2BgfFGPKcMtkq79d2l4FW7zZj
 GvhFB17ElkR7rer04/mQO7NqnzEAgvDdg4XkAjIKm5W8n3ZaTI
 nGEnxrNb+kfQtlnXiMqAzlTO3vbXo2+UhGDuMmYGhtGTbDBVKD
 I8eLHL15LT9Aqj+GHKVu7A+5h4xIwmZftmaHmZz8WccCTOmCuw
 MxRKxJm7hmr/UkgKEYRo=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 69e273c0b0a3c337a521d083374c918dc52c666f:

  Linux 3.17-rc3 (2014-08-31 18:23:04 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/soc-for-linus

for you to fetch changes up to d8f0faa339b0beff6e055218e10b2982422db540:

  ARM: hisi: depend on ARCH_MULTI_V7 (2014-10-02 16:40:10 +0200)

----------------------------------------------------------------
ARM: SoC platform changes for 3.18

New and updated SoC support. Among the things new for this release are:

- at91: Added support for the new SAMA5D4 SoC, following the earlier SAMA5D3
- bcm: Added support for BCM63XX family of DSL SoCs
- hisi: Added support for HiP04 server-class SoC
- meson: Initial support for the Amlogic Meson6 (aka 8726MX) platform
- shmobile: added support for new r8a7794 (R-Car E2) automotive SoC

Noteworthy changes to existing SoC support are:

- imx: convert i.MX1 to device tree
- omap: lots of power management work
- omap: base support to enable moving to standard UART driver
- shmobile: lots of progress for multiplatform support, still ongoing

----------------------------------------------------------------
Alexander Shiyan (6):
      ARM: i.MX: Remove mach-cpuimx27sd board file
      ARM: i.MX: Remove Phytec i.MX27 PCM038/PCM970 board files
      ARM: i.MX: Remove i.MX1 ADS board support
      ARM: clps711x: edb7211: Use new PWM driver for backlight
      ARM: clps711x: Add SOC BUS support
      ARM: i.MX1: Add devicetree support

Alexander Stein (1):
      ARM: imx: iomux: Do not export symbol without public declaration

Alexandre Belloni (3):
      clk: at91: add a driver for the h32mx clock
      ARM: at91: add sama5d4 support to sama5_defconfig
      ARM: at91: document Atmel SMART compatibles

Anson Huang (3):
      ARM: imx: add cpufreq support for i.mx6sx
      ARM: imx: add gpt_3m clk for i.mx6qdl
      ARM: imx: source gpt per clk from OSC for system timer

Arnd Bergmann (21):
      Merge tag 'renesas-soc-for-v3.18' of git://git.kernel.org/.../horms/renesas into next/soc
      Merge tag 'renesas-init-delay-for-v3.18' of git://git.kernel.org/.../horms/renesas into next/soc
      Merge tag 'renesas-soc2-for-v3.18' of git://git.kernel.org/.../horms/renesas into next/soc
      Merge tag 'renesas-r8a7740-ccf-and-timers-for-v3.18' of git://git.kernel.org/.../horms/renesas into next/soc
      Merge tag 'renesas-dt-timers-for-v3.18' of git://git.kernel.org/.../horms/renesas into next/soc
      Merge tag 'renesas-cleanup-for-v3.18' of git://git.kernel.org/.../horms/renesas into next/soc
      Merge tag 'renesas-clk-for-v3.18' of git://git.kernel.org/.../horms/renesas into next/soc
      Merge tag 'integrator-for-v3.18-1' of git://git.kernel.org/.../linusw/linux-integrator into next/soc
      Merge tag 'renesas-r8a7740-multiplatform-for-v3.18' of git://git.kernel.org/.../horms/renesas into next/soc
      Merge tag 'renesas-soc3-for-v3.18' of git://git.kernel.org/.../horms/renesas into next/soc
      Merge tag 'renesas-dt-timers2-for-v3.18' of git://git.kernel.org/.../horms/renesas into next/soc
      Merge tag 'zynq-cleanup-for-3.18' of git://git.xilinx.com/linux-xlnx into next/soc
      Merge tag 'tegra-for-3.18-soc' of git://git.kernel.org/.../swarren/linux-tegra into next/soc
      Merge tag 'pxa3xx-ssp-name' of https://git.kernel.org/.../hzhuang1/linux into next/soc
      Merge tag 'renesas-soc5-for-v3.18' of git://git.kernel.org/.../horms/renesas into next/soc
      Merge tag 'bcm63138-v4' of http://github.com/brcm/linux into next/soc
      Merge tag 'soc-part2-for-v3.18' of git://git.kernel.org/.../tmlind/linux-omap into next/soc
      Merge branch 'at91/soc' into next/soc
      Merge tag 'at91-soc2' of git://github.com/at91linux/linux-at91 into next/soc
      ARM: at91: fix nommu build regression
      ARM: hisi: depend on ARCH_MULTI_V7

Carlo Caione (2):
      ARM: meson: debug: add debug UART for earlyprintk support
      ARM: meson: add basic support for MesonX SoCs

Daniel Lezcano (2):
      ARM: zynq: Remove invalidate cache for cpu die
      ARM: zynq: cpuidle: Remove pointless code

Daniel Mack (2):
      ARM: pxa: ssp: provide platform_device_id for PXA3xx
      ARM: pxa3xx: provide specific platform_devices for all ssp ports

Fabio Estevam (5):
      ARM: imx: Remove mach-mxt_td60 board file
      ARM: clk-imx6sl: Remove csi_lcdif_sels[]
      ARM: clk-imx6sl: Select appropriate parents for LCDIF clocks
      ARM: imx_v4_v5_defconfig: Select CONFIG_IMX_WEIM
      ARM: imx_v6_v7_defconfig updates

Fancy Fang (1):
      ARM: clk-imx6sl: correct the pxp and epdc axi clock selections

Florian Fainelli (5):
      ARM: BCM63XX: add basic support for the Broadcom BCM63138 DSL SoC
      ARM: BCM63XX: add low-level UART debug support
      ARM: BCM63XX: add BCM63138 minimal Device Tree
      ARM: BCM63XX: add BCM963138DVT Reference platform DTS
      MAINTAINERS: add entry for the Broadcom BCM63xx ARM SoCs

Geert Uytterhoeven (8):
      ARM: shmobile: r8a7778: Add missing call to shmobile_init_late()
      ARM: shmobile: kzm9g: Remove unneeded nr_irqs initialization
      ARM: shmobile: kzm9g-reference: Remove unneeded nr_irqs initialization
      ARM: shmobile: dma: Use defines instead of hardcoded numbers
      ARM: shmobile: sh7372: Remove unneeded nr_irqs initialization
      ARM: shmobile: sh73a0: Remove unneeded nr_irqs initialization
      ARM: shmobile: Move legacy INTC definitions from irqs.h to intc.h
      ARM: shmobile: r8a7740 legacy: Fix copied bug in comment

Haojian Zhuang (7):
      ARM: mcpm: support 4 clusters
      ARM: hisi: enable MCPM implementation
      ARM: hisi: enable HiP04
      document: dt: add the binding on HiP04
      ARM: dts: add hip04 dts
      ARM: config: enable hisilicon hip04
      ARM: debug: add HiP04 debug uart

Hisashi Nakamura (1):
      clk: shmobile: Add r8a7794 support

Jason Liu (1):
      ARM: i.MX6: add more chip revision support

Joe Perches (1):
      arm: mach-imx: Convert pr_warning to pr_warn

Josef Holzmayr (1):
      ARM: at91: Remove the support for the RSI EWS board

Keerthy (1):
      ARM: AM437x: use pdata quirks for pinctrl information

Krzysztof Hałasa (1):
      CNS3xxx: Fix debug UART.

Laurent Pinchart (11):
      ARM: shmobile: r8a7790: Add CMT devices to DT
      ARM: shmobile: r8a7791: Add CMT devices to DT
      ARM: shmobile: r8a7779: Add TMU devices to DT
      ARM: shmobile: lager-reference: Enable CMT0 in device tree
      ARM: shmobile: koelsch-reference: Enable CMT0 in device tree
      ARM: shmobile: marzen-reference: Enable TMU0 in device tree
      ARM: shmobile: r7s72100: Add MTU2 device to DT
      ARM: shmobile: genmai-reference: Enable MTU2 in device tree
      ARM: shmobile: r7s72100: genmai: Remove reference board file
      ARM: shmobile: r7s72100: genmai: Remove legacy board file
      ARM: shmobile: r7s72100: Remove legacy board support

Linus Walleij (1):
      ARM: integrator: add MMCI device to IM-PD1

Magnus Damm (32):
      ARM: shmobile: kzm9g: Add shmobile_init_late()
      ARM: shmobile: marzen: Add shmobile_init_late()
      ARM: shmobile: bockw: Add shmobile_init_late()
      ARM: shmobile: ape6evm: Add shmobile_init_late()
      ARM: shmobile: ape6evm: Use shmobile_init_delay()
      ARM: shmobile: marzen: Remove NR_IRQS_LEGACY
      ARM: shmobile: sh73a0: Add shmobile_init_late()
      ARM: shmobile: r8a7779: Fix shmobile_init_late()
      ARM: shmobile: r8a7778: Fix shmobile_init_late()
      ARM: shmobile: r8a73a4: Add shmobile_init_late()
      ARM: shmobile: r7s72100: Add shmobile_init_late()
      ARM: shmobile: Rework multiplatform include workaround
      ARM: shmobile: r8a7779: Remove NR_IRQS_LEGACY
      ARM: shmobile: sh7372: Update DTS to include CPU frequency
      ARM: shmobile: sh73a0: Update DTS to include CPU frequency
      ARM: shmobile: r8a7778: Update DTS to include CPU frequency
      ARM: shmobile: sh7372: Use shmobile_init_delay()
      ARM: shmobile: r8a73a4: Use shmobile_init_delay()
      ARM: shmobile: Remove shmobile_setup_delay()
      ARM: shmobile: sh73a0: Use shmobile_init_delay()
      ARM: shmobile: r8a7778: Use shmobile_init_delay()
      ARM: shmobile: bockw: Use shmobile_init_delay()
      ARM: shmobile: kzm9g: Use shmobile_init_delay()
      ARM: shmobile: sh73a0: Remove duplicate CPUFreq bits
      ARM: shmobile: ape6evm: Remove duplicate CPUFreq bits
      ARM: shmobile: r8a7740: Multiplatform support
      ARM: shmobile: armadillo800eva: Sync DTS
      ARM: shmobile: armadillo800eva: Build DTS for multiplatform
      ARM: shmobile: r8a7740: Add restart callback
      ARM: shmobile: armadillo800eva reference: Remove C board code
      ARM: shmobile: armadillo800eva reference: Remove DTS
      ARM: shmobile: r8a7794: Reserve memory as other R-Car Gen2 SoCs

Mark Brown (1):
      ARM: omap: Remove stray ARCH_HAS_OPP references

Matthias Brugger (1):
      ARM: mediatek: Add earlyprintk support for mt6589

Michal Simek (1):
      ARM: zynq: Remove useless L2C AUX setting

Nicolas Ferre (5):
      ARM: at91: remove board file for Acme Systems Fox G20
      ARM: at91: introduce basic SAMA5D4 support
      ARM: at91: SAMA5D4 SoC detection code and low level routines
      ARM: at91: dt: add device tree file for SAMA5D4 SoC
      ARM: at91: dt: add device tree file for SAMA5D4ek board

Nishanth Menon (19):
      ARM: dts: omap4-panda: Fix model and SoC family details
      ARM: dts: am335x-bone*: Fix model name and update compatibility information
      ARM: OMAP4+: prminst: provide function to find prm_dev instance offset
      ARM: OMAP4: PRM: use the generic prm_inst to allow logic to be abstracted
      ARM: OMAP4+: PRM: register interrupt information from DT
      ARM: OMAP4+: PRM: remove "wkup" event
      ARM: OMAP4+: PRM: Enable wakeup capability for OMAP5, DRA7
      ARM: OMAP3+: PRM: register interrupt information from DT
      ARM: OMAP: DRA7: powerdomain data: fix powerdomain powerstate
      ARM: OMAP5: powerdomain data: fix powerdomain powerstate
      ARM: OMAP2+: powerdomain: pwrdm_for_each_clkdm iterate only valid clkdms
      ARM: OMAP2+: powerdomain: introduce logic for finding valid power domain
      ARM: OMAP4+: PM: Make logic state programmable
      ARM: OMAP4+: PM: use only valid low power state for suspend
      ARM: OMAP4+: PM: Use only valid low power state for CPU hotplug
      ARM: OMAP5: use pdata quirks for pinctrl information
      ARM: DRA7: use pdata quirks for pinctrl information
      ARM: dts: OMAP3+: Add PRM interrupt
      ARM: OMAP5+: Reuse OMAP4 PM code for OMAP5 and DRA7

Olof Johansson (6):
      Merge tag 'soc-for-v3.18' of git://git.kernel.org/.../tmlind/linux-omap into next/soc
      Merge tag 'renesas-clk2-for-v3.18' of git://git.kernel.org/.../horms/renesas into next/soc
      Merge tag 'D01-for-3.18' of git://github.com/hisilicon/linux-hisi into next/soc
      ARM: debug: fix alphanumerical order on debug uarts
      Merge tag 'renesas-soc4-for-v3.18' of git://git.kernel.org/.../horms/renesas into next/soc
      Merge tag 'imx-soc-3.18' of git://git.kernel.org/.../shawnguo/linux into next/soc

Rajendra Nayak (6):
      ARM: OMAP5 / DRA7: PM: Avoid all SAR saves
      ARM: OMAP5 / DRA7: Enable CPU RET on suspend
      ARM: DRA7: Add hook in SoC initcalls to enable pm initialization
      ARM: AM335x: Get rid of unused sram init function
      ARM: OMAP4+: Move SRAM data to DT
      ARM: OMAP4+: Remove static iotable mappings for SRAM

Rasmus Villemoes (1):
      ARM: tegra: remove unused tegra_emc.h

Santosh Shilimkar (6):
      ARM: OMAP5 / DRA7: PM: Update CPU context register offset
      ARM: OMAP5 / DRA7: PM: Set MPUSS-EMIF clock-domain static dependency
      ARM: OMAP5 / DRA7: PM / wakeupgen: Enables ES2 PM mode by default
      ARM: OMAP5 / DRA7: PM: Enable Mercury retention mode on CPUx powerdomains
      ARM: OMAP5 / DRA7: PM: Provide a dummy startup function for CPU hotplug
      ARM: OMAP5: Add hook in SoC initcalls to enable pm initialization

Shawn Guo (7):
      ARM: imx: remove imx_scu_standby_enable()
      ARM: imx: add an exclusive gate clock type
      ARM: imx6q: add BYPASS support for PLL clocks
      ARM: imx6sl: add BYPASS support for PLL clocks
      ARM: imx6sx: add BYPASS support for PLL clocks
      ARM: imx: remove ENABLE and BYPASS bits from clk-pllv3 driver
      ARM: imx: fix register offset of pll7_usb_host gate clock

Shengjiu Wang (4):
      ARM: clk-imx6q: refine clock tree for ESAI
      ARM: clk-imx6q: refine clock tree for ASRC
      ARM: clk-imx6q: refine clock tree for SSI
      ARM: clk-imx6sl: refine clock tree for SSI

Simon Horman (12):
      Merge branch 'boards-for-v3.18' into soc-init-delay-for-v3.18.base
      ARM: shmobile: r8a7740: Add CMT1 device to DT
      ARM: shmobile: armadillo800eva-reference: Enable CMT1 in device tree
      ARM: shmobile: armadillo800eva-reference: Do not use r8a7740_add_standard_devices_dt()
      ARM: shmobile: r8a7740: Remove r8a7740_add_standard_devices_dt
      Merge tag 'renesas-r8a7740-ccf-and-timers-for-v3.18' into dt-timers-for-v3.18
      ARM: shmobile: r8a7790: Use SoC-specific 48-bit CMT compat string
      ARM: shmobile: r7s72100: Use SoC-specific MTU2 compat string
      ARM: shmobile: r8a7791: Use SoC-specific 48-bit CMT compat string
      ARM: shmobile: r8a7779: Use SoC-specific TMU compat string
      ARM: shmobile: r8a7740: Use SoC-specific 48-bit CMT compat string
      ARM: shmobile: r8a7794: Remove unnecessary #ifdef CONFIG_USE_OF

Soren Brinkmann (7):
      ARM: zynq: PM: Enable A9 internal clock gating feature
      Documentation: devicetree: Add binding for Synopsys DDR controller
      ARM: zynq: DT: Add DDRC node
      ARM: zynq: PM: Enable DDR clock stop
      ARM: zynq: Synchronise zynq_cpu_die/kill
      ARM: zynq: Remove hotplug.c
      ARM: zynq: Rename 'zynq_platform_cpu_die'

Stefan Agner (2):
      ARM: imx: clk-vf610: introduce clks_init_on
      ARM: imx: clk-vf610: Add USBPHY clocks

Thierry Reding (2):
      of: Add NVIDIA Tegra flow controller bindings
      ARM: tegra: Initialize flow controller from DT

Tony Lindgren (9):
      Merge branch 'pull/v3.18/powerdomain-fixes' of https://github.com/nmenon/linux-2.6-playground into omap-for-v3.18/fixes-not-urgent
      Merge branch 'pull/v3.18/for-omap-soc' of https://github.com/nmenon/linux-2.6-playground into omap-for-v3.18/soc
      ARM: OMAP2+: Add hwmod flag for HWMOD_RECONFIG_IO_CHAIN
      ARM: OMAP3: Use manual idle for UARTs because of DMA errata
      ARM: omap2plus_defconfig: Shrink with savedefconfig
      ARM: omap2plus_defconfig: Add cpufreq to defconfig
      ARM: omap2plus_defconfig: Add support for distros with systemd
      ARM: omap2plus_defconfig: Enable battery and reset drivers
      ARM: omap2plus_defconfig: Enable some display features

Ulrich Hecht (9):
      ARM: shmobile: r8a7740: clock register bits
      ARM: shmobile: r8a7740: add SoC clocks to DTS
      ARM: shmobile: r8a7740: add MSTP clock assignments to DT
      ARM: shmobile: armadillo800eva-reference: add clock overrides to DTS
      ARM: shmobile: support Cortex-A7 in shmobile_init_delay()
      ARM: shmobile: Initial r8a7794 SoC support
      ARM: shmobile: sh73a0: Add CMT1 device to DT
      ARM: shmobile: kzm9g-reference: Enable CMT1 in device tree
      clk: shmobile: Add r8a7740, sh73a0 SoCs to MSTP bindings

Vincent Stehlé (1):
      irq: Export handle_fasteoi_irq

Wei Xu (1):
      ARM: hisi: Fix platmcpm compilation when ARMv6 is selected

Xiubo Li (1):
      ARM: dts: vf610-twr: remove useless property for sound card.

 .../devicetree/bindings/arm/atmel-at91.txt         |   37 +
 .../devicetree/bindings/arm/bcm/bcm63138.txt       |    9 +
 .../bindings/arm/hisilicon/hisilicon.txt           |   23 +
 Documentation/devicetree/bindings/arm/omap/mpu.txt |    3 +
 .../bindings/arm/tegra/nvidia,tegra20-flowctrl.txt |   12 +
 .../devicetree/bindings/clock/at91-clock.txt       |   14 +
 .../bindings/clock/renesas,cpg-mstp-clocks.txt     |    2 +
 .../bindings/memory-controllers/synopsys.txt       |   11 +
 MAINTAINERS                                        |    8 +
 arch/arm/Kconfig                                   |   12 +
 arch/arm/Kconfig.debug                             |   79 +-
 arch/arm/Makefile                                  |    1 +
 arch/arm/boot/dts/Makefile                         |    6 +-
 arch/arm/boot/dts/am335x-bone-common.dtsi          |    3 -
 arch/arm/boot/dts/am335x-bone.dts                  |    5 +
 arch/arm/boot/dts/am335x-boneblack.dts             |    5 +
 arch/arm/boot/dts/am33xx.dtsi                      |    5 +-
 arch/arm/boot/dts/am4372.dtsi                      |    5 +
 arch/arm/boot/dts/at91-sama5d4ek.dts               |  260 ++++
 arch/arm/boot/dts/bcm63138.dtsi                    |  134 +++
 arch/arm/boot/dts/bcm963138dvt.dts                 |   30 +
 arch/arm/boot/dts/dra7.dtsi                        |    1 +
 arch/arm/boot/dts/hip04-d01.dts                    |   32 +
 arch/arm/boot/dts/hip04.dtsi                       |  267 +++++
 arch/arm/boot/dts/omap3.dtsi                       |    1 +
 arch/arm/boot/dts/omap4-panda-common.dtsi          |    3 -
 arch/arm/boot/dts/omap4-panda-es.dts               |    5 +
 arch/arm/boot/dts/omap4-panda.dts                  |    5 +
 arch/arm/boot/dts/omap4.dtsi                       |    7 +
 arch/arm/boot/dts/omap5.dtsi                       |    9 +-
 arch/arm/boot/dts/r7s72100-genmai.dts              |    4 +
 arch/arm/boot/dts/r7s72100.dtsi                    |   10 +
 .../boot/dts/r8a7740-armadillo800eva-reference.dts |  283 -----
 arch/arm/boot/dts/r8a7740-armadillo800eva.dts      |  276 ++++-
 arch/arm/boot/dts/r8a7740.dtsi                     |  220 +++-
 arch/arm/boot/dts/r8a7778.dtsi                     |    6 +
 arch/arm/boot/dts/r8a7779-marzen.dts               |    4 +
 arch/arm/boot/dts/r8a7779.dtsi                     |   42 +
 arch/arm/boot/dts/r8a7790-lager.dts                |    4 +
 arch/arm/boot/dts/r8a7790.dtsi                     |   32 +
 arch/arm/boot/dts/r8a7791-koelsch.dts              |    4 +
 arch/arm/boot/dts/r8a7791.dtsi                     |   32 +
 arch/arm/boot/dts/sama5d4.dtsi                     | 1240 ++++++++++++++++++++
 arch/arm/boot/dts/sh7372.dtsi                      |    1 +
 arch/arm/boot/dts/sh73a0-kzm9g-reference.dts       |    4 +
 arch/arm/boot/dts/sh73a0.dtsi                      |   12 +
 arch/arm/boot/dts/vf610-twr.dts                    |    1 -
 arch/arm/boot/dts/zynq-7000.dtsi                   |    5 +
 arch/arm/configs/clps711x_defconfig                |    4 +-
 .../configs/{hi3xxx_defconfig => hisi_defconfig}   |   13 +
 arch/arm/configs/imx_v4_v5_defconfig               |   16 +-
 arch/arm/configs/imx_v6_v7_defconfig               |   10 +-
 arch/arm/configs/multi_v7_defconfig                |    1 +
 arch/arm/configs/omap2plus_defconfig               |   79 +-
 arch/arm/configs/sama5_defconfig                   |    1 +
 arch/arm/include/asm/mcpm.h                        |    5 +
 arch/arm/include/debug/bcm63xx.S                   |   33 +
 arch/arm/include/debug/meson.S                     |   35 +
 arch/arm/mach-at91/Kconfig                         |   21 +
 arch/arm/mach-at91/Kconfig.non_dt                  |   12 -
 arch/arm/mach-at91/Makefile                        |    3 +-
 arch/arm/mach-at91/board-dt-sama5.c                |   16 +-
 arch/arm/mach-at91/board-foxg20.c                  |  272 -----
 arch/arm/mach-at91/board-rsi-ews.c                 |  232 ----
 arch/arm/mach-at91/generic.h                       |    1 +
 arch/arm/mach-at91/include/mach/cpu.h              |   22 +-
 arch/arm/mach-at91/include/mach/debug-macro.S      |    5 +-
 arch/arm/mach-at91/include/mach/hardware.h         |   23 +-
 arch/arm/mach-at91/include/mach/sama5d4.h          |   33 +
 arch/arm/mach-at91/include/mach/uncompress.h       |   21 +-
 arch/arm/mach-at91/sama5d4.c                       |   64 +
 arch/arm/mach-at91/setup.c                         |   97 +-
 arch/arm/mach-at91/soc.h                           |    5 +
 arch/arm/mach-bcm/Kconfig                          |   17 +
 arch/arm/mach-bcm/Makefile                         |    3 +
 arch/arm/mach-bcm/bcm63xx.c                        |   27 +
 arch/arm/mach-clps711x/board-edb7211.c             |   37 +-
 arch/arm/mach-clps711x/devices.c                   |   52 +-
 arch/arm/mach-hisi/Kconfig                         |   11 +-
 arch/arm/mach-hisi/Makefile                        |    3 +
 arch/arm/mach-hisi/hisilicon.c                     |    9 +
 arch/arm/mach-hisi/platmcpm.c                      |  386 ++++++
 arch/arm/mach-imx/Kconfig                          |  111 +-
 arch/arm/mach-imx/Makefile                         |   10 +-
 arch/arm/mach-imx/anatop.c                         |   13 +
 arch/arm/mach-imx/board-pcm038.h                   |   36 -
 arch/arm/mach-imx/clk-gate-exclusive.c             |   94 ++
 arch/arm/mach-imx/clk-imx6q.c                      |   99 +-
 arch/arm/mach-imx/clk-imx6sl.c                     |  103 +-
 arch/arm/mach-imx/clk-imx6sx.c                     |   63 +-
 arch/arm/mach-imx/clk-pllv3.c                      |   37 -
 arch/arm/mach-imx/clk-vf610.c                      |   21 +-
 arch/arm/mach-imx/clk.h                            |    3 +
 arch/arm/mach-imx/common.h                         |    2 -
 arch/arm/mach-imx/cpuidle-imx6q.c                  |    4 -
 arch/arm/mach-imx/eukrea-baseboards.h              |   10 +-
 arch/arm/mach-imx/eukrea_mbimx27-baseboard.c       |  351 ------
 arch/arm/mach-imx/imx1-dt.c                        |   26 +
 arch/arm/mach-imx/iomux-imx31.c                    |    7 -
 arch/arm/mach-imx/iomux-v1.c                       |    2 -
 arch/arm/mach-imx/iomux-v3.c                       |    2 -
 arch/arm/mach-imx/mach-armadillo5x0.c              |    2 +-
 arch/arm/mach-imx/mach-cpuimx27.c                  |  321 -----
 arch/arm/mach-imx/mach-imx6sx.c                    |    3 +
 arch/arm/mach-imx/mach-mx1ads.c                    |  154 ---
 arch/arm/mach-imx/mach-mx31_3ds.c                  |    4 +-
 arch/arm/mach-imx/mach-mx31lite.c                  |    2 +-
 arch/arm/mach-imx/mach-mxt_td60.c                  |  273 -----
 arch/arm/mach-imx/mach-pcm037.c                    |    4 +-
 arch/arm/mach-imx/mach-pcm038.c                    |  358 ------
 arch/arm/mach-imx/mxc.h                            |    2 +
 arch/arm/mach-imx/pcm970-baseboard.c               |  231 ----
 arch/arm/mach-imx/platsmp.c                        |   10 -
 arch/arm/mach-imx/time.c                           |   31 +-
 arch/arm/mach-integrator/impd1.c                   |   48 +
 arch/arm/mach-meson/Kconfig                        |   13 +
 arch/arm/mach-meson/Makefile                       |    1 +
 arch/arm/mach-meson/meson.c                        |   27 +
 arch/arm/mach-omap2/Kconfig                        |    5 -
 arch/arm/mach-omap2/Makefile                       |   12 +-
 arch/arm/mach-omap2/common.h                       |    2 +-
 arch/arm/mach-omap2/io.c                           |   23 +-
 arch/arm/mach-omap2/omap-mpuss-lowpower.c          |  106 +-
 arch/arm/mach-omap2/omap-secure.h                  |    1 +
 arch/arm/mach-omap2/omap-wakeupgen.c               |   20 +-
 arch/arm/mach-omap2/omap-wakeupgen.h               |    1 +
 arch/arm/mach-omap2/omap4-common.c                 |   22 +-
 arch/arm/mach-omap2/omap_hwmod.c                   |    4 +-
 arch/arm/mach-omap2/omap_hwmod.h                   |    4 +
 arch/arm/mach-omap2/omap_hwmod_3xxx_data.c         |   12 +-
 arch/arm/mach-omap2/pdata-quirks.c                 |   10 +
 arch/arm/mach-omap2/pm.h                           |    1 +
 arch/arm/mach-omap2/pm44xx.c                       |   57 +-
 arch/arm/mach-omap2/powerdomain.c                  |   79 +-
 arch/arm/mach-omap2/powerdomain.h                  |    4 +
 arch/arm/mach-omap2/powerdomains54xx_data.c        |   12 +-
 arch/arm/mach-omap2/powerdomains7xx_data.c         |   14 +-
 arch/arm/mach-omap2/prm3xxx.c                      |   18 +
 arch/arm/mach-omap2/prm44xx.c                      |   90 +-
 arch/arm/mach-omap2/prminst44xx.c                  |   40 +-
 arch/arm/mach-omap2/prminst44xx.h                  |    3 +
 arch/arm/mach-omap2/sram.c                         |   39 +-
 arch/arm/mach-omap2/sram.h                         |    7 -
 arch/arm/mach-pxa/devices.c                        |   42 +-
 arch/arm/mach-pxa/devices.h                        |    3 +
 arch/arm/mach-pxa/pxa3xx.c                         |   14 +-
 arch/arm/mach-shmobile/Kconfig                     |   41 +-
 arch/arm/mach-shmobile/Makefile                    |    7 +-
 arch/arm/mach-shmobile/Makefile.boot               |    2 -
 arch/arm/mach-shmobile/board-ape6evm-reference.c   |    4 +-
 arch/arm/mach-shmobile/board-ape6evm.c             |    3 +-
 .../board-armadillo800eva-reference.c              |  198 ----
 arch/arm/mach-shmobile/board-bockw-reference.c     |    3 +-
 arch/arm/mach-shmobile/board-bockw.c               |    2 +-
 arch/arm/mach-shmobile/board-genmai-reference.c    |   55 -
 arch/arm/mach-shmobile/board-genmai.c              |  161 ---
 arch/arm/mach-shmobile/board-koelsch-reference.c   |    2 -
 arch/arm/mach-shmobile/board-kzm9g-reference.c     |    4 +-
 arch/arm/mach-shmobile/board-kzm9g.c               |    2 +-
 arch/arm/mach-shmobile/board-lager-reference.c     |    2 -
 arch/arm/mach-shmobile/board-mackerel.c            |    1 +
 arch/arm/mach-shmobile/board-marzen-reference.c    |   12 +-
 arch/arm/mach-shmobile/clock-r7s72100.c            |  231 ----
 arch/arm/mach-shmobile/common.h                    |    2 -
 arch/arm/mach-shmobile/dma-register.h              |    4 +-
 arch/arm/mach-shmobile/intc.h                      |    5 +
 arch/arm/mach-shmobile/irqs.h                      |    8 +-
 arch/arm/mach-shmobile/pm-r8a7740.c                |    7 +-
 arch/arm/mach-shmobile/r7s72100.h                  |    7 -
 arch/arm/mach-shmobile/r8a73a4.h                   |    1 -
 arch/arm/mach-shmobile/r8a7740.h                   |    5 +-
 arch/arm/mach-shmobile/r8a7779.h                   |    1 -
 arch/arm/mach-shmobile/r8a7790.h                   |    1 -
 arch/arm/mach-shmobile/r8a7791.h                   |    1 -
 arch/arm/mach-shmobile/setup-r7s72100.c            |   24 +-
 arch/arm/mach-shmobile/setup-r8a73a4.c             |   10 +-
 arch/arm/mach-shmobile/setup-r8a7740.c             |   34 +-
 arch/arm/mach-shmobile/setup-r8a7778.c             |    5 +-
 arch/arm/mach-shmobile/setup-r8a7779.c             |   20 +-
 arch/arm/mach-shmobile/setup-r8a7790.c             |    7 +-
 arch/arm/mach-shmobile/setup-r8a7791.c             |    7 +-
 arch/arm/mach-shmobile/setup-r8a7794.c             |   33 +
 arch/arm/mach-shmobile/setup-sh7372.c              |    4 +-
 arch/arm/mach-shmobile/setup-sh73a0.c              |   21 +-
 arch/arm/mach-shmobile/timer.c                     |   30 +-
 arch/arm/mach-tegra/flowctrl.c                     |   44 +-
 arch/arm/mach-tegra/flowctrl.h                     |    2 +
 arch/arm/mach-tegra/tegra.c                        |    2 +
 arch/arm/mach-zynq/Makefile                        |    3 +-
 arch/arm/mach-zynq/common.c                        |   11 +-
 arch/arm/mach-zynq/common.h                        |   16 +-
 arch/arm/mach-zynq/hotplug.c                       |   47 +-
 arch/arm/mach-zynq/platsmp.c                       |   41 +-
 arch/arm/mach-zynq/pm.c                            |   83 ++
 arch/arm/mach-zynq/slcr.c                          |   43 +-
 arch/arm/plat-pxa/ssp.c                            |    1 +
 drivers/clk/at91/Makefile                          |    1 +
 drivers/clk/at91/clk-h32mx.c                       |  123 ++
 drivers/clk/at91/pmc.c                             |    6 +
 drivers/clk/at91/pmc.h                             |    5 +
 drivers/clk/shmobile/Makefile                      |    1 +
 drivers/cpuidle/cpuidle-zynq.c                     |   10 +-
 include/dt-bindings/clock/imx6qdl-clock.h          |   35 +-
 include/dt-bindings/clock/imx6sl-clock.h           |   30 +-
 include/dt-bindings/clock/imx6sx-clock.h           |   25 +-
 include/dt-bindings/clock/r8a7740-clock.h          |   77 ++
 include/dt-bindings/clock/vf610-clock.h            |    5 +-
 include/linux/clk/at91_pmc.h                       |    1 +
 include/linux/platform_data/tegra_emc.h            |   34 -
 kernel/irq/chip.c                                  |    1 +
 210 files changed, 5486 insertions(+), 3994 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/arm/bcm/bcm63138.txt
 create mode 100644 Documentation/devicetree/bindings/arm/tegra/nvidia,tegra20-flowctrl.txt
 create mode 100644 Documentation/devicetree/bindings/memory-controllers/synopsys.txt
 create mode 100644 arch/arm/boot/dts/at91-sama5d4ek.dts
 create mode 100644 arch/arm/boot/dts/bcm63138.dtsi
 create mode 100644 arch/arm/boot/dts/bcm963138dvt.dts
 create mode 100644 arch/arm/boot/dts/hip04-d01.dts
 create mode 100644 arch/arm/boot/dts/hip04.dtsi
 delete mode 100644 arch/arm/boot/dts/r8a7740-armadillo800eva-reference.dts
 create mode 100644 arch/arm/boot/dts/sama5d4.dtsi
 rename arch/arm/configs/{hi3xxx_defconfig => hisi_defconfig} (77%)
 create mode 100644 arch/arm/include/debug/bcm63xx.S
 create mode 100644 arch/arm/include/debug/meson.S
 delete mode 100644 arch/arm/mach-at91/board-foxg20.c
 delete mode 100644 arch/arm/mach-at91/board-rsi-ews.c
 create mode 100644 arch/arm/mach-at91/include/mach/sama5d4.h
 create mode 100644 arch/arm/mach-at91/sama5d4.c
 create mode 100644 arch/arm/mach-bcm/bcm63xx.c
 create mode 100644 arch/arm/mach-hisi/platmcpm.c
 delete mode 100644 arch/arm/mach-imx/board-pcm038.h
 create mode 100644 arch/arm/mach-imx/clk-gate-exclusive.c
 delete mode 100644 arch/arm/mach-imx/eukrea_mbimx27-baseboard.c
 create mode 100644 arch/arm/mach-imx/imx1-dt.c
 delete mode 100644 arch/arm/mach-imx/mach-cpuimx27.c
 delete mode 100644 arch/arm/mach-imx/mach-mx1ads.c
 delete mode 100644 arch/arm/mach-imx/mach-mxt_td60.c
 delete mode 100644 arch/arm/mach-imx/mach-pcm038.c
 delete mode 100644 arch/arm/mach-imx/pcm970-baseboard.c
 create mode 100644 arch/arm/mach-meson/Kconfig
 create mode 100644 arch/arm/mach-meson/Makefile
 create mode 100644 arch/arm/mach-meson/meson.c
 delete mode 100644 arch/arm/mach-shmobile/board-armadillo800eva-reference.c
 delete mode 100644 arch/arm/mach-shmobile/board-genmai-reference.c
 delete mode 100644 arch/arm/mach-shmobile/board-genmai.c
 delete mode 100644 arch/arm/mach-shmobile/clock-r7s72100.c
 delete mode 100644 arch/arm/mach-shmobile/r7s72100.h
 create mode 100644 arch/arm/mach-shmobile/setup-r8a7794.c
 create mode 100644 arch/arm/mach-zynq/pm.c
 create mode 100644 drivers/clk/at91/clk-h32mx.c
 create mode 100644 include/dt-bindings/clock/r8a7740-clock.h
 delete mode 100644 include/linux/platform_data/tegra_emc.h

