Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753678AbaDETEz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Apr 2014 15:04:55 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:53129 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753489AbaDETEy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Apr 2014 15:04:54 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL 4/8] ARM: SoC: board changes
Date: Sat, 5 Apr 2014 20:04:48 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, arm@kernel.org,
        linux-arm-kernel@lists.infradead.org
References: <201404052101.19381.arnd@arndb.de>
In-Reply-To: <201404052101.19381.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201404052104.48617.arnd@arndb.de>
X-Provags-ID: V02:K0:1A/J7IRg93ryL/RwpA+CAR5GLXR+mztDIgc/eUihb1R
 uzZlqF7LaOjLzC4ia4dlxUp+dPJi66IOQ6iaETlO4m52TUckQK
 UiVk/nzEDxo8ayng4dV6XBCu7hdc3Jz5axDwD7Kb1IF1G4WvKK
 xcdXKYkcXZojbKHJp13TB7+9nBgnrqG78aSwEAAZydMmcDRiSq
 IJ2qae7lHw/ZdUFkMCRdtEnsbp1F6Npz4v4Az6wX4mJYmU0UOT
 tM0YPjSli6UHugeyUQGLlcpHI8xNE6ugS0iH56VYE/E3XEofNt
 Epqbqrw7PwtHiw08MDA7d223y0hbR5f0doV+wfGrxhMG0B5nlI
 09gC5aaxj1n38/sWZ3H/Q1ZXm4o2NYDfQirkyh8Dv
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 6d0abeca3242a88cab8232e4acd7e2bf088f3bc2:

  Linux 3.14-rc3 (2014-02-16 13:30:25 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/boards-3.15

for you to fetch changes up to 077492acceeafc0a106f88b0780623d2321a8947:

  ARM: enable fhandle in multi_v7_defconfig (2014-03-26 23:20:03 +0100)

----------------------------------------------------------------
ARM: SoC: board changes

As we continue to replace board files with device tree descriptions,
this part of the ARM support is getting smaller. We have basically just
defconfig changes here this time, and a significant number of Renesas
shmobile changes, as Renesas is still in the process of deprecating
board file support.

----------------------------------------------------------------
Alexandre Courbot (2):
      ARM: tegra: enable fhandle in tegra_defconfig
      ARM: enable fhandle in multi_v7_defconfig

Andrew Lunn (3):
      ARM: config: Add a multi_v5_defconfig
      ARM: config: Add mvebu_v5_defconfig
      ARM: kirkwood: Add HP T5325 devices to {multi|mvebu}_v5_defconfig

Arnd Bergmann (3):
      Merge tag 'mvebu-defconfig-3.15-2' of git://git.infradead.org/linux-mvebu into next/boards
      ARM: fix duplicate symbols in multi_v5_defconfig
      Merge tag 'sunxi-defconfig-for-3.15' of https://github.com/mripard/linux into next/boards

Ben Dooks (2):
      ARM: shmobile: lager: fix error return code check from clk_get()
      ARM: shmobile: koelsch: fix error return code check from clk_get()

Dmitry Eremin-Solenikov (1):
      ARM: pxa: add gpio keys information

Ezequiel Garcia (3):
      ARM: dove: Remove UBI support from defconfig
      ARM: mvebu: Enable watchdog support in defconfig
      ARM: dove: Enable watchdog support in the defconfig

Geert Uytterhoeven (9):
      ARM: shmobile: lager: Make spi_flash_data const
      ARM: shmobile: koelsch: Enable DEVTMPFS_MOUNT in defconfig
      ARM: shmobile: genmai legacy: Add RSPI support
      ARM: shmobile: koelsch legacy: Add QSPI support
      ARM: shmobile: lager legacy: Switch QSPI to named IRQs
      ARM: shmobile: koelsch defconfig: Enable RSPI and MTD_M25P80
      ARM: shmobile: genmai defconfig: Enable RSPI
      ARM: shmobile: lager legacy: Add QSPI pinmux
      ARM: shmobile: lager defconfig: Enable RSPI and MTD_M25P80

Grygorii Strashko (2):
      ARM: config: keystone: enable gpio support
      ARM: config: keystone: enable led support

Ivan Khoronzhuk (2):
      ARM: config: keystone: enable watchdog support
      ARM: config: keystone: enable AEMIF/NAND support

Kumar Gala (1):
      ARM: qcom: Enable basic support for Qualcomm platforms in multi_v7_defconfig

Kuninori Morimoto (16):
      ARM: shmobile: bockw: use SSI DMAEngine for sound
      ARM: shmobile: bockw: use HPBIF DMAEngine for sound
      ARM: shmobile: bockw: add USB Func DMAEngine support
      ARM: shmobile: marzen: enable CONFIG_DEVTMPFS in defconfig
      ARM: shmobile: mackerel: enable CONFIG_DEVTMPFS in defconfig
      ARM: shmobile: lager: enable CONFIG_DEVTMPFS in defconfig
      ARM: shmobile: kzm9g: enable CONFIG_DEVTMPFS in defconfig
      ARM: shmobile: kzm9d: enable CONFIG_DEVTMPFS in defconfig
      ARM: shmobile: genmai: enable CONFIG_DEVTMPFS in defconfig
      ARM: shmobile: bockw: enable CONFIG_DEVTMPFS in defconfig
      ARM: shmobile: armadillo: enable CONFIG_DEVTMPFS in defconfig
      ARM: shmobile: ape6evm: enable CONFIG_DEVTMPFS in defconfig
      ARM: shmobile: bockw: use wp-gpios instead of WP pin
      ARM: shmobile: lager: add sound support
      ARM: shmobile: lager: add sound support on defconfig
      ARM: shmobile: lager: add SDHI0/2 support

Laurent Pinchart (4):
      ARM: shmobile: lager-reference: Refactor clock lookup hack
      ARM: shmobile: lager-reference: Add DU device
      ARM: shmobile: koelsch-reference: Refactor clock lookup hack
      ARM: shmobile: koelsch-reference: Add DU device

Laxman Dewangan (1):
      ARM: tegra: defconfig updates

Magnus Damm (7):
      ARM: shmobile: Remove Lager USBHS UDC ifdefs
      ARM: shmobile: Lager USB0 cable detection workaround
      ARM: shmobile: Add SDHI devices for legacy Koelsch
      ARM: shmobile: Get rid of legacy KZM9D defconfig
      ARM: shmobile: Remove KZM9D board code
      ARM: shmobile: Remove Koelsch DT reference legacy clock bits
      ARM: shmobile: Remove Lager DT reference legacy clock bits

Maxime Ripard (1):
      ARM: sunxi: Enable A31 SPI and SID in the defconfig

Olof Johansson (10):
      Merge tag 'renesas-boards-for-v3.15' of git://git.kernel.org/.../horms/renesas into next/boards
      Merge tag 'renesas-defconfig-for-v3.15' of git://git.kernel.org/.../horms/renesas into next/boards
      Merge tag 'renesas-boards2-for-v3.15' of git://git.kernel.org/.../horms/renesas into next/boards
      Merge tag 'renesas-defconfig2-for-v3.15' of git://git.kernel.org/.../horms/renesas into next/boards
      Merge tag 'mvebu-defconfig-3.15' of git://git.infradead.org/linux-mvebu into next/boards
      Merge tag 'pxa' of https://git.kernel.org/.../hzhuang1/linux into next/boards
      Merge tag 'keystone-soc' of git://git.kernel.org/.../ssantosh/linux-keystone into next/boards
      Merge tag 'renesas-boards3-for-v3.15' of git://git.kernel.org/.../horms/renesas into next/boards
      Merge tag 'renesas-defconfig3-for-v3.15' of git://git.kernel.org/.../horms/renesas into next/boards
      Merge tag 'tegra-for-3.15-defconfig' of git://git.kernel.org/.../tegra/linux into next/boards

Sebastian Hesselbarth (1):
      ARM: add Marvell Dove and some drivers to multi_v7 defconfig

Sergei Shtylyov (8):
      ARM: shmobile: Lager: conditionally select CONFIG_MICREL_PHY
      ARM: shmobile: Lager: pass Ether PHY IRQ
      ARM: shmobile: Koelsch: pass Ether PHY IRQ
      ARM: shmobile: Armadillo 800 EVA: set proper DMA masks for Ether device
      ARM: shmobile: BOCK-W: set proper DMA masks for Ether device
      ARM: shmobile: Lager: set proper DMA masks for Ether device
      ARM: shmobile: Koelsch: set proper DMA masks for Ether device
      ARM: shmobile: Genmai: set proper DMA masks for Ether device

Simon Horman (11):
      ARM: shmobile: koelsch: Conditionally select MICREL_PHY for Multiplatform
      ARM: shmobile: ape6evm: Conditionally select SMSC_PHY
      ARM: shmobile: armadillo800eva: Conditionally select SMSC_PHY
      ARM: shmobile: bockw: Sort Kconfig node's selections
      ARM: shmobile: kzm9d: Conditionally select SMSC_PHY
      ARM: shmobile: mackerel: Conditionally select SMSC_PHY
      ARM: shmobile: marzen: Conditionally select SMSC_PHY
      Revert "ARM: shmobile: marzen: Conditionally select SMSC_PHY"
      ARM: shmobile: genmai: Enable r7s72100-ether
      ARM: shmobile: Add defconfig for shmobile multiplatform
      ARM: shmobile: koelsch: Enable SDHI, GPIO and regulators in defconfig

Stephen Warren (1):
      ARM: update multi_v7_defconfig for Tegra

Takashi Yoshii (1):
      ARM: shmobile: kzm9d: Use common clock framework

Thomas Petazzoni (3):
      ARM: mvebu: rename mvebu_defconfig to mvebu_v7_defconfig
      ARM: mvebu: enable audio options in mvebu_defconfig
      ARM: mvebu: update defconfigs for Armada 375 and 38x

Ulrich Hecht (1):
      ARM: mach-shmobile: kzm9g: add zboot support

Valentine Barshak (10):
      ARM: shmobile: lager: Add VIN1 SoC camera support
      ARM: shmobile: lager: Add SATA support
      ARM: shmobile: koelsch: Add SATA0 support
      ARM: shmobile: lager: Enable VIN along with ADV7180 decoder in defconfig
      ARM: shmobile: koelsch: Enable SATA in defconfig
      ARM: shmobile: lager: Enable SATA in defconfig
      ARM: shmobile: lager: Add USBHS support
      ARM: shmobile: koelsch: Add I2C support
      ARM: shmobile: koelsch: Enable I2C in defconfig
      ARM: shmobile: lager: Add internal USB PCI support

Wolfram Sang (1):
      ARM: shmobile: r7s72100: update defconfig for I2C usage

 arch/arm/boot/dts/r8a7778-bockw-reference.dts      |   4 +-
 arch/arm/configs/ape6evm_defconfig                 |   2 +
 arch/arm/configs/armadillo800eva_defconfig         |   2 +
 arch/arm/configs/bockw_defconfig                   |   2 +
 arch/arm/configs/dove_defconfig                    |   3 +-
 arch/arm/configs/genmai_defconfig                  |   8 +-
 arch/arm/configs/keystone_defconfig                |  15 +
 arch/arm/configs/koelsch_defconfig                 |  21 +-
 arch/arm/configs/kzm9d_defconfig                   |  89 ----
 arch/arm/configs/kzm9g_defconfig                   |   2 +
 arch/arm/configs/lager_defconfig                   |  21 +
 arch/arm/configs/mackerel_defconfig                |   2 +
 arch/arm/configs/marzen_defconfig                  |   2 +
 arch/arm/configs/multi_v5_defconfig                | 190 ++++++++
 arch/arm/configs/multi_v7_defconfig                |  23 +
 arch/arm/configs/mvebu_v5_defconfig                | 181 ++++++++
 .../{mvebu_defconfig => mvebu_v7_defconfig}        |   9 +
 arch/arm/configs/shmobile_defconfig                | 129 ++++++
 arch/arm/configs/sunxi_defconfig                   |   3 +
 arch/arm/configs/tegra_defconfig                   |   7 +-
 arch/arm/mach-pxa/corgi.c                          |  40 ++
 arch/arm/mach-shmobile/Kconfig                     |  18 +-
 arch/arm/mach-shmobile/Makefile                    |   1 -
 arch/arm/mach-shmobile/board-armadillo800eva.c     |   2 +
 arch/arm/mach-shmobile/board-bockw.c               |  45 +-
 arch/arm/mach-shmobile/board-genmai.c              |  75 +++-
 arch/arm/mach-shmobile/board-koelsch-reference.c   | 106 ++++-
 arch/arm/mach-shmobile/board-koelsch.c             | 305 ++++++++++++-
 arch/arm/mach-shmobile/board-kzm9d-reference.c     |  48 --
 arch/arm/mach-shmobile/board-lager-reference.c     | 109 ++++-
 arch/arm/mach-shmobile/board-lager.c               | 492 ++++++++++++++++++++-
 arch/arm/mach-shmobile/include/mach/head-kzm9g.txt | 410 +++++++++++++++++
 arch/arm/mach-shmobile/include/mach/zboot.h        |   3 +
 arch/arm/mach-shmobile/include/mach/zboot_macros.h |  43 ++
 34 files changed, 2196 insertions(+), 216 deletions(-)
 delete mode 100644 arch/arm/configs/kzm9d_defconfig
 create mode 100644 arch/arm/configs/multi_v5_defconfig
 create mode 100644 arch/arm/configs/mvebu_v5_defconfig
 rename arch/arm/configs/{mvebu_defconfig => mvebu_v7_defconfig} (91%)
 create mode 100644 arch/arm/configs/shmobile_defconfig
 delete mode 100644 arch/arm/mach-shmobile/board-kzm9d-reference.c
 create mode 100644 arch/arm/mach-shmobile/include/mach/head-kzm9g.txt
