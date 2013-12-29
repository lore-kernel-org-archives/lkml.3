Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751689Ab3L2PsC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Dec 2013 10:48:02 -0500
Received: from mail-pb0-f53.google.com ([209.85.160.53]:50336 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750887Ab3L2PsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Dec 2013 10:48:00 -0500
Date: Sun, 29 Dec 2013 07:45:54 -0800
From: Olof Johansson <olof@lixom.net>
To: torvalds@linux-foundation.org
Cc: olof@lixom.net, arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] ARM: SoC fixes for 3.13-rc
Message-ID: <20131229154554.GA14633@quad.lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The following changes since commit 413541dd66d51f791a0b169d9b9014e4f56be13c:

  Linux 3.13-rc5 (2013-12-22 13:08:32 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/fixes-for-linus

for you to fetch changes up to 9b17c16525552b247cb2d9bb8eeadc87950b36ff:

  Merge tag 'omap-for-v3.13/intc-ldp-fix' of git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap into fixes (2013-12-28 15:38:32 -0800)

----------------------------------------------------------------

ARM: SoC fixes for 3.13-rc

Another smallish batch of fixes, it's been quiet due to the holidays. Nothing
controversial here, a handful of things across the board.

----------------------------------------------------------------
Ben Dooks (1):
      ARM: shmobile: r8a7790: fix shdi resource sizes

Kuninori Morimoto (1):
      ARM: shmobile: bockw: fixup DMA mask

Laurent Pinchart (1):
      ARM: shmobile: armadillo: Add PWM backlight power supply

Linus Walleij (1):
      ARM: pxa: fix USB gadget driver compilation regression

Olof Johansson (2):
      Merge tag 'renesas-fixes2-for-v3.13' of git://git.kernel.org/.../horms/renesas into fixes
      Merge tag 'omap-for-v3.13/intc-ldp-fix' of git://git.kernel.org/.../tmlind/linux-omap into fixes

Rajendra Nayak (1):
      ARM: DRA7: hwmod: Fix boot crash with DEBUG_LL

Suman Anna (1):
      ARM: OMAP2+: hwmod_data: fix missing OMAP_INTC_START in irq data

Tony Lindgren (2):
      ARM: OMAP2+: Fix LCD panel backlight regression for LDP legacy booting
      Merge tag 'for-v3.13-rc/hwmod-fixes-b' of git://git.kernel.org/.../pjw/omap-pending into debug-ll-and-ldp-backlight-fix

 arch/arm/boot/dts/r8a7790.dtsi                     | 4 ++--
 arch/arm/mach-omap2/board-ldp.c                    | 7 ++++++-
 arch/arm/mach-omap2/omap_hwmod_2xxx_ipblock_data.c | 4 ++--
 arch/arm/mach-omap2/omap_hwmod_3xxx_data.c         | 6 +++---
 arch/arm/mach-omap2/omap_hwmod_7xx_data.c          | 2 +-
 arch/arm/mach-pxa/include/mach/lubbock.h           | 2 ++
 arch/arm/mach-shmobile/board-armadillo800eva.c     | 7 +++++++
 arch/arm/mach-shmobile/board-bockw.c               | 2 +-
 8 files changed, 24 insertions(+), 10 deletions(-)
