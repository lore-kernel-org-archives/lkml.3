Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756268Ab3AQVYY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 16:24:24 -0500
Received: from mail1.windriver.com ([147.11.146.13]:39493 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754708Ab3AQVYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 16:24:19 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <linux-kernel@vger.kernel.org>, <torvalds@linux-foundation.org>,
        <akpm@linux-foundation.org>, <gregkh@linuxfoundation.org>
CC: Paul Gortmaker <paul.gortmaker@windriver.com>, <stable@vger.kernel.org>,
        <lwn@lwn.net>
Subject: Linux 2.6.34.14
Date: Thu, 17 Jan 2013 16:24:02 -0500
Message-ID: <1358457842-13335-1-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm announcing the release of the 2.6.34.14 kernel.

All 2.6.34 users are strongly encouraged to update.

Please also note that there will be a limited number of further
updates to the 2.6.34 line -- on the order of one or two more
releases.  So you may want to start thinking about your upgrade plan.

The updated 2.6.34.y git tree can be found at:
   git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-2.6.34.y
and can be browsed at the normal kernel.org git web browser:
   http://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=shortlog;h=refs/heads/linux-2.6.34.y

Thanks,
Paul.
---

The following changes since commit 5b765b08fa5fbbba1131dcc459f8991d81e4f8d7:

  Linux 2.6.34.13 (2012-08-20 14:45:22 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git tags/v2.6.34.14

for you to fetch changes up to c12a2ff7096edca9f610ef813253c1bceeb2800d:

  Linux 2.6.34.14 (2013-01-16 16:55:31 -0500)

----------------------------------------------------------------
This is the 2.6.34.14 stable release

----------------------------------------------------------------
Andrea Arcangeli (1):
      ext4: avoid hangs in ext4_da_should_update_i_disksize()

Bankim Bhavsar (1):
      ALSA: hda - Add support for VMware controller

Bart Westgeest (1):
      staging: usbip: bugfix for deadlock

Benjamin Poirier (1):
      gro: reset vlan_tci on reuse

Bernd Porr (1):
      staging: comedi: fix oops for USB DAQ devices.

Bjorn Helgaas (2):
      PCI hotplug: shpchp: don't blindly claim non-AMD 0x7450 device IDs
      x86/mpparse: Account for bus types other than ISA and PCI

Chanho Min (1):
      sched/rt: Fix task stack corruption under __ARCH_WANT_INTERRUPTS_ON_CTXSW

Christoph Hellwig (1):
      xfs: validate acl count

Dan Carpenter (1):
      USB: whci-hcd: fix endian conversion in qset_clear()

Daniel T Chen (1):
      ALSA: hda: Use position_fix=1 for Acer Aspire 5538 to enable capture on internal mic

David Dillow (1):
      ALSA: sis7019 - give slow codecs more time to reset

Eliad Peller (1):
      nl80211: fix MAC address validation

Eric Paris (1):
      inotify: stop kernel memory leak on file creation failure

Eric W. Biederman (1):
      net: Fix ip link add netns oops

Eryu Guan (1):
      jbd/jbd2: validate sb->s_first in journal_get_superblock()

Federico Vaga (1):
      Staging: comedi: fix signal handling in read and write

Hannes Reinecke (1):
      Silencing 'killing requests for dead queue'

Hans Verkuil (1):
      ARM: davinci: dm646x evm: wrong register used in setup_vpif_input_channel_mode

Hector Palacios (1):
      timekeeping: add arch_offset hook to ktime_get functions

Ido Yariv (1):
      genirq: Fix race condition when stopping the irq thread

Jacek Luczak (1):
      SCTP: fix race between sctp_bind_addr_free() and sctp_bind_addr_conflict()

Jan Kara (3):
      udf: Fortify loading of sparing table
      udf: Avoid run away loop when partition table length is corrupted
      udf: Improve table length check to avoid possible overflow

Jan Kiszka (1):
      KVM: x86: Prevent starting PIT timers in the absence of irqchip support

Jason Wang (1):
      net: sock: validate data_len before allocating skb in sock_alloc_send_pskb()

Jeffrey (Sheng-Hui) Chu (1):
      i2c-algo-bit: Generate correct i2c address sequence for 10-bit target

John Stultz (3):
      time: Improve sanity checking of timekeeping inputs
      time: Avoid making adjustments if we haven't accumulated anything
      time: Move ktime_t overflow checking into timespec_valid_strict

Krzysztof Hałasa (1):
      USB: cdc-acm: add IDs for Motorola H24 HSPA USB module.

Linus Torvalds (2):
      linux/log2.h: Fix rounddown_pow_of_two(1)
      Make TASKSTATS require root access

Marcin Kościelnicki (1):
      usb: ftdi_sio: add PID for Propox ISPcable III

Matthew Garrett (1):
      x86: Don't use the EFI reboot method by default

Michael Büsch (2):
      p54spi: Add missing spin_lock_init
      p54spi: Fix workqueue deadlock

Neil Horman (1):
      sctp: Fix list corruption resulting from freeing an association on a list

NeilBrown (2):
      md: Fix handling for devices from 2TB to 4TB in 0.90 metadata.
      md: Don't truncate size at 4TB for RAID0 and Linear

Otavio Salvador (1):
      ALSA: hda: add Vortex86MX PCI ids

Paul Gortmaker (1):
      Linux 2.6.34.14

Peter Zijlstra (2):
      perf_events: Fix races in group composition
      perf: Fix tear-down of inherited group events

Phillip Lougher (1):
      hfs: fix hfs_find_init() sb->ext_tree NULL ptr oops

Qinglin Ye (1):
      USB: usb-storage: unusual_devs entry for Kingston DT 101 G2

Richard Weinberger (2):
      um: Use RWSEM_GENERIC_SPINLOCK on x86
      x86: Get rid of asmregparm

Robert Richter (4):
      oprofile, x86: Fix crash when unloading module (nmi timer mode)
      oprofile: Free potentially owned tasks in case of errors
      oprofile: Fix locking dependency in sync_start()
      oprofile, x86: Fix nmi-unsafe callgraph support

Salman Qazi (1):
      sched, x86: Avoid unnecessary overflow in sched_clock

Seth Heasley (2):
      ALSA: hda_intel: ALSA HD Audio patch for Intel Patsburg DeviceIDs
      ALSA: hda - ALSA HD Audio patch for Intel Panther Point DeviceIDs

Stanislaw Gruszka (1):
      sched: fix divide by zero at {thread_group,task}_times

Suresh Jayaraman (1):
      cifs: fix cifs stable patch cifs-fix-oplock-break-handling-try-2.patch

Suresh Siddha (1):
      x86, ioapic: initialize nr_ioapic_registers early in mp_register_ioapic()

Takashi Iwai (2):
      ALSA: hda - Reduce pci id list for Intel with class id
      ALSA: hda/realtek - Fix Oops in alc_mux_select()

Tejun Heo (2):
      percpu: fix first chunk match in per_cpu_ptr_to_phys()
      percpu: fix chunk range calculation

Thadeu Lima de Souza Cascardo (1):
      genalloc: stop crashing the system when destroying a pool

Thomas Gleixner (2):
      tick-broadcast: Stop active broadcast device when replacing it
      rwsem: Remove redundant asmregparm annotation

Thomas Graf (2):
      sctp: ABORT if receive, reassmbly, or reodering queue is not empty while closing socket
      sctp: Enforce retransmission limit during shutdown

Tim Blechmann (1):
      ALSA: lx6464es - fix device communication via command bus

Trond Myklebust (1):
      SUNRPC: Ensure we return EAGAIN in xs_nospace if congestion is cleared

Tushar Gohad (1):
      xfrm: Fix key lengths for rfc3686(ctr(aes))

Tyler Hicks (1):
      eCryptfs: Extend array bounds for all filename chars

Veli-Pekka Peltola (1):
      usb: option: add SIMCom SIM5218

Wei Yongjun (1):
      sctp: malloc enough room for asconf-ack chunk

Will Deacon (2):
      ARM: 7161/1: errata: no automatic store buffer drain
      mutex: Place lock in contended state after fastpath_lock failure

Xi Wang (1):
      xfs: fix acl count validation in xfs_acl_from_disk()

Xiao Guangrong (1):
      export __get_user_pages_fast() function

 Makefile                                 |   2 +-
 arch/arm/Kconfig                         |  12 ++++
 arch/arm/kernel/process.c                |   3 +
 arch/arm/mach-davinci/board-dm646x-evm.c |   6 +-
 arch/um/Kconfig.x86                      |   4 +-
 arch/x86/include/asm/linkage.h           |   5 --
 arch/x86/include/asm/rwsem.h             |  12 ++--
 arch/x86/include/asm/timer.h             |  23 ++++++-
 arch/x86/kernel/apic/io_apic.c           |   9 ++-
 arch/x86/kernel/efi.c                    |   3 -
 arch/x86/kernel/mpparse.c                |   2 +-
 arch/x86/kernel/ptrace.c                 |   4 +-
 arch/x86/kvm/i8254.c                     |  10 ++-
 arch/x86/oprofile/backtrace.c            |  46 ++++++++++++--
 arch/x86/oprofile/init.c                 |   7 ++-
 drivers/i2c/algos/i2c-algo-bit.c         |   4 +-
 drivers/md/md.c                          |  15 ++++-
 drivers/net/wireless/p54/p54spi.c        |   5 +-
 drivers/oprofile/buffer_sync.c           |  21 ++++---
 drivers/pci/hotplug/shpchp_core.c        |   4 +-
 drivers/pci/hotplug/shpchp_hpc.c         |   4 +-
 drivers/scsi/scsi_lib.c                  |   3 +-
 drivers/staging/comedi/comedi_fops.c     |  75 ++++++++++++++++------
 drivers/staging/usbip/vhci_rx.c          |  10 +--
 drivers/usb/class/cdc-acm.c              |  10 +++
 drivers/usb/host/whci/qset.c             |   2 +-
 drivers/usb/serial/ftdi_sio.c            |   1 +
 drivers/usb/serial/ftdi_sio_ids.h        |   1 +
 drivers/usb/serial/option.c              |   1 +
 drivers/usb/storage/unusual_devs.h       |   7 +++
 fs/cifs/misc.c                           |   3 +
 fs/ecryptfs/crypto.c                     |   4 +-
 fs/ext4/inode.c                          |   2 +-
 fs/hfs/btree.c                           |  20 ++++--
 fs/jbd/journal.c                         |   8 +++
 fs/jbd2/journal.c                        |   8 +++
 fs/notify/inotify/inotify_user.c         |   1 +
 fs/udf/super.c                           |  96 ++++++++++++++++++----------
 fs/xfs/linux-2.6/xfs_acl.c               |   4 +-
 include/asm-generic/mutex-xchg.h         |  11 +++-
 include/linux/ktime.h                    |   7 ---
 include/linux/linkage.h                  |   4 --
 include/linux/log2.h                     |   1 -
 include/linux/perf_event.h               |   4 ++
 include/linux/time.h                     |  29 ++++++++-
 include/net/sctp/command.h               |   1 +
 include/net/sctp/ulpevent.h              |   2 +-
 kernel/irq/manage.c                      |   5 +-
 kernel/perf_event.c                      | 104 ++++++++++++++++++++++---------
 kernel/sched.c                           |  34 +++++-----
 kernel/sched_rt.c                        |   5 ++
 kernel/taskstats.c                       |   1 +
 kernel/time/tick-broadcast.c             |   2 +-
 kernel/time/timekeeping.c                |  23 ++++++-
 lib/genalloc.c                           |   2 +-
 lib/rwsem.c                              |  10 ++-
 mm/percpu.c                              |  64 ++++++++++++++-----
 mm/util.c                                |  13 ++++
 net/core/dev.c                           |   1 +
 net/core/rtnetlink.c                     |   3 +
 net/core/sock.c                          |   7 ++-
 net/sctp/bind_addr.c                     |  10 ++-
 net/sctp/input.c                         |   7 +--
 net/sctp/outqueue.c                      |  20 +++++-
 net/sctp/sm_make_chunk.c                 |   4 +-
 net/sctp/sm_sideeffect.c                 |  20 +++++-
 net/sctp/sm_statefuns.c                  |  32 +++++++---
 net/sctp/sm_statetable.c                 |   2 +-
 net/sctp/socket.c                        |  25 +++++---
 net/sctp/ulpevent.c                      |  16 ++++-
 net/sunrpc/xprtsock.c                    |   3 +-
 net/wireless/nl80211.c                   |   4 +-
 net/xfrm/xfrm_algo.c                     |   4 +-
 sound/pci/hda/hda_intel.c                |  29 +++++----
 sound/pci/hda/patch_realtek.c            |   2 +
 sound/pci/lx6464es/lx_core.c             |  16 +++--
 sound/pci/sis7019.c                      |  64 +++++++++++++++----
 77 files changed, 764 insertions(+), 284 deletions(-)
