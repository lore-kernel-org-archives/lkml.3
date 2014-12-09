Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753172AbaLIVeq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 16:34:46 -0500
Received: from mout.kundenserver.de ([212.227.17.10]:58859 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752200AbaLIVeo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 16:34:44 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL 4/9] ARM: SoC platform changes for 3.19
Date: Tue, 09 Dec 2014 22:34:28 +0100
Message-ID: <4290430.SjCennoZBW@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <4491193.a6KEQb1tZH@wuerfel>
References: <4491193.a6KEQb1tZH@wuerfel>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
X-Provags-ID: V03:K0:lLn1vP9WyNfCSAJ6fuw0f4w9xqTA9ENjhxIbF0toAmAETWGYjSF
 wUe8vFbIIg3L3nDGgjakcuCrtN+4w2RBnV7ezIf13SPZdLM9czUKaoU/z/nABRSyNKMcbwd
 jRzxX8Pc0gtEz2yy9ew69mQVtAYFjkPbqHpwx++ZE7W47V230o2Y0LbSlvn5DP08DWLGxjL
 XwXhzpCbJJLnOMSdUEZiA==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 2eb04ae010a8fb165ba7aa56e9aa8e7980887dee:

  ARM: mvebu: add missing of_node_put() call in coherency.c (2014-11-07 02:56:36 +0000)
  (this was part of a fixes branch merged into 3.18-rc2)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/soc-for-linus

for you to fetch changes up to 842f7d2c4d392c0571cf72e3eaca26742bebbd1e:

  ARM: mvebu: use the cpufreq-dt platform_data for independent clocks (2014-12-04 17:31:32 +0100)

----------------------------------------------------------------
ARM: SoC platform changes for 3.19

New and updated SoC support, notable changes include:

* bcm: brcmstb SMP support
* bcm: initial iproc/cygnus support
* exynos: Exynos4415 SoC support
* exynos: PMU and suspend support for Exynos5420
* exynos: PMU support for Exynos3250
* exynos: pm related maintenance
* imx: new LS1021A SoC support
* imx: vybrid 610 global timer support
* integrator: convert to using multiplatform configuration
* mediatek: earlyprintk support for mt8127/mt8135
* meson: meson8 soc and l2 cache controller support
* mvebu: Armada 38x CPU hotplug support
* mvebu: drop support for prerelease Armada 375 Z1 stepping
* mvebu: extended suspend support, now works on Armada 370/XP
* omap: hwmod related maintenance
* omap: prcm cleanup
* pxa: initial pxa27x DT handling
* rockchip: SMP support for rk3288
* rockchip: add cpu frequency scaling support
* shmobile: r8a7740 power domain support
* shmobile: various small restart, timer, pci apmu changes
* sunxi: Allwinner A80 (sun9i) earlyprintk support
* ux500: power domain support

Overall, a significant chunk of changes, coming mostly from
the usual suspects: omap, shmobile, samsung and mvebu, all of
which already contain a lot of platform specific code in
arch/arm.

----------------------------------------------------------------
Abhilash Kesavan (2):
      ARM: EXYNOS: Add PMU support for exynos5420
      ARM: EXYNOS: Use MCPM call-backs to support S2R on exynos5420

Alan Tull (1):
      socfpga: hotplug: put cpu1 in wfi

Ambresh K (1):
      ARM: DRA7: hwmod data: Add missing UART hwmod data

Anson Huang (2):
      ARM: imx: replace cpu type check with ddr type check
      ARM: imx: add anatop settings for LPDDR2 when enter DSM mode

Antoine Tenart (1):
      ARM: berlin: do not select RESET_CONTROLLER

Antoine Ténart (1):
      ARM: Berlin: select the reset controller

Arnd Bergmann (26):
      ARM: EXYNOS: Fix build with ARM_CPU_SUSPEND=n
      ARM: shmobile: always build rcar setup for armv7
      Merge tag 'renesas-runtime-pm-for-v3.19' of git://git.kernel.org/.../horms/renesas into next/soc
      Merge tag 'renesas-soc-for-v3.19' of git://git.kernel.org/.../horms/renesas into next/soc
      Merge tag 'renesas-soc2-for-v3.19' of git://git.kernel.org/.../horms/renesas into next/soc
      Merge tag 'renesas-soc3-for-v3.19' of git://git.kernel.org/.../horms/renesas into next/soc
      Merge tag 'renesas-boards-for-v3.19' of git://git.kernel.org/.../horms/renesas into next/soc
      Merge tag 'pxa-for-3.19' of https://github.com/rjarzmik/linux into next/soc
      Merge tag 'omap-for-v3.19/clocks-and-pm' of git://git.kernel.org/.../tmlind/linux-omap into next/soc
      Merge tag 'omap-for-v3.19/prcm-cleanup' of git://git.kernel.org/.../tmlind/linux-omap into next/soc
      Merge tag 'arm-soc/for-3.19/cygnus-platform-v2' of http://github.com/brcm/linux into next/soc
      Merge tag 'arm-soc/for-3.19/cygnus-defconfig-v2' of http://github.com/brcm/linux into next/soc
      Merge tag 'v3.19-next-soc' of https://github.com/mbgg/linux-mediatek into next/soc
      Merge tag 'integrator-v3.19-arm-soc-2' of git://git.kernel.org/.../linusw/linux-integrator into next/soc
      Merge tag 'v3.19-rockchip-soc2' of git://git.kernel.org/.../mmind/linux-rockchip into next/soc
      Merge tag 'v3.19-meson-soc' of https://github.com/carlocaione/linux-meson into next/soc
      Merge tag 'sunxi-core-for-3.19' of git://git.kernel.org/.../mripard/linux into next/soc
      Merge tag 'berlin-soc-3.19-2' of git://git.infradead.org/users/hesselba/linux-berlin into next/soc
      Merge tag 'renesas-soc4-for-v3.19' of git://git.kernel.org/.../horms/renesas into next/soc
      ARM: imx: temporarily remove CONFIG_SOC_FSL from LS1021A
      Merge tag 'samsung-exynos-v3.19' of git://git.kernel.org/.../kgene/linux-samsung into next/soc
      Merge tag 'samsung-pm-3' of git://git.kernel.org/.../kgene/linux-samsung into next/soc
      Merge (part of) tag 'omap-for-v3.19/hwmod-and-defconfig' of git://git.kernel.org/.../tmlind/linux-omap into next/soc
      Merge tag 'imx-soc-3.19' of git://git.kernel.org/.../shawnguo/linux into next/soc
      Merge tag 'mvebu-soc-3.19' of git://git.infradead.org/linux-mvebu into next/soc
      Merge tag 'mvebu-soc-suspend-3.19' of git://git.infradead.org/linux-mvebu into next/soc

Axel Lin (1):
      soc: integrator: Add terminating entry for integrator_cm_match

Bartlomiej Zolnierkiewicz (8):
      ARM: EXYNOS: replace EXYNOS_BOOT_VECTOR_* macros by static inlines
      ARM: firmware: add AFTR mode support to firmware do_idle method
      ARM: EXYNOS: add secure firmware support to AFTR mode code
      ARM: EXYNOS: fix register setup for AFTR mode code
      ARM: EXYNOS: allow driver usage on Exynos4x12 SoCs
      ARM: EXYNOS: Fix build with PM_SLEEP=n and ARM_EXYNOS_CPUIDLE=y
      ARM: EXYNOS: add exynos3250 PMU support
      ARM: EXYNOS: use u8 for val[] in struct exynos_pmu_conf

Beniamino Galvani (4):
      ARM: meson: add meson8 support
      ARM: meson: document meson8 compatible properties
      ARM: meson: enable L2 cache
      clocksource: meson6: Select CLKSRC_MMIO

Brian Norris (2):
      ARM: brcmstb: reintroduce SMP support
      ARM: brcmstb: Kconfig: drop unneeded symbol selections

Chanwoo Choi (1):
      ARM: EXYNOS: Add support for exynos4415 SoC

Chen-Yu Tsai (7):
      Documentation: sunxi: Update Allwinner SoC documentation (A31/A31s/A23)
      ARM: sunxi: Add debug uart used by sun9i (Allwinner A80)
      devicetree: bindings: Add vendor prefix for Merrii Technology Co., Ltd.
      ARM: sunxi: Introduce Allwinner A80 support
      devicetree: bindings: Document supported Allwinner sunxi SoCs
      Documentation: sunxi: Add A80 datasheet link
      ARM: sunxi: Select ARCH_HAS_RESET_CONTROLLER and RESET_CONTROLLER for sun9i

Dmitry Eremin-Solenikov (2):
      ARM: pxa: tosa: switch to gpio-charger
      ARM: debug: move StrongARM debug include to arch/arm/include/debug

Dmitry Lifshitz (1):
      ARM: dts: cm-t3x30: add keypad support

Emilio López (1):
      ARM: sunxi: make sun6i SMP ops static

Ezequiel Garcia (1):
      ARM: mvebu: Remove thermal quirk for A375 Z1 revision

Felipe Balbi (1):
      ARM: OMAP2+: hwmod: drop unnecessary list initialization

Florian Fainelli (2):
      bus: brcmstb_gisb: register the fault code hook
      bus: brcmstb_gisb: save and restore GISB timeout

Fugang Duan (2):
      ARM: imx6sx: add imx6sx iomux-gpr field define
      ARM: imx: add enet init for i.mx6sx

Geert Uytterhoeven (15):
      ARM: shmobile: sh7372: Add shmobile_init_late()
      ARM: shmobile: r8a7740: Add missing A3SP pm domain devices
      ARM: shmobile: r8a7740: Add missing A4S pm domain devices
      ARM: shmobile: armadillo800eva legacy: Add missing A3SP pm domain devices
      ARM: shmobile: armadillo800eva legacy: Add missing A4S pm domain devices
      ARM: shmobile: r8a7740: Add A3RV pm domain support
      ARM: shmobile: r8a7740: Add A3SG pm domain support
      ARM: shmobile: r8a7740/armadillo legacy: Add A4MP pm domain support
      ARM: shmobile: r8a7740: Add D4 pm domain support
      ARM: shmobile: r8a7740/armadillo legacy: Add A4R pm domain support
      ARM: shmobile: r8a7740: Add A4SU pm domain support
      ARM: shmobile: r8a7740: Add A3SM pm domain support
      ARM: shmobile: kzm9g-reference: Add restart callback
      ARM: shmobile: sh73a0: Add restart callback
      ARM: shmobile: Add early debugging support using SCIF(A)

Gregory CLEMENT (4):
      ARM: mvebu: Clean-up the Armada XP support
      ARM: mvebu: Move SCU power up in a function
      ARM: mvebu: Fix the secondary startup for Cortex A9 SoC
      ARM: mvebu: Implement the CPU hotplug support for the Armada 38x SoCs

Hauke Mehrtens (1):
      ARM: BCM5301X: fix early serial console

Heiko Stuebner (4):
      ARM: rockchip: add a cpufreq-cpu0 device
      ARM: rockchip: honor renaming of cpufreq-cpu0 to cpufreq-dt
      ARM: rockchip: convert to regmap and use pmu syscon if available
      ARM: rockchip: add option to access the pmu via a phandle in smp_operations

Hisashi Nakamura (2):
      ARM: shmobile: Separate APMU resource data into CPU dependant part
      ARM: shmobile: r8a7791: Correct number of CPU cores

Jason Cooper (1):
      Merge branch 'mvebu/fixes' into mvebu/soc

Javier Martinez Canillas (1):
      ARM: EXYNOS: Call regulator core suspend prepare and finish functions

Jingchang Lu (2):
      ARM: imx: Add initial support for Freescale LS1021A
      ARM: imx: Add Freescale LS1021A SMP support

Joe Perches (2):
      ARM: u300: Convert pr_warning to pr_warn
      arm: mach-pxa: Convert pr_warning to pr_warn

Joe.C (2):
      ARM: mediatek: Add earlyprintk support for mt8127 & mt8135
      ARM: mediatek: Fix description for mediatek SoCs

Jonathan Richardson (1):
      ARM: cygnus: Initial support for Broadcom Cygnus SoC

Kever Yang (1):
      ARM: rockchip: add basic smp support for rk3288

Krzysztof Kozlowski (1):
      ARM: EXYNOS: SWRESET is needed to boot secondary CPU on exynos3250

Kukjin Kim (2):
      Merge branch 'v3.19-next/cleanup-samsung' into v3.19-next/mach-exynos
      Merge branch 'v3.19-next/non-critical-fixes' into v3.19-next/mach-exynos

Laurent Pinchart (1):
      ARM: shmobile: Select CONFIG_ZONE_DMA when CONFIG_ARM_LPAE is enabled

Linus Walleij (8):
      ARM: integrator: make the Integrator multiplatform
      ARM: integrator: set V4T and V5 as default multitargets
      ARM: integrator: move AP timer to clocksource
      ARM: fix multiplatform allmodcompile
      ARM: integrator: move restart to the device tree
      ARM: integrator: move debug LEDs to syscon LED driver
      ARM: integrator: move core module LED to device tree
      soc: move SoC driver for the ARM Integrator

Lucas Stach (4):
      ARM: imx5: add step clock, used when reprogramming PLL1
      ARM: imx: add CPU clock type
      ARM: imx53: clk: add ARM clock
      ARM: imx53: add cpufreq support

Magnus Damm (1):
      ARM: shmobile: Handle CA7 arch timer delay

Marc Carino (1):
      ARM: brcmstb: add debug UART for earlyprintk support

Nishanth Menon (3):
      ARM: OMAP4: PM: Only do static dependency configuration in omap4_init_static_deps
      ARM: OMAP4+: PM: Centralize static dependency mapping table
      ARM: OMAP4+: PM: Program CPU logic power state

Oleksij Rempel (2):
      ARM: add mach-asm9260
      ARM: add lolevel debug support for asm9260

Olof Johansson (6):
      Merge tag 'v3.18-rockchip-cpufreqdev-v2' of git://git.kernel.org/.../mmind/linux-rockchip into next/soc
      Merge tag 'brcmstb-smp-uart-for-3.19' of http://github.com/brcm/linux into next/soc
      Merge tag 'integrator-multiplatform-for-arm-soc' of git://git.kernel.org/.../linusw/linux-integrator into next/soc
      Merge branch 'v3.19-next/pm-samsung-2' of http://git.kernel.org/.../kgene/linux-samsung into next/soc
      Merge tag 'berlin-soc-3.19-1' of git://git.infradead.org/users/hesselba/linux-berlin into next/soc
      Merge tag 'ux500-core-for-arm-soc' of git://git.kernel.org/.../linusw/linux-stericsson into next/soc

Pankaj Dubey (4):
      ARM: EXYNOS: Add platform driver support for Exynos PMU
      ARM: EXYNOS: Move PMU specific definitions from common.h
      clk: exynos5440: move restart code into clock driver
      ARM: EXYNOS: move restart code into pmu driver

Paul Walmsley (2):
      Merge branch 'dra7xx-uart-hwmod-v3.19' into omap-b-for-v3.19
      Merge branch 'adc-support-v3.19' into omap-b-for-v3.19

Phil Edworthy (1):
      ARM: shmobile: Enable PCI domains for R-Car Gen2 devices

Robert Jarzmik (4):
      arm: pxa: add device-tree irq init for pxa27x
      arm: pxa: move init functions into generic.h
      arm: pxa: remove unnecessary includes from pxa-dt
      arm: pxa: add pxa27x device-tree support

Robin Gong (1):
      power: reset: imx-snvs-poweroff: add power off driver for i.mx6

Scott Branden (3):
      ARM: mach-bcm: Consolidate currently supported IPROC SoCs
      ARM: mach-bcm: ARCH_BCM_MOBILE: remove one level of menu from Kconfig
      ARM: bcm_defconfig: remove one level of menu from Kconfig

Shawn Guo (1):
      Merge tag 'imx-fixes-3.18-2' into imx/soc

Stefan Agner (2):
      ARM: vf610: Add ARM Global Timer clocksource option
      ARM: imx: clk-vf610: get input clocks from assigned clocks

Tero Kristo (31):
      ARM: DRA7: PRM: add voltage processor check behind a prm_feature flag
      ARM: AM43XX: PRM: use OMAP4 PRM driver
      ARM: OMAP2/3: hwmod: merge wait_target_ready functions for omap2/3
      ARM: AM33xx/OMAP4+: CM: remove cdoffs parameter from wait_module_idle/ready
      ARM: OMAP4/AM33xx: add cm_init / cm_exit calls for AM33xx and OMAP4+
      ARM: OMAP2+: CM: add common API for cm_wait_module_ready
      ARM: OMAP4+/AM33xx: CM: add common API for cm_wait_module_idle
      ARM: OMAP2+: CM: make clkdm_hwsup operations static
      ARM: OMAP2+: CM: add common APIs for cm_module_enable/disable
      ARM: OMAP2/3: CM: make cm_split_idlest_reg SoC calls static
      ARM: AM33xx: hwmod: remove am33xx specific module SoC opts
      ARM: AM43xx: hwmod: use OMAP4 hardreset ops instead of the AM33xx version
      ARM: AM33xx: PRM: add support for prm_init
      ARM: OMAP2+: PRM: add generic API for asserting hardware reset
      ARM: OMAP2+: PRM: add generic API for deasserting hardware reset
      ARM: OMAP2+: PRM: add generic API for checking hardreset status
      ARM: OMAP4: CM: move public definitions from cminst44xx.h to cm44xx.h
      ARM: OMAP4: CM: make cminst direct register access functions static
      ARM: OMAP4+: CM: remove omap4_cm1/cm2_* functions
      ARM: AM33xx: PRM: move global warm reset implementation to driver
      ARM: AM33xx: PRM: make direct register access functions static
      ARM: OMAP4: PRM: make omap4_prm_read/write_inst_reg calls static
      ARM: OMAP3: PRM: make PRCM interrupt handler related functions static
      ARM: OMAP4: PRM: make PRCM interrupt handler related functions static
      ARM: OMAP3+: PRM: add generic API for reconfiguring I/O chain
      ARM: OMAP2+: PRM: provide generic API for system reset
      ARM: OMAP3: clock: use clk_features flags for omap3 DPLL4 checks
      ARM: OMAP3: clock: add new rate changing logic support for noncore DPLLs
      ARM: OMAP4: clock: add support for determine_rate for omap4 regm4xen DPLL
      ARM: OMAP3: clock: add support for dpll4_set_rate_and_parent
      ARM: OMAP3+: DPLL: use determine_rate() and set_rate_and_parent()

Thomas Petazzoni (20):
      Documentation: dt-bindings: minimal documentation for MVEBU SDRAM controller
      ARM: mvebu: make the coherency_ll.S functions work with no coherency fabric
      ARM: mvebu: disable I/O coherency on non-SMP situations on Armada 370/375/38x/XP
      ARM: mvebu: remove unused register offset definition
      ARM: mvebu: remove Armada 375 Z1 workaround for I/O coherency
      ARM: mvebu: update comments in coherency.c
      irqchip: armada-370-xp: Add suspend/resume support
      clocksource: time-armada-370-xp: add suspend/resume support
      bus: mvebu-mbus: suspend/resume support
      bus: mvebu-mbus: provide a mechanism to save SDRAM window configuration
      clk: mvebu: add suspend/resume for gatable clocks
      ARM: mvebu: implement suspend/resume support for Armada XP
      ARM: mvebu: reserve the first 10 KB of each memory bank for suspend/resume
      ARM: mvebu: Armada XP GP specific suspend/resume code
      ARM: mvebu: make sure MMU is disabled in armada_370_xp_cpu_resume
      ARM: mvebu: synchronize secondary CPU clocks on resume
      ARM: mvebu: add suspend/resume DT information for Armada XP GP
      ARM: mvebu: adjust mbus controller description on Armada 370/XP
      ARM: mvebu: add SDRAM controller description for Armada XP
      ARM: mvebu: use the cpufreq-dt platform_data for independent clocks

Tomasz Figa (2):
      ARM: firmware: Introduce suspend and resume operations
      ARM: EXYNOS: Add support for firmware-assisted suspend/resume

Tomi Valkeinen (6):
      ARM: OMAP2+: hwmod: add parent_hwmod support
      ARM: OMAP5: hwmod: set DSS submodule parent hwmods
      ARM: OMAP4: hwmod: set DSS submodule parent hwmods
      ARM: OMAP4: hwmod: use MODULEMODE properly
      ARM: OMAP4: fix RFBI iclk
      ARM: dts: omap4.dtsi: remove dss_fck

Tony Lindgren (2):
      Merge tag 'for-v3.19/omap-a' of git://git.kernel.org/.../pjw/omap-pending into omap-for-v3.19/soc
      Merge tag 'for-v3.19/omap-b2' of git://git.kernel.org/.../pjw/omap-pending into omap-for-v3.19/soc

Ulf Hansson (8):
      dt: bindings: ux500: Add documentation for PM domains
      dt: bindings: ux500: Add header for PM domains specifiers
      ARM: ux500: Initial support for PM domains
      ARM: ux500: Enable Kconfig for the generic PM domain
      ARM: ux500: Add DT node for ux500 PM domains
      ARM: ux500: Add sdi devices to the VAPE PM domain
      ARM: ux500: Add spi and ssp devices to the VAPE PM domain
      ARM: ux500: Add i2c devices to the VAPE PM domain

Ulrich Hecht (1):
      ARM: shmobile: rcar-gen2: Add CA7 arch_timer initialization for r8a7794

Vignesh R (1):
      ARM: OMAP2+: hwmod: AM43x: add hwmod support for ADC on AM43xx

Vikas Sajjan (3):
      ARM: EXYNOS: Move Disabling of JPEG USE_RETENTION for exynos5250 to pmu.c
      ARM: EXYNOS: Refactor the pm code to use DT based lookup
      ARM: EXYNOS: Add Suspend-to-RAM support for exynos5420

 Documentation/arm/firmware.txt                     |  28 +-
 Documentation/arm/sunxi/README                     |  16 +-
 Documentation/devicetree/bindings/arm/amlogic.txt  |   8 +-
 Documentation/devicetree/bindings/arm/cpus.txt     |   9 +
 Documentation/devicetree/bindings/arm/sunxi.txt    |  12 +
 .../devicetree/bindings/arm/ux500/power_domain.txt |  35 ++
 .../devicetree/bindings/bus/mvebu-mbus.txt         |  17 +-
 .../memory-controllers/mvebu-sdram-controller.txt  |  21 +
 .../bindings/power_supply/imx-snvs-poweroff.txt    |  23 +
 .../devicetree/bindings/vendor-prefixes.txt        |   1 +
 MAINTAINERS                                        |   1 +
 arch/arm/Kconfig                                   |  20 +-
 arch/arm/Kconfig.debug                             | 167 ++++-
 arch/arm/boot/dts/armada-370-xp.dtsi               |   3 +-
 arch/arm/boot/dts/armada-xp-gp.dts                 |  19 +-
 arch/arm/boot/dts/armada-xp.dtsi                   |   5 +
 arch/arm/boot/dts/integrator.dtsi                  |  48 +-
 arch/arm/boot/dts/omap3-cm-t3x30.dtsi              |  17 +
 arch/arm/boot/dts/omap4.dtsi                       |   2 +-
 arch/arm/boot/dts/omap44xx-clocks.dtsi             |   8 -
 arch/arm/boot/dts/ste-dbx5x0.dtsi                  |  22 +
 arch/arm/configs/bcm_defconfig                     |   3 +-
 arch/arm/configs/integrator_defconfig              |   3 +
 arch/arm/include/asm/firmware.h                    |  10 +-
 arch/arm/include/debug/asm9260.S                   |  29 +
 arch/arm/include/debug/renesas-scif.S              |  52 ++
 .../mach/debug-macro.S => include/debug/sa1100.S}  |  10 +-
 arch/arm/mach-asm9260/Kconfig                      |   6 +
 arch/arm/mach-bcm/Kconfig                          |  96 +--
 arch/arm/mach-bcm/Makefile                         |   5 +
 arch/arm/mach-bcm/bcm_cygnus.c                     |  25 +
 arch/arm/mach-bcm/brcmstb.h                        |  19 +
 arch/arm/mach-bcm/headsmp-brcmstb.S                |  33 +
 arch/arm/mach-bcm/platsmp-brcmstb.c                | 329 ++++++++++
 arch/arm/mach-berlin/Kconfig                       |   3 +-
 arch/arm/mach-exynos/Kconfig                       |  11 +
 arch/arm/mach-exynos/Makefile                      |   4 +-
 arch/arm/mach-exynos/common.h                      |  31 +-
 arch/arm/mach-exynos/exynos-pmu.h                  |  24 +
 arch/arm/mach-exynos/exynos.c                      |  30 +-
 arch/arm/mach-exynos/firmware.c                    |  67 ++-
 arch/arm/mach-exynos/mcpm-exynos.c                 |  32 +-
 arch/arm/mach-exynos/platsmp.c                     |  35 ++
 arch/arm/mach-exynos/pm.c                          | 311 ++--------
 arch/arm/mach-exynos/pmu.c                         | 669 +++++++++++++++++++--
 arch/arm/mach-exynos/regs-pmu.h                    | 358 +++++++++++
 arch/arm/mach-exynos/sleep.S                       |  28 +
 arch/arm/mach-exynos/smc.h                         |   4 +
 arch/arm/mach-exynos/suspend.c                     | 566 +++++++++++++++++
 arch/arm/mach-imx/Kconfig                          |  31 +-
 arch/arm/mach-imx/Makefile                         |   6 +-
 arch/arm/mach-imx/anatop.c                         |  34 +-
 arch/arm/mach-imx/clk-cpu.c                        | 107 ++++
 arch/arm/mach-imx/clk-imx51-imx53.c                |  14 +-
 arch/arm/mach-imx/clk-vf610.c                      |  21 +-
 arch/arm/mach-imx/clk.h                            |   4 +
 arch/arm/mach-imx/common.h                         |   2 +
 arch/arm/mach-imx/mach-imx53.c                     |   2 +
 arch/arm/mach-imx/mach-imx6sx.c                    |  51 ++
 arch/arm/mach-imx/mach-ls1021a.c                   |  22 +
 arch/arm/mach-imx/mmdc.c                           |  17 +
 arch/arm/mach-imx/mxc.h                            |   2 +
 arch/arm/mach-imx/platsmp.c                        |  33 +
 arch/arm/mach-imx/pm-imx6.c                        |  10 +-
 arch/arm/mach-imx/suspend-imx6.S                   |  14 +-
 arch/arm/mach-integrator/Kconfig                   |  23 +
 arch/arm/mach-integrator/Makefile                  |   2 +-
 arch/arm/mach-integrator/cm.h                      |   1 -
 arch/arm/mach-integrator/common.h                  |   2 -
 arch/arm/mach-integrator/core.c                    | 103 ----
 arch/arm/mach-integrator/include/mach/uncompress.h |  48 --
 arch/arm/mach-integrator/integrator_ap.c           | 218 -------
 arch/arm/mach-integrator/integrator_cp.c           |  28 -
 arch/arm/mach-integrator/leds.c                    | 124 ----
 arch/arm/mach-mediatek/Kconfig                     |   4 +-
 arch/arm/mach-meson/Kconfig                        |   6 +
 arch/arm/mach-meson/meson.c                        |  10 +-
 arch/arm/mach-mvebu/Makefile                       |   2 +-
 arch/arm/mach-mvebu/armada-370-xp.h                |   6 -
 arch/arm/mach-mvebu/board-v7.c                     | 122 ++--
 arch/arm/mach-mvebu/coherency.c                    | 221 ++-----
 arch/arm/mach-mvebu/coherency_ll.S                 |  21 +-
 arch/arm/mach-mvebu/common.h                       |   2 +
 arch/arm/mach-mvebu/cpu-reset.c                    |   1 -
 arch/arm/mach-mvebu/headsmp-a9.S                   |   1 +
 arch/arm/mach-mvebu/platsmp-a9.c                   |  53 +-
 arch/arm/mach-mvebu/platsmp.c                      |  33 +-
 arch/arm/mach-mvebu/pm-board.c                     | 141 +++++
 arch/arm/mach-mvebu/pm.c                           | 218 +++++++
 arch/arm/mach-mvebu/pmsu.c                         |  11 +-
 arch/arm/mach-mvebu/pmsu.h                         |   3 +
 arch/arm/mach-mvebu/pmsu_ll.S                      |  28 +-
 arch/arm/mach-omap2/Makefile                       |   2 +-
 arch/arm/mach-omap2/am33xx-restart.c               |  12 +-
 arch/arm/mach-omap2/cclock3xxx_data.c              |   6 +
 arch/arm/mach-omap2/clock.c                        |   7 +-
 arch/arm/mach-omap2/clock.h                        |   1 +
 arch/arm/mach-omap2/clock3xxx.c                    |  38 +-
 arch/arm/mach-omap2/cm.h                           |  18 +-
 arch/arm/mach-omap2/cm1_44xx.h                     |   2 -
 arch/arm/mach-omap2/cm1_54xx.h                     |   2 -
 arch/arm/mach-omap2/cm1_7xx.h                      |   2 -
 arch/arm/mach-omap2/cm2_44xx.h                     |   2 -
 arch/arm/mach-omap2/cm2_54xx.h                     |   2 -
 arch/arm/mach-omap2/cm2_7xx.h                      |   2 -
 arch/arm/mach-omap2/cm2xxx.c                       |  17 +-
 arch/arm/mach-omap2/cm2xxx.h                       |  10 +-
 arch/arm/mach-omap2/cm33xx.c                       |  61 +-
 arch/arm/mach-omap2/cm33xx.h                       |  37 +-
 arch/arm/mach-omap2/cm3xxx.c                       |  19 +-
 arch/arm/mach-omap2/cm3xxx.h                       |  12 -
 arch/arm/mach-omap2/cm44xx.c                       |  49 --
 arch/arm/mach-omap2/cm44xx.h                       |   3 +
 arch/arm/mach-omap2/cm_44xx_54xx.h                 |  36 --
 arch/arm/mach-omap2/cm_common.c                    |  82 ++-
 arch/arm/mach-omap2/cminst44xx.c                   |  80 ++-
 arch/arm/mach-omap2/cminst44xx.h                   |  43 --
 arch/arm/mach-omap2/dpll3xxx.c                     | 179 ++++--
 arch/arm/mach-omap2/dpll44xx.c                     |  41 ++
 arch/arm/mach-omap2/io.c                           |  11 +-
 arch/arm/mach-omap2/omap-mpuss-lowpower.c          |   4 +-
 arch/arm/mach-omap2/omap2-restart.c                |   5 +-
 arch/arm/mach-omap2/omap3-restart.c                |   7 +-
 arch/arm/mach-omap2/omap4-restart.c                |   6 +-
 arch/arm/mach-omap2/omap_hwmod.c                   | 272 +++------
 arch/arm/mach-omap2/omap_hwmod.h                   |   8 +
 arch/arm/mach-omap2/omap_hwmod_43xx_data.c         |  39 ++
 arch/arm/mach-omap2/omap_hwmod_44xx_data.c         |  25 +-
 arch/arm/mach-omap2/omap_hwmod_54xx_data.c         |   5 +
 arch/arm/mach-omap2/omap_hwmod_7xx_data.c          | 100 +++
 arch/arm/mach-omap2/pm44xx.c                       | 146 ++---
 arch/arm/mach-omap2/prm.h                          |  16 +
 arch/arm/mach-omap2/prm2xxx.c                      |   6 +-
 arch/arm/mach-omap2/prm2xxx.h                      |   1 -
 arch/arm/mach-omap2/prm2xxx_3xxx.c                 |  19 +-
 arch/arm/mach-omap2/prm2xxx_3xxx.h                 |   9 +-
 arch/arm/mach-omap2/prm33xx.c                      |  64 +-
 arch/arm/mach-omap2/prm33xx.h                      |  11 +-
 arch/arm/mach-omap2/prm3xxx.c                      |  32 +-
 arch/arm/mach-omap2/prm3xxx.h                      |  16 -
 arch/arm/mach-omap2/prm44xx.c                      |  36 +-
 arch/arm/mach-omap2/prm44xx_54xx.h                 |  19 -
 arch/arm/mach-omap2/prm_common.c                   |  99 +++
 arch/arm/mach-omap2/prminst44xx.c                  |  10 +-
 arch/arm/mach-omap2/prminst44xx.h                  |   5 +-
 arch/arm/mach-pxa/Kconfig                          |  11 +
 arch/arm/mach-pxa/Makefile                         |   1 +
 arch/arm/mach-pxa/em-x270.c                        |   4 +-
 arch/arm/mach-pxa/generic.h                        |  65 +-
 arch/arm/mach-pxa/gumstix.c                        |   3 +-
 arch/arm/mach-pxa/include/mach/pxa25x.h            |   8 -
 arch/arm/mach-pxa/include/mach/pxa27x.h            |   4 -
 arch/arm/mach-pxa/include/mach/pxa3xx.h            |   5 -
 arch/arm/mach-pxa/mfp-pxa2xx.c                     |  12 +-
 arch/arm/mach-pxa/poodle.c                         |   2 +-
 arch/arm/mach-pxa/pxa-dt.c                         |  18 +-
 arch/arm/mach-pxa/pxa27x.c                         |   6 +
 arch/arm/mach-pxa/pxa3xx-ulpi.c                    |   6 +-
 arch/arm/mach-pxa/raumfeld.c                       |  26 +-
 arch/arm/mach-pxa/tosa.c                           |  41 +-
 arch/arm/mach-rockchip/headsmp.S                   |   5 +-
 arch/arm/mach-rockchip/platsmp.c                   | 223 +++++--
 arch/arm/mach-rockchip/rockchip.c                  |   7 +
 arch/arm/mach-shmobile/Kconfig                     |   2 +
 arch/arm/mach-shmobile/Makefile                    |   1 +
 arch/arm/mach-shmobile/board-armadillo800eva.c     |  12 +-
 arch/arm/mach-shmobile/board-kzm9g-reference.c     |   8 +
 arch/arm/mach-shmobile/common.h                    |   5 -
 arch/arm/mach-shmobile/platsmp-apmu.c              |  27 +-
 arch/arm/mach-shmobile/platsmp-apmu.h              |  32 +
 arch/arm/mach-shmobile/pm-r8a7740.c                |  44 +-
 arch/arm/mach-shmobile/setup-r8a7740.c             |  12 +
 arch/arm/mach-shmobile/setup-r8a7779.c             |   1 +
 arch/arm/mach-shmobile/setup-rcar-gen2.c           |  72 ++-
 arch/arm/mach-shmobile/setup-sh7372.c              |   2 +
 arch/arm/mach-shmobile/setup-sh73a0.c              |   9 +
 arch/arm/mach-shmobile/smp-r8a7790.c               |  16 +-
 arch/arm/mach-shmobile/smp-r8a7791.c               |  12 +-
 arch/arm/mach-shmobile/timer.c                     |  23 +-
 arch/arm/mach-socfpga/core.h                       |   3 +
 arch/arm/mach-socfpga/platsmp.c                    |  19 +-
 arch/arm/mach-sunxi/Kconfig                        |   7 +
 arch/arm/mach-sunxi/platsmp.c                      |   2 +-
 arch/arm/mach-sunxi/sunxi.c                        |   9 +
 arch/arm/mach-tegra/cpuidle-tegra114.c             |   2 +-
 arch/arm/mach-u300/dummyspichip.c                  |  65 +-
 arch/arm/mach-ux500/Kconfig                        |   1 +
 arch/arm/mach-ux500/Makefile                       |   1 +
 arch/arm/mach-ux500/pm.c                           |   4 +
 arch/arm/mach-ux500/pm_domains.c                   |  79 +++
 arch/arm/mach-ux500/pm_domains.h                   |  17 +
 arch/arm/mm/Kconfig                                |  28 +-
 arch/arm/plat-samsung/Makefile                     |   1 +
 drivers/bus/brcmstb_gisb.c                         |  45 +-
 drivers/bus/mvebu-mbus.c                           | 180 +++++-
 drivers/clk/mvebu/common.c                         |  32 +-
 drivers/clk/samsung/clk-exynos5440.c               |  29 +-
 drivers/clk/ti/dpll.c                              |  15 +
 drivers/clocksource/Kconfig                        |   1 +
 drivers/clocksource/Makefile                       |   1 +
 drivers/clocksource/time-armada-370-xp.c           |  25 +
 drivers/clocksource/timer-integrator-ap.c          | 210 +++++++
 drivers/irqchip/irq-armada-370-xp.c                |  52 ++
 drivers/power/reset/Kconfig                        |   9 +
 drivers/power/reset/Makefile                       |   1 +
 drivers/power/reset/imx-snvs-poweroff.c            |  66 ++
 drivers/soc/versatile/Kconfig                      |   9 +
 drivers/soc/versatile/Makefile                     |   1 +
 drivers/soc/versatile/soc-integrator.c             | 155 +++++
 include/dt-bindings/arm/ux500_pm_domains.h         |  15 +
 include/dt-bindings/clock/imx5-clock.h             |   5 +-
 include/linux/clk/ti.h                             |  15 +
 include/linux/mbus.h                               |   1 +
 include/linux/mfd/syscon/imx6q-iomuxc-gpr.h        |  39 ++
 214 files changed, 6329 insertions(+), 2353 deletions(-)

