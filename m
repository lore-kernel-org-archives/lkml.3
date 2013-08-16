Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757419Ab3HPWlv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 18:41:51 -0400
Received: from winston.telenet-ops.be ([195.130.137.75]:43180 "EHLO
	winston.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754991Ab3HPWlr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 18:41:47 -0400
X-Greylist: delayed 1054 seconds by postgrey-1.27 at vger.kernel.org; Fri, 16 Aug 2013 18:41:46 EDT
Date: Fri, 16 Aug 2013 23:55:38 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux/m68k <linux-m68k@vger.kernel.org>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [git pull] m68k updates for 3.11-rc6
Message-ID: <alpine.DEB.2.02.1308162324580.23373@ayla.of.borg>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Hi Linus,

The following changes since commit d4e4ab86bcba5a72779c43dc1459f71fea3d89c8:

  Linux 3.11-rc5 (2013-08-11 18:04:20 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/geert/linux-m68k.git for-3.11

for you to fetch changes up to ea077b1b96e073eac5c3c5590529e964767fc5f7:

  m68k: Truncate base in do_div() (2013-08-14 11:46:30 +0200)

----------------------------------------------------------------
Andreas Schwab (1):
      m68k: Truncate base in do_div()

Geert Uytterhoeven (1):
      m68k/atari: ARAnyM - Fix NatFeat module support

Summary:

These are two critical fixes, needed by distro kernels, and thus also
destined for stable:
  - The do_div() commit fixes a crash in mounting btrfs volumes, which was
    a regression from 3.2,
  - The ARAnyM fix allows to have NatFeat drivers as loadable modules,
    which is needed for initrds.

Thanks for pulling!

 arch/m68k/emu/natfeat.c       |   23 +++++++++++++++++++----
 arch/m68k/include/asm/div64.h |    9 +++++----
 2 files changed, 24 insertions(+), 8 deletions(-)

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
