Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754320AbaIDQZR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 12:25:17 -0400
Received: from andre.telenet-ops.be ([195.130.132.53]:35320 "EHLO
	andre.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751674AbaIDQZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 12:25:15 -0400
Date: Thu, 4 Sep 2014 18:25:10 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>, Greg Ungerer <gerg@uclinux.org>,
        Linux/m68k <linux-m68k@vger.kernel.org>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [git pull] m68k updates for 3.17 (take 2)
Message-ID: <alpine.DEB.2.02.1409041822460.17564@ayla.of.borg>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

        Hi Linus,

The following changes since commit 69e273c0b0a3c337a521d083374c918dc52c666f:

  Linux 3.17-rc3 (2014-08-31 18:23:04 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/geert/linux-m68k.git for-linus

for you to fetch changes up to 4ed7800987b1b082f8fc98c5cb7eb20cf74280a8:

  m68k: Wire up memfd_create (2014-09-01 10:28:00 +0200)

Summary:
  - m68k: Wire up new syscalls getrandom and memfd_create

Thanks for pulling!

----------------------------------------------------------------
Geert Uytterhoeven (2):
      m68k: Wire up getrandom
      m68k: Wire up memfd_create

 arch/m68k/include/asm/unistd.h      | 2 +-
 arch/m68k/include/uapi/asm/unistd.h | 2 ++
 arch/m68k/kernel/syscalltable.S     | 2 ++
 3 files changed, 5 insertions(+), 1 deletion(-)

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
