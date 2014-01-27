Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753362AbaA0LD1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 06:03:27 -0500
Received: from ra.se.axis.com ([195.60.68.10]:34109 "EHLO ra.se.axis.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751098AbaA0LD0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 06:03:26 -0500
Date: Mon, 27 Jan 2014 12:03:23 +0100
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-cris-kernel@axis.com
Subject: [GIT PULL] CRIS updates for 3.14
Message-ID: <20140127110322.GR17210@axis.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus!

Please pull for CRIS Linux 3.14 updates.
Mostly removal of deprecated or old code, but also
a long promised update of the CRIS syscalls.

Thanks!

The following changes since commit ceb3b0212dfc843a6abe8a6f3b4e28c1f2059e64:

  Merge branch 'drm-nouveau-next' of git://anongit.freedesktop.org/nouveau/linux-2.6 into drm-fixes (2014-01-08 17:57:45 +1000)

are available in the git repository at:


  git://jni.nu/cris tags/cris-for-3.14

for you to fetch changes up to e269a869417cd4053b37da1b19186902d3cbf63b:

  Drop code for CRISv10 CPU simulator (2014-01-15 14:44:02 +0100)

----------------------------------------------------------------
CRIS changes for 3.14

----------------------------------------------------------------
Arnd Bergmann (1):
      cris: sync_serial: remove interruptible_sleep_on

Jesper Nilsson (3):
      CRIS: Add missing syscalls
      Cleanup whitespace, remove old author tag
      Drop code for CRISv10 CPU simulator

Michael Opdenacker (1):
      cris: remove deprecated IRQF_DISABLED

 arch/cris/Kconfig                         |   6 -
 arch/cris/arch-v10/drivers/gpio.c         |   4 +-
 arch/cris/arch-v10/drivers/sync_serial.c  |   8 +-
 arch/cris/arch-v10/kernel/Makefile        |   1 -
 arch/cris/arch-v10/kernel/debugport.c     |   7 --
 arch/cris/arch-v10/kernel/entry.S         | 184 ++++++++++++++++--------------
 arch/cris/arch-v10/kernel/head.S          | 127 ++++++++++-----------
 arch/cris/arch-v10/kernel/irq.c           |  18 +--
 arch/cris/arch-v10/kernel/process.c       |   5 +-
 arch/cris/arch-v10/kernel/time.c          |  98 +++++++---------
 arch/cris/arch-v10/lib/dram_init.S        |  40 +++----
 arch/cris/arch-v32/drivers/mach-a3/gpio.c |   2 +-
 arch/cris/arch-v32/drivers/mach-fs/gpio.c |   4 +-
 arch/cris/arch-v32/drivers/sync_serial.c  |   4 +-
 arch/cris/arch-v32/kernel/entry.S         |  34 ++++--
 arch/cris/arch-v32/kernel/fasttimer.c     |   2 +-
 arch/cris/arch-v32/kernel/irq.c           |  10 +-
 arch/cris/arch-v32/kernel/smp.c           |   2 +-
 arch/cris/arch-v32/kernel/time.c          |   6 +-
 arch/cris/arch-v32/mach-a3/arbiter.c      |   4 +-
 arch/cris/arch-v32/mach-fs/arbiter.c      |   2 +-
 arch/cris/boot/rescue/kimagerescue.S      |   2 -
 arch/cris/include/arch-v10/arch/io.h      |  29 +----
 arch/cris/include/arch-v10/arch/irq.h     |   6 +-
 arch/cris/include/arch-v32/arch/irq.h     |   6 +-
 arch/cris/include/asm/unistd.h            |   2 +-
 arch/cris/include/uapi/asm/unistd.h       |  16 +++
 arch/cris/kernel/irq.c                    |   3 -
 28 files changed, 299 insertions(+), 333 deletions(-)


/^JN - Jesper Nilsson
-- 
               Jesper Nilsson -- jesper.nilsson@axis.com
