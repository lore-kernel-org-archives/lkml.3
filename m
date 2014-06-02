Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752690AbaFBViH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 17:38:07 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:53730 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752617AbaFBViC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 17:38:02 -0400
From: Olof Johansson <olof@lixom.net>
To: torvalds@linux-foundation.org
Cc: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Olof Johansson <olof@lixom.net>
Subject: [GIT PULL 1/7] ARM: SoC low-priority fixes for 3.16
Date: Mon,  2 Jun 2014 14:04:04 -0700
Message-Id: <1401743050-7379-2-git-send-email-olof@lixom.net>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1401743050-7379-1-git-send-email-olof@lixom.net>
References: <1401743050-7379-1-git-send-email-olof@lixom.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A small selection of fixes coming in late during the release cycle and
not being critical enough for 3.15 inclusion.

----------------------------------------------------------------

The following changes since commit 425553209b387fa2125df09d01a2d1c1724bd205:

  Merge tag 'pci-v3.16-changes' of git://git.kernel.org/pub/scm/linux/kernel/git/helgaas/pci into next

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/fixes-for-3.16

for you to fetch changes up to da98f44f27d81d7fe9a41f69af4fe08c18d13b56:

  Merge tag 'renesas-fixes-for-v3.16' of git://git.kernel.org/pub/scm/linux/kernel/git/horms/renesas into next/fixes-non-critical

----------------------------------------------------------------

Afzal Mohammed (1):
      ARM: dts: AM4372: add l3-noc information

Hans de Goede (1):
      reset: Add of_reset_control_get to reset.h

Joel Fernandes (1):
      ARM: OMAP5: Redo THUMB mode switch on secondary CPU

Johan Hovold (1):
      ARM: dts: am335x-boneblack: remove use of ti,vcc-aux-disable-is-sleep

Kuninori Morimoto (1):
      ARM: shmobile: armadillo800eva: fixup HDMI sound flags setting

Olof Johansson (3):
      Merge branch 'reset/fixes' of git://git.pengutronix.de/git/pza/linux into next/fixes-non-critical
      Merge tag 'omap-for-v3.16/fixes-not-urgent-signed' of git://git.kernel.org/.../tmlind/linux-omap into next/fixes-non-critical
      Merge tag 'renesas-fixes-for-v3.16' of git://git.kernel.org/.../horms/renesas into next/fixes-non-critical

Oussama Ghorbel (1):
      ARM: OMAP2+: free use_gptimer_clksrc variable after boot

Pekon Gupta (1):
      ARM: dts: am43xx: fix starting offset of NAND.filesystem MTD partition

Rajendra Nayak (1):
      ARM: dts: DRA7: Use dra7-l3-noc instead of omap4-l3-noc

Stephen Boyd (1):
      ARM: msm: Silence readb/writeb warnings due to missing IOMEM()

Tony Lindgren (1):
      Merge branch 'pull/l3noc/dts-fixes' of https://github.com/nmenon/linux-2.6-playground into omap-for-v3.16/fixes-not-urgent


 arch/arm/boot/dts/am335x-boneblack.dts         |  1 -
 arch/arm/boot/dts/am4372.dtsi                  |  6 +++++-
 arch/arm/boot/dts/am43x-epos-evm.dts           |  2 +-
 arch/arm/boot/dts/dra7.dtsi                    |  6 +++---
 arch/arm/mach-msm/board-trout-gpio.c           |  2 +-
 arch/arm/mach-msm/board-trout.c                |  2 +-
 arch/arm/mach-msm/board-trout.h                |  2 +-
 arch/arm/mach-omap2/omap-headsmp.S             |  6 +-----
 arch/arm/mach-omap2/timer.c                    |  2 +-
 arch/arm/mach-shmobile/board-armadillo800eva.c |  2 +-
 include/linux/reset.h                          | 10 ++++++++++
 11 files changed, 25 insertions(+), 16 deletions(-)
