Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752726AbaHDTud (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 15:50:33 -0400
Received: from andre.telenet-ops.be ([195.130.132.53]:54387 "EHLO
	andre.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751713AbaHDTub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 15:50:31 -0400
Date: Mon, 4 Aug 2014 21:50:18 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux/m68k <linux-m68k@vger.kernel.org>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [git pull] m68k updates for 3.17
Message-ID: <alpine.DEB.2.02.1408042146210.19306@ayla.of.borg>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Hi Linus,

The following extremely non-spectacular changes since commit
5bc8c7cdeb6e3d9c1b938b4029d9a22f8dc5cd9d:

  m68k: Export mach_random_get_entropy to modules (2014-07-11 10:37:53 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/geert/linux-m68k.git for-linus

for you to fetch changes up to 9117710a5997eb078035052800a31b77d47e0e5a:

  m68k/sun3: Remove define statement no longer needed (2014-07-26 17:48:34 +0200)

Thanks for pulling!

----------------------------------------------------------------
Himangi Saraogi (1):
      zorro: Use ARRAY_SIZE

Nicholas Krause (1):
      m68k/sun3: Remove define statement no longer needed

 arch/m68k/include/asm/sun3_pgalloc.h | 4 ----
 drivers/zorro/names.c                | 4 ++--
 2 files changed, 2 insertions(+), 6 deletions(-)

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
