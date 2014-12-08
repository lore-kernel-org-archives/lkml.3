Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754929AbaLHJwe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 04:52:34 -0500
Received: from baptiste.telenet-ops.be ([195.130.132.51]:40011 "EHLO
	baptiste.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754047AbaLHJwc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 04:52:32 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Greg Ungerer <gerg@uclinux.org>,
        linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [git pull] m68k updates for 3.19
Date: Mon,  8 Dec 2014 10:52:17 +0100
Message-Id: <1418032337-15218-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Hi Linus,

The following changes since commit cac7f2429872d3733dc3f9915857b1691da2eb2f:

  Linux 3.18-rc2 (2014-10-26 16:48:41 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/geert/linux-m68k.git for-linus

for you to fetch changes up to f0b99a643e9613beb28af43333bbfa90d4bf85cc:

  m68k/mm: Eliminate memset after alloc_bootmem_pages (2014-11-10 09:56:44 +0100)

----------------------------------------------------------------
Geert Uytterhoeven (1):
      nubus: Remove superfluous interrupt disable/restore

Himangi Saraogi (1):
      m68k/mm: Eliminate memset after alloc_bootmem_pages

 arch/m68k/mm/init.c   | 1 -
 drivers/nubus/nubus.c | 4 ----
 2 files changed, 5 deletions(-)

Thanks for pulling!

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
