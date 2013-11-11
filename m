Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752622Ab3KKFda (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 00:33:30 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:44519 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751296Ab3KKFc5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 00:32:57 -0500
From: Olof Johansson <olof@lixom.net>
To: torvalds@linux-foundation.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arm@kernel.org, Olof Johansson <olof@lixom.net>
Subject: [GIT PULL 1/6] ARM: SoC low-priority fixes for 3.13
Date: Sun, 10 Nov 2013 21:29:31 -0800
Message-Id: <1384147776-18735-2-git-send-email-olof@lixom.net>
X-Mailer: git-send-email 1.8.4.1.601.g02b3b1d
In-Reply-To: <1384147776-18735-1-git-send-email-olof@lixom.net>
References: <1384147776-18735-1-git-send-email-olof@lixom.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A set of fixes for various platforms that weren't considered bad enough
to include in 3.12 (nor -stable). Mostly simple typo fixes, etc.


Conflicts: None.

----------------------------------------------------------------

The following changes since commit 8b5baa460b69c27389353eeff0dbe51dc695da60:

  Merge tag 'gfs2-merge-window' of git://git.kernel.org/pub/scm/linux/kernel/git/steve/gfs2-3.0-nmw

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/fixes-nc-for-linus

for you to fetch changes up to 462fb38f3d2ec3deb6e60c1725bc0b6e9d4b7fdb:

  Merge tag 'omap-for-v3.13/fixes-not-urgent-part2' of git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap into fixes-non-critical

----------------------------------------------------------------

Afzal Mohammed (1):
      ARM: OMAP2+: wakeupgen: AM43x adaptation

Al Stone (1):
      ARM: dts: Correct typo in use of samsung,pin-drv for exynos5250

Bartlomiej Zolnierkiewicz (2):
      ARM: OMAP1: fix incorrect placement of __initdata tag
      ARM: dts: fix PL330 MDMA1 address in DT for Universal C210 board

Heiko Stuebner (2):
      ARM: rockchip: fix wrong use of non-existent CONFIG_LOCAL_TIMERS
      ARM: rockchip: remove obsolete rockchip,config properties

Kevin Hilman (3):
      Merge tag 'omap-for-v3.13/fixes-not-urgent-signed' of git://git.kernel.org/.../tmlind/linux-omap into fixes-non-critical
      Merge tag 'v3.13-rockchip-fixes' of git://git.kernel.org/.../mmind/linux-rockchip into fixes-non-critical
      Merge tag 'samsung-fixes-v2' of git://git.kernel.org/.../kgene/linux-samsung into fixes-non-critical

Linus Walleij (1):
      ARM: OMAP2+: throw the die id into the entropy pool

Majunath Goudar (1):
      ARM: mach-omap1: Fix omap1510_fpga_init_irq() implicit declarations.

Markus Pargmann (1):
      ARM: OMAP2+: irq, AM33XX add missing register check

Michael Opdenacker (1):
      ARM: OMAP: remove deprecated IRQF_DISABLED

Olof Johansson (1):
      Merge tag 'omap-for-v3.13/fixes-not-urgent-part2' of git://git.kernel.org/.../tmlind/linux-omap into fixes-non-critical

Tomasz Figa (1):
      ARM: dts: Work around lack of cpufreq regulator lookup for exynos4210-origen and trats boards

Tony Lindgren (1):
      ARM: OMAP1: Fix a bunch of GPIO related section warnings after initdata got corrected

Youngmin Nam (1):
      ARM: dts: Fix typo earlyprintk in exynos5440-sd5v1 and ssdk5440 boards


 arch/arm/boot/dts/exynos4210-origen.dts         |  7 +++-
 arch/arm/boot/dts/exynos4210-trats.dts          |  7 +++-
 arch/arm/boot/dts/exynos4210-universal_c210.dts |  4 ++
 arch/arm/boot/dts/exynos5250-pinctrl.dtsi       | 44 ++++++++++----------
 arch/arm/boot/dts/exynos5440-sd5v1.dts          |  2 +-
 arch/arm/boot/dts/exynos5440-ssdk5440.dts       |  2 +-
 arch/arm/boot/dts/rk3066a.dtsi                  | 22 ----------
 arch/arm/mach-omap1/common.h                    |  3 ++
 arch/arm/mach-omap1/fpga.c                      |  3 +-
 arch/arm/mach-omap1/gpio15xx.c                  |  8 ++--
 arch/arm/mach-omap1/gpio16xx.c                  | 22 +++++-----
 arch/arm/mach-omap1/gpio7xx.c                   | 30 ++++++-------
 arch/arm/mach-omap1/pm.c                        |  1 -
 arch/arm/mach-omap1/time.c                      |  2 +-
 arch/arm/mach-omap1/timer32k.c                  |  2 +-
 arch/arm/mach-omap2/id.c                        | 12 ++++++
 arch/arm/mach-omap2/irq.c                       |  2 +-
 arch/arm/mach-omap2/omap-wakeupgen.c            | 18 +++++---
 arch/arm/mach-omap2/timer.c                     |  2 +-
 arch/arm/mach-rockchip/Kconfig                  |  3 +-
 arch/arm/plat-omap/dma.c                        |  1 -
 21 files changed, 104 insertions(+), 93 deletions(-)
