Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934371Ab3BSVby (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 16:31:54 -0500
Received: from georges.telenet-ops.be ([195.130.137.68]:48849 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934343Ab3BSVbx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 16:31:53 -0500
Date: Tue, 19 Feb 2013 22:31:50 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>, Greg Ungerer <gerg@uclinux.org>,
        Linux/m68k <linux-m68k@vger.kernel.org>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [git pull] m68k updates for 3.9
Message-ID: <alpine.DEB.2.00.1302192229230.12529@ayla.of.borg>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Hi Linus,

The following changes since commit 19f949f52599ba7c3f67a5897ac6be14bfcb1200:
  Linus Torvalds (1):
        Linux 3.8

are available in the git repository at:

  ra.kernel.org:/pub/scm/linux/kernel/git/geert/linux-m68k.git for-linus
  git://git.kernel.org/pub/scm/linux/kernel/git/geert/linux-m68k.git for-linus

Geert Uytterhoeven (1):
      m68k: Sort out !CONFIG_MMU_SUN3 vs. CONFIG_HAS_DMA

Jean Delvare (1):
      swim: Add missing spinlock init

 arch/m68k/include/asm/dma-mapping.h |    5 -----
 arch/m68k/kernel/Makefile           |    4 +---
 drivers/block/swim.c                |    1 +
 3 files changed, 2 insertions(+), 8 deletions(-)

Thanks for pulling!

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
