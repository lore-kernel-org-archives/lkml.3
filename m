Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933262AbbA1EK1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 23:10:27 -0500
Received: from mail.kernel.org ([198.145.29.136]:36394 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760160AbbA1EKS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 23:10:18 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux@roeck-us.net,
        satoru.takeuchi@gmail.com, Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 000/177] 3.4.106-rc1 review
Date: Wed, 28 Jan 2015 12:07:30 +0800
Message-Id: <1422418050-12581-1-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zefan Li <lizefan@huawei.com>

This is the start of the stable review cycle for the 3.4.106 release.
There are 177 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri Jan 30 03:58:34 UTC 2015.
Anything received after that time might be too late.

A combined patch relative to 3.4.105 will be posted as an additional
response to this.  A shortlog and diffstat can be found below.

thanks,

Zefan Li

--------------------

Aaro Koskinen (1):
  MIPS: oprofile: Fix backtrace on 64-bit kernel

Adel Gadllah (2):
  USB: quirks: enable device-qualifier quirk for another Elan
    touchscreen
  USB: quirks: enable device-qualifier quirk for yet another Elan
    touchscreen

Al Viro (1):
  fix misuses of f_count() in ppp and netlink

Alan Stern (1):
  usb-storage: handle a skipped data phase

Alex Deucher (2):
  drm/radeon: remove invalid pci id
  drm/radeon: add missing crtc unlock when setting up the MC

Alexey Khoroshilov (2):
  dm log userspace: fix memory leak in dm_ulog_tfr_init failure path
  can: esd_usb2: fix memory leak on disconnect

Anatol Pomozov (1):
  ALSA: pcm: use the same dma mmap codepath both for arm and arm64

Andreas Bomholtz (1):
  USB: cp210x: add support for Seluxit USB dongle

Andreas Noever (1):
  PCI: pciehp: Prevent NULL dereference during probe

Andy Adamson (1):
  NFSv4.1: Fix an NFSv4.1 state renewal regression

Andy Honig (2):
  KVM: x86: Prevent host from panicking on shared MSR writes.
  KVM: x86: Improve thread safety in pit

Andy Lutomirski (8):
  x86,kvm,vmx: Preserve CR4 across VM entry
  x86, apic: Handle a bad TSC more gracefully
  x86_64, traps: Stop using IST for #SS
  x86_64, traps: Fix the espfix64 #DF fixup and rewrite it in C
  x86_64, traps: Rework bad_iret
  x86/asm/traps: Disable tracing and kprobes in fixup_bad_iret and
    sync_regs
  x86, kvm: Clear paravirt_enabled on KVM guests for espfix32's benefit
  x86/tls: Validate TLS entries to protect espfix

Andy Shevchenko (2):
  spi: dw-mid: respect 8 bit mode
  spi: dw-mid: terminate ongoing transfers at exit

Anton Blanchard (1):
  powerpc: do_notify_resume can be called with bad thread_info flags
    argument

Artem Bityutskiy (3):
  UBIFS: remove mst_mutex
  UBIFS: fix a race condition
  UBIFS: fix free log space calculation

Bart Van Assche (1):
  srp-target: Retry when QP creation fails with ENOMEM

Ben Hutchings (1):
  x86: Reject x32 executables if x32 ABI not supported

Benjamin Coddington (1):
  lockd: Try to reconnect if statd has moved

Benjamin Herrenschmidt (1):
  of/base: Fix PowerPC address parsing hack

Borislav Petkov (1):
  mpc85xx_edac: Make L2 interrupt shared too

Brian Silverman (1):
  futex: Fix a race condition between REQUEUE_PI and task death

Bryan O'Donoghue (2):
  x86/intel/quark: Switch off CR4.PGE so TLB flush uses CR3 instead
  serial: 8250: Add Quark X1000 to 8250_pci.c

Catalin Marinas (1):
  futex: Ensure get_futex_key_refs() always implies a barrier

Cesar Eduardo Barros (1):
  crypto: more robust crypto_memneq

Champion Chen (1):
  Bluetooth: Fix issue with USB suspend in btusb driver

Chao Yu (1):
  ecryptfs: avoid to access NULL pointer when write metadata in xattr

Chris Mason (1):
  Btrfs: fix kfree on list_head in btrfs_lookup_csums_range error
    cleanup

Christian Borntraeger (1):
  KVM: s390: unintended fallthrough for external call

Christoph Hellwig (1):
  scsi: only re-lock door after EH on devices that were reset

Cong Wang (1):
  freezer: Do not freeze tasks killed by OOM killer

Cyril Brulebois (1):
  wireless: rt2x00: add new rt2800usb device

Dan Williams (1):
  USB: option: add Haier CE81B CDMA modem

Daniel Borkmann (1):
  random: add and use memzero_explicit() for clearing data

Daniele Palmas (1):
  usb: option: add support for Telit LE910

Darrick J. Wong (1):
  ext4: check EA value offset when loading

Dave Hansen (1):
  x86: Require exact match for 'noxsave' command line option

David Daney (1):
  MIPS: tlbex: Properly fix HUGE TLB Refill exception handler

David Matlack (2):
  kvm: x86: fix stale mmio cache bug
  kvm: don't take vcpu mutex for obviously invalid vcpu ioctls

David Rientjes (1):
  mm, thp: fix collapsing of hugepages on madvise

Dirk Brandewie (1):
  cpufreq: expose scaling_cur_freq sysfs file for set_policy() drivers

Dmitry Kasatkin (1):
  evm: check xattr value length and type in evm_inode_setxattr()

Dmitry Torokhov (1):
  Input: synaptics - gate forcepad support by DMI check

Douglas Lehr (1):
  PCI: Increase IBM ipr SAS Crocodile BARs to at least system page size

Eric Sandeen (1):
  ext4: fix reservation overflow in ext4_da_write_begin

Eric W. Biederman (1):
  mnt: Prevent pivot_root from creating a loop in the mount tree

Fabio Estevam (1):
  ASoC: sgtl5000: Fix SMALL_POP bit definition

Felipe Balbi (1):
  usb: dwc3: gadget: fix set_halt() bug with pending transfers

Frans Klaver (1):
  usb: serial: ftdi_sio: add Awinda Station and Dongle products

Geert Uytterhoeven (1):
  m68k: Disable/restore interrupts in hwreg_present()/hwreg_write()

Grant Likely (1):
  of: Fix overflow bug in string property parsing functions

Guenter Roeck (1):
  Revert "percpu: free percpu allocation info for uniprocessor system"

Hans de Goede (5):
  Input: i8042 - add noloop quirk for Asus X750LN
  Input: i8042 - quirks for Fujitsu Lifebook A544 and Lifebook AH544
  samsung-laptop: Add broken-acpi-video quirk for NC210/NC110
  acer-wmi: Add acpi_backlight=video quirk for the Acer KAV80
  usb: Do not allow usb_alloc_streams on unconfigured devices

Heinz Mauelshagen (1):
  dm raid: ensure superblock's size matches device's logical block size

Herbert Xu (1):
  macvtap: Fix csum_start when VLAN tags are present

Huacai Chen (1):
  MIPS: tlbex: Fix a missing statement for HUGETLB

Ilya Dryomov (1):
  libceph: do not crash on large auth tickets

Imre Deak (2):
  PM / Sleep: fix recovery during resuming from hibernation
  tty/vt: don't set font mappings on vc not supporting this

J. Bruce Fields (1):
  nfsd4: fix crash on unknown operation number

Jack Pham (1):
  usb: dwc3: gadget: Properly initialize LINK TRB

James Ralston (1):
  ahci: Add Device IDs for Intel Sunrise Point PCH

Jan Kara (11):
  ext4: don't check quota format when there are no quota files
  vfs: fix data corruption when blocksize < pagesize for mmaped data
  ext3: Don't check quota format when there are no quota files
  scsi: Fix error handling in SCSI_IOCTL_SEND_COMMAND
  lib/bitmap.c: fix undefined shift in __bitmap_shift_{left|right}()
  ext4: fix overflow when updating superblock backups after resize
  ext4: fix oops when loading block bitmap failed
  ext4: bail out from make_indexed_dir() on first error
  block: Fix computation of merged request priority
  nfs: Fix use of uninitialized variable in nfs_getattr()
  mm: Remove false WARN_ON from pagecache_isize_extended()

Joe Savage (1):
  USB: serial: cp210x: added Ketra N1 wireless interface support

Joe Thornber (1):
  dm bufio: update last_accessed when relinking a buffer

Johan Hedberg (1):
  Bluetooth: Fix setting correct security level when initiating SMP

Johan Hovold (5):
  USB: kobil_sct: fix non-atomic allocation in write path
  USB: opticon: fix non-atomic allocation in write path
  USB: cdc-acm: add device id for GW Instek AFG-2225
  USB: core: add device-qualifier quirk
  USB: cdc-acm: only raise DTR on transitions from B0

Johannes Berg (2):
  mac80211: properly flush delayed scan work on interface removal
  mac80211: fix use-after-free in defragmentation

Jonathan Cameron (1):
  staging:iio:impedance-analyzer:ad5933 unwind use of IIO_CHAN macro.

K. Y. Srinivasan (5):
  Drivers: hv: vmbus: Cleanup vmbus_post_msg()
  Drivers: hv: vmbus: Cleanup vmbus_teardown_gpadl()
  Drivers: hv: vmbus: Cleanup vmbus_establish_gpadl()
  Drivers: hv: vmbus: Fix a bug in vmbus_open()
  Drivers: hv: vmbus: Cleanup vmbus_close_internal()

Kees Cook (1):
  firmware_class: make sure fw requests contain a name

Krzysztof Kozlowski (1):
  power: charger-manager: Fix NULL pointer exception with missing
    cm-fuel-gauge

Kuninori Morimoto (1):
  ASoC: fsi: remove unsupported PAUSE flag

Lars-Peter Clausen (2):
  staging:iio:ad5933: Drop "raw" from channel names
  staging:iio:ade7758: Fix check if channels are enabled in prenable

Lu Baolu (1):
  USB: Add device quirk for ASUS T100 Base Station keyboard

Mathias Krause (1):
  posix-timers: Fix stack info leak in timer_create()

Max Filippov (1):
  xtensa: re-wire umount syscall to sys_oldumount

Michael S. Tsirkin (2):
  virtio_pci: fix virtio spec compliance on restore
  kvm: x86: don't kill guest on unknown exit reason

Michal Hocko (1):
  OOM, PM: OOM killed task shouldn't escape PM suspend

Mike Snitzer (1):
  block: fix alignment_offset math that assumes io_min is a power-of-2

Miklos Szeredi (1):
  audit: keep inode pinned

Mikulas Patocka (3):
  framebuffer: fix border color
  fs: make cont_expand_zero interruptible
  dm bufio: change __GFP_IO to __GFP_FS in shrinker callbacks

Nadav Amit (5):
  KVM: x86: Check non-canonical addresses upon WRMSR
  KVM: x86: Fix wrong masking on relative jump/call
  KVM: x86: Emulator fixes for eip canonical checks on near branches
  KVM: x86: Handle errors when RIP is set during far jumps
  KVM: x86: Fix uninitialized op->type for some immediate values

Nadav Har'El (1):
  nEPT: Nested INVEPT

Nathaniel Ting (1):
  USB: serial: cp210x: add Silicon Labs 358x VID and PID

Oleg Nesterov (2):
  kernel/fork.c:copy_process(): unify
    CLONE_THREAD-or-thread_group_leader code
  introduce for_each_thread() to replace the buggy while_each_thread()

Oliver Neukum (1):
  xhci: no switching back on non-ULT Haswell

Ondrej Zary (1):
  libata-sff: Fix controllers with no ctl port

Pali Rohár (2):
  Input: alps - ignore potential bare packets when device is out of sync
  Input: alps - allow up to 2 invalid packets without resetting device

Paolo Bonzini (1):
  KVM: x86: use new CS.RPL as CPL during task switch

Patrick Riphagen (2):
  USB: serial: ftdi_sio: Annotate the current Xsens PID assignments
  USB: serial: ftdi_sio: Add support for new Xsens devices

Perry Hung (1):
  usb: serial: ftdi_sio: add "bricked" FTDI device PID

Peter Hurley (3):
  serial: Fix divide-by-zero fault in uart_get_divisor()
  tty: Fix high cpu load if tty is unreleaseable
  tty: Prevent "read/write wait queue active!" log flooding

Petr Matousek (1):
  kvm: vmx: handle invvpid vm exit gracefully

Quentin Casasnovas (1):
  kvm: fix excessive pages un-pinning in kvm_iommu_map error path.

Quinn Tran (1):
  target: Fix queue full status NULL pointer for
    SCF_TRANSPORT_TASK_SENSE

Rabin Vincent (1):
  tracing/syscalls: Ignore numbers outside NR_syscalls' range

Ray Jui (1):
  spi: pl022: Fix incorrect dma_unmap_sg

Ricardo Ribalda Delgado (1):
  PCI: Generate uppercase hex for modalias interface class

Sasha Levin (1):
  kernel: add support for gcc 5

Scott Carter (1):
  pata_serverworks: disable 64-KB DMA transfers on Broadcom OSB4 IDE
    Controller

Sinclair Yeh (1):
  drm/vmwgfx: Filter out modes those cannot be supported by the current
    VRAM size.

Stanislaw Gruszka (2):
  rt2800: correct BBP1_TX_POWER_CTRL mask
  rt2x00: do not align payload on modern H/W

Stefan Richter (1):
  firewire: cdev: prevent kernel stack leaking into ioctl arguments

Stephen Smalley (1):
  selinux: fix inode security list corruption

Takashi Iwai (3):
  ALSA: emu10k1: Fix deadlock in synth voice lookup
  ALSA: pcm: Zero-clear reserved fields of PCM status ioctl in compat
    mode
  ALSA: usb-audio: Fix device_del() sysfs warnings at disconnect

Tetsuo Handa (1):
  fs: Fix theoretical division by 0 in super_cache_scan().

Theodore Ts'o (2):
  ext4: don't orphan or truncate the boot loader inode
  ext4: add ext4_iget_normal() which is to be used for dir tree lookups

Thomas Körper (1):
  can: dev: avoid calling kfree_skb() from interrupt context

Trond Myklebust (2):
  NFSv4: fix open/lock state recovery error handling
  NFSv4: Ensure that we remove NFSv4.0 delegations when state has
    expired

Vlad Catoi (1):
  ALSA: usb-audio: Add support for Steinberg UR22 USB interface

Wang Nan (1):
  cgroup/kmemleak: add kmemleak_free() for cgroup deallocations.

Will Deacon (2):
  zap_pte_range: update addr when forcing flush after TLB batching
    faiure
  tracing/syscalls: Fix perf syscall tracing when syscall_nr == -1

Willy Tarreau (3):
  Documentation: lzo: document part of the encoding
  Revert "lzo: properly check for overruns"
  lzo: check for length overrun in variable length encoding.

Xiubo Li (2):
  regmap: debugfs: fix possbile NULL pointer dereference
  regmap: fix possible ZERO_SIZE_PTR pointer dereferencing error.

Yann Droneaud (1):
  fanotify: enable close-on-exec on events' fd when requested in
    fanotify_init()

Yijing Wang (1):
  sysfs: driver core: Fix glue dir race condition by gdp_mutex

 Documentation/lzo.txt                           | 164 +++++++++++++++
 arch/m68k/mm/hwtest.c                           |   6 +
 arch/mips/mm/tlbex.c                            |   5 +
 arch/mips/oprofile/backtrace.c                  |   2 +-
 arch/powerpc/kernel/entry_64.S                  |   6 +
 arch/s390/kvm/interrupt.c                       |   1 +
 arch/x86/include/asm/elf.h                      |   5 +-
 arch/x86/include/asm/kvm_host.h                 |  17 +-
 arch/x86/include/asm/page_32_types.h            |   1 -
 arch/x86/include/asm/page_64_types.h            |  11 +-
 arch/x86/include/asm/vmx.h                      |   2 +
 arch/x86/kernel/apic/apic.c                     |   4 +-
 arch/x86/kernel/cpu/common.c                    |   2 +
 arch/x86/kernel/cpu/intel.c                     |  15 ++
 arch/x86/kernel/dumpstack_64.c                  |   1 -
 arch/x86/kernel/entry_64.S                      |  84 ++------
 arch/x86/kernel/kvm.c                           |   9 +-
 arch/x86/kernel/kvmclock.c                      |   1 -
 arch/x86/kernel/tls.c                           |  23 +++
 arch/x86/kernel/traps.c                         |  69 +++++--
 arch/x86/kernel/tsc.c                           |   5 +-
 arch/x86/kvm/emulate.c                          | 257 +++++++++++++++++-------
 arch/x86/kvm/i8254.c                            |   2 +
 arch/x86/kvm/mmu.c                              |   2 +-
 arch/x86/kvm/svm.c                              |   8 +-
 arch/x86/kvm/vmx.c                              |  51 ++++-
 arch/x86/kvm/x86.c                              |  38 +++-
 arch/x86/kvm/x86.h                              |  20 +-
 arch/xtensa/include/asm/unistd.h                |   3 +-
 block/blk-settings.c                            |   4 +-
 block/scsi_ioctl.c                              |   3 +-
 drivers/ata/ahci.c                              |   5 +
 drivers/ata/libata-sff.c                        |  20 +-
 drivers/ata/pata_serverworks.c                  |  13 +-
 drivers/base/core.c                             |   4 +-
 drivers/base/firmware_class.c                   |   3 +
 drivers/base/regmap/regmap-debugfs.c            |   7 +-
 drivers/base/regmap/regmap.c                    |   5 +
 drivers/bluetooth/btusb.c                       |   9 +
 drivers/char/random.c                           |  10 +-
 drivers/cpufreq/cpufreq.c                       |  23 ++-
 drivers/edac/mpc85xx_edac.c                     |   3 +-
 drivers/firewire/core-cdev.c                    |   3 +-
 drivers/gpu/drm/radeon/evergreen.c              |   1 +
 drivers/gpu/drm/vmwgfx/vmwgfx_kms.c             |  16 +-
 drivers/hv/channel.c                            |  47 +++--
 drivers/hv/connection.c                         |  17 +-
 drivers/infiniband/ulp/srpt/ib_srpt.c           |   8 +
 drivers/input/mouse/alps.c                      |  11 +-
 drivers/input/mouse/synaptics.c                 |  22 +-
 drivers/input/mouse/synaptics.h                 |   8 +-
 drivers/input/serio/i8042-x86ia64io.h           |  22 ++
 drivers/md/dm-bufio.c                           |  11 +-
 drivers/md/dm-log-userspace-transfer.c          |   2 +-
 drivers/md/dm-raid.c                            |  11 +-
 drivers/net/can/dev.c                           |   2 +-
 drivers/net/can/usb/esd_usb2.c                  |   1 +
 drivers/net/macvtap.c                           |   2 +
 drivers/net/ppp/ppp_generic.c                   |   2 +-
 drivers/net/wireless/rt2x00/rt2800.h            |   2 +-
 drivers/net/wireless/rt2x00/rt2800usb.c         |   1 +
 drivers/net/wireless/rt2x00/rt2x00queue.c       |  50 ++---
 drivers/of/address.c                            |  19 +-
 drivers/of/base.c                               |  88 ++------
 drivers/of/selftest.c                           |  64 +++++-
 drivers/pci/hotplug/pciehp_core.c               |   7 +
 drivers/pci/pci-sysfs.c                         |   2 +-
 drivers/pci/quirks.c                            |  20 ++
 drivers/platform/x86/acer-wmi.c                 |  11 +
 drivers/platform/x86/samsung-laptop.c           |  10 +
 drivers/power/charger-manager.c                 |   5 +
 drivers/scsi/scsi_error.c                       |   4 +-
 drivers/spi/spi-dw-mid.c                        |   7 +-
 drivers/spi/spi-pl022.c                         |   2 +-
 drivers/staging/iio/impedance-analyzer/ad5933.c |  47 ++++-
 drivers/staging/iio/meter/ade7758_ring.c        |   2 +-
 drivers/target/target_core_transport.c          |   3 +-
 drivers/tty/serial/8250/8250_pci.c              |  21 ++
 drivers/tty/serial/serial_core.c                |   2 +-
 drivers/tty/tty_io.c                            |  13 +-
 drivers/tty/vt/consolemap.c                     |   4 +
 drivers/usb/class/cdc-acm.c                     |   6 +-
 drivers/usb/core/hcd.c                          |   2 +
 drivers/usb/core/hub.c                          |   9 +-
 drivers/usb/core/quirks.c                       |  10 +
 drivers/usb/dwc3/ep0.c                          |   4 +-
 drivers/usb/dwc3/gadget.c                       |  17 +-
 drivers/usb/dwc3/gadget.h                       |   2 +-
 drivers/usb/host/xhci-pci.c                     |  14 --
 drivers/usb/serial/cp210x.c                     |   3 +
 drivers/usb/serial/ftdi_sio.c                   |   5 +
 drivers/usb/serial/ftdi_sio_ids.h               |  23 ++-
 drivers/usb/serial/kobil_sct.c                  |   4 +-
 drivers/usb/serial/opticon.c                    |   2 +-
 drivers/usb/serial/option.c                     |  10 +
 drivers/usb/storage/transport.c                 |  26 +++
 drivers/video/console/bitblit.c                 |   3 +-
 drivers/video/console/fbcon_ccw.c               |   3 +-
 drivers/video/console/fbcon_cw.c                |   3 +-
 drivers/video/console/fbcon_ud.c                |   3 +-
 drivers/virtio/virtio_pci.c                     |  33 ++-
 fs/btrfs/file-item.c                            |   2 +-
 fs/buffer.c                                     |   8 +
 fs/ecryptfs/inode.c                             |   2 +-
 fs/ext3/super.c                                 |   7 -
 fs/ext4/ext4.h                                  |   1 +
 fs/ext4/ialloc.c                                |   4 +
 fs/ext4/inode.c                                 |  32 ++-
 fs/ext4/namei.c                                 |  33 +--
 fs/ext4/resize.c                                |   2 +-
 fs/ext4/super.c                                 |   9 +-
 fs/ext4/xattr.c                                 |  32 ++-
 fs/ioprio.c                                     |  14 +-
 fs/lockd/mon.c                                  |   6 +
 fs/namespace.c                                  |   3 +
 fs/nfs/inode.c                                  |   2 +-
 fs/nfs/nfs4proc.c                               |  26 ++-
 fs/nfs/nfs4renewd.c                             |  12 +-
 fs/nfs/nfs4state.c                              |  16 +-
 fs/nfsd/nfs4proc.c                              |   3 +-
 fs/notify/fanotify/fanotify_user.c              |   2 +-
 fs/super.c                                      |   2 +
 fs/ubifs/commit.c                               |  10 +-
 fs/ubifs/log.c                                  |  19 +-
 fs/ubifs/master.c                               |   7 +-
 fs/ubifs/super.c                                |   1 -
 fs/ubifs/ubifs.h                                |   2 -
 include/drm/drm_pciids.h                        |   1 -
 include/linux/blkdev.h                          |   5 +-
 include/linux/compiler-gcc.h                    |   3 +
 include/linux/compiler-gcc5.h                   |  66 ++++++
 include/linux/compiler-intel.h                  |   7 +
 include/linux/init_task.h                       |   2 +
 include/linux/khugepaged.h                      |  17 +-
 include/linux/mm.h                              |   1 +
 include/linux/of.h                              |  84 ++++++--
 include/linux/oom.h                             |   4 +
 include/linux/sched.h                           |  12 ++
 include/linux/string.h                          |   4 +-
 include/linux/usb/quirks.h                      |   6 +
 kernel/audit_tree.c                             |   1 +
 kernel/exit.c                                   |   1 +
 kernel/fork.c                                   |  22 +-
 kernel/freezer.c                                |   3 +
 kernel/futex.c                                  |  24 ++-
 kernel/posix-timers.c                           |   1 +
 kernel/power/hibernate.c                        |   8 +-
 kernel/power/process.c                          |  40 +++-
 kernel/trace/trace_syscalls.c                   |   8 +-
 lib/bitmap.c                                    |   8 +-
 lib/lzo/lzo1x_decompress_safe.c                 | 103 +++++-----
 lib/string.c                                    |  16 ++
 mm/huge_memory.c                                |  11 +-
 mm/memory.c                                     |   4 +-
 mm/mmap.c                                       |   8 +-
 mm/oom_kill.c                                   |  17 ++
 mm/page_alloc.c                                 |   8 +
 mm/page_cgroup.c                                |   1 +
 mm/percpu.c                                     |   2 -
 mm/truncate.c                                   |  61 +++++-
 net/bluetooth/smp.c                             |   5 +-
 net/ceph/crypto.c                               | 169 ++++++++++++----
 net/mac80211/iface.c                            |   7 +-
 net/mac80211/rx.c                               |  14 +-
 security/integrity/evm/evm_main.c               |   9 +-
 security/selinux/hooks.c                        |   2 +-
 sound/core/pcm_compat.c                         |   2 +
 sound/core/pcm_native.c                         |   2 +-
 sound/pci/emu10k1/emu10k1_callback.c            |   6 +-
 sound/soc/codecs/sgtl5000.c                     |   3 +-
 sound/soc/codecs/sgtl5000.h                     |   2 +-
 sound/soc/sh/fsi.c                              |   3 +-
 sound/usb/card.c                                |   9 +-
 sound/usb/quirks-table.h                        |  30 +++
 virt/kvm/iommu.c                                |   8 +-
 virt/kvm/kvm_main.c                             |   4 +
 176 files changed, 2061 insertions(+), 705 deletions(-)
 create mode 100644 Documentation/lzo.txt
 create mode 100644 include/linux/compiler-gcc5.h

-- 
1.9.1

