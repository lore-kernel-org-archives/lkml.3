Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753392Ab3GAKQV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 06:16:21 -0400
Received: from gerard.telenet-ops.be ([195.130.132.48]:50880 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752983Ab3GAKQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 06:16:19 -0400
Date: Mon, 1 Jul 2013 12:16:16 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>, Greg Ungerer <gerg@uclinux.org>,
        Linux/m68k <linux-m68k@vger.kernel.org>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [git pull] m68k updates for 3.11
Message-ID: <alpine.DEB.2.02.1307011212400.22695@ayla.of.borg>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Hi Linus,

The following changes since commit 9e895ace5d82df8929b16f58e9f515f6d54ab82d:

  Linux 3.10-rc7 (2013-06-22 09:47:31 -1000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/geert/linux-m68k.git for-3.11

for you to fetch changes up to 980f3a7315b4691ec90538352a9e9c5a53ea9d34:

  m68k/q40: Enable PC parallel port in defconfig (2013-06-24 19:44:30 +0200)

----------------------------------------------------------------
Chen Gang (1):
      m68k/math-emu: unsigned issue, 'unsigned long' will never be less than zero

Denis Efremov (1):
      m68k/sun3: remove inline marking of EXPORT_SYMBOL functions

Finn Thain (1):
      m68k: remove CONFIG_EARLY_PRINTK dependency on CONFIG_EMBEDDED, default to n

Geert Uytterhoeven (4):
      m68k: Remove inline strcpy() and strcat() implementations
      m68k/uaccess: Fix asm constraints for userspace access
      m68k/q40: Undefine insl/outsl before redefining them
      m68k/q40: Enable PC parallel port in defconfig

Jingoo Han (2):
      [SCSI] a4000t: use module_platform_driver_probe()
      [SCSI] a3000: use module_platform_driver_probe()

Joe Perches (1):
      swim: Release memory region after incorrect return/goto

Thomas Bogendoerfer (1):
      m68k/irq: Vector ints need a valid interrupt handler

Thanks for pulling!

 arch/m68k/Kconfig.debug            |    3 +--
 arch/m68k/configs/multi_defconfig  |    2 ++
 arch/m68k/configs/q40_defconfig    |    6 ++++++
 arch/m68k/include/asm/parport.h    |    2 ++
 arch/m68k/include/asm/string.h     |   32 --------------------------------
 arch/m68k/include/asm/uaccess_mm.h |    8 ++++----
 arch/m68k/kernel/ints.c            |    2 +-
 arch/m68k/lib/Makefile             |    2 +-
 arch/m68k/lib/string.c             |   22 ----------------------
 arch/m68k/lib/uaccess.c            |    6 +++---
 arch/m68k/math-emu/fp_arith.c      |    2 +-
 arch/m68k/sun3/sun3dvma.c          |    2 +-
 drivers/block/swim.c               |    2 +-
 drivers/scsi/a3000.c               |   13 +------------
 drivers/scsi/a4000t.c              |   15 +--------------
 15 files changed, 25 insertions(+), 94 deletions(-)
 delete mode 100644 arch/m68k/lib/string.c

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
