Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753133AbaCaNJu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 09:09:50 -0400
Received: from albert.telenet-ops.be ([195.130.137.90]:46718 "EHLO
	albert.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752382AbaCaNJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 09:09:48 -0400
Date: Mon, 31 Mar 2014 15:09:45 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux/m68k <linux-m68k@vger.kernel.org>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [git pull] m68k updates for 3.15
Message-ID: <alpine.DEB.2.02.1403311440160.11624@ayla.of.borg>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Hi Linus,

The following changes since commit cfbf8d4857c26a8a307fb7cd258074c9dcd8c691:

  Linux 3.14-rc4 (2014-02-23 17:40:03 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/geert/linux-m68k.git for-linus

for you to fetch changes up to 50be9eba831da114e1979726f4119d342698e651:

  m68k: Update defconfigs for v3.14-rc1 (2014-03-31 15:07:24 +0200)

Thanks for pulling!

----------------------------------------------------------------
Arnd Bergmann (1):
      [SCSI] atari_scsi: Fix sleep_on race

Finn Thain (2):
      m68k: Remove CONSOLE_PENGUIN macro, adopt CONFIG_LOGO
      m68k: Remove dead code

Geert Uytterhoeven (2):
      m68k: head.S - Remove bogus L prefix in comment
      m68k: Update defconfigs for v3.14-rc1

 arch/m68k/configs/amiga_defconfig    |   10 +++--
 arch/m68k/configs/apollo_defconfig   |   10 +++--
 arch/m68k/configs/atari_defconfig    |   10 +++--
 arch/m68k/configs/bvme6000_defconfig |   10 +++--
 arch/m68k/configs/hp300_defconfig    |   10 +++--
 arch/m68k/configs/mac_defconfig      |   10 +++--
 arch/m68k/configs/multi_defconfig    |   10 +++--
 arch/m68k/configs/mvme147_defconfig  |   10 +++--
 arch/m68k/configs/mvme16x_defconfig  |   10 +++--
 arch/m68k/configs/q40_defconfig      |   10 +++--
 arch/m68k/configs/sun3_defconfig     |   10 +++--
 arch/m68k/configs/sun3x_defconfig    |   10 +++--
 arch/m68k/kernel/head.S              |   70 ++++------------------------------
 drivers/scsi/atari_scsi.c            |   12 ++++--
 14 files changed, 88 insertions(+), 114 deletions(-)

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
