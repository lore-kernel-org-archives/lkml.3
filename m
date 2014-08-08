Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757194AbaHHQsN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 12:48:13 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:57741 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757160AbaHHQrw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 12:47:52 -0400
From: Olof Johansson <olof@lixom.net>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, arm@kernel.org,
        linux-arm-kernel@lists.infradead.org, Olof Johansson <olof@lixom.net>
Subject: [GIT PULL 7/7] ARM: SoC defconfig updates for 3.17
Date: Fri,  8 Aug 2014 09:47:59 -0700
Message-Id: <1407516479-1251-8-git-send-email-olof@lixom.net>
X-Mailer: git-send-email 2.0.1.473.gc4d58ca
In-Reply-To: <1407516479-1251-1-git-send-email-olof@lixom.net>
References: <1407516479-1251-1-git-send-email-olof@lixom.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We broke this out in a separate branch since some defconfigs now are
shared between maintainers, and having them merged in through separate
topics (drivers/soc/etc) is a recipe for conflicts.

Most of this is removal of two defconfigs:

* Kirkwood, now folded into mvebu/multi_v5
* Renesas genmai, removed platform
* Major defconfig refresh for exynos
* Various updates on the other multi-defconfigs and others (tegra,
  socfpga, shmobile).


Conflicts: None

----------------------------------------------------------------

The following changes since commit 2696879b31fb6bbf9689996a7fe10f7a60b5ac54:

  Merge branch 'next/drivers' into HEAD

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/defconfig-for-3.17

for you to fetch changes up to dc1c5a84c7c97318f0f9cfb66198ef2f5db3dcb3:

  ARM: multi_v7_defconfig: Enable TI PIPE3 PHY driver

----------------------------------------------------------------

Andrew Lunn (3):
      ARM: mvebu: Add LaCie 2Big and 5Big Network v2
      ARM: multi_v5: Enable LaCie 2Big and 5Big Network v2
      ARM: Kirkwood: Remove kirkwood_defconfig

Gabriel FERNANDEZ (1):
      ARM: multi_v7_defconfig: add ST Keyscan driver

Gaku Inami (1):
      ARM: shmobile: Enable CPUFREQ configuration

Geert Uytterhoeven (1):
      ARM: shmobile: armadillo800eva defconfig: Enable REGULATOR_GPIO and LEDS_GPIO

Gregory CLEMENT (1):
      ARM: mvebu: defconfig: enable cpuidle support in mvebu_v7_defconfig

Haojian Zhuang (1):
      ARM: config: enable ARCH_HIX5HD2

Laurent Pinchart (1):
      ARM: shmobile: defconfig: Remove MACH_GENMAI

Lee Jones (4):
      ARM: multi_v7_defconfig: Enable ST's I2C driver
      ARM: multi_v7_defconfig: Configure in ST's Thermal Controller
      ARM: multi_v7_defconfig: Enable ST's (S)ATA driver
      ARM: multi_v7_defconfig: Enable MiPHY365x - ST's Generic (SATA & PCIe) PHY

Marcel Ziswiler (2):
      ARM: tegra: enable igb, stmpe, i2c chardev, lm95245, pwm leds
      ARM: multi_v7: enable igb, stmpe, lm95245, pwm leds

Marcin Wojtas (1):
      ARM: mvebu: enable Armada 375 network driver in mvebu_v7_defconfig

Olof Johansson (8):
      Merge tag 'renesas-defconfig-for-v3.17' of git://git.kernel.org/.../horms/renesas into next/defconfig
      Merge tag 'mvebu-defconfig-3.17' of git://git.infradead.org/linux-mvebu into next/defconfig
      Merge tag 'renesas-defconfig2-for-v3.17' of git://git.kernel.org/.../horms/renesas into next/defconfig
      Merge tag 'renesas-defconfig3-for-v3.17' of git://git.kernel.org/.../horms/renesas into next/defconfig
      Merge tag 'renesas-defconfig4-for-v3.17' of git://git.kernel.org/.../horms/renesas into next/defconfig
      Merge tag 'tegra-for-3.17-defconfig' of git://git.kernel.org/.../tegra/linux into next/defconfig
      Merge tag 'mvebu-defconfig-3.17-2' of git://git.infradead.org/linux-mvebu into next/defconfig
      Merge tag 'sti-defconfig-for-v3.17-1' of git://git.stlinux.com/devel/kernel/linux-sti into next/defconfig

Peter Griffin (1):
      ARM: update multi_v7_defconfig for STI

Roger Quadros (1):
      ARM: multi_v7_defconfig: Enable TI PIPE3 PHY driver

Sachin Kamat (1):
      ARM: exynos_defconfig: Update exynos_defconfig

Simon Horman (5):
      ARM: shmobile: marzen: Add to shmobile defconfig
      ARM: shmobile: Enable PM_RUNTIME in defconfig
      ARM: shmobile: Enable genmai board in multiplatform defconfig
      ARM: shmobile: Enable R-Car Gen 2 PCIe in shmobile_defconfig
      ARM: shmobile: genmai: remove defconfig

Stephen Warren (1):
      ARM: tegra: rebuild tegra_defconfig

Thomas Petazzoni (3):
      ARM: mvebu: add appended DTB support in mvebu_v5_defconfig
      ARM: mvebu: add devtmpfs to mvebu_v5_defconfig
      ARM: mvebu: update mvebu_v7_defconfig with cpufreq support

Vince Bridgers (1):
      ARM: socfpga: Update socfpga_defconfig


 arch/arm/configs/armadillo800eva_defconfig |   4 +
 arch/arm/configs/exynos_defconfig          |  56 ++++++--
 arch/arm/configs/genmai_defconfig          | 122 ----------------
 arch/arm/configs/hi3xxx_defconfig          |   2 +
 arch/arm/configs/kirkwood_defconfig        | 181 ------------------------
 arch/arm/configs/multi_v5_defconfig        |   2 +
 arch/arm/configs/multi_v7_defconfig        |  20 ++-
 arch/arm/configs/mvebu_v5_defconfig        |   6 +
 arch/arm/configs/mvebu_v7_defconfig        |   5 +
 arch/arm/configs/shmobile_defconfig        |  23 ++-
 arch/arm/configs/socfpga_defconfig         |  35 +++++
 arch/arm/configs/tegra_defconfig           |  16 +--
 12 files changed, 151 insertions(+), 321 deletions(-)
 delete mode 100644 arch/arm/configs/genmai_defconfig
 delete mode 100644 arch/arm/configs/kirkwood_defconfig
