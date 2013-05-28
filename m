Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933799Ab3E1Jag (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 05:30:36 -0400
Received: from juliette.telenet-ops.be ([195.130.137.74]:46806 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933724Ab3E1Jae (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 05:30:34 -0400
Date: Tue, 28 May 2013 11:30:19 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>, Greg Ungerer <gerg@uclinux.org>,
        Linux/m68k <linux-m68k@vger.kernel.org>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [git pull] m68k updates for 3.10, take 2
Message-ID: <alpine.DEB.2.00.1305281127350.32281@ayla.of.borg>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Hi Linus,

The following changes since commit c7788792a5e7b0d5d7f96d0766b4cb6112d47d75:
  Linus Torvalds (1):
        Linux 3.10-rc2

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/geert/linux-m68k.git for-linus

Geert Uytterhoeven (1):
      m68k: Update defconfigs for v3.9

Mikael Pettersson (1):
      m68k: implement futex.h to support userspace robust futexes and PI mutexes

Summarized:
  - futex support that I had missed before,
  - A long-overdue update of the m68k defconfigs.

Thanks for pulling!

 arch/m68k/configs/amiga_defconfig    |  230 ++++++++++++++++++++++--------
 arch/m68k/configs/apollo_defconfig   |  215 ++++++++++++++++++++-------
 arch/m68k/configs/atari_defconfig    |  227 ++++++++++++++++++++++--------
 arch/m68k/configs/bvme6000_defconfig |  217 ++++++++++++++++++++--------
 arch/m68k/configs/hp300_defconfig    |  214 ++++++++++++++++++++-------
 arch/m68k/configs/mac_defconfig      |  234 ++++++++++++++++++++++--------
 arch/m68k/configs/multi_defconfig    |  264 ++++++++++++++++++++++++----------
 arch/m68k/configs/mvme147_defconfig  |  215 ++++++++++++++++++++-------
 arch/m68k/configs/mvme16x_defconfig  |  216 ++++++++++++++++++++--------
 arch/m68k/configs/q40_defconfig      |  229 ++++++++++++++++++++++--------
 arch/m68k/configs/sun3_defconfig     |  209 ++++++++++++++++++++-------
 arch/m68k/configs/sun3x_defconfig    |  210 ++++++++++++++++++++-------
 arch/m68k/include/asm/Kbuild         |    1 -
 arch/m68k/include/asm/futex.h        |   94 ++++++++++++
 14 files changed, 2076 insertions(+), 699 deletions(-)
 create mode 100644 arch/m68k/include/asm/futex.h

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
