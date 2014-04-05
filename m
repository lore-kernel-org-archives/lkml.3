Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753406AbaDEBBv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 21:01:51 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:59993 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752682AbaDEBBt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 21:01:49 -0400
Date: Fri, 4 Apr 2014 20:01:45 -0500
From: rkuo <rkuo@codeaurora.org>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-hexagon@vger.kernel.org
Subject: [GIT PULL] arch/hexagon changes for 3.15
Message-ID: <20140405010145.GA28225@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Linus,

Please pull the following changes for Hexagon.  They contain mostly cleanups
for compilation with allmodconfig and some other miscellaneous fixes.


Thanks,
Richard Kuo


The following changes since commit 455c6fdbd219161bd09b1165f11699d6d73de11c:

  Linux 3.14 (2014-03-30 20:40:15 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rkuo/linux-hexagon-kernel.git for-linus

for you to fetch changes up to a9a44fdf329668125042055c569656aa83d8cccb:

  Hexagon: update CR year for elf.h (2014-04-04 18:20:02 -0500)

----------------------------------------------------------------
Chen Gang (12):
      hexagon: kernel: remove useless variables 'dn', 'r' and 'err' in time_init_deferred() in "time.c"
      hexagon: kernel: kgdb: include related header for pass compiling.
      hexagon: include: asm: kgdb: extend DBG_MAX_REG_NUM for "cs0/1"
      arch: hexagon: kernel: add export symbol function __delay()
      arch: hexagon: Kconfig: add HAVE_DMA_ATTR in Kconfig and remove "linux/dma-mapping.h" from "asm/dma-mapping.h"
      arch: hexagon: include: asm: add prefix "hvm[ci]_" for all enum members in "hexagon_vm.h"
      arch: hexagon: include: uapi: asm: setup.h add swith macro __KERNEL__
      arch: hexagon: include: asm: Kbuild: add generic "serial.h" in Kbuild
      arch: hexagon: include: asm: add "vga.h" in Kbuild
      arch: hexagon: kernel: reset.c: use function pointer instead of function for pm_power_off and export it
      arch: hexagon: kernel: hexagon_ksyms.c: export related symbols which various modules need
      arch: hexagon: include: asm: add generic macro 'mmiowb' in "io.h"

Ilia Mirkin (1):
      hexagon: correct type on pgd copy

Jiang Liu (1):
      smp, hexagon: kill SMP single function call interrupt

Richard Kuo (6):
      Hexagon: add screen_info for VGA_CONSOLE
      Hexagon: fix atomic_set
      Hexagon: set the e_flags in user regset view for core dumps
      Hexagon:  set ELF_EXEC_PAGESIZE to PAGE_SIZE
      Hexagon: remove SP macro
      Hexagon: update CR year for elf.h

 arch/hexagon/Kconfig                      |    1 +
 arch/hexagon/include/asm/Kbuild           |    4 +-
 arch/hexagon/include/asm/atomic.h         |   15 +++++-
 arch/hexagon/include/asm/delay.h          |    1 +
 arch/hexagon/include/asm/dma-mapping.h    |    1 -
 arch/hexagon/include/asm/elf.h            |    4 +-
 arch/hexagon/include/asm/hexagon_vm.h     |   72 ++++++++++++++---------------
 arch/hexagon/include/asm/io.h             |    2 +
 arch/hexagon/include/asm/kgdb.h           |    5 +-
 arch/hexagon/include/asm/pgalloc.h        |    2 +-
 arch/hexagon/include/asm/smp.h            |    1 -
 arch/hexagon/include/uapi/asm/registers.h |    4 +-
 arch/hexagon/include/uapi/asm/setup.h     |    5 ++
 arch/hexagon/kernel/Makefile              |    2 +
 arch/hexagon/kernel/hexagon_ksyms.c       |   24 ++++++++--
 arch/hexagon/kernel/kgdb.c                |    2 +
 arch/hexagon/kernel/ptrace.c              |    1 +
 arch/hexagon/kernel/reset.c               |    5 +-
 arch/hexagon/kernel/screen_info.c         |    3 ++
 arch/hexagon/kernel/smp.c                 |    6 +--
 arch/hexagon/kernel/time.c                |   12 +++--
 21 files changed, 109 insertions(+), 63 deletions(-)
 create mode 100644 arch/hexagon/kernel/screen_info.c

-- 

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
