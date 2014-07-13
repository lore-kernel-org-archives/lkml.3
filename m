Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752831AbaGMJIS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2014 05:08:18 -0400
Received: from andre.telenet-ops.be ([195.130.132.53]:59969 "EHLO
	andre.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752229AbaGMJIK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2014 05:08:10 -0400
Date: Sun, 13 Jul 2014 11:08:07 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux/m68k <linux-m68k@vger.kernel.org>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [git pull] m68k updates for 3.16 (take 2)
Message-ID: <alpine.DEB.2.02.1407131105390.7520@ayla.of.borg>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Hi Linus,

The following changes since commit cd3de83f147601356395b57a8673e9c5ff1e59d1:

  Linux 3.16-rc4 (2014-07-06 12:37:51 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/geert/linux-m68k.git for-linus

for you to fetch changes up to 5bc8c7cdeb6e3d9c1b938b4029d9a22f8dc5cd9d:

  m68k: Export mach_random_get_entropy to modules (2014-07-11 10:37:53 +0200)

Summary:
  - Fix for a boot regression introduced in v3.16-rc1,
  - Fix for a built issue in -next.

Thanks for pulling!

----------------------------------------------------------------
Geert Uytterhoeven (2):
      m68k: Fix boot regression on machines with RAM at non-zero
      m68k: Export mach_random_get_entropy to modules

 arch/m68k/kernel/head.S | 3 ++-
 arch/m68k/kernel/time.c | 2 ++
 2 files changed, 4 insertions(+), 1 deletion(-)

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
