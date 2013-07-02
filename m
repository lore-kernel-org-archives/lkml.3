Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754744Ab3GBTTH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 15:19:07 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:53092 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754024Ab3GBTTD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 15:19:03 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL 4/7] ARM SoC board specific changes
Date: Tue, 2 Jul 2013 21:06:06 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arm@kernel.org
References: <201307022055.50717.arnd@arndb.de>
In-Reply-To: <201307022055.50717.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Message-Id: <201307022106.06880.arnd@arndb.de>
X-Provags-ID: V02:K0:inV8UQxUACjZ6m/h3QQx7RjY/8q58pJ+fq3Rad1ttjL
 DRRl0iVwF1yAcINKqhmiyLSJuwXpvKKm8W7zpW2zAwKv/pMoXL
 400fiXdcZJe4eitXpbMih4tFsiacO5dFemfgaiHXQfxKURvH5s
 usaBFRCDKkSjcckCmtMGKho8EAk/gpRc63AeTTC0H+/8mXYAgk
 XxhGTYflnQZ3hhM7kRZcjuNwjEAx2uASTVo1aq1E5XVPvVUcSW
 Bpw3VK0p2sxB3kToYIKfirYLUZLUH8PUEfel+PrxFZqlgQxl6p
 0INpyHmTdjBiKRBYBYT+faiIbopl89VGyNKid17WTIADu9dD/1
 p2vHdmqPgOlcbB/6IV8c=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 7d132055814ef17a6c7b69f342244c410a5e000f:

  Linux 3.10-rc6 (2013-06-15 11:51:07 -1000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/boards-for-linus

for you to fetch changes up to f8ace40e88eb7063f66697713373ac64cbc1412a:

  Merge tag 'zynq-defconfig-for-3.11' of git://git.xilinx.com/linux-xlnx into next/boards (2013-06-21 15:48:32 +0200)

----------------------------------------------------------------

ARM SoC board specific changes

These are 18 branches on 9 platforms with board specific changes, mostly
for defconfig files, but nothing really exciting in here.

Since the shmobile platform still uses board files for some of the newer
machines, we get a few changes there as the result of drivers getting
enabled for those boards. This causes some conflicts with contents getting
added from multiple branches in sh-mobile specific files. Renesas is
putting a lot of work into migrating to device-tree based setup, which
will make all those files obsolete in the future and avoid both the
conflicts and the need to have these files in the first place.

----------------------------------------------------------------

Aaro Koskinen (1):
      ARM: OMAP1: nokia770: enable Tahvo

Adrien Vergé (1):
      ARM: omap2plus_defconfig: enable USB_PHY and NOP_USB_XCEIV

Andrew Lunn (2):
      ARM: Kirkwood: Make use of the QNAP Power off driver.
      ARM: Kirkwood: Convert LSXL to restart-poweroff driver.

Arnd Bergmann (5):
      ARM: ux500: avoid warning in ux500_read_asicid
      Merge tag 'omap-for-v3.11/board-signed' of git://git.kernel.org/.../tmlind/linux-omap into next/boards
      Merge tag 'renesas-boards2-for-v3.11' of git://git.kernel.org/.../horms/renesas into next/boards
      Merge tag 'zynq-defconfig-for-3.11' of git://git.xilinx.com/linux-xlnx into next/boards
      Merge tag 'boards-for-linus' into for-linus

Fabio Baltieri (1):
      ARM: ux500: update MSP1 pinctrl defintions

Florian Vaussard (1):
      arm: omap: board-overo: reset GPIO for SMSC911x

Guennadi Liakhovetski (2):
      ARM: shmobile: kzm9g: enable AS3711 PMIC in defconfig
      ARM: shmobile: kzm9g: add AS3711 PMIC platform data

Kuninori Morimoto (13):
      ARM: shmobile: bockw: enable SDHI on defconfig
      ARM: shmobile: ape6evm: MP clock parent become EXTAL2
      ARM: shmobile: bockw: define FPGA address and rename iomem variable
      ARM: shmobile: bockw: add CN9 SCIF/RCAN selection dipswitch explanation
      ARM: shmobile: bockw: add dummy regulators for SMSC
      ARM: shmobile: bockw: add SDHI0 support
      ARM: shmobile: marzen: keep local function as static
      ARM: shmobile: bockw defconfig: add RTC RX8581 support
      ARM: shmobile: bockw defconfig: add M25P80 support
      ARM: shmobile: bockw defconfig: add MMCIF support
      ARM: shmobile: bockw: add I2C device support
      ARM: shmobile: bockw: add SPI FLASH support
      ARM: shmobile: bockw: add MMCIF support

Lee Jones (3):
      ARM: ux500: Increase the size of the PRCMU's TCPM size
      ARM: ux500: Remove incorrect DB9540 PRCMU TCDM base location
      ARM: ux500: regulators: Remove misleading comment

Lokesh Vutla (1):
      ARM: OMAP3EVM: Marking omap3_evm_display_init() with CONFIG_BROKEN

Nobuhiro Iwamatsu (1):
      ARM: shmobile: armadillo800eva: Fix maximum number of SCIF

Olof Johansson (11):
      Merge tag 'boards-3.11-2' of git://git.infradead.org/users/jcooper/linux into next/boards
      Merge tag 'renesas-defconfig-for-v3.11' of git://git.kernel.org/.../horms/renesas into next/boards
      Merge branch 'renesas/pinmux-gpio' into next/boards
      Merge branch 'renesas/soc' into next/boards
      Merge tag 'renesas-boards-for-v3.11' of git://git.kernel.org/.../horms/renesas into next/boards
      Merge tag 'ux500-core-for-arm-soc' of git://git.kernel.org/.../linusw/linux-stericsson into next/boards
      Merge tag 'ux500-pinctrl-for-arm-soc' of git://git.kernel.org/.../linusw/linux-stericsson into next/boards
      ARM: ux500: board-mop500: remove unused pin modes
      Merge tag 'bcm2835-for-3.11-defconfig' of git://git.kernel.org/.../swarren/linux-rpi into next/boards
      Merge tag 'renesas-defconfig2-for-v3.11' of git://git.kernel.org/.../horms/renesas into next/boards
      Merge tag 'tegra-for-3.11-defconfig' of git://git.kernel.org/.../swarren/linux-tegra into next/boards

Patrice Chotard (1):
      ARM: ux500: add ABx500 pinctrl tables

Sergei Shtylyov (3):
      ARM: shmobile: bockw: enable USB in defconfig
      ARM: shmobile: BOCK-W: add Ether support
      ARM: shmobile: BOCK-W: change Ether device name

Simon Baatz (1):
      ARM: Kirkwood: add DT support for Sheevaplug and Sheevaplug eSATA

Simon Horman (6):
      Merge branches 'pinmux' and 'soc' into boards-base
      ARM: shmobile: kzm9d: resigser smsc911x platform device with id -1
      ARM: shmobile: lager: Add GPIO LEDs
      ARM: shmobile: lager: support GPIO switches
      ARM: shmobile: marzen: Use INTC External IRQ pin driver for SMSC
      Merge branch 'soc2' into boards-base

Soren Brinkmann (2):
      arm: multi_v7_defconfig: Enable Zynq UART driver
      arm: multi_v7_defconfig: Enable initrd/initramfs support

Stephen Warren (2):
      ARM: bcm2835: defconfig updates
      ARM: tegra: defconfig updates

Ulf Hansson (6):
      ARM: ux500: Enable 100MHz for SD/SDIO/MMC devices
      ARM: ux500: Don't set plf ocr mask for SD/MMC device
      ARM: ux500: Enable support for RPMB and Reliable Write for eMMC
      ARM: ux500: Enable support for discard for MMC/SD
      ARM: ux500: Set eMMC and WLAN card slot as non-removable
      ARM: ux500: Enable support for UHS-I SD-cards

Vladimir Barinov (2):
      ARM: shmobile: bockw: enable I2C in defconfig
      ARM: shmobile: bockw: enable CONFIG_PM_RUNTIME in defconfig

 arch/arm/boot/dts/kirkwood-lsxl.dtsi          |   4 +
 arch/arm/boot/dts/kirkwood-ts219.dtsi         |   5 +
 arch/arm/configs/armadillo800eva_defconfig    |   2 +-
 arch/arm/configs/bcm2835_defconfig            |  19 +-
 arch/arm/configs/bockw_defconfig              |  27 ++-
 arch/arm/configs/kzm9g_defconfig              |   3 +
 arch/arm/configs/multi_v7_defconfig           |   3 +
 arch/arm/configs/omap2plus_defconfig          |   2 +
 arch/arm/configs/tegra_defconfig              |  23 ++-
 arch/arm/mach-kirkwood/Kconfig                |   9 +
 arch/arm/mach-kirkwood/Makefile               |   1 +
 arch/arm/mach-kirkwood/board-dt.c             |   4 +
 arch/arm/mach-kirkwood/board-lsxl.c           |  16 --
 arch/arm/mach-kirkwood/board-sheevaplug.c     |  27 +++
 arch/arm/mach-kirkwood/board-ts219.c          |   3 -
 arch/arm/mach-kirkwood/common.h               |   5 +
 arch/arm/mach-omap1/board-nokia770.c          |  10 +
 arch/arm/mach-omap2/board-omap3evm.c          |   4 +
 arch/arm/mach-omap2/board-overo.c             |   3 +-
 arch/arm/mach-shmobile/board-ape6evm.c        |  15 ++
 arch/arm/mach-shmobile/board-bockw.c          | 158 +++++++++++++-
 arch/arm/mach-shmobile/board-kzm9d.c          |   2 +-
 arch/arm/mach-shmobile/board-kzm9g.c          | 193 +++++++++++++-----
 arch/arm/mach-shmobile/board-lager.c          |  49 +++++
 arch/arm/mach-shmobile/board-marzen.c         |   3 +-
 arch/arm/mach-ux500/board-mop500-pins.c       | 283 ++++++++++++++++++++++++--
 arch/arm/mach-ux500/board-mop500-regulators.c |   1 -
 arch/arm/mach-ux500/board-mop500-sdi.c        |  34 ++--
 arch/arm/mach-ux500/db8500-regs.h             |   3 +-
 arch/arm/mach-ux500/devices-db8500.c          |   2 +-
 arch/arm/mach-ux500/id.c                      |   6 +-
 31 files changed, 791 insertions(+), 128 deletions(-)
 create mode 100644 arch/arm/mach-kirkwood/board-sheevaplug.c
