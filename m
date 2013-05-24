Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756672Ab3EXWyM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 18:54:12 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:57013 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755025Ab3EXWyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 18:54:10 -0400
Date: Fri, 24 May 2013 15:54:08 -0700
From: Olof Johansson <olof@lixom.net>
To: torvalds@linux-foundation.org
Cc: olof@lixom.net, linux-arm-kernel@lists.infradead.org, arm@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] ARM: SoC fixes for 3.10-rc
Message-ID: <20130524225408.GA11451@quad.lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,


The following changes since commit c7788792a5e7b0d5d7f96d0766b4cb6112d47d75:

  Linux 3.10-rc2 (2013-05-20 14:37:38 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/fixes-for-linus

for you to fetch changes up to f4ae176c626311d6507c9a2d263657c4cc4e1667:

  Merge tag 'sunxi-fixes-for-3.10' of git://github.com/mripard/linux into fixes (2013-05-24 15:50:28 -0700)

----------------------------------------------------------------

ARM: SoC fixes for 3.10-rc

We didn't have any fixes sent up for -rc2, so this is a slightly larger
batch. A bit all over the place platform-wise; OMAP, at91, marvell,
renesas, sunxi, ux500, etc.

I tried to summarize highlights but there isn't a whole lot to point
out. Lots of little things fixed all over. A couple of defconfig updates
due to new/changing options.

----------------------------------------------------------------
Alexandre Courbot (1):
      ARM: tegra: defconfig fixes

Andrew Lunn (1):
      ARM: Orion: Remove redundant init_dma_coherent_pool_size()

Boris BREZILLON (1):
      ARM: at91/dt: fix macb pinctrl_macb_rmii_mii_alt definition

Dirk Behme (1):
      ARM i.MX6: correct MLB clock configuration

Emilio López (1):
      ARM: ux500: select REGULATOR

Ezequiel Garcia (2):
      ARM: mvebu: Add a ranges entry to translate devbus childs
      ARM: mvebu: Fix ranges entry on XP GP board

Gregory CLEMENT (3):
      ARM: mvebu: select ARCH_REQUIRE_GPIOLIB for mvebu platform
      ARM: plat-orion: Fix num_resources and id for ge10 and ge11
      ARM: dts: mvebu: Fix wrong the address reg value for the L2-cache node

Jean-Christophe PLAGNIOL-VILLARD (3):
      ARM: at91/trivial: fix model name for SAM9X25-EK
      ARM: at91: rm9200 fix time support
      ARM: at91: at91sam9n12: move external irq declatation to DT

Josh Wu (1):
      ARM: at91/sama5: fix incorrect PMC pcr div definition

Lee Jones (3):
      ARM: ux500: Remove duplicated assignment of ab8500_platdata
      ARM: ux500: Fix incorrect DEBUG UART virtual addresses
      ARM: ux500: Provide device enumeration number suffix for SMSC911x

Linus Walleij (1):
      ARM: nomadik: fix IRQ assignment for SMC ethernet

Lucas Stach (2):
      clk: tegra: remove USB from clk init table
      clk: tegra: add ac97 controller clock

Ludovic Desroches (1):
      ARM: at91: dts: request only spi cs-gpios used on sama5d3x cpu module

Martin Michlmayr (1):
      Kirkwood: Enable PCIe port 1 on QNAP TS-11x/TS-21x

Maxime Ripard (2):
      ARM: sunxi: Fix Mini X-plus device tree build
      ARM: sunxi: select ARCH_REQUIRE_GPIOLIB

Nicolas Ferre (1):
      ARM: at91/trivial: typo in GEM compatible string

Olof Johansson (10):
      Merge tag 'fixes-3.10-1' of git://git.infradead.org/users/jcooper/linux into fixes
      Merge tag 'at91-fixes' of git://github.com/at91linux/linux-at91 into fixes
      Merge tag 'omap-for-v3.10-rc1/fixes' of git://git.kernel.org/.../tmlind/linux-omap into fixes
      Merge tag 'fixes-3.10-2' of git://git.infradead.org/users/jcooper/linux into fixes
      Merge tag 'imx-fixes-3.10' of git://git.linaro.org/people/shawnguo/linux-2.6 into fixes
      Merge tag 'ux500-arm-soc-v3.10-fixes' of git://git.kernel.org/.../linusw/linux-stericsson into fixes
      Merge tag 'omap-fixes-a-for-3.10-rc' of git://git.kernel.org/.../pjw/omap-pending into fixes
      Merge tag 'renesas-boards-marzen-fixes-for-v3.10' of git://git.kernel.org/.../horms/renesas into fixes
      Merge tag 'at91-fixes' of git://github.com/at91linux/linux-at91 into fixes
      Merge tag 'sunxi-fixes-for-3.10' of git://github.com/mripard/linux into fixes

Paul Walmsley (1):
      ARM: OMAP2+: Add missing CONFIG_ARCH_MULTI_V6=y to omap2plus_defconfig

Philipp Zabel (1):
      ARM i.MX6q: Fix periph_clk2_sel and periph2_clk2_sel clocks

Rajendra Nayak (2):
      ARM: OMAP2+: hwmod: Fix sidle programming in _enable_sysc()/_idle_sysc()
      ARM: OMAP2+: hwmod: Add a new flag to handle SIDLE in SWSUP only in active

Santosh Shilimkar (4):
      ARM: OMAP2+: hwmod-data: UART IP needs software control to manage sidle modes
      ARM: OMAP2+: serial: Remove the un-used slave idle hooks
      SERIAL: OMAP: Remove the slave idle handling from the driver
      ARM: OMAP2+: hwmod: Remove sysc slave idle and auto idle apis

Sebastian Hesselbarth (1):
      ARM: plat-orion: add missing ehci include to common.h

Shawn Guo (2):
      ARM: imx: replicate the diagnostic register of boot cpu into secondary cores
      ARM: imx: fix typo in gpu3d_shader_sels

Simon Horman (1):
      ARM: shmobile: marzen: Use error values in usb_power_*

Srinivas Kandagatla (1):
      ARM: vt8500: Add missing NULL terminator in dt_compat

Thomas Petazzoni (2):
      ARM: mvebu: do not duplicate the mpic alias
      arm: mvebu: fix the 'ranges' property to handle PCIe

Tony Lindgren (1):
      ARM: dts: Fix musb interrupt for device tree booting

Vaibhav Hiremath (1):
      ARM: AM33XX: Add missing .clkdm_name to clkdiv32k_ick clock

Wei Yongjun (1):
      ARM: OMAP: fix error return code in omap1_system_dma_init()

jean-philippe francois (1):
      ARM: OMAP: fix __init section mismatch for _enable_preprogram

 Documentation/devicetree/bindings/net/macb.txt     |   2 +-
 arch/arm/boot/dts/Makefile                         |   4 +-
 arch/arm/boot/dts/armada-370-xp.dtsi               |   3 +-
 arch/arm/boot/dts/armada-370.dtsi                  |   7 +-
 arch/arm/boot/dts/armada-xp-gp.dts                 |   3 +
 arch/arm/boot/dts/armada-xp-openblocks-ax3-4.dts   |   3 +
 arch/arm/boot/dts/armada-xp.dtsi                   |   2 +-
 arch/arm/boot/dts/at91sam9260.dtsi                 |   2 +-
 arch/arm/boot/dts/at91sam9n12.dtsi                 |   1 +
 arch/arm/boot/dts/at91sam9x25ek.dts                |   2 +-
 arch/arm/boot/dts/omap3.dtsi                       |   2 +-
 arch/arm/boot/dts/sama5d3.dtsi                     |  12 +--
 arch/arm/boot/dts/sama5d3xcm.dtsi                  |   4 +
 arch/arm/boot/dts/ste-nomadik-s8815.dts            |  12 ++-
 arch/arm/boot/dts/sun4i-a10-mini-xplus.dts         |   4 +-
 arch/arm/configs/omap2plus_defconfig               |   1 +
 arch/arm/configs/tegra_defconfig                   |   3 +-
 arch/arm/include/debug/ux500.S                     |   6 +-
 arch/arm/mach-at91/at91rm9200_time.c               |   7 +-
 arch/arm/mach-at91/at91sam9n12.c                   |   6 --
 arch/arm/mach-at91/include/mach/at91_pmc.h         |   6 +-
 arch/arm/mach-imx/clk-imx6q.c                      |  11 +-
 arch/arm/mach-imx/headsmp.S                        |  12 +++
 arch/arm/mach-imx/platsmp.c                        |  14 +++
 arch/arm/mach-kirkwood/common.c                    |   6 --
 arch/arm/mach-kirkwood/ts219-setup.c               |   2 +-
 arch/arm/mach-mvebu/Kconfig                        |   1 +
 arch/arm/mach-mvebu/armada-370-xp.c                |   7 --
 arch/arm/mach-omap1/dma.c                          |   1 +
 arch/arm/mach-omap2/cclock33xx_data.c              |  26 ++++-
 arch/arm/mach-omap2/omap_hwmod.c                   | 113 +++++----------------
 arch/arm/mach-omap2/omap_hwmod.h                   |   7 +-
 arch/arm/mach-omap2/omap_hwmod_2xxx_ipblock_data.c |   3 +
 arch/arm/mach-omap2/omap_hwmod_33xx_data.c         |   6 ++
 arch/arm/mach-omap2/omap_hwmod_3xxx_data.c         |   4 +
 arch/arm/mach-omap2/omap_hwmod_44xx_data.c         |   6 +-
 arch/arm/mach-omap2/serial.c                       |  31 ------
 arch/arm/mach-orion5x/common.c                     |   7 --
 arch/arm/mach-shmobile/board-marzen.c              |   6 +-
 arch/arm/mach-sunxi/Kconfig                        |   1 +
 arch/arm/mach-ux500/Kconfig                        |   1 +
 arch/arm/mach-ux500/board-mop500.c                 |   6 +-
 arch/arm/mach-ux500/cpu-db8500.c                   |   6 +-
 arch/arm/mach-ux500/setup.h                        |   2 +-
 arch/arm/mach-vt8500/vt8500.c                      |   1 +
 arch/arm/plat-orion/common.c                       |  12 +--
 arch/arm/plat-orion/include/plat/common.h          |   1 +
 drivers/clk/tegra/clk-tegra20.c                    |  11 +-
 drivers/tty/serial/omap-serial.c                   |  23 -----
 include/linux/platform_data/serial-omap.h          |   2 -
 50 files changed, 185 insertions(+), 236 deletions(-)
