Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756139Ab3BUVNO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 16:13:14 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:61738 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756024Ab3BUVNJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 16:13:09 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [GIT PULL 07/09] arm-soc: board specific changes
Date: Thu, 21 Feb 2013 21:12:27 +0000
Message-Id: <1361481149-27559-8-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1361481149-27559-1-git-send-email-arnd@arndb.de>
References: <1361481149-27559-1-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V02:K0:r+lBlCqC8zpjBy+w0Xl/eIKY5Mo82zjvuacbbNtMGNg
 xyfrTwfCP3HrgKC04SDeQG7m65pDZJ/X8PuS1roY2ixAMaCvnL
 WOeynVBgNtXe/jT0ImnDFrENqQdNxaTKqnVQ83jF0wf60CULRv
 YeKpD+iUWhJbL43vddQNrOk624hvJAK0O8Ki0O9s1ZQznwgG2y
 r4LtjBdILwTXzM56QQ9sSGO/8VybCy8H14ArMIcCP2s7XoWOlP
 DBazP1ztQ5bg1p1FZJqKkHrPN056uvNl+JxWpIKBfngoUfbvbk
 KX8rUQmo6DBz43pO/6s3lttdPJmf4L3q+MGsuJogOf6uMXKBEs
 ETQeGv6GKiH8wYhAyqJ6r5pb7sDrt0Nn1/O/QWsHE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 836dc9e3fbbab0c30aa6e664417225f5c1fb1c39:

  Linux 3.8-rc7 (2013-02-09 08:20:39 +1100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/boards

for you to fetch changes up to f628e3d92465303792d52c98fb0c95bef558f936:

  Merge tag 'arm-imx-defconfig' of git://git.pengutronix.de/git/imx/linux-2.6 into next/boards (2013-02-12 15:08:53 -0800)

----------------------------------------------------------------

arm-soc: board specific changes

These updates are all for board specific code, including

* defconfig updates for shmobile, davinci, bcm2835, imx, omap and tegra
* SD/MMC and I2C support on bcm2835 (Raspberry PI)
* minor updates for PXA
* shmobile updates to GPIO usage in board files
* More things in OMAP board files are moved over to device tree probing
* Better support for audio devices on some OMAP platforms

Conflicts include the omap board-apollon.c file that is removed without
a replacement, and conflicting context in the 4430sdp board file.

----------------------------------------------------------------
Aaro Koskinen (1):
      ARM: OMAP1: nokia770: enable CBUS/Retu

Andrea Adami (1):
      ARM: pxa: pxa27x.c: add dummy SA1100 rtc clock

AnilKumar Ch (1):
      ARM: OMAP2+: AM33XX: omap2plus_defconfig: Add support for few drivers

Fabio Estevam (1):
      ARM: imx_v4_v5_defconfig: Add VPU support

Guennadi Liakhovetski (1):
      ARM: mackerel: include the correct .dtsi file

Hideki EIRAKU (1):
      ARM: shmobile: armadillo800eva: set clock rates before timer init

Igor Grinberg (1):
      ARM: OMAP3: cm-t3517: add MMC support

Javier Martinez Canillas (4):
      ARM: OMAP3: igep0020: simplify GPIO LEDs dependencies
      ARM: OMAP2+: omap2plus_defconfig: enable TFP410 chip support
      ARM: OMAP2+: omap2plus_defconfig: enable CMA allocator
      ARM: imx: configs: enable netfilter support

Kim Milo (2):
      ARM: OMAP2+: craneboard: support NAND device
      ARM: OMAP2+: craneboard: support the TPS65910 PMU

Kuninori Morimoto (3):
      ARM: shmobile: fix sample amixer settings for mackerel
      ARM: shmobile: add sample amixer settings for ap4evb
      ARM: shmobile: add sample amixer settings for armadillo800eva

Kyungmin Park (1):
      ARM: OMAP2+: Remove apollon board support

Laurent Pinchart (10):
      ARM: shmobile: kzm9g: Use of_machine_is_compatible()
      ARM: shmobile: Include sh73a0 DTSI in kzm9g
      ARM: shmobile: ag5evm: Use gpio_request_one()
      ARM: shmobile: ap4evb: Use gpio_request_one()
      ARM: shmobile: armadillo800eva: Use gpio_request_one()
      ARM: shmobile: armadillo800eva: Use gpio_set_value() to set GPIO value
      ARM: shmobile: kota2: Use gpio_request_one()
      ARM: shmobile: bonito: Use gpio_request_one()
      ARM: shmobile: kzm9g: Use gpio_request_one()
      ARM: shmobile: mackerel: Use gpio_request_one()

Laxman Dewangan (1):
      ARM: tegra: defconfig updates

Mark Jackson (1):
      ARM: OMAP2+: omap2plus_defconfig: enable omap1 rtc

Mike Dunn (2):
      ARM: palmtreo: add docg4 device initialization
      ARM: palmtreo: replace #if defined with IF_ENABLED

Nobuhiro Iwamatsu (1):
      ARM: shmobile: Include DTSI of r8a7740 to armadillo800eva

Olof Johansson (12):
      Merge branch 'defconfig' of git://git.kernel.org/.../horms/renesas into next/boards
      Merge branch 'armsoc/board' of git://github.com/hzhuang1/linux into next/boards
      Merge branch 'defconfig2' of git://git.kernel.org/.../horms/renesas into next/boards
      Merge branch 'boards' of git://git.kernel.org/.../horms/renesas into next/boards
      Merge tag 'davinci-for-v3.9/board' of git://gitorious.org/linux-davinci/linux-davinci into next/boards
      Merge tag 'bcm2835-for-3.9-defconfig' of git://git.kernel.org/.../swarren/linux-rpi into next/boards
      Merge tag 'renesas-boards2-for-v3.9' of git://git.kernel.org/.../horms/renesas into next/boards
      Merge tag 'tegra-for-3.9-defconfig' of git://git.kernel.org/.../swarren/linux-tegra into next/boards
      Merge tag 'omap-for-v3.9/board-signed' of git://git.kernel.org/.../tmlind/linux-omap into next/boards
      Merge tag 'omap-for-v3.9/twl-signed-v2' of git://git.kernel.org/.../tmlind/linux-omap into next/boards
      Merge tag 'v3.8-rc7' into next/boards
      Merge tag 'arm-imx-defconfig' of git://git.pengutronix.de/git/imx/linux-2.6 into next/boards

Pali Rohár (2):
      RX-51: Add leds lp5523 names from Maemo 5 2.6.28 kernel
      RX-51: Register twl4030-madc device

Peter Ujfalusi (9):
      ARM: OMAP: 3430sdp: Enable extmute functionality for audio
      ARM: OMAP: zoom: Zoom2 does not have extmute functionality
      ARM: OMAP2+: twl-common: Add default twl4030 audio configuration
      ARM: OMAP2+: twl-common: Allow boards to customize the twl4030 audio setup
      ARM: OMAP: zoom: Audio support via the common omap-twl4030 machine driver
      ARM: OMAP: sdp3430: Audio support via the common omap-twl4030 machine driver
      ARM: OMAP: board-4430sdp: Proper support for TWL6030 PWM LED/Backlight
      ARM: OMAP: omap3beagle: Use the pwm_leds driver to control the PMU_STAT led
      ARM: board-zoom: Do not request LCD panel enable GPIO from twl4030

Robert Tivy (1):
      ARM: davinci: da850 board: change pr_warning() to pr_warn()

Sekhar Nori (2):
      ARM: davinci: defconfig: enable devtmpfs and devtmpfs automount
      ARM: davinci: defconfig: enable pm_runtime

Simon Horman (7):
      ARM: mach-shmobile: mackerel: update defconfig
      ARM: mach-shmobile: fix memory size for kota2_defconfig
      ARM: mach-shmobile: kzm9g: defconfig update
      ARM: mach-shmobile: armadillo: update defconfig
      ARM: mach-shmobile: kzm9d: update defconfig
      ARM: mach-shmobile: armadillo: defconfig: Enable CEU
      ARM: mach-shmobile: mackerel:  enable VFP in defconfig

Stephen Warren (1):
      ARM: bcm2835: defconfig updates

Tony Lindgren (2):
      Merge branch 'peter/for-tony' of git://gitorious.org/omap-audio/linux-audio into omap-for-v3.9/twl
      ARM: OMAP2+: Fix twl section warnings related to omap_twl4030_audio_init

 arch/arm/arm-soc-for-next-contents.txt           |  10 +
 arch/arm/boot/dts/emev2-kzm9d.dts                |   2 +-
 arch/arm/boot/dts/r8a7740-armadillo800eva.dts    |   6 +-
 arch/arm/boot/dts/sh7372-mackerel.dts            |   6 +-
 arch/arm/boot/dts/sh73a0-kzm9g.dts               |   6 +-
 arch/arm/configs/armadillo800eva_defconfig       |  10 +-
 arch/arm/configs/bcm2835_defconfig               |  43 ++-
 arch/arm/configs/da8xx_omapl_defconfig           |   3 +
 arch/arm/configs/davinci_all_defconfig           |   3 +
 arch/arm/configs/imx_v4_v5_defconfig             |   3 +
 arch/arm/configs/imx_v6_v7_defconfig             |   1 +
 arch/arm/configs/kota2_defconfig                 |   2 +-
 arch/arm/configs/kzm9d_defconfig                 |   4 +-
 arch/arm/configs/kzm9g_defconfig                 |   4 +-
 arch/arm/configs/mackerel_defconfig              |   3 +-
 arch/arm/configs/omap2plus_defconfig             |  25 ++
 arch/arm/configs/tegra_defconfig                 |   6 +
 arch/arm/mach-davinci/board-da850-evm.c          | 102 +++----
 arch/arm/mach-davinci/board-omapl138-hawk.c      |  30 +-
 arch/arm/mach-omap1/board-nokia770.c             |  43 +++
 arch/arm/mach-omap2/Kconfig                      |   6 -
 arch/arm/mach-omap2/Makefile                     |   1 -
 arch/arm/mach-omap2/board-3430sdp.c              |  20 ++
 arch/arm/mach-omap2/board-4430sdp.c              |  30 +-
 arch/arm/mach-omap2/board-am3517crane.c          |  59 ++++
 arch/arm/mach-omap2/board-apollon.c              | 342 -----------------------
 arch/arm/mach-omap2/board-cm-t35.c               |   2 +-
 arch/arm/mach-omap2/board-cm-t3517.c             |  27 ++
 arch/arm/mach-omap2/board-devkit8000.c           |   2 +-
 arch/arm/mach-omap2/board-igep0020.c             |  18 +-
 arch/arm/mach-omap2/board-omap3beagle.c          |  41 ++-
 arch/arm/mach-omap2/board-omap3evm.c             |   2 +-
 arch/arm/mach-omap2/board-overo.c                |   2 +-
 arch/arm/mach-omap2/board-rx51-peripherals.c     |  20 ++
 arch/arm/mach-omap2/board-zoom-peripherals.c     |  39 +--
 arch/arm/mach-omap2/gpmc.c                       |   3 -
 arch/arm/mach-omap2/twl-common.c                 |  17 +-
 arch/arm/mach-omap2/twl-common.h                 |   3 +-
 arch/arm/mach-pxa/palmtreo.c                     |  35 ++-
 arch/arm/mach-pxa/pxa27x.c                       |   1 +
 arch/arm/mach-shmobile/board-ag5evm.c            |  22 +-
 arch/arm/mach-shmobile/board-ap4evb.c            |  37 +--
 arch/arm/mach-shmobile/board-armadillo800eva.c   |  65 ++---
 arch/arm/mach-shmobile/board-bonito.c            |   7 +-
 arch/arm/mach-shmobile/board-kota2.c             |   9 +-
 arch/arm/mach-shmobile/board-kzm9g.c             |  20 +-
 arch/arm/mach-shmobile/board-mackerel.c          |  20 +-
 drivers/video/omap2/displays/panel-generic-dpi.c |  24 --
 48 files changed, 546 insertions(+), 640 deletions(-)
