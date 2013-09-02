Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755310Ab3IBENx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 00:13:53 -0400
Received: from mail-vc0-f172.google.com ([209.85.220.172]:47240 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752254Ab3IBENv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 00:13:51 -0400
MIME-Version: 1.0
In-Reply-To: <1377914435-24206-1-git-send-email-linux@roeck-us.net>
References: <1377914435-24206-1-git-send-email-linux@roeck-us.net>
Date: Mon, 2 Sep 2013 12:13:49 +0800
Message-ID: <CAF0htA6gW3h82p2sBBpFEi4s0MkQ-NUn79VXWLieZmYNuUPA6w@mail.gmail.com>
Subject: Re: [PATCH] Remove support for score architecture
From: Lennox Wu <lennox.wu@gmail.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiang Liu <jiang.liu@huawei.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>, Arnd Bergmann <arnd@arndb.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Liqin Chen <liqin299@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear all,

Indeed, Sunplus S+core is not a popular architecture and there is no
standalone to be sold so you should not find related news on the
Internet.  However, the s+core is adopted by our SoCs and these SoCs
are indeed adopted by some companies, we hope the architecture can be
reserved to provide the more and more powerful Linux for our
customers. It is true that we rarely update the code because that we
are rarely requested to add new functions and to correct bugs by our
customers, and it is also because we have no new product to release.
In the near future, we will release some patches for the existed
S+core architecture.

2013/8/31 Guenter Roeck <linux@roeck-us.net>:
> The web site associated with the score architecture in MAINTAINERS
> is non-functional and available for sale. The last Ack from one
> of the maintainers was in December 2012. The main maintainer's last
> commit was in 2011. The last maintainer pull request was early 2011.
>
> Cc: Lennox Wu <lennox.wu@gmail.com>
> Cc: Chen Liqin <liqin.chen@sunplusct.com>
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> ---
> More housekeeping.
>
> Maybe this removal request is a bit early, but architecture support seems
> to have vanished entirely. At the very least this puts interested parties
> (if there are any) on notice.
>
>  MAINTAINERS                                |    7 -
>  arch/score/Kconfig                         |  113 -------
>  arch/score/Kconfig.debug                   |   28 --
>  arch/score/Makefile                        |   44 ---
>  arch/score/boot/Makefile                   |   15 -
>  arch/score/configs/spct6600_defconfig      |   85 -----
>  arch/score/include/asm/Kbuild              |    6 -
>  arch/score/include/asm/asm-offsets.h       |    1 -
>  arch/score/include/asm/asmmacro.h          |  161 ---------
>  arch/score/include/asm/atomic.h            |    7 -
>  arch/score/include/asm/barrier.h           |   16 -
>  arch/score/include/asm/bitops.h            |   15 -
>  arch/score/include/asm/bug.h               |   17 -
>  arch/score/include/asm/bugs.h              |    6 -
>  arch/score/include/asm/cache.h             |    7 -
>  arch/score/include/asm/cacheflush.h        |   48 ---
>  arch/score/include/asm/checksum.h          |  235 -------------
>  arch/score/include/asm/cmpxchg.h           |   49 ---
>  arch/score/include/asm/cputime.h           |    6 -
>  arch/score/include/asm/current.h           |    6 -
>  arch/score/include/asm/delay.h             |   28 --
>  arch/score/include/asm/device.h            |    6 -
>  arch/score/include/asm/div64.h             |    6 -
>  arch/score/include/asm/dma.h               |    8 -
>  arch/score/include/asm/elf.h               |   97 ------
>  arch/score/include/asm/emergency-restart.h |    6 -
>  arch/score/include/asm/exec.h              |    6 -
>  arch/score/include/asm/fixmap.h            |   82 -----
>  arch/score/include/asm/ftrace.h            |    4 -
>  arch/score/include/asm/futex.h             |    6 -
>  arch/score/include/asm/hardirq.h           |    6 -
>  arch/score/include/asm/hw_irq.h            |    4 -
>  arch/score/include/asm/io.h                |    9 -
>  arch/score/include/asm/irq.h               |   25 --
>  arch/score/include/asm/irq_regs.h          |   11 -
>  arch/score/include/asm/irqflags.h          |  120 -------
>  arch/score/include/asm/kdebug.h            |    6 -
>  arch/score/include/asm/kmap_types.h        |    6 -
>  arch/score/include/asm/linkage.h           |    7 -
>  arch/score/include/asm/local.h             |    6 -
>  arch/score/include/asm/local64.h           |    1 -
>  arch/score/include/asm/mmu.h               |    6 -
>  arch/score/include/asm/mmu_context.h       |  113 -------
>  arch/score/include/asm/module.h            |   35 --
>  arch/score/include/asm/mutex.h             |    6 -
>  arch/score/include/asm/page.h              |   93 ------
>  arch/score/include/asm/pci.h               |    4 -
>  arch/score/include/asm/percpu.h            |    6 -
>  arch/score/include/asm/pgalloc.h           |   83 -----
>  arch/score/include/asm/pgtable-bits.h      |   25 --
>  arch/score/include/asm/pgtable.h           |  282 ----------------
>  arch/score/include/asm/processor.h         |  104 ------
>  arch/score/include/asm/ptrace.h            |   25 --
>  arch/score/include/asm/scatterlist.h       |    6 -
>  arch/score/include/asm/scoreregs.h         |   51 ---
>  arch/score/include/asm/sections.h          |    6 -
>  arch/score/include/asm/segment.h           |   21 --
>  arch/score/include/asm/setup.h             |   36 --
>  arch/score/include/asm/shmparam.h          |    6 -
>  arch/score/include/asm/string.h            |    8 -
>  arch/score/include/asm/switch_to.h         |   13 -
>  arch/score/include/asm/syscalls.h          |    8 -
>  arch/score/include/asm/thread_info.h       |  100 ------
>  arch/score/include/asm/timex.h             |    8 -
>  arch/score/include/asm/tlb.h               |   17 -
>  arch/score/include/asm/tlbflush.h          |  142 --------
>  arch/score/include/asm/topology.h          |    6 -
>  arch/score/include/asm/uaccess.h           |  424 ------------------------
>  arch/score/include/asm/ucontext.h          |    1 -
>  arch/score/include/asm/unaligned.h         |    6 -
>  arch/score/include/asm/user.h              |   21 --
>  arch/score/include/uapi/asm/Kbuild         |   34 --
>  arch/score/include/uapi/asm/auxvec.h       |    4 -
>  arch/score/include/uapi/asm/bitsperlong.h  |    6 -
>  arch/score/include/uapi/asm/byteorder.h    |    6 -
>  arch/score/include/uapi/asm/errno.h        |    6 -
>  arch/score/include/uapi/asm/fcntl.h        |    6 -
>  arch/score/include/uapi/asm/ioctl.h        |    6 -
>  arch/score/include/uapi/asm/ioctls.h       |    6 -
>  arch/score/include/uapi/asm/ipcbuf.h       |    6 -
>  arch/score/include/uapi/asm/kvm_para.h     |    1 -
>  arch/score/include/uapi/asm/mman.h         |    6 -
>  arch/score/include/uapi/asm/msgbuf.h       |    6 -
>  arch/score/include/uapi/asm/param.h        |    6 -
>  arch/score/include/uapi/asm/poll.h         |    6 -
>  arch/score/include/uapi/asm/posix_types.h  |    6 -
>  arch/score/include/uapi/asm/ptrace.h       |   76 -----
>  arch/score/include/uapi/asm/resource.h     |    6 -
>  arch/score/include/uapi/asm/sembuf.h       |    6 -
>  arch/score/include/uapi/asm/setup.h        |    9 -
>  arch/score/include/uapi/asm/shmbuf.h       |    6 -
>  arch/score/include/uapi/asm/sigcontext.h   |   22 --
>  arch/score/include/uapi/asm/siginfo.h      |    6 -
>  arch/score/include/uapi/asm/signal.h       |    6 -
>  arch/score/include/uapi/asm/socket.h       |    6 -
>  arch/score/include/uapi/asm/sockios.h      |    6 -
>  arch/score/include/uapi/asm/stat.h         |    6 -
>  arch/score/include/uapi/asm/statfs.h       |    6 -
>  arch/score/include/uapi/asm/swab.h         |    6 -
>  arch/score/include/uapi/asm/termbits.h     |    6 -
>  arch/score/include/uapi/asm/termios.h      |    6 -
>  arch/score/include/uapi/asm/types.h        |    6 -
>  arch/score/include/uapi/asm/unistd.h       |   11 -
>  arch/score/kernel/Makefile                 |   11 -
>  arch/score/kernel/asm-offsets.c            |  216 ------------
>  arch/score/kernel/entry.S                  |  493 ----------------------------
>  arch/score/kernel/head.S                   |   70 ----
>  arch/score/kernel/irq.c                    |  111 -------
>  arch/score/kernel/module.c                 |  132 --------
>  arch/score/kernel/process.c                |  123 -------
>  arch/score/kernel/ptrace.c                 |  383 ---------------------
>  arch/score/kernel/setup.c                  |  162 ---------
>  arch/score/kernel/signal.c                 |  315 ------------------
>  arch/score/kernel/sys_call_table.c         |   12 -
>  arch/score/kernel/sys_score.c              |   50 ---
>  arch/score/kernel/time.c                   |   99 ------
>  arch/score/kernel/traps.c                  |  341 -------------------
>  arch/score/kernel/vmlinux.lds.S            |   90 -----
>  arch/score/lib/Makefile                    |    8 -
>  arch/score/lib/ashldi3.c                   |   46 ---
>  arch/score/lib/ashrdi3.c                   |   48 ---
>  arch/score/lib/checksum.S                  |  255 --------------
>  arch/score/lib/checksum_copy.c             |   52 ---
>  arch/score/lib/cmpdi2.c                    |   44 ---
>  arch/score/lib/libgcc.h                    |   37 ---
>  arch/score/lib/lshrdi3.c                   |   47 ---
>  arch/score/lib/string.S                    |  184 -----------
>  arch/score/lib/ucmpdi2.c                   |   38 ---
>  arch/score/mm/Makefile                     |    6 -
>  arch/score/mm/cache.c                      |  279 ----------------
>  arch/score/mm/extable.c                    |   38 ---
>  arch/score/mm/fault.c                      |  235 -------------
>  arch/score/mm/init.c                       |  109 ------
>  arch/score/mm/pgtable.c                    |   52 ---
>  arch/score/mm/tlb-miss.S                   |  199 -----------
>  arch/score/mm/tlb-score.c                  |  251 --------------
>  136 files changed, 7827 deletions(-)
>  delete mode 100644 arch/score/Kconfig
>  delete mode 100644 arch/score/Kconfig.debug
>  delete mode 100644 arch/score/Makefile
>  delete mode 100644 arch/score/boot/Makefile
>  delete mode 100644 arch/score/configs/spct6600_defconfig
>  delete mode 100644 arch/score/include/asm/Kbuild
>  delete mode 100644 arch/score/include/asm/asm-offsets.h
>  delete mode 100644 arch/score/include/asm/asmmacro.h
>  delete mode 100644 arch/score/include/asm/atomic.h
>  delete mode 100644 arch/score/include/asm/barrier.h
>  delete mode 100644 arch/score/include/asm/bitops.h
>  delete mode 100644 arch/score/include/asm/bug.h
>  delete mode 100644 arch/score/include/asm/bugs.h
>  delete mode 100644 arch/score/include/asm/cache.h
>  delete mode 100644 arch/score/include/asm/cacheflush.h
>  delete mode 100644 arch/score/include/asm/checksum.h
>  delete mode 100644 arch/score/include/asm/cmpxchg.h
>  delete mode 100644 arch/score/include/asm/cputime.h
>  delete mode 100644 arch/score/include/asm/current.h
>  delete mode 100644 arch/score/include/asm/delay.h
>  delete mode 100644 arch/score/include/asm/device.h
>  delete mode 100644 arch/score/include/asm/div64.h
>  delete mode 100644 arch/score/include/asm/dma.h
>  delete mode 100644 arch/score/include/asm/elf.h
>  delete mode 100644 arch/score/include/asm/emergency-restart.h
>  delete mode 100644 arch/score/include/asm/exec.h
>  delete mode 100644 arch/score/include/asm/fixmap.h
>  delete mode 100644 arch/score/include/asm/ftrace.h
>  delete mode 100644 arch/score/include/asm/futex.h
>  delete mode 100644 arch/score/include/asm/hardirq.h
>  delete mode 100644 arch/score/include/asm/hw_irq.h
>  delete mode 100644 arch/score/include/asm/io.h
>  delete mode 100644 arch/score/include/asm/irq.h
>  delete mode 100644 arch/score/include/asm/irq_regs.h
>  delete mode 100644 arch/score/include/asm/irqflags.h
>  delete mode 100644 arch/score/include/asm/kdebug.h
>  delete mode 100644 arch/score/include/asm/kmap_types.h
>  delete mode 100644 arch/score/include/asm/linkage.h
>  delete mode 100644 arch/score/include/asm/local.h
>  delete mode 100644 arch/score/include/asm/local64.h
>  delete mode 100644 arch/score/include/asm/mmu.h
>  delete mode 100644 arch/score/include/asm/mmu_context.h
>  delete mode 100644 arch/score/include/asm/module.h
>  delete mode 100644 arch/score/include/asm/mutex.h
>  delete mode 100644 arch/score/include/asm/page.h
>  delete mode 100644 arch/score/include/asm/pci.h
>  delete mode 100644 arch/score/include/asm/percpu.h
>  delete mode 100644 arch/score/include/asm/pgalloc.h
>  delete mode 100644 arch/score/include/asm/pgtable-bits.h
>  delete mode 100644 arch/score/include/asm/pgtable.h
>  delete mode 100644 arch/score/include/asm/processor.h
>  delete mode 100644 arch/score/include/asm/ptrace.h
>  delete mode 100644 arch/score/include/asm/scatterlist.h
>  delete mode 100644 arch/score/include/asm/scoreregs.h
>  delete mode 100644 arch/score/include/asm/sections.h
>  delete mode 100644 arch/score/include/asm/segment.h
>  delete mode 100644 arch/score/include/asm/setup.h
>  delete mode 100644 arch/score/include/asm/shmparam.h
>  delete mode 100644 arch/score/include/asm/string.h
>  delete mode 100644 arch/score/include/asm/switch_to.h
>  delete mode 100644 arch/score/include/asm/syscalls.h
>  delete mode 100644 arch/score/include/asm/thread_info.h
>  delete mode 100644 arch/score/include/asm/timex.h
>  delete mode 100644 arch/score/include/asm/tlb.h
>  delete mode 100644 arch/score/include/asm/tlbflush.h
>  delete mode 100644 arch/score/include/asm/topology.h
>  delete mode 100644 arch/score/include/asm/uaccess.h
>  delete mode 100644 arch/score/include/asm/ucontext.h
>  delete mode 100644 arch/score/include/asm/unaligned.h
>  delete mode 100644 arch/score/include/asm/user.h
>  delete mode 100644 arch/score/include/uapi/asm/Kbuild
>  delete mode 100644 arch/score/include/uapi/asm/auxvec.h
>  delete mode 100644 arch/score/include/uapi/asm/bitsperlong.h
>  delete mode 100644 arch/score/include/uapi/asm/byteorder.h
>  delete mode 100644 arch/score/include/uapi/asm/errno.h
>  delete mode 100644 arch/score/include/uapi/asm/fcntl.h
>  delete mode 100644 arch/score/include/uapi/asm/ioctl.h
>  delete mode 100644 arch/score/include/uapi/asm/ioctls.h
>  delete mode 100644 arch/score/include/uapi/asm/ipcbuf.h
>  delete mode 100644 arch/score/include/uapi/asm/kvm_para.h
>  delete mode 100644 arch/score/include/uapi/asm/mman.h
>  delete mode 100644 arch/score/include/uapi/asm/msgbuf.h
>  delete mode 100644 arch/score/include/uapi/asm/param.h
>  delete mode 100644 arch/score/include/uapi/asm/poll.h
>  delete mode 100644 arch/score/include/uapi/asm/posix_types.h
>  delete mode 100644 arch/score/include/uapi/asm/ptrace.h
>  delete mode 100644 arch/score/include/uapi/asm/resource.h
>  delete mode 100644 arch/score/include/uapi/asm/sembuf.h
>  delete mode 100644 arch/score/include/uapi/asm/setup.h
>  delete mode 100644 arch/score/include/uapi/asm/shmbuf.h
>  delete mode 100644 arch/score/include/uapi/asm/sigcontext.h
>  delete mode 100644 arch/score/include/uapi/asm/siginfo.h
>  delete mode 100644 arch/score/include/uapi/asm/signal.h
>  delete mode 100644 arch/score/include/uapi/asm/socket.h
>  delete mode 100644 arch/score/include/uapi/asm/sockios.h
>  delete mode 100644 arch/score/include/uapi/asm/stat.h
>  delete mode 100644 arch/score/include/uapi/asm/statfs.h
>  delete mode 100644 arch/score/include/uapi/asm/swab.h
>  delete mode 100644 arch/score/include/uapi/asm/termbits.h
>  delete mode 100644 arch/score/include/uapi/asm/termios.h
>  delete mode 100644 arch/score/include/uapi/asm/types.h
>  delete mode 100644 arch/score/include/uapi/asm/unistd.h
>  delete mode 100644 arch/score/kernel/Makefile
>  delete mode 100644 arch/score/kernel/asm-offsets.c
>  delete mode 100644 arch/score/kernel/entry.S
>  delete mode 100644 arch/score/kernel/head.S
>  delete mode 100644 arch/score/kernel/irq.c
>  delete mode 100644 arch/score/kernel/module.c
>  delete mode 100644 arch/score/kernel/process.c
>  delete mode 100644 arch/score/kernel/ptrace.c
>  delete mode 100644 arch/score/kernel/setup.c
>  delete mode 100644 arch/score/kernel/signal.c
>  delete mode 100644 arch/score/kernel/sys_call_table.c
>  delete mode 100644 arch/score/kernel/sys_score.c
>  delete mode 100644 arch/score/kernel/time.c
>  delete mode 100644 arch/score/kernel/traps.c
>  delete mode 100644 arch/score/kernel/vmlinux.lds.S
>  delete mode 100644 arch/score/lib/Makefile
>  delete mode 100644 arch/score/lib/ashldi3.c
>  delete mode 100644 arch/score/lib/ashrdi3.c
>  delete mode 100644 arch/score/lib/checksum.S
>  delete mode 100644 arch/score/lib/checksum_copy.c
>  delete mode 100644 arch/score/lib/cmpdi2.c
>  delete mode 100644 arch/score/lib/libgcc.h
>  delete mode 100644 arch/score/lib/lshrdi3.c
>  delete mode 100644 arch/score/lib/string.S
>  delete mode 100644 arch/score/lib/ucmpdi2.c
>  delete mode 100644 arch/score/mm/Makefile
>  delete mode 100644 arch/score/mm/cache.c
>  delete mode 100644 arch/score/mm/extable.c
>  delete mode 100644 arch/score/mm/fault.c
>  delete mode 100644 arch/score/mm/init.c
>  delete mode 100644 arch/score/mm/pgtable.c
>  delete mode 100644 arch/score/mm/tlb-miss.S
>  delete mode 100644 arch/score/mm/tlb-score.c
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 62e513e..bdf7855 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -7178,13 +7178,6 @@ F:       kernel/sched/
>  F:     include/linux/sched.h
>  F:     include/uapi/linux/sched.h
>
> -SCORE ARCHITECTURE
> -M:     Chen Liqin <liqin.chen@sunplusct.com>
> -M:     Lennox Wu <lennox.wu@gmail.com>
> -W:     http://www.sunplusct.com
> -S:     Supported
> -F:     arch/score/
> -
>  SCSI CDROM DRIVER
>  M:     Jens Axboe <axboe@kernel.dk>
>  L:     linux-scsi@vger.kernel.org
> diff --git a/arch/score/Kconfig b/arch/score/Kconfig
> deleted file mode 100644
> index 5fc2375..0000000
> --- a/arch/score/Kconfig
> +++ /dev/null
> @@ -1,113 +0,0 @@
> -menu "Machine selection"
> -
> -config SCORE
> -       def_bool y
> -       select HAVE_GENERIC_HARDIRQS
> -       select GENERIC_IRQ_SHOW
> -       select GENERIC_IOMAP
> -       select GENERIC_ATOMIC64
> -       select HAVE_MEMBLOCK
> -       select HAVE_MEMBLOCK_NODE_MAP
> -       select ARCH_DISCARD_MEMBLOCK
> -       select GENERIC_CPU_DEVICES
> -       select GENERIC_CLOCKEVENTS
> -       select HAVE_MOD_ARCH_SPECIFIC
> -       select VIRT_TO_BUS
> -       select MODULES_USE_ELF_REL
> -       select CLONE_BACKWARDS
> -
> -choice
> -       prompt "System type"
> -       default MACH_SPCT6600
> -
> -config ARCH_SCORE7
> -       bool "SCORE7 processor"
> -       select SYS_SUPPORTS_32BIT_KERNEL
> -       select CPU_SCORE7
> -       select GENERIC_HAS_IOMAP
> -
> -config MACH_SPCT6600
> -       bool "SPCT6600 series based machines"
> -       select SYS_SUPPORTS_32BIT_KERNEL
> -       select CPU_SCORE7
> -       select GENERIC_HAS_IOMAP
> -
> -config SCORE_SIM
> -       bool "Score simulator"
> -       select SYS_SUPPORTS_32BIT_KERNEL
> -       select CPU_SCORE7
> -       select GENERIC_HAS_IOMAP
> -endchoice
> -
> -endmenu
> -
> -config CPU_SCORE7
> -       bool
> -
> -config NO_DMA
> -       bool
> -       default y
> -
> -config RWSEM_GENERIC_SPINLOCK
> -       def_bool y
> -
> -config GENERIC_HWEIGHT
> -       def_bool y
> -
> -config GENERIC_CALIBRATE_DELAY
> -       def_bool y
> -
> -menu "Kernel type"
> -
> -config 32BIT
> -       def_bool y
> -
> -config ARCH_FLATMEM_ENABLE
> -       def_bool y
> -
> -source "mm/Kconfig"
> -
> -config MEMORY_START
> -       hex
> -       default 0xa0000000
> -
> -source "kernel/Kconfig.hz"
> -source "kernel/Kconfig.preempt"
> -
> -endmenu
> -
> -config RWSEM_GENERIC_SPINLOCK
> -       def_bool y
> -
> -config LOCKDEP_SUPPORT
> -       def_bool y
> -
> -config STACKTRACE_SUPPORT
> -       def_bool y
> -
> -source "init/Kconfig"
> -
> -source "kernel/Kconfig.freezer"
> -
> -config MMU
> -       def_bool y
> -
> -menu "Executable file formats"
> -
> -source "fs/Kconfig.binfmt"
> -
> -endmenu
> -
> -source "net/Kconfig"
> -
> -source "drivers/Kconfig"
> -
> -source "fs/Kconfig"
> -
> -source "arch/score/Kconfig.debug"
> -
> -source "security/Kconfig"
> -
> -source "crypto/Kconfig"
> -
> -source "lib/Kconfig"
> diff --git a/arch/score/Kconfig.debug b/arch/score/Kconfig.debug
> deleted file mode 100644
> index d8a9b2d..0000000
> --- a/arch/score/Kconfig.debug
> +++ /dev/null
> @@ -1,28 +0,0 @@
> -menu "Kernel hacking"
> -
> -config TRACE_IRQFLAGS_SUPPORT
> -       bool
> -       default y
> -
> -source "lib/Kconfig.debug"
> -
> -config CMDLINE
> -       string "Default kernel command string"
> -       default ""
> -       help
> -         On some platforms, there is currently no way for the boot loader to
> -         pass arguments to the kernel. For these platforms, you can supply
> -         some command-line options at build time by entering them here.  In
> -         other cases you can specify kernel args so that you don't have
> -         to set them up in board prom initialization routines.
> -
> -config RUNTIME_DEBUG
> -       bool "Enable run-time debugging"
> -       depends on DEBUG_KERNEL
> -       help
> -         If you say Y here, some debugging macros will do run-time checking.
> -         If you say N here, those macros will mostly turn to no-ops.  See
> -         include/asm-score/debug.h for debugging macros.
> -         If unsure, say N.
> -
> -endmenu
> diff --git a/arch/score/Makefile b/arch/score/Makefile
> deleted file mode 100644
> index 974aefe..0000000
> --- a/arch/score/Makefile
> +++ /dev/null
> @@ -1,44 +0,0 @@
> -#
> -# arch/score/Makefile
> -#
> -# This file is subject to the terms and conditions of the GNU General Public
> -# License.  See the file "COPYING" in the main directory of this archive
> -# for more details.
> -#
> -
> -KBUILD_DEFCONFIG := spct6600_defconfig
> -CROSS_COMPILE := score-linux-
> -
> -#
> -# CPU-dependent compiler/assembler options for optimization.
> -#
> -cflags-y += -G0 -pipe -mel -mnhwloop -D__SCOREEL__ \
> -       -D__linux__ -ffunction-sections -ffreestanding
> -
> -#
> -# Board-dependent options and extra files
> -#
> -KBUILD_AFLAGS += $(cflags-y)
> -KBUILD_CFLAGS += $(cflags-y)
> -KBUILD_AFLAGS_MODULE += -mlong-calls
> -KBUILD_CFLAGS_MODULE += -mlong-calls
> -LDFLAGS += --oformat elf32-littlescore
> -LDFLAGS_vmlinux        += -G0 -static -nostdlib
> -
> -head-y := arch/score/kernel/head.o
> -libs-y += arch/score/lib/
> -core-y += arch/score/kernel/ arch/score/mm/
> -
> -boot := arch/score/boot
> -
> -vmlinux.bin: vmlinux
> -       $(Q)$(MAKE) $(build)=$(boot) $(boot)/$@
> -
> -archclean:
> -       @$(MAKE) $(clean)=$(boot)
> -
> -define archhelp
> -       echo '  vmlinux.bin          - Raw binary boot image'
> -       echo
> -       echo '  These will be default as appropriate for a configured platform.'
> -endef
> diff --git a/arch/score/boot/Makefile b/arch/score/boot/Makefile
> deleted file mode 100644
> index 0c5fbd0..0000000
> --- a/arch/score/boot/Makefile
> +++ /dev/null
> @@ -1,15 +0,0 @@
> -#
> -# arch/score/boot/Makefile
> -#
> -# This file is subject to the terms and conditions of the GNU General Public
> -# License.  See the file "COPYING" in the main directory of this archive
> -# for more details.
> -#
> -
> -targets        := vmlinux.bin
> -
> -$(obj)/vmlinux.bin: vmlinux FORCE
> -       $(call if_changed,objcopy)
> -       @echo 'Kernel: $@ is ready' ' (#'`cat .version`')'
> -
> -clean-files += vmlinux.bin
> diff --git a/arch/score/configs/spct6600_defconfig b/arch/score/configs/spct6600_defconfig
> deleted file mode 100644
> index df1edbf..0000000
> --- a/arch/score/configs/spct6600_defconfig
> +++ /dev/null
> @@ -1,85 +0,0 @@
> -CONFIG_HZ_100=y
> -CONFIG_PREEMPT_VOLUNTARY=y
> -CONFIG_EXPERIMENTAL=y
> -# CONFIG_LOCALVERSION_AUTO is not set
> -CONFIG_SYSVIPC=y
> -CONFIG_POSIX_MQUEUE=y
> -CONFIG_BSD_PROCESS_ACCT=y
> -CONFIG_LOG_BUF_SHIFT=12
> -CONFIG_SYSFS_DEPRECATED_V2=y
> -CONFIG_BLK_DEV_INITRD=y
> -# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
> -CONFIG_EXPERT=y
> -# CONFIG_KALLSYMS is not set
> -# CONFIG_HOTPLUG is not set
> -CONFIG_SLAB=y
> -CONFIG_MODULES=y
> -CONFIG_MODULE_FORCE_LOAD=y
> -CONFIG_MODULE_UNLOAD=y
> -CONFIG_MODULE_FORCE_UNLOAD=y
> -# CONFIG_BLK_DEV_BSG is not set
> -CONFIG_BINFMT_MISC=y
> -CONFIG_NET=y
> -CONFIG_UNIX=y
> -CONFIG_NET_KEY=y
> -CONFIG_INET=y
> -CONFIG_IP_MULTICAST=y
> -CONFIG_ARPD=y
> -# CONFIG_INET_LRO is not set
> -# CONFIG_IPV6 is not set
> -# CONFIG_STANDALONE is not set
> -# CONFIG_PREVENT_FIRMWARE_BUILD is not set
> -CONFIG_BLK_DEV_LOOP=y
> -CONFIG_BLK_DEV_CRYPTOLOOP=y
> -CONFIG_BLK_DEV_RAM=y
> -CONFIG_BLK_DEV_RAM_COUNT=1
> -# CONFIG_MISC_DEVICES is not set
> -CONFIG_NETDEVICES=y
> -# CONFIG_NETDEV_1000 is not set
> -# CONFIG_NETDEV_10000 is not set
> -# CONFIG_INPUT_MOUSEDEV is not set
> -# CONFIG_INPUT_KEYBOARD is not set
> -# CONFIG_INPUT_MOUSE is not set
> -# CONFIG_SERIO is not set
> -CONFIG_SERIAL_NONSTANDARD=y
> -CONFIG_STALDRV=y
> -# CONFIG_HW_RANDOM is not set
> -CONFIG_RAW_DRIVER=y
> -CONFIG_MAX_RAW_DEVS=8192
> -# CONFIG_HWMON is not set
> -# CONFIG_VGA_CONSOLE is not set
> -# CONFIG_HID_SUPPORT is not set
> -# CONFIG_USB_SUPPORT is not set
> -CONFIG_EXT2_FS=y
> -CONFIG_EXT2_FS_XATTR=y
> -CONFIG_EXT2_FS_POSIX_ACL=y
> -CONFIG_EXT3_FS=y
> -# CONFIG_EXT3_DEFAULTS_TO_ORDERED is not set
> -CONFIG_EXT3_FS_POSIX_ACL=y
> -CONFIG_AUTOFS_FS=y
> -CONFIG_AUTOFS4_FS=y
> -CONFIG_PROC_KCORE=y
> -# CONFIG_PROC_PAGE_MONITOR is not set
> -CONFIG_TMPFS=y
> -CONFIG_TMPFS_POSIX_ACL=y
> -CONFIG_NFS_FS=y
> -CONFIG_NFS_V3=y
> -CONFIG_NFS_V3_ACL=y
> -CONFIG_NFS_V4=y
> -CONFIG_NFSD=y
> -CONFIG_NFSD_V3_ACL=y
> -CONFIG_NFSD_V4=y
> -# CONFIG_RCU_CPU_STALL_DETECTOR is not set
> -CONFIG_KEYS_DEBUG_PROC_KEYS=y
> -CONFIG_SECURITY=y
> -CONFIG_SECURITY_NETWORK=y
> -CONFIG_CRYPTO_NULL=y
> -CONFIG_CRYPTO_CRYPTD=y
> -CONFIG_CRYPTO_SEQIV=y
> -CONFIG_CRYPTO_MD4=y
> -CONFIG_CRYPTO_MICHAEL_MIC=y
> -# CONFIG_CRYPTO_ANSI_CPRNG is not set
> -# CONFIG_CRYPTO_HW is not set
> -CONFIG_CRC_CCITT=y
> -CONFIG_CRC16=y
> -CONFIG_LIBCRC32C=y
> diff --git a/arch/score/include/asm/Kbuild b/arch/score/include/asm/Kbuild
> deleted file mode 100644
> index e1c7bb9..0000000
> --- a/arch/score/include/asm/Kbuild
> +++ /dev/null
> @@ -1,6 +0,0 @@
> -
> -header-y +=
> -
> -generic-y += clkdev.h
> -generic-y += trace_clock.h
> -generic-y += xor.h
> diff --git a/arch/score/include/asm/asm-offsets.h b/arch/score/include/asm/asm-offsets.h
> deleted file mode 100644
> index d370ee3..0000000
> --- a/arch/score/include/asm/asm-offsets.h
> +++ /dev/null
> @@ -1 +0,0 @@
> -#include <generated/asm-offsets.h>
> diff --git a/arch/score/include/asm/asmmacro.h b/arch/score/include/asm/asmmacro.h
> deleted file mode 100644
> index a04a54c..0000000
> --- a/arch/score/include/asm/asmmacro.h
> +++ /dev/null
> @@ -1,161 +0,0 @@
> -#ifndef _ASM_SCORE_ASMMACRO_H
> -#define _ASM_SCORE_ASMMACRO_H
> -
> -#include <asm/asm-offsets.h>
> -
> -#ifdef __ASSEMBLY__
> -
> -.macro SAVE_ALL
> -       mfcr    r30, cr0
> -       mv      r31, r0
> -       nop
> -       /* if UMs == 1, change stack. */
> -       slli.c  r30, r30, 28
> -       bpl     1f
> -       la      r31, kernelsp
> -       lw      r31, [r31]
> -1:
> -       mv      r30, r0
> -       addri   r0, r31, -PT_SIZE
> -
> -       sw      r30, [r0, PT_R0]
> -       .set    r1
> -       sw      r1, [r0, PT_R1]
> -       .set    nor1
> -       sw      r2, [r0, PT_R2]
> -       sw      r3, [r0, PT_R3]
> -       sw      r4, [r0, PT_R4]
> -       sw      r5, [r0, PT_R5]
> -       sw      r6, [r0, PT_R6]
> -       sw      r7, [r0, PT_R7]
> -
> -       sw      r8, [r0, PT_R8]
> -       sw      r9, [r0, PT_R9]
> -       sw      r10, [r0, PT_R10]
> -       sw      r11, [r0, PT_R11]
> -       sw      r12, [r0, PT_R12]
> -       sw      r13, [r0, PT_R13]
> -       sw      r14, [r0, PT_R14]
> -       sw      r15, [r0, PT_R15]
> -
> -       sw      r16, [r0, PT_R16]
> -       sw      r17, [r0, PT_R17]
> -       sw      r18, [r0, PT_R18]
> -       sw      r19, [r0, PT_R19]
> -       sw      r20, [r0, PT_R20]
> -       sw      r21, [r0, PT_R21]
> -       sw      r22, [r0, PT_R22]
> -       sw      r23, [r0, PT_R23]
> -
> -       sw      r24, [r0, PT_R24]
> -       sw      r25, [r0, PT_R25]
> -       sw      r25, [r0, PT_R25]
> -       sw      r26, [r0, PT_R26]
> -       sw      r27, [r0, PT_R27]
> -
> -       sw      r28, [r0, PT_R28]
> -       sw      r29, [r0, PT_R29]
> -       orri    r28, r0, 0x1fff
> -       li      r31, 0x00001fff
> -       xor     r28, r28, r31
> -
> -       mfcehl  r30, r31
> -       sw      r30, [r0, PT_CEH]
> -       sw      r31, [r0, PT_CEL]
> -
> -       mfcr    r31, cr0
> -       sw      r31, [r0, PT_PSR]
> -
> -       mfcr    r31, cr1
> -       sw      r31, [r0, PT_CONDITION]
> -
> -       mfcr    r31, cr2
> -       sw      r31, [r0, PT_ECR]
> -
> -       mfcr    r31, cr5
> -       srli    r31, r31, 1
> -       slli    r31, r31, 1
> -       sw      r31, [r0, PT_EPC]
> -.endm
> -
> -.macro RESTORE_ALL_AND_RET
> -       mfcr    r30, cr0
> -       srli    r30, r30, 1
> -       slli    r30, r30, 1
> -       mtcr    r30, cr0
> -       nop
> -       nop
> -       nop
> -       nop
> -       nop
> -
> -       .set    r1
> -       ldis    r1, 0x00ff
> -       and     r30, r30, r1
> -       not     r1, r1
> -       lw      r31, [r0, PT_PSR]
> -       and     r31, r31, r1
> -       .set    nor1
> -       or      r31, r31, r30
> -       mtcr    r31, cr0
> -       nop
> -       nop
> -       nop
> -       nop
> -       nop
> -
> -       lw      r30, [r0, PT_CONDITION]
> -       mtcr    r30, cr1
> -       nop
> -       nop
> -       nop
> -       nop
> -       nop
> -
> -       lw      r30, [r0, PT_CEH]
> -       lw      r31, [r0, PT_CEL]
> -       mtcehl  r30, r31
> -
> -       .set    r1
> -       lw      r1, [r0, PT_R1]
> -       .set    nor1
> -       lw      r2, [r0, PT_R2]
> -       lw      r3, [r0, PT_R3]
> -       lw      r4, [r0, PT_R4]
> -       lw      r5, [r0, PT_R5]
> -       lw      r6, [r0, PT_R6]
> -       lw      r7, [r0, PT_R7]
> -
> -       lw      r8, [r0, PT_R8]
> -       lw      r9, [r0, PT_R9]
> -       lw      r10, [r0, PT_R10]
> -       lw      r11, [r0, PT_R11]
> -       lw      r12, [r0, PT_R12]
> -       lw      r13, [r0, PT_R13]
> -       lw      r14, [r0, PT_R14]
> -       lw      r15, [r0, PT_R15]
> -
> -       lw      r16, [r0, PT_R16]
> -       lw      r17, [r0, PT_R17]
> -       lw      r18, [r0, PT_R18]
> -       lw      r19, [r0, PT_R19]
> -       lw      r20, [r0, PT_R20]
> -       lw      r21, [r0, PT_R21]
> -       lw      r22, [r0, PT_R22]
> -       lw      r23, [r0, PT_R23]
> -
> -       lw      r24, [r0, PT_R24]
> -       lw      r25, [r0, PT_R25]
> -       lw      r26, [r0, PT_R26]
> -       lw      r27, [r0, PT_R27]
> -       lw      r28, [r0, PT_R28]
> -       lw      r29, [r0, PT_R29]
> -
> -       lw      r30, [r0, PT_EPC]
> -       lw      r0, [r0, PT_R0]
> -       mtcr    r30, cr5
> -       rte
> -.endm
> -
> -#endif /* __ASSEMBLY__ */
> -#endif /* _ASM_SCORE_ASMMACRO_H */
> diff --git a/arch/score/include/asm/atomic.h b/arch/score/include/asm/atomic.h
> deleted file mode 100644
> index edf33db..0000000
> --- a/arch/score/include/asm/atomic.h
> +++ /dev/null
> @@ -1,7 +0,0 @@
> -#ifndef _ASM_SCORE_ATOMIC_H
> -#define _ASM_SCORE_ATOMIC_H
> -
> -#include <asm/cmpxchg.h>
> -#include <asm-generic/atomic.h>
> -
> -#endif /* _ASM_SCORE_ATOMIC_H */
> diff --git a/arch/score/include/asm/barrier.h b/arch/score/include/asm/barrier.h
> deleted file mode 100644
> index 0eacb64..0000000
> --- a/arch/score/include/asm/barrier.h
> +++ /dev/null
> @@ -1,16 +0,0 @@
> -#ifndef _ASM_SCORE_BARRIER_H
> -#define _ASM_SCORE_BARRIER_H
> -
> -#define mb()           barrier()
> -#define rmb()          barrier()
> -#define wmb()          barrier()
> -#define smp_mb()       barrier()
> -#define smp_rmb()      barrier()
> -#define smp_wmb()      barrier()
> -
> -#define read_barrier_depends()         do {} while (0)
> -#define smp_read_barrier_depends()     do {} while (0)
> -
> -#define set_mb(var, value)             do {var = value; wmb(); } while (0)
> -
> -#endif /* _ASM_SCORE_BARRIER_H */
> diff --git a/arch/score/include/asm/bitops.h b/arch/score/include/asm/bitops.h
> deleted file mode 100644
> index a304096..0000000
> --- a/arch/score/include/asm/bitops.h
> +++ /dev/null
> @@ -1,15 +0,0 @@
> -#ifndef _ASM_SCORE_BITOPS_H
> -#define _ASM_SCORE_BITOPS_H
> -
> -#include <asm/byteorder.h> /* swab32 */
> -
> -/*
> - * clear_bit() doesn't provide any barrier for the compiler.
> - */
> -#define smp_mb__before_clear_bit()     barrier()
> -#define smp_mb__after_clear_bit()      barrier()
> -
> -#include <asm-generic/bitops.h>
> -#include <asm-generic/bitops/__fls.h>
> -
> -#endif /* _ASM_SCORE_BITOPS_H */
> diff --git a/arch/score/include/asm/bug.h b/arch/score/include/asm/bug.h
> deleted file mode 100644
> index fd7164a..0000000
> --- a/arch/score/include/asm/bug.h
> +++ /dev/null
> @@ -1,17 +0,0 @@
> -#ifndef _ASM_SCORE_BUG_H
> -#define _ASM_SCORE_BUG_H
> -
> -#include <asm-generic/bug.h>
> -
> -struct pt_regs;
> -extern void __die(const char *, struct pt_regs *, const char *,
> -       const char *, unsigned long) __attribute__((noreturn));
> -extern void __die_if_kernel(const char *, struct pt_regs *, const char *,
> -       const char *, unsigned long);
> -
> -#define die(msg, regs)                                                 \
> -       __die(msg, regs, __FILE__ ":", __func__, __LINE__)
> -#define die_if_kernel(msg, regs)                                       \
> -       __die_if_kernel(msg, regs, __FILE__ ":", __func__, __LINE__)
> -
> -#endif /* _ASM_SCORE_BUG_H */
> diff --git a/arch/score/include/asm/bugs.h b/arch/score/include/asm/bugs.h
> deleted file mode 100644
> index a062e10..0000000
> --- a/arch/score/include/asm/bugs.h
> +++ /dev/null
> @@ -1,6 +0,0 @@
> -#ifndef _ASM_SCORE_BUGS_H
> -#define _ASM_SCORE_BUGS_H
> -
> -#include <asm-generic/bugs.h>
> -
> -#endif /* _ASM_SCORE_BUGS_H */
> diff --git a/arch/score/include/asm/cache.h b/arch/score/include/asm/cache.h
> deleted file mode 100644
> index ae3d59f..0000000
> --- a/arch/score/include/asm/cache.h
> +++ /dev/null
> @@ -1,7 +0,0 @@
> -#ifndef _ASM_SCORE_CACHE_H
> -#define _ASM_SCORE_CACHE_H
> -
> -#define L1_CACHE_SHIFT         4
> -#define L1_CACHE_BYTES         (1 << L1_CACHE_SHIFT)
> -
> -#endif /* _ASM_SCORE_CACHE_H */
> diff --git a/arch/score/include/asm/cacheflush.h b/arch/score/include/asm/cacheflush.h
> deleted file mode 100644
> index 1d545d0..0000000
> --- a/arch/score/include/asm/cacheflush.h
> +++ /dev/null
> @@ -1,48 +0,0 @@
> -#ifndef _ASM_SCORE_CACHEFLUSH_H
> -#define _ASM_SCORE_CACHEFLUSH_H
> -
> -/* Keep includes the same across arches. */
> -#include <linux/mm.h>
> -
> -extern void flush_cache_all(void);
> -extern void flush_cache_mm(struct mm_struct *mm);
> -extern void flush_cache_range(struct vm_area_struct *vma,
> -                               unsigned long start, unsigned long end);
> -extern void flush_cache_page(struct vm_area_struct *vma,
> -                               unsigned long page, unsigned long pfn);
> -extern void flush_cache_sigtramp(unsigned long addr);
> -extern void flush_icache_all(void);
> -extern void flush_icache_range(unsigned long start, unsigned long end);
> -extern void flush_dcache_range(unsigned long start, unsigned long end);
> -extern void flush_dcache_page(struct page *page);
> -
> -#define PG_dcache_dirty         PG_arch_1
> -
> -#define flush_cache_dup_mm(mm)                 do {} while (0)
> -#define ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE 0
> -#define flush_dcache_mmap_lock(mapping)                do {} while (0)
> -#define flush_dcache_mmap_unlock(mapping)      do {} while (0)
> -#define flush_cache_vmap(start, end)           do {} while (0)
> -#define flush_cache_vunmap(start, end)         do {} while (0)
> -
> -static inline void flush_icache_page(struct vm_area_struct *vma,
> -       struct page *page)
> -{
> -       if (vma->vm_flags & VM_EXEC) {
> -               void *v = page_address(page);
> -               flush_icache_range((unsigned long) v,
> -                               (unsigned long) v + PAGE_SIZE);
> -       }
> -}
> -
> -#define copy_from_user_page(vma, page, vaddr, dst, src, len) \
> -       memcpy(dst, src, len)
> -
> -#define copy_to_user_page(vma, page, vaddr, dst, src, len)     \
> -       do {                                                    \
> -               memcpy(dst, src, len);                          \
> -               if ((vma->vm_flags & VM_EXEC))                  \
> -                       flush_cache_page(vma, vaddr, page_to_pfn(page));\
> -       } while (0)
> -
> -#endif /* _ASM_SCORE_CACHEFLUSH_H */
> diff --git a/arch/score/include/asm/checksum.h b/arch/score/include/asm/checksum.h
> deleted file mode 100644
> index f909ac3..0000000
> --- a/arch/score/include/asm/checksum.h
> +++ /dev/null
> @@ -1,235 +0,0 @@
> -#ifndef _ASM_SCORE_CHECKSUM_H
> -#define _ASM_SCORE_CHECKSUM_H
> -
> -#include <linux/in6.h>
> -#include <asm/uaccess.h>
> -
> -/*
> - * computes the checksum of a memory block at buff, length len,
> - * and adds in "sum" (32-bit)
> - *
> - * returns a 32-bit number suitable for feeding into itself
> - * or csum_tcpudp_magic
> - *
> - * this function must be called with even lengths, except
> - * for the last fragment, which may be odd
> - *
> - * it's best to have buff aligned on a 32-bit boundary
> - */
> -unsigned int csum_partial(const void *buff, int len, __wsum sum);
> -unsigned int csum_partial_copy_from_user(const char *src, char *dst, int len,
> -                                       unsigned int sum, int *csum_err);
> -unsigned int csum_partial_copy(const char *src, char *dst,
> -                                       int len, unsigned int sum);
> -
> -/*
> - * this is a new version of the above that records errors it finds in *errp,
> - * but continues and zeros the rest of the buffer.
> - */
> -
> -/*
> - * Copy and checksum to user
> - */
> -#define HAVE_CSUM_COPY_USER
> -static inline
> -__wsum csum_and_copy_to_user(const void *src, void __user *dst, int len,
> -                       __wsum sum, int *err_ptr)
> -{
> -       sum = csum_partial(src, len, sum);
> -       if (copy_to_user(dst, src, len)) {
> -               *err_ptr = -EFAULT;
> -               return (__force __wsum) -1; /* invalid checksum */
> -       }
> -       return sum;
> -}
> -
> -
> -#define csum_partial_copy_nocheck csum_partial_copy
> -/*
> - *     Fold a partial checksum without adding pseudo headers
> - */
> -
> -static inline __sum16 csum_fold(__wsum sum)
> -{
> -       /* the while loop is unnecessary really, it's always enough with two
> -          iterations */
> -       __asm__ __volatile__(
> -               ".set volatile\n\t"
> -               ".set\tr1\n\t"
> -               "slli\tr1,%0, 16\n\t"
> -               "add\t%0,%0, r1\n\t"
> -               "cmp.c\tr1, %0\n\t"
> -               "srli\t%0, %0, 16\n\t"
> -               "bleu\t1f\n\t"
> -               "addi\t%0, 0x1\n\t"
> -               "1:ldi\tr30, 0xffff\n\t"
> -               "xor\t%0, %0, r30\n\t"
> -               "slli\t%0, %0, 16\n\t"
> -               "srli\t%0, %0, 16\n\t"
> -               ".set\tnor1\n\t"
> -               ".set optimize\n\t"
> -               : "=r" (sum)
> -               : "0" (sum));
> -       return sum;
> -}
> -
> -/*
> - *     This is a version of ip_compute_csum() optimized for IP headers,
> - *     which always checksum on 4 octet boundaries.
> - *
> - *     By Jorge Cwik <jorge@laser.satlink.net>, adapted for linux by
> - *     Arnt Gulbrandsen.
> - */
> -static inline __sum16 ip_fast_csum(const void *iph, unsigned int ihl)
> -{
> -       unsigned int sum;
> -       unsigned long dummy;
> -
> -       __asm__ __volatile__(
> -               ".set volatile\n\t"
> -               ".set\tnor1\n\t"
> -               "lw\t%0, [%1]\n\t"
> -               "subri\t%2, %2, 4\n\t"
> -               "slli\t%2, %2, 2\n\t"
> -               "lw\t%3, [%1, 4]\n\t"
> -               "add\t%2, %2, %1\n\t"
> -               "add\t%0, %0, %3\n\t"
> -               "cmp.c\t%3, %0\n\t"
> -               "lw\t%3, [%1, 8]\n\t"
> -               "bleu\t1f\n\t"
> -               "addi\t%0, 0x1\n\t"
> -               "1:\n\t"
> -               "add\t%0, %0, %3\n\t"
> -               "cmp.c\t%3, %0\n\t"
> -               "lw\t%3, [%1, 12]\n\t"
> -               "bleu\t1f\n\t"
> -               "addi\t%0, 0x1\n\t"
> -               "1:add\t%0, %0, %3\n\t"
> -               "cmp.c\t%3, %0\n\t"
> -               "bleu\t1f\n\t"
> -               "addi\t%0, 0x1\n"
> -
> -               "1:\tlw\t%3, [%1, 16]\n\t"
> -               "addi\t%1, 4\n\t"
> -               "add\t%0, %0, %3\n\t"
> -               "cmp.c\t%3, %0\n\t"
> -               "bleu\t2f\n\t"
> -               "addi\t%0, 0x1\n"
> -               "2:cmp.c\t%2, %1\n\t"
> -               "bne\t1b\n\t"
> -
> -               ".set\tr1\n\t"
> -               ".set optimize\n\t"
> -               : "=&r" (sum), "=&r" (iph), "=&r" (ihl), "=&r" (dummy)
> -               : "1" (iph), "2" (ihl));
> -
> -       return csum_fold(sum);
> -}
> -
> -static inline __wsum
> -csum_tcpudp_nofold(__be32 saddr, __be32 daddr, unsigned short len,
> -               unsigned short proto, __wsum sum)
> -{
> -       unsigned long tmp = (ntohs(len) << 16) + proto * 256;
> -       __asm__ __volatile__(
> -               ".set volatile\n\t"
> -               "add\t%0, %0, %2\n\t"
> -               "cmp.c\t%2, %0\n\t"
> -               "bleu\t1f\n\t"
> -               "addi\t%0, 0x1\n\t"
> -               "1:\n\t"
> -               "add\t%0, %0, %3\n\t"
> -               "cmp.c\t%3, %0\n\t"
> -               "bleu\t1f\n\t"
> -               "addi\t%0, 0x1\n\t"
> -               "1:\n\t"
> -               "add\t%0, %0, %4\n\t"
> -               "cmp.c\t%4, %0\n\t"
> -               "bleu\t1f\n\t"
> -               "addi\t%0, 0x1\n\t"
> -               "1:\n\t"
> -               ".set optimize\n\t"
> -               : "=r" (sum)
> -               : "0" (daddr), "r"(saddr),
> -               "r" (tmp),
> -               "r" (sum));
> -       return sum;
> -}
> -
> -/*
> - * computes the checksum of the TCP/UDP pseudo-header
> - * returns a 16-bit checksum, already complemented
> - */
> -static inline __sum16
> -csum_tcpudp_magic(__be32 saddr, __be32 daddr, unsigned short len,
> -               unsigned short proto, __wsum sum)
> -{
> -       return csum_fold(csum_tcpudp_nofold(saddr, daddr, len, proto, sum));
> -}
> -
> -/*
> - * this routine is used for miscellaneous IP-like checksums, mainly
> - * in icmp.c
> - */
> -
> -static inline unsigned short ip_compute_csum(const void *buff, int len)
> -{
> -       return csum_fold(csum_partial(buff, len, 0));
> -}
> -
> -#define _HAVE_ARCH_IPV6_CSUM
> -static inline __sum16 csum_ipv6_magic(const struct in6_addr *saddr,
> -                               const struct in6_addr *daddr,
> -                               __u32 len, unsigned short proto,
> -                               __wsum sum)
> -{
> -       __asm__ __volatile__(
> -               ".set\tnoreorder\t\t\t# csum_ipv6_magic\n\t"
> -               ".set\tnoat\n\t"
> -               "addu\t%0, %5\t\t\t# proto (long in network byte order)\n\t"
> -               "sltu\t$1, %0, %5\n\t"
> -               "addu\t%0, $1\n\t"
> -               "addu\t%0, %6\t\t\t# csum\n\t"
> -               "sltu\t$1, %0, %6\n\t"
> -               "lw\t%1, 0(%2)\t\t\t# four words source address\n\t"
> -               "addu\t%0, $1\n\t"
> -               "addu\t%0, %1\n\t"
> -               "sltu\t$1, %0, %1\n\t"
> -               "lw\t%1, 4(%2)\n\t"
> -               "addu\t%0, $1\n\t"
> -               "addu\t%0, %1\n\t"
> -               "sltu\t$1, %0, %1\n\t"
> -               "lw\t%1, 8(%2)\n\t"
> -               "addu\t%0, $1\n\t"
> -               "addu\t%0, %1\n\t"
> -               "sltu\t$1, %0, %1\n\t"
> -               "lw\t%1, 12(%2)\n\t"
> -               "addu\t%0, $1\n\t"
> -               "addu\t%0, %1\n\t"
> -               "sltu\t$1, %0, %1\n\t"
> -               "lw\t%1, 0(%3)\n\t"
> -               "addu\t%0, $1\n\t"
> -               "addu\t%0, %1\n\t"
> -               "sltu\t$1, %0, %1\n\t"
> -               "lw\t%1, 4(%3)\n\t"
> -               "addu\t%0, $1\n\t"
> -               "addu\t%0, %1\n\t"
> -               "sltu\t$1, %0, %1\n\t"
> -               "lw\t%1, 8(%3)\n\t"
> -               "addu\t%0, $1\n\t"
> -               "addu\t%0, %1\n\t"
> -               "sltu\t$1, %0, %1\n\t"
> -               "lw\t%1, 12(%3)\n\t"
> -               "addu\t%0, $1\n\t"
> -               "addu\t%0, %1\n\t"
> -               "sltu\t$1, %0, %1\n\t"
> -               "addu\t%0, $1\t\t\t# Add final carry\n\t"
> -               ".set\tnoat\n\t"
> -               ".set\tnoreorder"
> -               : "=r" (sum), "=r" (proto)
> -               : "r" (saddr), "r" (daddr),
> -                 "0" (htonl(len)), "1" (htonl(proto)), "r" (sum));
> -
> -       return csum_fold(sum);
> -}
> -#endif /* _ASM_SCORE_CHECKSUM_H */
> diff --git a/arch/score/include/asm/cmpxchg.h b/arch/score/include/asm/cmpxchg.h
> deleted file mode 100644
> index f384839..0000000
> --- a/arch/score/include/asm/cmpxchg.h
> +++ /dev/null
> @@ -1,49 +0,0 @@
> -#ifndef _ASM_SCORE_CMPXCHG_H
> -#define _ASM_SCORE_CMPXCHG_H
> -
> -#include <linux/irqflags.h>
> -
> -struct __xchg_dummy { unsigned long a[100]; };
> -#define __xg(x) ((struct __xchg_dummy *)(x))
> -
> -static inline
> -unsigned long __xchg(volatile unsigned long *m, unsigned long val)
> -{
> -       unsigned long retval;
> -       unsigned long flags;
> -
> -       local_irq_save(flags);
> -       retval = *m;
> -       *m = val;
> -       local_irq_restore(flags);
> -       return retval;
> -}
> -
> -#define xchg(ptr, v)                                           \
> -       ((__typeof__(*(ptr))) __xchg((unsigned long *)(ptr),    \
> -                                       (unsigned long)(v)))
> -
> -static inline unsigned long __cmpxchg(volatile unsigned long *m,
> -                               unsigned long old, unsigned long new)
> -{
> -       unsigned long retval;
> -       unsigned long flags;
> -
> -       local_irq_save(flags);
> -       retval = *m;
> -       if (retval == old)
> -               *m = new;
> -       local_irq_restore(flags);
> -       return retval;
> -}
> -
> -#define cmpxchg(ptr, o, n)                                     \
> -       ((__typeof__(*(ptr))) __cmpxchg((unsigned long *)(ptr), \
> -                                       (unsigned long)(o),     \
> -                                       (unsigned long)(n)))
> -
> -#define __HAVE_ARCH_CMPXCHG    1
> -
> -#include <asm-generic/cmpxchg-local.h>
> -
> -#endif /* _ASM_SCORE_CMPXCHG_H */
> diff --git a/arch/score/include/asm/cputime.h b/arch/score/include/asm/cputime.h
> deleted file mode 100644
> index 1fced99..0000000
> --- a/arch/score/include/asm/cputime.h
> +++ /dev/null
> @@ -1,6 +0,0 @@
> -#ifndef _ASM_SCORE_CPUTIME_H
> -#define _ASM_SCORE_CPUTIME_H
> -
> -#include <asm-generic/cputime.h>
> -
> -#endif /* _ASM_SCORE_CPUTIME_H */
> diff --git a/arch/score/include/asm/current.h b/arch/score/include/asm/current.h
> deleted file mode 100644
> index 16eae9c..0000000
> --- a/arch/score/include/asm/current.h
> +++ /dev/null
> @@ -1,6 +0,0 @@
> -#ifndef _ASM_SCORE_CURRENT_H
> -#define _ASM_SCORE_CURRENT_H
> -
> -#include <asm-generic/current.h>
> -
> -#endif /* _ASM_SCORE_CURRENT_H */
> diff --git a/arch/score/include/asm/delay.h b/arch/score/include/asm/delay.h
> deleted file mode 100644
> index 529e494..0000000
> --- a/arch/score/include/asm/delay.h
> +++ /dev/null
> @@ -1,28 +0,0 @@
> -#ifndef _ASM_SCORE_DELAY_H
> -#define _ASM_SCORE_DELAY_H
> -
> -#include <asm-generic/param.h>
> -
> -static inline void __delay(unsigned long loops)
> -{
> -       /* 3 cycles per loop. */
> -       __asm__ __volatile__ (
> -               "1:\tsubi\t%0, 3\n\t"
> -               "cmpz.c\t%0\n\t"
> -               "ble\t1b\n\t"
> -               : "=r" (loops)
> -               : "0" (loops));
> -}
> -
> -static inline void __udelay(unsigned long usecs)
> -{
> -       unsigned long loops_per_usec;
> -
> -       loops_per_usec = (loops_per_jiffy * HZ) / 1000000;
> -
> -       __delay(usecs * loops_per_usec);
> -}
> -
> -#define udelay(usecs) __udelay(usecs)
> -
> -#endif /* _ASM_SCORE_DELAY_H */
> diff --git a/arch/score/include/asm/device.h b/arch/score/include/asm/device.h
> deleted file mode 100644
> index 2dc7cc5..0000000
> --- a/arch/score/include/asm/device.h
> +++ /dev/null
> @@ -1,6 +0,0 @@
> -#ifndef _ASM_SCORE_DEVICE_H
> -#define _ASM_SCORE_DEVICE_H
> -
> -#include <asm-generic/device.h>
> -
> -#endif /* _ASM_SCORE_DEVICE_H */
> diff --git a/arch/score/include/asm/div64.h b/arch/score/include/asm/div64.h
> deleted file mode 100644
> index 75fae19..0000000
> --- a/arch/score/include/asm/div64.h
> +++ /dev/null
> @@ -1,6 +0,0 @@
> -#ifndef _ASM_SCORE_DIV64_H
> -#define _ASM_SCORE_DIV64_H
> -
> -#include <asm-generic/div64.h>
> -
> -#endif /* _ASM_SCORE_DIV64_H */
> diff --git a/arch/score/include/asm/dma.h b/arch/score/include/asm/dma.h
> deleted file mode 100644
> index 9f44185..0000000
> --- a/arch/score/include/asm/dma.h
> +++ /dev/null
> @@ -1,8 +0,0 @@
> -#ifndef _ASM_SCORE_DMA_H
> -#define _ASM_SCORE_DMA_H
> -
> -#include <asm/io.h>
> -
> -#define MAX_DMA_ADDRESS                (0)
> -
> -#endif /* _ASM_SCORE_DMA_H */
> diff --git a/arch/score/include/asm/elf.h b/arch/score/include/asm/elf.h
> deleted file mode 100644
> index 6a9421c..0000000
> --- a/arch/score/include/asm/elf.h
> +++ /dev/null
> @@ -1,97 +0,0 @@
> -#ifndef _ASM_SCORE_ELF_H
> -#define _ASM_SCORE_ELF_H
> -
> -#include <linux/ptrace.h>
> -
> -#define EM_SCORE7      135
> -
> -/* Relocation types. */
> -#define R_SCORE_NONE           0
> -#define R_SCORE_HI16           1
> -#define R_SCORE_LO16           2
> -#define R_SCORE_BCMP           3
> -#define R_SCORE_24             4
> -#define R_SCORE_PC19           5
> -#define R_SCORE16_11           6
> -#define R_SCORE16_PC8          7
> -#define R_SCORE_ABS32          8
> -#define R_SCORE_ABS16          9
> -#define R_SCORE_DUMMY2         10
> -#define R_SCORE_GP15           11
> -#define R_SCORE_GNU_VTINHERIT  12
> -#define R_SCORE_GNU_VTENTRY    13
> -#define R_SCORE_GOT15          14
> -#define R_SCORE_GOT_LO16       15
> -#define R_SCORE_CALL15         16
> -#define R_SCORE_GPREL32                17
> -#define R_SCORE_REL32          18
> -#define R_SCORE_DUMMY_HI16     19
> -#define R_SCORE_IMM30          20
> -#define R_SCORE_IMM32          21
> -
> -/* ELF register definitions */
> -typedef unsigned long  elf_greg_t;
> -
> -#define ELF_NGREG      (sizeof(struct pt_regs) / sizeof(elf_greg_t))
> -typedef elf_greg_t     elf_gregset_t[ELF_NGREG];
> -
> -/* Score does not have fp regs. */
> -typedef double         elf_fpreg_t;
> -typedef elf_fpreg_t    elf_fpregset_t;
> -
> -#define elf_check_arch(x)      ((x)->e_machine == EM_SCORE7)
> -
> -/*
> - * These are used to set parameters in the core dumps.
> - */
> -#define ELF_CLASS      ELFCLASS32
> -
> -/*
> - * These are used to set parameters in the core dumps.
> - */
> -#define ELF_DATA       ELFDATA2LSB
> -#define ELF_ARCH       EM_SCORE7
> -
> -struct task_struct;
> -struct pt_regs;
> -
> -#define CORE_DUMP_USE_REGSET
> -#define ELF_EXEC_PAGESIZE      PAGE_SIZE
> -
> -/* This yields a mask that user programs can use to figure out what
> -   instruction set this cpu supports.  This could be done in userspace,
> -   but it's not easy, and we've already done it here.  */
> -
> -#define ELF_HWCAP      (0)
> -
> -/* This yields a string that ld.so will use to load implementation
> -   specific libraries for optimization.  This is more specific in
> -   intent than poking at uname or /proc/cpuinfo.
> -
> -   For the moment, we have only optimizations for the Intel generations,
> -   but that could change... */
> -
> -#define ELF_PLATFORM   (NULL)
> -
> -#define ELF_PLAT_INIT(_r, load_addr)                                   \
> -do {                                                                   \
> -       _r->regs[1] = _r->regs[2] = _r->regs[3] = _r->regs[4] = 0;      \
> -       _r->regs[5] = _r->regs[6] = _r->regs[7] = _r->regs[8] = 0;      \
> -       _r->regs[9] = _r->regs[10] = _r->regs[11] = _r->regs[12] = 0;   \
> -       _r->regs[13] = _r->regs[14] = _r->regs[15] = _r->regs[16] = 0;  \
> -       _r->regs[17] = _r->regs[18] = _r->regs[19] = _r->regs[20] = 0;  \
> -       _r->regs[21] = _r->regs[22] = _r->regs[23] = _r->regs[24] = 0;  \
> -       _r->regs[25] = _r->regs[26] = _r->regs[27] = _r->regs[28] = 0;  \
> -       _r->regs[30] = _r->regs[31] = 0;                                \
> -} while (0)
> -
> -/* This is the location that an ET_DYN program is loaded if exec'ed.  Typical
> -   use of this is to invoke "./ld.so someprog" to test out a new version of
> -   the loader.  We need to make sure that it is out of the way of the program
> -   that it will "exec", and that there is sufficient room for the brk.  */
> -
> -#ifndef ELF_ET_DYN_BASE
> -#define ELF_ET_DYN_BASE                (TASK_SIZE / 3 * 2)
> -#endif
> -
> -#endif /* _ASM_SCORE_ELF_H */
> diff --git a/arch/score/include/asm/emergency-restart.h b/arch/score/include/asm/emergency-restart.h
> deleted file mode 100644
> index ca31e98..0000000
> --- a/arch/score/include/asm/emergency-restart.h
> +++ /dev/null
> @@ -1,6 +0,0 @@
> -#ifndef _ASM_SCORE_EMERGENCY_RESTART_H
> -#define _ASM_SCORE_EMERGENCY_RESTART_H
> -
> -#include <asm-generic/emergency-restart.h>
> -
> -#endif /* _ASM_SCORE_EMERGENCY_RESTART_H */
> diff --git a/arch/score/include/asm/exec.h b/arch/score/include/asm/exec.h
> deleted file mode 100644
> index f9f3cd5..0000000
> --- a/arch/score/include/asm/exec.h
> +++ /dev/null
> @@ -1,6 +0,0 @@
> -#ifndef _ASM_SCORE_EXEC_H
> -#define _ASM_SCORE_EXEC_H
> -
> -extern unsigned long arch_align_stack(unsigned long sp);
> -
> -#endif /* _ASM_SCORE_EXEC_H */
> diff --git a/arch/score/include/asm/fixmap.h b/arch/score/include/asm/fixmap.h
> deleted file mode 100644
> index ee16766..0000000
> --- a/arch/score/include/asm/fixmap.h
> +++ /dev/null
> @@ -1,82 +0,0 @@
> -#ifndef _ASM_SCORE_FIXMAP_H
> -#define _ASM_SCORE_FIXMAP_H
> -
> -#include <asm/page.h>
> -
> -#define PHY_RAM_BASE           0x00000000
> -#define PHY_IO_BASE            0x10000000
> -
> -#define VIRTUAL_RAM_BASE       0xa0000000
> -#define VIRTUAL_IO_BASE                0xb0000000
> -
> -#define RAM_SPACE_SIZE         0x10000000
> -#define IO_SPACE_SIZE          0x10000000
> -
> -/* Kernel unmapped, cached 512MB */
> -#define KSEG1                  0xa0000000
> -
> -/*
> - * Here we define all the compile-time 'special' virtual
> - * addresses. The point is to have a constant address at
> - * compile time, but to set the physical address only
> - * in the boot process. We allocate these special addresses
> - * from the end of virtual memory (0xfffff000) backwards.
> - * Also this lets us do fail-safe vmalloc(), we
> - * can guarantee that these special addresses and
> - * vmalloc()-ed addresses never overlap.
> - *
> - * these 'compile-time allocated' memory buffers are
> - * fixed-size 4k pages. (or larger if used with an increment
> - * highger than 1) use fixmap_set(idx,phys) to associate
> - * physical memory with fixmap indices.
> - *
> - * TLB entries of such buffers will not be flushed across
> - * task switches.
> - */
> -
> -/*
> - * on UP currently we will have no trace of the fixmap mechanizm,
> - * no page table allocations, etc. This might change in the
> - * future, say framebuffers for the console driver(s) could be
> - * fix-mapped?
> - */
> -enum fixed_addresses {
> -#define FIX_N_COLOURS 8
> -       FIX_CMAP_BEGIN,
> -       FIX_CMAP_END = FIX_CMAP_BEGIN + FIX_N_COLOURS,
> -       __end_of_fixed_addresses
> -};
> -
> -/*
> - * used by vmalloc.c.
> - *
> - * Leave one empty page between vmalloc'ed areas and
> - * the start of the fixmap, and leave one page empty
> - * at the top of mem..
> - */
> -#define FIXADDR_TOP    ((unsigned long)(long)(int)0xfefe0000)
> -#define FIXADDR_SIZE   (__end_of_fixed_addresses << PAGE_SHIFT)
> -#define FIXADDR_START  (FIXADDR_TOP - FIXADDR_SIZE)
> -
> -#define __fix_to_virt(x)       (FIXADDR_TOP - ((x) << PAGE_SHIFT))
> -#define __virt_to_fix(x)       \
> -       ((FIXADDR_TOP - ((x) & PAGE_MASK)) >> PAGE_SHIFT)
> -
> -extern void __this_fixmap_does_not_exist(void);
> -
> -/*
> - * 'index to address' translation. If anyone tries to use the idx
> - * directly without tranlation, we catch the bug with a NULL-deference
> - * kernel oops. Illegal ranges of incoming indices are caught too.
> - */
> -static inline unsigned long fix_to_virt(const unsigned int idx)
> -{
> -       return __fix_to_virt(idx);
> -}
> -
> -static inline unsigned long virt_to_fix(const unsigned long vaddr)
> -{
> -       return __virt_to_fix(vaddr);
> -}
> -
> -#endif /* _ASM_SCORE_FIXMAP_H */
> diff --git a/arch/score/include/asm/ftrace.h b/arch/score/include/asm/ftrace.h
> deleted file mode 100644
> index 79d6f10..0000000
> --- a/arch/score/include/asm/ftrace.h
> +++ /dev/null
> @@ -1,4 +0,0 @@
> -#ifndef _ASM_SCORE_FTRACE_H
> -#define _ASM_SCORE_FTRACE_H
> -
> -#endif /* _ASM_SCORE_FTRACE_H */
> diff --git a/arch/score/include/asm/futex.h b/arch/score/include/asm/futex.h
> deleted file mode 100644
> index 1dca242..0000000
> --- a/arch/score/include/asm/futex.h
> +++ /dev/null
> @@ -1,6 +0,0 @@
> -#ifndef _ASM_SCORE_FUTEX_H
> -#define _ASM_SCORE_FUTEX_H
> -
> -#include <asm-generic/futex.h>
> -
> -#endif /* _ASM_SCORE_FUTEX_H */
> diff --git a/arch/score/include/asm/hardirq.h b/arch/score/include/asm/hardirq.h
> deleted file mode 100644
> index dc932c5..0000000
> --- a/arch/score/include/asm/hardirq.h
> +++ /dev/null
> @@ -1,6 +0,0 @@
> -#ifndef _ASM_SCORE_HARDIRQ_H
> -#define _ASM_SCORE_HARDIRQ_H
> -
> -#include <asm-generic/hardirq.h>
> -
> -#endif /* _ASM_SCORE_HARDIRQ_H */
> diff --git a/arch/score/include/asm/hw_irq.h b/arch/score/include/asm/hw_irq.h
> deleted file mode 100644
> index 4caafb2..0000000
> --- a/arch/score/include/asm/hw_irq.h
> +++ /dev/null
> @@ -1,4 +0,0 @@
> -#ifndef _ASM_SCORE_HW_IRQ_H
> -#define _ASM_SCORE_HW_IRQ_H
> -
> -#endif /* _ASM_SCORE_HW_IRQ_H */
> diff --git a/arch/score/include/asm/io.h b/arch/score/include/asm/io.h
> deleted file mode 100644
> index fbbfd71..0000000
> --- a/arch/score/include/asm/io.h
> +++ /dev/null
> @@ -1,9 +0,0 @@
> -#ifndef _ASM_SCORE_IO_H
> -#define _ASM_SCORE_IO_H
> -
> -#include <asm-generic/io.h>
> -
> -#define virt_to_bus    virt_to_phys
> -#define bus_to_virt    phys_to_virt
> -
> -#endif /* _ASM_SCORE_IO_H */
> diff --git a/arch/score/include/asm/irq.h b/arch/score/include/asm/irq.h
> deleted file mode 100644
> index c883f3d..0000000
> --- a/arch/score/include/asm/irq.h
> +++ /dev/null
> @@ -1,25 +0,0 @@
> -#ifndef _ASM_SCORE_IRQ_H
> -#define _ASM_SCORE_IRQ_H
> -
> -#define EXCEPTION_VECTOR_BASE_ADDR     0xa0000000
> -#define VECTOR_ADDRESS_OFFSET_MODE4    0
> -#define VECTOR_ADDRESS_OFFSET_MODE16   1
> -
> -#define DEBUG_VECTOR_SIZE              (0x4)
> -#define DEBUG_VECTOR_BASE_ADDR         ((EXCEPTION_VECTOR_BASE_ADDR) + 0x1fc)
> -
> -#define GENERAL_VECTOR_SIZE            (0x10)
> -#define GENERAL_VECTOR_BASE_ADDR       ((EXCEPTION_VECTOR_BASE_ADDR) + 0x200)
> -
> -#define NR_IRQS                                64
> -#define IRQ_VECTOR_SIZE                        (0x10)
> -#define IRQ_VECTOR_BASE_ADDR           ((EXCEPTION_VECTOR_BASE_ADDR) + 0x210)
> -#define IRQ_VECTOR_END_ADDR            ((EXCEPTION_VECTOR_BASE_ADDR) + 0x5f0)
> -
> -#define irq_canonicalize(irq)  (irq)
> -
> -#define IRQ_TIMER (7)          /* Timer IRQ number of SPCT6600 */
> -
> -extern void interrupt_exception_vector(void);
> -
> -#endif /* _ASM_SCORE_IRQ_H */
> diff --git a/arch/score/include/asm/irq_regs.h b/arch/score/include/asm/irq_regs.h
> deleted file mode 100644
> index b8e881c..0000000
> --- a/arch/score/include/asm/irq_regs.h
> +++ /dev/null
> @@ -1,11 +0,0 @@
> -#ifndef _ASM_SCORE_IRQ_REGS_H
> -#define _ASM_SCORE_IRQ_REGS_H
> -
> -#include <linux/thread_info.h>
> -
> -static inline struct pt_regs *get_irq_regs(void)
> -{
> -       return current_thread_info()->regs;
> -}
> -
> -#endif /* _ASM_SCORE_IRQ_REGS_H */
> diff --git a/arch/score/include/asm/irqflags.h b/arch/score/include/asm/irqflags.h
> deleted file mode 100644
> index 37c6ac9..0000000
> --- a/arch/score/include/asm/irqflags.h
> +++ /dev/null
> @@ -1,120 +0,0 @@
> -#ifndef _ASM_SCORE_IRQFLAGS_H
> -#define _ASM_SCORE_IRQFLAGS_H
> -
> -#ifndef __ASSEMBLY__
> -
> -#include <linux/types.h>
> -
> -static inline unsigned long arch_local_save_flags(void)
> -{
> -       unsigned long flags;
> -
> -       asm volatile(
> -               "       mfcr    r8, cr0         \n"
> -               "       nop                     \n"
> -               "       nop                     \n"
> -               "       mv      %0, r8          \n"
> -               "       nop                     \n"
> -               "       nop                     \n"
> -               "       nop                     \n"
> -               "       nop                     \n"
> -               "       nop                     \n"
> -               "       ldi     r9, 0x1         \n"
> -               "       and     %0, %0, r9      \n"
> -               : "=r" (flags)
> -               :
> -               : "r8", "r9");
> -       return flags;
> -}
> -
> -static inline unsigned long arch_local_irq_save(void)
> -{
> -       unsigned long flags;
> -
> -       asm volatile(
> -               "       mfcr    r8, cr0         \n"
> -               "       li      r9, 0xfffffffe  \n"
> -               "       nop                     \n"
> -               "       mv      %0, r8          \n"
> -               "       and     r8, r8, r9      \n"
> -               "       mtcr    r8, cr0         \n"
> -               "       nop                     \n"
> -               "       nop                     \n"
> -               "       nop                     \n"
> -               "       nop                     \n"
> -               "       nop                     \n"
> -               : "=r" (flags)
> -               :
> -               : "r8", "r9", "memory");
> -
> -       return flags;
> -}
> -
> -static inline void arch_local_irq_restore(unsigned long flags)
> -{
> -       asm volatile(
> -               "       mfcr    r8, cr0         \n"
> -               "       ldi     r9, 0x1         \n"
> -               "       and     %0, %0, r9      \n"
> -               "       or      r8, r8, %0      \n"
> -               "       mtcr    r8, cr0         \n"
> -               "       nop                     \n"
> -               "       nop                     \n"
> -               "       nop                     \n"
> -               "       nop                     \n"
> -               "       nop                     \n"
> -               :
> -               : "r"(flags)
> -               : "r8", "r9", "memory");
> -}
> -
> -static inline void arch_local_irq_enable(void)
> -{
> -       asm volatile(
> -               "       mfcr    r8,cr0          \n"
> -               "       nop                     \n"
> -               "       nop                     \n"
> -               "       ori     r8,0x1          \n"
> -               "       mtcr    r8,cr0          \n"
> -               "       nop                     \n"
> -               "       nop                     \n"
> -               "       nop                     \n"
> -               "       nop                     \n"
> -               "       nop                     \n"
> -               :
> -               :
> -               : "r8", "memory");
> -}
> -
> -static inline void arch_local_irq_disable(void)
> -{
> -       asm volatile(
> -               "       mfcr    r8,cr0          \n"
> -               "       nop                     \n"
> -               "       nop                     \n"
> -               "       srli    r8,r8,1         \n"
> -               "       slli    r8,r8,1         \n"
> -               "       mtcr    r8,cr0          \n"
> -               "       nop                     \n"
> -               "       nop                     \n"
> -               "       nop                     \n"
> -               "       nop                     \n"
> -               "       nop                     \n"
> -               :
> -               :
> -               : "r8", "memory");
> -}
> -
> -static inline bool arch_irqs_disabled_flags(unsigned long flags)
> -{
> -       return !(flags & 1);
> -}
> -
> -static inline bool arch_irqs_disabled(void)
> -{
> -       return arch_irqs_disabled_flags(arch_local_save_flags());
> -}
> -
> -#endif /* __ASSEMBLY__ */
> -
> -#endif /* _ASM_SCORE_IRQFLAGS_H */
> diff --git a/arch/score/include/asm/kdebug.h b/arch/score/include/asm/kdebug.h
> deleted file mode 100644
> index a666e51..0000000
> --- a/arch/score/include/asm/kdebug.h
> +++ /dev/null
> @@ -1,6 +0,0 @@
> -#ifndef _ASM_SCORE_KDEBUG_H
> -#define _ASM_SCORE_KDEBUG_H
> -
> -#include <asm-generic/kdebug.h>
> -
> -#endif /* _ASM_SCORE_KDEBUG_H */
> diff --git a/arch/score/include/asm/kmap_types.h b/arch/score/include/asm/kmap_types.h
> deleted file mode 100644
> index 6c46eb5..0000000
> --- a/arch/score/include/asm/kmap_types.h
> +++ /dev/null
> @@ -1,6 +0,0 @@
> -#ifndef _ASM_SCORE_KMAP_TYPES_H
> -#define _ASM_SCORE_KMAP_TYPES_H
> -
> -#include <asm-generic/kmap_types.h>
> -
> -#endif /* _ASM_SCORE_KMAP_TYPES_H */
> diff --git a/arch/score/include/asm/linkage.h b/arch/score/include/asm/linkage.h
> deleted file mode 100644
> index 2323a8e..0000000
> --- a/arch/score/include/asm/linkage.h
> +++ /dev/null
> @@ -1,7 +0,0 @@
> -#ifndef _ASM_SCORE_LINKAGE_H
> -#define _ASM_SCORE_LINKAGE_H
> -
> -#define __ALIGN .align 2
> -#define __ALIGN_STR ".align 2"
> -
> -#endif /* _ASM_SCORE_LINKAGE_H */
> diff --git a/arch/score/include/asm/local.h b/arch/score/include/asm/local.h
> deleted file mode 100644
> index 7e02f13..0000000
> --- a/arch/score/include/asm/local.h
> +++ /dev/null
> @@ -1,6 +0,0 @@
> -#ifndef _ASM_SCORE_LOCAL_H
> -#define _ASM_SCORE_LOCAL_H
> -
> -#include <asm-generic/local.h>
> -
> -#endif /* _ASM_SCORE_LOCAL_H */
> diff --git a/arch/score/include/asm/local64.h b/arch/score/include/asm/local64.h
> deleted file mode 100644
> index 36c93b5..0000000
> --- a/arch/score/include/asm/local64.h
> +++ /dev/null
> @@ -1 +0,0 @@
> -#include <asm-generic/local64.h>
> diff --git a/arch/score/include/asm/mmu.h b/arch/score/include/asm/mmu.h
> deleted file mode 100644
> index 676828e..0000000
> --- a/arch/score/include/asm/mmu.h
> +++ /dev/null
> @@ -1,6 +0,0 @@
> -#ifndef _ASM_SCORE_MMU_H
> -#define _ASM_SCORE_MMU_H
> -
> -typedef unsigned long mm_context_t;
> -
> -#endif /* _ASM_SCORE_MMU_H */
> diff --git a/arch/score/include/asm/mmu_context.h b/arch/score/include/asm/mmu_context.h
> deleted file mode 100644
> index 2644577..0000000
> --- a/arch/score/include/asm/mmu_context.h
> +++ /dev/null
> @@ -1,113 +0,0 @@
> -#ifndef _ASM_SCORE_MMU_CONTEXT_H
> -#define _ASM_SCORE_MMU_CONTEXT_H
> -
> -#include <linux/errno.h>
> -#include <linux/sched.h>
> -#include <linux/slab.h>
> -#include <asm-generic/mm_hooks.h>
> -
> -#include <asm/cacheflush.h>
> -#include <asm/tlbflush.h>
> -#include <asm/scoreregs.h>
> -
> -/*
> - * For the fast tlb miss handlers, we keep a per cpu array of pointers
> - * to the current pgd for each processor. Also, the proc. id is stuffed
> - * into the context register.
> - */
> -extern unsigned long asid_cache;
> -extern unsigned long pgd_current;
> -
> -#define TLBMISS_HANDLER_SETUP_PGD(pgd) (pgd_current = (unsigned long)(pgd))
> -
> -#define TLBMISS_HANDLER_SETUP()                                \
> -do {                                                   \
> -       write_c0_context(0);                            \
> -       TLBMISS_HANDLER_SETUP_PGD(swapper_pg_dir)       \
> -} while (0)
> -
> -/*
> - * All unused by hardware upper bits will be considered
> - * as a software asid extension.
> - */
> -#define ASID_VERSION_MASK      0xfffff000
> -#define ASID_FIRST_VERSION     0x1000
> -
> -/* PEVN    --------- VPN ---------- --ASID--- -NA- */
> -/* binary: 0000 0000 0000 0000 0000 0000 0001 0000 */
> -/* binary: 0000 0000 0000 0000 0000 1111 1111 0000 */
> -#define ASID_INC       0x10
> -#define ASID_MASK      0xff0
> -
> -static inline void enter_lazy_tlb(struct mm_struct *mm,
> -                               struct task_struct *tsk)
> -{}
> -
> -static inline void
> -get_new_mmu_context(struct mm_struct *mm)
> -{
> -       unsigned long asid = asid_cache + ASID_INC;
> -
> -       if (!(asid & ASID_MASK)) {
> -               local_flush_tlb_all();          /* start new asid cycle */
> -               if (!asid)                      /* fix version if needed */
> -                       asid = ASID_FIRST_VERSION;
> -       }
> -
> -       mm->context = asid;
> -       asid_cache = asid;
> -}
> -
> -/*
> - * Initialize the context related info for a new mm_struct
> - * instance.
> - */
> -static inline int
> -init_new_context(struct task_struct *tsk, struct mm_struct *mm)
> -{
> -       mm->context = 0;
> -       return 0;
> -}
> -
> -static inline void switch_mm(struct mm_struct *prev, struct mm_struct *next,
> -                       struct task_struct *tsk)
> -{
> -       unsigned long flags;
> -
> -       local_irq_save(flags);
> -       if ((next->context ^ asid_cache) & ASID_VERSION_MASK)
> -               get_new_mmu_context(next);
> -
> -       pevn_set(next->context);
> -       TLBMISS_HANDLER_SETUP_PGD(next->pgd);
> -       local_irq_restore(flags);
> -}
> -
> -/*
> - * Destroy context related info for an mm_struct that is about
> - * to be put to rest.
> - */
> -static inline void destroy_context(struct mm_struct *mm)
> -{}
> -
> -static inline void
> -deactivate_mm(struct task_struct *task, struct mm_struct *mm)
> -{}
> -
> -/*
> - * After we have set current->mm to a new value, this activates
> - * the context for the new mm so we see the new mappings.
> - */
> -static inline void
> -activate_mm(struct mm_struct *prev, struct mm_struct *next)
> -{
> -       unsigned long flags;
> -
> -       local_irq_save(flags);
> -       get_new_mmu_context(next);
> -       pevn_set(next->context);
> -       TLBMISS_HANDLER_SETUP_PGD(next->pgd);
> -       local_irq_restore(flags);
> -}
> -
> -#endif /* _ASM_SCORE_MMU_CONTEXT_H */
> diff --git a/arch/score/include/asm/module.h b/arch/score/include/asm/module.h
> deleted file mode 100644
> index abf395b..0000000
> --- a/arch/score/include/asm/module.h
> +++ /dev/null
> @@ -1,35 +0,0 @@
> -#ifndef _ASM_SCORE_MODULE_H
> -#define _ASM_SCORE_MODULE_H
> -
> -#include <linux/list.h>
> -#include <asm/uaccess.h>
> -#include <asm-generic/module.h>
> -
> -struct mod_arch_specific {
> -       /* Data Bus Error exception tables */
> -       struct list_head dbe_list;
> -       const struct exception_table_entry *dbe_start;
> -       const struct exception_table_entry *dbe_end;
> -};
> -
> -typedef uint8_t Elf64_Byte;            /* Type for a 8-bit quantity. */
> -
> -/* Given an address, look for it in the exception tables. */
> -#ifdef CONFIG_MODULES
> -const struct exception_table_entry *search_module_dbetables(unsigned long addr);
> -#else
> -static inline const struct exception_table_entry
> -*search_module_dbetables(unsigned long addr)
> -{
> -       return NULL;
> -}
> -#endif
> -
> -#define MODULE_PROC_FAMILY "SCORE7"
> -#define MODULE_KERNEL_TYPE "32BIT "
> -#define MODULE_KERNEL_SMTC ""
> -
> -#define MODULE_ARCH_VERMAGIC \
> -       MODULE_PROC_FAMILY MODULE_KERNEL_TYPE MODULE_KERNEL_SMTC
> -
> -#endif /* _ASM_SCORE_MODULE_H */
> diff --git a/arch/score/include/asm/mutex.h b/arch/score/include/asm/mutex.h
> deleted file mode 100644
> index 10d48fe..0000000
> --- a/arch/score/include/asm/mutex.h
> +++ /dev/null
> @@ -1,6 +0,0 @@
> -#ifndef _ASM_SCORE_MUTEX_H
> -#define _ASM_SCORE_MUTEX_H
> -
> -#include <asm-generic/mutex-dec.h>
> -
> -#endif /* _ASM_SCORE_MUTEX_H */
> diff --git a/arch/score/include/asm/page.h b/arch/score/include/asm/page.h
> deleted file mode 100644
> index 1e9ade8..0000000
> --- a/arch/score/include/asm/page.h
> +++ /dev/null
> @@ -1,93 +0,0 @@
> -#ifndef _ASM_SCORE_PAGE_H
> -#define _ASM_SCORE_PAGE_H
> -
> -#include <linux/pfn.h>
> -#include <linux/const.h>
> -
> -/* PAGE_SHIFT determines the page size */
> -#define PAGE_SHIFT     (12)
> -#define PAGE_SIZE      (_AC(1,UL) << PAGE_SHIFT)
> -#define PAGE_MASK      (~(PAGE_SIZE-1))
> -
> -#ifdef __KERNEL__
> -
> -#ifndef __ASSEMBLY__
> -
> -#define PAGE_UP(addr)  (((addr)+((PAGE_SIZE)-1))&(~((PAGE_SIZE)-1)))
> -#define PAGE_DOWN(addr)        ((addr)&(~((PAGE_SIZE)-1)))
> -
> -/* align addr on a size boundary - adjust address up/down if needed */
> -#define _ALIGN_UP(addr, size)  (((addr)+((size)-1))&(~((size)-1)))
> -#define _ALIGN_DOWN(addr, size)        ((addr)&(~((size)-1)))
> -
> -/* align addr on a size boundary - adjust address up if needed */
> -#define _ALIGN(addr, size)     _ALIGN_UP(addr, size)
> -
> -/*
> - * PAGE_OFFSET -- the first address of the first page of memory. When not
> - * using MMU this corresponds to the first free page in physical memory (aligned
> - * on a page boundary).
> - */
> -#define PAGE_OFFSET            (0xA0000000UL)
> -
> -#define clear_page(pgaddr)                     memset((pgaddr), 0, PAGE_SIZE)
> -#define copy_page(to, from)                    memcpy((to), (from), PAGE_SIZE)
> -
> -#define clear_user_page(pgaddr, vaddr, page)   memset((pgaddr), 0, PAGE_SIZE)
> -#define copy_user_page(vto, vfrom, vaddr, topg) \
> -                       memcpy((vto), (vfrom), PAGE_SIZE)
> -
> -/*
> - * These are used to make use of C type-checking..
> - */
> -
> -typedef struct { unsigned long pte; } pte_t;           /* page table entry */
> -typedef struct { unsigned long pgd; } pgd_t;           /* PGD table entry */
> -typedef struct { unsigned long pgprot; } pgprot_t;
> -typedef struct page *pgtable_t;
> -
> -#define pte_val(x)     ((x).pte)
> -#define pgd_val(x)     ((x).pgd)
> -#define pgprot_val(x)  ((x).pgprot)
> -
> -#define __pte(x)       ((pte_t) { (x) })
> -#define __pgd(x)       ((pgd_t) { (x) })
> -#define __pgprot(x)    ((pgprot_t) { (x) })
> -
> -extern unsigned long max_low_pfn;
> -extern unsigned long min_low_pfn;
> -extern unsigned long max_pfn;
> -
> -#define __pa(x)                ((unsigned long)(x) - PAGE_OFFSET)
> -#define __va(x)                ((void *)((unsigned long) (x) + PAGE_OFFSET))
> -
> -#define phys_to_pfn(phys)      (PFN_DOWN(phys))
> -#define pfn_to_phys(pfn)       (PFN_PHYS(pfn))
> -
> -#define virt_to_pfn(vaddr)     (phys_to_pfn((__pa(vaddr))))
> -#define pfn_to_virt(pfn)       __va(pfn_to_phys((pfn)))
> -
> -#define virt_to_page(vaddr)    (pfn_to_page(virt_to_pfn(vaddr)))
> -#define page_to_virt(page)     (pfn_to_virt(page_to_pfn(page)))
> -
> -#define page_to_phys(page)     (pfn_to_phys(page_to_pfn(page)))
> -#define page_to_bus(page)      (page_to_phys(page))
> -#define phys_to_page(paddr)    (pfn_to_page(phys_to_pfn(paddr)))
> -
> -#define pfn_valid(pfn)         (((pfn) >= min_low_pfn) && ((pfn) < max_low_pfn))
> -
> -#define ARCH_PFN_OFFSET                (PAGE_OFFSET >> PAGE_SHIFT)
> -
> -#endif /* __ASSEMBLY__ */
> -
> -#define virt_addr_valid(vaddr) (pfn_valid(virt_to_pfn(vaddr)))
> -
> -#endif /* __KERNEL__ */
> -
> -#define VM_DATA_DEFAULT_FLAGS  (VM_READ | VM_WRITE | VM_EXEC | \
> -                                VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC)
> -
> -#include <asm-generic/memory_model.h>
> -#include <asm-generic/getorder.h>
> -
> -#endif /* _ASM_SCORE_PAGE_H */
> diff --git a/arch/score/include/asm/pci.h b/arch/score/include/asm/pci.h
> deleted file mode 100644
> index 3f3cfd8..0000000
> --- a/arch/score/include/asm/pci.h
> +++ /dev/null
> @@ -1,4 +0,0 @@
> -#ifndef _ASM_SCORE_PCI_H
> -#define _ASM_SCORE_PCI_H
> -
> -#endif /* _ASM_SCORE_PCI_H */
> diff --git a/arch/score/include/asm/percpu.h b/arch/score/include/asm/percpu.h
> deleted file mode 100644
> index e7bd4e0..0000000
> --- a/arch/score/include/asm/percpu.h
> +++ /dev/null
> @@ -1,6 +0,0 @@
> -#ifndef _ASM_SCORE_PERCPU_H
> -#define _ASM_SCORE_PERCPU_H
> -
> -#include <asm-generic/percpu.h>
> -
> -#endif /* _ASM_SCORE_PERCPU_H */
> diff --git a/arch/score/include/asm/pgalloc.h b/arch/score/include/asm/pgalloc.h
> deleted file mode 100644
> index 059a61b..0000000
> --- a/arch/score/include/asm/pgalloc.h
> +++ /dev/null
> @@ -1,83 +0,0 @@
> -#ifndef _ASM_SCORE_PGALLOC_H
> -#define _ASM_SCORE_PGALLOC_H
> -
> -#include <linux/mm.h>
> -
> -static inline void pmd_populate_kernel(struct mm_struct *mm, pmd_t *pmd,
> -       pte_t *pte)
> -{
> -       set_pmd(pmd, __pmd((unsigned long)pte));
> -}
> -
> -static inline void pmd_populate(struct mm_struct *mm, pmd_t *pmd,
> -       pgtable_t pte)
> -{
> -       set_pmd(pmd, __pmd((unsigned long)page_address(pte)));
> -}
> -
> -#define pmd_pgtable(pmd)       pmd_page(pmd)
> -
> -static inline pgd_t *pgd_alloc(struct mm_struct *mm)
> -{
> -       pgd_t *ret, *init;
> -
> -       ret = (pgd_t *) __get_free_pages(GFP_KERNEL, PGD_ORDER);
> -       if (ret) {
> -               init = pgd_offset(&init_mm, 0UL);
> -               pgd_init((unsigned long)ret);
> -               memcpy(ret + USER_PTRS_PER_PGD, init + USER_PTRS_PER_PGD,
> -               (PTRS_PER_PGD - USER_PTRS_PER_PGD) * sizeof(pgd_t));
> -       }
> -
> -       return ret;
> -}
> -
> -static inline void pgd_free(struct mm_struct *mm, pgd_t *pgd)
> -{
> -       free_pages((unsigned long)pgd, PGD_ORDER);
> -}
> -
> -static inline pte_t *pte_alloc_one_kernel(struct mm_struct *mm,
> -       unsigned long address)
> -{
> -       pte_t *pte;
> -
> -       pte = (pte_t *) __get_free_pages(GFP_KERNEL|__GFP_REPEAT|__GFP_ZERO,
> -                                       PTE_ORDER);
> -
> -       return pte;
> -}
> -
> -static inline struct page *pte_alloc_one(struct mm_struct *mm,
> -       unsigned long address)
> -{
> -       struct page *pte;
> -
> -       pte = alloc_pages(GFP_KERNEL | __GFP_REPEAT, PTE_ORDER);
> -       if (pte) {
> -               clear_highpage(pte);
> -               pgtable_page_ctor(pte);
> -       }
> -       return pte;
> -}
> -
> -static inline void pte_free_kernel(struct mm_struct *mm, pte_t *pte)
> -{
> -       free_pages((unsigned long)pte, PTE_ORDER);
> -}
> -
> -static inline void pte_free(struct mm_struct *mm, pgtable_t pte)
> -{
> -       pgtable_page_dtor(pte);
> -       __free_pages(pte, PTE_ORDER);
> -}
> -
> -#define __pte_free_tlb(tlb, pte, buf)                  \
> -do {                                                   \
> -       pgtable_page_dtor(pte);                         \
> -       tlb_remove_page((tlb), pte);                    \
> -} while (0)
> -
> -#define check_pgt_cache()              do {} while (0)
> -
> -#endif /* _ASM_SCORE_PGALLOC_H */
> diff --git a/arch/score/include/asm/pgtable-bits.h b/arch/score/include/asm/pgtable-bits.h
> deleted file mode 100644
> index 7d65a96..0000000
> --- a/arch/score/include/asm/pgtable-bits.h
> +++ /dev/null
> @@ -1,25 +0,0 @@
> -#ifndef _ASM_SCORE_PGTABLE_BITS_H
> -#define _ASM_SCORE_PGTABLE_BITS_H
> -
> -#define _PAGE_ACCESSED                 (1<<5)  /* implemented in software */
> -#define _PAGE_READ                     (1<<6)  /* implemented in software */
> -#define _PAGE_WRITE                    (1<<7)  /* implemented in software */
> -#define _PAGE_PRESENT                  (1<<9)  /* implemented in software */
> -#define _PAGE_MODIFIED                 (1<<10) /* implemented in software */
> -#define _PAGE_FILE                     (1<<10)
> -
> -#define _PAGE_GLOBAL                   (1<<0)
> -#define _PAGE_VALID                    (1<<1)
> -#define _PAGE_SILENT_READ              (1<<1)  /* synonym */
> -#define _PAGE_DIRTY                    (1<<2)  /* Write bit */
> -#define _PAGE_SILENT_WRITE             (1<<2)
> -#define _PAGE_CACHE                    (1<<3)  /* cache */
> -#define _CACHE_MASK                    (1<<3)
> -#define _PAGE_BUFFERABLE               (1<<4)  /*Fallow Spec. */
> -
> -#define __READABLE     (_PAGE_READ | _PAGE_SILENT_READ | _PAGE_ACCESSED)
> -#define __WRITEABLE    (_PAGE_WRITE | _PAGE_SILENT_WRITE | _PAGE_MODIFIED)
> -#define _PAGE_CHG_MASK                 \
> -       (PAGE_MASK | _PAGE_ACCESSED | _PAGE_MODIFIED | _PAGE_CACHE)
> -
> -#endif /* _ASM_SCORE_PGTABLE_BITS_H */
> diff --git a/arch/score/include/asm/pgtable.h b/arch/score/include/asm/pgtable.h
> deleted file mode 100644
> index db96ad9..0000000
> --- a/arch/score/include/asm/pgtable.h
> +++ /dev/null
> @@ -1,282 +0,0 @@
> -#ifndef _ASM_SCORE_PGTABLE_H
> -#define _ASM_SCORE_PGTABLE_H
> -
> -#include <linux/const.h>
> -#include <asm-generic/pgtable-nopmd.h>
> -
> -#include <asm/fixmap.h>
> -#include <asm/setup.h>
> -#include <asm/pgtable-bits.h>
> -
> -extern void load_pgd(unsigned long pg_dir);
> -extern pte_t invalid_pte_table[PAGE_SIZE/sizeof(pte_t)];
> -
> -/* PGDIR_SHIFT determines what a third-level page table entry can map */
> -#define PGDIR_SHIFT    22
> -#define PGDIR_SIZE     (_AC(1, UL) << PGDIR_SHIFT)
> -#define PGDIR_MASK     (~(PGDIR_SIZE - 1))
> -
> -/*
> - * Entries per page directory level: we use two-level, so
> - * we don't really have any PUD/PMD directory physically.
> - */
> -#define PGD_ORDER      0
> -#define PTE_ORDER      0
> -
> -#define PTRS_PER_PGD   1024
> -#define PTRS_PER_PTE   1024
> -
> -#define USER_PTRS_PER_PGD      (0x80000000UL/PGDIR_SIZE)
> -#define FIRST_USER_ADDRESS     0
> -
> -#define VMALLOC_START          (0xc0000000UL)
> -
> -#define PKMAP_BASE             (0xfd000000UL)
> -
> -#define VMALLOC_END            (FIXADDR_START - 2*PAGE_SIZE)
> -
> -#define pte_ERROR(e) \
> -       printk(KERN_ERR "%s:%d: bad pte %08lx.\n", \
> -               __FILE__, __LINE__, pte_val(e))
> -#define pgd_ERROR(e) \
> -       printk(KERN_ERR "%s:%d: bad pgd %08lx.\n", \
> -               __FILE__, __LINE__, pgd_val(e))
> -
> -/*
> - * Empty pgd/pmd entries point to the invalid_pte_table.
> - */
> -static inline int pmd_none(pmd_t pmd)
> -{
> -       return pmd_val(pmd) == (unsigned long) invalid_pte_table;
> -}
> -
> -#define pmd_bad(pmd)           (pmd_val(pmd) & ~PAGE_MASK)
> -
> -static inline int pmd_present(pmd_t pmd)
> -{
> -       return pmd_val(pmd) != (unsigned long) invalid_pte_table;
> -}
> -
> -static inline void pmd_clear(pmd_t *pmdp)
> -{
> -       pmd_val(*pmdp) = ((unsigned long) invalid_pte_table);
> -}
> -
> -#define pte_page(x)            pfn_to_page(pte_pfn(x))
> -#define pte_pfn(x)             ((unsigned long)((x).pte >> PAGE_SHIFT))
> -#define pfn_pte(pfn, prot)     \
> -       __pte(((unsigned long long)(pfn) << PAGE_SHIFT) | pgprot_val(prot))
> -
> -#define __pgd_offset(address)  pgd_index(address)
> -#define __pud_offset(address)  (((address) >> PUD_SHIFT) & (PTRS_PER_PUD-1))
> -#define __pmd_offset(address)  (((address) >> PMD_SHIFT) & (PTRS_PER_PMD-1))
> -
> -/* to find an entry in a kernel page-table-directory */
> -#define pgd_offset_k(address)  pgd_offset(&init_mm, address)
> -#define pgd_index(address)     (((address) >> PGDIR_SHIFT) & (PTRS_PER_PGD-1))
> -
> -/* to find an entry in a page-table-directory */
> -#define pgd_offset(mm, addr)   ((mm)->pgd + pgd_index(addr))
> -
> -/* Find an entry in the third-level page table.. */
> -#define __pte_offset(address)          \
> -       (((address) >> PAGE_SHIFT) & (PTRS_PER_PTE - 1))
> -#define pte_offset(dir, address)       \
> -       ((pte_t *) pmd_page_vaddr(*(dir)) + __pte_offset(address))
> -#define pte_offset_kernel(dir, address)        \
> -       ((pte_t *) pmd_page_vaddr(*(dir)) + __pte_offset(address))
> -
> -#define pte_offset_map(dir, address)   \
> -       ((pte_t *)page_address(pmd_page(*(dir))) + __pte_offset(address))
> -#define pte_unmap(pte) ((void)(pte))
> -
> -/*
> - * Bits 9(_PAGE_PRESENT) and 10(_PAGE_FILE)are taken,
> - * split up 30 bits of offset into this range:
> - */
> -#define PTE_FILE_MAX_BITS      30
> -#define pte_to_pgoff(_pte)             \
> -       (((_pte).pte & 0x1ff) | (((_pte).pte >> 11) << 9))
> -#define pgoff_to_pte(off)              \
> -       ((pte_t) {((off) & 0x1ff) | (((off) >> 9) << 11) | _PAGE_FILE})
> -#define __pte_to_swp_entry(pte)                \
> -       ((swp_entry_t) { pte_val(pte)})
> -#define __swp_entry_to_pte(x)  ((pte_t) {(x).val})
> -
> -#define pmd_phys(pmd)          __pa((void *)pmd_val(pmd))
> -#define pmd_page(pmd)          (pfn_to_page(pmd_phys(pmd) >> PAGE_SHIFT))
> -#define mk_pte(page, prot)     pfn_pte(page_to_pfn(page), prot)
> -static inline pte_t pte_mkspecial(pte_t pte) { return pte; }
> -
> -#define set_pte(pteptr, pteval) (*(pteptr) = pteval)
> -#define set_pte_at(mm, addr, ptep, pteval) set_pte(ptep, pteval)
> -#define pte_clear(mm, addr, xp)                \
> -       do { set_pte_at(mm, addr, xp, __pte(0)); } while (0)
> -
> -/*
> - * The "pgd_xxx()" functions here are trivial for a folded two-level
> - * setup: the pgd is never bad, and a pmd always exists (as it's folded
> - * into the pgd entry)
> - */
> -#define pgd_present(pgd)       (1)
> -#define pgd_none(pgd)          (0)
> -#define pgd_bad(pgd)           (0)
> -#define pgd_clear(pgdp)                do { } while (0)
> -
> -#define kern_addr_valid(addr)  (1)
> -#define pmd_page_vaddr(pmd)    pmd_val(pmd)
> -
> -#define pte_none(pte)          (!(pte_val(pte) & ~_PAGE_GLOBAL))
> -#define pte_present(pte)       (pte_val(pte) & _PAGE_PRESENT)
> -
> -#define PAGE_NONE      __pgprot(_PAGE_PRESENT | _PAGE_CACHE)
> -#define PAGE_SHARED    __pgprot(_PAGE_PRESENT | _PAGE_READ | _PAGE_WRITE | \
> -                               _PAGE_CACHE)
> -#define PAGE_COPY      __pgprot(_PAGE_PRESENT | _PAGE_READ | _PAGE_CACHE)
> -#define PAGE_READONLY  __pgprot(_PAGE_PRESENT | _PAGE_READ | _PAGE_CACHE)
> -#define PAGE_KERNEL    __pgprot(_PAGE_PRESENT | __READABLE | __WRITEABLE | \
> -                               _PAGE_GLOBAL | _PAGE_CACHE)
> -#define PAGE_KERNEL_UNCACHED __pgprot(_PAGE_PRESENT | __READABLE | \
> -                               __WRITEABLE | _PAGE_GLOBAL & ~_PAGE_CACHE)
> -
> -#define __P000 PAGE_NONE
> -#define __P001 PAGE_READONLY
> -#define __P010 PAGE_COPY
> -#define __P011 PAGE_COPY
> -#define __P100 PAGE_READONLY
> -#define __P101 PAGE_READONLY
> -#define __P110 PAGE_COPY
> -#define __P111 PAGE_COPY
> -
> -#define __S000 PAGE_NONE
> -#define __S001 PAGE_READONLY
> -#define __S010 PAGE_SHARED
> -#define __S011 PAGE_SHARED
> -#define __S100 PAGE_READONLY
> -#define __S101 PAGE_READONLY
> -#define __S110 PAGE_SHARED
> -#define __S111 PAGE_SHARED
> -
> -#define pgprot_noncached pgprot_noncached
> -
> -static inline pgprot_t pgprot_noncached(pgprot_t _prot)
> -{
> -       unsigned long prot = pgprot_val(_prot);
> -
> -       prot = (prot & ~_CACHE_MASK);
> -
> -       return __pgprot(prot);
> -}
> -
> -#define __swp_type(x)          ((x).val & 0x1f)
> -#define __swp_offset(x)        ((x).val >> 11)
> -#define __swp_entry(type, offset) ((swp_entry_t){(type) | ((offset) << 11)})
> -
> -extern unsigned long empty_zero_page;
> -extern unsigned long zero_page_mask;
> -
> -#define ZERO_PAGE(vaddr) \
> -       (virt_to_page((void *)(empty_zero_page + \
> -        (((unsigned long)(vaddr)) & zero_page_mask))))
> -
> -#define pgtable_cache_init()   do {} while (0)
> -
> -#define arch_enter_lazy_cpu_mode()     do {} while (0)
> -
> -static inline int pte_write(pte_t pte)
> -{
> -       return pte_val(pte) & _PAGE_WRITE;
> -}
> -
> -static inline int pte_dirty(pte_t pte)
> -{
> -       return pte_val(pte) & _PAGE_MODIFIED;
> -}
> -
> -static inline int pte_young(pte_t pte)
> -{
> -       return pte_val(pte) & _PAGE_ACCESSED;
> -}
> -
> -static inline int pte_file(pte_t pte)
> -{
> -       return pte_val(pte) & _PAGE_FILE;
> -}
> -
> -#define pte_special(pte)       (0)
> -
> -static inline pte_t pte_wrprotect(pte_t pte)
> -{
> -       pte_val(pte) &= ~(_PAGE_WRITE | _PAGE_SILENT_WRITE);
> -       return pte;
> -}
> -
> -static inline pte_t pte_mkclean(pte_t pte)
> -{
> -       pte_val(pte) &= ~(_PAGE_MODIFIED|_PAGE_SILENT_WRITE);
> -       return pte;
> -}
> -
> -static inline pte_t pte_mkold(pte_t pte)
> -{
> -       pte_val(pte) &= ~(_PAGE_ACCESSED|_PAGE_SILENT_READ);
> -       return pte;
> -}
> -
> -static inline pte_t pte_mkwrite(pte_t pte)
> -{
> -       pte_val(pte) |= _PAGE_WRITE;
> -       if (pte_val(pte) & _PAGE_MODIFIED)
> -               pte_val(pte) |= _PAGE_SILENT_WRITE;
> -       return pte;
> -}
> -
> -static inline pte_t pte_mkdirty(pte_t pte)
> -{
> -       pte_val(pte) |= _PAGE_MODIFIED;
> -       if (pte_val(pte) & _PAGE_WRITE)
> -               pte_val(pte) |= _PAGE_SILENT_WRITE;
> -       return pte;
> -}
> -
> -static inline pte_t pte_mkyoung(pte_t pte)
> -{
> -       pte_val(pte) |= _PAGE_ACCESSED;
> -       if (pte_val(pte) & _PAGE_READ)
> -               pte_val(pte) |= _PAGE_SILENT_READ;
> -       return pte;
> -}
> -
> -#define set_pmd(pmdptr, pmdval)                \
> -        do { *(pmdptr) = (pmdval); } while (0)
> -#define pte_present(pte)       (pte_val(pte) & _PAGE_PRESENT)
> -
> -extern unsigned long pgd_current;
> -extern pgd_t swapper_pg_dir[PTRS_PER_PGD];
> -extern void paging_init(void);
> -
> -static inline pte_t pte_modify(pte_t pte, pgprot_t newprot)
> -{
> -       return __pte((pte_val(pte) & _PAGE_CHG_MASK) | pgprot_val(newprot));
> -}
> -
> -extern void __update_tlb(struct vm_area_struct *vma,
> -       unsigned long address,  pte_t pte);
> -extern void __update_cache(struct vm_area_struct *vma,
> -       unsigned long address,  pte_t pte);
> -
> -static inline void update_mmu_cache(struct vm_area_struct *vma,
> -       unsigned long address, pte_t *ptep)
> -{
> -       pte_t pte = *ptep;
> -       __update_tlb(vma, address, pte);
> -       __update_cache(vma, address, pte);
> -}
> -
> -#ifndef __ASSEMBLY__
> -#include <asm-generic/pgtable.h>
> -
> -void setup_memory(void);
> -#endif /* __ASSEMBLY__ */
> -
> -#endif /* _ASM_SCORE_PGTABLE_H */
> diff --git a/arch/score/include/asm/processor.h b/arch/score/include/asm/processor.h
> deleted file mode 100644
> index d9a922d..0000000
> --- a/arch/score/include/asm/processor.h
> +++ /dev/null
> @@ -1,104 +0,0 @@
> -#ifndef _ASM_SCORE_PROCESSOR_H
> -#define _ASM_SCORE_PROCESSOR_H
> -
> -#include <linux/cpumask.h>
> -#include <linux/threads.h>
> -
> -#include <asm/segment.h>
> -
> -struct task_struct;
> -
> -/*
> - * System setup and hardware flags..
> - */
> -extern void (*cpu_wait)(void);
> -
> -extern unsigned long thread_saved_pc(struct task_struct *tsk);
> -extern void start_thread(struct pt_regs *regs,
> -                       unsigned long pc, unsigned long sp);
> -extern unsigned long get_wchan(struct task_struct *p);
> -
> -/*
> - * Return current * instruction pointer ("program counter").
> - */
> -#define current_text_addr() ({ __label__ _l; _l: &&_l; })
> -
> -#define cpu_relax()            barrier()
> -#define release_thread(thread) do {} while (0)
> -
> -/*
> - * User space process size: 2GB. This is hardcoded into a few places,
> - * so don't change it unless you know what you are doing.
> - */
> -#define TASK_SIZE      0x7fff8000UL
> -
> -/*
> - * This decides where the kernel will search for a free chunk of vm
> - * space during mmap's.
> - */
> -#define TASK_UNMAPPED_BASE     ((TASK_SIZE / 3) & ~(PAGE_SIZE))
> -
> -#ifdef __KERNEL__
> -#define STACK_TOP      TASK_SIZE
> -#define STACK_TOP_MAX  TASK_SIZE
> -#endif
> -
> -/*
> - * If you change thread_struct remember to change the #defines below too!
> - */
> -struct thread_struct {
> -       unsigned long reg0, reg2, reg3;
> -       unsigned long reg12, reg13, reg14, reg15, reg16;
> -       unsigned long reg17, reg18, reg19, reg20, reg21;
> -
> -       unsigned long cp0_psr;
> -       unsigned long cp0_ema;          /* Last user fault */
> -       unsigned long cp0_badvaddr;     /* Last user fault */
> -       unsigned long cp0_baduaddr;     /* Last kernel fault accessing USEG */
> -       unsigned long error_code;
> -       unsigned long trap_no;
> -
> -       unsigned long mflags;
> -       unsigned long reg29;
> -
> -       unsigned long single_step;
> -       unsigned long ss_nextcnt;
> -
> -       unsigned long insn1_type;
> -       unsigned long addr1;
> -       unsigned long insn1;
> -
> -       unsigned long insn2_type;
> -       unsigned long addr2;
> -       unsigned long insn2;
> -
> -       mm_segment_t current_ds;
> -};
> -
> -#define INIT_THREAD {                                          \
> -       .reg0                   = 0,                            \
> -       .reg2                   = 0,                            \
> -       .reg3                   = 0,                            \
> -       .reg12                  = 0,                            \
> -       .reg13                  = 0,                            \
> -       .reg14                  = 0,                            \
> -       .reg15                  = 0,                            \
> -       .reg16                  = 0,                            \
> -       .reg17                  = 0,                            \
> -       .reg18                  = 0,                            \
> -       .reg19                  = 0,                            \
> -       .reg20                  = 0,                            \
> -       .reg21                  = 0,                            \
> -       .cp0_psr                = 0,                            \
> -       .error_code             = 0,                            \
> -       .trap_no                = 0,                            \
> -}
> -
> -#define kstk_tos(tsk)          \
> -       ((unsigned long)task_stack_page(tsk) + THREAD_SIZE - 32)
> -#define task_pt_regs(tsk)      ((struct pt_regs *)kstk_tos(tsk) - 1)
> -
> -#define KSTK_EIP(tsk)          (task_pt_regs(tsk)->cp0_epc)
> -#define KSTK_ESP(tsk)          (task_pt_regs(tsk)->regs[29])
> -
> -#endif /* _ASM_SCORE_PROCESSOR_H */
> diff --git a/arch/score/include/asm/ptrace.h b/arch/score/include/asm/ptrace.h
> deleted file mode 100644
> index abc279d..0000000
> --- a/arch/score/include/asm/ptrace.h
> +++ /dev/null
> @@ -1,25 +0,0 @@
> -#ifndef _ASM_SCORE_PTRACE_H
> -#define _ASM_SCORE_PTRACE_H
> -
> -#include <uapi/asm/ptrace.h>
> -
> -
> -struct task_struct;
> -
> -/*
> - * Does the process account for user or for system time?
> - */
> -#define user_mode(regs)        ((regs->cp0_psr & 8) == 8)
> -
> -#define instruction_pointer(regs)      ((unsigned long)(regs)->cp0_epc)
> -#define profile_pc(regs)               instruction_pointer(regs)
> -#define user_stack_pointer(r)          ((unsigned long)(r)->regs[0])
> -
> -extern void do_syscall_trace(struct pt_regs *regs, int entryexit);
> -extern int read_tsk_long(struct task_struct *, unsigned long, unsigned long *);
> -extern int read_tsk_short(struct task_struct *, unsigned long,
> -                        unsigned short *);
> -
> -#define arch_has_single_step() (1)
> -
> -#endif /* _ASM_SCORE_PTRACE_H */
> diff --git a/arch/score/include/asm/scatterlist.h b/arch/score/include/asm/scatterlist.h
> deleted file mode 100644
> index 9f533b8..0000000
> --- a/arch/score/include/asm/scatterlist.h
> +++ /dev/null
> @@ -1,6 +0,0 @@
> -#ifndef _ASM_SCORE_SCATTERLIST_H
> -#define _ASM_SCORE_SCATTERLIST_H
> -
> -#include <asm-generic/scatterlist.h>
> -
> -#endif /* _ASM_SCORE_SCATTERLIST_H */
> diff --git a/arch/score/include/asm/scoreregs.h b/arch/score/include/asm/scoreregs.h
> deleted file mode 100644
> index d0ad292..0000000
> --- a/arch/score/include/asm/scoreregs.h
> +++ /dev/null
> @@ -1,51 +0,0 @@
> -#ifndef _ASM_SCORE_SCOREREGS_H
> -#define _ASM_SCORE_SCOREREGS_H
> -
> -#include <linux/linkage.h>
> -
> -/* TIMER register */
> -#define TIME0BASE              0x96080000
> -#define P_TIMER0_CTRL          (TIME0BASE + 0x00)
> -#define P_TIMER0_CPP_CTRL      (TIME0BASE + 0x04)
> -#define P_TIMER0_PRELOAD       (TIME0BASE + 0x08)
> -#define P_TIMER0_CPP_REG       (TIME0BASE + 0x0C)
> -#define P_TIMER0_UPCNT         (TIME0BASE + 0x10)
> -
> -/* Timer Controller Register */
> -/* bit 0 Timer enable */
> -#define TMR_DISABLE    0x0000
> -#define TMR_ENABLE     0x0001
> -
> -/* bit 1 Interrupt enable */
> -#define TMR_IE_DISABLE 0x0000
> -#define TMR_IE_ENABLE  0x0002
> -
> -/* bit 2 Output enable */
> -#define TMR_OE_DISABLE 0x0004
> -#define TMR_OE_ENABLE  0x0000
> -
> -/* bit4 Up/Down counting selection */
> -#define TMR_UD_DOWN    0x0000
> -#define TMR_UD_UP      0x0010
> -
> -/* bit5 Up/Down counting control selection */
> -#define TMR_UDS_UD     0x0000
> -#define TMR_UDS_EXTUD  0x0020
> -
> -/* bit6 Time output mode */
> -#define TMR_OM_TOGGLE  0x0000
> -#define TMR_OM_PILSE   0x0040
> -
> -/* bit 8..9 External input active edge selection */
> -#define TMR_ES_PE      0x0000
> -#define TMR_ES_NE      0x0100
> -#define TMR_ES_BOTH    0x0200
> -
> -/* bit 10..11 Operating mode */
> -#define TMR_M_FREE     0x0000 /* free running timer mode */
> -#define TMR_M_PERIODIC 0x0400 /* periodic timer mode */
> -#define TMR_M_FC       0x0800 /* free running counter mode */
> -#define TMR_M_PC       0x0c00 /* periodic counter mode */
> -
> -#define SYSTEM_CLOCK           (27*1000000/4)          /* 27 MHz */
> -#endif /* _ASM_SCORE_SCOREREGS_H */
> diff --git a/arch/score/include/asm/sections.h b/arch/score/include/asm/sections.h
> deleted file mode 100644
> index 9441d23..0000000
> --- a/arch/score/include/asm/sections.h
> +++ /dev/null
> @@ -1,6 +0,0 @@
> -#ifndef _ASM_SCORE_SECTIONS_H
> -#define _ASM_SCORE_SECTIONS_H
> -
> -#include <asm-generic/sections.h>
> -
> -#endif /* _ASM_SCORE_SECTIONS_H */
> diff --git a/arch/score/include/asm/segment.h b/arch/score/include/asm/segment.h
> deleted file mode 100644
> index e16cf6a..0000000
> --- a/arch/score/include/asm/segment.h
> +++ /dev/null
> @@ -1,21 +0,0 @@
> -#ifndef _ASM_SCORE_SEGMENT_H
> -#define _ASM_SCORE_SEGMENT_H
> -
> -#ifndef __ASSEMBLY__
> -
> -typedef struct {
> -       unsigned long seg;
> -} mm_segment_t;
> -
> -#define KERNEL_DS      ((mm_segment_t){0})
> -#define USER_DS        KERNEL_DS
> -
> -# define get_ds()      (KERNEL_DS)
> -# define get_fs()      (current_thread_info()->addr_limit)
> -# define set_fs(x)     \
> -       do { current_thread_info()->addr_limit = (x); } while (0)
> -
> -# define segment_eq(a, b)      ((a).seg == (b).seg)
> -
> -# endif /* __ASSEMBLY__ */
> -#endif /* _ASM_SCORE_SEGMENT_H */
> diff --git a/arch/score/include/asm/setup.h b/arch/score/include/asm/setup.h
> deleted file mode 100644
> index 1f3aa72..0000000
> --- a/arch/score/include/asm/setup.h
> +++ /dev/null
> @@ -1,36 +0,0 @@
> -#ifndef _ASM_SCORE_SETUP_H
> -#define _ASM_SCORE_SETUP_H
> -
> -#include <uapi/asm/setup.h>
> -
> -
> -extern void pagetable_init(void);
> -extern void pgd_init(unsigned long page);
> -
> -extern void setup_early_printk(void);
> -extern void cpu_cache_init(void);
> -extern void tlb_init(void);
> -
> -extern void handle_nmi(void);
> -extern void handle_adelinsn(void);
> -extern void handle_adedata(void);
> -extern void handle_ibe(void);
> -extern void handle_pel(void);
> -extern void handle_sys(void);
> -extern void handle_ccu(void);
> -extern void handle_ri(void);
> -extern void handle_tr(void);
> -extern void handle_ades(void);
> -extern void handle_cee(void);
> -extern void handle_cpe(void);
> -extern void handle_dve(void);
> -extern void handle_dbe(void);
> -extern void handle_reserved(void);
> -extern void handle_tlb_refill(void);
> -extern void handle_tlb_invaild(void);
> -extern void handle_mod(void);
> -extern void debug_exception_vector(void);
> -extern void general_exception_vector(void);
> -extern void interrupt_exception_vector(void);
> -
> -#endif /* _ASM_SCORE_SETUP_H */
> diff --git a/arch/score/include/asm/shmparam.h b/arch/score/include/asm/shmparam.h
> deleted file mode 100644
> index 1d60813..0000000
> --- a/arch/score/include/asm/shmparam.h
> +++ /dev/null
> @@ -1,6 +0,0 @@
> -#ifndef _ASM_SCORE_SHMPARAM_H
> -#define _ASM_SCORE_SHMPARAM_H
> -
> -#include <asm-generic/shmparam.h>
> -
> -#endif /* _ASM_SCORE_SHMPARAM_H */
> diff --git a/arch/score/include/asm/string.h b/arch/score/include/asm/string.h
> deleted file mode 100644
> index 8a6bf50..0000000
> --- a/arch/score/include/asm/string.h
> +++ /dev/null
> @@ -1,8 +0,0 @@
> -#ifndef _ASM_SCORE_STRING_H
> -#define _ASM_SCORE_STRING_H
> -
> -extern void *memset(void *__s, int __c, size_t __count);
> -extern void *memcpy(void *__to, __const__ void *__from, size_t __n);
> -extern void *memmove(void *__dest, __const__ void *__src, size_t __n);
> -
> -#endif /* _ASM_SCORE_STRING_H */
> diff --git a/arch/score/include/asm/switch_to.h b/arch/score/include/asm/switch_to.h
> deleted file mode 100644
> index 031756b..0000000
> --- a/arch/score/include/asm/switch_to.h
> +++ /dev/null
> @@ -1,13 +0,0 @@
> -#ifndef _ASM_SCORE_SWITCH_TO_H
> -#define _ASM_SCORE_SWITCH_TO_H
> -
> -extern void *resume(void *last, void *next, void *next_ti);
> -
> -#define switch_to(prev, next, last)                            \
> -do {                                                           \
> -       (last) = resume(prev, next, task_thread_info(next));    \
> -} while (0)
> -
> -#define finish_arch_switch(prev)       do {} while (0)
> -
> -#endif /* _ASM_SCORE_SWITCH_TO_H */
> diff --git a/arch/score/include/asm/syscalls.h b/arch/score/include/asm/syscalls.h
> deleted file mode 100644
> index 98d1df9..0000000
> --- a/arch/score/include/asm/syscalls.h
> +++ /dev/null
> @@ -1,8 +0,0 @@
> -#ifndef _ASM_SCORE_SYSCALLS_H
> -#define _ASM_SCORE_SYSCALLS_H
> -
> -asmlinkage long score_rt_sigreturn(struct pt_regs *regs);
> -
> -#include <asm-generic/syscalls.h>
> -
> -#endif /* _ASM_SCORE_SYSCALLS_H */
> diff --git a/arch/score/include/asm/thread_info.h b/arch/score/include/asm/thread_info.h
> deleted file mode 100644
> index 1425cc0..0000000
> --- a/arch/score/include/asm/thread_info.h
> +++ /dev/null
> @@ -1,100 +0,0 @@
> -#ifndef _ASM_SCORE_THREAD_INFO_H
> -#define _ASM_SCORE_THREAD_INFO_H
> -
> -#ifdef __KERNEL__
> -
> -#define KU_MASK        0x08
> -#define KU_USER        0x08
> -#define KU_KERN        0x00
> -
> -#include <asm/page.h>
> -#include <linux/const.h>
> -
> -/* thread information allocation */
> -#define THREAD_SIZE_ORDER      (1)
> -#define THREAD_SIZE            (PAGE_SIZE << THREAD_SIZE_ORDER)
> -#define THREAD_MASK            (THREAD_SIZE - _AC(1,UL))
> -
> -#ifndef __ASSEMBLY__
> -
> -#include <asm/processor.h>
> -
> -/*
> - * low level task data that entry.S needs immediate access to
> - * - this struct should fit entirely inside of one cache line
> - * - this struct shares the supervisor stack pages
> - * - if the contents of this structure are changed, the assembly constants
> - *   must also be changed
> - */
> -struct thread_info {
> -       struct task_struct      *task;          /* main task structure */
> -       struct exec_domain      *exec_domain;   /* execution domain */
> -       unsigned long           flags;          /* low level flags */
> -       unsigned long           tp_value;       /* thread pointer */
> -       __u32                   cpu;            /* current CPU */
> -
> -       /* 0 => preemptable, < 0 => BUG */
> -       int                     preempt_count;
> -
> -       /*
> -        * thread address space:
> -        * 0-0xBFFFFFFF for user-thead
> -        * 0-0xFFFFFFFF for kernel-thread
> -        */
> -       mm_segment_t            addr_limit;
> -       struct restart_block    restart_block;
> -       struct pt_regs          *regs;
> -};
> -
> -/*
> - * macros/functions for gaining access to the thread information structure
> - *
> - * preempt_count needs to be 1 initially, until the scheduler is functional.
> - */
> -#define INIT_THREAD_INFO(tsk)                  \
> -{                                              \
> -       .task           = &tsk,                 \
> -       .exec_domain    = &default_exec_domain, \
> -       .cpu            = 0,                    \
> -       .preempt_count  = 1,                    \
> -       .addr_limit     = KERNEL_DS,            \
> -       .restart_block  = {                     \
> -               .fn = do_no_restart_syscall,    \
> -       },                                      \
> -}
> -
> -#define init_thread_info       (init_thread_union.thread_info)
> -#define init_stack             (init_thread_union.stack)
> -
> -/* How to get the thread information struct from C. */
> -register struct thread_info *__current_thread_info __asm__("r28");
> -#define current_thread_info()  __current_thread_info
> -
> -#endif /* !__ASSEMBLY__ */
> -
> -#define PREEMPT_ACTIVE         0x10000000
> -
> -/*
> - * thread information flags
> - * - these are process state flags that various assembly files may need to
> - *   access
> - * - pending work-to-be-done flags are in LSW
> - * - other flags in MSW
> - */
> -#define TIF_SYSCALL_TRACE      0       /* syscall trace active */
> -#define TIF_SIGPENDING         1       /* signal pending */
> -#define TIF_NEED_RESCHED       2       /* rescheduling necessary */
> -#define TIF_NOTIFY_RESUME      5       /* callback before returning to user */
> -#define TIF_RESTORE_SIGMASK    9       /* restore signal mask in do_signal() */
> -#define TIF_MEMDIE             18      /* is terminating due to OOM killer */
> -
> -#define _TIF_SYSCALL_TRACE     (1<<TIF_SYSCALL_TRACE)
> -#define _TIF_SIGPENDING                (1<<TIF_SIGPENDING)
> -#define _TIF_NEED_RESCHED      (1<<TIF_NEED_RESCHED)
> -#define _TIF_NOTIFY_RESUME     (1<<TIF_NOTIFY_RESUME)
> -
> -#define _TIF_WORK_MASK         (0x0000ffff)
> -
> -#endif /* __KERNEL__ */
> -
> -#endif /* _ASM_SCORE_THREAD_INFO_H */
> diff --git a/arch/score/include/asm/timex.h b/arch/score/include/asm/timex.h
> deleted file mode 100644
> index a524ae0..0000000
> --- a/arch/score/include/asm/timex.h
> +++ /dev/null
> @@ -1,8 +0,0 @@
> -#ifndef _ASM_SCORE_TIMEX_H
> -#define _ASM_SCORE_TIMEX_H
> -
> -#define CLOCK_TICK_RATE 27000000 /* Timer input freq. */
> -
> -#include <asm-generic/timex.h>
> -
> -#endif /* _ASM_SCORE_TIMEX_H */
> diff --git a/arch/score/include/asm/tlb.h b/arch/score/include/asm/tlb.h
> deleted file mode 100644
> index 46882ed..0000000
> --- a/arch/score/include/asm/tlb.h
> +++ /dev/null
> @@ -1,17 +0,0 @@
> -#ifndef _ASM_SCORE_TLB_H
> -#define _ASM_SCORE_TLB_H
> -
> -/*
> - * SCORE doesn't need any special per-pte or per-vma handling, except
> - * we need to flush cache for area to be unmapped.
> - */
> -#define tlb_start_vma(tlb, vma)                do {} while (0)
> -#define tlb_end_vma(tlb, vma)          do {} while (0)
> -#define __tlb_remove_tlb_entry(tlb, ptep, address) do {} while (0)
> -#define tlb_flush(tlb)                 flush_tlb_mm((tlb)->mm)
> -
> -extern void score7_FTLB_refill_Handler(void);
> -
> -#include <asm-generic/tlb.h>
> -
> -#endif /* _ASM_SCORE_TLB_H */
> diff --git a/arch/score/include/asm/tlbflush.h b/arch/score/include/asm/tlbflush.h
> deleted file mode 100644
> index 9cce978..0000000
> --- a/arch/score/include/asm/tlbflush.h
> +++ /dev/null
> @@ -1,142 +0,0 @@
> -#ifndef _ASM_SCORE_TLBFLUSH_H
> -#define _ASM_SCORE_TLBFLUSH_H
> -
> -#include <linux/mm.h>
> -
> -/*
> - * TLB flushing:
> - *
> - * - flush_tlb_all() flushes all processes TLB entries
> - * - flush_tlb_mm(mm) flushes the specified mm context TLB entries
> - * - flush_tlb_page(vma, vmaddr) flushes one page
> - * - flush_tlb_range(vma, start, end) flushes a range of pages
> - * - flush_tlb_kernel_range(start, end) flushes a range of kernel pages
> - */
> -extern void local_flush_tlb_all(void);
> -extern void local_flush_tlb_mm(struct mm_struct *mm);
> -extern void local_flush_tlb_range(struct vm_area_struct *vma,
> -       unsigned long start, unsigned long end);
> -extern void local_flush_tlb_kernel_range(unsigned long start,
> -       unsigned long end);
> -extern void local_flush_tlb_page(struct vm_area_struct *vma,
> -       unsigned long page);
> -extern void local_flush_tlb_one(unsigned long vaddr);
> -
> -#define flush_tlb_all()                        local_flush_tlb_all()
> -#define flush_tlb_mm(mm)               local_flush_tlb_mm(mm)
> -#define flush_tlb_range(vma, vmaddr, end) \
> -       local_flush_tlb_range(vma, vmaddr, end)
> -#define flush_tlb_kernel_range(vmaddr, end) \
> -       local_flush_tlb_kernel_range(vmaddr, end)
> -#define flush_tlb_page(vma, page)      local_flush_tlb_page(vma, page)
> -#define flush_tlb_one(vaddr)           local_flush_tlb_one(vaddr)
> -
> -#ifndef __ASSEMBLY__
> -
> -static inline unsigned long pevn_get(void)
> -{
> -       unsigned long val;
> -
> -       __asm__ __volatile__(
> -               "mfcr %0, cr11\n"
> -               "nop\nnop\n"
> -               : "=r" (val));
> -
> -       return val;
> -}
> -
> -static inline void pevn_set(unsigned long val)
> -{
> -       __asm__ __volatile__(
> -               "mtcr %0, cr11\n"
> -               "nop\nnop\nnop\nnop\nnop\n"
> -       : : "r" (val));
> -}
> -
> -static inline void pectx_set(unsigned long val)
> -{
> -       __asm__ __volatile__(
> -               "mtcr %0, cr12\n"
> -               "nop\nnop\nnop\nnop\nnop\n"
> -       : : "r" (val));
> -}
> -
> -static inline unsigned long pectx_get(void)
> -{
> -       unsigned long val;
> -       __asm__ __volatile__(
> -               "mfcr %0, cr12\n"
> -               "nop\nnop\n"
> -       : "=r" (val));
> -       return val;
> -}
> -static inline unsigned long tlblock_get(void)
> -{
> -       unsigned long val;
> -
> -       __asm__ __volatile__(
> -               "mfcr %0, cr7\n"
> -               "nop\nnop\n"
> -       : "=r" (val));
> -       return val;
> -}
> -static inline void tlblock_set(unsigned long val)
> -{
> -       __asm__ __volatile__(
> -               "mtcr %0, cr7\n"
> -               "nop\nnop\nnop\nnop\nnop\n"
> -       : : "r" (val));
> -}
> -
> -static inline void tlbpt_set(unsigned long val)
> -{
> -       __asm__ __volatile__(
> -               "mtcr %0, cr8\n"
> -               "nop\nnop\nnop\nnop\nnop\n"
> -               : : "r" (val));
> -}
> -
> -static inline long tlbpt_get(void)
> -{
> -       long val;
> -
> -       __asm__ __volatile__(
> -               "mfcr %0, cr8\n"
> -               "nop\nnop\n"
> -               : "=r" (val));
> -
> -       return val;
> -}
> -
> -static inline void peaddr_set(unsigned long val)
> -{
> -       __asm__ __volatile__(
> -               "mtcr %0, cr9\n"
> -               "nop\nnop\nnop\nnop\nnop\n"
> -               : : "r" (val));
> -}
> -
> -/* TLB operations. */
> -static inline void tlb_probe(void)
> -{
> -       __asm__ __volatile__("stlb;nop;nop;nop;nop;nop");
> -}
> -
> -static inline void tlb_read(void)
> -{
> -       __asm__ __volatile__("mftlb;nop;nop;nop;nop;nop");
> -}
> -
> -static inline void tlb_write_indexed(void)
> -{
> -       __asm__ __volatile__("mtptlb;nop;nop;nop;nop;nop");
> -}
> -
> -static inline void tlb_write_random(void)
> -{
> -       __asm__ __volatile__("mtrtlb;nop;nop;nop;nop;nop");
> -}
> -
> -#endif /* Not __ASSEMBLY__ */
> -
> -#endif /* _ASM_SCORE_TLBFLUSH_H */
> diff --git a/arch/score/include/asm/topology.h b/arch/score/include/asm/topology.h
> deleted file mode 100644
> index 425fba3..0000000
> --- a/arch/score/include/asm/topology.h
> +++ /dev/null
> @@ -1,6 +0,0 @@
> -#ifndef _ASM_SCORE_TOPOLOGY_H
> -#define _ASM_SCORE_TOPOLOGY_H
> -
> -#include <asm-generic/topology.h>
> -
> -#endif /* _ASM_SCORE_TOPOLOGY_H */
> diff --git a/arch/score/include/asm/uaccess.h b/arch/score/include/asm/uaccess.h
> deleted file mode 100644
> index ab66ddd..0000000
> --- a/arch/score/include/asm/uaccess.h
> +++ /dev/null
> @@ -1,424 +0,0 @@
> -#ifndef __SCORE_UACCESS_H
> -#define __SCORE_UACCESS_H
> -
> -#include <linux/kernel.h>
> -#include <linux/errno.h>
> -#include <linux/thread_info.h>
> -
> -#define VERIFY_READ            0
> -#define VERIFY_WRITE           1
> -
> -#define get_ds()               (KERNEL_DS)
> -#define get_fs()               (current_thread_info()->addr_limit)
> -#define segment_eq(a, b)       ((a).seg == (b).seg)
> -
> -/*
> - * Is a address valid? This does a straighforward calculation rather
> - * than tests.
> - *
> - * Address valid if:
> - *  - "addr" doesn't have any high-bits set
> - *  - AND "size" doesn't have any high-bits set
> - *  - AND "addr+size" doesn't have any high-bits set
> - *  - OR we are in kernel mode.
> - *
> - * __ua_size() is a trick to avoid runtime checking of positive constant
> - * sizes; for those we already know at compile time that the size is ok.
> - */
> -#define __ua_size(size)                                                        \
> -       ((__builtin_constant_p(size) && (signed long) (size) > 0) ? 0 : (size))
> -
> -/*
> - * access_ok: - Checks if a user space pointer is valid
> - * @type: Type of access: %VERIFY_READ or %VERIFY_WRITE.  Note that
> - *        %VERIFY_WRITE is a superset of %VERIFY_READ - if it is safe
> - *        to write to a block, it is always safe to read from it.
> - * @addr: User space pointer to start of block to check
> - * @size: Size of block to check
> - *
> - * Context: User context only.  This function may sleep.
> - *
> - * Checks if a pointer to a block of memory in user space is valid.
> - *
> - * Returns true (nonzero) if the memory block may be valid, false (zero)
> - * if it is definitely invalid.
> - *
> - * Note that, depending on architecture, this function probably just
> - * checks that the pointer is in the user space range - after calling
> - * this function, memory access functions may still return -EFAULT.
> - */
> -
> -#define __access_ok(addr, size)                                        \
> -       (((long)((get_fs().seg) &                               \
> -                ((addr) | ((addr) + (size)) |                  \
> -                 __ua_size(size)))) == 0)
> -
> -#define access_ok(type, addr, size)                            \
> -       likely(__access_ok((unsigned long)(addr), (size)))
> -
> -/*
> - * put_user: - Write a simple value into user space.
> - * @x:   Value to copy to user space.
> - * @ptr: Destination address, in user space.
> - *
> - * Context: User context only.  This function may sleep.
> - *
> - * This macro copies a single simple value from kernel space to user
> - * space.  It supports simple types like char and int, but not larger
> - * data types like structures or arrays.
> - *
> - * @ptr must have pointer-to-simple-variable type, and @x must be assignable
> - * to the result of dereferencing @ptr.
> - *
> - * Returns zero on success, or -EFAULT on error.
> - */
> -#define put_user(x, ptr) __put_user_check((x), (ptr), sizeof(*(ptr)))
> -
> -/*
> - * get_user: - Get a simple variable from user space.
> - * @x:   Variable to store result.
> - * @ptr: Source address, in user space.
> - *
> - * Context: User context only.  This function may sleep.
> - *
> - * This macro copies a single simple variable from user space to kernel
> - * space.  It supports simple types like char and int, but not larger
> - * data types like structures or arrays.
> - *
> - * @ptr must have pointer-to-simple-variable type, and the result of
> - * dereferencing @ptr must be assignable to @x without a cast.
> - *
> - * Returns zero on success, or -EFAULT on error.
> - * On error, the variable @x is set to zero.
> - */
> -#define get_user(x, ptr) __get_user_check((x), (ptr), sizeof(*(ptr)))
> -
> -/*
> - * __put_user: - Write a simple value into user space, with less checking.
> - * @x:   Value to copy to user space.
> - * @ptr: Destination address, in user space.
> - *
> - * Context: User context only.  This function may sleep.
> - *
> - * This macro copies a single simple value from kernel space to user
> - * space.  It supports simple types like char and int, but not larger
> - * data types like structures or arrays.
> - *
> - * @ptr must have pointer-to-simple-variable type, and @x must be assignable
> - * to the result of dereferencing @ptr.
> - *
> - * Caller must check the pointer with access_ok() before calling this
> - * function.
> - *
> - * Returns zero on success, or -EFAULT on error.
> - */
> -#define __put_user(x, ptr) __put_user_nocheck((x), (ptr), sizeof(*(ptr)))
> -
> -/*
> - * __get_user: - Get a simple variable from user space, with less checking.
> - * @x:   Variable to store result.
> - * @ptr: Source address, in user space.
> - *
> - * Context: User context only.  This function may sleep.
> - *
> - * This macro copies a single simple variable from user space to kernel
> - * space.  It supports simple types like char and int, but not larger
> - * data types like structures or arrays.
> - *
> - * @ptr must have pointer-to-simple-variable type, and the result of
> - * dereferencing @ptr must be assignable to @x without a cast.
> - *
> - * Caller must check the pointer with access_ok() before calling this
> - * function.
> - *
> - * Returns zero on success, or -EFAULT on error.
> - * On error, the variable @x is set to zero.
> - */
> -#define __get_user(x, ptr) __get_user_nocheck((x), (ptr), sizeof(*(ptr)))
> -
> -struct __large_struct { unsigned long buf[100]; };
> -#define __m(x) (*(struct __large_struct __user *)(x))
> -
> -/*
> - * Yuck.  We need two variants, one for 64bit operation and one
> - * for 32 bit mode and old iron.
> - */
> -extern void __get_user_unknown(void);
> -
> -#define __get_user_common(val, size, ptr)                              \
> -do {                                                                   \
> -       switch (size) {                                                 \
> -       case 1:                                                         \
> -               __get_user_asm(val, "lb", ptr);                         \
> -               break;                                                  \
> -       case 2:                                                         \
> -               __get_user_asm(val, "lh", ptr);                         \
> -                break;                                                 \
> -       case 4:                                                         \
> -               __get_user_asm(val, "lw", ptr);                         \
> -                break;                                                 \
> -       case 8:                                                         \
> -               if ((copy_from_user((void *)&val, ptr, 8)) == 0)        \
> -                       __gu_err = 0;                                   \
> -               else                                                    \
> -                       __gu_err = -EFAULT;                             \
> -               break;                                                  \
> -       default:                                                        \
> -               __get_user_unknown();                                   \
> -               break;                                                  \
> -       }                                                               \
> -} while (0)
> -
> -#define __get_user_nocheck(x, ptr, size)                               \
> -({                                                                     \
> -       long __gu_err = 0;                                              \
> -       __get_user_common((x), size, ptr);                              \
> -       __gu_err;                                                       \
> -})
> -
> -#define __get_user_check(x, ptr, size)                                 \
> -({                                                                     \
> -       long __gu_err = -EFAULT;                                        \
> -       const __typeof__(*(ptr)) __user *__gu_ptr = (ptr);              \
> -                                                                       \
> -       if (likely(access_ok(VERIFY_READ, __gu_ptr, size)))             \
> -               __get_user_common((x), size, __gu_ptr);                 \
> -                                                                       \
> -       __gu_err;                                                       \
> -})
> -
> -#define __get_user_asm(val, insn, addr)                                        \
> -{                                                                      \
> -       long __gu_tmp;                                                  \
> -                                                                       \
> -       __asm__ __volatile__(                                           \
> -               "1:" insn " %1, %3\n"                                   \
> -               "2:\n"                                                  \
> -               ".section .fixup,\"ax\"\n"                              \
> -               "3:li   %0, %4\n"                                       \
> -               "j      2b\n"                                           \
> -               ".previous\n"                                           \
> -               ".section __ex_table,\"a\"\n"                           \
> -               ".word  1b, 3b\n"                                       \
> -               ".previous\n"                                           \
> -               : "=r" (__gu_err), "=r" (__gu_tmp)                      \
> -               : "0" (0), "o" (__m(addr)), "i" (-EFAULT));             \
> -                                                                       \
> -               (val) = (__typeof__(*(addr))) __gu_tmp;                 \
> -}
> -
> -/*
> - * Yuck.  We need two variants, one for 64bit operation and one
> - * for 32 bit mode and old iron.
> - */
> -#define __put_user_nocheck(val, ptr, size)                             \
> -({                                                                     \
> -       __typeof__(*(ptr)) __pu_val;                                    \
> -       long __pu_err = 0;                                              \
> -                                                                       \
> -       __pu_val = (val);                                               \
> -       switch (size) {                                                 \
> -       case 1:                                                         \
> -               __put_user_asm("sb", ptr);                              \
> -               break;                                                  \
> -       case 2:                                                         \
> -               __put_user_asm("sh", ptr);                              \
> -               break;                                                  \
> -       case 4:                                                         \
> -               __put_user_asm("sw", ptr);                              \
> -               break;                                                  \
> -       case 8:                                                         \
> -               if ((__copy_to_user((void *)ptr, &__pu_val, 8)) == 0)   \
> -                       __pu_err = 0;                                   \
> -               else                                                    \
> -                       __pu_err = -EFAULT;                             \
> -               break;                                                  \
> -       default:                                                        \
> -                __put_user_unknown();                                  \
> -                break;                                                 \
> -       }                                                               \
> -       __pu_err;                                                       \
> -})
> -
> -
> -#define __put_user_check(val, ptr, size)                               \
> -({                                                                     \
> -       __typeof__(*(ptr)) __user *__pu_addr = (ptr);                   \
> -       __typeof__(*(ptr)) __pu_val = (val);                            \
> -       long __pu_err = -EFAULT;                                        \
> -                                                                       \
> -       if (likely(access_ok(VERIFY_WRITE, __pu_addr, size))) {         \
> -               switch (size) {                                         \
> -               case 1:                                                 \
> -                       __put_user_asm("sb", __pu_addr);                \
> -                       break;                                          \
> -               case 2:                                                 \
> -                       __put_user_asm("sh", __pu_addr);                \
> -                       break;                                          \
> -               case 4:                                                 \
> -                       __put_user_asm("sw", __pu_addr);                \
> -                       break;                                          \
> -               case 8:                                                 \
> -                       if ((__copy_to_user((void *)__pu_addr, &__pu_val, 8)) == 0)\
> -                               __pu_err = 0;                           \
> -                       else                                            \
> -                               __pu_err = -EFAULT;                     \
> -                       break;                                          \
> -               default:                                                \
> -                       __put_user_unknown();                           \
> -                       break;                                          \
> -               }                                                       \
> -       }                                                               \
> -       __pu_err;                                                       \
> -})
> -
> -#define __put_user_asm(insn, ptr)                                      \
> -       __asm__ __volatile__(                                           \
> -               "1:" insn " %2, %3\n"                                   \
> -               "2:\n"                                                  \
> -               ".section .fixup,\"ax\"\n"                              \
> -               "3:li %0, %4\n"                                         \
> -               "j 2b\n"                                                \
> -               ".previous\n"                                           \
> -               ".section __ex_table,\"a\"\n"                           \
> -               ".word 1b, 3b\n"                                        \
> -               ".previous\n"                                           \
> -               : "=r" (__pu_err)                                       \
> -               : "0" (0), "r" (__pu_val), "o" (__m(ptr)),              \
> -                 "i" (-EFAULT));
> -
> -extern void __put_user_unknown(void);
> -extern int __copy_tofrom_user(void *to, const void *from, unsigned long len);
> -
> -static inline unsigned long
> -copy_from_user(void *to, const void *from, unsigned long len)
> -{
> -       unsigned long over;
> -
> -       if (access_ok(VERIFY_READ, from, len))
> -               return __copy_tofrom_user(to, from, len);
> -
> -       if ((unsigned long)from < TASK_SIZE) {
> -               over = (unsigned long)from + len - TASK_SIZE;
> -               return __copy_tofrom_user(to, from, len - over) + over;
> -       }
> -       return len;
> -}
> -
> -static inline unsigned long
> -copy_to_user(void *to, const void *from, unsigned long len)
> -{
> -       unsigned long over;
> -
> -       if (access_ok(VERIFY_WRITE, to, len))
> -               return __copy_tofrom_user(to, from, len);
> -
> -       if ((unsigned long)to < TASK_SIZE) {
> -               over = (unsigned long)to + len - TASK_SIZE;
> -               return __copy_tofrom_user(to, from, len - over) + over;
> -       }
> -       return len;
> -}
> -
> -#define __copy_from_user(to, from, len)        \
> -               __copy_tofrom_user((to), (from), (len))
> -
> -#define __copy_to_user(to, from, len)          \
> -               __copy_tofrom_user((to), (from), (len))
> -
> -static inline unsigned long
> -__copy_to_user_inatomic(void *to, const void *from, unsigned long len)
> -{
> -       return __copy_to_user(to, from, len);
> -}
> -
> -static inline unsigned long
> -__copy_from_user_inatomic(void *to, const void *from, unsigned long len)
> -{
> -       return __copy_from_user(to, from, len);
> -}
> -
> -#define __copy_in_user(to, from, len)  __copy_from_user(to, from, len)
> -
> -static inline unsigned long
> -copy_in_user(void *to, const void *from, unsigned long len)
> -{
> -       if (access_ok(VERIFY_READ, from, len) &&
> -                     access_ok(VERFITY_WRITE, to, len))
> -               return copy_from_user(to, from, len);
> -}
> -
> -/*
> - * __clear_user: - Zero a block of memory in user space, with less checking.
> - * @to:   Destination address, in user space.
> - * @n:    Number of bytes to zero.
> - *
> - * Zero a block of memory in user space.  Caller must check
> - * the specified block with access_ok() before calling this function.
> - *
> - * Returns number of bytes that could not be cleared.
> - * On success, this will be zero.
> - */
> -extern unsigned long __clear_user(void __user *src, unsigned long size);
> -
> -static inline unsigned long clear_user(char *src, unsigned long size)
> -{
> -       if (access_ok(VERIFY_WRITE, src, size))
> -               return __clear_user(src, size);
> -
> -       return -EFAULT;
> -}
> -/*
> - * __strncpy_from_user: - Copy a NUL terminated string from userspace, with less checking.
> - * @dst:   Destination address, in kernel space.  This buffer must be at
> - *         least @count bytes long.
> - * @src:   Source address, in user space.
> - * @count: Maximum number of bytes to copy, including the trailing NUL.
> - *
> - * Copies a NUL-terminated string from userspace to kernel space.
> - * Caller must check the specified block with access_ok() before calling
> - * this function.
> - *
> - * On success, returns the length of the string (not including the trailing
> - * NUL).
> - *
> - * If access to userspace fails, returns -EFAULT (some data may have been
> - * copied).
> - *
> - * If @count is smaller than the length of the string, copies @count bytes
> - * and returns @count.
> - */
> -extern int __strncpy_from_user(char *dst, const char *src, long len);
> -
> -static inline int strncpy_from_user(char *dst, const char *src, long len)
> -{
> -       if (access_ok(VERIFY_READ, src, 1))
> -               return __strncpy_from_user(dst, src, len);
> -
> -       return -EFAULT;
> -}
> -
> -extern int __strlen_user(const char *src);
> -static inline long strlen_user(const char __user *src)
> -{
> -       return __strlen_user(src);
> -}
> -
> -extern int __strnlen_user(const char *str, long len);
> -static inline long strnlen_user(const char __user *str, long len)
> -{
> -       if (!access_ok(VERIFY_READ, str, 0))
> -               return 0;
> -       else
> -               return __strnlen_user(str, len);
> -}
> -
> -struct exception_table_entry {
> -       unsigned long insn;
> -       unsigned long fixup;
> -};
> -
> -extern int fixup_exception(struct pt_regs *regs);
> -
> -#endif /* __SCORE_UACCESS_H */
> -
> diff --git a/arch/score/include/asm/ucontext.h b/arch/score/include/asm/ucontext.h
> deleted file mode 100644
> index 9bc07b9..0000000
> --- a/arch/score/include/asm/ucontext.h
> +++ /dev/null
> @@ -1 +0,0 @@
> -#include <asm-generic/ucontext.h>
> diff --git a/arch/score/include/asm/unaligned.h b/arch/score/include/asm/unaligned.h
> deleted file mode 100644
> index 2fc06de..0000000
> --- a/arch/score/include/asm/unaligned.h
> +++ /dev/null
> @@ -1,6 +0,0 @@
> -#ifndef _ASM_SCORE_UNALIGNED_H
> -#define _ASM_SCORE_UNALIGNED_H
> -
> -#include <asm-generic/unaligned.h>
> -
> -#endif /* _ASM_SCORE_UNALIGNED_H */
> diff --git a/arch/score/include/asm/user.h b/arch/score/include/asm/user.h
> deleted file mode 100644
> index 7bfb8e2..0000000
> --- a/arch/score/include/asm/user.h
> +++ /dev/null
> @@ -1,21 +0,0 @@
> -#ifndef _ASM_SCORE_USER_H
> -#define _ASM_SCORE_USER_H
> -
> -struct user_regs_struct {
> -       unsigned long regs[32];
> -
> -       unsigned long cel;
> -       unsigned long ceh;
> -
> -       unsigned long sr0;      /* cnt */
> -       unsigned long sr1;      /* lcr */
> -       unsigned long sr2;      /* scr */
> -
> -       unsigned long cp0_epc;
> -       unsigned long cp0_ema;
> -       unsigned long cp0_psr;
> -       unsigned long cp0_ecr;
> -       unsigned long cp0_condition;
> -};
> -
> -#endif /* _ASM_SCORE_USER_H */
> diff --git a/arch/score/include/uapi/asm/Kbuild b/arch/score/include/uapi/asm/Kbuild
> deleted file mode 100644
> index 040178c..0000000
> --- a/arch/score/include/uapi/asm/Kbuild
> +++ /dev/null
> @@ -1,34 +0,0 @@
> -# UAPI Header export list
> -include include/uapi/asm-generic/Kbuild.asm
> -
> -header-y += auxvec.h
> -header-y += bitsperlong.h
> -header-y += byteorder.h
> -header-y += errno.h
> -header-y += fcntl.h
> -header-y += ioctl.h
> -header-y += ioctls.h
> -header-y += ipcbuf.h
> -header-y += kvm_para.h
> -header-y += mman.h
> -header-y += msgbuf.h
> -header-y += param.h
> -header-y += poll.h
> -header-y += posix_types.h
> -header-y += ptrace.h
> -header-y += resource.h
> -header-y += sembuf.h
> -header-y += setup.h
> -header-y += shmbuf.h
> -header-y += sigcontext.h
> -header-y += siginfo.h
> -header-y += signal.h
> -header-y += socket.h
> -header-y += sockios.h
> -header-y += stat.h
> -header-y += statfs.h
> -header-y += swab.h
> -header-y += termbits.h
> -header-y += termios.h
> -header-y += types.h
> -header-y += unistd.h
> diff --git a/arch/score/include/uapi/asm/auxvec.h b/arch/score/include/uapi/asm/auxvec.h
> deleted file mode 100644
> index f691515..0000000
> --- a/arch/score/include/uapi/asm/auxvec.h
> +++ /dev/null
> @@ -1,4 +0,0 @@
> -#ifndef _ASM_SCORE_AUXVEC_H
> -#define _ASM_SCORE_AUXVEC_H
> -
> -#endif /* _ASM_SCORE_AUXVEC_H */
> diff --git a/arch/score/include/uapi/asm/bitsperlong.h b/arch/score/include/uapi/asm/bitsperlong.h
> deleted file mode 100644
> index 86ff337..0000000
> --- a/arch/score/include/uapi/asm/bitsperlong.h
> +++ /dev/null
> @@ -1,6 +0,0 @@
> -#ifndef _ASM_SCORE_BITSPERLONG_H
> -#define _ASM_SCORE_BITSPERLONG_H
> -
> -#include <asm-generic/bitsperlong.h>
> -
> -#endif /* _ASM_SCORE_BITSPERLONG_H */
> diff --git a/arch/score/include/uapi/asm/byteorder.h b/arch/score/include/uapi/asm/byteorder.h
> deleted file mode 100644
> index 88cbebc..0000000
> --- a/arch/score/include/uapi/asm/byteorder.h
> +++ /dev/null
> @@ -1,6 +0,0 @@
> -#ifndef _ASM_SCORE_BYTEORDER_H
> -#define _ASM_SCORE_BYTEORDER_H
> -
> -#include <linux/byteorder/little_endian.h>
> -
> -#endif /* _ASM_SCORE_BYTEORDER_H */
> diff --git a/arch/score/include/uapi/asm/errno.h b/arch/score/include/uapi/asm/errno.h
> deleted file mode 100644
> index 29ff39d..0000000
> --- a/arch/score/include/uapi/asm/errno.h
> +++ /dev/null
> @@ -1,6 +0,0 @@
> -#ifndef _ASM_SCORE_ERRNO_H
> -#define _ASM_SCORE_ERRNO_H
> -
> -#include <asm-generic/errno.h>
> -
> -#endif /* _ASM_SCORE_ERRNO_H */
> diff --git a/arch/score/include/uapi/asm/fcntl.h b/arch/score/include/uapi/asm/fcntl.h
> deleted file mode 100644
> index 03968a3..0000000
> --- a/arch/score/include/uapi/asm/fcntl.h
> +++ /dev/null
> @@ -1,6 +0,0 @@
> -#ifndef _ASM_SCORE_FCNTL_H
> -#define _ASM_SCORE_FCNTL_H
> -
> -#include <asm-generic/fcntl.h>
> -
> -#endif /* _ASM_SCORE_FCNTL_H */
> diff --git a/arch/score/include/uapi/asm/ioctl.h b/arch/score/include/uapi/asm/ioctl.h
> deleted file mode 100644
> index a351d21..0000000
> --- a/arch/score/include/uapi/asm/ioctl.h
> +++ /dev/null
> @@ -1,6 +0,0 @@
> -#ifndef _ASM_SCORE_IOCTL_H
> -#define _ASM_SCORE_IOCTL_H
> -
> -#include <asm-generic/ioctl.h>
> -
> -#endif /* _ASM_SCORE_IOCTL_H */
> diff --git a/arch/score/include/uapi/asm/ioctls.h b/arch/score/include/uapi/asm/ioctls.h
> deleted file mode 100644
> index ed01d2b..0000000
> --- a/arch/score/include/uapi/asm/ioctls.h
> +++ /dev/null
> @@ -1,6 +0,0 @@
> -#ifndef _ASM_SCORE_IOCTLS_H
> -#define _ASM_SCORE_IOCTLS_H
> -
> -#include <asm-generic/ioctls.h>
> -
> -#endif /* _ASM_SCORE_IOCTLS_H */
> diff --git a/arch/score/include/uapi/asm/ipcbuf.h b/arch/score/include/uapi/asm/ipcbuf.h
> deleted file mode 100644
> index e082cef..0000000
> --- a/arch/score/include/uapi/asm/ipcbuf.h
> +++ /dev/null
> @@ -1,6 +0,0 @@
> -#ifndef _ASM_SCORE_IPCBUF_H
> -#define _ASM_SCORE_IPCBUF_H
> -
> -#include <asm-generic/ipcbuf.h>
> -
> -#endif /* _ASM_SCORE_IPCBUF_H */
> diff --git a/arch/score/include/uapi/asm/kvm_para.h b/arch/score/include/uapi/asm/kvm_para.h
> deleted file mode 100644
> index 14fab8f..0000000
> --- a/arch/score/include/uapi/asm/kvm_para.h
> +++ /dev/null
> @@ -1 +0,0 @@
> -#include <asm-generic/kvm_para.h>
> diff --git a/arch/score/include/uapi/asm/mman.h b/arch/score/include/uapi/asm/mman.h
> deleted file mode 100644
> index 84d85dd..0000000
> --- a/arch/score/include/uapi/asm/mman.h
> +++ /dev/null
> @@ -1,6 +0,0 @@
> -#ifndef _ASM_SCORE_MMAN_H
> -#define _ASM_SCORE_MMAN_H
> -
> -#include <asm-generic/mman.h>
> -
> -#endif /* _ASM_SCORE_MMAN_H */
> diff --git a/arch/score/include/uapi/asm/msgbuf.h b/arch/score/include/uapi/asm/msgbuf.h
> deleted file mode 100644
> index 7506721..0000000
> --- a/arch/score/include/uapi/asm/msgbuf.h
> +++ /dev/null
> @@ -1,6 +0,0 @@
> -#ifndef _ASM_SCORE_MSGBUF_H
> -#define _ASM_SCORE_MSGBUF_H
> -
> -#include <asm-generic/msgbuf.h>
> -
> -#endif /* _ASM_SCORE_MSGBUF_H */
> diff --git a/arch/score/include/uapi/asm/param.h b/arch/score/include/uapi/asm/param.h
> deleted file mode 100644
> index 916b869..0000000
> --- a/arch/score/include/uapi/asm/param.h
> +++ /dev/null
> @@ -1,6 +0,0 @@
> -#ifndef _ASM_SCORE_PARAM_H
> -#define _ASM_SCORE_PARAM_H
> -
> -#include <asm-generic/param.h>
> -
> -#endif /* _ASM_SCORE_PARAM_H */
> diff --git a/arch/score/include/uapi/asm/poll.h b/arch/score/include/uapi/asm/poll.h
> deleted file mode 100644
> index 18532db..0000000
> --- a/arch/score/include/uapi/asm/poll.h
> +++ /dev/null
> @@ -1,6 +0,0 @@
> -#ifndef _ASM_SCORE_POLL_H
> -#define _ASM_SCORE_POLL_H
> -
> -#include <asm-generic/poll.h>
> -
> -#endif /* _ASM_SCORE_POLL_H */
> diff --git a/arch/score/include/uapi/asm/posix_types.h b/arch/score/include/uapi/asm/posix_types.h
> deleted file mode 100644
> index b88acf8..0000000
> --- a/arch/score/include/uapi/asm/posix_types.h
> +++ /dev/null
> @@ -1,6 +0,0 @@
> -#ifndef _ASM_SCORE_POSIX_TYPES_H
> -#define _ASM_SCORE_POSIX_TYPES_H
> -
> -#include <asm-generic/posix_types.h>
> -
> -#endif /* _ASM_SCORE_POSIX_TYPES_H */
> diff --git a/arch/score/include/uapi/asm/ptrace.h b/arch/score/include/uapi/asm/ptrace.h
> deleted file mode 100644
> index f59771a..0000000
> --- a/arch/score/include/uapi/asm/ptrace.h
> +++ /dev/null
> @@ -1,76 +0,0 @@
> -#ifndef _UAPI_ASM_SCORE_PTRACE_H
> -#define _UAPI_ASM_SCORE_PTRACE_H
> -
> -#define PTRACE_GETREGS         12
> -#define PTRACE_SETREGS         13
> -
> -#define PC             32
> -#define CONDITION      33
> -#define ECR            34
> -#define EMA            35
> -#define CEH            36
> -#define CEL            37
> -#define COUNTER                38
> -#define LDCR           39
> -#define STCR           40
> -#define PSR            41
> -
> -#define SINGLESTEP16_INSN      0x7006
> -#define SINGLESTEP32_INSN      0x840C8000
> -#define BREAKPOINT16_INSN      0x7002          /* work on SPG300 */
> -#define BREAKPOINT32_INSN      0x84048000      /* work on SPG300 */
> -
> -/* Define instruction mask */
> -#define INSN32_MASK    0x80008000
> -
> -#define J32    0x88008000      /* 1_00010_0000000000_1_000000000000000 */
> -#define J32M   0xFC008000      /* 1_11111_0000000000_1_000000000000000 */
> -
> -#define B32    0x90008000      /* 1_00100_0000000000_1_000000000000000 */
> -#define B32M   0xFC008000
> -#define BL32   0x90008001      /* 1_00100_0000000000_1_000000000000001 */
> -#define BL32M  B32
> -#define BR32   0x80008008      /* 1_00000_0000000000_1_00000000_000100_0 */
> -#define BR32M  0xFFE0807E
> -#define BRL32  0x80008009      /* 1_00000_0000000000_1_00000000_000100_1 */
> -#define BRL32M BR32M
> -
> -#define B32_SET        (J32 | B32 | BL32 | BR32 | BRL32)
> -
> -#define J16    0x3000          /* 0_011_....... */
> -#define J16M   0xF000
> -#define B16    0x4000          /* 0_100_....... */
> -#define B16M   0xF000
> -#define BR16   0x0004          /* 0_000.......0100 */
> -#define BR16M  0xF00F
> -#define B16_SET (J16 | B16 | BR16)
> -
> -
> -/*
> - * This struct defines the way the registers are stored on the stack during a
> - * system call/exception. As usual the registers k0/k1 aren't being saved.
> - */
> -struct pt_regs {
> -       unsigned long pad0[6];  /* stack arguments */
> -       unsigned long orig_r4;
> -       unsigned long orig_r7;
> -       long is_syscall;
> -
> -       unsigned long regs[32];
> -
> -       unsigned long cel;
> -       unsigned long ceh;
> -
> -       unsigned long sr0;      /* cnt */
> -       unsigned long sr1;      /* lcr */
> -       unsigned long sr2;      /* scr */
> -
> -       unsigned long cp0_epc;
> -       unsigned long cp0_ema;
> -       unsigned long cp0_psr;
> -       unsigned long cp0_ecr;
> -       unsigned long cp0_condition;
> -};
> -
> -
> -#endif /* _UAPI_ASM_SCORE_PTRACE_H */
> diff --git a/arch/score/include/uapi/asm/resource.h b/arch/score/include/uapi/asm/resource.h
> deleted file mode 100644
> index 9ce22bc..0000000
> --- a/arch/score/include/uapi/asm/resource.h
> +++ /dev/null
> @@ -1,6 +0,0 @@
> -#ifndef _ASM_SCORE_RESOURCE_H
> -#define _ASM_SCORE_RESOURCE_H
> -
> -#include <asm-generic/resource.h>
> -
> -#endif /* _ASM_SCORE_RESOURCE_H */
> diff --git a/arch/score/include/uapi/asm/sembuf.h b/arch/score/include/uapi/asm/sembuf.h
> deleted file mode 100644
> index dae5e83..0000000
> --- a/arch/score/include/uapi/asm/sembuf.h
> +++ /dev/null
> @@ -1,6 +0,0 @@
> -#ifndef _ASM_SCORE_SEMBUF_H
> -#define _ASM_SCORE_SEMBUF_H
> -
> -#include <asm-generic/sembuf.h>
> -
> -#endif /* _ASM_SCORE_SEMBUF_H */
> diff --git a/arch/score/include/uapi/asm/setup.h b/arch/score/include/uapi/asm/setup.h
> deleted file mode 100644
> index ab9dbdb..0000000
> --- a/arch/score/include/uapi/asm/setup.h
> +++ /dev/null
> @@ -1,9 +0,0 @@
> -#ifndef _UAPI_ASM_SCORE_SETUP_H
> -#define _UAPI_ASM_SCORE_SETUP_H
> -
> -#define COMMAND_LINE_SIZE      256
> -#define MEMORY_START           0
> -#define MEMORY_SIZE            0x2000000
> -
> -
> -#endif /* _UAPI_ASM_SCORE_SETUP_H */
> diff --git a/arch/score/include/uapi/asm/shmbuf.h b/arch/score/include/uapi/asm/shmbuf.h
> deleted file mode 100644
> index c85b242..0000000
> --- a/arch/score/include/uapi/asm/shmbuf.h
> +++ /dev/null
> @@ -1,6 +0,0 @@
> -#ifndef _ASM_SCORE_SHMBUF_H
> -#define _ASM_SCORE_SHMBUF_H
> -
> -#include <asm-generic/shmbuf.h>
> -
> -#endif /* _ASM_SCORE_SHMBUF_H */
> diff --git a/arch/score/include/uapi/asm/sigcontext.h b/arch/score/include/uapi/asm/sigcontext.h
> deleted file mode 100644
> index 5ffda39..0000000
> --- a/arch/score/include/uapi/asm/sigcontext.h
> +++ /dev/null
> @@ -1,22 +0,0 @@
> -#ifndef _ASM_SCORE_SIGCONTEXT_H
> -#define _ASM_SCORE_SIGCONTEXT_H
> -
> -/*
> - * Keep this struct definition in sync with the sigcontext fragment
> - * in arch/score/tools/offset.c
> - */
> -struct sigcontext {
> -       unsigned int            sc_regmask;
> -       unsigned int            sc_psr;
> -       unsigned int            sc_condition;
> -       unsigned long           sc_pc;
> -       unsigned long           sc_regs[32];
> -       unsigned int            sc_ssflags;
> -       unsigned int            sc_mdceh;
> -       unsigned int            sc_mdcel;
> -       unsigned int            sc_ecr;
> -       unsigned long           sc_ema;
> -       unsigned long           sc_sigset[4];
> -};
> -
> -#endif /* _ASM_SCORE_SIGCONTEXT_H */
> diff --git a/arch/score/include/uapi/asm/siginfo.h b/arch/score/include/uapi/asm/siginfo.h
> deleted file mode 100644
> index 87ca356..0000000
> --- a/arch/score/include/uapi/asm/siginfo.h
> +++ /dev/null
> @@ -1,6 +0,0 @@
> -#ifndef _ASM_SCORE_SIGINFO_H
> -#define _ASM_SCORE_SIGINFO_H
> -
> -#include <asm-generic/siginfo.h>
> -
> -#endif /* _ASM_SCORE_SIGINFO_H */
> diff --git a/arch/score/include/uapi/asm/signal.h b/arch/score/include/uapi/asm/signal.h
> deleted file mode 100644
> index 2605bc0..0000000
> --- a/arch/score/include/uapi/asm/signal.h
> +++ /dev/null
> @@ -1,6 +0,0 @@
> -#ifndef _ASM_SCORE_SIGNAL_H
> -#define _ASM_SCORE_SIGNAL_H
> -
> -#include <asm-generic/signal.h>
> -
> -#endif /* _ASM_SCORE_SIGNAL_H */
> diff --git a/arch/score/include/uapi/asm/socket.h b/arch/score/include/uapi/asm/socket.h
> deleted file mode 100644
> index 612a70e..0000000
> --- a/arch/score/include/uapi/asm/socket.h
> +++ /dev/null
> @@ -1,6 +0,0 @@
> -#ifndef _ASM_SCORE_SOCKET_H
> -#define _ASM_SCORE_SOCKET_H
> -
> -#include <asm-generic/socket.h>
> -
> -#endif /* _ASM_SCORE_SOCKET_H */
> diff --git a/arch/score/include/uapi/asm/sockios.h b/arch/score/include/uapi/asm/sockios.h
> deleted file mode 100644
> index ba825648..0000000
> --- a/arch/score/include/uapi/asm/sockios.h
> +++ /dev/null
> @@ -1,6 +0,0 @@
> -#ifndef _ASM_SCORE_SOCKIOS_H
> -#define _ASM_SCORE_SOCKIOS_H
> -
> -#include <asm-generic/sockios.h>
> -
> -#endif /* _ASM_SCORE_SOCKIOS_H */
> diff --git a/arch/score/include/uapi/asm/stat.h b/arch/score/include/uapi/asm/stat.h
> deleted file mode 100644
> index 5037055..0000000
> --- a/arch/score/include/uapi/asm/stat.h
> +++ /dev/null
> @@ -1,6 +0,0 @@
> -#ifndef _ASM_SCORE_STAT_H
> -#define _ASM_SCORE_STAT_H
> -
> -#include <asm-generic/stat.h>
> -
> -#endif /* _ASM_SCORE_STAT_H */
> diff --git a/arch/score/include/uapi/asm/statfs.h b/arch/score/include/uapi/asm/statfs.h
> deleted file mode 100644
> index 36e4100..0000000
> --- a/arch/score/include/uapi/asm/statfs.h
> +++ /dev/null
> @@ -1,6 +0,0 @@
> -#ifndef _ASM_SCORE_STATFS_H
> -#define _ASM_SCORE_STATFS_H
> -
> -#include <asm-generic/statfs.h>
> -
> -#endif /* _ASM_SCORE_STATFS_H */
> diff --git a/arch/score/include/uapi/asm/swab.h b/arch/score/include/uapi/asm/swab.h
> deleted file mode 100644
> index fadc3cc..0000000
> --- a/arch/score/include/uapi/asm/swab.h
> +++ /dev/null
> @@ -1,6 +0,0 @@
> -#ifndef _ASM_SCORE_SWAB_H
> -#define _ASM_SCORE_SWAB_H
> -
> -#include <asm-generic/swab.h>
> -
> -#endif /* _ASM_SCORE_SWAB_H */
> diff --git a/arch/score/include/uapi/asm/termbits.h b/arch/score/include/uapi/asm/termbits.h
> deleted file mode 100644
> index 9a95c14..0000000
> --- a/arch/score/include/uapi/asm/termbits.h
> +++ /dev/null
> @@ -1,6 +0,0 @@
> -#ifndef _ASM_SCORE_TERMBITS_H
> -#define _ASM_SCORE_TERMBITS_H
> -
> -#include <asm-generic/termbits.h>
> -
> -#endif /* _ASM_SCORE_TERMBITS_H */
> diff --git a/arch/score/include/uapi/asm/termios.h b/arch/score/include/uapi/asm/termios.h
> deleted file mode 100644
> index 40984e8..0000000
> --- a/arch/score/include/uapi/asm/termios.h
> +++ /dev/null
> @@ -1,6 +0,0 @@
> -#ifndef _ASM_SCORE_TERMIOS_H
> -#define _ASM_SCORE_TERMIOS_H
> -
> -#include <asm-generic/termios.h>
> -
> -#endif /* _ASM_SCORE_TERMIOS_H */
> diff --git a/arch/score/include/uapi/asm/types.h b/arch/score/include/uapi/asm/types.h
> deleted file mode 100644
> index 2140032..0000000
> --- a/arch/score/include/uapi/asm/types.h
> +++ /dev/null
> @@ -1,6 +0,0 @@
> -#ifndef _ASM_SCORE_TYPES_H
> -#define _ASM_SCORE_TYPES_H
> -
> -#include <asm-generic/types.h>
> -
> -#endif /* _ASM_SCORE_TYPES_H */
> diff --git a/arch/score/include/uapi/asm/unistd.h b/arch/score/include/uapi/asm/unistd.h
> deleted file mode 100644
> index 9cb4260..0000000
> --- a/arch/score/include/uapi/asm/unistd.h
> +++ /dev/null
> @@ -1,11 +0,0 @@
> -#define __ARCH_HAVE_MMU
> -
> -#define __ARCH_WANT_SYSCALL_NO_AT
> -#define __ARCH_WANT_SYSCALL_NO_FLAGS
> -#define __ARCH_WANT_SYSCALL_OFF_T
> -#define __ARCH_WANT_SYSCALL_DEPRECATED
> -#define __ARCH_WANT_SYS_CLONE
> -#define __ARCH_WANT_SYS_FORK
> -#define __ARCH_WANT_SYS_VFORK
> -
> -#include <asm-generic/unistd.h>
> diff --git a/arch/score/kernel/Makefile b/arch/score/kernel/Makefile
> deleted file mode 100644
> index fb1802b..0000000
> --- a/arch/score/kernel/Makefile
> +++ /dev/null
> @@ -1,11 +0,0 @@
> -#
> -# Makefile for the Linux/SCORE kernel.
> -#
> -
> -extra-y        := head.o vmlinux.lds
> -
> -obj-y += entry.o irq.o process.o ptrace.o \
> -       setup.o signal.o sys_score.o time.o traps.o \
> -       sys_call_table.o
> -
> -obj-$(CONFIG_MODULES) += module.o
> diff --git a/arch/score/kernel/asm-offsets.c b/arch/score/kernel/asm-offsets.c
> deleted file mode 100644
> index 57788f4..0000000
> --- a/arch/score/kernel/asm-offsets.c
> +++ /dev/null
> @@ -1,216 +0,0 @@
> -/*
> - * arch/score/kernel/asm-offsets.c
> - *
> - * Score Processor version.
> - *
> - * Copyright (C) 2009 Sunplus Core Technology Co., Ltd.
> - *  Chen Liqin <liqin.chen@sunplusct.com>
> - *  Lennox Wu <lennox.wu@sunplusct.com>
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
> - *
> - * This program is distributed in the hope that it will be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, see the file COPYING, or write
> - * to the Free Software Foundation, Inc.,
> - * 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> - */
> -
> -#include <linux/kbuild.h>
> -#include <linux/interrupt.h>
> -#include <linux/mm.h>
> -#include <linux/sched.h>
> -
> -#include <asm-generic/cmpxchg-local.h>
> -
> -void output_ptreg_defines(void)
> -{
> -       COMMENT("SCORE pt_regs offsets.");
> -       OFFSET(PT_R0, pt_regs, regs[0]);
> -       OFFSET(PT_R1, pt_regs, regs[1]);
> -       OFFSET(PT_R2, pt_regs, regs[2]);
> -       OFFSET(PT_R3, pt_regs, regs[3]);
> -       OFFSET(PT_R4, pt_regs, regs[4]);
> -       OFFSET(PT_R5, pt_regs, regs[5]);
> -       OFFSET(PT_R6, pt_regs, regs[6]);
> -       OFFSET(PT_R7, pt_regs, regs[7]);
> -       OFFSET(PT_R8, pt_regs, regs[8]);
> -       OFFSET(PT_R9, pt_regs, regs[9]);
> -       OFFSET(PT_R10, pt_regs, regs[10]);
> -       OFFSET(PT_R11, pt_regs, regs[11]);
> -       OFFSET(PT_R12, pt_regs, regs[12]);
> -       OFFSET(PT_R13, pt_regs, regs[13]);
> -       OFFSET(PT_R14, pt_regs, regs[14]);
> -       OFFSET(PT_R15, pt_regs, regs[15]);
> -       OFFSET(PT_R16, pt_regs, regs[16]);
> -       OFFSET(PT_R17, pt_regs, regs[17]);
> -       OFFSET(PT_R18, pt_regs, regs[18]);
> -       OFFSET(PT_R19, pt_regs, regs[19]);
> -       OFFSET(PT_R20, pt_regs, regs[20]);
> -       OFFSET(PT_R21, pt_regs, regs[21]);
> -       OFFSET(PT_R22, pt_regs, regs[22]);
> -       OFFSET(PT_R23, pt_regs, regs[23]);
> -       OFFSET(PT_R24, pt_regs, regs[24]);
> -       OFFSET(PT_R25, pt_regs, regs[25]);
> -       OFFSET(PT_R26, pt_regs, regs[26]);
> -       OFFSET(PT_R27, pt_regs, regs[27]);
> -       OFFSET(PT_R28, pt_regs, regs[28]);
> -       OFFSET(PT_R29, pt_regs, regs[29]);
> -       OFFSET(PT_R30, pt_regs, regs[30]);
> -       OFFSET(PT_R31, pt_regs, regs[31]);
> -
> -       OFFSET(PT_ORIG_R4, pt_regs, orig_r4);
> -       OFFSET(PT_ORIG_R7, pt_regs, orig_r7);
> -       OFFSET(PT_CEL, pt_regs, cel);
> -       OFFSET(PT_CEH, pt_regs, ceh);
> -       OFFSET(PT_SR0, pt_regs, sr0);
> -       OFFSET(PT_SR1, pt_regs, sr1);
> -       OFFSET(PT_SR2, pt_regs, sr2);
> -       OFFSET(PT_EPC, pt_regs, cp0_epc);
> -       OFFSET(PT_EMA, pt_regs, cp0_ema);
> -       OFFSET(PT_PSR, pt_regs, cp0_psr);
> -       OFFSET(PT_ECR, pt_regs, cp0_ecr);
> -       OFFSET(PT_CONDITION, pt_regs, cp0_condition);
> -       OFFSET(PT_IS_SYSCALL, pt_regs, is_syscall);
> -
> -       DEFINE(PT_SIZE, sizeof(struct pt_regs));
> -       BLANK();
> -}
> -
> -void output_task_defines(void)
> -{
> -       COMMENT("SCORE task_struct offsets.");
> -       OFFSET(TASK_STATE, task_struct, state);
> -       OFFSET(TASK_THREAD_INFO, task_struct, stack);
> -       OFFSET(TASK_FLAGS, task_struct, flags);
> -       OFFSET(TASK_MM, task_struct, mm);
> -       OFFSET(TASK_PID, task_struct, pid);
> -       DEFINE(TASK_STRUCT_SIZE, sizeof(struct task_struct));
> -       BLANK();
> -}
> -
> -void output_thread_info_defines(void)
> -{
> -       COMMENT("SCORE thread_info offsets.");
> -       OFFSET(TI_TASK, thread_info, task);
> -       OFFSET(TI_EXEC_DOMAIN, thread_info, exec_domain);
> -       OFFSET(TI_FLAGS, thread_info, flags);
> -       OFFSET(TI_TP_VALUE, thread_info, tp_value);
> -       OFFSET(TI_CPU, thread_info, cpu);
> -       OFFSET(TI_PRE_COUNT, thread_info, preempt_count);
> -       OFFSET(TI_ADDR_LIMIT, thread_info, addr_limit);
> -       OFFSET(TI_RESTART_BLOCK, thread_info, restart_block);
> -       OFFSET(TI_REGS, thread_info, regs);
> -       DEFINE(KERNEL_STACK_SIZE, THREAD_SIZE);
> -       DEFINE(KERNEL_STACK_MASK, THREAD_MASK);
> -       BLANK();
> -}
> -
> -void output_thread_defines(void)
> -{
> -       COMMENT("SCORE specific thread_struct offsets.");
> -       OFFSET(THREAD_REG0, task_struct, thread.reg0);
> -       OFFSET(THREAD_REG2, task_struct, thread.reg2);
> -       OFFSET(THREAD_REG3, task_struct, thread.reg3);
> -       OFFSET(THREAD_REG12, task_struct, thread.reg12);
> -       OFFSET(THREAD_REG13, task_struct, thread.reg13);
> -       OFFSET(THREAD_REG14, task_struct, thread.reg14);
> -       OFFSET(THREAD_REG15, task_struct, thread.reg15);
> -       OFFSET(THREAD_REG16, task_struct, thread.reg16);
> -       OFFSET(THREAD_REG17, task_struct, thread.reg17);
> -       OFFSET(THREAD_REG18, task_struct, thread.reg18);
> -       OFFSET(THREAD_REG19, task_struct, thread.reg19);
> -       OFFSET(THREAD_REG20, task_struct, thread.reg20);
> -       OFFSET(THREAD_REG21, task_struct, thread.reg21);
> -       OFFSET(THREAD_REG29, task_struct, thread.reg29);
> -
> -       OFFSET(THREAD_PSR, task_struct, thread.cp0_psr);
> -       OFFSET(THREAD_EMA, task_struct, thread.cp0_ema);
> -       OFFSET(THREAD_BADUADDR, task_struct, thread.cp0_baduaddr);
> -       OFFSET(THREAD_ECODE, task_struct, thread.error_code);
> -       OFFSET(THREAD_TRAPNO, task_struct, thread.trap_no);
> -       BLANK();
> -}
> -
> -void output_mm_defines(void)
> -{
> -       COMMENT("Size of struct page");
> -       DEFINE(STRUCT_PAGE_SIZE, sizeof(struct page));
> -       BLANK();
> -       COMMENT("Linux mm_struct offsets.");
> -       OFFSET(MM_USERS, mm_struct, mm_users);
> -       OFFSET(MM_PGD, mm_struct, pgd);
> -       OFFSET(MM_CONTEXT, mm_struct, context);
> -       BLANK();
> -       DEFINE(_PAGE_SIZE, PAGE_SIZE);
> -       DEFINE(_PAGE_SHIFT, PAGE_SHIFT);
> -       BLANK();
> -       DEFINE(_PGD_T_SIZE, sizeof(pgd_t));
> -       DEFINE(_PTE_T_SIZE, sizeof(pte_t));
> -       BLANK();
> -       DEFINE(_PGD_ORDER, PGD_ORDER);
> -       DEFINE(_PTE_ORDER, PTE_ORDER);
> -       BLANK();
> -       DEFINE(_PGDIR_SHIFT, PGDIR_SHIFT);
> -       BLANK();
> -       DEFINE(_PTRS_PER_PGD, PTRS_PER_PGD);
> -       DEFINE(_PTRS_PER_PTE, PTRS_PER_PTE);
> -       BLANK();
> -}
> -
> -void output_sc_defines(void)
> -{
> -       COMMENT("Linux sigcontext offsets.");
> -       OFFSET(SC_REGS, sigcontext, sc_regs);
> -       OFFSET(SC_MDCEH, sigcontext, sc_mdceh);
> -       OFFSET(SC_MDCEL, sigcontext, sc_mdcel);
> -       OFFSET(SC_PC, sigcontext, sc_pc);
> -       OFFSET(SC_PSR, sigcontext, sc_psr);
> -       OFFSET(SC_ECR, sigcontext, sc_ecr);
> -       OFFSET(SC_EMA, sigcontext, sc_ema);
> -       BLANK();
> -}
> -
> -void output_signal_defined(void)
> -{
> -       COMMENT("Linux signal numbers.");
> -       DEFINE(_SIGHUP, SIGHUP);
> -       DEFINE(_SIGINT, SIGINT);
> -       DEFINE(_SIGQUIT, SIGQUIT);
> -       DEFINE(_SIGILL, SIGILL);
> -       DEFINE(_SIGTRAP, SIGTRAP);
> -       DEFINE(_SIGIOT, SIGIOT);
> -       DEFINE(_SIGABRT, SIGABRT);
> -       DEFINE(_SIGFPE, SIGFPE);
> -       DEFINE(_SIGKILL, SIGKILL);
> -       DEFINE(_SIGBUS, SIGBUS);
> -       DEFINE(_SIGSEGV, SIGSEGV);
> -       DEFINE(_SIGSYS, SIGSYS);
> -       DEFINE(_SIGPIPE, SIGPIPE);
> -       DEFINE(_SIGALRM, SIGALRM);
> -       DEFINE(_SIGTERM, SIGTERM);
> -       DEFINE(_SIGUSR1, SIGUSR1);
> -       DEFINE(_SIGUSR2, SIGUSR2);
> -       DEFINE(_SIGCHLD, SIGCHLD);
> -       DEFINE(_SIGPWR, SIGPWR);
> -       DEFINE(_SIGWINCH, SIGWINCH);
> -       DEFINE(_SIGURG, SIGURG);
> -       DEFINE(_SIGIO, SIGIO);
> -       DEFINE(_SIGSTOP, SIGSTOP);
> -       DEFINE(_SIGTSTP, SIGTSTP);
> -       DEFINE(_SIGCONT, SIGCONT);
> -       DEFINE(_SIGTTIN, SIGTTIN);
> -       DEFINE(_SIGTTOU, SIGTTOU);
> -       DEFINE(_SIGVTALRM, SIGVTALRM);
> -       DEFINE(_SIGPROF, SIGPROF);
> -       DEFINE(_SIGXCPU, SIGXCPU);
> -       DEFINE(_SIGXFSZ, SIGXFSZ);
> -       BLANK();
> -}
> diff --git a/arch/score/kernel/entry.S b/arch/score/kernel/entry.S
> deleted file mode 100644
> index 7234ed0..0000000
> --- a/arch/score/kernel/entry.S
> +++ /dev/null
> @@ -1,493 +0,0 @@
> -/*
> - * arch/score/kernel/entry.S
> - *
> - * Score Processor version.
> - *
> - * Copyright (C) 2009 Sunplus Core Technology Co., Ltd.
> - *  Chen Liqin <liqin.chen@sunplusct.com>
> - *  Lennox Wu <lennox.wu@sunplusct.com>
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
> - *
> - * This program is distributed in the hope that it will be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, see the file COPYING, or write
> - * to the Free Software Foundation, Inc.,
> - * 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> - */
> -
> -#include <linux/err.h>
> -#include <linux/init.h>
> -#include <linux/linkage.h>
> -
> -#include <asm/asmmacro.h>
> -#include <asm/thread_info.h>
> -#include <asm/unistd.h>
> -
> -/*
> - * disable interrupts.
> - */
> -.macro disable_irq
> -       mfcr    r8, cr0
> -       srli    r8, r8, 1
> -       slli    r8, r8, 1
> -       mtcr    r8, cr0
> -       nop
> -       nop
> -       nop
> -       nop
> -       nop
> -.endm
> -
> -/*
> - * enable interrupts.
> - */
> -.macro enable_irq
> -       mfcr    r8, cr0
> -       ori     r8, 1
> -       mtcr    r8, cr0
> -       nop
> -       nop
> -       nop
> -       nop
> -       nop
> -.endm
> -
> -__INIT
> -ENTRY(debug_exception_vector)
> -       nop!
> -       nop!
> -       nop!
> -       nop!
> -       nop!
> -       nop!
> -       nop!
> -       nop!
> -
> -ENTRY(general_exception_vector)                        # should move to addr 0x200
> -       j       general_exception
> -       nop!
> -       nop!
> -       nop!
> -       nop!
> -       nop!
> -       nop!
> -
> -ENTRY(interrupt_exception_vector)              # should move to addr 0x210
> -       j       interrupt_exception
> -       nop!
> -       nop!
> -       nop!
> -       nop!
> -       nop!
> -       nop!
> -
> -       .section ".text", "ax"
> -       .align  2;
> -general_exception:
> -       mfcr    r31, cr2
> -       nop
> -       la      r30, exception_handlers
> -       andi    r31, 0x1f                       # get ecr.exc_code
> -       slli    r31, r31, 2
> -       add     r30, r30, r31
> -       lw      r30, [r30]
> -       br      r30
> -
> -interrupt_exception:
> -       SAVE_ALL
> -       mfcr    r4, cr2
> -       nop
> -       lw      r16, [r28, TI_REGS]
> -       sw      r0, [r28, TI_REGS]
> -       la      r3, ret_from_irq
> -       srli    r4, r4, 18                      # get ecr.ip[7:2], interrupt No.
> -       mv      r5, r0
> -       j       do_IRQ
> -
> -ENTRY(handle_nmi)                              # NMI #1
> -       SAVE_ALL
> -       mv      r4, r0
> -       la      r8, nmi_exception_handler
> -       brl     r8
> -       j       restore_all
> -
> -ENTRY(handle_adelinsn)                         # AdEL-instruction #2
> -       SAVE_ALL
> -       mfcr    r8, cr6
> -       nop
> -       nop
> -       sw      r8, [r0, PT_EMA]
> -       mv      r4, r0
> -       la      r8, do_adelinsn
> -       brl     r8
> -       mv      r4, r0
> -       j       ret_from_exception
> -       nop
> -
> -ENTRY(handle_ibe)                              # BusEL-instruction #5
> -       SAVE_ALL
> -       mv      r4, r0
> -       la      r8, do_be
> -       brl     r8
> -       mv      r4, r0
> -       j       ret_from_exception
> -       nop
> -
> -ENTRY(handle_pel)                              # P-EL #6
> -       SAVE_ALL
> -       mv      r4, r0
> -       la      r8, do_pel
> -       brl     r8
> -       mv      r4, r0
> -       j       ret_from_exception
> -       nop
> -
> -ENTRY(handle_ccu)                              # CCU #8
> -       SAVE_ALL
> -       mv      r4, r0
> -       la      r8, do_ccu
> -       brl     r8
> -       mv      r4, r0
> -       j       ret_from_exception
> -       nop
> -
> -ENTRY(handle_ri)                               # RI #9
> -       SAVE_ALL
> -       mv      r4, r0
> -       la      r8, do_ri
> -       brl     r8
> -       mv      r4, r0
> -       j       ret_from_exception
> -       nop
> -
> -ENTRY(handle_tr)                               # Trap #10
> -       SAVE_ALL
> -       mv      r4, r0
> -       la      r8, do_tr
> -       brl     r8
> -       mv      r4, r0
> -       j       ret_from_exception
> -       nop
> -
> -ENTRY(handle_adedata)                          # AdES-instruction #12
> -       SAVE_ALL
> -       mfcr    r8, cr6
> -       nop
> -       nop
> -       sw      r8, [r0, PT_EMA]
> -       mv      r4, r0
> -       la      r8, do_adedata
> -       brl     r8
> -       mv      r4, r0
> -       j       ret_from_exception
> -       nop
> -
> -ENTRY(handle_cee)                              # CeE #16
> -       SAVE_ALL
> -       mv      r4, r0
> -       la      r8, do_cee
> -       brl     r8
> -       mv      r4, r0
> -       j       ret_from_exception
> -       nop
> -
> -ENTRY(handle_cpe)                              # CpE #17
> -       SAVE_ALL
> -       mv      r4, r0
> -       la      r8, do_cpe
> -       brl     r8
> -       mv      r4, r0
> -       j       ret_from_exception
> -       nop
> -
> -ENTRY(handle_dbe)                              # BusEL-data #18
> -       SAVE_ALL
> -       mv      r4, r0
> -       la      r8, do_be
> -       brl     r8
> -       mv      r4, r0
> -       j       ret_from_exception
> -       nop
> -
> -ENTRY(handle_reserved)                         # others
> -       SAVE_ALL
> -       mv      r4, r0
> -       la      r8, do_reserved
> -       brl     r8
> -       mv      r4, r0
> -       j       ret_from_exception
> -       nop
> -
> -#ifndef CONFIG_PREEMPT
> -#define resume_kernel  restore_all
> -#else
> -#define __ret_from_irq ret_from_exception
> -#endif
> -
> -       .align  2
> -#ifndef CONFIG_PREEMPT
> -ENTRY(ret_from_exception)
> -       disable_irq                     # preempt stop
> -       nop
> -       j       __ret_from_irq
> -       nop
> -#endif
> -
> -ENTRY(ret_from_irq)
> -       sw      r16, [r28, TI_REGS]
> -
> -ENTRY(__ret_from_irq)
> -       lw      r8, [r0, PT_PSR]        # returning to kernel mode?
> -       andri.c r8, r8, KU_USER
> -       beq     resume_kernel
> -
> -resume_userspace:
> -       disable_irq
> -       lw      r6, [r28, TI_FLAGS]     # current->work
> -       li      r8, _TIF_WORK_MASK
> -       and.c   r8, r8, r6              # ignoring syscall_trace
> -       bne     work_pending
> -       nop
> -       j       restore_all
> -       nop
> -
> -#ifdef CONFIG_PREEMPT
> -resume_kernel:
> -       disable_irq
> -       lw      r8, [r28, TI_PRE_COUNT]
> -       cmpz.c  r8
> -       bne     r8, restore_all
> -need_resched:
> -       lw      r8, [r28, TI_FLAGS]
> -       andri.c r9, r8, _TIF_NEED_RESCHED
> -       beq     restore_all
> -       lw      r8, [r28, PT_PSR]               # Interrupts off?
> -       andri.c r8, r8, 1
> -       beq     restore_all
> -       bl      preempt_schedule_irq
> -       nop
> -       j       need_resched
> -       nop
> -#endif
> -
> -ENTRY(ret_from_kernel_thread)
> -       bl      schedule_tail                   # r4=struct task_struct *prev
> -       nop
> -       mv      r4, r13
> -       brl     r12
> -       j       syscall_exit
> -
> -ENTRY(ret_from_fork)
> -       bl      schedule_tail                   # r4=struct task_struct *prev
> -
> -ENTRY(syscall_exit)
> -       nop
> -       disable_irq
> -       lw      r6, [r28, TI_FLAGS]             # current->work
> -       li      r8, _TIF_WORK_MASK
> -       and.c   r8, r6, r8
> -       bne     syscall_exit_work
> -
> -ENTRY(restore_all)                                     # restore full frame
> -       RESTORE_ALL_AND_RET
> -
> -work_pending:
> -       andri.c r8, r6, _TIF_NEED_RESCHED # r6 is preloaded with TI_FLAGS
> -       beq     work_notifysig
> -work_resched:
> -       bl      schedule
> -       nop
> -       disable_irq
> -       lw      r6, [r28, TI_FLAGS]
> -       li      r8, _TIF_WORK_MASK
> -       and.c   r8, r6, r8      # is there any work to be done
> -                               # other than syscall tracing?
> -       beq     restore_all
> -       andri.c r8, r6, _TIF_NEED_RESCHED
> -       bne     work_resched
> -
> -work_notifysig:
> -       mv      r4, r0
> -       li      r5, 0
> -       bl      do_notify_resume        # r6 already loaded
> -       nop
> -       j       resume_userspace
> -       nop
> -
> -ENTRY(syscall_exit_work)
> -       li      r8, _TIF_SYSCALL_TRACE
> -       and.c   r8, r8, r6              # r6 is preloaded with TI_FLAGS
> -       beq     work_pending            # trace bit set?
> -       nop
> -       enable_irq
> -       mv      r4, r0
> -       li      r5, 1
> -       bl      do_syscall_trace
> -       nop
> -       b       resume_userspace
> -       nop
> -
> -.macro save_context    reg
> -       sw      r12, [\reg, THREAD_REG12];
> -       sw      r13, [\reg, THREAD_REG13];
> -       sw      r14, [\reg, THREAD_REG14];
> -       sw      r15, [\reg, THREAD_REG15];
> -       sw      r16, [\reg, THREAD_REG16];
> -       sw      r17, [\reg, THREAD_REG17];
> -       sw      r18, [\reg, THREAD_REG18];
> -       sw      r19, [\reg, THREAD_REG19];
> -       sw      r20, [\reg, THREAD_REG20];
> -       sw      r21, [\reg, THREAD_REG21];
> -       sw      r29, [\reg, THREAD_REG29];
> -       sw      r2, [\reg, THREAD_REG2];
> -       sw      r0, [\reg, THREAD_REG0]
> -.endm
> -
> -.macro restore_context reg
> -       lw      r12, [\reg, THREAD_REG12];
> -       lw      r13, [\reg, THREAD_REG13];
> -       lw      r14, [\reg, THREAD_REG14];
> -       lw      r15, [\reg, THREAD_REG15];
> -       lw      r16, [\reg, THREAD_REG16];
> -       lw      r17, [\reg, THREAD_REG17];
> -       lw      r18, [\reg, THREAD_REG18];
> -       lw      r19, [\reg, THREAD_REG19];
> -       lw      r20, [\reg, THREAD_REG20];
> -       lw      r21, [\reg, THREAD_REG21];
> -       lw      r29, [\reg, THREAD_REG29];
> -       lw      r0, [\reg, THREAD_REG0];
> -       lw      r2, [\reg, THREAD_REG2];
> -       lw      r3, [\reg, THREAD_REG3]
> -.endm
> -
> -/*
> - * task_struct *resume(task_struct *prev, task_struct *next,
> - *                     struct thread_info *next_ti)
> - */
> -ENTRY(resume)
> -       mfcr    r9, cr0
> -       nop
> -       nop
> -       sw      r9, [r4, THREAD_PSR]
> -       save_context    r4
> -       sw      r3, [r4, THREAD_REG3]
> -
> -       mv      r28, r6
> -       restore_context r5
> -       mv      r8, r6
> -       addi    r8, KERNEL_STACK_SIZE
> -       subi    r8, 32
> -       la      r9, kernelsp;
> -       sw      r8, [r9];
> -
> -       mfcr    r9, cr0
> -       ldis    r7, 0x00ff
> -       nop
> -       and     r9, r9, r7
> -       lw      r6, [r5, THREAD_PSR]
> -       not     r7, r7
> -       and     r6, r6, r7
> -       or      r6, r6, r9
> -       mtcr    r6, cr0
> -       nop; nop; nop; nop; nop
> -       br      r3
> -
> -ENTRY(handle_sys)
> -       SAVE_ALL
> -       sw      r8, [r0, 16]            # argument 5 from user r8
> -       sw      r9, [r0, 20]            # argument 6 from user r9
> -       enable_irq
> -
> -       sw      r4, [r0, PT_ORIG_R4]    #for restart syscall
> -       sw      r7, [r0, PT_ORIG_R7]    #for restart syscall
> -       sw      r27, [r0, PT_IS_SYSCALL] # it from syscall
> -
> -       lw      r9, [r0, PT_EPC]        # skip syscall on return
> -       addi    r9, 4
> -       sw      r9, [r0, PT_EPC]
> -
> -       cmpi.c  r27, __NR_syscalls      # check syscall number
> -       bgeu    illegal_syscall
> -
> -       slli    r8, r27, 2              # get syscall routine
> -       la      r11, sys_call_table
> -       add     r11, r11, r8
> -       lw      r10, [r11]              # get syscall entry
> -
> -       cmpz.c  r10
> -       beq     illegal_syscall
> -
> -       lw      r8, [r28, TI_FLAGS]
> -       li      r9, _TIF_SYSCALL_TRACE
> -       and.c   r8, r8, r9
> -       bne     syscall_trace_entry
> -
> -       brl     r10                     # Do The Real system call
> -
> -       cmpi.c  r4, 0
> -       blt     1f
> -       ldi     r8, 0
> -       sw      r8, [r0, PT_R7]
> -       b 2f
> -1:
> -       cmpi.c  r4, -MAX_ERRNO - 1
> -       ble     2f
> -       ldi     r8, 0x1;
> -       sw      r8, [r0, PT_R7]
> -       neg     r4, r4
> -2:
> -       sw      r4, [r0, PT_R4]         # save result
> -
> -syscall_return:
> -       disable_irq
> -       lw      r6, [r28, TI_FLAGS]     # current->work
> -       li      r8, _TIF_WORK_MASK
> -       and.c   r8, r6, r8
> -       bne     syscall_return_work
> -       j       restore_all
> -
> -syscall_return_work:
> -       j       syscall_exit_work
> -
> -syscall_trace_entry:
> -       mv      r16, r10
> -       mv      r4, r0
> -       li      r5, 0
> -       bl      do_syscall_trace
> -
> -       mv      r8, r16
> -       lw      r4, [r0, PT_R4]         # Restore argument registers
> -       lw      r5, [r0, PT_R5]
> -       lw      r6, [r0, PT_R6]
> -       lw      r7, [r0, PT_R7]
> -       brl     r8
> -
> -       li      r8, -MAX_ERRNO - 1
> -       sw      r8, [r0, PT_R7]         # set error flag
> -
> -       neg     r4, r4                  # error
> -       sw      r4, [r0, PT_R0]         # set flag for syscall
> -                                       # restarting
> -1:     sw      r4, [r0, PT_R2]         # result
> -       j       syscall_exit
> -
> -illegal_syscall:
> -       ldi     r4, -ENOSYS             # error
> -       sw      r4, [r0, PT_ORIG_R4]
> -       sw      r4, [r0, PT_R4]
> -       ldi     r9, 1                   # set error flag
> -       sw      r9, [r0, PT_R7]
> -       j       syscall_return
> -
> -ENTRY(sys_rt_sigreturn)
> -       mv      r4, r0
> -       la      r8, score_rt_sigreturn
> -       br      r8
> diff --git a/arch/score/kernel/head.S b/arch/score/kernel/head.S
> deleted file mode 100644
> index 22a7e3c..0000000
> --- a/arch/score/kernel/head.S
> +++ /dev/null
> @@ -1,70 +0,0 @@
> -/*
> - * arch/score/kernel/head.S
> - *
> - * Score Processor version.
> - *
> - * Copyright (C) 2009 Sunplus Core Technology Co., Ltd.
> - *  Chen Liqin <liqin.chen@sunplusct.com>
> - *  Lennox Wu <lennox.wu@sunplusct.com>
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
> - *
> - * This program is distributed in the hope that it will be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, see the file COPYING, or write
> - * to the Free Software Foundation, Inc.,
> - * 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> - */
> -#include <linux/init.h>
> -#include <linux/linkage.h>
> -
> -#include <asm/asm-offsets.h>
> -
> -       .extern start_kernel
> -       .global init_thread_union
> -       .global kernelsp
> -
> -__INIT
> -ENTRY(_stext)
> -       la      r30, __bss_start        /* initialize BSS segment. */
> -       la      r31, _end
> -       xor     r8, r8, r8
> -
> -1:     cmp.c   r31, r30
> -       beq     2f
> -
> -       sw      r8, [r30]               /* clean memory. */
> -       addi    r30, 4
> -       b       1b
> -
> -2:     la      r28, init_thread_union  /* set kernel stack. */
> -       mv      r0, r28
> -       addi    r0, KERNEL_STACK_SIZE - 32
> -       la      r30, kernelsp
> -       sw      r0, [r30]
> -       subi    r0, 4*4
> -       xor     r30, r30, r30
> -       ori     r30, 0x02               /* enable MMU. */
> -       mtcr    r30, cr4
> -       nop
> -       nop
> -       nop
> -       nop
> -       nop
> -       nop
> -       nop
> -
> -       /* there is no parameter */
> -       xor     r4, r4, r4
> -       xor     r5, r5, r5
> -       xor     r6, r6, r6
> -       xor     r7, r7, r7
> -       la      r30, start_kernel       /* jump to init_arch */
> -       br      r30
> diff --git a/arch/score/kernel/irq.c b/arch/score/kernel/irq.c
> deleted file mode 100644
> index d419673..0000000
> --- a/arch/score/kernel/irq.c
> +++ /dev/null
> @@ -1,111 +0,0 @@
> -/*
> - * arch/score/kernel/irq.c
> - *
> - * Score Processor version.
> - *
> - * Copyright (C) 2009 Sunplus Core Technology Co., Ltd.
> - *  Chen Liqin <liqin.chen@sunplusct.com>
> - *  Lennox Wu <lennox.wu@sunplusct.com>
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
> - *
> - * This program is distributed in the hope that it will be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, see the file COPYING, or write
> - * to the Free Software Foundation, Inc.,
> - * 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> - */
> -
> -#include <linux/interrupt.h>
> -#include <linux/kernel_stat.h>
> -#include <linux/seq_file.h>
> -
> -#include <asm/io.h>
> -
> -/* the interrupt controller is hardcoded at this address */
> -#define SCORE_PIC              ((u32 __iomem __force *)0x95F50000)
> -
> -#define INT_PNDL               0
> -#define INT_PNDH               1
> -#define INT_PRIORITY_M         2
> -#define INT_PRIORITY_SG0       4
> -#define INT_PRIORITY_SG1       5
> -#define INT_PRIORITY_SG2       6
> -#define INT_PRIORITY_SG3       7
> -#define INT_MASKL              8
> -#define INT_MASKH              9
> -
> -/*
> - * handles all normal device IRQs
> - */
> -asmlinkage void do_IRQ(int irq)
> -{
> -       irq_enter();
> -       generic_handle_irq(irq);
> -       irq_exit();
> -}
> -
> -static void score_mask(struct irq_data *d)
> -{
> -       unsigned int irq_source = 63 - d->irq;
> -
> -       if (irq_source < 32)
> -               __raw_writel((__raw_readl(SCORE_PIC + INT_MASKL) | \
> -                       (1 << irq_source)), SCORE_PIC + INT_MASKL);
> -       else
> -               __raw_writel((__raw_readl(SCORE_PIC + INT_MASKH) | \
> -                       (1 << (irq_source - 32))), SCORE_PIC + INT_MASKH);
> -}
> -
> -static void score_unmask(struct irq_data *d)
> -{
> -       unsigned int irq_source = 63 - d->irq;
> -
> -       if (irq_source < 32)
> -               __raw_writel((__raw_readl(SCORE_PIC + INT_MASKL) & \
> -                       ~(1 << irq_source)), SCORE_PIC + INT_MASKL);
> -       else
> -               __raw_writel((__raw_readl(SCORE_PIC + INT_MASKH) & \
> -                       ~(1 << (irq_source - 32))), SCORE_PIC + INT_MASKH);
> -}
> -
> -struct irq_chip score_irq_chip = {
> -       .name           = "Score7-level",
> -       .irq_mask       = score_mask,
> -       .irq_mask_ack   = score_mask,
> -       .irq_unmask     = score_unmask,
> -};
> -
> -/*
> - * initialise the interrupt system
> - */
> -void __init init_IRQ(void)
> -{
> -       int index;
> -       unsigned long target_addr;
> -
> -       for (index = 0; index < NR_IRQS; ++index)
> -               irq_set_chip_and_handler(index, &score_irq_chip,
> -                                        handle_level_irq);
> -
> -       for (target_addr = IRQ_VECTOR_BASE_ADDR;
> -               target_addr <= IRQ_VECTOR_END_ADDR;
> -               target_addr += IRQ_VECTOR_SIZE)
> -               memcpy((void *)target_addr, \
> -                       interrupt_exception_vector, IRQ_VECTOR_SIZE);
> -
> -       __raw_writel(0xffffffff, SCORE_PIC + INT_MASKL);
> -       __raw_writel(0xffffffff, SCORE_PIC + INT_MASKH);
> -
> -       __asm__ __volatile__(
> -               "mtcr   %0, cr3\n\t"
> -               : : "r" (EXCEPTION_VECTOR_BASE_ADDR | \
> -                       VECTOR_ADDRESS_OFFSET_MODE16));
> -}
> diff --git a/arch/score/kernel/module.c b/arch/score/kernel/module.c
> deleted file mode 100644
> index 1378d99..0000000
> --- a/arch/score/kernel/module.c
> +++ /dev/null
> @@ -1,132 +0,0 @@
> -/*
> - * arch/score/kernel/module.c
> - *
> - * Score Processor version.
> - *
> - * Copyright (C) 2009 Sunplus Core Technology Co., Ltd.
> - *  Chen Liqin <liqin.chen@sunplusct.com>
> - *  Lennox Wu <lennox.wu@sunplusct.com>
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
> - *
> - * This program is distributed in the hope that it will be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, see the file COPYING, or write
> - * to the Free Software Foundation, Inc.,
> - * 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> - */
> -
> -#include <linux/moduleloader.h>
> -#include <linux/module.h>
> -#include <linux/vmalloc.h>
> -
> -int apply_relocate(Elf_Shdr *sechdrs, const char *strtab,
> -               unsigned int symindex, unsigned int relindex,
> -               struct module *me)
> -{
> -       Elf32_Shdr *symsec = sechdrs + symindex;
> -       Elf32_Shdr *relsec = sechdrs + relindex;
> -       Elf32_Shdr *dstsec = sechdrs + relsec->sh_info;
> -       Elf32_Rel *rel = (void *)relsec->sh_addr;
> -       unsigned int i;
> -
> -       for (i = 0; i < relsec->sh_size / sizeof(Elf32_Rel); i++, rel++) {
> -               unsigned long loc;
> -               Elf32_Sym *sym;
> -               s32 r_offset;
> -
> -               r_offset = ELF32_R_SYM(rel->r_info);
> -               if ((r_offset < 0) ||
> -                   (r_offset > (symsec->sh_size / sizeof(Elf32_Sym)))) {
> -                       printk(KERN_ERR "%s: bad relocation, section %d reloc %d\n",
> -                               me->name, relindex, i);
> -                               return -ENOEXEC;
> -               }
> -
> -               sym = ((Elf32_Sym *)symsec->sh_addr) + r_offset;
> -
> -               if ((rel->r_offset < 0) ||
> -                   (rel->r_offset > dstsec->sh_size - sizeof(u32))) {
> -                       printk(KERN_ERR "%s: out of bounds relocation, "
> -                               "section %d reloc %d offset %d size %d\n",
> -                               me->name, relindex, i, rel->r_offset,
> -                               dstsec->sh_size);
> -                       return -ENOEXEC;
> -               }
> -
> -               loc = dstsec->sh_addr + rel->r_offset;
> -               switch (ELF32_R_TYPE(rel->r_info)) {
> -               case R_SCORE_NONE:
> -                       break;
> -               case R_SCORE_ABS32:
> -                       *(unsigned long *)loc += sym->st_value;
> -                       break;
> -               case R_SCORE_HI16:
> -                       break;
> -               case R_SCORE_LO16: {
> -                       unsigned long hi16_offset, offset;
> -                       unsigned long uvalue;
> -                       unsigned long temp, temp_hi;
> -                       temp_hi = *((unsigned long *)loc - 1);
> -                       temp = *(unsigned long *)loc;
> -
> -                       hi16_offset = (((((temp_hi) >> 16) & 0x3) << 15) |
> -                                       ((temp_hi) & 0x7fff)) >> 1;
> -                       offset = ((temp >> 16 & 0x03) << 15) |
> -                                       ((temp & 0x7fff) >> 1);
> -                       offset = (hi16_offset << 16) | (offset & 0xffff);
> -                       uvalue = sym->st_value + offset;
> -                       hi16_offset = (uvalue >> 16) << 1;
> -
> -                       temp_hi = ((temp_hi) & (~(0x37fff))) |
> -                                       (hi16_offset & 0x7fff) |
> -                                       ((hi16_offset << 1) & 0x30000);
> -                       *((unsigned long *)loc - 1) = temp_hi;
> -
> -                       offset = (uvalue & 0xffff) << 1;
> -                       temp = (temp & (~(0x37fff))) | (offset & 0x7fff) |
> -                               ((offset << 1) & 0x30000);
> -                       *(unsigned long *)loc = temp;
> -                       break;
> -               }
> -               case R_SCORE_24: {
> -                       unsigned long hi16_offset, offset;
> -                       unsigned long uvalue;
> -                       unsigned long temp;
> -
> -                       temp = *(unsigned long *)loc;
> -                       offset = (temp & 0x03FF7FFE);
> -                       hi16_offset = (offset & 0xFFFF0000);
> -                       offset = (hi16_offset | ((offset & 0xFFFF) << 1)) >> 2;
> -
> -                       uvalue = (sym->st_value + offset) >> 1;
> -                       uvalue = uvalue & 0x00ffffff;
> -
> -                       temp = (temp & 0xfc008001) |
> -                               ((uvalue << 2) & 0x3ff0000) |
> -                               ((uvalue & 0x3fff) << 1);
> -                       *(unsigned long *)loc = temp;
> -                       break;
> -               }
> -               default:
> -                       printk(KERN_ERR "%s: unknown relocation: %u\n",
> -                               me->name, ELF32_R_TYPE(rel->r_info));
> -                       return -ENOEXEC;
> -               }
> -       }
> -
> -       return 0;
> -}
> -
> -/* Given an address, look for it in the module exception tables. */
> -const struct exception_table_entry *search_module_dbetables(unsigned long addr)
> -{
> -       return NULL;
> -}
> diff --git a/arch/score/kernel/process.c b/arch/score/kernel/process.c
> deleted file mode 100644
> index f4c6d02..0000000
> --- a/arch/score/kernel/process.c
> +++ /dev/null
> @@ -1,123 +0,0 @@
> -/*
> - * arch/score/kernel/process.c
> - *
> - * Score Processor version.
> - *
> - * Copyright (C) 2009 Sunplus Core Technology Co., Ltd.
> - *  Chen Liqin <liqin.chen@sunplusct.com>
> - *  Lennox Wu <lennox.wu@sunplusct.com>
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
> - *
> - * This program is distributed in the hope that it will be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, see the file COPYING, or write
> - * to the Free Software Foundation, Inc.,
> - * 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> - */
> -
> -#include <linux/module.h>
> -#include <linux/reboot.h>
> -#include <linux/elfcore.h>
> -#include <linux/pm.h>
> -#include <linux/rcupdate.h>
> -
> -void (*pm_power_off)(void);
> -EXPORT_SYMBOL(pm_power_off);
> -
> -/* If or when software machine-restart is implemented, add code here. */
> -void machine_restart(char *command) {}
> -
> -/* If or when software machine-halt is implemented, add code here. */
> -void machine_halt(void) {}
> -
> -/* If or when software machine-power-off is implemented, add code here. */
> -void machine_power_off(void) {}
> -
> -void ret_from_fork(void);
> -void ret_from_kernel_thread(void);
> -
> -void start_thread(struct pt_regs *regs, unsigned long pc, unsigned long sp)
> -{
> -       unsigned long status;
> -
> -       /* New thread loses kernel privileges. */
> -       status = regs->cp0_psr & ~(KU_MASK);
> -       status |= KU_USER;
> -       regs->cp0_psr = status;
> -       regs->cp0_epc = pc;
> -       regs->regs[0] = sp;
> -}
> -
> -void exit_thread(void) {}
> -
> -/*
> - * When a process does an "exec", machine state like FPU and debug
> - * registers need to be reset.  This is a hook function for that.
> - * Currently we don't have any such state to reset, so this is empty.
> - */
> -void flush_thread(void) {}
> -
> -/*
> - * set up the kernel stack and exception frames for a new process
> - */
> -int copy_thread(unsigned long clone_flags, unsigned long usp,
> -               unsigned long arg, struct task_struct *p)
> -{
> -       struct thread_info *ti = task_thread_info(p);
> -       struct pt_regs *childregs = task_pt_regs(p);
> -       struct pt_regs *regs = current_pt_regs();
> -
> -       p->thread.reg0 = (unsigned long) childregs;
> -       if (unlikely(p->flags & PF_KTHREAD)) {
> -               memset(childregs, 0, sizeof(struct pt_regs));
> -               p->thread->reg12 = usp;
> -               p->thread->reg13 = arg;
> -               p->thread.reg3 = (unsigned long) ret_from_kernel_thread;
> -       } else {
> -               *childregs = *current_pt_regs();
> -               childregs->regs[7] = 0;         /* Clear error flag */
> -               childregs->regs[4] = 0;         /* Child gets zero as return value */
> -               if (usp)
> -                       childregs->regs[0] = usp;       /* user fork */
> -               p->thread.reg3 = (unsigned long) ret_from_fork;
> -       }
> -
> -       p->thread.cp0_psr = 0;
> -
> -       return 0;
> -}
> -
> -/* Fill in the fpu structure for a core dump. */
> -int dump_fpu(struct pt_regs *regs, elf_fpregset_t *r)
> -{
> -       return 1;
> -}
> -
> -unsigned long thread_saved_pc(struct task_struct *tsk)
> -{
> -       return task_pt_regs(tsk)->cp0_epc;
> -}
> -
> -unsigned long get_wchan(struct task_struct *task)
> -{
> -       if (!task || task == current || task->state == TASK_RUNNING)
> -               return 0;
> -
> -       if (!task_stack_page(task))
> -               return 0;
> -
> -       return task_pt_regs(task)->cp0_epc;
> -}
> -
> -unsigned long arch_align_stack(unsigned long sp)
> -{
> -       return sp;
> -}
> diff --git a/arch/score/kernel/ptrace.c b/arch/score/kernel/ptrace.c
> deleted file mode 100644
> index 5583618..0000000
> --- a/arch/score/kernel/ptrace.c
> +++ /dev/null
> @@ -1,383 +0,0 @@
> -/*
> - * arch/score/kernel/ptrace.c
> - *
> - * Score Processor version.
> - *
> - * Copyright (C) 2009 Sunplus Core Technology Co., Ltd.
> - *  Chen Liqin <liqin.chen@sunplusct.com>
> - *  Lennox Wu <lennox.wu@sunplusct.com>
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
> - *
> - * This program is distributed in the hope that it will be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, see the file COPYING, or write
> - * to the Free Software Foundation, Inc.,
> - * 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> - */
> -
> -#include <linux/elf.h>
> -#include <linux/kernel.h>
> -#include <linux/mm.h>
> -#include <linux/ptrace.h>
> -#include <linux/regset.h>
> -
> -#include <asm/uaccess.h>
> -
> -/*
> - * retrieve the contents of SCORE userspace general registers
> - */
> -static int genregs_get(struct task_struct *target,
> -                      const struct user_regset *regset,
> -                      unsigned int pos, unsigned int count,
> -                      void *kbuf, void __user *ubuf)
> -{
> -       const struct pt_regs *regs = task_pt_regs(target);
> -       int ret;
> -
> -       /* skip 9 * sizeof(unsigned long) not use for pt_regs */
> -       ret = user_regset_copyout_zero(&pos, &count, &kbuf, &ubuf,
> -                                       0, offsetof(struct pt_regs, regs));
> -
> -       /* r0 - r31, cel, ceh, sr0, sr1, sr2, epc, ema, psr, ecr, condition */
> -       ret = user_regset_copyout(&pos, &count, &kbuf, &ubuf,
> -                                 regs->regs,
> -                                 offsetof(struct pt_regs, regs),
> -                                 offsetof(struct pt_regs, cp0_condition));
> -
> -       if (!ret)
> -               ret = user_regset_copyout_zero(&pos, &count, &kbuf, &ubuf,
> -                                               sizeof(struct pt_regs), -1);
> -
> -       return ret;
> -}
> -
> -/*
> - * update the contents of the SCORE userspace general registers
> - */
> -static int genregs_set(struct task_struct *target,
> -                      const struct user_regset *regset,
> -                      unsigned int pos, unsigned int count,
> -                      const void *kbuf, const void __user *ubuf)
> -{
> -       struct pt_regs *regs = task_pt_regs(target);
> -       int ret;
> -
> -       /* skip 9 * sizeof(unsigned long) */
> -       ret = user_regset_copyin_ignore(&pos, &count, &kbuf, &ubuf,
> -                                       0, offsetof(struct pt_regs, regs));
> -
> -       /* r0 - r31, cel, ceh, sr0, sr1, sr2, epc, ema, psr, ecr, condition */
> -       ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf,
> -                                 regs->regs,
> -                                 offsetof(struct pt_regs, regs),
> -                                 offsetof(struct pt_regs, cp0_condition));
> -
> -       if (!ret)
> -               ret = user_regset_copyin_ignore(&pos, &count, &kbuf, &ubuf,
> -                                               sizeof(struct pt_regs), -1);
> -
> -       return ret;
> -}
> -
> -/*
> - * Define the register sets available on the score7 under Linux
> - */
> -enum score7_regset {
> -       REGSET_GENERAL,
> -};
> -
> -static const struct user_regset score7_regsets[] = {
> -       [REGSET_GENERAL] = {
> -               .core_note_type = NT_PRSTATUS,
> -               .n              = ELF_NGREG,
> -               .size           = sizeof(long),
> -               .align          = sizeof(long),
> -               .get            = genregs_get,
> -               .set            = genregs_set,
> -       },
> -};
> -
> -static const struct user_regset_view user_score_native_view = {
> -       .name           = "score7",
> -       .e_machine      = EM_SCORE7,
> -       .regsets        = score7_regsets,
> -       .n              = ARRAY_SIZE(score7_regsets),
> -};
> -
> -const struct user_regset_view *task_user_regset_view(struct task_struct *task)
> -{
> -       return &user_score_native_view;
> -}
> -
> -static int is_16bitinsn(unsigned long insn)
> -{
> -       if ((insn & INSN32_MASK) == INSN32_MASK)
> -               return 0;
> -       else
> -               return 1;
> -}
> -
> -int
> -read_tsk_long(struct task_struct *child,
> -               unsigned long addr, unsigned long *res)
> -{
> -       int copied;
> -
> -       copied = access_process_vm(child, addr, res, sizeof(*res), 0);
> -
> -       return copied != sizeof(*res) ? -EIO : 0;
> -}
> -
> -int
> -read_tsk_short(struct task_struct *child,
> -               unsigned long addr, unsigned short *res)
> -{
> -       int copied;
> -
> -       copied = access_process_vm(child, addr, res, sizeof(*res), 0);
> -
> -       return copied != sizeof(*res) ? -EIO : 0;
> -}
> -
> -static int
> -write_tsk_short(struct task_struct *child,
> -               unsigned long addr, unsigned short val)
> -{
> -       int copied;
> -
> -       copied = access_process_vm(child, addr, &val, sizeof(val), 1);
> -
> -       return copied != sizeof(val) ? -EIO : 0;
> -}
> -
> -static int
> -write_tsk_long(struct task_struct *child,
> -               unsigned long addr, unsigned long val)
> -{
> -       int copied;
> -
> -       copied = access_process_vm(child, addr, &val, sizeof(val), 1);
> -
> -       return copied != sizeof(val) ? -EIO : 0;
> -}
> -
> -void user_enable_single_step(struct task_struct *child)
> -{
> -       /* far_epc is the target of branch */
> -       unsigned int epc, far_epc = 0;
> -       unsigned long epc_insn, far_epc_insn;
> -       int ninsn_type;                 /* next insn type 0=16b, 1=32b */
> -       unsigned int tmp, tmp2;
> -       struct pt_regs *regs = task_pt_regs(child);
> -       child->thread.single_step = 1;
> -       child->thread.ss_nextcnt = 1;
> -       epc = regs->cp0_epc;
> -
> -       read_tsk_long(child, epc, &epc_insn);
> -
> -       if (is_16bitinsn(epc_insn)) {
> -               if ((epc_insn & J16M) == J16) {
> -                       tmp = epc_insn & 0xFFE;
> -                       epc = (epc & 0xFFFFF000) | tmp;
> -               } else if ((epc_insn & B16M) == B16) {
> -                       child->thread.ss_nextcnt = 2;
> -                       tmp = (epc_insn & 0xFF) << 1;
> -                       tmp = tmp << 23;
> -                       tmp = (unsigned int)((int) tmp >> 23);
> -                       far_epc = epc + tmp;
> -                       epc += 2;
> -               } else if ((epc_insn & BR16M) == BR16) {
> -                       child->thread.ss_nextcnt = 2;
> -                       tmp = (epc_insn >> 4) & 0xF;
> -                       far_epc = regs->regs[tmp];
> -                       epc += 2;
> -               } else
> -                       epc += 2;
> -       } else {
> -               if ((epc_insn & J32M) == J32) {
> -                       tmp = epc_insn & 0x03FFFFFE;
> -                       tmp2 = tmp & 0x7FFF;
> -                       tmp = (((tmp >> 16) & 0x3FF) << 15) | tmp2;
> -                       epc = (epc & 0xFFC00000) | tmp;
> -               } else if ((epc_insn & B32M) == B32) {
> -                       child->thread.ss_nextcnt = 2;
> -                       tmp = epc_insn & 0x03FFFFFE;    /* discard LK bit */
> -                       tmp2 = tmp & 0x3FF;
> -                       tmp = (((tmp >> 16) & 0x3FF) << 10) | tmp2; /* 20bit */
> -                       tmp = tmp << 12;
> -                       tmp = (unsigned int)((int) tmp >> 12);
> -                       far_epc = epc + tmp;
> -                       epc += 4;
> -               } else if ((epc_insn & BR32M) == BR32) {
> -                       child->thread.ss_nextcnt = 2;
> -                       tmp = (epc_insn >> 16) & 0x1F;
> -                       far_epc = regs->regs[tmp];
> -                       epc += 4;
> -               } else
> -                       epc += 4;
> -       }
> -
> -       if (child->thread.ss_nextcnt == 1) {
> -               read_tsk_long(child, epc, &epc_insn);
> -
> -               if (is_16bitinsn(epc_insn)) {
> -                       write_tsk_short(child, epc, SINGLESTEP16_INSN);
> -                       ninsn_type = 0;
> -               } else {
> -                       write_tsk_long(child, epc, SINGLESTEP32_INSN);
> -                       ninsn_type = 1;
> -               }
> -
> -               if (ninsn_type == 0) {  /* 16bits */
> -                       child->thread.insn1_type = 0;
> -                       child->thread.addr1 = epc;
> -                        /* the insn may have 32bit data */
> -                       child->thread.insn1 = (short)epc_insn;
> -               } else {
> -                       child->thread.insn1_type = 1;
> -                       child->thread.addr1 = epc;
> -                       child->thread.insn1 = epc_insn;
> -               }
> -       } else {
> -               /* branch! have two target child->thread.ss_nextcnt=2 */
> -               read_tsk_long(child, epc, &epc_insn);
> -               read_tsk_long(child, far_epc, &far_epc_insn);
> -               if (is_16bitinsn(epc_insn)) {
> -                       write_tsk_short(child, epc, SINGLESTEP16_INSN);
> -                       ninsn_type = 0;
> -               } else {
> -                       write_tsk_long(child, epc, SINGLESTEP32_INSN);
> -                       ninsn_type = 1;
> -               }
> -
> -               if (ninsn_type == 0) {  /* 16bits */
> -                       child->thread.insn1_type = 0;
> -                       child->thread.addr1 = epc;
> -                        /* the insn may have 32bit data */
> -                       child->thread.insn1 = (short)epc_insn;
> -               } else {
> -                       child->thread.insn1_type = 1;
> -                       child->thread.addr1 = epc;
> -                       child->thread.insn1 = epc_insn;
> -               }
> -
> -               if (is_16bitinsn(far_epc_insn)) {
> -                       write_tsk_short(child, far_epc, SINGLESTEP16_INSN);
> -                       ninsn_type = 0;
> -               } else {
> -                       write_tsk_long(child, far_epc, SINGLESTEP32_INSN);
> -                       ninsn_type = 1;
> -               }
> -
> -               if (ninsn_type == 0) {  /* 16bits */
> -                       child->thread.insn2_type = 0;
> -                       child->thread.addr2 = far_epc;
> -                        /* the insn may have 32bit data */
> -                       child->thread.insn2 = (short)far_epc_insn;
> -               } else {
> -                       child->thread.insn2_type = 1;
> -                       child->thread.addr2 = far_epc;
> -                       child->thread.insn2 = far_epc_insn;
> -               }
> -       }
> -}
> -
> -void user_disable_single_step(struct task_struct *child)
> -{
> -       if (child->thread.insn1_type == 0)
> -               write_tsk_short(child, child->thread.addr1,
> -                               child->thread.insn1);
> -
> -       if (child->thread.insn1_type == 1)
> -               write_tsk_long(child, child->thread.addr1,
> -                               child->thread.insn1);
> -
> -       if (child->thread.ss_nextcnt == 2) {    /* branch */
> -               if (child->thread.insn1_type == 0)
> -                       write_tsk_short(child, child->thread.addr1,
> -                                       child->thread.insn1);
> -               if (child->thread.insn1_type == 1)
> -                       write_tsk_long(child, child->thread.addr1,
> -                                       child->thread.insn1);
> -               if (child->thread.insn2_type == 0)
> -                       write_tsk_short(child, child->thread.addr2,
> -                                       child->thread.insn2);
> -               if (child->thread.insn2_type == 1)
> -                       write_tsk_long(child, child->thread.addr2,
> -                                       child->thread.insn2);
> -       }
> -
> -       child->thread.single_step = 0;
> -       child->thread.ss_nextcnt = 0;
> -}
> -
> -void ptrace_disable(struct task_struct *child)
> -{
> -       user_disable_single_step(child);
> -}
> -
> -long
> -arch_ptrace(struct task_struct *child, long request,
> -           unsigned long addr, unsigned long data)
> -{
> -       int ret;
> -       unsigned long __user *datap = (void __user *)data;
> -
> -       switch (request) {
> -       case PTRACE_GETREGS:
> -               ret = copy_regset_to_user(child, &user_score_native_view,
> -                                               REGSET_GENERAL,
> -                                               0, sizeof(struct pt_regs),
> -                                               datap);
> -               break;
> -
> -       case PTRACE_SETREGS:
> -               ret = copy_regset_from_user(child, &user_score_native_view,
> -                                               REGSET_GENERAL,
> -                                               0, sizeof(struct pt_regs),
> -                                               datap);
> -               break;
> -
> -       default:
> -               ret = ptrace_request(child, request, addr, data);
> -               break;
> -       }
> -
> -       return ret;
> -}
> -
> -/*
> - * Notification of system call entry/exit
> - * - triggered by current->work.syscall_trace
> - */
> -asmlinkage void do_syscall_trace(struct pt_regs *regs, int entryexit)
> -{
> -       if (!(current->ptrace & PT_PTRACED))
> -               return;
> -
> -       if (!test_thread_flag(TIF_SYSCALL_TRACE))
> -               return;
> -
> -       /* The 0x80 provides a way for the tracing parent to distinguish
> -          between a syscall stop and SIGTRAP delivery. */
> -       ptrace_notify(SIGTRAP | ((current->ptrace & PT_TRACESYSGOOD) ?
> -                       0x80 : 0));
> -
> -       /*
> -        * this isn't the same as continuing with a signal, but it will do
> -        * for normal use.  strace only continues with a signal if the
> -        * stopping signal is not SIGTRAP.  -brl
> -        */
> -       if (current->exit_code) {
> -               send_sig(current->exit_code, current, 1);
> -               current->exit_code = 0;
> -       }
> -}
> diff --git a/arch/score/kernel/setup.c b/arch/score/kernel/setup.c
> deleted file mode 100644
> index b48459a..0000000
> --- a/arch/score/kernel/setup.c
> +++ /dev/null
> @@ -1,162 +0,0 @@
> -/*
> - * arch/score/kernel/setup.c
> - *
> - * Score Processor version.
> - *
> - * Copyright (C) 2009 Sunplus Core Technology Co., Ltd.
> - *  Chen Liqin <liqin.chen@sunplusct.com>
> - *  Lennox Wu <lennox.wu@sunplusct.com>
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
> - *
> - * This program is distributed in the hope that it will be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, see the file COPYING, or write
> - * to the Free Software Foundation, Inc.,
> - * 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> - */
> -
> -#include <linux/bootmem.h>
> -#include <linux/initrd.h>
> -#include <linux/ioport.h>
> -#include <linux/memblock.h>
> -#include <linux/mm.h>
> -#include <linux/seq_file.h>
> -#include <linux/screen_info.h>
> -
> -#include <asm-generic/sections.h>
> -#include <asm/setup.h>
> -
> -struct screen_info screen_info;
> -unsigned long kernelsp;
> -
> -static char command_line[COMMAND_LINE_SIZE];
> -static struct resource code_resource = { .name = "Kernel code",};
> -static struct resource data_resource = { .name = "Kernel data",};
> -
> -static void __init bootmem_init(void)
> -{
> -       unsigned long start_pfn, bootmap_size;
> -       unsigned long size = initrd_end - initrd_start;
> -
> -       start_pfn = PFN_UP(__pa(&_end));
> -
> -       min_low_pfn = PFN_UP(MEMORY_START);
> -       max_low_pfn = PFN_UP(MEMORY_START + MEMORY_SIZE);
> -       max_mapnr = max_low_pfn - min_low_pfn;
> -
> -       /* Initialize the boot-time allocator with low memory only. */
> -       bootmap_size = init_bootmem_node(NODE_DATA(0), start_pfn,
> -                                        min_low_pfn, max_low_pfn);
> -       memblock_add_node(PFN_PHYS(min_low_pfn),
> -                         PFN_PHYS(max_low_pfn - min_low_pfn), 0);
> -
> -       free_bootmem(PFN_PHYS(start_pfn),
> -                    (max_low_pfn - start_pfn) << PAGE_SHIFT);
> -       memory_present(0, start_pfn, max_low_pfn);
> -
> -       /* Reserve space for the bootmem bitmap. */
> -       reserve_bootmem(PFN_PHYS(start_pfn), bootmap_size, BOOTMEM_DEFAULT);
> -
> -       if (size == 0) {
> -               printk(KERN_INFO "Initrd not found or empty");
> -               goto disable;
> -       }
> -
> -       if (__pa(initrd_end) > PFN_PHYS(max_low_pfn)) {
> -               printk(KERN_ERR "Initrd extends beyond end of memory");
> -               goto disable;
> -       }
> -
> -       /* Reserve space for the initrd bitmap. */
> -       reserve_bootmem(__pa(initrd_start), size, BOOTMEM_DEFAULT);
> -       initrd_below_start_ok = 1;
> -
> -       pr_info("Initial ramdisk at: 0x%lx (%lu bytes)\n",
> -                initrd_start, size);
> -       return;
> -disable:
> -       printk(KERN_CONT " - disabling initrd\n");
> -       initrd_start = 0;
> -       initrd_end = 0;
> -}
> -
> -static void __init resource_init(void)
> -{
> -       struct resource *res;
> -
> -       code_resource.start = __pa(&_text);
> -       code_resource.end = __pa(&_etext) - 1;
> -       data_resource.start = __pa(&_etext);
> -       data_resource.end = __pa(&_edata) - 1;
> -
> -       res = alloc_bootmem(sizeof(struct resource));
> -       res->name = "System RAM";
> -       res->start = MEMORY_START;
> -       res->end = MEMORY_START + MEMORY_SIZE - 1;
> -       res->flags = IORESOURCE_MEM | IORESOURCE_BUSY;
> -       request_resource(&iomem_resource, res);
> -
> -       request_resource(res, &code_resource);
> -       request_resource(res, &data_resource);
> -}
> -
> -void __init setup_arch(char **cmdline_p)
> -{
> -       randomize_va_space = 0;
> -       *cmdline_p = command_line;
> -
> -       cpu_cache_init();
> -       tlb_init();
> -       bootmem_init();
> -       paging_init();
> -       resource_init();
> -}
> -
> -static int show_cpuinfo(struct seq_file *m, void *v)
> -{
> -       unsigned long n = (unsigned long) v - 1;
> -
> -       seq_printf(m, "processor\t\t: %ld\n", n);
> -       seq_printf(m, "\n");
> -
> -       return 0;
> -}
> -
> -static void *c_start(struct seq_file *m, loff_t *pos)
> -{
> -       unsigned long i = *pos;
> -
> -       return i < 1 ? (void *) (i + 1) : NULL;
> -}
> -
> -static void *c_next(struct seq_file *m, void *v, loff_t *pos)
> -{
> -       ++*pos;
> -       return c_start(m, pos);
> -}
> -
> -static void c_stop(struct seq_file *m, void *v)
> -{
> -}
> -
> -const struct seq_operations cpuinfo_op = {
> -       .start  = c_start,
> -       .next   = c_next,
> -       .stop   = c_stop,
> -       .show   = show_cpuinfo,
> -};
> -
> -static int __init topology_init(void)
> -{
> -       return 0;
> -}
> -
> -subsys_initcall(topology_init);
> diff --git a/arch/score/kernel/signal.c b/arch/score/kernel/signal.c
> deleted file mode 100644
> index a00fba3..0000000
> --- a/arch/score/kernel/signal.c
> +++ /dev/null
> @@ -1,315 +0,0 @@
> -/*
> - * arch/score/kernel/signal.c
> - *
> - * Score Processor version.
> - *
> - * Copyright (C) 2009 Sunplus Core Technology Co., Ltd.
> - *  Chen Liqin <liqin.chen@sunplusct.com>
> - *  Lennox Wu <lennox.wu@sunplusct.com>
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
> - *
> - * This program is distributed in the hope that it will be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, see the file COPYING, or write
> - * to the Free Software Foundation, Inc.,
> - * 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> - */
> -
> -#include <linux/errno.h>
> -#include <linux/signal.h>
> -#include <linux/ptrace.h>
> -#include <linux/unistd.h>
> -#include <linux/uaccess.h>
> -#include <linux/tracehook.h>
> -
> -#include <asm/cacheflush.h>
> -#include <asm/syscalls.h>
> -#include <asm/ucontext.h>
> -
> -struct rt_sigframe {
> -       u32 rs_ass[4];          /* argument save space */
> -       u32 rs_code[2];         /* signal trampoline */
> -       struct siginfo rs_info;
> -       struct ucontext rs_uc;
> -};
> -
> -static int setup_sigcontext(struct pt_regs *regs, struct sigcontext __user *sc)
> -{
> -       int err = 0;
> -       unsigned long reg;
> -
> -       reg = regs->cp0_epc; err |= __put_user(reg, &sc->sc_pc);
> -       err |= __put_user(regs->cp0_psr, &sc->sc_psr);
> -       err |= __put_user(regs->cp0_condition, &sc->sc_condition);
> -
> -
> -#define save_gp_reg(i) {                               \
> -       reg = regs->regs[i];                            \
> -       err |= __put_user(reg, &sc->sc_regs[i]);        \
> -} while (0)
> -       save_gp_reg(0); save_gp_reg(1); save_gp_reg(2);
> -       save_gp_reg(3); save_gp_reg(4); save_gp_reg(5);
> -       save_gp_reg(6); save_gp_reg(7); save_gp_reg(8);
> -       save_gp_reg(9); save_gp_reg(10); save_gp_reg(11);
> -       save_gp_reg(12); save_gp_reg(13); save_gp_reg(14);
> -       save_gp_reg(15); save_gp_reg(16); save_gp_reg(17);
> -       save_gp_reg(18); save_gp_reg(19); save_gp_reg(20);
> -       save_gp_reg(21); save_gp_reg(22); save_gp_reg(23);
> -       save_gp_reg(24); save_gp_reg(25); save_gp_reg(26);
> -       save_gp_reg(27); save_gp_reg(28); save_gp_reg(29);
> -#undef save_gp_reg
> -
> -       reg = regs->ceh; err |= __put_user(reg, &sc->sc_mdceh);
> -       reg = regs->cel; err |= __put_user(reg, &sc->sc_mdcel);
> -       err |= __put_user(regs->cp0_ecr, &sc->sc_ecr);
> -       err |= __put_user(regs->cp0_ema, &sc->sc_ema);
> -
> -       return err;
> -}
> -
> -static int restore_sigcontext(struct pt_regs *regs, struct sigcontext __user *sc)
> -{
> -       int err = 0;
> -       u32 reg;
> -
> -       err |= __get_user(regs->cp0_epc, &sc->sc_pc);
> -       err |= __get_user(regs->cp0_condition, &sc->sc_condition);
> -
> -       err |= __get_user(reg, &sc->sc_mdceh);
> -       regs->ceh = (int) reg;
> -       err |= __get_user(reg, &sc->sc_mdcel);
> -       regs->cel = (int) reg;
> -
> -       err |= __get_user(reg, &sc->sc_psr);
> -       regs->cp0_psr = (int) reg;
> -       err |= __get_user(reg, &sc->sc_ecr);
> -       regs->cp0_ecr = (int) reg;
> -       err |= __get_user(reg, &sc->sc_ema);
> -       regs->cp0_ema = (int) reg;
> -
> -#define restore_gp_reg(i) do {                         \
> -       err |= __get_user(reg, &sc->sc_regs[i]);        \
> -       regs->regs[i] = reg;                            \
> -} while (0)
> -       restore_gp_reg(0); restore_gp_reg(1); restore_gp_reg(2);
> -       restore_gp_reg(3); restore_gp_reg(4); restore_gp_reg(5);
> -       restore_gp_reg(6); restore_gp_reg(7); restore_gp_reg(8);
> -       restore_gp_reg(9); restore_gp_reg(10); restore_gp_reg(11);
> -       restore_gp_reg(12); restore_gp_reg(13); restore_gp_reg(14);
> -       restore_gp_reg(15); restore_gp_reg(16); restore_gp_reg(17);
> -       restore_gp_reg(18); restore_gp_reg(19); restore_gp_reg(20);
> -       restore_gp_reg(21); restore_gp_reg(22); restore_gp_reg(23);
> -       restore_gp_reg(24); restore_gp_reg(25); restore_gp_reg(26);
> -       restore_gp_reg(27); restore_gp_reg(28); restore_gp_reg(29);
> -#undef restore_gp_reg
> -
> -       return err;
> -}
> -
> -/*
> - * Determine which stack to use..
> - */
> -static void __user *get_sigframe(struct k_sigaction *ka,
> -                       struct pt_regs *regs, size_t frame_size)
> -{
> -       unsigned long sp;
> -
> -       /* Default to using normal stack */
> -       sp = regs->regs[0];
> -       sp -= 32;
> -
> -       /* This is the X/Open sanctioned signal stack switching.  */
> -       if ((ka->sa.sa_flags & SA_ONSTACK) && (!on_sig_stack(sp)))
> -               sp = current->sas_ss_sp + current->sas_ss_size;
> -
> -       return (void __user*)((sp - frame_size) & ~7);
> -}
> -
> -asmlinkage long
> -score_rt_sigreturn(struct pt_regs *regs)
> -{
> -       struct rt_sigframe __user *frame;
> -       sigset_t set;
> -       int sig;
> -
> -       /* Always make any pending restarted system calls return -EINTR */
> -       current_thread_info()->restart_block.fn = do_no_restart_syscall;
> -
> -       frame = (struct rt_sigframe __user *) regs->regs[0];
> -       if (!access_ok(VERIFY_READ, frame, sizeof(*frame)))
> -               goto badframe;
> -       if (__copy_from_user(&set, &frame->rs_uc.uc_sigmask, sizeof(set)))
> -               goto badframe;
> -
> -       set_current_blocked(&set);
> -
> -       sig = restore_sigcontext(regs, &frame->rs_uc.uc_mcontext);
> -       if (sig < 0)
> -               goto badframe;
> -       else if (sig)
> -               force_sig(sig, current);
> -
> -       if (restore_altstack(&frame->rs_uc.uc_stack))
> -               goto badframe;
> -       regs->is_syscall = 0;
> -
> -       __asm__ __volatile__(
> -               "mv\tr0, %0\n\t"
> -               "la\tr8, syscall_exit\n\t"
> -               "br\tr8\n\t"
> -               : : "r" (regs) : "r8");
> -
> -badframe:
> -       force_sig(SIGSEGV, current);
> -
> -       return 0;
> -}
> -
> -static int setup_rt_frame(struct k_sigaction *ka, struct pt_regs *regs,
> -               int signr, sigset_t *set, siginfo_t *info)
> -{
> -       struct rt_sigframe __user *frame;
> -       int err = 0;
> -
> -       frame = get_sigframe(ka, regs, sizeof(*frame));
> -       if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
> -               goto give_sigsegv;
> -
> -       /*
> -        * Set up the return code ...
> -        *
> -        *         li      v0, __NR_rt_sigreturn
> -        *         syscall
> -        */
> -       err |= __put_user(0x87788000 + __NR_rt_sigreturn*2,
> -                       frame->rs_code + 0);
> -       err |= __put_user(0x80008002, frame->rs_code + 1);
> -       flush_cache_sigtramp((unsigned long) frame->rs_code);
> -
> -       err |= copy_siginfo_to_user(&frame->rs_info, info);
> -       err |= __put_user(0, &frame->rs_uc.uc_flags);
> -       err |= __put_user(NULL, &frame->rs_uc.uc_link);
> -       err |= __save_altstack(&frame->rs_uc.uc_stack, regs->regs[0]);
> -       err |= setup_sigcontext(regs, &frame->rs_uc.uc_mcontext);
> -       err |= __copy_to_user(&frame->rs_uc.uc_sigmask, set, sizeof(*set));
> -
> -       if (err)
> -               goto give_sigsegv;
> -
> -       regs->regs[0] = (unsigned long) frame;
> -       regs->regs[3] = (unsigned long) frame->rs_code;
> -       regs->regs[4] = signr;
> -       regs->regs[5] = (unsigned long) &frame->rs_info;
> -       regs->regs[6] = (unsigned long) &frame->rs_uc;
> -       regs->regs[29] = (unsigned long) ka->sa.sa_handler;
> -       regs->cp0_epc = (unsigned long) ka->sa.sa_handler;
> -
> -       return 0;
> -
> -give_sigsegv:
> -       force_sigsegv(signr, current);
> -       return -EFAULT;
> -}
> -
> -static void handle_signal(unsigned long sig, siginfo_t *info,
> -       struct k_sigaction *ka, struct pt_regs *regs)
> -{
> -       if (regs->is_syscall) {
> -               switch (regs->regs[4]) {
> -               case ERESTART_RESTARTBLOCK:
> -               case ERESTARTNOHAND:
> -                       regs->regs[4] = EINTR;
> -                       break;
> -               case ERESTARTSYS:
> -                       if (!(ka->sa.sa_flags & SA_RESTART)) {
> -                               regs->regs[4] = EINTR;
> -                               break;
> -                       }
> -               case ERESTARTNOINTR:
> -                       regs->regs[4] = regs->orig_r4;
> -                       regs->regs[7] = regs->orig_r7;
> -                       regs->cp0_epc -= 8;
> -               }
> -
> -               regs->is_syscall = 0;
> -       }
> -
> -       /*
> -        * Set up the stack frame
> -        */
> -       if (setup_rt_frame(ka, regs, sig, sigmask_to_save(), info) < 0)
> -               return;
> -
> -       signal_delivered(sig, info, ka, regs, 0);
> -}
> -
> -static void do_signal(struct pt_regs *regs)
> -{
> -       struct k_sigaction ka;
> -       siginfo_t info;
> -       int signr;
> -
> -       /*
> -        * We want the common case to go fast, which is why we may in certain
> -        * cases get here from kernel mode. Just return without doing anything
> -        * if so.
> -        */
> -       if (!user_mode(regs))
> -               return;
> -
> -       signr = get_signal_to_deliver(&info, &ka, regs, NULL);
> -       if (signr > 0) {
> -               /* Actually deliver the signal.  */
> -               handle_signal(signr, &info, &ka, regs);
> -               return;
> -       }
> -
> -       if (regs->is_syscall) {
> -               if (regs->regs[4] == ERESTARTNOHAND ||
> -                   regs->regs[4] == ERESTARTSYS ||
> -                   regs->regs[4] == ERESTARTNOINTR) {
> -                       regs->regs[4] = regs->orig_r4;
> -                       regs->regs[7] = regs->orig_r7;
> -                       regs->cp0_epc -= 8;
> -               }
> -
> -               if (regs->regs[4] == ERESTART_RESTARTBLOCK) {
> -                       regs->regs[27] = __NR_restart_syscall;
> -                       regs->regs[4] = regs->orig_r4;
> -                       regs->regs[7] = regs->orig_r7;
> -                       regs->cp0_epc -= 8;
> -               }
> -
> -               regs->is_syscall = 0;   /* Don't deal with this again.  */
> -       }
> -
> -       /*
> -        * If there's no signal to deliver, we just put the saved sigmask
> -        * back
> -        */
> -       restore_saved_sigmask();
> -}
> -
> -/*
> - * notification of userspace execution resumption
> - * - triggered by the TIF_WORK_MASK flags
> - */
> -asmlinkage void do_notify_resume(struct pt_regs *regs, void *unused,
> -                               __u32 thread_info_flags)
> -{
> -       /* deal with pending signal delivery */
> -       if (thread_info_flags & _TIF_SIGPENDING)
> -               do_signal(regs);
> -       if (thread_info_flags & _TIF_NOTIFY_RESUME) {
> -               clear_thread_flag(TIF_NOTIFY_RESUME);
> -               tracehook_notify_resume(regs);
> -       }
> -}
> diff --git a/arch/score/kernel/sys_call_table.c b/arch/score/kernel/sys_call_table.c
> deleted file mode 100644
> index 287369b..0000000
> --- a/arch/score/kernel/sys_call_table.c
> +++ /dev/null
> @@ -1,12 +0,0 @@
> -#include <linux/syscalls.h>
> -#include <linux/signal.h>
> -#include <linux/unistd.h>
> -
> -#include <asm/syscalls.h>
> -
> -#undef __SYSCALL
> -#define __SYSCALL(nr, call) [nr] = (call),
> -
> -void *sys_call_table[__NR_syscalls] = {
> -#include <asm/unistd.h>
> -};
> diff --git a/arch/score/kernel/sys_score.c b/arch/score/kernel/sys_score.c
> deleted file mode 100644
> index 47c20ba..0000000
> --- a/arch/score/kernel/sys_score.c
> +++ /dev/null
> @@ -1,50 +0,0 @@
> -/*
> - * arch/score/kernel/syscall.c
> - *
> - * Score Processor version.
> - *
> - * Copyright (C) 2009 Sunplus Core Technology Co., Ltd.
> - *  Chen Liqin <liqin.chen@sunplusct.com>
> - *  Lennox Wu <lennox.wu@sunplusct.com>
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
> - *
> - * This program is distributed in the hope that it will be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, see the file COPYING, or write
> - * to the Free Software Foundation, Inc.,
> - * 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> - */
> -
> -#include <linux/file.h>
> -#include <linux/fs.h>
> -#include <linux/mm.h>
> -#include <linux/mman.h>
> -#include <linux/module.h>
> -#include <linux/slab.h>
> -#include <linux/unistd.h>
> -#include <linux/syscalls.h>
> -#include <asm/syscalls.h>
> -
> -asmlinkage long
> -sys_mmap2(unsigned long addr, unsigned long len, unsigned long prot,
> -         unsigned long flags, unsigned long fd, unsigned long pgoff)
> -{
> -       return sys_mmap_pgoff(addr, len, prot, flags, fd, pgoff);
> -}
> -
> -asmlinkage long
> -sys_mmap(unsigned long addr, unsigned long len, unsigned long prot,
> -       unsigned long flags, unsigned long fd, off_t offset)
> -{
> -       if (unlikely(offset & ~PAGE_MASK))
> -               return -EINVAL;
> -       return sys_mmap_pgoff(addr, len, prot, flags, fd, offset >> PAGE_SHIFT);
> -}
> diff --git a/arch/score/kernel/time.c b/arch/score/kernel/time.c
> deleted file mode 100644
> index f0a43aff..0000000
> --- a/arch/score/kernel/time.c
> +++ /dev/null
> @@ -1,99 +0,0 @@
> -/*
> - * arch/score/kernel/time.c
> - *
> - * Score Processor version.
> - *
> - * Copyright (C) 2009 Sunplus Core Technology Co., Ltd.
> - *  Chen Liqin <liqin.chen@sunplusct.com>
> - *  Lennox Wu <lennox.wu@sunplusct.com>
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
> - *
> - * This program is distributed in the hope that it will be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, see the file COPYING, or write
> - * to the Free Software Foundation, Inc.,
> - * 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> - */
> -
> -#include <linux/clockchips.h>
> -#include <linux/interrupt.h>
> -
> -#include <asm/scoreregs.h>
> -
> -static irqreturn_t timer_interrupt(int irq, void *dev_id)
> -{
> -       struct clock_event_device *evdev = dev_id;
> -
> -       /* clear timer interrupt flag */
> -       outl(1, P_TIMER0_CPP_REG);
> -       evdev->event_handler(evdev);
> -
> -       return IRQ_HANDLED;
> -}
> -
> -static struct irqaction timer_irq = {
> -       .handler = timer_interrupt,
> -       .flags = IRQF_DISABLED | IRQF_TIMER,
> -       .name = "timer",
> -};
> -
> -static int score_timer_set_next_event(unsigned long delta,
> -               struct clock_event_device *evdev)
> -{
> -       outl((TMR_M_PERIODIC | TMR_IE_ENABLE), P_TIMER0_CTRL);
> -       outl(delta, P_TIMER0_PRELOAD);
> -       outl(inl(P_TIMER0_CTRL) | TMR_ENABLE, P_TIMER0_CTRL);
> -
> -       return 0;
> -}
> -
> -static void score_timer_set_mode(enum clock_event_mode mode,
> -               struct clock_event_device *evdev)
> -{
> -       switch (mode) {
> -       case CLOCK_EVT_MODE_PERIODIC:
> -               outl((TMR_M_PERIODIC | TMR_IE_ENABLE), P_TIMER0_CTRL);
> -               outl(SYSTEM_CLOCK/HZ, P_TIMER0_PRELOAD);
> -               outl(inl(P_TIMER0_CTRL) | TMR_ENABLE, P_TIMER0_CTRL);
> -               break;
> -       case CLOCK_EVT_MODE_ONESHOT:
> -       case CLOCK_EVT_MODE_SHUTDOWN:
> -       case CLOCK_EVT_MODE_RESUME:
> -       case CLOCK_EVT_MODE_UNUSED:
> -               break;
> -       default:
> -               BUG();
> -       }
> -}
> -
> -static struct clock_event_device score_clockevent = {
> -       .name           = "score_clockevent",
> -       .features       = CLOCK_EVT_FEAT_PERIODIC,
> -       .shift          = 16,
> -       .set_next_event = score_timer_set_next_event,
> -       .set_mode       = score_timer_set_mode,
> -};
> -
> -void __init time_init(void)
> -{
> -       timer_irq.dev_id = &score_clockevent;
> -       setup_irq(IRQ_TIMER , &timer_irq);
> -
> -       /* setup COMPARE clockevent */
> -       score_clockevent.mult = div_sc(SYSTEM_CLOCK, NSEC_PER_SEC,
> -                                       score_clockevent.shift);
> -       score_clockevent.max_delta_ns = clockevent_delta2ns((u32)~0,
> -                                       &score_clockevent);
> -       score_clockevent.min_delta_ns = clockevent_delta2ns(50,
> -                                               &score_clockevent) + 1;
> -       score_clockevent.cpumask = cpumask_of(0);
> -       clockevents_register_device(&score_clockevent);
> -}
> diff --git a/arch/score/kernel/traps.c b/arch/score/kernel/traps.c
> deleted file mode 100644
> index 1517a7d..0000000
> --- a/arch/score/kernel/traps.c
> +++ /dev/null
> @@ -1,341 +0,0 @@
> -/*
> - * arch/score/kernel/traps.c
> - *
> - * Score Processor version.
> - *
> - * Copyright (C) 2009 Sunplus Core Technology Co., Ltd.
> - *  Chen Liqin <liqin.chen@sunplusct.com>
> - *  Lennox Wu <lennox.wu@sunplusct.com>
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
> - *
> - * This program is distributed in the hope that it will be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, see the file COPYING, or write
> - * to the Free Software Foundation, Inc.,
> - * 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> - */
> -
> -#include <linux/module.h>
> -#include <linux/sched.h>
> -
> -#include <asm/cacheflush.h>
> -#include <asm/irq.h>
> -#include <asm/irq_regs.h>
> -
> -unsigned long exception_handlers[32];
> -
> -/*
> - * The architecture-independent show_stack generator
> - */
> -void show_stack(struct task_struct *task, unsigned long *sp)
> -{
> -       int i;
> -       long stackdata;
> -
> -       sp = sp ? sp : (unsigned long *)&sp;
> -
> -       printk(KERN_NOTICE "Stack: ");
> -       i = 1;
> -       while ((long) sp & (PAGE_SIZE - 1)) {
> -               if (i && ((i % 8) == 0))
> -                       printk(KERN_NOTICE "\n");
> -               if (i > 40) {
> -                       printk(KERN_NOTICE " ...");
> -                       break;
> -               }
> -
> -               if (__get_user(stackdata, sp++)) {
> -                       printk(KERN_NOTICE " (Bad stack address)");
> -                       break;
> -               }
> -
> -               printk(KERN_NOTICE " %08lx", stackdata);
> -               i++;
> -       }
> -       printk(KERN_NOTICE "\n");
> -}
> -
> -static void show_trace(long *sp)
> -{
> -       int i;
> -       long addr;
> -
> -       sp = sp ? sp : (long *) &sp;
> -
> -       printk(KERN_NOTICE "Call Trace:  ");
> -       i = 1;
> -       while ((long) sp & (PAGE_SIZE - 1)) {
> -               if (__get_user(addr, sp++)) {
> -                       if (i && ((i % 6) == 0))
> -                               printk(KERN_NOTICE "\n");
> -                       printk(KERN_NOTICE " (Bad stack address)\n");
> -                       break;
> -               }
> -
> -               if (kernel_text_address(addr)) {
> -                       if (i && ((i % 6) == 0))
> -                               printk(KERN_NOTICE "\n");
> -                       if (i > 40) {
> -                               printk(KERN_NOTICE " ...");
> -                               break;
> -                       }
> -
> -                       printk(KERN_NOTICE " [<%08lx>]", addr);
> -                       i++;
> -               }
> -       }
> -       printk(KERN_NOTICE "\n");
> -}
> -
> -static void show_code(unsigned int *pc)
> -{
> -       long i;
> -
> -       printk(KERN_NOTICE "\nCode:");
> -
> -       for (i = -3; i < 6; i++) {
> -               unsigned long insn;
> -               if (__get_user(insn, pc + i)) {
> -                       printk(KERN_NOTICE " (Bad address in epc)\n");
> -                       break;
> -               }
> -               printk(KERN_NOTICE "%c%08lx%c", (i ? ' ' : '<'),
> -                       insn, (i ? ' ' : '>'));
> -       }
> -}
> -
> -/*
> - * FIXME: really the generic show_regs should take a const pointer argument.
> - */
> -void show_regs(struct pt_regs *regs)
> -{
> -       show_regs_print_info(KERN_DEFAULT);
> -
> -       printk("r0 : %08lx %08lx %08lx %08lx %08lx %08lx %08lx %08lx\n",
> -               regs->regs[0], regs->regs[1], regs->regs[2], regs->regs[3],
> -               regs->regs[4], regs->regs[5], regs->regs[6], regs->regs[7]);
> -       printk("r8 : %08lx %08lx %08lx %08lx %08lx %08lx %08lx %08lx\n",
> -               regs->regs[8], regs->regs[9], regs->regs[10], regs->regs[11],
> -               regs->regs[12], regs->regs[13], regs->regs[14], regs->regs[15]);
> -       printk("r16: %08lx %08lx %08lx %08lx %08lx %08lx %08lx %08lx\n",
> -               regs->regs[16], regs->regs[17], regs->regs[18], regs->regs[19],
> -               regs->regs[20], regs->regs[21], regs->regs[22], regs->regs[23]);
> -       printk("r24: %08lx %08lx %08lx %08lx %08lx %08lx %08lx %08lx\n",
> -               regs->regs[24], regs->regs[25], regs->regs[26], regs->regs[27],
> -               regs->regs[28], regs->regs[29], regs->regs[30], regs->regs[31]);
> -
> -       printk("CEH : %08lx\n", regs->ceh);
> -       printk("CEL : %08lx\n", regs->cel);
> -
> -       printk("EMA:%08lx, epc:%08lx %s\nPSR: %08lx\nECR:%08lx\nCondition : %08lx\n",
> -               regs->cp0_ema, regs->cp0_epc, print_tainted(), regs->cp0_psr,
> -               regs->cp0_ecr, regs->cp0_condition);
> -}
> -
> -static void show_registers(struct pt_regs *regs)
> -{
> -       show_regs(regs);
> -       printk(KERN_NOTICE "Process %s (pid: %d, stackpage=%08lx)\n",
> -               current->comm, current->pid, (unsigned long) current);
> -       show_stack(current_thread_info()->task, (long *) regs->regs[0]);
> -       show_trace((long *) regs->regs[0]);
> -       show_code((unsigned int *) regs->cp0_epc);
> -       printk(KERN_NOTICE "\n");
> -}
> -
> -void __die(const char *str, struct pt_regs *regs, const char *file,
> -       const char *func, unsigned long line)
> -{
> -       console_verbose();
> -       printk("%s", str);
> -       if (file && func)
> -               printk(" in %s:%s, line %ld", file, func, line);
> -       printk(":\n");
> -       show_registers(regs);
> -       do_exit(SIGSEGV);
> -}
> -
> -void __die_if_kernel(const char *str, struct pt_regs *regs,
> -               const char *file, const char *func, unsigned long line)
> -{
> -       if (!user_mode(regs))
> -               __die(str, regs, file, func, line);
> -}
> -
> -asmlinkage void do_adelinsn(struct pt_regs *regs)
> -{
> -       printk("do_ADE-linsn:ema:0x%08lx:epc:0x%08lx\n",
> -                regs->cp0_ema, regs->cp0_epc);
> -       die_if_kernel("do_ade execution Exception\n", regs);
> -       force_sig(SIGBUS, current);
> -}
> -
> -asmlinkage void do_adedata(struct pt_regs *regs)
> -{
> -       const struct exception_table_entry *fixup;
> -       fixup = search_exception_tables(regs->cp0_epc);
> -       if (fixup) {
> -               regs->cp0_epc = fixup->fixup;
> -               return;
> -       }
> -       printk("do_ADE-data:ema:0x%08lx:epc:0x%08lx\n",
> -                regs->cp0_ema, regs->cp0_epc);
> -       die_if_kernel("do_ade execution Exception\n", regs);
> -       force_sig(SIGBUS, current);
> -}
> -
> -asmlinkage void do_pel(struct pt_regs *regs)
> -{
> -       die_if_kernel("do_pel execution Exception", regs);
> -       force_sig(SIGFPE, current);
> -}
> -
> -asmlinkage void do_cee(struct pt_regs *regs)
> -{
> -       die_if_kernel("do_cee execution Exception", regs);
> -       force_sig(SIGFPE, current);
> -}
> -
> -asmlinkage void do_cpe(struct pt_regs *regs)
> -{
> -       die_if_kernel("do_cpe execution Exception", regs);
> -       force_sig(SIGFPE, current);
> -}
> -
> -asmlinkage void do_be(struct pt_regs *regs)
> -{
> -       die_if_kernel("do_be execution Exception", regs);
> -       force_sig(SIGBUS, current);
> -}
> -
> -asmlinkage void do_ov(struct pt_regs *regs)
> -{
> -       siginfo_t info;
> -
> -       die_if_kernel("do_ov execution Exception", regs);
> -
> -       info.si_code = FPE_INTOVF;
> -       info.si_signo = SIGFPE;
> -       info.si_errno = 0;
> -       info.si_addr = (void *)regs->cp0_epc;
> -       force_sig_info(SIGFPE, &info, current);
> -}
> -
> -asmlinkage void do_tr(struct pt_regs *regs)
> -{
> -       die_if_kernel("do_tr execution Exception", regs);
> -       force_sig(SIGTRAP, current);
> -}
> -
> -asmlinkage void do_ri(struct pt_regs *regs)
> -{
> -       unsigned long epc_insn;
> -       unsigned long epc = regs->cp0_epc;
> -
> -       read_tsk_long(current, epc, &epc_insn);
> -       if (current->thread.single_step == 1) {
> -               if ((epc == current->thread.addr1) ||
> -                   (epc == current->thread.addr2)) {
> -                       user_disable_single_step(current);
> -                       force_sig(SIGTRAP, current);
> -                       return;
> -               } else
> -                       BUG();
> -       } else if ((epc_insn == BREAKPOINT32_INSN) ||
> -                  ((epc_insn & 0x0000FFFF) == 0x7002) ||
> -                  ((epc_insn & 0xFFFF0000) == 0x70020000)) {
> -                       force_sig(SIGTRAP, current);
> -                       return;
> -       } else {
> -               die_if_kernel("do_ri execution Exception", regs);
> -               force_sig(SIGILL, current);
> -       }
> -}
> -
> -asmlinkage void do_ccu(struct pt_regs *regs)
> -{
> -       die_if_kernel("do_ccu execution Exception", regs);
> -       force_sig(SIGILL, current);
> -}
> -
> -asmlinkage void do_reserved(struct pt_regs *regs)
> -{
> -       /*
> -        * Game over - no way to handle this if it ever occurs.  Most probably
> -        * caused by a new unknown cpu type or after another deadly
> -        * hard/software error.
> -        */
> -       die_if_kernel("do_reserved execution Exception", regs);
> -       show_regs(regs);
> -       panic("Caught reserved exception - should not happen.");
> -}
> -
> -/*
> - * NMI exception handler.
> - */
> -void nmi_exception_handler(struct pt_regs *regs)
> -{
> -       die_if_kernel("nmi_exception_handler execution Exception", regs);
> -       die("NMI", regs);
> -}
> -
> -/* Install CPU exception handler */
> -void *set_except_vector(int n, void *addr)
> -{
> -       unsigned long handler = (unsigned long) addr;
> -       unsigned long old_handler = exception_handlers[n];
> -
> -       exception_handlers[n] = handler;
> -       return (void *)old_handler;
> -}
> -
> -void __init trap_init(void)
> -{
> -       int i;
> -
> -       pgd_current = (unsigned long)init_mm.pgd;
> -       /* DEBUG EXCEPTION */
> -       memcpy((void *)DEBUG_VECTOR_BASE_ADDR,
> -                       &debug_exception_vector, DEBUG_VECTOR_SIZE);
> -       /* NMI EXCEPTION */
> -       memcpy((void *)GENERAL_VECTOR_BASE_ADDR,
> -                       &general_exception_vector, GENERAL_VECTOR_SIZE);
> -
> -       /*
> -        * Initialise exception handlers
> -        */
> -       for (i = 0; i <= 31; i++)
> -               set_except_vector(i, handle_reserved);
> -
> -       set_except_vector(1, handle_nmi);
> -       set_except_vector(2, handle_adelinsn);
> -       set_except_vector(3, handle_tlb_refill);
> -       set_except_vector(4, handle_tlb_invaild);
> -       set_except_vector(5, handle_ibe);
> -       set_except_vector(6, handle_pel);
> -       set_except_vector(7, handle_sys);
> -       set_except_vector(8, handle_ccu);
> -       set_except_vector(9, handle_ri);
> -       set_except_vector(10, handle_tr);
> -       set_except_vector(11, handle_adedata);
> -       set_except_vector(12, handle_adedata);
> -       set_except_vector(13, handle_tlb_refill);
> -       set_except_vector(14, handle_tlb_invaild);
> -       set_except_vector(15, handle_mod);
> -       set_except_vector(16, handle_cee);
> -       set_except_vector(17, handle_cpe);
> -       set_except_vector(18, handle_dbe);
> -       flush_icache_range(DEBUG_VECTOR_BASE_ADDR, IRQ_VECTOR_BASE_ADDR);
> -
> -       atomic_inc(&init_mm.mm_count);
> -       current->active_mm = &init_mm;
> -       cpu_cache_init();
> -}
> diff --git a/arch/score/kernel/vmlinux.lds.S b/arch/score/kernel/vmlinux.lds.S
> deleted file mode 100644
> index 7274b5c..0000000
> --- a/arch/score/kernel/vmlinux.lds.S
> +++ /dev/null
> @@ -1,90 +0,0 @@
> -/*
> - * arch/score/kernel/vmlinux.lds.S
> - *
> - * Score Processor version.
> - *
> - * Copyright (C) 2009 Sunplus Core Technology Co., Ltd.
> - *  Chen Liqin <liqin.chen@sunplusct.com>
> - *  Lennox Wu <lennox.wu@sunplusct.com>
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
> - *
> - * This program is distributed in the hope that it will be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, see the file COPYING, or write
> - * to the Free Software Foundation, Inc.,
> - * 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> - */
> -
> -#include <asm-generic/vmlinux.lds.h>
> -#include <asm/thread_info.h>
> -#include <asm/page.h>
> -
> -OUTPUT_ARCH(score)
> -ENTRY(_stext)
> -
> -jiffies = jiffies_64;
> -
> -SECTIONS
> -{
> -       . = CONFIG_MEMORY_START + 0x2000;
> -       /* read-only */
> -       .text : {
> -               _text = .;      /* Text and read-only data */
> -               TEXT_TEXT
> -               SCHED_TEXT
> -               LOCK_TEXT
> -               KPROBES_TEXT
> -               *(.text.*)
> -               *(.fixup)
> -               . = ALIGN (4) ;
> -               _etext = .;     /* End of text section */
> -       }
> -
> -       . = ALIGN(16);
> -       _sdata =  .;                    /* Start of data section */
> -       RODATA
> -
> -       EXCEPTION_TABLE(16)
> -
> -       RW_DATA_SECTION(32, PAGE_SIZE, THREAD_SIZE)
> -
> -       /* We want the small data sections together, so single-instruction offsets
> -          can access them all, and initialized data all before uninitialized, so
> -          we can shorten the on-disk segment size.  */
> -       . = ALIGN(8);
> -       .sdata : {
> -               *(.sdata)
> -       }
> -       _edata =  .;                    /* End of data section */
> -
> -       /* will be freed after init */
> -       . = ALIGN(PAGE_SIZE);           /* Init code and data */
> -       __init_begin = .;
> -
> -       INIT_TEXT_SECTION(PAGE_SIZE)
> -       INIT_DATA_SECTION(16)
> -
> -       /* .exit.text is discarded at runtime, not link time, to deal with
> -        * references from .rodata
> -        */
> -       .exit.text : {
> -               EXIT_TEXT
> -       }
> -       .exit.data : {
> -               EXIT_DATA
> -       }
> -       . = ALIGN(PAGE_SIZE);
> -       __init_end = .;
> -       /* freed after init ends here */
> -
> -       BSS_SECTION(0, 0, 0)
> -       _end = .;
> -}
> diff --git a/arch/score/lib/Makefile b/arch/score/lib/Makefile
> deleted file mode 100644
> index 553e30e..0000000
> --- a/arch/score/lib/Makefile
> +++ /dev/null
> @@ -1,8 +0,0 @@
> -#
> -# Makefile for SCORE-specific library files..
> -#
> -
> -lib-y += string.o checksum.o checksum_copy.o
> -
> -# libgcc-style stuff needed in the kernel
> -obj-y += ashldi3.o ashrdi3.o cmpdi2.o lshrdi3.o ucmpdi2.o
> diff --git a/arch/score/lib/ashldi3.c b/arch/score/lib/ashldi3.c
> deleted file mode 100644
> index 15691a9..0000000
> --- a/arch/score/lib/ashldi3.c
> +++ /dev/null
> @@ -1,46 +0,0 @@
> -/*
> - * arch/score/lib/ashldi3.c
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
> - *
> - * This program is distributed in the hope that it will be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, see the file COPYING, or write
> - * to the Free Software Foundation, Inc.,
> - * 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> - */
> -
> -#include <linux/module.h>
> -#include "libgcc.h"
> -
> -long long __ashldi3(long long u, word_type b)
> -{
> -       DWunion uu, w;
> -       word_type bm;
> -
> -       if (b == 0)
> -               return u;
> -
> -       uu.ll = u;
> -       bm = 32 - b;
> -
> -       if (bm <= 0) {
> -               w.s.low = 0;
> -               w.s.high = (unsigned int) uu.s.low << -bm;
> -       } else {
> -               const unsigned int carries = (unsigned int) uu.s.low >> bm;
> -
> -               w.s.low = (unsigned int) uu.s.low << b;
> -               w.s.high = ((unsigned int) uu.s.high << b) | carries;
> -       }
> -
> -       return w.ll;
> -}
> -EXPORT_SYMBOL(__ashldi3);
> diff --git a/arch/score/lib/ashrdi3.c b/arch/score/lib/ashrdi3.c
> deleted file mode 100644
> index d9814a5..0000000
> --- a/arch/score/lib/ashrdi3.c
> +++ /dev/null
> @@ -1,48 +0,0 @@
> -/*
> - * arch/score/lib/ashrdi3.c
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
> - *
> - * This program is distributed in the hope that it will be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, see the file COPYING, or write
> - * to the Free Software Foundation, Inc.,
> - * 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> - */
> -
> -#include <linux/module.h>
> -#include "libgcc.h"
> -
> -long long __ashrdi3(long long u, word_type b)
> -{
> -       DWunion uu, w;
> -       word_type bm;
> -
> -       if (b == 0)
> -               return u;
> -
> -       uu.ll = u;
> -       bm = 32 - b;
> -
> -       if (bm <= 0) {
> -               /* w.s.high = 1..1 or 0..0 */
> -               w.s.high =
> -                   uu.s.high >> 31;
> -               w.s.low = uu.s.high >> -bm;
> -       } else {
> -               const unsigned int carries = (unsigned int) uu.s.high << bm;
> -
> -               w.s.high = uu.s.high >> b;
> -               w.s.low = ((unsigned int) uu.s.low >> b) | carries;
> -       }
> -
> -       return w.ll;
> -}
> -EXPORT_SYMBOL(__ashrdi3);
> diff --git a/arch/score/lib/checksum.S b/arch/score/lib/checksum.S
> deleted file mode 100644
> index 706157e..0000000
> --- a/arch/score/lib/checksum.S
> +++ /dev/null
> @@ -1,255 +0,0 @@
> -/*
> - * arch/score/lib/csum_partial.S
> - *
> - * Score Processor version.
> - *
> - * Copyright (C) 2009 Sunplus Core Technology Co., Ltd.
> - *  Lennox Wu <lennox.wu@sunplusct.com>
> - *  Chen Liqin <liqin.chen@sunplusct.com>
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
> - *
> - * This program is distributed in the hope that it will be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, see the file COPYING, or write
> - * to the Free Software Foundation, Inc.,
> - * 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> - */
> -#include <linux/linkage.h>
> -
> -#define ADDC(sum,reg)                  \
> -       add     sum, sum, reg;          \
> -       cmp.c   reg, sum;               \
> -       bleu    9f;                     \
> -       addi    sum, 0x1;               \
> -9:
> -
> -#define CSUM_BIGCHUNK(src, offset, sum)                \
> -       lw      r8, [src, offset + 0x00];       \
> -       lw      r9, [src, offset + 0x04];       \
> -       lw      r10, [src, offset + 0x08];      \
> -       lw      r11, [src, offset + 0x0c];      \
> -       ADDC(sum, r8);                          \
> -       ADDC(sum, r9);                          \
> -       ADDC(sum, r10);                         \
> -       ADDC(sum, r11);                         \
> -       lw      r8, [src, offset + 0x10];       \
> -       lw      r9, [src, offset + 0x14];       \
> -       lw      r10, [src, offset + 0x18];      \
> -       lw      r11, [src, offset + 0x1c];      \
> -       ADDC(sum, r8);                          \
> -       ADDC(sum, r9);                          \
> -       ADDC(sum, r10);                         \
> -       ADDC(sum, r11);                         \
> -
> -#define src r4
> -#define dest r5
> -#define sum r27
> -
> -       .text
> -/* unknown src alignment and < 8 bytes to go */
> -small_csumcpy:
> -       mv      r5, r10
> -       ldi     r9, 0x0
> -       cmpi.c  r25, 0x1
> -       beq pass_small_set_t7   /*already set, jump to pass_small_set_t7*/
> -       andri.c r25,r4 , 0x1    /*Is src 2 bytes aligned?*/
> -
> -pass_small_set_t7:
> -       beq     aligned
> -       cmpi.c  r5, 0x0
> -       beq     fold
> -       lbu     r9, [src]
> -       slli    r9,r9, 0x8      /*Little endian*/
> -       ADDC(sum, r9)
> -       addi    src, 0x1
> -       subi.c  r5, 0x1
> -
> -       /*len still a full word */
> -aligned:
> -       andri.c r8, r5, 0x4     /*Len >= 4?*/
> -       beq     len_less_4bytes
> -
> -       /* Still a full word (4byte) to go,and the src is word aligned.*/
> -       andri.c r8, src, 0x3    /*src is 4bytes aligned, so use LW!!*/
> -       beq     four_byte_aligned
> -       lhu     r9, [src]
> -       addi    src, 2
> -       ADDC(sum, r9)
> -       lhu     r9, [src]
> -       addi    src, 2
> -       ADDC(sum, r9)
> -       b len_less_4bytes
> -
> -four_byte_aligned:             /* Len >=4 and four byte aligned */
> -       lw      r9, [src]
> -       addi    src, 4
> -       ADDC(sum, r9)
> -
> -len_less_4bytes:               /* 2 byte aligned aligned and length<4B */
> -       andri.c r8, r5, 0x2
> -       beq     len_less_2bytes
> -       lhu     r9, [src]
> -       addi    src, 0x2        /* src+=2 */
> -       ADDC(sum, r9)
> -
> -len_less_2bytes:               /* len = 1 */
> -       andri.c r8, r5, 0x1
> -       beq     fold            /* less than 2 and not equal 1--> len=0 -> fold */
> -       lbu     r9, [src]
> -
> -fold_ADDC:
> -       ADDC(sum, r9)
> -fold:
> -       /* fold checksum */
> -       slli    r26, sum, 16
> -       add     sum, sum, r26
> -       cmp.c   r26, sum
> -       srli    sum, sum, 16
> -       bleu    1f              /* if r26<=sum */
> -       addi    sum, 0x1        /* r26>sum */
> -1:
> -       /* odd buffer alignment? r25 was set in csum_partial */
> -       cmpi.c  r25, 0x0
> -       beq     1f
> -       slli    r26, sum, 8
> -       srli    sum, sum, 8
> -       or      sum, sum, r26
> -       andi    sum, 0xffff
> -1:
> -       .set    optimize
> -       /* Add the passed partial csum. */
> -       ADDC(sum, r6)
> -       mv      r4, sum
> -       br      r3
> -       .set    volatile
> -
> -       .align  5
> -ENTRY(csum_partial)
> -       ldi sum, 0
> -       ldi r25, 0
> -       mv r10, r5
> -       cmpi.c  r5, 0x8
> -       blt     small_csumcpy           /* < 8(singed) bytes to copy */
> -       cmpi.c  r5, 0x0
> -       beq     out
> -       andri.c r25, src, 0x1           /* odd buffer? */
> -
> -       beq     word_align
> -hword_align:                           /* 1 byte */
> -       lbu     r8, [src]
> -       subi    r5, 0x1
> -       slli    r8, r8, 8
> -       ADDC(sum, r8)
> -       addi    src, 0x1
> -
> -word_align:                            /* 2 bytes */
> -       andri.c r8, src, 0x2            /* 4bytes(dword)_aligned? */
> -       beq     dword_align             /* not, maybe dword_align */
> -       lhu     r8, [src]
> -       subi    r5, 0x2
> -       ADDC(sum, r8)
> -       addi    src, 0x2
> -
> -dword_align:                           /* 4bytes */
> -       mv      r26, r5                 /* maybe useless when len >=56 */
> -       ldi     r8, 56
> -       cmp.c   r8, r5
> -       bgtu    do_end_words            /* if a1(len)<t0(56) ,unsigned */
> -       andri.c r26, src, 0x4
> -       beq     qword_align
> -       lw      r8, [src]
> -       subi    r5, 0x4
> -       ADDC(sum, r8)
> -       addi    src, 0x4
> -
> -qword_align:                           /* 8 bytes */
> -       andri.c r26, src, 0x8
> -       beq     oword_align
> -       lw      r8, [src, 0x0]
> -       lw      r9, [src, 0x4]
> -       subi    r5, 0x8                 /* len-=0x8 */
> -       ADDC(sum, r8)
> -       ADDC(sum, r9)
> -       addi    src, 0x8
> -
> -oword_align:                           /* 16bytes */
> -       andri.c r26, src, 0x10
> -       beq     begin_movement
> -       lw      r10, [src, 0x08]
> -       lw      r11, [src, 0x0c]
> -       lw      r8, [src, 0x00]
> -       lw      r9, [src, 0x04]
> -       ADDC(sum, r10)
> -       ADDC(sum, r11)
> -       ADDC(sum, r8)
> -       ADDC(sum, r9)
> -       subi    r5, 0x10
> -       addi    src, 0x10
> -
> -begin_movement:
> -       srli.c  r26, r5, 0x7            /* len>=128? */
> -       beq     1f                      /* len<128 */
> -
> -/* r26 is the result that computed in oword_align */
> -move_128bytes:
> -       CSUM_BIGCHUNK(src, 0x00, sum)
> -       CSUM_BIGCHUNK(src, 0x20, sum)
> -       CSUM_BIGCHUNK(src, 0x40, sum)
> -       CSUM_BIGCHUNK(src, 0x60, sum)
> -       subi.c  r26, 0x01               /* r26 equals len/128 */
> -       addi    src, 0x80
> -       bne     move_128bytes
> -
> -1:     /* len<128,we process 64byte here */
> -       andri.c r10, r5, 0x40
> -       beq     1f
> -
> -move_64bytes:
> -       CSUM_BIGCHUNK(src, 0x00, sum)
> -       CSUM_BIGCHUNK(src, 0x20, sum)
> -       addi    src, 0x40
> -
> -1:                                     /* len<64 */
> -       andri   r26, r5, 0x1c           /* 0x1c=28 */
> -       andri.c r10, r5, 0x20
> -       beq     do_end_words            /* decided by andri */
> -
> -move_32bytes:
> -       CSUM_BIGCHUNK(src, 0x00, sum)
> -       andri   r26, r5, 0x1c
> -       addri   src, src, 0x20
> -
> -do_end_words:                          /* len<32 */
> -       /* r26 was set already in dword_align */
> -       cmpi.c  r26, 0x0
> -       beq     maybe_end_cruft         /* len<28 or len<56 */
> -       srli    r26, r26, 0x2
> -
> -end_words:
> -       lw      r8, [src]
> -       subi.c  r26, 0x1                /* unit is 4 byte */
> -       ADDC(sum, r8)
> -       addi    src, 0x4
> -       cmpi.c  r26, 0x0
> -       bne     end_words               /* r26!=0 */
> -
> -maybe_end_cruft:                       /* len<4 */
> -       andri   r10, r5, 0x3
> -
> -small_memcpy:
> -       mv      r5, r10
> -       j       small_csumcpy
> -
> -out:
> -       mv      r4, sum
> -       br      r3
> -
> -END(csum_partial)
> diff --git a/arch/score/lib/checksum_copy.c b/arch/score/lib/checksum_copy.c
> deleted file mode 100644
> index 04565dd..0000000
> --- a/arch/score/lib/checksum_copy.c
> +++ /dev/null
> @@ -1,52 +0,0 @@
> -/*
> - * arch/score/lib/csum_partial_copy.c
> - *
> - * Score Processor version.
> - *
> - * Copyright (C) 2009 Sunplus Core Technology Co., Ltd.
> - *  Lennox Wu <lennox.wu@sunplusct.com>
> - *  Chen Liqin <liqin.chen@sunplusct.com>
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
> - *
> - * This program is distributed in the hope that it will be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, see the file COPYING, or write
> - * to the Free Software Foundation, Inc.,
> - * 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> - */
> -
> -#include <net/checksum.h>
> -
> -#include <asm/uaccess.h>
> -
> -unsigned int csum_partial_copy(const char *src, char *dst,
> -                               int len, unsigned int sum)
> -{
> -       sum = csum_partial(src, len, sum);
> -       memcpy(dst, src, len);
> -
> -       return sum;
> -}
> -
> -unsigned int csum_partial_copy_from_user(const char *src, char *dst,
> -                                       int len, unsigned int sum,
> -                                       int *err_ptr)
> -{
> -       int missing;
> -
> -       missing = copy_from_user(dst, src, len);
> -       if (missing) {
> -               memset(dst + len - missing, 0, missing);
> -               *err_ptr = -EFAULT;
> -       }
> -
> -       return csum_partial(dst, len, sum);
> -}
> diff --git a/arch/score/lib/cmpdi2.c b/arch/score/lib/cmpdi2.c
> deleted file mode 100644
> index 1ed5290..0000000
> --- a/arch/score/lib/cmpdi2.c
> +++ /dev/null
> @@ -1,44 +0,0 @@
> -/*
> - * arch/score/lib/cmpdi2.c
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
> - *
> - * This program is distributed in the hope that it will be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, see the file COPYING, or write
> - * to the Free Software Foundation, Inc.,
> - * 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> - */
> -
> -#include <linux/module.h>
> -#include "libgcc.h"
> -
> -word_type __cmpdi2(long long a, long long b)
> -{
> -       const DWunion au = {
> -               .ll = a
> -       };
> -       const DWunion bu = {
> -               .ll = b
> -       };
> -
> -       if (au.s.high < bu.s.high)
> -               return 0;
> -       else if (au.s.high > bu.s.high)
> -               return 2;
> -
> -       if ((unsigned int) au.s.low < (unsigned int) bu.s.low)
> -               return 0;
> -       else if ((unsigned int) au.s.low > (unsigned int) bu.s.low)
> -               return 2;
> -
> -       return 1;
> -}
> -EXPORT_SYMBOL(__cmpdi2);
> diff --git a/arch/score/lib/libgcc.h b/arch/score/lib/libgcc.h
> deleted file mode 100644
> index 0f12543..0000000
> --- a/arch/score/lib/libgcc.h
> +++ /dev/null
> @@ -1,37 +0,0 @@
> -/*
> - * arch/score/lib/libgcc.h
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
> - *
> - * This program is distributed in the hope that it will be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, see the file COPYING, or write
> - * to the Free Software Foundation, Inc.,
> - * 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> - */
> -
> -
> -#ifndef __ASM_LIBGCC_H
> -#define __ASM_LIBGCC_H
> -
> -#include <asm/byteorder.h>
> -
> -typedef int word_type __attribute__((mode(__word__)));
> -
> -struct DWstruct {
> -       int low, high;
> -};
> -
> -typedef union {
> -       struct DWstruct s;
> -       long long ll;
> -} DWunion;
> -
> -#endif /* __ASM_LIBGCC_H */
> diff --git a/arch/score/lib/lshrdi3.c b/arch/score/lib/lshrdi3.c
> deleted file mode 100644
> index ce21175..0000000
> --- a/arch/score/lib/lshrdi3.c
> +++ /dev/null
> @@ -1,47 +0,0 @@
> -/*
> - * arch/score/lib/lshrdi3.c
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
> - *
> - * This program is distributed in the hope that it will be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, see the file COPYING, or write
> - * to the Free Software Foundation, Inc.,
> - * 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> - */
> -
> -
> -#include <linux/module.h>
> -#include "libgcc.h"
> -
> -long long __lshrdi3(long long u, word_type b)
> -{
> -       DWunion uu, w;
> -       word_type bm;
> -
> -       if (b == 0)
> -               return u;
> -
> -       uu.ll = u;
> -       bm = 32 - b;
> -
> -       if (bm <= 0) {
> -               w.s.high = 0;
> -               w.s.low = (unsigned int) uu.s.high >> -bm;
> -       } else {
> -               const unsigned int carries = (unsigned int) uu.s.high << bm;
> -
> -               w.s.high = (unsigned int) uu.s.high >> b;
> -               w.s.low = ((unsigned int) uu.s.low >> b) | carries;
> -       }
> -
> -       return w.ll;
> -}
> -EXPORT_SYMBOL(__lshrdi3);
> diff --git a/arch/score/lib/string.S b/arch/score/lib/string.S
> deleted file mode 100644
> index 00b7d3a..0000000
> --- a/arch/score/lib/string.S
> +++ /dev/null
> @@ -1,184 +0,0 @@
> -/*
> - * arch/score/lib/string.S
> - *
> - * Score Processor version.
> - *
> - * Copyright (C) 2009 Sunplus Core Technology Co., Ltd.
> - *  Chen Liqin <liqin.chen@sunplusct.com>
> - *  Lennox Wu <lennox.wu@sunplusct.com>
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
> - *
> - * This program is distributed in the hope that it will be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, see the file COPYING, or write
> - * to the Free Software Foundation, Inc.,
> - * 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> - */
> -
> -#include <linux/linkage.h>
> -#include <asm-generic/errno.h>
> -
> -       .text
> -       .align 2
> -ENTRY(__strncpy_from_user)
> -       cmpi.c  r6, 0
> -       mv      r9, r6
> -       ble     .L2
> -0:     lbu     r7, [r5]
> -       ldi     r8, 0
> -1:     sb      r7, [r4]
> -2:     lb      r6, [r5]
> -       cmp.c   r6, r8
> -       beq     .L2
> -
> -.L5:
> -       addi    r8, 1
> -       cmp.c   r8, r9
> -       beq     .L7
> -3:     lbu     r6, [r5, 1]+
> -4:     sb      r6, [r4, 1]+
> -5:     lb      r7, [r5]
> -       cmpi.c  r7, 0
> -       bne     .L5
> -.L7:
> -       mv      r4, r8
> -       br      r3
> -.L2:
> -       ldi     r8, 0
> -       mv      r4, r8
> -       br      r3
> -       .section .fixup, "ax"
> -99:
> -       ldi     r4, -EFAULT
> -       br      r3
> -       .previous
> -       .section __ex_table, "a"
> -       .align  2
> -       .word   0b ,99b
> -       .word   1b ,99b
> -       .word   2b ,99b
> -       .word   3b ,99b
> -       .word   4b ,99b
> -       .word   5b ,99b
> -       .previous
> -
> -       .align 2
> -ENTRY(__strnlen_user)
> -       cmpi.c  r5, 0
> -       ble     .L11
> -0:     lb      r6, [r4]
> -       ldi     r7, 0
> -       cmp.c   r6, r7
> -       beq     .L11
> -.L15:
> -       addi    r7, 1
> -       cmp.c   r7, r5
> -       beq     .L23
> -1:     lb      r6, [r4,1]+
> -       cmpi.c  r6, 0
> -       bne     .L15
> -.L23:
> -       addri   r4, r7, 1
> -       br      r3
> -
> -.L11:
> -       ldi     r4, 1
> -       br      r3
> -       .section .fixup, "ax"
> -99:
> -       ldi     r4, 0
> -       br      r3
> -
> -       .section __ex_table,"a"
> -       .align 2
> -       .word   0b, 99b
> -       .word   1b, 99b
> -       .previous
> -
> -       .align 2
> -ENTRY(__strlen_user)
> -0:     lb      r6, [r4]
> -       mv      r7, r4
> -       extsb   r6, r6
> -       cmpi.c  r6, 0
> -       mv      r4, r6
> -       beq     .L27
> -.L28:
> -1:     lb      r6, [r7, 1]+
> -       addi    r6, 1
> -       cmpi.c  r6, 0
> -       bne     .L28
> -.L27:
> -       br      r3
> -       .section .fixup, "ax"
> -       ldi     r4, 0x0
> -       br      r3
> -99:
> -       ldi     r4, 0
> -       br      r3
> -       .previous
> -       .section __ex_table, "a"
> -       .align  2
> -       .word   0b ,99b
> -       .word   1b ,99b
> -       .previous
> -
> -       .align 2
> -ENTRY(__copy_tofrom_user)
> -       cmpi.c  r6, 0
> -       mv      r10,r6
> -       beq     .L32
> -       ldi     r9, 0
> -.L34:
> -       add     r6, r5, r9
> -0:     lbu     r8, [r6]
> -       add     r7, r4, r9
> -1:     sb      r8, [r7]
> -       addi    r9, 1
> -       cmp.c   r9, r10
> -       bne     .L34
> -.L32:
> -       ldi     r4, 0
> -       br      r3
> -       .section .fixup, "ax"
> -99:
> -       sub     r4, r10, r9
> -       br      r3
> -       .previous
> -       .section __ex_table, "a"
> -       .align  2
> -       .word   0b, 99b
> -       .word   1b, 99b
> -       .previous
> -
> -       .align 2
> -ENTRY(__clear_user)
> -       cmpi.c  r5, 0
> -       beq     .L38
> -       ldi     r6, 0
> -       mv      r7, r6
> -.L40:
> -       addi    r6, 1
> -0:     sb      r7, [r4]+, 1
> -       cmp.c   r6, r5
> -       bne     .L40
> -.L38:
> -       ldi     r4, 0
> -       br      r3
> -
> -       .section .fixup, "ax"
> -       br      r3
> -       .previous
> -       .section __ex_table, "a"
> -       .align  2
> -99:
> -       .word   0b, 99b
> -       .previous
> diff --git a/arch/score/lib/ucmpdi2.c b/arch/score/lib/ucmpdi2.c
> deleted file mode 100644
> index b15241e..0000000
> --- a/arch/score/lib/ucmpdi2.c
> +++ /dev/null
> @@ -1,38 +0,0 @@
> -/*
> - * arch/score/lib/ucmpdi2.c
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
> - *
> - * This program is distributed in the hope that it will be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, see the file COPYING, or write
> - * to the Free Software Foundation, Inc.,
> - * 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> - */
> -
> -#include <linux/module.h>
> -#include "libgcc.h"
> -
> -word_type __ucmpdi2(unsigned long long a, unsigned long long b)
> -{
> -       const DWunion au = {.ll = a};
> -       const DWunion bu = {.ll = b};
> -
> -       if ((unsigned int) au.s.high < (unsigned int) bu.s.high)
> -               return 0;
> -       else if ((unsigned int) au.s.high > (unsigned int) bu.s.high)
> -               return 2;
> -       if ((unsigned int) au.s.low < (unsigned int) bu.s.low)
> -               return 0;
> -       else if ((unsigned int) au.s.low > (unsigned int) bu.s.low)
> -               return 2;
> -       return 1;
> -}
> -EXPORT_SYMBOL(__ucmpdi2);
> diff --git a/arch/score/mm/Makefile b/arch/score/mm/Makefile
> deleted file mode 100644
> index 7b1e29b..0000000
> --- a/arch/score/mm/Makefile
> +++ /dev/null
> @@ -1,6 +0,0 @@
> -#
> -# Makefile for the Linux/SCORE-specific parts of the memory manager.
> -#
> -
> -obj-y += cache.o extable.o fault.o init.o \
> -       tlb-miss.o tlb-score.o pgtable.o
> diff --git a/arch/score/mm/cache.c b/arch/score/mm/cache.c
> deleted file mode 100644
> index f85ec1a..0000000
> --- a/arch/score/mm/cache.c
> +++ /dev/null
> @@ -1,279 +0,0 @@
> -/*
> - * arch/score/mm/cache.c
> - *
> - * Score Processor version.
> - *
> - * Copyright (C) 2009 Sunplus Core Technology Co., Ltd.
> - *  Lennox Wu <lennox.wu@sunplusct.com>
> - *  Chen Liqin <liqin.chen@sunplusct.com>
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
> - *
> - * This program is distributed in the hope that it will be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, see the file COPYING, or write
> - * to the Free Software Foundation, Inc.,
> - * 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> - */
> -
> -#include <linux/init.h>
> -#include <linux/linkage.h>
> -#include <linux/kernel.h>
> -#include <linux/mm.h>
> -#include <linux/module.h>
> -#include <linux/sched.h>
> -#include <linux/fs.h>
> -
> -#include <asm/mmu_context.h>
> -
> -/*
> -Just flush entire Dcache!!
> -You must ensure the page doesn't include instructions, because
> -the function will not flush the Icache.
> -The addr must be cache aligned.
> -*/
> -static void flush_data_cache_page(unsigned long addr)
> -{
> -       unsigned int i;
> -       for (i = 0; i < (PAGE_SIZE / L1_CACHE_BYTES); i += L1_CACHE_BYTES) {
> -               __asm__ __volatile__(
> -               "cache 0x0e, [%0, 0]\n"
> -               "cache 0x1a, [%0, 0]\n"
> -               "nop\n"
> -               : : "r" (addr));
> -               addr += L1_CACHE_BYTES;
> -       }
> -}
> -
> -void flush_dcache_page(struct page *page)
> -{
> -       struct address_space *mapping = page_mapping(page);
> -       unsigned long addr;
> -
> -       if (PageHighMem(page))
> -               return;
> -       if (mapping && !mapping_mapped(mapping)) {
> -               set_bit(PG_dcache_dirty, &(page)->flags);
> -               return;
> -       }
> -
> -       /*
> -        * We could delay the flush for the !page_mapping case too.  But that
> -        * case is for exec env/arg pages and those are %99 certainly going to
> -        * get faulted into the tlb (and thus flushed) anyways.
> -        */
> -       addr = (unsigned long) page_address(page);
> -       flush_data_cache_page(addr);
> -}
> -
> -/* called by update_mmu_cache. */
> -void __update_cache(struct vm_area_struct *vma, unsigned long address,
> -               pte_t pte)
> -{
> -       struct page *page;
> -       unsigned long pfn, addr;
> -       int exec = (vma->vm_flags & VM_EXEC);
> -
> -       pfn = pte_pfn(pte);
> -       if (unlikely(!pfn_valid(pfn)))
> -               return;
> -       page = pfn_to_page(pfn);
> -       if (page_mapping(page) && test_bit(PG_dcache_dirty, &(page)->flags)) {
> -               addr = (unsigned long) page_address(page);
> -               if (exec)
> -                       flush_data_cache_page(addr);
> -               clear_bit(PG_dcache_dirty, &(page)->flags);
> -       }
> -}
> -
> -static inline void setup_protection_map(void)
> -{
> -       protection_map[0] = PAGE_NONE;
> -       protection_map[1] = PAGE_READONLY;
> -       protection_map[2] = PAGE_COPY;
> -       protection_map[3] = PAGE_COPY;
> -       protection_map[4] = PAGE_READONLY;
> -       protection_map[5] = PAGE_READONLY;
> -       protection_map[6] = PAGE_COPY;
> -       protection_map[7] = PAGE_COPY;
> -       protection_map[8] = PAGE_NONE;
> -       protection_map[9] = PAGE_READONLY;
> -       protection_map[10] = PAGE_SHARED;
> -       protection_map[11] = PAGE_SHARED;
> -       protection_map[12] = PAGE_READONLY;
> -       protection_map[13] = PAGE_READONLY;
> -       protection_map[14] = PAGE_SHARED;
> -       protection_map[15] = PAGE_SHARED;
> -}
> -
> -void cpu_cache_init(void)
> -{
> -       setup_protection_map();
> -}
> -
> -void flush_icache_all(void)
> -{
> -       __asm__ __volatile__(
> -       "la r8, flush_icache_all\n"
> -       "cache 0x10, [r8, 0]\n"
> -       "nop\nnop\nnop\nnop\nnop\nnop\n"
> -       : : : "r8");
> -}
> -
> -void flush_dcache_all(void)
> -{
> -       __asm__ __volatile__(
> -       "la r8, flush_dcache_all\n"
> -       "cache 0x1f, [r8, 0]\n"
> -       "nop\nnop\nnop\nnop\nnop\nnop\n"
> -       "cache 0x1a, [r8, 0]\n"
> -       "nop\nnop\nnop\nnop\nnop\nnop\n"
> -       : : : "r8");
> -}
> -
> -void flush_cache_all(void)
> -{
> -       __asm__ __volatile__(
> -       "la r8, flush_cache_all\n"
> -       "cache 0x10, [r8, 0]\n"
> -       "nop\nnop\nnop\nnop\nnop\nnop\n"
> -       "cache 0x1f, [r8, 0]\n"
> -       "nop\nnop\nnop\nnop\nnop\nnop\n"
> -       "cache 0x1a, [r8, 0]\n"
> -       "nop\nnop\nnop\nnop\nnop\nnop\n"
> -       : : : "r8");
> -}
> -
> -void flush_cache_mm(struct mm_struct *mm)
> -{
> -       if (!(mm->context))
> -               return;
> -       flush_cache_all();
> -}
> -
> -/*if we flush a range precisely , the processing may be very long.
> -We must check each page in the range whether present. If the page is present,
> -we can flush the range in the page. Be careful, the range may be cross two
> -page, a page is present and another is not present.
> -*/
> -/*
> -The interface is provided in hopes that the port can find
> -a suitably efficient method for removing multiple page
> -sized regions from the cache.
> -*/
> -void flush_cache_range(struct vm_area_struct *vma,
> -               unsigned long start, unsigned long end)
> -{
> -       struct mm_struct *mm = vma->vm_mm;
> -       int exec = vma->vm_flags & VM_EXEC;
> -       pgd_t *pgdp;
> -       pud_t *pudp;
> -       pmd_t *pmdp;
> -       pte_t *ptep;
> -
> -       if (!(mm->context))
> -               return;
> -
> -       pgdp = pgd_offset(mm, start);
> -       pudp = pud_offset(pgdp, start);
> -       pmdp = pmd_offset(pudp, start);
> -       ptep = pte_offset(pmdp, start);
> -
> -       while (start <= end) {
> -               unsigned long tmpend;
> -               pgdp = pgd_offset(mm, start);
> -               pudp = pud_offset(pgdp, start);
> -               pmdp = pmd_offset(pudp, start);
> -               ptep = pte_offset(pmdp, start);
> -
> -               if (!(pte_val(*ptep) & _PAGE_PRESENT)) {
> -                       start = (start + PAGE_SIZE) & ~(PAGE_SIZE - 1);
> -                       continue;
> -               }
> -               tmpend = (start | (PAGE_SIZE-1)) > end ?
> -                                end : (start | (PAGE_SIZE-1));
> -
> -               flush_dcache_range(start, tmpend);
> -               if (exec)
> -                       flush_icache_range(start, tmpend);
> -               start = (start + PAGE_SIZE) & ~(PAGE_SIZE - 1);
> -       }
> -}
> -
> -void flush_cache_page(struct vm_area_struct *vma,
> -               unsigned long addr, unsigned long pfn)
> -{
> -       int exec = vma->vm_flags & VM_EXEC;
> -       unsigned long kaddr = 0xa0000000 | (pfn << PAGE_SHIFT);
> -
> -       flush_dcache_range(kaddr, kaddr + PAGE_SIZE);
> -
> -       if (exec)
> -               flush_icache_range(kaddr, kaddr + PAGE_SIZE);
> -}
> -
> -void flush_cache_sigtramp(unsigned long addr)
> -{
> -       __asm__ __volatile__(
> -       "cache 0x02, [%0, 0]\n"
> -       "nop\nnop\nnop\nnop\nnop\n"
> -       "cache 0x02, [%0, 0x4]\n"
> -       "nop\nnop\nnop\nnop\nnop\n"
> -
> -       "cache 0x0d, [%0, 0]\n"
> -       "nop\nnop\nnop\nnop\nnop\n"
> -       "cache 0x0d, [%0, 0x4]\n"
> -       "nop\nnop\nnop\nnop\nnop\n"
> -
> -       "cache 0x1a, [%0, 0]\n"
> -       "nop\nnop\nnop\nnop\nnop\n"
> -       : : "r" (addr));
> -}
> -
> -/*
> -1. WB and invalid a cache line of Dcache
> -2. Drain Write Buffer
> -the range must be smaller than PAGE_SIZE
> -*/
> -void flush_dcache_range(unsigned long start, unsigned long end)
> -{
> -       int size, i;
> -
> -       start = start & ~(L1_CACHE_BYTES - 1);
> -       end = end & ~(L1_CACHE_BYTES - 1);
> -       size = end - start;
> -       /* flush dcache to ram, and invalidate dcache lines. */
> -       for (i = 0; i < size; i += L1_CACHE_BYTES) {
> -               __asm__ __volatile__(
> -               "cache 0x0e, [%0, 0]\n"
> -               "nop\nnop\nnop\nnop\nnop\n"
> -               "cache 0x1a, [%0, 0]\n"
> -               "nop\nnop\nnop\nnop\nnop\n"
> -               : : "r" (start));
> -               start += L1_CACHE_BYTES;
> -       }
> -}
> -
> -void flush_icache_range(unsigned long start, unsigned long end)
> -{
> -       int size, i;
> -       start = start & ~(L1_CACHE_BYTES - 1);
> -       end = end & ~(L1_CACHE_BYTES - 1);
> -
> -       size = end - start;
> -       /* invalidate icache lines. */
> -       for (i = 0; i < size; i += L1_CACHE_BYTES) {
> -               __asm__ __volatile__(
> -               "cache 0x02, [%0, 0]\n"
> -               "nop\nnop\nnop\nnop\nnop\n"
> -               : : "r" (start));
> -               start += L1_CACHE_BYTES;
> -       }
> -}
> diff --git a/arch/score/mm/extable.c b/arch/score/mm/extable.c
> deleted file mode 100644
> index 01ff644..0000000
> --- a/arch/score/mm/extable.c
> +++ /dev/null
> @@ -1,38 +0,0 @@
> -/*
> - * arch/score/mm/extable.c
> - *
> - * Score Processor version.
> - *
> - * Copyright (C) 2009 Sunplus Core Technology Co., Ltd.
> - *  Lennox Wu <lennox.wu@sunplusct.com>
> - *  Chen Liqin <liqin.chen@sunplusct.com>
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
> - *
> - * This program is distributed in the hope that it will be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, see the file COPYING, or write
> - * to the Free Software Foundation, Inc.,
> - * 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> - */
> -
> -#include <linux/module.h>
> -
> -int fixup_exception(struct pt_regs *regs)
> -{
> -       const struct exception_table_entry *fixup;
> -
> -       fixup = search_exception_tables(regs->cp0_epc);
> -       if (fixup) {
> -               regs->cp0_epc = fixup->fixup;
> -               return 1;
> -       }
> -       return 0;
> -}
> diff --git a/arch/score/mm/fault.c b/arch/score/mm/fault.c
> deleted file mode 100644
> index 6b18fb0..0000000
> --- a/arch/score/mm/fault.c
> +++ /dev/null
> @@ -1,235 +0,0 @@
> -/*
> - * arch/score/mm/fault.c
> - *
> - * Score Processor version.
> - *
> - * Copyright (C) 2009 Sunplus Core Technology Co., Ltd.
> - *  Lennox Wu <lennox.wu@sunplusct.com>
> - *  Chen Liqin <liqin.chen@sunplusct.com>
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
> - *
> - * This program is distributed in the hope that it will be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, see the file COPYING, or write
> - * to the Free Software Foundation, Inc.,
> - * 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> - */
> -
> -#include <linux/errno.h>
> -#include <linux/interrupt.h>
> -#include <linux/kernel.h>
> -#include <linux/mm.h>
> -#include <linux/mman.h>
> -#include <linux/module.h>
> -#include <linux/signal.h>
> -#include <linux/sched.h>
> -#include <linux/string.h>
> -#include <linux/types.h>
> -#include <linux/ptrace.h>
> -
> -/*
> - * This routine handles page faults.  It determines the address,
> - * and the problem, and then passes it off to one of the appropriate
> - * routines.
> - */
> -asmlinkage void do_page_fault(struct pt_regs *regs, unsigned long write,
> -                               unsigned long address)
> -{
> -       struct vm_area_struct *vma = NULL;
> -       struct task_struct *tsk = current;
> -       struct mm_struct *mm = tsk->mm;
> -       const int field = sizeof(unsigned long) * 2;
> -       siginfo_t info;
> -       int fault;
> -
> -       info.si_code = SEGV_MAPERR;
> -
> -       /*
> -       * We fault-in kernel-space virtual memory on-demand. The
> -       * 'reference' page table is init_mm.pgd.
> -       *
> -       * NOTE! We MUST NOT take any locks for this case. We may
> -       * be in an interrupt or a critical region, and should
> -       * only copy the information from the master page table,
> -       * nothing more.
> -       */
> -       if (unlikely(address >= VMALLOC_START && address <= VMALLOC_END))
> -               goto vmalloc_fault;
> -#ifdef MODULE_START
> -       if (unlikely(address >= MODULE_START && address < MODULE_END))
> -               goto vmalloc_fault;
> -#endif
> -
> -       /*
> -       * If we're in an interrupt or have no user
> -       * context, we must not take the fault..
> -       */
> -       if (in_atomic() || !mm)
> -               goto bad_area_nosemaphore;
> -
> -       down_read(&mm->mmap_sem);
> -       vma = find_vma(mm, address);
> -       if (!vma)
> -               goto bad_area;
> -       if (vma->vm_start <= address)
> -               goto good_area;
> -       if (!(vma->vm_flags & VM_GROWSDOWN))
> -               goto bad_area;
> -       if (expand_stack(vma, address))
> -               goto bad_area;
> -       /*
> -       * Ok, we have a good vm_area for this memory access, so
> -       * we can handle it..
> -        */
> -good_area:
> -       info.si_code = SEGV_ACCERR;
> -
> -       if (write) {
> -               if (!(vma->vm_flags & VM_WRITE))
> -                       goto bad_area;
> -       } else {
> -               if (!(vma->vm_flags & (VM_READ | VM_WRITE | VM_EXEC)))
> -                       goto bad_area;
> -       }
> -
> -survive:
> -       /*
> -       * If for any reason at all we couldn't handle the fault,
> -       * make sure we exit gracefully rather than endlessly redo
> -       * the fault.
> -       */
> -       fault = handle_mm_fault(mm, vma, address, write);
> -       if (unlikely(fault & VM_FAULT_ERROR)) {
> -               if (fault & VM_FAULT_OOM)
> -                       goto out_of_memory;
> -               else if (fault & VM_FAULT_SIGBUS)
> -                       goto do_sigbus;
> -               BUG();
> -       }
> -       if (fault & VM_FAULT_MAJOR)
> -               tsk->maj_flt++;
> -       else
> -               tsk->min_flt++;
> -
> -       up_read(&mm->mmap_sem);
> -       return;
> -
> -       /*
> -       * Something tried to access memory that isn't in our memory map..
> -       * Fix it, but check if it's kernel or user first..
> -        */
> -bad_area:
> -       up_read(&mm->mmap_sem);
> -
> -bad_area_nosemaphore:
> -       /* User mode accesses just cause a SIGSEGV */
> -       if (user_mode(regs)) {
> -               tsk->thread.cp0_badvaddr = address;
> -               tsk->thread.error_code = write;
> -               info.si_signo = SIGSEGV;
> -               info.si_errno = 0;
> -               /* info.si_code has been set above */
> -               info.si_addr = (void __user *) address;
> -               force_sig_info(SIGSEGV, &info, tsk);
> -               return;
> -       }
> -
> -no_context:
> -       /* Are we prepared to handle this kernel fault? */
> -       if (fixup_exception(regs)) {
> -               current->thread.cp0_baduaddr = address;
> -               return;
> -       }
> -
> -       /*
> -       * Oops. The kernel tried to access some bad page. We'll have to
> -       * terminate things with extreme prejudice.
> -       */
> -       bust_spinlocks(1);
> -
> -       printk(KERN_ALERT "CPU %d Unable to handle kernel paging request at "
> -                       "virtual address %0*lx, epc == %0*lx, ra == %0*lx\n",
> -                       0, field, address, field, regs->cp0_epc,
> -                       field, regs->regs[3]);
> -       die("Oops", regs);
> -
> -       /*
> -       * We ran out of memory, or some other thing happened to us that made
> -       * us unable to handle the page fault gracefully.
> -       */
> -out_of_memory:
> -       up_read(&mm->mmap_sem);
> -       if (is_global_init(tsk)) {
> -               yield();
> -               down_read(&mm->mmap_sem);
> -               goto survive;
> -       }
> -       if (!user_mode(regs))
> -               goto no_context;
> -       pagefault_out_of_memory();
> -       return;
> -
> -do_sigbus:
> -       up_read(&mm->mmap_sem);
> -       /* Kernel mode? Handle exceptions or die */
> -       if (!user_mode(regs))
> -               goto no_context;
> -       else
> -       /*
> -       * Send a sigbus, regardless of whether we were in kernel
> -       * or user mode.
> -       */
> -       tsk->thread.cp0_badvaddr = address;
> -       info.si_signo = SIGBUS;
> -       info.si_errno = 0;
> -       info.si_code = BUS_ADRERR;
> -       info.si_addr = (void __user *) address;
> -       force_sig_info(SIGBUS, &info, tsk);
> -       return;
> -vmalloc_fault:
> -       {
> -               /*
> -               * Synchronize this task's top level page-table
> -               * with the 'reference' page table.
> -               *
> -               * Do _not_ use "tsk" here. We might be inside
> -               * an interrupt in the middle of a task switch..
> -               */
> -               int offset = __pgd_offset(address);
> -               pgd_t *pgd, *pgd_k;
> -               pud_t *pud, *pud_k;
> -               pmd_t *pmd, *pmd_k;
> -               pte_t *pte_k;
> -
> -               pgd = (pgd_t *) pgd_current + offset;
> -               pgd_k = init_mm.pgd + offset;
> -
> -               if (!pgd_present(*pgd_k))
> -                       goto no_context;
> -               set_pgd(pgd, *pgd_k);
> -
> -               pud = pud_offset(pgd, address);
> -               pud_k = pud_offset(pgd_k, address);
> -               if (!pud_present(*pud_k))
> -                       goto no_context;
> -
> -               pmd = pmd_offset(pud, address);
> -               pmd_k = pmd_offset(pud_k, address);
> -               if (!pmd_present(*pmd_k))
> -                       goto no_context;
> -               set_pmd(pmd, *pmd_k);
> -
> -               pte_k = pte_offset_kernel(pmd_k, address);
> -               if (!pte_present(*pte_k))
> -                       goto no_context;
> -               return;
> -       }
> -}
> diff --git a/arch/score/mm/init.c b/arch/score/mm/init.c
> deleted file mode 100644
> index 9fbce49..0000000
> --- a/arch/score/mm/init.c
> +++ /dev/null
> @@ -1,109 +0,0 @@
> -/*
> - * arch/score/mm/init.c
> - *
> - * Score Processor version.
> - *
> - * Copyright (C) 2009 Sunplus Core Technology Co., Ltd.
> - *  Lennox Wu <lennox.wu@sunplusct.com>
> - *  Chen Liqin <liqin.chen@sunplusct.com>
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
> - *
> - * This program is distributed in the hope that it will be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, see the file COPYING, or write
> - * to the Free Software Foundation, Inc.,
> - * 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> - */
> -
> -#include <linux/errno.h>
> -#include <linux/bootmem.h>
> -#include <linux/kernel.h>
> -#include <linux/gfp.h>
> -#include <linux/init.h>
> -#include <linux/mm.h>
> -#include <linux/mman.h>
> -#include <linux/pagemap.h>
> -#include <linux/kcore.h>
> -#include <linux/sched.h>
> -#include <linux/initrd.h>
> -
> -#include <asm/sections.h>
> -#include <asm/tlb.h>
> -
> -unsigned long empty_zero_page;
> -EXPORT_SYMBOL_GPL(empty_zero_page);
> -
> -static void setup_zero_page(void)
> -{
> -       struct page *page;
> -
> -       empty_zero_page = __get_free_pages(GFP_KERNEL | __GFP_ZERO, 0);
> -       if (!empty_zero_page)
> -               panic("Oh boy, that early out of memory?");
> -
> -       page = virt_to_page((void *) empty_zero_page);
> -       mark_page_reserved(page);
> -}
> -
> -#ifndef CONFIG_NEED_MULTIPLE_NODES
> -int page_is_ram(unsigned long pagenr)
> -{
> -       if (pagenr >= min_low_pfn && pagenr < max_low_pfn)
> -               return 1;
> -       else
> -               return 0;
> -}
> -
> -void __init paging_init(void)
> -{
> -       unsigned long max_zone_pfns[MAX_NR_ZONES];
> -       unsigned long lastpfn;
> -
> -       pagetable_init();
> -       max_zone_pfns[ZONE_NORMAL] = max_low_pfn;
> -       lastpfn = max_low_pfn;
> -       free_area_init_nodes(max_zone_pfns);
> -}
> -
> -void __init mem_init(void)
> -{
> -       high_memory = (void *) __va(max_low_pfn << PAGE_SHIFT);
> -       free_all_bootmem();
> -       setup_zero_page();      /* Setup zeroed pages. */
> -
> -       mem_init_print_info(NULL);
> -}
> -#endif /* !CONFIG_NEED_MULTIPLE_NODES */
> -
> -#ifdef CONFIG_BLK_DEV_INITRD
> -void free_initrd_mem(unsigned long start, unsigned long end)
> -{
> -       free_reserved_area((void *)start, (void *)end, POISON_FREE_INITMEM,
> -                          "initrd");
> -}
> -#endif
> -
> -void __init_refok free_initmem(void)
> -{
> -       free_initmem_default(POISON_FREE_INITMEM);
> -}
> -
> -unsigned long pgd_current;
> -
> -#define __page_aligned(order) __attribute__((__aligned__(PAGE_SIZE<<order)))
> -
> -/*
> - * gcc 3.3 and older have trouble determining that PTRS_PER_PGD and PGD_ORDER
> - * are constants.  So we use the variants from asm-offset.h until that gcc
> - * will officially be retired.
> - */
> -pgd_t swapper_pg_dir[PTRS_PER_PGD] __page_aligned(PTE_ORDER);
> -pte_t invalid_pte_table[PTRS_PER_PTE] __page_aligned(PTE_ORDER);
> diff --git a/arch/score/mm/pgtable.c b/arch/score/mm/pgtable.c
> deleted file mode 100644
> index 6408bb7..0000000
> --- a/arch/score/mm/pgtable.c
> +++ /dev/null
> @@ -1,52 +0,0 @@
> -/*
> - * arch/score/mm/pgtable-32.c
> - *
> - * Score Processor version.
> - *
> - * Copyright (C) 2009 Sunplus Core Technology Co., Ltd.
> - *  Lennox Wu <lennox.wu@sunplusct.com>
> - *  Chen Liqin <liqin.chen@sunplusct.com>
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
> - *
> - * This program is distributed in the hope that it will be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, see the file COPYING, or write
> - * to the Free Software Foundation, Inc.,
> - * 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> - */
> -
> -#include <linux/bootmem.h>
> -#include <linux/init.h>
> -#include <linux/pfn.h>
> -#include <linux/mm.h>
> -
> -void pgd_init(unsigned long page)
> -{
> -       unsigned long *p = (unsigned long *) page;
> -       int i;
> -
> -       for (i = 0; i < USER_PTRS_PER_PGD; i += 8) {
> -               p[i + 0] = (unsigned long) invalid_pte_table;
> -               p[i + 1] = (unsigned long) invalid_pte_table;
> -               p[i + 2] = (unsigned long) invalid_pte_table;
> -               p[i + 3] = (unsigned long) invalid_pte_table;
> -               p[i + 4] = (unsigned long) invalid_pte_table;
> -               p[i + 5] = (unsigned long) invalid_pte_table;
> -               p[i + 6] = (unsigned long) invalid_pte_table;
> -               p[i + 7] = (unsigned long) invalid_pte_table;
> -       }
> -}
> -
> -void __init pagetable_init(void)
> -{
> -       /* Initialize the entire pgd. */
> -       pgd_init((unsigned long)swapper_pg_dir);
> -}
> diff --git a/arch/score/mm/tlb-miss.S b/arch/score/mm/tlb-miss.S
> deleted file mode 100644
> index f276519..0000000
> --- a/arch/score/mm/tlb-miss.S
> +++ /dev/null
> @@ -1,199 +0,0 @@
> -/*
> - * arch/score/mm/tlbex.S
> - *
> - * Score Processor version.
> - *
> - * Copyright (C) 2009 Sunplus Core Technology Co., Ltd.
> - *  Lennox Wu <lennox.wu@sunplusct.com>
> - *  Chen Liqin <liqin.chen@sunplusct.com>
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
> - *
> - * This program is distributed in the hope that it will be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, see the file COPYING, or write
> - * to the Free Software Foundation, Inc.,
> - * 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> - */
> -
> -#include <asm/asmmacro.h>
> -#include <asm/pgtable-bits.h>
> -#include <asm/scoreregs.h>
> -
> -/*
> -* After this macro runs, the pte faulted on is
> -* in register PTE, a ptr into the table in which
> -* the pte belongs is in PTR.
> -*/
> -       .macro  load_pte, pte, ptr
> -       la      \ptr, pgd_current
> -       lw      \ptr, [\ptr, 0]
> -       mfcr    \pte, cr6
> -       srli    \pte, \pte, 22
> -       slli    \pte, \pte, 2
> -       add     \ptr, \ptr, \pte
> -       lw      \ptr, [\ptr, 0]
> -       mfcr    \pte, cr6
> -       srli    \pte, \pte, 10
> -       andi    \pte, 0xffc
> -       add     \ptr, \ptr, \pte
> -       lw      \pte, [\ptr, 0]
> -       .endm
> -
> -       .macro  pte_reload, ptr
> -       lw      \ptr, [\ptr, 0]
> -       mtcr    \ptr, cr12
> -       nop
> -       nop
> -       nop
> -       nop
> -       nop
> -       .endm
> -
> -       .macro do_fault, write
> -       SAVE_ALL
> -       mfcr    r6, cr6
> -       mv      r4, r0
> -       ldi     r5, \write
> -       la      r8, do_page_fault
> -       brl     r8
> -       j       ret_from_exception
> -       .endm
> -
> -       .macro  pte_writable, pte, ptr, label
> -       andi    \pte, 0x280
> -       cmpi.c  \pte, 0x280
> -       bne     \label
> -       lw      \pte, [\ptr, 0]         /*reload PTE*/
> -       .endm
> -
> -/*
> - * Make PTE writable, update software status bits as well,
> - * then store at PTR.
> - */
> -       .macro  pte_makewrite, pte, ptr
> -       ori     \pte, 0x426
> -       sw      \pte, [\ptr, 0]
> -       .endm
> -
> -       .text
> -ENTRY(score7_FTLB_refill_Handler)
> -       la      r31, pgd_current        /* get pgd pointer */
> -       lw      r31, [r31, 0]           /* get the address of PGD */
> -       mfcr    r30, cr6
> -       srli    r30, r30, 22            /* PGDIR_SHIFT = 22*/
> -       slli    r30, r30, 2
> -       add     r31, r31, r30
> -       lw      r31, [r31, 0]           /* get the address of the start address of PTE table */
> -
> -       mfcr    r30, cr9
> -       andi    r30, 0xfff              /* equivalent to get PET index and right shift 2 bits */
> -       add     r31, r31, r30
> -       lw      r30, [r31, 0]           /* load pte entry */
> -       mtcr    r30, cr12
> -       nop
> -       nop
> -       nop
> -       nop
> -       nop
> -       mtrtlb
> -       nop
> -       nop
> -       nop
> -       nop
> -       nop
> -       rte                             /* 6 cycles to make sure tlb entry works */
> -
> -ENTRY(score7_KSEG_refill_Handler)
> -       la      r31, pgd_current        /* get pgd pointer */
> -       lw      r31, [r31, 0]           /* get the address of PGD */
> -       mfcr    r30, cr6
> -       srli    r30, r30, 22            /* PGDIR_SHIFT = 22 */
> -       slli    r30, r30, 2
> -       add     r31, r31, r30
> -       lw      r31, [r31, 0]           /* get the address of the start address of PTE table */
> -
> -       mfcr    r30, cr6                /* get Bad VPN */
> -       srli    r30, r30, 10
> -       andi    r30, 0xffc              /* PTE VPN mask (bit 11~2) */
> -
> -       add     r31, r31, r30
> -       lw      r30, [r31, 0]           /* load pte entry */
> -       mtcr    r30, cr12
> -       nop
> -       nop
> -       nop
> -       nop
> -       nop
> -       mtrtlb
> -       nop
> -       nop
> -       nop
> -       nop
> -       nop
> -       rte                             /* 6 cycles to make sure tlb entry works */
> -
> -nopage_tlbl:
> -       do_fault        0               /* Read */
> -
> -ENTRY(handle_tlb_refill)
> -       load_pte        r30, r31
> -       pte_writable    r30, r31, handle_tlb_refill_nopage
> -       pte_makewrite   r30, r31        /* Access|Modify|Dirty|Valid */
> -       pte_reload      r31
> -       mtrtlb
> -       nop
> -       nop
> -       nop
> -       nop
> -       nop
> -       rte
> -handle_tlb_refill_nopage:
> -       do_fault        0               /* Read */
> -
> -ENTRY(handle_tlb_invaild)
> -       load_pte        r30, r31
> -       stlb                            /* find faulting entry */
> -       pte_writable    r30, r31, handle_tlb_invaild_nopage
> -       pte_makewrite   r30, r31        /* Access|Modify|Dirty|Valid */
> -       pte_reload      r31
> -       mtptlb
> -       nop
> -       nop
> -       nop
> -       nop
> -       nop
> -       rte
> -handle_tlb_invaild_nopage:
> -       do_fault        0               /* Read */
> -
> -ENTRY(handle_mod)
> -       load_pte        r30, r31
> -       stlb                            /* find faulting entry */
> -       andi    r30, _PAGE_WRITE        /* Writable? */
> -       cmpz.c  r30
> -       beq     nowrite_mod
> -       lw      r30, [r31, 0]           /* reload into r30 */
> -
> -       /* Present and writable bits set, set accessed and dirty bits. */
> -       pte_makewrite   r30, r31
> -
> -       /* Now reload the entry into the tlb. */
> -       pte_reload      r31
> -       mtptlb
> -       nop
> -       nop
> -       nop
> -       nop
> -       nop
> -       rte
> -
> -nowrite_mod:
> -       do_fault        1       /* Write */
> diff --git a/arch/score/mm/tlb-score.c b/arch/score/mm/tlb-score.c
> deleted file mode 100644
> index 0040737..0000000
> --- a/arch/score/mm/tlb-score.c
> +++ /dev/null
> @@ -1,251 +0,0 @@
> -/*
> - * arch/score/mm/tlb-score.c
> - *
> - * Score Processor version.
> - *
> - * Copyright (C) 2009 Sunplus Core Technology Co., Ltd.
> - *  Lennox Wu <lennox.wu@sunplusct.com>
> - *  Chen Liqin <liqin.chen@sunplusct.com>
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
> - *
> - * This program is distributed in the hope that it will be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, see the file COPYING, or write
> - * to the Free Software Foundation, Inc.,
> - * 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> - */
> -
> -#include <linux/highmem.h>
> -#include <linux/module.h>
> -
> -#include <asm/irq.h>
> -#include <asm/mmu_context.h>
> -#include <asm/tlb.h>
> -
> -#define TLBSIZE 32
> -
> -unsigned long asid_cache = ASID_FIRST_VERSION;
> -EXPORT_SYMBOL(asid_cache);
> -
> -void local_flush_tlb_all(void)
> -{
> -       unsigned long flags;
> -       unsigned long old_ASID;
> -       int entry;
> -
> -       local_irq_save(flags);
> -       old_ASID = pevn_get() & ASID_MASK;
> -       pectx_set(0);                   /* invalid */
> -       entry = tlblock_get();          /* skip locked entries*/
> -
> -       for (; entry < TLBSIZE; entry++) {
> -               tlbpt_set(entry);
> -               pevn_set(KSEG1);
> -               barrier();
> -               tlb_write_indexed();
> -       }
> -       pevn_set(old_ASID);
> -       local_irq_restore(flags);
> -}
> -
> -/*
> - * If mm is currently active_mm, we can't really drop it. Instead,
> - * we will get a new one for it.
> - */
> -static inline void
> -drop_mmu_context(struct mm_struct *mm)
> -{
> -       unsigned long flags;
> -
> -       local_irq_save(flags);
> -       get_new_mmu_context(mm);
> -       pevn_set(mm->context & ASID_MASK);
> -       local_irq_restore(flags);
> -}
> -
> -void local_flush_tlb_mm(struct mm_struct *mm)
> -{
> -       if (mm->context != 0)
> -               drop_mmu_context(mm);
> -}
> -
> -void local_flush_tlb_range(struct vm_area_struct *vma, unsigned long start,
> -       unsigned long end)
> -{
> -       struct mm_struct *mm = vma->vm_mm;
> -       unsigned long vma_mm_context = mm->context;
> -       if (mm->context != 0) {
> -               unsigned long flags;
> -               int size;
> -
> -               local_irq_save(flags);
> -               size = (end - start + (PAGE_SIZE - 1)) >> PAGE_SHIFT;
> -               if (size <= TLBSIZE) {
> -                       int oldpid = pevn_get() & ASID_MASK;
> -                       int newpid = vma_mm_context & ASID_MASK;
> -
> -                       start &= PAGE_MASK;
> -                       end += (PAGE_SIZE - 1);
> -                       end &= PAGE_MASK;
> -                       while (start < end) {
> -                               int idx;
> -
> -                               pevn_set(start | newpid);
> -                               start += PAGE_SIZE;
> -                               barrier();
> -                               tlb_probe();
> -                               idx = tlbpt_get();
> -                               pectx_set(0);
> -                               pevn_set(KSEG1);
> -                               if (idx < 0)
> -                                       continue;
> -                               tlb_write_indexed();
> -                       }
> -                       pevn_set(oldpid);
> -               } else {
> -                       /* Bigger than TLBSIZE, get new ASID directly */
> -                       get_new_mmu_context(mm);
> -                       if (mm == current->active_mm)
> -                               pevn_set(vma_mm_context & ASID_MASK);
> -               }
> -               local_irq_restore(flags);
> -       }
> -}
> -
> -void local_flush_tlb_kernel_range(unsigned long start, unsigned long end)
> -{
> -       unsigned long flags;
> -       int size;
> -
> -       local_irq_save(flags);
> -       size = (end - start + (PAGE_SIZE - 1)) >> PAGE_SHIFT;
> -       if (size <= TLBSIZE) {
> -               int pid = pevn_get();
> -
> -               start &= PAGE_MASK;
> -               end += PAGE_SIZE - 1;
> -               end &= PAGE_MASK;
> -
> -               while (start < end) {
> -                       long idx;
> -
> -                       pevn_set(start);
> -                       start += PAGE_SIZE;
> -                       tlb_probe();
> -                       idx = tlbpt_get();
> -                       if (idx < 0)
> -                               continue;
> -                       pectx_set(0);
> -                       pevn_set(KSEG1);
> -                       barrier();
> -                       tlb_write_indexed();
> -               }
> -               pevn_set(pid);
> -       } else {
> -               local_flush_tlb_all();
> -       }
> -
> -       local_irq_restore(flags);
> -}
> -
> -void local_flush_tlb_page(struct vm_area_struct *vma, unsigned long page)
> -{
> -       if (vma && vma->vm_mm->context != 0) {
> -               unsigned long flags;
> -               int oldpid, newpid, idx;
> -               unsigned long vma_ASID = vma->vm_mm->context;
> -
> -               newpid = vma_ASID & ASID_MASK;
> -               page &= PAGE_MASK;
> -               local_irq_save(flags);
> -               oldpid = pevn_get() & ASID_MASK;
> -               pevn_set(page | newpid);
> -               barrier();
> -               tlb_probe();
> -               idx = tlbpt_get();
> -               pectx_set(0);
> -               pevn_set(KSEG1);
> -               if (idx < 0)            /* p_bit(31) - 1: miss, 0: hit*/
> -                       goto finish;
> -               barrier();
> -               tlb_write_indexed();
> -finish:
> -               pevn_set(oldpid);
> -               local_irq_restore(flags);
> -       }
> -}
> -
> -/*
> - * This one is only used for pages with the global bit set so we don't care
> - * much about the ASID.
> - */
> -void local_flush_tlb_one(unsigned long page)
> -{
> -       unsigned long flags;
> -       int oldpid, idx;
> -
> -       local_irq_save(flags);
> -       oldpid = pevn_get();
> -       page &= (PAGE_MASK << 1);
> -       pevn_set(page);
> -       barrier();
> -       tlb_probe();
> -       idx = tlbpt_get();
> -       pectx_set(0);
> -       if (idx >= 0) {
> -               /* Make sure all entries differ. */
> -               pevn_set(KSEG1);
> -               barrier();
> -               tlb_write_indexed();
> -       }
> -       pevn_set(oldpid);
> -       local_irq_restore(flags);
> -}
> -
> -void __update_tlb(struct vm_area_struct *vma, unsigned long address, pte_t pte)
> -{
> -       unsigned long flags;
> -       int idx, pid;
> -
> -       /*
> -        * Handle debugger faulting in for debugee.
> -        */
> -       if (current->active_mm != vma->vm_mm)
> -               return;
> -
> -       pid = pevn_get() & ASID_MASK;
> -
> -       local_irq_save(flags);
> -       address &= PAGE_MASK;
> -       pevn_set(address | pid);
> -       barrier();
> -       tlb_probe();
> -       idx = tlbpt_get();
> -       pectx_set(pte_val(pte));
> -       pevn_set(address | pid);
> -       if (idx < 0)
> -               tlb_write_random();
> -       else
> -               tlb_write_indexed();
> -
> -       pevn_set(pid);
> -       local_irq_restore(flags);
> -}
> -
> -void tlb_init(void)
> -{
> -       tlblock_set(0);
> -       local_flush_tlb_all();
> -       memcpy((void *)(EXCEPTION_VECTOR_BASE_ADDR + 0x100),
> -                       &score7_FTLB_refill_Handler, 0xFC);
> -       flush_icache_range(EXCEPTION_VECTOR_BASE_ADDR + 0x100,
> -                       EXCEPTION_VECTOR_BASE_ADDR + 0x1FC);
> -}
> --
> 1.7.9.7
>
