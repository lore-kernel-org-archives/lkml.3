Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752191Ab3AWUA3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 15:00:29 -0500
Received: from jacques.telenet-ops.be ([195.130.132.50]:47510 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751513Ab3AWUAW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 15:00:22 -0500
Date: Wed, 23 Jan 2013 21:00:18 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>, Greg Ungerer <gerg@uclinux.org>,
        Linux/m68k <linux-m68k@vger.kernel.org>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [git pull] m68k updates for 3.8 (take 2)
Message-ID: <alpine.DEB.2.00.1301232058001.14225@ayla.of.borg>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Hi Linus,

The following changes since commit a49f0d1ea3ec94fc7cf33a7c36a16343b74bd565:
  Linus Torvalds (1):
        Linux 3.8-rc1

are available in the git repository at:

  ra.kernel.org:/pub/scm/linux/kernel/git/geert/linux-m68k.git for-linus
  git://git.kernel.org/pub/scm/linux/kernel/git/geert/linux-m68k.git for-linus

Geert Uytterhoeven (3):
      m68k: Provide dma_alloc_attrs()/dma_free_attrs()
      asm-generic/dma-mapping-broken.h: Provide dma_alloc_attrs()/dma_free_attrs()
      m68k: Wire up finit_module

The asm-generic changeset has been ack'ed by Arnd.

Thanks for pulling!

 arch/m68k/include/asm/dma-mapping.h      |   16 ++++++++++++++++
 arch/m68k/include/asm/unistd.h           |    2 +-
 arch/m68k/include/uapi/asm/unistd.h      |    1 +
 arch/m68k/kernel/syscalltable.S          |    1 +
 include/asm-generic/dma-mapping-broken.h |   16 ++++++++++++++++
 5 files changed, 35 insertions(+), 1 deletions(-)

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
