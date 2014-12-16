Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751489AbaLPVNm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 16:13:42 -0500
Received: from mout.kundenserver.de ([212.227.126.187]:58738 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750976AbaLPVNl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 16:13:41 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL 1/3] ARM: SoC fixes for 3.19-rc1
Date: Tue, 16 Dec 2014 22:13:10 +0100
Message-ID: <5499732.TPqbyGxy2W@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:Y86db2hNJHGmB5HNgVwpAqT5yuD1hSyVPlUsNNiAmirtf1wzlLp
 34YWjDJmGi0jucdDgmLliLncpS0PxIzjJ2a4f4OPUSAxpbctN9ZKg9zvZ3QVQy+6PDfMk5Z
 pdqDrxvo+bKWm6J0tnmZocS5UMGkrcApf7NPfNJn2UWI6CGW2C73fggpYnw20h23ke8dGYH
 5q/8l5t2rLmUOsKHutc6g==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit a0e4467726cd26bacb16f13d207ffcfa82ffc07d:

  Merge tag 'asm-generic-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/arnd/asm-generic (2014-12-09 17:25:00 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/fixes-for-linus

for you to fetch changes up to 5f1b2953da58e51e97eea9b7235545d72e9e1dab:

  Merge tag 'renesas-defconfig-fixes-for-v3.19' of git://git.kernel.org/pub/scm/linux/kernel/git/horms/renesas into fixes (2014-12-16 21:43:15 +0100)

----------------------------------------------------------------
ARM: SoC fixes for 3.19-rc1

Here are the first arm-soc bug fixes. Most of these are OMAP related
fixes for regressions or minor bugs. Aside from that, there are a
few defconfig changes for various platforms.

----------------------------------------------------------------
Arnd Bergmann (1):
      Merge tag 'renesas-defconfig-fixes-for-v3.19' of git://git.kernel.org/.../horms/renesas into fixes

Felipe Balbi (1):
      ARM: dts: am437x-sk: fix lcd enable pin mux data

Johan Hovold (1):
      ARM: OMAP2+: clock: remove unused function prototype

Kevin Hilman (1):
      Merge tag 'omap-for-v3.19/fixes-for-merge-window' of git://git.kernel.org/.../tmlind/linux-omap into fixes

Lokesh Vutla (2):
      ARM: dts: DRA7: wdt: Fix compatible property for watchdog node
      ARM: OMAP2+: AM43x: Add ID for ES1.2

Mark Brown (1):
      iommu/exynos: Fix arm64 allmodconfig build

Ravikumar Kattekola (2):
      ARM: dts: dra7-evm: Fix typo in SMPS6 (VDD_GPU) max voltage
      ARM: dts: dra7-evm: Update SMPS7 (VDD_CORE) max voltage to match DM

Roger Quadros (1):
      ARM: omap2plus_defconfig: Enable AHCI_PLATFORM driver

Simon Horman (1):
      Revert "ARM: shmobile: multiplatform: add Audo DMAC peri peri support on defconfig"

Tomi Valkeinen (2):
      ARM: dts: dra7: fix DSS PLL clock mux registers
      ARM: dts: am437x-sk-evm.dts: fix LCD timings

Tony Lindgren (2):
      Merge branch 'omap-for-v3.19/fixes-not-urgent' into omap-for-v3.19/fixes
      ARM: dts: Fix gpmc regression for omap 2430sdp smc91x

Viresh Kumar (1):
      ARM: defconfigs: use CONFIG_CPUFREQ_DT

 arch/arm/boot/dts/am437x-sk-evm.dts  | 15 +++++++--------
 arch/arm/boot/dts/dra7-evm.dts       |  4 ++--
 arch/arm/boot/dts/dra7.dtsi          |  2 +-
 arch/arm/boot/dts/dra72-evm.dts      |  2 +-
 arch/arm/boot/dts/dra7xx-clocks.dtsi |  6 +++---
 arch/arm/boot/dts/omap2430-sdp.dts   | 32 ++++++++++++++++----------------
 arch/arm/configs/multi_v7_defconfig  |  2 +-
 arch/arm/configs/omap2plus_defconfig |  2 ++
 arch/arm/configs/shmobile_defconfig  |  3 +--
 arch/arm/mach-omap2/clock.h          |  2 --
 arch/arm/mach-omap2/id.c             |  8 ++++++--
 arch/arm/mach-omap2/soc.h            |  1 +
 drivers/iommu/Kconfig                |  2 +-
 13 files changed, 42 insertions(+), 39 deletions(-)

