Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967389AbaFTMhr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 08:37:47 -0400
Received: from baptiste.telenet-ops.be ([195.130.132.51]:33382 "EHLO
	baptiste.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967156AbaFTMhp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 08:37:45 -0400
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>,
        Vinod Koul <vinod.koul@intel.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>, linux-sh@vger.kernel.org,
        dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH 0/4] dmaengine: shdma: Register documentation
Date: Fri, 20 Jun 2014 14:37:37 +0200
Message-Id: <1403267861-15609-1-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series adds more register documentation for shdma, and replaces
some hardcoded numbers by defines.

  [1/4] dmaengine: shdma: Add more register documentation
  [2/4] ARM: shmobile: dma: Use defines instead of hardcoded numbers
  [3/4] sh: dma: Use defines instead of hardcoded numbers
  [4/4] dmaengine: shdma: Use defines instead of hardcoded numbers

 arch/arm/mach-shmobile/dma-register.h  |  4 +--
 arch/sh/drivers/dma/dma-sh.c           |  2 +-
 arch/sh/include/asm/dma-register.h     | 36 ++++++++++---------
 arch/sh/kernel/cpu/sh4a/setup-sh7722.c | 24 ++++++-------
 arch/sh/kernel/cpu/sh4a/setup-sh7724.c | 48 ++++++++++++-------------
 arch/sh/kernel/cpu/sh4a/setup-sh7757.c | 64 +++++++++++++++++-----------------
 drivers/dma/sh/shdma-arm.h             |  4 +--
 drivers/dma/sh/shdmac.c                | 15 ++++----
 include/linux/sh_dma.h                 | 24 +++++++------
 9 files changed, 112 insertions(+), 109 deletions(-)

Thanks!

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
