Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756918Ab3EDHrB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 May 2013 03:47:01 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:57650 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757033Ab3EDHqa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 May 2013 03:46:30 -0400
From: Olof Johansson <olof@lixom.net>
To: torvalds@linux-foundation.org
Cc: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Olof Johansson <olof@lixom.net>
Subject: [GIT PULL 4/4] ARM: arm-soc board specific changes for 3.10, part 1
Date: Sat,  4 May 2013 00:42:48 -0700
Message-Id: <1367653368-25291-5-git-send-email-olof@lixom.net>
X-Mailer: git-send-email 1.8.1.192.gc4361b8
In-Reply-To: <1367653368-25291-1-git-send-email-olof@lixom.net>
References: <1367653368-25291-1-git-send-email-olof@lixom.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These changes are all for board specific files. These used to make up a
large portion of the ARM changes in the past, but as we are generalizing
the support and moving to device tree probing, this has gotten
significantly smaller. The only platform actually adding new code here
at the moment is Renesas shmobile, as they are still busy converting
their code to device tree and have not come far enough to not need it.

Conflicts:

arch/arm/Kconfig.debug:
Add/add conflict, keep both.

----------------------------------------------------------------

The following changes since commit c77984fd31ca2b2a3227eae717587da60072685f:

  Merge branch 'next/firmware' into HEAD

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/boards-for-linus

for you to fetch changes up to 21bdcc1a2ffce8c9bc7caad711401fff47f99c00:

  ARM: msm: USB_MSM_OTG needs USB_PHY

----------------------------------------------------------------

Aaro Koskinen (2):
      ARM: OMAP1: fix omap_udc registration
      ARM: OMAP: RX-51: add missing regulator supply definitions for lis3lv02d

Andrew Chew (1):
      ARM: OMAP: board-4430sdp: Provide regulator to pwm-backlight

Arnaud Ebalard (1):
      ARM: kirkwood: Add support for NETGEAR ReadyNAS Duo v2 using DT

Arnd Bergmann (6):
      ARM: shmobile: mark mackerel sh_mmcif_device __maybe_unused
      Merge tag 'renesas-boards-for-v3.10' of git://git.kernel.org/.../horms/renesas into next/boards
      Merge tag 'renesas-boards2-for-v3.10' of git://git.kernel.org/.../horms/renesas into next/boards
      Merge tag 'davinci-for-v3.10/board' of git://git.kernel.org/.../nsekhar/linux-davinci into next/boards
      Merge tag 'omap-for-v3.10/board-signed' of git://git.kernel.org/.../tmlind/linux-omap into next/boards
      ARM: msm: USB_MSM_OTG needs USB_PHY

David Brown (1):
      ARM: msm: enable SSBI driver in defconfig

Guennadi Liakhovetski (11):
      ARM: shmobile: use GPIO SD-card detection on armadillo800eva
      ARM: shmobile: switch SDHI0 to GPIO regulator on armadillo800eva
      ARM: shmobile: streamline mackerel SD and MMC devices
      ARM: shmobile: parse DT and configure pinmux early on kzm9g-reference
      ARM: shmobile: SDHI and MMCIF interfaces to kzm9g-reference
      ARM: shmobile: simplify kzm9g Kconfig dependencies
      ARM: shmobile: kzm9g: SDHI0 and SDHI1 use a 3.3V power supply
      ARM: shmobile: sh73a0: move SDHI and MMCIF DT nodes to sh73a0.dtsi
      ARM: shmobile: armadillo800eva: add a fixed voltage regulator for SDHI1
      ARM: shmobile: kzm9g: add fixed voltage regulators for SDHI0 and SDHI2
      ARM: shmobile: kzm9g-reference: fix device-tree bindings and device names

Haojian Zhuang (5):
      ARM: pxa: remove cpu_is_xxx in gpio driver
      ARM: pxa: move PXA_GPIO_TO_IRQ macro
      ARM: mmp: add more compatible names in gpio driver
      ARM: pxa: select PXA935 on saar & tavorevb
      ARM: pxa: move debug uart code

Kuninori Morimoto (1):
      ARM: shmobile: marzen: Use gic_iid macro for ICCIAR / interrupt ID

Lad, Prabhakar (1):
      ARM: davinci: use is IS_ENABLED macro

Olof Johansson (4):
      Merge branch 'armsoc/pxa' of git://github.com/hzhuang1/linux into next/boards
      Merge tag 'msm-defconfig-3.10' of git://git.kernel.org/.../davidb/linux-msm into next/boards
      Merge tag 'boards-3.10' of git://git.infradead.org/users/jcooper/linux into next/boards
      Merge tag 'davinci-for-v3.10/board-2-v2' of git://git.kernel.org/.../nsekhar/linux-davinci into next/boards

Paul Bolle (2):
      omap2+: Remove useless Makefile line
      omap2+: Remove useless Makefile line

Peter Ujfalusi (1):
      ARM: OMAP: zoom: Use pwm stack for lcd and keyboard backlight

Robert Tivy (1):
      ARM: davinci: da850 board: add remoteproc support

Ruslan Bilovol (1):
      ARM: OMAP2+: omap2plus_defconfig: Add support for BMP085 pressure sensor

Sebastian Hesselbarth (1):
      ARM: kirkwood: add MACH_GURUPLUG_DT to defconfig

Sekhar Nori (2):
      ARM: davinci: defconfig: enable CGROUPS
      ARM: davinci: da850 evm: fix const qualifier placement

Simon Guinot (3):
      ARM: Kirkwood: sort board entries by ASCII-code order
      ARM: Kirkwood: DT board setup for CloudBox
      ARM: Kirkwood: update Network Space Mini v2 description

Simon Horman (7):
      Merge branches 'soc' and 'pinmux' into boards-base
      ARM: shmobile: marzen: Reference DT implementation
      ARM: shmobile: kzm9g: Reference DT implementation
      ARM: shmobile: kzm9g: Remove warning about SMP
      ARM: shmobile: kzm9g: Trim reference DT_MACHINE_START
      ARM: shmobile: kzm9g: correct smsc regulator registration
      Revert "ARM: shmobile: streamline mackerel SD and MMC devices"

Stephen Boyd (1):
      ARM: msm: Concentrate defconfig on DT supported devices


 .../devicetree/bindings/gpio/mrvl-gpio.txt      |   7 +-
 arch/arm/Kconfig.debug                          |   9 +
 arch/arm/boot/dts/Makefile                      |   6 +-
 arch/arm/boot/dts/kirkwood-cloudbox.dts         |  89 +++++
 .../dts/kirkwood-netgear_readynas_duo_v2.dts    | 180 ++++++++++
 arch/arm/boot/dts/kirkwood-ns2mini.dts          |   1 +
 arch/arm/boot/dts/mmp2.dtsi                     |   2 +-
 arch/arm/boot/dts/pxa168.dtsi                   |   2 +-
 arch/arm/boot/dts/pxa910.dtsi                   |   2 +-
 arch/arm/boot/dts/r8a7779-marzen-reference.dts  |  47 +++
 arch/arm/boot/dts/sh73a0-kzm9g-reference.dts    |  66 ++++
 arch/arm/boot/dts/sh73a0-reference.dtsi         |  24 --
 arch/arm/boot/dts/sh73a0.dtsi                   |  44 +++
 arch/arm/configs/da8xx_omapl_defconfig          |   1 +
 arch/arm/configs/davinci_all_defconfig          |   1 +
 arch/arm/configs/kirkwood_defconfig             |  53 +--
 arch/arm/configs/msm_defconfig                  | 155 ++++++---
 arch/arm/configs/omap2plus_defconfig            |   1 +
 arch/arm/include/debug/pxa.S                    |  33 ++
 arch/arm/mach-davinci/board-da830-evm.c         |   6 +-
 arch/arm/mach-davinci/board-da850-evm.c         |  17 +-
 arch/arm/mach-davinci/board-dm644x-evm.c        |  25 +-
 arch/arm/mach-davinci/board-dm646x-evm.c        |   7 +-
 arch/arm/mach-davinci/board-neuros-osd2.c       |  15 +-
 arch/arm/mach-davinci/board-omapl138-hawk.c     |   6 +
 arch/arm/mach-davinci/devices.c                 |   2 +-
 arch/arm/mach-davinci/usb.c                     |   2 +-
 arch/arm/mach-kirkwood/Kconfig                  | 334 ++++++++++---------
 arch/arm/mach-kirkwood/Makefile                 |  42 +--
 arch/arm/mach-kirkwood/board-dt.c               |  18 +-
 arch/arm/mach-kirkwood/board-ns2.c              |   3 +-
 arch/arm/mach-kirkwood/board-readynas.c         |  28 ++
 arch/arm/mach-kirkwood/common.h                 |  12 +
 arch/arm/mach-mmp/aspenite.c                    |   7 +
 arch/arm/mach-mmp/avengers_lite.c               |   7 +
 arch/arm/mach-mmp/brownstone.c                  |   7 +
 arch/arm/mach-mmp/clock-mmp2.c                  |   2 +-
 arch/arm/mach-mmp/clock-pxa168.c                |   2 +-
 arch/arm/mach-mmp/clock-pxa910.c                |   2 +-
 arch/arm/mach-mmp/flint.c                       |   7 +
 arch/arm/mach-mmp/gplugd.c                      |   7 +
 arch/arm/mach-mmp/include/mach/debug-macro.S    |  30 --
 arch/arm/mach-mmp/jasper.c                      |   8 +
 arch/arm/mach-mmp/mmp-dt.c                      |   4 +-
 arch/arm/mach-mmp/mmp2-dt.c                     |   2 +-
 arch/arm/mach-mmp/mmp2.c                        |   2 +-
 arch/arm/mach-mmp/pxa168.c                      |   2 +-
 arch/arm/mach-mmp/pxa910.c                      |   2 +-
 arch/arm/mach-mmp/tavorevb.c                    |   7 +
 arch/arm/mach-mmp/teton_bga.c                   |   7 +
 arch/arm/mach-mmp/ttc_dkb.c                     |   7 +
 arch/arm/mach-omap1/include/mach/usb.h          |   2 +-
 arch/arm/mach-omap1/usb.c                       |   6 +-
 arch/arm/mach-omap2/Makefile                    |   3 -
 arch/arm/mach-omap2/board-4430sdp.c             |   6 +
 arch/arm/mach-omap2/board-rx51-peripherals.c    |   4 +
 arch/arm/mach-omap2/board-zoom-display.c        |  56 ----
 arch/arm/mach-omap2/board-zoom-peripherals.c    |  53 ++-
 arch/arm/mach-pxa/Kconfig                       |   2 +
 arch/arm/mach-pxa/devices.c                     |  29 +-
 arch/arm/mach-pxa/devices.h                     |   6 +-
 arch/arm/mach-pxa/include/mach/debug-macro.S    |  23 --
 arch/arm/mach-pxa/pxa25x.c                      |  11 +-
 arch/arm/mach-pxa/pxa27x.c                      |   7 +-
 arch/arm/mach-pxa/pxa3xx.c                      |  23 +-
 arch/arm/mach-pxa/pxa930.c                      |  17 +-
 arch/arm/mach-shmobile/Kconfig                  |  27 ++
 arch/arm/mach-shmobile/Makefile                 |   2 +
 arch/arm/mach-shmobile/board-armadillo800eva.c  | 148 ++++++--
 arch/arm/mach-shmobile/board-kzm9g-reference.c  | 107 ++++++
 arch/arm/mach-shmobile/board-kzm9g.c            |  82 ++++-
 arch/arm/mach-shmobile/board-mackerel.c         |   2 +-
 arch/arm/mach-shmobile/board-marzen-reference.c |  75 +++++
 arch/arm/mach-shmobile/board-marzen.c           |  12 +-
 drivers/clk/mmp/clk-mmp2.c                      |   2 +-
 drivers/clk/mmp/clk-pxa168.c                    |   2 +-
 drivers/clk/mmp/clk-pxa910.c                    |   2 +-
 drivers/gpio/gpio-pxa.c                         | 151 +++++----
 include/linux/gpio-pxa.h                        |   1 +
 79 files changed, 1627 insertions(+), 586 deletions(-)
 create mode 100644 arch/arm/boot/dts/kirkwood-cloudbox.dts
 create mode 100644 arch/arm/boot/dts/kirkwood-netgear_readynas_duo_v2.dts
 create mode 100644 arch/arm/boot/dts/r8a7779-marzen-reference.dts
 create mode 100644 arch/arm/boot/dts/sh73a0-kzm9g-reference.dts
 delete mode 100644 arch/arm/boot/dts/sh73a0-reference.dtsi
 create mode 100644 arch/arm/include/debug/pxa.S
 create mode 100644 arch/arm/mach-kirkwood/board-readynas.c
 delete mode 100644 arch/arm/mach-mmp/include/mach/debug-macro.S
 delete mode 100644 arch/arm/mach-pxa/include/mach/debug-macro.S
 create mode 100644 arch/arm/mach-shmobile/board-kzm9g-reference.c
 create mode 100644 arch/arm/mach-shmobile/board-marzen-reference.c
