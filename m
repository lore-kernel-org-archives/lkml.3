Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753796Ab3HVHEW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 03:04:22 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:34304 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753637Ab3HVHEV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 03:04:21 -0400
Date: Thu, 22 Aug 2013 00:03:40 -0700
From: Olof Johansson <olof@lixom.net>
To: torvalds@linux-foundation.org
Cc: olof@lixom.net, arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] ARM: SoC fixes for 3.11-rc
Message-ID: <20130822070340.GA8608@quad.lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The following changes since commit 1154f858ab5cd3c5facde7cb9ac31c889eb780a8:

  MAINTAINERS: add TI Keystone ARM platform (2013-08-07 10:30:29 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/fixes-for-linus

for you to fetch changes up to 30ca2226bea6f0db519dc53381b893cd66cb5b66:

  ARM: tegra: always enable USB VBUS regulators (2013-08-21 21:36:19 -0700)

----------------------------------------------------------------
ARM: SoC fixes for 3.11-rc

A handful of fixes for 3.11 are still trickling in. These are:
- A couple of fixes for older OMAP platforms
- Another few fixes for at91 (lateish due to European summer vacations)
- A late-found problem with USB on Tegra, fix is to keep VBUS regulator
  on at all times
- One fix for Exynos 5440 dealing with CPU detection
- One MAINTAINERS update

----------------------------------------------------------------
Aaro Koskinen (1):
      ARM: OMAP: rx51: change musb mode to OTG

Benoit Cousson (1):
      MAINTAINERS: Update email address for Benoit Cousson

Boris BREZILLON (1):
      ARM: at91: add missing uart clocks DT entries

Daniel Mack (1):
      ARM: OMAP2: fix musb usage for n8x0

Kukjin Kim (1):
      ARM: SAMSUNG: fix to support for missing cpu specific map_io

Nicolas Ferre (2):
      ARM: at91/DT: at91sam9x5ek: fix USB host property to enable port C
      ARM: at91/DT: fix at91sam9n12ek memory node

Olof Johansson (2):
      Merge tag 'samsung-fixes-2' of git://git.kernel.org/.../kgene/linux-samsung into fixes
      Merge tag 'at91-fixes' of git://github.com/at91linux/linux-at91 into fixes

Sekhar Nori (1):
      ARM: davinci: nand: specify ecc strength

Stephen Warren (1):
      ARM: tegra: always enable USB VBUS regulators

 MAINTAINERS                                 | 6 +++---
 arch/arm/boot/dts/at91sam9n12ek.dts         | 4 ++--
 arch/arm/boot/dts/at91sam9x5ek.dtsi         | 5 +++--
 arch/arm/boot/dts/tegra20-seaboard.dts      | 2 ++
 arch/arm/boot/dts/tegra20-trimslice.dts     | 2 ++
 arch/arm/boot/dts/tegra20-whistler.dts      | 4 ++++
 arch/arm/mach-at91/at91sam9x5.c             | 2 ++
 arch/arm/mach-davinci/board-dm355-leopard.c | 1 +
 arch/arm/mach-davinci/board-dm644x-evm.c    | 1 +
 arch/arm/mach-davinci/board-dm646x-evm.c    | 1 +
 arch/arm/mach-davinci/board-neuros-osd2.c   | 1 +
 arch/arm/mach-omap2/board-n8x0.c            | 4 ----
 arch/arm/mach-omap2/board-rx51.c            | 2 +-
 arch/arm/mach-omap2/usb-musb.c              | 5 +----
 arch/arm/plat-samsung/init.c                | 5 +++--
 15 files changed, 27 insertions(+), 18 deletions(-)
