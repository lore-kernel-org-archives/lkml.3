Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932347Ab3IBVoe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 17:44:34 -0400
Received: from gerard.telenet-ops.be ([195.130.132.48]:39736 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758976Ab3IBVod (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 17:44:33 -0400
Date: Mon, 2 Sep 2013 23:44:24 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux/m68k <linux-m68k@vger.kernel.org>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [git pull] m68k updates for 3.12
Message-ID: <alpine.DEB.2.02.1309022339040.10575@ayla.of.borg>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Hi Linus,

The following changes since commit b36f4be3de1b123d8601de062e7dbfc904f305fb:

  Linux 3.11-rc6 (2013-08-18 14:36:53 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/geert/linux-m68k.git for-linus

for you to fetch changes up to 55490050df0f5d82ce070be11351c65f7696101c:

  m68k/atari: ARAnyM - Always use physical addresses in NatFeat calls (2013-08-23 12:49:01 +0200)

----------------------------------------------------------------
Geert Uytterhoeven (2):
      m68k: Ignore disabled HSYNC interrupt on Atari for irqs_disabled()
      m68k/atari: ARAnyM - Always use physical addresses in NatFeat calls

Summary:
  - Kill harmless warning messages when running a multi-platform kernel on
    Atari,
  - Correct virt/phys mixups that didn't actually hurt due to identity
    mappings.

Thanks for pulling!

 arch/m68k/emu/natfeat.c          |   14 +++++++-------
 arch/m68k/emu/nfblock.c          |    4 ++--
 arch/m68k/emu/nfcon.c            |    8 +++++---
 arch/m68k/emu/nfeth.c            |    7 ++++---
 arch/m68k/include/asm/irqflags.h |    4 ++++
 5 files changed, 22 insertions(+), 15 deletions(-)

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
