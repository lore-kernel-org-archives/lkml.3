Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751307AbaKFLL2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 06:11:28 -0500
Received: from mail-wg0-f42.google.com ([74.125.82.42]:41701 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750846AbaKFLLW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 06:11:22 -0500
Message-ID: <545B5756.9030905@suse.cz>
Date: Thu, 06 Nov 2014 12:11:18 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
CC: lwn@lwn.net
Subject: Linux 3.12.32
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

I'm announcing the release of the 3.12.32 kernel.

All users of the 3.12 kernel series must upgrade.

The updated 3.12.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git
linux-3.12.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

- ----------------------------------------------------------------
Al Viro (17):
      switch shrink_dcache_for_umount() to use of d_walk()
      fold __d_shrink() into its only remaining caller
      fold try_to_ascend() into the sole remaining caller
      fold d_kill() and d_free()
      fold try_prune_one_dentry()
      new helper: dentry_free()
      expand the call of dentry_lru_del() in dentry_kill()
      dentry_kill(): don't try to remove from shrink list
      don't remove from shrink list in select_collect()
      more graceful recovery in umount_collect()
      lift the "already marked killed" case into shrink_dentry_list()
      split dentry_kill()
      expand dentry_kill(dentry, 0) in shrink_dentry_list()
      shrink_dentry_list(): take parent's ->d_lock earlier
      dealing with the rest of shrink_dentry_list() livelock
      dentry_kill() doesn't need the second argument now
      lock_parent: don't step on stale ->d_parent of all-but-freed one

Alexander Usyskin (1):
      mei: bus: fix possible boundaries violation

Allen Pais (3):
      sparc64: correctly recognise M6 and M7 cpu type
      sparc64: support M6 and M7 for building CPU distribution map
      sparc64: cpu hardware caps support for sparc M6 and M7

Anatol Pomozov (1):
      ALSA: pcm: use the same dma mmap codepath both for arm and arm64

Andreas Henriksson (1):
      ARM: at91: fix at91sam9263ek DT mmc pinmuxing settings

Andreas Larsson (1):
      sparc: Let memset return the address argument

Andy Adamson (1):
      NFSv4.1: Fix an NFSv4.1 state renewal regression

Andy Lutomirski (1):
      fs: Add a missing permission check to do_umount

Andy Shevchenko (3):
      spi: dw-mid: respect 8 bit mode
      spi: dw-mid: check that DMA was inited before exit
      spi: dw-mid: terminate ongoing transfers at exit

Anssi Hannula (1):
      ALSA: hda - hdmi: Fix missing ELD change event on plug/unplug

Arjun Sreedharan (1):
      usb: phy: return -ENODEV on failure of try_module_get

Arun Easi (1):
      qla2xxx: Use correct offset to req-q-out for reserve calculation

Bryan O'Donoghue (2):
      usb: pch_udc: usb gadget device support for Intel Quark X1000
      x86/intel/quark: Switch off CR4.PGE so TLB flush uses CR3 instead

Champion Chen (1):
      Bluetooth: Fix issue with USB suspend in btusb driver

Chao Yu (1):
      ecryptfs: avoid to access NULL pointer when write metadata in xattr

Chris J Arges (1):
      mptfusion: enable no_write_same for vmware scsi disks

Christian Borntraeger (1):
      KVM: s390: unintended fallthrough for external call

Daniel Hellstrom (1):
      sparc32: dma_alloc_coherent must honour gfp flags

Dave Chinner (1):
      xfs: ensure WB_SYNC_ALL writeback handles partial pages correctly

Dave Kleikamp (2):
      sparc64: Increase size of boot string to 1024 bytes
      Revert "sparc64: Fix __copy_{to,from}_user_inatomic defines."

David Matlack (3):
      kvm: x86: fix stale mmio cache bug
      kvm: fix potentially corrupt mmio cache
      kvm: don't take vcpu mutex for obviously invalid vcpu ioctls

David S. Miller (35):
      sparc64: Do not disable interrupts in nmi_cpu_busy()
      sparc64: Fix pcr_ops initialization and usage bugs.
      sparc64: Fix corrupted thread fault code.
      sparc64: Fix reversed start/end in flush_tlb_kernel_range()
      sparc64: Fix lockdep warnings on reboot on Ultra-5
      sparc64: Fix FPU register corruption with AES crypto offload.
      sparc64: Do not define thread fpregs save area as zero-length array.
      sparc64: Fix register corruption in top-most kernel stack frame during boot.
      sparc64: Implement __get_user_pages_fast().
      sparc64: Clean up 64-bit mmap exclusion defines.
      sparc64: Use PAGE_OFFSET instead of a magic constant.
      sparc64: Define PAGE_OFFSET in terms of physical address bits.
      sparc64: Document the shift counts used to validate linear kernel addresses.
      sparc64: Fix inconsistent max-physical-address defines.
      sparc64: Make PAGE_OFFSET variable.
      sparc64: Move from 4MB to 8MB huge pages.
      sparc64: Move to 64-bit PGDs and PMDs.
      sparc64: Encode huge PMDs using PTE encoding.
      sparc64: Fix executable bit testing in set_pmd_at() paths.
      sparc64: Fix huge PMD invalidation.
      sparc64: Fix bugs in get_user_pages_fast() wrt. THP.
      sparc64: Fix hex values in comment above pte_modify().
      sparc64: Don't use _PAGE_PRESENT in pte_modify() mask.
      sparc64: Fix range check in kern_addr_valid().
      sparc64: Use 'ILOG2_4MB' instead of constant '22'.
      sparc64: Add basic validations to {pud,pmd}_bad().
      sparc64: Fix hibernation code refrence to PAGE_OFFSET.
      sparc64: Switch to 4-level page tables.
      sparc64: Define VA hole at run time, rather than at compile time.
      sparc64: Adjust KTSB assembler to support larger physical addresses.
      sparc64: Fix physical memory management regressions with large max_phys_bits.
      sparc64: Use kernel page tables for vmemmap.
      sparc64: Increase MAX_PHYS_ADDRESS_BITS to 53.
      sparc64: Adjust vmalloc region size based upon available virtual address bits.
      sparc64: Kill unnecessary tables and increase MAX_BANKS.

David Sterba (1):
      btrfs: wake up transaction thread from SYNC_FS ioctl

Douglas Lehr (1):
      PCI: Increase IBM ipr SAS Crocodile BARs to at least system page size

Eliad Peller (1):
      regulatory: fix misapplied alpha2 fix

Ezequiel Garcia (1):
      drm/tilcdc: Fix the error path in tilcdc_load()

Frans Klaver (1):
      tty: omap-serial: fix division by zero

Geert Uytterhoeven (1):
      m68k: Disable/restore interrupts in hwreg_present()/hwreg_write()

Harsha Priya (1):
      ALSA: ALC283 codec - Avoid pop noise on headphones during suspend/resume

Ilya Dryomov (1):
      libceph: ceph-msgr workqueue needs a resque worker

Jan Kara (1):
      ext2: Fix fs corruption in ext2_get_xip_mem()

Jiri Slaby (1):
      Linux 3.12.32

Johannes Weiner (1):
      mm: memcontrol: do not iterate uninitialized memcgs

Josef Ahmad (1):
      pci_ids: Add support for Intel Quark ILB

Josef Bacik (3):
      Btrfs: try not to ENOSPC on log replay
      Btrfs: cleanup error handling in build_backref_tree
      Btrfs: fix build_backref_tree issue with multiple shared blocks

Junxiao Bi (1):
      mm: clear __GFP_FS when PF_MEMALLOC_NOIO is set

K. Y. Srinivasan (5):
      Drivers: hv: vmbus: Cleanup vmbus_post_msg()
      Drivers: hv: vmbus: Cleanup vmbus_teardown_gpadl()
      Drivers: hv: vmbus: Cleanup vmbus_close_internal()
      Drivers: hv: vmbus: Cleanup vmbus_establish_gpadl()
      Drivers: hv: vmbus: Fix a bug in vmbus_open()

Kees Cook (1):
      firmware_class: make sure fw requests contain a name

Linus Torvalds (1):
      dcache: add missing lockdep annotation

Loic Poulain (1):
      Bluetooth: Fix HCI H5 corrupted ack value

Lu Baolu (1):
      USB: Add device quirk for ASUS T100 Base Station keyboard

Ludovic Desroches (1):
      ARM: at91/PMC: don't forget to write PMC_PCDR register to disable clocks

Mark Knibbs (2):
      storage: Add quirk for another SCM-based USB-SCSI converter
      storage: Add quirks for Castlewood and Double-H USB-SCSI converters

Michael Ellerman (2):
      powerpc: Add smp_mb() to arch_spin_is_locked()
      powerpc: Add smp_mb()s to arch_spin_unlock_wait()

Michal Kubeček (1):
      net: fix checksum features handling in netif_skb_features()

Mike Christie (1):
      be2iscsi: check ip buffer before copying

Miklos Szeredi (1):
      dcache: don't need rcu in shrink_dentry_list()

Oren Givon (1):
      iwlwifi: Add missing PCI IDs for the 7260 series

Pali Rohár (1):
      dell-wmi: Fix access out of memory

Pankaj Dubey (1):
      regmap: fix NULL pointer dereference in _regmap_write/read

Pawel Moll (1):
      perf: Handle compat ioctl

Ricardo Ribalda Delgado (1):
      PCI: Generate uppercase hex for modalias interface class

Sage Weil (1):
      Btrfs: fix race in WAIT_SYNC ioctl

Sanjeev Sharma (1):
      uas: replace WARN_ON_ONCE() with lockdep_assert_held()

Sasha Levin (1):
      kernel: add support for gcc 5

Shen Guang (1):
      usb:hub set hub->change_bits when over-current happens

Slava Pestov (2):
      bcache: fix memory corruption in init error path
      bcache: fix crash with incomplete cache set

Sowmini Varadhan (1):
      sparc64: Move request_irq() from ldc_bind() to ldc_alloc()

Stanislaw Gruszka (1):
      rt2800: correct BBP1_TX_POWER_CTRL mask

Surbhi Palande (1):
      bcache: Correct printing of btree_gc_max_duration_ms

Takashi Iwai (1):
      ALSA: emu10k1: Fix deadlock in synth voice lookup

Thomas Petazzoni (1):
      PCI: mvebu: Fix uninitialized variable in mvebu_get_tgt_attr()

Trond Myklebust (2):
      NFSv4: Fix lock recovery when CREATE_SESSION/SETCLIENTID_CONFIRM fails
      NFSv4: fix open/lock state recovery error handling

Victor Kamensky (1):
      arm64: compat: fix compat types affecting struct compat_elf_prpsinfo

Vince Weaver (1):
      perf/x86/intel: Use proper dTLB-load-misses event on IvyBridge

Vlad Catoi (1):
      ALSA: usb-audio: Add support for Steinberg UR22 USB interface

Willy Tarreau (3):
      Documentation: lzo: document part of the encoding
      Revert "lzo: properly check for overruns"
      lzo: check for length overrun in variable length encoding.

Xiubo Li (2):
      regmap: debugfs: fix possbile NULL pointer dereference
      regmap: fix possible ZERO_SIZE_PTR pointer dereferencing error.

Yann Droneaud (1):
      fanotify: enable close-on-exec on events' fd when requested in fanotify_init()

bob picco (4):
      sparc64: sun4v TLB error power off events
      sparc64: find_node adjustment
      sparc64: T5 PMU
      sparc64: sparse irq

oftedal (1):
      sparc: PCI: Fix incorrect address calculation of PCI Bridge windows on Simba-bridges

 Documentation/lzo.txt                   | 164 +++++
 Documentation/virtual/kvm/mmu.txt       |  14 +
 Makefile                                |   2 +-
 arch/arm/boot/dts/at91sam9263.dtsi      |   2 +
 arch/arm/mach-at91/clock.c              |   1 +
 arch/arm64/include/asm/compat.h         |   4 +-
 arch/m68k/mm/hwtest.c                   |   6 +
 arch/powerpc/include/asm/spinlock.h     |   8 +-
 arch/powerpc/lib/locks.c                |   4 +
 arch/s390/kvm/interrupt.c               |   1 +
 arch/sparc/Kconfig                      |   1 +
 arch/sparc/include/asm/hypervisor.h     |  11 +
 arch/sparc/include/asm/irq_64.h         |   7 +-
 arch/sparc/include/asm/ldc.h            |   5 +-
 arch/sparc/include/asm/mmu_64.h         |   1 -
 arch/sparc/include/asm/oplib_64.h       |   3 +-
 arch/sparc/include/asm/page_64.h        |  44 +-
 arch/sparc/include/asm/pgalloc_64.h     |  28 +-
 arch/sparc/include/asm/pgtable_64.h     | 305 +++++----
 arch/sparc/include/asm/setup.h          |   4 +
 arch/sparc/include/asm/sparsemem.h      |   6 +-
 arch/sparc/include/asm/spitfire.h       |   2 +
 arch/sparc/include/asm/thread_info_64.h |   4 +-
 arch/sparc/include/asm/tsb.h            | 193 +++---
 arch/sparc/include/asm/uaccess_64.h     |   4 +-
 arch/sparc/include/asm/visasm.h         |   8 +
 arch/sparc/kernel/cpu.c                 |  12 +
 arch/sparc/kernel/cpumap.c              |   2 +
 arch/sparc/kernel/ds.c                  |   4 +-
 arch/sparc/kernel/dtlb_prot.S           |   6 +-
 arch/sparc/kernel/entry.h               |   3 -
 arch/sparc/kernel/head_64.S             |  56 +-
 arch/sparc/kernel/hvapi.c               |   1 +
 arch/sparc/kernel/hvcalls.S             |  16 +
 arch/sparc/kernel/hvtramp.S             |   1 -
 arch/sparc/kernel/ioport.c              |   5 +-
 arch/sparc/kernel/irq_64.c              | 507 ++++++++++-----
 arch/sparc/kernel/ktlb.S                | 105 +---
 arch/sparc/kernel/ldc.c                 |  41 +-
 arch/sparc/kernel/nmi.c                 |   1 -
 arch/sparc/kernel/pci.c                 |   4 +-
 arch/sparc/kernel/pcr.c                 |  47 +-
 arch/sparc/kernel/perf_event.c          |  10 +-
 arch/sparc/kernel/process_64.c          |   3 +
 arch/sparc/kernel/setup_64.c            |  36 +-
 arch/sparc/kernel/smp_64.c              |   8 +-
 arch/sparc/kernel/sun4v_tlb_miss.S      |  37 +-
 arch/sparc/kernel/sys_sparc_64.c        |   3 -
 arch/sparc/kernel/trampoline_64.S       |  12 +-
 arch/sparc/kernel/traps_64.c            |  15 +-
 arch/sparc/kernel/tsb.S                 |   8 +-
 arch/sparc/kernel/viohs.c               |   4 +-
 arch/sparc/kernel/vmlinux.lds.S         |   5 +-
 arch/sparc/lib/NG4memcpy.S              |  14 +-
 arch/sparc/lib/clear_page.S             |   4 +-
 arch/sparc/lib/copy_page.S              |   4 +-
 arch/sparc/lib/memset.S                 |  18 +-
 arch/sparc/mm/fault_64.c                |   3 +
 arch/sparc/mm/gup.c                     |  39 +-
 arch/sparc/mm/hugetlbpage.c             |   2 -
 arch/sparc/mm/init_64.c                 | 732 ++++++++++------------
 arch/sparc/mm/init_64.h                 |  22 +-
 arch/sparc/mm/tlb.c                     |  35 +-
 arch/sparc/mm/tsb.c                     |  13 +-
 arch/sparc/mm/ultra.S                   |  12 +-
 arch/sparc/power/hibernate_asm.S        |   4 +-
 arch/sparc/prom/bootstr_64.c            |   5 +-
 arch/sparc/prom/cif.S                   |   5 +-
 arch/sparc/prom/init_64.c               |   6 +-
 arch/sparc/prom/p1275.c                 |   9 +-
 arch/x86/include/asm/kvm_host.h         |   1 +
 arch/x86/kernel/cpu/intel.c             |  15 +
 arch/x86/kernel/cpu/perf_event_intel.c  |   3 +
 arch/x86/kvm/mmu.c                      |  22 +-
 arch/x86/kvm/x86.h                      |  20 +-
 drivers/base/firmware_class.c           |   3 +
 drivers/base/regmap/regmap-debugfs.c    |   8 +-
 drivers/base/regmap/regmap.c            |   7 +-
 drivers/bluetooth/btusb.c               |   9 +
 drivers/bluetooth/hci_h5.c              |   2 +-
 drivers/gpu/drm/tilcdc/tilcdc_drv.c     |  60 +-
 drivers/hv/channel.c                    |  49 +-
 drivers/hv/connection.c                 |  17 +-
 drivers/md/bcache/bcache.h              |   4 +
 drivers/md/bcache/super.c               |  15 +-
 drivers/md/bcache/util.h                |   4 +-
 drivers/message/fusion/mptspi.c         |   5 +
 drivers/misc/mei/bus.c                  |   2 +-
 drivers/net/wireless/iwlwifi/pcie/drv.c |   4 +
 drivers/net/wireless/rt2x00/rt2800.h    |   2 +-
 drivers/pci/host/pci-mvebu.c            |   6 +-
 drivers/pci/pci-sysfs.c                 |   2 +-
 drivers/pci/quirks.c                    |  20 +
 drivers/platform/x86/dell-wmi.c         |  12 +-
 drivers/scsi/be2iscsi/be_mgmt.c         |  13 +-
 drivers/scsi/qla2xxx/qla_target.c       |   4 +-
 drivers/spi/spi-dw-mid.c                |  10 +-
 drivers/tty/serial/omap-serial.c        |  12 +-
 drivers/usb/core/hub.c                  |   3 +-
 drivers/usb/core/quirks.c               |   4 +
 drivers/usb/gadget/Kconfig              |   3 +-
 drivers/usb/gadget/pch_udc.c            |  22 +-
 drivers/usb/phy/phy.c                   |   3 +
 drivers/usb/storage/uas.c               |   4 +-
 drivers/usb/storage/unusual_devs.h      |  24 +-
 fs/btrfs/inode.c                        |   3 +-
 fs/btrfs/ioctl.c                        |   6 +
 fs/btrfs/relocation.c                   |  93 ++-
 fs/btrfs/transaction.c                  |  12 +-
 fs/dcache.c                             | 586 +++++++----------
 fs/ecryptfs/inode.c                     |   2 +-
 fs/ext2/inode.c                         |   2 +
 fs/ext2/xip.c                           |   1 +
 fs/namespace.c                          |   2 +
 fs/nfs/nfs4proc.c                       |   2 +-
 fs/nfs/nfs4renewd.c                     |  12 +-
 fs/nfs/nfs4state.c                      |  17 +-
 fs/notify/fanotify/fanotify_user.c      |   2 +-
 fs/xfs/xfs_aops.c                       |  16 +-
 include/linux/compiler-gcc5.h           |  66 ++
 include/linux/dcache.h                  |   2 +
 include/linux/kvm_host.h                |   2 -
 include/linux/pci_ids.h                 |   1 +
 include/linux/sched.h                   |   6 +-
 include/linux/usb/quirks.h              |   3 +
 include/net/regulatory.h                |   4 +-
 kernel/events/core.c                    |  23 +-
 lib/lzo/lzo1x_decompress_safe.c         | 103 +--
 mm/memcontrol.c                         |  33 +-
 net/ceph/messenger.c                    |   6 +-
 net/core/dev.c                          |  16 +-
 sound/core/pcm_native.c                 |   2 +-
 sound/pci/emu10k1/emu10k1_callback.c    |   6 +-
 sound/pci/hda/patch_hdmi.c              |  15 +-
 sound/pci/hda/patch_realtek.c           |   3 +
 sound/usb/quirks-table.h                |  30 +
 virt/kvm/kvm_main.c                     |  25 +-
 137 files changed, 2549 insertions(+), 1658 deletions(-)
 create mode 100644 Documentation/lzo.txt
 create mode 100644 include/linux/compiler-gcc5.h

thanks,
- -- 
js
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUW1dWAAoJEL0lsQQGtHBJsEUP/RlPU6NQzyWLA+JUuuZnJctt
aC+MVpyU9G8lCpPBoycUQ8Cslpuwk2KD6+g768YZ8XDpkqdpWPSrKAuVBXbylVVW
8CuhnMphv0mSh1M/WIc7OfAORcmlfGjvAjPI2ZkJqFbOUtp9s1k7GSL6TYXxG8QF
1NJ1weCNoY3L4mQ7N+HiVhvAk3K/TYDq424PSFjVNNLsOmkbyEjQpQ5DK0WuTiHv
dT2A9V1mcr/7bs5yCIZPTMfB1LocPLBjzTOCRPWWIMtQFgbRLxddawheEl5VCJ86
ARc86GhdVFd2AORdoWkTBzwETcLH/nyUptha+ppb5xo+6ovryeLH1MBAVJ5k6nVn
7Vxg0+T6C2BCfpC52rUPrwPzCRqb1Txfogb064TXMdXVDhoDOhtF2G7WsNO9puAe
CfepWmjrQgcTNKwAqkEbROIcQUJT8aNQNw8H+jTtEp3jAFeQ9YKnRkZR9MuXrXBw
HU3bW0sS2KSBTs2pPOC7F/xCn+Ennli4qZE3FkPfXgBxU/CJoTXVxPw54j1QxQjq
uNbp0Rz1PDRjPglEFitzodVrVbcefc7V32icFT2JbPig3l6EsSXaf8bsYNgaw7XS
ygCr6xt49FihgEYQEYLhvOFsOSwCP5xrEOiHXc2xKRfvoA4/o/q1FnSnzylP8QKl
cweMDKA7VHSoEqkqsmIa
=WRTz
-----END PGP SIGNATURE-----
