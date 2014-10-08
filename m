Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754485AbaJHHtZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 03:49:25 -0400
Received: from baptiste.telenet-ops.be ([195.130.132.51]:53321 "EHLO
	baptiste.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752084AbaJHHtW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 03:49:22 -0400
Date: Wed, 8 Oct 2014 09:49:19 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>, Greg Ungerer <gerg@uclinux.org>,
        Linux/m68k <linux-m68k@vger.kernel.org>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [git pull] m68k updates for 3.18
Message-ID: <alpine.DEB.2.02.1410080943190.27455@ayla.of.borg>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Hi Linus,

The following changes since commit 2ce7598c9a453e0acd0e07be7be3f5eb39608ebd:

  Linux 3.17-rc4 (2014-09-07 16:09:43 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/geert/linux-m68k.git for-linus

for you to fetch changes up to 24cae7934cf1455c9793a95376a206ca6b965ade:

  m68k: Reformat arch/m68k/mm/hwtest.c (2014-10-03 10:50:56 +0200)

Summary:
  - A fix for an intermittent crash in macsonic and hilkbd, marked for stable,
  - Build fixes for uncommon configs.

Note: "m68k: AMIGA_BUILTIN_SERIAL should depend on TTY" was also picked up by
      GregKH for "[GIT PULL] TTY/Serial patches for 3.18-rc1".

Thanks for pulling!

----------------------------------------------------------------
Geert Uytterhoeven (5):
      m68k/atari - stram: Add missing #include <linux/ioport.h>
      m68k: Add missing ioport_unmap()
      m68k: AMIGA_BUILTIN_SERIAL should depend on TTY
      m68k: Disable/restore interrupts in hwreg_present()/hwreg_write()
      m68k: Reformat arch/m68k/mm/hwtest.c

 arch/m68k/Kconfig.devices     |  2 +-
 arch/m68k/atari/stram.c       |  1 +
 arch/m68k/include/asm/io_mm.h |  9 ++++-
 arch/m68k/mm/hwtest.c         | 78 ++++++++++++++++++++++++-------------------
 4 files changed, 53 insertions(+), 37 deletions(-)

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
