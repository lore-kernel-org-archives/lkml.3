Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932348Ab3CLNvc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 09:51:32 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:62039 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753648Ab3CLNvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 09:51:31 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL]  arm-soc fixes for 3.9-rc2
Date: Tue, 12 Mar 2013 13:51:23 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-8-generic; KDE/4.3.2; x86_64; ; )
Cc: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201303121351.23297.arnd@arndb.de>
X-Provags-ID: V02:K0:yLNJ0FEagf0lsLXSFx2HEjFTDJJJRvD4vpSkqujiJ6G
 VWl92sjBo6It5O9KdgFPM6zn+XMRbtFBxvJcvV1zSb0eH/E3j1
 T+oyoxNJDhK0lJz5WxFGw1xpjbnBs48PCBnsVRQHI1Ut74Sq/D
 +ecncC7tESIJZ30x5jVb74p2m+kXgC4hbpJUWUBNqhIF8THwux
 y+U6Uu2WnLXcwHUkKMTaIF7oCwqGZUq9LUt/xscNekomW3eXMr
 cq1dzRu0c6qAYQN50TbqrV7tkbo8SxMbVUjkssIddpWS08Gsuf
 6gij/mX0BhXEJpg3Nwbwpu6BChBjGo3prszv5WyiKCS4xNDebW
 6zyLNAsLZHUnRprCWpAw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Here is the usual round of arm-soc fixes on top of 3.9-rc2. There are a couple more
fixes in there than I'd like because Olof and I did not get around to send a pull
request last week during Linaro Connect.

	Arnd
----
The following changes since commit 6dbe51c251a327e012439c4772097a13df43c5b8:

  Linux 3.9-rc1 (2013-03-03 15:11:05 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/fixes

for you to fetch changes up to 27f423fe120df3a7488dd750b4e0508f03c325b6:

  ARM: spear3xx: Use correct pl080 header file (2013-03-12 10:56:32 +0100)

----------------------------------------------------------------
arm-soc fixes for 3.9-rc2

These bug fixes are for the largest part for mvebu/kirkwood, which
saw a few regressions after the clock infrastructure was enabled,
and for OMAP, which showed a few more preexisting bugs with
the new multiplatform support.

Other small fixes are for imx, mxs, tegra, spear and socfpga.

----------------------------------------------------------------
Aaro Koskinen (1):
      ARM: OMAP: RX-51: add missing USB phy binding

Andrew Lunn (2):
      gpio: mvebu: Add clk support to prevent lockup
      rtc: rtc-mv: Add support for clk to avoid lockups

Arnd Bergmann (5):
      Merge tag 'omap-for-v3.9-rc1/fixes-signed' of git://git.kernel.org/.../tmlind/linux-omap into fixes
      Merge tag 'mxs-fixes-3.9-2' of git://git.linaro.org/people/shawnguo/linux-2.6 into fixes
      Merge tag 'imx-fixes-3.9-2' of git://git.linaro.org/people/shawnguo/linux-2.6 into fixes
      Merge tag 'mvebu_fixes_for_v3.9' of git://git.infradead.org/users/jcooper/linux into fixes
      ARM: spear3xx: Use correct pl080 header file

Fabio Estevam (4):
      ARM: mxs_defconfig: Make USB host functional again
      ARM: mxs: mm: Fix sparse warning
      ARM: mxs: icoll: Fix sparse warning
      ARM: mxs: ocotp: Fix sparse warning

Felipe Balbi (1):
      ARM: OMAP2+: mux: fix debugfs file permission

Florian Fainelli (1):
      arm: mvebu: enable the USB ports on Armada 370 Reference Design board

Heikki Krogerus (1):
      arm: mvebu: Reduce reg-io-width with UARTs

Jason Cooper (1):
      ARM: kirkwood: of_serial: fix clock gating by removing clock-frequency

Javi Merino (1):
      irqchip: fix typo when moving gic_raise_softirq()

Jean-Francois Moine (1):
      ARM: Dove: add RTC device node

Jon Hunter (1):
      ARM: OMAP2+: Fix broken gpmc support

Maxime Ripard (2):
      ARM: mxs: cfa10049: Fix fb initialisation function
      ARM: multiplatform: Sort the max gpio numbers.

Nicolas Pitre (1):
      ARM: mach-imx: move early resume code out of the .data section

Nishanth Menon (1):
      ARM: dts: remove generated .dtb files on clean

Olof Johansson (2):
      Merge tag 'imx-fixes-3.9' of git://git.linaro.org/people/shawnguo/linux-2.6 into fixes
      Merge tag 'mxs-fixes-3.9' of git://git.linaro.org/people/shawnguo/linux-2.6 into fixes

Padmavathi Venna (1):
      Arm: socfpga: pl330: Add #dma-cells for generic dma binding support

Paul Bolle (3):
      ARM: SPEAr13xx: Fix typo "ARCH_HAVE_CPUFREQ"
      ARM: dove: drop "select COMMON_CLK_DOVE"
      ARM: imx: fix typo "DEBUG_IMX50_IMX53_UART"

Prashant Gaikwad (2):
      ARM: Tegra: Add clock entry for smp_twd clock
      clk: Tegra: Remove duplicate smp_twd clock

Rajendra Nayak (1):
      ARM: OMAP3: board-generic: Add missing omap3_init_late

Ruslan Bilovol (1):
      ARM: OMAP2+: mux: correct wrong error messages

Santosh Shilimkar (1):
      ARM: OMAP2+: Remove duplicate omap4430_init_late() declaration

Sebastian Hesselbarth (1):
      ARM: kirkwood: fix to retain gbe MAC addresses for DT kernels

Shawn Guo (2):
      ARM: dts: imx53-mba53: fix fsl,pins for disp1-grp1
      ARM: imx: pll1_sys should be an initial on clk

Stephen Warren (1):
      ARM: bcm2835: fix I2C module clock rate

Thomas Petazzoni (3):
      arm: plat-orion: fix address decoding when > 4GB is used
      arm: mvebu: fix address-cells in mpic DT node
      arm: mach-orion5x: fix typo in compatible string of a .dts file

Tony Lindgren (2):
      ARM: OMAP1: Fix build related to kgdb.h no longer including serial_8250.h
      ARM: OMAP2+: Fix unmet direct dependencies for zoom for 8250 serial

 arch/arm/Kconfig                                   |  8 ++++---
 arch/arm/Kconfig.debug                             |  2 +-
 arch/arm/boot/Makefile                             |  2 +-
 arch/arm/boot/dts/armada-370-rd.dts                |  8 +++++++
 arch/arm/boot/dts/armada-370-xp.dtsi               |  5 ++--
 arch/arm/boot/dts/armada-xp.dtsi                   |  4 ++--
 arch/arm/boot/dts/bcm2835.dtsi                     |  2 +-
 arch/arm/boot/dts/dove.dtsi                        |  5 ++++
 arch/arm/boot/dts/imx53-mba53.dts                  |  3 +--
 arch/arm/boot/dts/kirkwood-dns320.dts              |  2 --
 arch/arm/boot/dts/kirkwood-dns325.dts              |  1 -
 arch/arm/boot/dts/kirkwood-dockstar.dts            |  1 -
 arch/arm/boot/dts/kirkwood-dreamplug.dts           |  1 -
 arch/arm/boot/dts/kirkwood-goflexnet.dts           |  1 -
 arch/arm/boot/dts/kirkwood-ib62x0.dts              |  1 -
 arch/arm/boot/dts/kirkwood-iconnect.dts            |  1 -
 arch/arm/boot/dts/kirkwood-iomega_ix2_200.dts      |  1 -
 arch/arm/boot/dts/kirkwood-km_kirkwood.dts         |  1 -
 arch/arm/boot/dts/kirkwood-lschlv2.dts             |  1 -
 arch/arm/boot/dts/kirkwood-lsxhl.dts               |  1 -
 arch/arm/boot/dts/kirkwood-mplcec4.dts             |  1 -
 arch/arm/boot/dts/kirkwood-ns2-common.dtsi         |  1 -
 arch/arm/boot/dts/kirkwood-nsa310.dts              |  1 -
 arch/arm/boot/dts/kirkwood-openblocks_a6.dts       |  2 --
 arch/arm/boot/dts/kirkwood-topkick.dts             |  1 -
 arch/arm/boot/dts/kirkwood.dtsi                    |  5 ++--
 .../dts/orion5x-lacie-ethernet-disk-mini-v2.dts    |  2 +-
 arch/arm/boot/dts/socfpga.dtsi                     |  3 +++
 arch/arm/boot/dts/tegra20.dtsi                     |  1 +
 arch/arm/boot/dts/tegra30.dtsi                     |  1 +
 arch/arm/configs/mxs_defconfig                     |  1 +
 arch/arm/configs/omap2plus_defconfig               |  2 ++
 arch/arm/mach-imx/clk-imx6q.c                      |  2 +-
 arch/arm/mach-imx/headsmp.S                        | 18 +++++++-------
 arch/arm/mach-imx/pm-imx6q.c                       | 15 ------------
 arch/arm/mach-kirkwood/board-dt.c                  | 25 +++++++++++++------
 arch/arm/mach-mxs/icoll.c                          |  2 +-
 arch/arm/mach-mxs/mach-mxs.c                       | 10 ++++----
 arch/arm/mach-mxs/mm.c                             |  1 +
 arch/arm/mach-mxs/ocotp.c                          |  1 +
 arch/arm/mach-omap1/common.h                       |  2 ++
 arch/arm/mach-omap2/Kconfig                        |  6 -----
 arch/arm/mach-omap2/board-generic.c                |  2 ++
 arch/arm/mach-omap2/board-rx51.c                   |  2 ++
 arch/arm/mach-omap2/common.h                       |  1 -
 arch/arm/mach-omap2/gpmc.c                         |  6 ++---
 arch/arm/mach-omap2/mux.c                          |  9 +++----
 arch/arm/mach-spear3xx/spear3xx.c                  |  2 +-
 arch/arm/plat-orion/addr-map.c                     |  7 ++++--
 arch/arm/plat-spear/Kconfig                        |  2 +-
 drivers/clk/tegra/clk-tegra20.c                    |  1 -
 drivers/clk/tegra/clk-tegra30.c                    |  1 -
 drivers/gpio/gpio-mvebu.c                          |  7 ++++++
 drivers/irqchip/irq-gic.c                          |  2 +-
 drivers/rtc/rtc-mv.c                               | 28 ++++++++++++++++++----
 drivers/video/omap/lcd_ams_delta.c                 |  1 +
 drivers/video/omap/lcd_osk.c                       |  3 +++
 57 files changed, 131 insertions(+), 97 deletions(-)
