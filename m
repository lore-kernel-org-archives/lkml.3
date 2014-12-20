Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752846AbaLTAaD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 19:30:03 -0500
Received: from bastet.se.axis.com ([195.60.68.11]:57111 "EHLO
	bastet.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752668AbaLTAaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 19:30:00 -0500
Date: Sat, 20 Dec 2014 01:29:53 +0100
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-cris-kernel <linux-cris-kernel@axis.com>
Subject: [GIT PULL] CRIS changes for 3.19
Message-ID: <20141220002953.GR26817@axis.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the below branch for CRIS changes for 3.19,
mostly cleanup and build fixes for CRISv32 allmodconfig.

God Jul och Gott Nytt år!

The following changes since commit e589c9e13aeb0c5539bf1314b3a78442ea8fc0c2:

  Merge branch 'x86-apic-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip (2014-12-19 14:02:02 -0800)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/jesper/cris.git tags/cris-changes-for-3.19

for you to fetch changes up to 8bcabff0589c1ef8fec9f98d525943217ae10971:

  CRISv32: Remove last remnants of ETRAX_SPI_MMC_BOARD (2014-12-20 00:06:13 +0100)

----------------------------------------------------------------
CRIS port changes for 3.19

----------------------------------------------------------------
Jesper Nilsson (13):
      CRISv32: Drop obsolete file for SPI driver
      CRISv32: Add missing include for mm.h
      CRIS: Export ioremap_nocache
      CRIS: Export missing function symbols
      CRISv32: Better handling of watchdog bite
      CRIS: Update init memory handling
      CRISv32: Rewrite of synchronous serial port driver
      CRISv32: Fix declaration mismatch
      CRIS: Use KALLSYMs if available in call stack dump
      CRISv32: Implement early console
      CRISv32: Select MTDRAM for axisflashmap
      CRISv32: ETRAXFS: Fix recursive spinlock
      CRISv32: Remove last remnants of ETRAX_SPI_MMC_BOARD

Sam Ravnborg (1):
      CRIS: Fix headers_install

 arch/cris/arch-v10/lib/usercopy.c                |   14 +-
 arch/cris/arch-v32/drivers/Kconfig               |    8 +-
 arch/cris/arch-v32/drivers/Makefile              |    1 -
 arch/cris/arch-v32/drivers/i2c.h                 |    1 -
 arch/cris/arch-v32/drivers/sync_serial.c         | 1430 ++++++++++++----------
 arch/cris/arch-v32/kernel/debugport.c            |   82 +-
 arch/cris/arch-v32/kernel/time.c                 |   29 +-
 arch/cris/arch-v32/lib/usercopy.c                |   15 +-
 arch/cris/arch-v32/mach-fs/pinmux.c              |  152 +--
 arch/cris/include/arch-v32/mach-fs/mach/pinmux.h |    2 -
 arch/cris/include/asm/Kbuild                     |    4 -
 arch/cris/include/uapi/asm/Kbuild                |    4 +-
 arch/cris/kernel/crisksyms.c                     |    9 +-
 arch/cris/kernel/traps.c                         |   61 +-
 arch/cris/mm/init.c                              |   38 +-
 arch/cris/mm/ioremap.c                           |    3 +-
 scripts/headers.sh                               |    2 -
 17 files changed, 1039 insertions(+), 816 deletions(-)

/^JN - Jesper Nilsson
-- 
               Jesper Nilsson -- jesper.nilsson@axis.com
