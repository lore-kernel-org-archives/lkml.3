Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753872AbaFPGpi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 02:45:38 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:44660 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953AbaFPGpg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 02:45:36 -0400
Date: Sun, 15 Jun 2014 23:45:35 -0700 (PDT)
Message-Id: <20140615.234535.16811015744529799.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Sparc
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Sun, 15 Jun 2014 23:45:36 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Please pull to get these sparc sparse fixes from Sam Ravnborg.

Thanks a lot!

The following changes since commit 2aafe1a4d451866e3e7b476e2fa0813b69b313c1:

  Merge tag 'trace-fixes-v3.15-rc2' of git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace (2014-04-28 16:57:51 -0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/davem/sparc-next.git master

for you to fetch changes up to 311b8935ad4e13bac5880ae3f0c269b0c253d25f:

  Merge branch 'sparc_sparse_fixes' (2014-05-18 19:03:07 -0700)

----------------------------------------------------------------

David S. Miller (3):
      Merge branch 'sparc32-sparse'
      Merge branch 'sparc32_generic_io_h'
      Merge branch 'sparc_sparse_fixes'

Sam Ravnborg (67):
      sparc32: rename mm/srmmu.h to mm/mm_32.h
      sparc32: fix sparse warning in fault_32.c
      sparc32: fix sparse warning in init_32.c
      sparc32: fix sparse warnings in srmmu.c
      sparc32: fix sparse "Should it be static?" in mm/
      sparc32: fix sparse warning in traps_32.c
      sparc32: fix sparse warnings in sun4m_irq.c and sun4d_irq.c
      sparc32: fix sparse warnings in sun4d_irq.c
      sparc32: fix sparse warnings in irq_32.c
      sparc32: fix sparse warnings in process_32.h
      sparc32: fix sparse warnings in signal_32.c
      sparc32: fix sparse warnings in ioport.c
      sparc32: fix sparse warnings in setup_32.c
      sparc32: fix sparse warnings in windows.c
      sparc: fix sparse warnings in cpu.c
      sparc32: fix sparse warning in devices.c
      sparc32: fix sparse warnings in tadpole.c
      sparc32: fix sparse warnings in leon_pci_grpci1.c
      sparc32: fix sparse warnings in leon_pci_grpci2.c
      sparc32: fix sparse warnings in auxio_32.c
      sparc32: fix sparse warnings in smp_32.c
      sparc32: fix sparse warning in ptrace_32.c
      sparc32: fix sparse warnings in unaligned_32.c
      sparc: fix sparse warnings in of_device_common.c
      sparc32: fix sparse warnings in leon_kernel.c
      sparc32: fix sparse warnings in leon_pmc.c
      sparc32: fix sparse warnings in sun4m_smp.c
      sparc32: fix sparse warnings in sun4d_smp.c
      sparc32: fix sparse warnings in leon_smp.c
      sparc: move page_to_phys to page.h
      sparc32: replace flip_dword() with swab32()
      sparc32: introduce asm-generic/io.h
      sparc32: clean up io_32.h
      sparc32: fix build breakage
      sparc32: fix sparse warning in iommu.c
      sparc32: fix sparse warning in io-unit.c
      sparc32: fix sparse warnings in pcic.c
      sparc32: fix sparse warning in auxio_32.c
      sparc32: fix sparse warnings in time_32.c
      sparc32: fix sparse warnings in sys_sparc_32.c
      sparc32: remove cast from output constraints in math asm statements
      sparc64: remove cast from output constraints in math asm statements
      sparc: fix sparse warning in math_{32,64}
      sparc32: drop tadpole specific code
      sparc: drop use of extern for prototypes in arch/sparc/include/asm
      sparc: drop use of extern for prototypes in arch/sparc/*
      sparc64: fix sparse warning in traps_64.c
      sparc64: fix sparse warning in process_64.c
      sparc64: fix sparse warnings in sys_sparc_64.c + unaligned_64.c
      sparc64: fix sparse warning in btext.c
      sparc64: fix sparse warning in prom_64.c
      sparc64: fix sparse warnings in smp_64.c
      sparc64: fix sparse warning in pci.c
      sparc64: fix sparse warnings in sys_sparc32.c
      sparc64: fix sparse "Should it be static?" warnings in signal32.c
      sparc64: clean up compat_sigset_t.seta handling
      sparc64: fix sparse warning in tsb.c
      sparc64: fix sparse warnings in kprobes.c
      sparc64: fix sparse warnings in perf_event.c
      sparc: fix sparse warnings in smp_32.c + smp_64.c
      sparc64: fix sparse warnings in aes_glue.c
      sparc64: fix sparse warnings in init_64.c
      sparc64: fix sparse warnings in compat_audit.c
      sparc64: fix sparse warning in kgdb_64.c
      sparc64: fix sparse warning in kprobes.c
      sparc64: fix sparse warning in ftrace.c
      sparc64: fix sparse warnings in int_64.c

 arch/sparc/crypto/aes_glue.c            |   6 +-
 arch/sparc/include/asm/atomic_32.h      |   8 +--
 arch/sparc/include/asm/atomic_64.h      |  18 ++---
 arch/sparc/include/asm/auxio.h          |   7 ++
 arch/sparc/include/asm/auxio_32.h       |   6 +-
 arch/sparc/include/asm/auxio_64.h       |   6 +-
 arch/sparc/include/asm/bitext.h         |   6 +-
 arch/sparc/include/asm/bitops_32.h      |   6 +-
 arch/sparc/include/asm/bitops_64.h      |  24 +++----
 arch/sparc/include/asm/btext.h          |   2 +-
 arch/sparc/include/asm/bug.h            |   4 +-
 arch/sparc/include/asm/cacheflush_32.h  |   8 +--
 arch/sparc/include/asm/cacheflush_64.h  |  24 +++----
 arch/sparc/include/asm/checksum_32.h    |   4 +-
 arch/sparc/include/asm/checksum_64.h    |  32 ++++-----
 arch/sparc/include/asm/cmpxchg_32.h     |   6 +-
 arch/sparc/include/asm/cmpxchg_64.h     |   4 +-
 arch/sparc/include/asm/cpudata.h        |  10 +++
 arch/sparc/include/asm/cpudata_64.h     |   5 --
 arch/sparc/include/asm/delay_32.h       |   4 +-
 arch/sparc/include/asm/delay_64.h       |   4 +-
 arch/sparc/include/asm/device.h         |   2 +-
 arch/sparc/include/asm/dma-mapping.h    |   2 +-
 arch/sparc/include/asm/ebus_dma.h       |  16 ++---
 arch/sparc/include/asm/floppy_32.h      |  14 +---
 arch/sparc/include/asm/floppy_64.h      |   2 +-
 arch/sparc/include/asm/ftrace.h         |   6 +-
 arch/sparc/include/asm/highmem.h        |  10 +--
 arch/sparc/include/asm/hvtramp.h        |   2 +-
 arch/sparc/include/asm/hypervisor.h     | 325 +++++++++++++++++++++++++++++++++++++++++++-------------------------------------------
 arch/sparc/include/asm/idprom.h         |   2 +-
 arch/sparc/include/asm/io-unit.h        |   2 +-
 arch/sparc/include/asm/io_32.h          | 299 +++++++++++++++----------------------------------------------------------------
 arch/sparc/include/asm/io_64.h          |  21 +++---
 arch/sparc/include/asm/iommu_32.h       |  10 +--
 arch/sparc/include/asm/iommu_64.h       |   6 +-
 arch/sparc/include/asm/irq_32.h         |   3 +-
 arch/sparc/include/asm/irq_64.h         |  44 ++++++------
 arch/sparc/include/asm/irqflags_32.h    |   6 +-
 arch/sparc/include/asm/kdebug_64.h      |   2 +-
 arch/sparc/include/asm/kgdb.h           |   5 +-
 arch/sparc/include/asm/kprobes.h        |   8 ++-
 arch/sparc/include/asm/ldc.h            |  66 +++++++++---------
 arch/sparc/include/asm/leon.h           |  54 +++++++--------
 arch/sparc/include/asm/leon_pci.h       |   4 +-
 arch/sparc/include/asm/mc146818rtc.h    |   5 ++
 arch/sparc/include/asm/mdesc.h          |  32 ++++-----
 arch/sparc/include/asm/mmu_64.h         |   6 +-
 arch/sparc/include/asm/mmu_context_64.h |  24 ++++---
 arch/sparc/include/asm/nmi.h            |  10 +--
 arch/sparc/include/asm/oplib_32.h       |  68 +++++++++---------
 arch/sparc/include/asm/oplib_64.h       | 112 +++++++++++++++---------------
 arch/sparc/include/asm/page.h           |   3 +
 arch/sparc/include/asm/page_64.h        |   8 +--
 arch/sparc/include/asm/pci_64.h         |  14 ++--
 arch/sparc/include/asm/pcic.h           |   8 +--
 arch/sparc/include/asm/pcr.h            |   6 +-
 arch/sparc/include/asm/pgalloc_32.h     |   2 +
 arch/sparc/include/asm/pgalloc_64.h     |  16 ++---
 arch/sparc/include/asm/pgtable_32.h     |  11 +--
 arch/sparc/include/asm/pgtable_64.h     |  58 ++++++++--------
 arch/sparc/include/asm/processor_32.h   |   5 +-
 arch/sparc/include/asm/processor_64.h   |   6 +-
 arch/sparc/include/asm/prom.h           |  24 +++----
 arch/sparc/include/asm/ptrace.h         |   2 +-
 arch/sparc/include/asm/setup.h          |  39 ++++++++++-
 arch/sparc/include/asm/sfp-machine_32.h |  28 ++++----
 arch/sparc/include/asm/smp_32.h         |   6 +-
 arch/sparc/include/asm/smp_64.h         |  24 ++++---
 arch/sparc/include/asm/spitfire.h       |   2 +-
 arch/sparc/include/asm/stacktrace.h     |   2 +-
 arch/sparc/include/asm/starfire.h       |   8 +--
 arch/sparc/include/asm/string_32.h      |  12 ++--
 arch/sparc/include/asm/string_64.h      |  12 ++--
 arch/sparc/include/asm/switch_to_32.h   |   6 +-
 arch/sparc/include/asm/switch_to_64.h   |   4 +-
 arch/sparc/include/asm/syscalls.h       |   8 +--
 arch/sparc/include/asm/timer_32.h       |   6 +-
 arch/sparc/include/asm/timer_64.h       |   6 +-
 arch/sparc/include/asm/tlb_64.h         |   8 +--
 arch/sparc/include/asm/tlbflush_64.h    |  22 +++---
 arch/sparc/include/asm/topology_64.h    |   2 +-
 arch/sparc/include/asm/trap_block.h     |   6 +-
 arch/sparc/include/asm/uaccess.h        |   2 +-
 arch/sparc/include/asm/uaccess_32.h     |  14 ++--
 arch/sparc/include/asm/uaccess_64.h     |  50 +++++++-------
 arch/sparc/include/asm/vio.h            |  36 +++++-----
 arch/sparc/include/asm/visasm.h         |   3 +-
 arch/sparc/include/asm/xor_64.h         |  28 ++++----
 arch/sparc/kernel/Makefile              |   1 -
 arch/sparc/kernel/audit.c               |   8 +--
 arch/sparc/kernel/auxio_32.c            |   9 ++-
 arch/sparc/kernel/btext.c               |   2 +-
 arch/sparc/kernel/compat_audit.c        |   1 +
 arch/sparc/kernel/cpu.c                 |   1 +
 arch/sparc/kernel/cpumap.h              |   4 +-
 arch/sparc/kernel/devices.c             |  12 ++--
 arch/sparc/kernel/entry.h               | 259 ++++++++++++++++++++++++++++++++++----------------------------------
 arch/sparc/kernel/iommu.c               |   3 +-
 arch/sparc/kernel/iommu_common.h        |  14 ++--
 arch/sparc/kernel/ioport.c              |   6 +-
 arch/sparc/kernel/irq.h                 |  11 ++-
 arch/sparc/kernel/irq_32.c              |   1 +
 arch/sparc/kernel/kernel.h              | 124 ++++++++++++++++++++++++++++-----
 arch/sparc/kernel/kgdb_64.c             |   2 +
 arch/sparc/kernel/kprobes.c             |   5 +-
 arch/sparc/kernel/leon_kernel.c         |  10 +--
 arch/sparc/kernel/leon_pci.c            |  79 ---------------------
 arch/sparc/kernel/leon_pci_grpci1.c     |  16 ++---
 arch/sparc/kernel/leon_pci_grpci2.c     |  22 +++---
 arch/sparc/kernel/leon_pmc.c            |   8 +--
 arch/sparc/kernel/leon_smp.c            |  13 +---
 arch/sparc/kernel/of_device_common.c    |   4 +-
 arch/sparc/kernel/pci.c                 |   1 +
 arch/sparc/kernel/pci_impl.h            |  30 ++++----
 arch/sparc/kernel/pci_sun4v.h           | 156 ++++++++++++++++++++---------------------
 arch/sparc/kernel/pcic.c                | 116 ++-----------------------------
 arch/sparc/kernel/perf_event.c          |  23 ++++---
 arch/sparc/kernel/process_32.c          |  12 +++-
 arch/sparc/kernel/process_64.c          |   2 +-
 arch/sparc/kernel/prom.h                |   2 +-
 arch/sparc/kernel/prom_64.c             |   5 +-
 arch/sparc/kernel/psycho_common.h       |  22 +++---
 arch/sparc/kernel/ptrace_32.c           |   2 +
 arch/sparc/kernel/setup_32.c            |   4 +-
 arch/sparc/kernel/signal32.c            |  56 +++++----------
 arch/sparc/kernel/signal_32.c           |  11 +--
 arch/sparc/kernel/signal_64.c           |   6 +-
 arch/sparc/kernel/smp_32.c              |  13 ++--
 arch/sparc/kernel/smp_64.c              |  16 +----
 arch/sparc/kernel/sun4d_irq.c           |  17 ++---
 arch/sparc/kernel/sys_sparc32.c         |   2 +
 arch/sparc/kernel/sys_sparc_32.c        |  10 +--
 arch/sparc/kernel/sys_sparc_64.c        |   1 +
 arch/sparc/kernel/systbls.h             | 124 ++++++++++++++++++++++++---------
 arch/sparc/kernel/tadpole.c             | 126 ---------------------------------
 arch/sparc/kernel/time_32.c             |   8 ++-
 arch/sparc/kernel/traps_32.c            |   4 +-
 arch/sparc/kernel/traps_64.c            |  11 +--
 arch/sparc/kernel/unaligned_32.c        |   4 ++
 arch/sparc/kernel/unaligned_64.c        |   2 +
 arch/sparc/kernel/windows.c             |   3 +
 arch/sparc/lib/Makefile                 |   2 +-
 arch/sparc/math-emu/sfp-util_32.h       |  20 +++---
 arch/sparc/math-emu/sfp-util_64.h       |  12 ++--
 arch/sparc/mm/fault_32.c                |   9 +--
 arch/sparc/mm/fault_64.c                |   4 +-
 arch/sparc/mm/init_32.c                 |   7 +-
 arch/sparc/mm/init_64.c                 |   9 ++-
 arch/sparc/mm/init_64.h                 |   4 +-
 arch/sparc/mm/io-unit.c                 |  21 +++---
 arch/sparc/mm/iommu.c                   |  25 ++++---
 arch/sparc/mm/leon_mm.c                 |   4 +-
 arch/sparc/mm/mm_32.h                   |  24 +++++++
 arch/sparc/mm/srmmu.c                   |  13 ++--
 arch/sparc/mm/srmmu.h                   |   4 --
 arch/sparc/mm/tsb.c                     |   1 +
 arch/sparc/prom/misc_64.c               |   5 --
 include/linux/profile.h                 |   1 +
 kernel/sysctl.c                         |   4 --
 160 files changed, 1579 insertions(+), 1853 deletions(-)
 delete mode 100644 arch/sparc/kernel/tadpole.c
 create mode 100644 arch/sparc/mm/mm_32.h
 delete mode 100644 arch/sparc/mm/srmmu.h
