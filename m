Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750914AbaLNSq2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 13:46:28 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33825 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750865AbaLNSqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 13:46:13 -0500
Message-ID: <1418582727.30883.2.camel@decadent.org.uk>
Subject: Linux 3.2.65
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, Jiri Slaby <jslaby@suse.cz>,
        stable@vger.kernel.org
Cc: lwn@lwn.net
Date: Sun, 14 Dec 2014 18:45:27 +0000
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-mPMtw4CtwxEZNBBbOUT3"
X-Mailer: Evolution 3.12.9-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 82.132.229.130
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-mPMtw4CtwxEZNBBbOUT3
Content-Type: multipart/mixed; boundary="=-RgCyPFCDhQU5Y3OPX3cz"


--=-RgCyPFCDhQU5Y3OPX3cz
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.2.65 kernel.

All users of the 3.2 kernel series should upgrade.

The updated 3.2.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.g=
it linux-3.2.y
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git

The diff from 3.2.64 is attached to this message.

Ben.

------------

 Documentation/lzo.txt                           | 164 ++++++++++++++++++++=
+++
 Makefile                                        |   2 +-
 arch/arm/mm/proc-xscale.S                       |   4 +-
 arch/m68k/mm/hwtest.c                           |   6 +
 arch/mips/include/asm/ftrace.h                  |   4 +-
 arch/mips/loongson/common/Makefile              |   3 +-
 arch/mips/oprofile/backtrace.c                  |   2 +-
 arch/s390/kvm/interrupt.c                       |   1 +
 arch/x86/include/asm/kvm_host.h                 |   1 +
 arch/x86/include/asm/page_32_types.h            |   1 -
 arch/x86/include/asm/page_64_types.h            |  11 +-
 arch/x86/kernel/apic/apic.c                     |  14 +-
 arch/x86/kernel/cpu/common.c                    |   2 +
 arch/x86/kernel/cpu/intel.c                     |  15 +++
 arch/x86/kernel/dumpstack_64.c                  |   1 -
 arch/x86/kernel/entry_64.S                      |  84 +++---------
 arch/x86/kernel/traps.c                         |  69 ++++++++--
 arch/x86/kernel/tsc.c                           |   5 +-
 arch/x86/kvm/mmu.c                              |   2 +-
 arch/x86/kvm/svm.c                              |   6 +-
 arch/x86/kvm/vmx.c                              |   6 +-
 arch/x86/kvm/x86.h                              |  20 ++-
 arch/x86/mm/init_64.c                           |  16 ++-
 arch/xtensa/include/asm/unistd.h                |   3 +-
 block/blk-settings.c                            |   4 +-
 block/scsi_ioctl.c                              |   3 +-
 crypto/algif_skcipher.c                         |   2 +-
 drivers/ata/ahci.c                              |  19 ++-
 drivers/ata/libata-sff.c                        |  20 ++-
 drivers/ata/pata_serverworks.c                  |  13 +-
 drivers/base/firmware_class.c                   |   3 +
 drivers/bluetooth/btusb.c                       |   9 ++
 drivers/char/random.c                           |  10 +-
 drivers/firewire/core-cdev.c                    |   3 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_kms.c             |  16 ++-
 drivers/hv/channel.c                            |  45 +++++--
 drivers/hv/connection.c                         |  17 ++-
 drivers/hv/hv.c                                 |  28 ++--
 drivers/hv/hyperv_vmbus.h                       |   4 +
 drivers/input/joystick/xpad.c                   |  16 ++-
 drivers/input/mouse/alps.c                      |  11 +-
 drivers/input/mouse/synaptics.c                 |  22 ++-
 drivers/input/mouse/synaptics.h                 |   8 +-
 drivers/input/serio/i8042-x86ia64io.h           |  22 +++
 drivers/md/dm-bufio.c                           |  11 +-
 drivers/md/dm-log-userspace-transfer.c          |   2 +-
 drivers/md/dm-raid.c                            |  11 +-
 drivers/media/dvb/frontends/ds3000.c            |   7 +
 drivers/media/video/uvc/uvc_driver.c            |   9 ++
 drivers/media/video/v4l2-common.c               |   9 +-
 drivers/net/can/dev.c                           |   2 +-
 drivers/net/can/usb/esd_usb2.c                  |   1 +
 drivers/net/ppp/ppp_generic.c                   |   2 +-
 drivers/net/wireless/rt2x00/rt2800.h            |   2 +-
 drivers/net/wireless/rt2x00/rt2800usb.c         |   1 +
 drivers/net/wireless/rt2x00/rt2x00queue.c       |  50 ++-----
 drivers/of/address.c                            |  20 ++-
 drivers/pci/hotplug/pciehp_core.c               |   7 +
 drivers/pci/pci-sysfs.c                         |   2 +-
 drivers/pci/quirks.c                            |  20 +++
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c               |   7 +
 drivers/scsi/hpsa.c                             |   4 +-
 drivers/scsi/scsi_error.c                       |   4 +-
 drivers/spi/spi-dw-mid.c                        |  10 +-
 drivers/spi/spi-dw.c                            |   6 +-
 drivers/spi/spi-pl022.c                         |   2 +-
 drivers/staging/iio/impedance-analyzer/ad5933.c |   4 +-
 drivers/staging/iio/meter/ade7758_core.c        |  30 ++---
 drivers/staging/iio/sysfs.h                     |   2 +-
 drivers/staging/mei/init.c                      |   9 ++
 drivers/staging/mei/interrupt.c                 |   4 +-
 drivers/staging/mei/main.c                      |  27 ++++
 drivers/staging/mei/mei_dev.h                   |  12 +-
 drivers/target/target_core_transport.c          |   3 +-
 drivers/tty/serial/serial_core.c                |   2 +-
 drivers/tty/tty_io.c                            |   7 +-
 drivers/tty/vt/consolemap.c                     |   2 +
 drivers/usb/class/cdc-acm.c                     |   6 +-
 drivers/usb/core/hcd.c                          |   2 +
 drivers/usb/core/hub.c                          |   6 +-
 drivers/usb/core/quirks.c                       |  10 ++
 drivers/usb/gadget/udc-core.c                   |   5 +
 drivers/usb/host/xhci-hub.c                     |   5 +-
 drivers/usb/host/xhci-pci.c                     |  16 +--
 drivers/usb/host/xhci-ring.c                    |  43 ++----
 drivers/usb/host/xhci.c                         |  99 ++++++++------
 drivers/usb/host/xhci.h                         |   2 +-
 drivers/usb/serial/cp210x.c                     |   4 +
 drivers/usb/serial/ftdi_sio.c                   |  36 +++++
 drivers/usb/serial/ftdi_sio_ids.h               |  51 ++++++-
 drivers/usb/serial/keyspan.c                    |  96 ++++++++------
 drivers/usb/serial/kobil_sct.c                  |   5 +-
 drivers/usb/serial/opticon.c                    |   2 +-
 drivers/usb/serial/option.c                     |  10 ++
 drivers/usb/serial/ssu100.c                     |  11 +-
 drivers/usb/storage/transport.c                 |  26 ++++
 drivers/video/cfbcopyarea.c                     |  13 +-
 drivers/video/console/bitblit.c                 |   3 +-
 drivers/video/console/fbcon_ccw.c               |   3 +-
 drivers/video/console/fbcon_cw.c                |   3 +-
 drivers/video/console/fbcon_ud.c                |   3 +-
 fs/buffer.c                                     |   8 ++
 fs/ecryptfs/inode.c                             |   2 +-
 fs/ext3/super.c                                 |   7 -
 fs/ext4/ext4.h                                  |   1 +
 fs/ext4/ialloc.c                                |   4 +
 fs/ext4/inode.c                                 |  31 ++++-
 fs/ext4/namei.c                                 |  33 +++--
 fs/ext4/resize.c                                |   2 +-
 fs/ext4/super.c                                 |   9 +-
 fs/ext4/xattr.c                                 |  32 +++--
 fs/ioprio.c                                     |  14 +-
 fs/lockd/mon.c                                  |   6 +
 fs/nfs/nfs4proc.c                               |   2 +-
 fs/nfs/nfs4renewd.c                             |  12 +-
 fs/nfs/nfs4state.c                              |  16 +--
 fs/nfsd/nfs4callback.c                          |   8 +-
 fs/nfsd/nfs4proc.c                              |   3 +-
 fs/notify/fanotify/fanotify_user.c              |   2 +-
 fs/super.c                                      |   2 +
 fs/ubifs/commit.c                               |  10 +-
 fs/ubifs/log.c                                  |  19 ++-
 fs/ubifs/master.c                               |   7 +-
 fs/ubifs/super.c                                |   1 -
 fs/ubifs/ubifs.h                                |   2 -
 include/drm/drm_pciids.h                        |   1 -
 include/linux/blkdev.h                          |   5 +-
 include/linux/compiler-gcc.h                    |   3 +
 include/linux/compiler-gcc5.h                   |  66 +++++++++
 include/linux/compiler-intel.h                  |   7 +
 include/linux/compiler.h                        |   4 +
 include/linux/khugepaged.h                      |  17 ++-
 include/linux/mm.h                              |   1 +
 include/linux/string.h                          |   2 +
 include/linux/usb/quirks.h                      |   3 +
 include/net/tcp.h                               |  23 +++-
 kernel/audit_tree.c                             |   1 +
 kernel/events/core.c                            |  22 ++-
 kernel/futex.c                                  |  22 +--
 kernel/posix-timers.c                           |   1 +
 kernel/power/hibernate.c                        |   8 +-
 kernel/trace/trace_syscalls.c                   |   8 +-
 lib/bitmap.c                                    |   8 +-
 lib/lzo/lzo1x_decompress_safe.c                 | 103 ++++++++-------
 lib/string.c                                    |  16 +++
 mm/huge_memory.c                                |  11 +-
 mm/memory.c                                     |   4 +-
 mm/mmap.c                                       |   8 +-
 mm/page_cgroup.c                                |   1 +
 mm/truncate.c                                   |  55 +++++++-
 net/ceph/crypto.c                               | 169 ++++++++++++++++++--=
----
 net/ceph/messenger.c                            |   7 +-
 net/ipv4/ip_output.c                            |   2 +-
 net/ipv4/tcp_ipv4.c                             |   2 +-
 net/ipv6/tcp_ipv6.c                             |   2 +-
 net/mac80211/iface.c                            |   7 +-
 net/mac80211/rx.c                               |  14 +-
 net/sunrpc/svcsock.c                            |  27 ++--
 security/integrity/evm/evm_main.c               |   9 +-
 security/selinux/hooks.c                        |   2 +-
 sound/core/pcm_compat.c                         |   2 +
 sound/pci/emu10k1/emu10k1_callback.c            |   6 +-
 sound/pci/hda/hda_intel.c                       |  14 +-
 sound/soc/codecs/sgtl5000.c                     |   3 +-
 sound/soc/codecs/sgtl5000.h                     |   2 +-
 sound/soc/sh/fsi.c                              |   3 +-
 sound/usb/card.c                                |   9 +-
 virt/kvm/iommu.c                                |   8 +-
 virt/kvm/kvm_main.c                             |   4 +
 169 files changed, 1688 insertions(+), 705 deletions(-)

Aaro Koskinen (2):
      MIPS: oprofile: Fix backtrace on 64-bit kernel
      MIPS: Loongson: Make platform serial setup always built-in.

Al Viro (1):
      fix misuses of f_count() in ppp and netlink

Alan Stern (1):
      usb-storage: handle a skipped data phase

Alex Deucher (1):
      drm/radeon: remove invalid pci id

Alexey Khoroshilov (2):
      dm log userspace: fix memory leak in dm_ulog_tfr_init failure path
      can: esd_usb2: fix memory leak on disconnect

Andreas Bomholtz (1):
      USB: cp210x: add support for Seluxit USB dongle

Andreas Noever (1):
      PCI: pciehp: Prevent NULL dereference during probe

Andy Adamson (1):
      NFSv4.1: Fix an NFSv4.1 state renewal regression

Andy Lutomirski (5):
      x86, apic: Handle a bad TSC more gracefully
      x86_64, traps: Stop using IST for #SS
      x86_64, traps: Fix the espfix64 #DF fixup and rewrite it in C
      x86_64, traps: Rework bad_iret
      x86/asm/traps: Disable tracing and kprobes in fixup_bad_iret and sync=
_regs

Andy Shevchenko (3):
      spi: dw-mid: respect 8 bit mode
      spi: dw-mid: check that DMA was inited before exit
      spi: dw-mid: terminate ongoing transfers at exit

Artem Bityutskiy (3):
      UBIFS: remove mst_mutex
      UBIFS: fix a race condition
      UBIFS: fix free log space calculation

Ben Hutchings (2):
      compiler: Define OPTIMIZER_HIDE_VAR
      Linux 3.2.65

Benjamin Coddington (1):
      lockd: Try to reconnect if statd has moved

Benjamin Herrenschmidt (1):
      of/base: Fix PowerPC address parsing hack

Brian Silverman (1):
      futex: Fix a race condition between REQUEUE_PI and task death

Bryan O'Donoghue (1):
      x86/intel/quark: Switch off CR4.PGE so TLB flush uses CR3 instead

Champion Chen (1):
      Bluetooth: Fix issue with USB suspend in btusb driver

Chao Yu (1):
      ecryptfs: avoid to access NULL pointer when write metadata in xattr

Christian Borntraeger (1):
      KVM: s390: unintended fallthrough for external call

Christoph Hellwig (1):
      scsi: only re-lock door after EH on devices that were reset

Chuck Lever (1):
      sunrpc: fix byte-swapping of displayed XID

Cristina Ciocan (1):
      iio: Fix IIO_EVENT_CODE_EXTRACT_DIR bit mask

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

David Matlack (2):
      kvm: x86: fix stale mmio cache bug
      kvm: don't take vcpu mutex for obviously invalid vcpu ioctls

David Rientjes (1):
      mm, thp: fix collapsing of hugepages on madvise

Dmitry Eremin-Solenikov (1):
      ARM: 8216/1: xscale: correct auxiliary register in suspend/resume

Dmitry Kasatkin (1):
      evm: check xattr value length and type in evm_inode_setxattr()

Dmitry Torokhov (1):
      Input: synaptics - gate forcepad support by DMI check

Douglas Lehr (1):
      PCI: Increase IBM ipr SAS Crocodile BARs to at least system page size

Eric Dumazet (1):
      tcp: be more strict before accepting ECN negociation

Eric Sandeen (1):
      ext4: fix reservation overflow in ext4_da_write_begin

Fabio Estevam (1):
      ASoC: sgtl5000: Fix SMALL_POP bit definition

Felipe Balbi (1):
      usb: gadget: udc: core: fix kernel oops with soft-connect

Frans Klaver (1):
      usb: serial: ftdi_sio: add Awinda Station and Dongle products

Geert Uytterhoeven (1):
      m68k: Disable/restore interrupts in hwreg_present()/hwreg_write()

Greg Kroah-Hartman (1):
      Input: xpad - use proper endpoint type

Hans de Goede (4):
      Input: i8042 - add noloop quirk for Asus X750LN
      Input: i8042 - quirks for Fujitsu Lifebook A544 and Lifebook AH544
      usb: Do not allow usb_alloc_streams on unconfigured devices
      usb-quirks: Add reset-resume quirk for MS Wireless Laser Mouse 6000

Heinz Mauelshagen (1):
      dm raid: ensure superblock's size matches device's logical block size

Ilya Dryomov (2):
      libceph: ceph-msgr workqueue needs a resque worker
      libceph: do not crash on large auth tickets

Imre Deak (2):
      PM / Sleep: fix recovery during resuming from hibernation
      tty/vt: don't set font mappings on vc not supporting this

J. Bruce Fields (1):
      nfsd4: fix crash on unknown operation number

James Ralston (1):
      ahci: Add Device IDs for Intel Sunrise Point PCH

Jan Kara (10):
      ext4: don't check quota format when there are no quota files
      vfs: fix data corruption when blocksize < pagesize for mmaped data
      ext3: Don't check quota format when there are no quota files
      scsi: Fix error handling in SCSI_IOCTL_SEND_COMMAND
      lib/bitmap.c: fix undefined shift in __bitmap_shift_{left|right}()
      ext4: fix overflow when updating superblock backups after resize
      ext4: fix oops when loading block bitmap failed
      ext4: bail out from make_indexed_dir() on first error
      block: Fix computation of merged request priority
      mm: Remove false WARN_ON from pagecache_isize_extended()

Jeffrey Knockel (1):
      Patch for 3.2.x, 3.4.x IP identifier regression

Joe Savage (1):
      USB: serial: cp210x: added Ketra N1 wireless interface support

Joe Thornber (1):
      dm bufio: update last_accessed when relinking a buffer

Johan Hovold (7):
      USB: kobil_sct: fix non-atomic allocation in write path
      USB: opticon: fix non-atomic allocation in write path
      USB: cdc-acm: add device id for GW Instek AFG-2225
      USB: cdc-acm: only raise DTR on transitions from B0
      USB: keyspan: fix tty line-status reporting
      USB: keyspan: fix overrun-error reporting
      USB: ssu100: fix overrun-error reporting

Johannes Berg (2):
      mac80211: properly flush delayed scan work on interface removal
      mac80211: fix use-after-free in defragmentation

Joonyoung Shim (1):
      USB: add reset resume quirk for usb3503

K. Y. Srinivasan (6):
      Drivers: hv: vmbus: Cleanup vmbus_post_msg()
      Drivers: hv: vmbus: Cleanup vmbus_teardown_gpadl()
      Drivers: hv: vmbus: Cleanup vmbus_establish_gpadl()
      Drivers: hv: vmbus: Fix a bug in vmbus_open()
      Drivers: hv: vmbus: Cleanup vmbus_close_internal()
      Drivers: hv: vmbus: Cleanup hv_post_message()

Kees Cook (2):
      firmware_class: make sure fw requests contain a name
      x86, mm: Set NX across entire PMD at boot

Kuninori Morimoto (1):
      ASoC: fsi: remove unsupported PAUSE flag

Lars-Peter Clausen (2):
      staging:iio:ad5933: Drop "raw" from channel names
      staging:iio:ade7758: Remove "raw" from channel name

Lu Baolu (3):
      USB: Add device quirk for ASUS T100 Base Station keyboard
      Revert "xhci: clear root port wake on bits if controller isn't wake-u=
p capable"
      usb: xhci: rework root port wake bits if controller isn't allowed to =
wakeup

Maciej Matraszek (1):
      v4l2-common: fix overflow in v4l_bound_align_image()

Markos Chandras (1):
      MIPS: ftrace: Fix a microMIPS build problem

Mathias Krause (1):
      posix-timers: Fix stack info leak in timer_create()

Mathias Nyman (2):
      USB: xhci: don't start a halted endpoint before its new dequeue is se=
t
      USB: xhci: Reset a halted endpoint immediately when we encounter a st=
all.

Maurizio Lombardi (1):
      bnx2fc: do not add shared skbs to the fcoe_rx_list

Max Filippov (1):
      xtensa: re-wire umount syscall to sys_oldumount

Michael S. Tsirkin (1):
      kvm: x86: don't kill guest on unknown exit reason

Mike Snitzer (1):
      block: fix alignment_offset math that assumes io_min is a power-of-2

Miklos Szeredi (1):
      audit: keep inode pinned

Mikulas Patocka (4):
      framebuffer: fix border color
      framebuffer: fix screen corruption when copying
      fs: make cont_expand_zero interruptible
      dm bufio: change __GFP_IO to __GFP_FS in shrinker callbacks

Nathaniel Ting (1):
      USB: serial: cp210x: add Silicon Labs 358x VID and PID

Oliver Neukum (1):
      xhci: no switching back on non-ULT Haswell

Ondrej Kozina (1):
      crypto: algif - avoid excessive use of socket buffer in skcipher

Ondrej Zary (1):
      libata-sff: Fix controllers with no ctl port

Pali Roh=C3=A1r (2):
      Input: alps - ignore potential bare packets when device is out of syn=
c
      Input: alps - allow up to 2 invalid packets without resetting device

Paul Fertser (1):
      media: usb: uvc: add a quirk for Dell XPS M1330 webcam

Pawel Moll (1):
      perf: Handle compat ioctl

Perry Hung (1):
      usb: serial: ftdi_sio: add "bricked" FTDI device PID

Peter Hurley (2):
      serial: Fix divide-by-zero fault in uart_get_divisor()
      tty: Fix high cpu load if tty is unreleaseable

Preston Fick (1):
      USB: serial: cp210x: add IDs for CEL MeshConnect USB Stick

Quentin Casasnovas (1):
      kvm: fix excessive pages un-pinning in kvm_iommu_map error path.

Quinn Tran (1):
      target: Fix queue full status NULL pointer for SCF_TRANSPORT_TASK_SEN=
SE

Rabin Vincent (1):
      tracing/syscalls: Ignore numbers outside NR_syscalls' range

Ray Jui (1):
      spi: pl022: Fix incorrect dma_unmap_sg

Ricardo Ribalda Delgado (1):
      PCI: Generate uppercase hex for modalias interface class

Sasha Levin (1):
      kernel: add support for gcc 5

Scott Carter (1):
      pata_serverworks: disable 64-KB DMA transfers on Broadcom OSB4 IDE Co=
ntroller

Shai Fultheim (1):
      x86: Conditionally update time when ack-ing pending irqs

Sinclair Yeh (1):
      drm/vmwgfx: Filter out modes those cannot be supported by the current=
 VRAM size.

Stanislaw Gruszka (2):
      rt2800: correct BBP1_TX_POWER_CTRL mask
      rt2x00: do not align payload on modern H/W

Stefan Richter (1):
      firewire: cdev: prevent kernel stack leaking into ioctl arguments

Stephen Smalley (1):
      selinux: fix inode security list corruption

Takashi Iwai (4):
      ALSA: emu10k1: Fix deadlock in synth voice lookup
      ALSA: pcm: Zero-clear reserved fields of PCM status ioctl in compat m=
ode
      ALSA: usb-audio: Fix device_del() sysfs warnings at disconnect
      ALSA: hda - Limit 40bit DMA for AMD HDMI controllers

Tejun Heo (1):
      ahci: disable MSI instead of NCQ on Samsung pci-e SSDs on macbooks

Tetsuo Handa (1):
      fs: Fix theoretical division by 0 in super_cache_scan().

Theodore Ts'o (2):
      ext4: don't orphan or truncate the boot loader inode
      ext4: add ext4_iget_normal() which is to be used for dir tree lookups

Thomas K=C3=B6rper (1):
      can: dev: avoid calling kfree_skb() from interrupt context

Thor Thayer (1):
      spi: dw: Fix dynamic speed change.

Tomas Henzl (1):
      hpsa: fix a race in cmd_free/scsi_done

Tomas Winkler (2):
      mei: add mei_quirk_probe function
      mei: limit the number of consecutive resets

Trond Myklebust (3):
      NFSv4: fix open/lock state recovery error handling
      SUNRPC: Fix locking around callback channel reply receive
      nfsd: Fix slot wake up race in the nfsv4.1 callback code

Troy Clark (1):
      usb: serial: ftdi_sio: add PIDs for Matrix Orbital products

Ulrich Eckhardt (1):
      ds3000: fix LNB supply voltage on Tevii S480 on initialization

Wang Nan (1):
      cgroup/kmemleak: add kmemleak_free() for cgroup deallocations.

Will Deacon (2):
      zap_pte_range: update addr when forcing flush after TLB batching faiu=
re
      tracing/syscalls: Fix perf syscall tracing when syscall_nr =3D=3D -1

Willy Tarreau (3):
      Documentation: lzo: document part of the encoding
      Revert "lzo: properly check for overruns"
      lzo: check for length overrun in variable length encoding.

Yann Droneaud (1):
      fanotify: enable close-on-exec on events' fd when requested in fanoti=
fy_init()

Yinghai Lu (1):
      x86, 64bit, mm: Mark data/bss/brk to nx


--=20
Ben Hutchings
The two most common things in the universe are hydrogen and stupidity.

--=-RgCyPFCDhQU5Y3OPX3cz
Content-Type: text/x-diff; charset="UTF-8"; name="linux-3.2.65.patch"
Content-Disposition: attachment; filename="linux-3.2.65.patch"
Content-Transfer-Encoding: quoted-printable

diff --git a/Documentation/lzo.txt b/Documentation/lzo.txt
new file mode 100644
index 0000000..ea45dd3
--- /dev/null
+++ b/Documentation/lzo.txt
@@ -0,0 +1,164 @@
+
+LZO stream format as understood by Linux's LZO decompressor
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+Introduction
+
+  This is not a specification. No specification seems to be publicly avail=
able
+  for the LZO stream format. This document describes what input format the=
 LZO
+  decompressor as implemented in the Linux kernel understands. The file su=
bject
+  of this analysis is lib/lzo/lzo1x_decompress_safe.c. No analysis was mad=
e on
+  the compressor nor on any other implementations though it seems likely t=
hat
+  the format matches the standard one. The purpose of this document is to
+  better understand what the code does in order to propose more efficient =
fixes
+  for future bug reports.
+
+Description
+
+  The stream is composed of a series of instructions, operands, and data. =
The
+  instructions consist in a few bits representing an opcode, and bits form=
ing
+  the operands for the instruction, whose size and position depend on the
+  opcode and on the number of literals copied by previous instruction. The
+  operands are used to indicate :
+
+    - a distance when copying data from the dictionary (past output buffer=
)
+    - a length (number of bytes to copy from dictionary)
+    - the number of literals to copy, which is retained in variable "state=
"
+      as a piece of information for next instructions.
+
+  Optionally depending on the opcode and operands, extra data may follow. =
These
+  extra data can be a complement for the operand (eg: a length or a distan=
ce
+  encoded on larger values), or a literal to be copied to the output buffe=
r.
+
+  The first byte of the block follows a different encoding from other byte=
s, it
+  seems to be optimized for literal use only, since there is no dictionary=
 yet
+  prior to that byte.
+
+  Lengths are always encoded on a variable size starting with a small numb=
er
+  of bits in the operand. If the number of bits isn't enough to represent =
the
+  length, up to 255 may be added in increments by consuming more bytes wit=
h a
+  rate of at most 255 per extra byte (thus the compression ratio cannot ex=
ceed
+  around 255:1). The variable length encoding using #bits is always the sa=
me :
+
+       length =3D byte & ((1 << #bits) - 1)
+       if (!length) {
+               length =3D ((1 << #bits) - 1)
+               length +=3D 255*(number of zero bytes)
+               length +=3D first-non-zero-byte
+       }
+       length +=3D constant (generally 2 or 3)
+
+  For references to the dictionary, distances are relative to the output
+  pointer. Distances are encoded using very few bits belonging to certain
+  ranges, resulting in multiple copy instructions using different encoding=
s.
+  Certain encodings involve one extra byte, others involve two extra bytes
+  forming a little-endian 16-bit quantity (marked LE16 below).
+
+  After any instruction except the large literal copy, 0, 1, 2 or 3 litera=
ls
+  are copied before starting the next instruction. The number of literals =
that
+  were copied may change the meaning and behaviour of the next instruction=
. In
+  practice, only one instruction needs to know whether 0, less than 4, or =
more
+  literals were copied. This is the information stored in the <state> vari=
able
+  in this implementation. This number of immediate literals to be copied i=
s
+  generally encoded in the last two bits of the instruction but may also b=
e
+  taken from the last two bits of an extra operand (eg: distance).
+
+  End of stream is declared when a block copy of distance 0 is seen. Only =
one
+  instruction may encode this distance (0001HLLL), it takes one LE16 opera=
nd
+  for the distance, thus requiring 3 bytes.
+
+  IMPORTANT NOTE : in the code some length checks are missing because cert=
ain
+  instructions are called under the assumption that a certain number of by=
tes
+  follow because it has already been garanteed before parsing the instruct=
ions.
+  They just have to "refill" this credit if they consume extra bytes. This=
 is
+  an implementation design choice independant on the algorithm or encoding=
.
+
+Byte sequences
+
+  First byte encoding :
+
+      0..17   : follow regular instruction encoding, see below. It is wort=
h
+                noting that codes 16 and 17 will represent a block copy fr=
om
+                the dictionary which is empty, and that they will always b=
e
+                invalid at this place.
+
+      18..21  : copy 0..3 literals
+                state =3D (byte - 17) =3D 0..3  [ copy <state> literals ]
+                skip byte
+
+      22..255 : copy literal string
+                length =3D (byte - 17) =3D 4..238
+                state =3D 4 [ don't copy extra literals ]
+                skip byte
+
+  Instruction encoding :
+
+      0 0 0 0 X X X X  (0..15)
+        Depends on the number of literals copied by the last instruction.
+        If last instruction did not copy any literal (state =3D=3D 0), thi=
s
+        encoding will be a copy of 4 or more literal, and must be interpre=
ted
+        like this :
+
+           0 0 0 0 L L L L  (0..15)  : copy long literal string
+           length =3D 3 + (L ?: 15 + (zero_bytes * 255) + non_zero_byte)
+           state =3D 4  (no extra literals are copied)
+
+        If last instruction used to copy between 1 to 3 literals (encoded =
in
+        the instruction's opcode or distance), the instruction is a copy o=
f a
+        2-byte block from the dictionary within a 1kB distance. It is wort=
h
+        noting that this instruction provides little savings since it uses=
 2
+        bytes to encode a copy of 2 other bytes but it encodes the number =
of
+        following literals for free. It must be interpreted like this :
+
+           0 0 0 0 D D S S  (0..15)  : copy 2 bytes from <=3D 1kB distance
+           length =3D 2
+           state =3D S (copy S literals after this block)
+         Always followed by exactly one byte : H H H H H H H H
+           distance =3D (H << 2) + D + 1
+
+        If last instruction used to copy 4 or more literals (as detected b=
y
+        state =3D=3D 4), the instruction becomes a copy of a 3-byte block =
from the
+        dictionary from a 2..3kB distance, and must be interpreted like th=
is :
+
+           0 0 0 0 D D S S  (0..15)  : copy 3 bytes from 2..3 kB distance
+           length =3D 3
+           state =3D S (copy S literals after this block)
+         Always followed by exactly one byte : H H H H H H H H
+           distance =3D (H << 2) + D + 2049
+
+      0 0 0 1 H L L L  (16..31)
+           Copy of a block within 16..48kB distance (preferably less than =
10B)
+           length =3D 2 + (L ?: 7 + (zero_bytes * 255) + non_zero_byte)
+        Always followed by exactly one LE16 :  D D D D D D D D : D D D D D=
 D S S
+           distance =3D 16384 + (H << 14) + D
+           state =3D S (copy S literals after this block)
+           End of stream is reached if distance =3D=3D 16384
+
+      0 0 1 L L L L L  (32..63)
+           Copy of small block within 16kB distance (preferably less than =
34B)
+           length =3D 2 + (L ?: 31 + (zero_bytes * 255) + non_zero_byte)
+        Always followed by exactly one LE16 :  D D D D D D D D : D D D D D=
 D S S
+           distance =3D D + 1
+           state =3D S (copy S literals after this block)
+
+      0 1 L D D D S S  (64..127)
+           Copy 3-4 bytes from block within 2kB distance
+           state =3D S (copy S literals after this block)
+           length =3D 3 + L
+         Always followed by exactly one byte : H H H H H H H H
+           distance =3D (H << 3) + D + 1
+
+      1 L L D D D S S  (128..255)
+           Copy 5-8 bytes from block within 2kB distance
+           state =3D S (copy S literals after this block)
+           length =3D 5 + L
+         Always followed by exactly one byte : H H H H H H H H
+           distance =3D (H << 3) + D + 1
+
+Authors
+
+  This document was written by Willy Tarreau <w@1wt.eu> on 2014/07/19 duri=
ng an
+  analysis of the decompression code available in Linux 3.16-rc5. The code=
 is
+  tricky, it is possible that this document contains mistakes or that a fe=
w
+  corner cases were overlooked. In any case, please report any doubt, fix,=
 or
+  proposed updates to the author(s) so that the document can be updated.
diff --git a/Makefile b/Makefile
index 2b58ffc..1433109 100644
--- a/Makefile
+++ b/Makefile
@@ -1,6 +1,6 @@
 VERSION =3D 3
 PATCHLEVEL =3D 2
-SUBLEVEL =3D 64
+SUBLEVEL =3D 65
 EXTRAVERSION =3D
 NAME =3D Saber-toothed Squirrel
=20
diff --git a/arch/arm/mm/proc-xscale.S b/arch/arm/mm/proc-xscale.S
index b09d036..76a8015 100644
--- a/arch/arm/mm/proc-xscale.S
+++ b/arch/arm/mm/proc-xscale.S
@@ -528,7 +528,7 @@ ENTRY(cpu_xscale_do_suspend)
 	mrc	p15, 0, r5, c15, c1, 0	@ CP access reg
 	mrc	p15, 0, r6, c13, c0, 0	@ PID
 	mrc	p15, 0, r7, c3, c0, 0	@ domain ID
-	mrc	p15, 0, r8, c1, c1, 0	@ auxiliary control reg
+	mrc	p15, 0, r8, c1, c0, 1	@ auxiliary control reg
 	mrc	p15, 0, r9, c1, c0, 0	@ control reg
 	bic	r4, r4, #2		@ clear frequency change bit
 	stmia	r0, {r4 - r9}		@ store cp regs
@@ -545,7 +545,7 @@ ENTRY(cpu_xscale_do_resume)
 	mcr	p15, 0, r6, c13, c0, 0	@ PID
 	mcr	p15, 0, r7, c3, c0, 0	@ domain ID
 	mcr	p15, 0, r1, c2, c0, 0	@ translation table base addr
-	mcr	p15, 0, r8, c1, c1, 0	@ auxiliary control reg
+	mcr	p15, 0, r8, c1, c0, 1	@ auxiliary control reg
 	mov	r0, r9			@ control register
 	b	cpu_resume_mmu
 ENDPROC(cpu_xscale_do_resume)
diff --git a/arch/m68k/mm/hwtest.c b/arch/m68k/mm/hwtest.c
index 2c7dde3..2a5259f 100644
--- a/arch/m68k/mm/hwtest.c
+++ b/arch/m68k/mm/hwtest.c
@@ -28,9 +28,11 @@
 int hwreg_present( volatile void *regp )
 {
     int	ret =3D 0;
+    unsigned long flags;
     long	save_sp, save_vbr;
     long	tmp_vectors[3];
=20
+    local_irq_save(flags);
     __asm__ __volatile__
 	(	"movec	%/vbr,%2\n\t"
 		"movel	#Lberr1,%4@(8)\n\t"
@@ -46,6 +48,7 @@ int hwreg_present( volatile void *regp )
 		: "=3D&d" (ret), "=3D&r" (save_sp), "=3D&r" (save_vbr)
 		: "a" (regp), "a" (tmp_vectors)
                 );
+    local_irq_restore(flags);
=20
     return( ret );
 }
@@ -58,9 +61,11 @@ EXPORT_SYMBOL(hwreg_present);
 int hwreg_write( volatile void *regp, unsigned short val )
 {
 	int		ret;
+	unsigned long flags;
 	long	save_sp, save_vbr;
 	long	tmp_vectors[3];
=20
+	local_irq_save(flags);
 	__asm__ __volatile__
 	(	"movec	%/vbr,%2\n\t"
 		"movel	#Lberr2,%4@(8)\n\t"
@@ -78,6 +83,7 @@ int hwreg_write( volatile void *regp, unsigned short val =
)
 		: "=3D&d" (ret), "=3D&r" (save_sp), "=3D&r" (save_vbr)
 		: "a" (regp), "a" (tmp_vectors), "g" (val)
 	);
+	local_irq_restore(flags);
=20
 	return( ret );
 }
diff --git a/arch/mips/include/asm/ftrace.h b/arch/mips/include/asm/ftrace.=
h
index ce35c9a..370ae7c 100644
--- a/arch/mips/include/asm/ftrace.h
+++ b/arch/mips/include/asm/ftrace.h
@@ -24,7 +24,7 @@ do {							\
 	asm volatile (					\
 		"1: " load " %[" STR(dst) "], 0(%[" STR(src) "])\n"\
 		"   li %[" STR(error) "], 0\n"		\
-		"2:\n"					\
+		"2: .insn\n"				\
 							\
 		".section .fixup, \"ax\"\n"		\
 		"3: li %[" STR(error) "], 1\n"		\
@@ -46,7 +46,7 @@ do {						\
 	asm volatile (				\
 		"1: " store " %[" STR(src) "], 0(%[" STR(dst) "])\n"\
 		"   li %[" STR(error) "], 0\n"	\
-		"2:\n"				\
+		"2: .insn\n"			\
 						\
 		".section .fixup, \"ax\"\n"	\
 		"3: li %[" STR(error) "], 1\n"	\
diff --git a/arch/mips/loongson/common/Makefile b/arch/mips/loongson/common=
/Makefile
index e526488..ce415f7 100644
--- a/arch/mips/loongson/common/Makefile
+++ b/arch/mips/loongson/common/Makefile
@@ -10,7 +10,8 @@ obj-$(CONFIG_GENERIC_GPIO) +=3D gpio.o
 # Serial port support
 #
 obj-$(CONFIG_EARLY_PRINTK) +=3D early_printk.o
-obj-$(CONFIG_SERIAL_8250) +=3D serial.o
+loongson-serial-$(CONFIG_SERIAL_8250) :=3D serial.o
+obj-y +=3D $(loongson-serial-m) $(loongson-serial-y)
 obj-$(CONFIG_LOONGSON_UART_BASE) +=3D uart_base.o
 obj-$(CONFIG_LOONGSON_MC146818) +=3D rtc.o
=20
diff --git a/arch/mips/oprofile/backtrace.c b/arch/mips/oprofile/backtrace.=
c
index 6854ed5..83a1dfd 100644
--- a/arch/mips/oprofile/backtrace.c
+++ b/arch/mips/oprofile/backtrace.c
@@ -92,7 +92,7 @@ static inline int unwind_user_frame(struct stackframe *ol=
d_frame,
 				/* This marks the end of the previous function,
 				   which means we overran. */
 				break;
-			stack_size =3D (unsigned) stack_adjustment;
+			stack_size =3D (unsigned long) stack_adjustment;
 		} else if (is_ra_save_ins(&ip)) {
 			int ra_slot =3D ip.i_format.simmediate;
 			if (ra_slot < 0)
diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
index 5482d1e..4d576a1 100644
--- a/arch/s390/kvm/interrupt.c
+++ b/arch/s390/kvm/interrupt.c
@@ -43,6 +43,7 @@ static int __interrupt_is_deliverable(struct kvm_vcpu *vc=
pu,
 			return 0;
 		if (vcpu->arch.sie_block->gcr[0] & 0x2000ul)
 			return 1;
+		return 0;
 	case KVM_S390_INT_EMERGENCY:
 		if (psw_extint_disabled(vcpu))
 			return 0;
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_hos=
t.h
index 15d24cb..9171618 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -435,6 +435,7 @@ struct kvm_vcpu_arch {
 	u64 mmio_gva;
 	unsigned access;
 	gfn_t mmio_gfn;
+	u64 mmio_gen;
=20
 	/* used for guest single stepping over the given code position */
 	unsigned long singlestep_rip;
diff --git a/arch/x86/include/asm/page_32_types.h b/arch/x86/include/asm/pa=
ge_32_types.h
index ade619f..88dae6b3 100644
--- a/arch/x86/include/asm/page_32_types.h
+++ b/arch/x86/include/asm/page_32_types.h
@@ -18,7 +18,6 @@
 #define THREAD_ORDER	1
 #define THREAD_SIZE 	(PAGE_SIZE << THREAD_ORDER)
=20
-#define STACKFAULT_STACK 0
 #define DOUBLEFAULT_STACK 1
 #define NMI_STACK 0
 #define DEBUG_STACK 0
diff --git a/arch/x86/include/asm/page_64_types.h b/arch/x86/include/asm/pa=
ge_64_types.h
index 7639dbf..a9e9937 100644
--- a/arch/x86/include/asm/page_64_types.h
+++ b/arch/x86/include/asm/page_64_types.h
@@ -14,12 +14,11 @@
 #define IRQ_STACK_ORDER 2
 #define IRQ_STACK_SIZE (PAGE_SIZE << IRQ_STACK_ORDER)
=20
-#define STACKFAULT_STACK 1
-#define DOUBLEFAULT_STACK 2
-#define NMI_STACK 3
-#define DEBUG_STACK 4
-#define MCE_STACK 5
-#define N_EXCEPTION_STACKS 5  /* hw limit: 7 */
+#define DOUBLEFAULT_STACK 1
+#define NMI_STACK 2
+#define DEBUG_STACK 3
+#define MCE_STACK 4
+#define N_EXCEPTION_STACKS 4  /* hw limit: 7 */
=20
 #define PUD_PAGE_SIZE		(_AC(1, UL) << PUD_SHIFT)
 #define PUD_PAGE_MASK		(~(PUD_PAGE_SIZE-1))
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index c4e3581..838a3b4 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1213,7 +1213,7 @@ void __cpuinit setup_local_APIC(void)
 	unsigned int value, queued;
 	int i, j, acked =3D 0;
 	unsigned long long tsc =3D 0, ntsc;
-	long long max_loops =3D cpu_khz;
+	long long max_loops =3D cpu_khz ? cpu_khz : 1000000;
=20
 	if (cpu_has_tsc)
 		rdtscll(tsc);
@@ -1309,11 +1309,13 @@ void __cpuinit setup_local_APIC(void)
 			       acked);
 			break;
 		}
-		if (cpu_has_tsc) {
-			rdtscll(ntsc);
-			max_loops =3D (cpu_khz << 10) - (ntsc - tsc);
-		} else
-			max_loops--;
+		if (queued) {
+			if (cpu_has_tsc && cpu_khz) {
+				rdtscll(ntsc);
+				max_loops =3D (cpu_khz << 10) - (ntsc - tsc);
+			} else
+				max_loops--;
+		}
 	} while (queued && max_loops > 0);
 	WARN_ON(max_loops <=3D 0);
=20
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index ca93cc7..6284d6d 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -140,6 +140,8 @@ EXPORT_PER_CPU_SYMBOL_GPL(gdt_page);
=20
 static int __init x86_xsave_setup(char *s)
 {
+	if (strlen(s))
+		return 0;
 	setup_clear_cpu_cap(X86_FEATURE_XSAVE);
 	setup_clear_cpu_cap(X86_FEATURE_XSAVEOPT);
 	return 1;
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 3e6ff6c..e7a64dd 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -143,6 +143,21 @@ static void __cpuinit early_init_intel(struct cpuinfo_=
x86 *c)
 			setup_clear_cpu_cap(X86_FEATURE_ERMS);
 		}
 	}
+
+	/*
+	 * Intel Quark Core DevMan_001.pdf section 6.4.11
+	 * "The operating system also is required to invalidate (i.e., flush)
+	 *  the TLB when any changes are made to any of the page table entries.
+	 *  The operating system must reload CR3 to cause the TLB to be flushed"
+	 *
+	 * As a result cpu_has_pge() in arch/x86/include/asm/tlbflush.h should
+	 * be false so that __flush_tlb_all() causes CR3 insted of CR4.PGE
+	 * to be modified
+	 */
+	if (c->x86 =3D=3D 5 && c->x86_model =3D=3D 9) {
+		pr_info("Disabling PGE capability bit\n");
+		setup_clear_cpu_cap(X86_FEATURE_PGE);
+	}
 }
=20
 #ifdef CONFIG_X86_32
diff --git a/arch/x86/kernel/dumpstack_64.c b/arch/x86/kernel/dumpstack_64.=
c
index 6d728d9..5e890cc 100644
--- a/arch/x86/kernel/dumpstack_64.c
+++ b/arch/x86/kernel/dumpstack_64.c
@@ -24,7 +24,6 @@ static char x86_stack_ids[][8] =3D {
 		[ DEBUG_STACK-1			]	=3D "#DB",
 		[ NMI_STACK-1			]	=3D "NMI",
 		[ DOUBLEFAULT_STACK-1		]	=3D "#DF",
-		[ STACKFAULT_STACK-1		]	=3D "#SS",
 		[ MCE_STACK-1			]	=3D "#MC",
 #if DEBUG_STKSZ > EXCEPTION_STKSZ
 		[ N_EXCEPTION_STACKS ...
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 4b511ef..9d28dbac 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -873,13 +873,16 @@ ENTRY(native_iret)
 	jnz native_irq_return_ldt
 #endif
=20
+.global native_irq_return_iret
 native_irq_return_iret:
+	/*
+	 * This may fault.  Non-paranoid faults on return to userspace are
+	 * handled by fixup_bad_iret.  These include #SS, #GP, and #NP.
+	 * Double-faults due to espfix64 are handled in do_double_fault.
+	 * Other faults here are fatal.
+	 */
 	iretq
=20
-	.section __ex_table,"a"
-	.quad native_irq_return_iret, bad_iret
-	.previous
-
 #ifdef CONFIG_X86_ESPFIX64
 native_irq_return_ldt:
 	pushq_cfi %rax
@@ -906,25 +909,6 @@ native_irq_return_ldt:
 	jmp native_irq_return_iret
 #endif
=20
-	.section .fixup,"ax"
-bad_iret:
-	/*
-	 * The iret traps when the %cs or %ss being restored is bogus.
-	 * We've lost the original trap vector and error code.
-	 * #GPF is the most likely one to get for an invalid selector.
-	 * So pretend we completed the iret and took the #GPF in user mode.
-	 *
-	 * We are now running with the kernel GS after exception recovery.
-	 * But error_entry expects us to have user GS to match the user %cs,
-	 * so swap back.
-	 */
-	pushq $0
-
-	SWAPGS
-	jmp general_protection
-
-	.previous
-
 	/* edi: workmask, edx: work */
 retint_careful:
 	CFI_RESTORE_STATE
@@ -972,37 +956,6 @@ ENTRY(retint_kernel)
 	CFI_ENDPROC
 END(common_interrupt)
=20
-	/*
-	 * If IRET takes a fault on the espfix stack, then we
-	 * end up promoting it to a doublefault.  In that case,
-	 * modify the stack to make it look like we just entered
-	 * the #GP handler from user space, similar to bad_iret.
-	 */
-#ifdef CONFIG_X86_ESPFIX64
-	ALIGN
-__do_double_fault:
-	XCPT_FRAME 1 RDI+8
-	movq RSP(%rdi),%rax		/* Trap on the espfix stack? */
-	sarq $PGDIR_SHIFT,%rax
-	cmpl $ESPFIX_PGD_ENTRY,%eax
-	jne do_double_fault		/* No, just deliver the fault */
-	cmpl $__KERNEL_CS,CS(%rdi)
-	jne do_double_fault
-	movq RIP(%rdi),%rax
-	cmpq $native_irq_return_iret,%rax
-	jne do_double_fault		/* This shouldn't happen... */
-	movq PER_CPU_VAR(kernel_stack),%rax
-	subq $(6*8-KERNEL_STACK_OFFSET),%rax	/* Reset to original stack */
-	movq %rax,RSP(%rdi)
-	movq $0,(%rax)			/* Missing (lost) #GP error code */
-	movq $general_protection,RIP(%rdi)
-	retq
-	CFI_ENDPROC
-END(__do_double_fault)
-#else
-# define __do_double_fault do_double_fault
-#endif
-
 /*
  * End of kprobes section
  */
@@ -1169,7 +1122,7 @@ zeroentry overflow do_overflow
 zeroentry bounds do_bounds
 zeroentry invalid_op do_invalid_op
 zeroentry device_not_available do_device_not_available
-paranoiderrorentry double_fault __do_double_fault
+paranoiderrorentry double_fault do_double_fault
 zeroentry coprocessor_segment_overrun do_coprocessor_segment_overrun
 errorentry invalid_TSS do_invalid_TSS
 errorentry segment_not_present do_segment_not_present
@@ -1383,7 +1336,7 @@ apicinterrupt XEN_HVM_EVTCHN_CALLBACK \
=20
 paranoidzeroentry_ist debug do_debug DEBUG_STACK
 paranoidzeroentry_ist int3 do_int3 DEBUG_STACK
-paranoiderrorentry stack_segment do_stack_segment
+errorentry stack_segment do_stack_segment
 #ifdef CONFIG_XEN
 zeroentry xen_debug do_debug
 zeroentry xen_int3 do_int3
@@ -1493,16 +1446,15 @@ error_sti:
=20
 /*
  * There are two places in the kernel that can potentially fault with
- * usergs. Handle them here. The exception handlers after iret run with
- * kernel gs again, so don't set the user space flag. B stepping K8s
- * sometimes report an truncated RIP for IRET exceptions returning to
- * compat mode. Check for these here too.
+ * usergs. Handle them here.  B stepping K8s sometimes report a
+ * truncated RIP for IRET exceptions returning to compat mode. Check
+ * for these here too.
  */
 error_kernelspace:
 	incl %ebx
 	leaq native_irq_return_iret(%rip),%rcx
 	cmpq %rcx,RIP+8(%rsp)
-	je error_swapgs
+	je error_bad_iret
 	movl %ecx,%eax	/* zero extend */
 	cmpq %rax,RIP+8(%rsp)
 	je bstep_iret
@@ -1513,7 +1465,15 @@ error_kernelspace:
 bstep_iret:
 	/* Fix truncated RIP */
 	movq %rcx,RIP+8(%rsp)
-	jmp error_swapgs
+	/* fall through */
+
+error_bad_iret:
+	SWAPGS
+	mov %rsp,%rdi
+	call fixup_bad_iret
+	mov %rax,%rsp
+	decl %ebx	/* Return to usergs */
+	jmp error_sti
 	CFI_ENDPROC
 END(error_entry)
=20
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 20061b9..2aff347 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -213,29 +213,41 @@ DO_ERROR(X86_TRAP_OLD_MF, SIGFPE, "coprocessor segmen=
t overrun",
 		coprocessor_segment_overrun)
 DO_ERROR(X86_TRAP_TS, SIGSEGV, "invalid TSS", invalid_TSS)
 DO_ERROR(X86_TRAP_NP, SIGBUS, "segment not present", segment_not_present)
-#ifdef CONFIG_X86_32
 DO_ERROR(X86_TRAP_SS, SIGBUS, "stack segment", stack_segment)
-#endif
 DO_ERROR_INFO(X86_TRAP_AC, SIGBUS, "alignment check", alignment_check,
 		BUS_ADRALN, 0)
=20
 #ifdef CONFIG_X86_64
 /* Runs on IST stack */
-dotraplinkage void do_stack_segment(struct pt_regs *regs, long error_code)
-{
-	if (notify_die(DIE_TRAP, "stack segment", regs, error_code,
-			X86_TRAP_SS, SIGBUS) =3D=3D NOTIFY_STOP)
-		return;
-	preempt_conditional_sti(regs);
-	do_trap(X86_TRAP_SS, SIGBUS, "stack segment", regs, error_code, NULL);
-	preempt_conditional_cli(regs);
-}
-
 dotraplinkage void do_double_fault(struct pt_regs *regs, long error_code)
 {
 	static const char str[] =3D "double fault";
 	struct task_struct *tsk =3D current;
=20
+#ifdef CONFIG_X86_ESPFIX64
+	extern unsigned char native_irq_return_iret[];
+
+	/*
+	 * If IRET takes a non-IST fault on the espfix64 stack, then we
+	 * end up promoting it to a doublefault.  In that case, modify
+	 * the stack to make it look like we just entered the #GP
+	 * handler from user space, similar to bad_iret.
+	 */
+	if (((long)regs->sp >> PGDIR_SHIFT) =3D=3D ESPFIX_PGD_ENTRY &&
+		regs->cs =3D=3D __KERNEL_CS &&
+		regs->ip =3D=3D (unsigned long)native_irq_return_iret)
+	{
+		struct pt_regs *normal_regs =3D task_pt_regs(current);
+
+		/* Fake a #GP(0) from userspace. */
+		memmove(&normal_regs->ip, (void *)regs->sp, 5*8);
+		normal_regs->orig_ax =3D 0;  /* Missing (lost) #GP error code */
+		regs->ip =3D (unsigned long)general_protection;
+		regs->sp =3D (unsigned long)&normal_regs->orig_ax;
+		return;
+	}
+#endif
+
 	/* Return not checked because double check cannot be ignored */
 	notify_die(DIE_TRAP, str, regs, error_code, X86_TRAP_DF, SIGSEGV);
=20
@@ -332,7 +344,7 @@ dotraplinkage void __kprobes do_int3(struct pt_regs *re=
gs, long error_code)
  * for scheduling or signal handling. The actual stack switch is done in
  * entry.S
  */
-asmlinkage __kprobes struct pt_regs *sync_regs(struct pt_regs *eregs)
+asmlinkage notrace __kprobes struct pt_regs *sync_regs(struct pt_regs *ere=
gs)
 {
 	struct pt_regs *regs =3D eregs;
 	/* Did already sync */
@@ -351,6 +363,35 @@ asmlinkage __kprobes struct pt_regs *sync_regs(struct =
pt_regs *eregs)
 		*regs =3D *eregs;
 	return regs;
 }
+
+struct bad_iret_stack {
+	void *error_entry_ret;
+	struct pt_regs regs;
+};
+
+asmlinkage notrace __kprobes
+struct bad_iret_stack *fixup_bad_iret(struct bad_iret_stack *s)
+{
+	/*
+	 * This is called from entry_64.S early in handling a fault
+	 * caused by a bad iret to user mode.  To handle the fault
+	 * correctly, we want move our stack frame to task_pt_regs
+	 * and we want to pretend that the exception came from the
+	 * iret target.
+	 */
+	struct bad_iret_stack *new_stack =3D
+		container_of(task_pt_regs(current),
+			     struct bad_iret_stack, regs);
+
+	/* Copy the IRET target to the new stack. */
+	memmove(&new_stack->regs.ip, (void *)s->regs.sp, 5*8);
+
+	/* Copy the remainder of the stack from the current stack. */
+	memmove(new_stack, s, offsetof(struct bad_iret_stack, regs.ip));
+
+	BUG_ON(!user_mode_vm(&new_stack->regs));
+	return new_stack;
+}
 #endif
=20
 /*
@@ -711,7 +752,7 @@ void __init trap_init(void)
 	set_intr_gate(X86_TRAP_OLD_MF, &coprocessor_segment_overrun);
 	set_intr_gate(X86_TRAP_TS, &invalid_TSS);
 	set_intr_gate(X86_TRAP_NP, &segment_not_present);
-	set_intr_gate_ist(X86_TRAP_SS, &stack_segment, STACKFAULT_STACK);
+	set_intr_gate(X86_TRAP_SS, stack_segment);
 	set_intr_gate(X86_TRAP_GP, &general_protection);
 	set_intr_gate(X86_TRAP_SPURIOUS, &spurious_interrupt_bug);
 	set_intr_gate(X86_TRAP_MF, &coprocessor_error);
diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 1ec515b..9f3706e 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -961,14 +961,17 @@ void __init tsc_init(void)
=20
 	x86_init.timers.tsc_pre_init();
=20
-	if (!cpu_has_tsc)
+	if (!cpu_has_tsc) {
+		setup_clear_cpu_cap(X86_FEATURE_TSC_DEADLINE_TIMER);
 		return;
+	}
=20
 	tsc_khz =3D x86_platform.calibrate_tsc();
 	cpu_khz =3D tsc_khz;
=20
 	if (!tsc_khz) {
 		mark_tsc_unstable("could not calculate TSC khz");
+		setup_clear_cpu_cap(X86_FEATURE_TSC_DEADLINE_TIMER);
 		return;
 	}
=20
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index db2ffef..bfc9507 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2842,7 +2842,7 @@ static void mmu_sync_roots(struct kvm_vcpu *vcpu)
 	if (!VALID_PAGE(vcpu->arch.mmu.root_hpa))
 		return;
=20
-	vcpu_clear_mmio_info(vcpu, ~0ul);
+	vcpu_clear_mmio_info(vcpu, MMIO_GVA_ANY);
 	trace_kvm_mmu_audit(vcpu, AUDIT_PRE_SYNC);
 	if (vcpu->arch.mmu.root_level =3D=3D PT64_ROOT_LEVEL) {
 		hpa_t root =3D vcpu->arch.mmu.root_hpa;
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 82f97a5..7a2d9d6 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -3390,9 +3390,9 @@ static int handle_exit(struct kvm_vcpu *vcpu)
=20
 	if (exit_code >=3D ARRAY_SIZE(svm_exit_handlers)
 	    || !svm_exit_handlers[exit_code]) {
-		kvm_run->exit_reason =3D KVM_EXIT_UNKNOWN;
-		kvm_run->hw.hardware_exit_reason =3D exit_code;
-		return 0;
+		WARN_ONCE(1, "vmx: unexpected exit reason 0x%x\n", exit_code);
+		kvm_queue_exception(vcpu, UD_VECTOR);
+		return 1;
 	}
=20
 	return svm_exit_handlers[exit_code](svm);
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 578b1c6..8831c43 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -5925,10 +5925,10 @@ static int vmx_handle_exit(struct kvm_vcpu *vcpu)
 	    && kvm_vmx_exit_handlers[exit_reason])
 		return kvm_vmx_exit_handlers[exit_reason](vcpu);
 	else {
-		vcpu->run->exit_reason =3D KVM_EXIT_UNKNOWN;
-		vcpu->run->hw.hardware_exit_reason =3D exit_reason;
+		WARN_ONCE(1, "vmx: unexpected exit reason 0x%x\n", exit_reason);
+		kvm_queue_exception(vcpu, UD_VECTOR);
+		return 1;
 	}
-	return 0;
 }
=20
 static void update_cr8_intercept(struct kvm_vcpu *vcpu, int tpr, int irr)
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 0e22f64..6c3c94f 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -81,15 +81,23 @@ static inline void vcpu_cache_mmio_info(struct kvm_vcpu=
 *vcpu,
 	vcpu->arch.mmio_gva =3D gva & PAGE_MASK;
 	vcpu->arch.access =3D access;
 	vcpu->arch.mmio_gfn =3D gfn;
+	vcpu->arch.mmio_gen =3D kvm_memslots(vcpu->kvm)->generation;
+}
+
+static inline bool vcpu_match_mmio_gen(struct kvm_vcpu *vcpu)
+{
+	return vcpu->arch.mmio_gen =3D=3D kvm_memslots(vcpu->kvm)->generation;
 }
=20
 /*
- * Clear the mmio cache info for the given gva,
- * specially, if gva is ~0ul, we clear all mmio cache info.
+ * Clear the mmio cache info for the given gva. If gva is MMIO_GVA_ANY, we
+ * clear all mmio cache info.
  */
+#define MMIO_GVA_ANY (~(gva_t)0)
+
 static inline void vcpu_clear_mmio_info(struct kvm_vcpu *vcpu, gva_t gva)
 {
-	if (gva !=3D (~0ul) && vcpu->arch.mmio_gva !=3D (gva & PAGE_MASK))
+	if (gva !=3D MMIO_GVA_ANY && vcpu->arch.mmio_gva !=3D (gva & PAGE_MASK))
 		return;
=20
 	vcpu->arch.mmio_gva =3D 0;
@@ -97,7 +105,8 @@ static inline void vcpu_clear_mmio_info(struct kvm_vcpu =
*vcpu, gva_t gva)
=20
 static inline bool vcpu_match_mmio_gva(struct kvm_vcpu *vcpu, unsigned lon=
g gva)
 {
-	if (vcpu->arch.mmio_gva && vcpu->arch.mmio_gva =3D=3D (gva & PAGE_MASK))
+	if (vcpu_match_mmio_gen(vcpu) && vcpu->arch.mmio_gva &&
+	      vcpu->arch.mmio_gva =3D=3D (gva & PAGE_MASK))
 		return true;
=20
 	return false;
@@ -105,7 +114,8 @@ static inline bool vcpu_match_mmio_gva(struct kvm_vcpu =
*vcpu, unsigned long gva)
=20
 static inline bool vcpu_match_mmio_gpa(struct kvm_vcpu *vcpu, gpa_t gpa)
 {
-	if (vcpu->arch.mmio_gfn && vcpu->arch.mmio_gfn =3D=3D gpa >> PAGE_SHIFT)
+	if (vcpu_match_mmio_gen(vcpu) && vcpu->arch.mmio_gfn &&
+	      vcpu->arch.mmio_gfn =3D=3D gpa >> PAGE_SHIFT)
 		return true;
=20
 	return false;
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 44b93da..266f717 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -778,6 +778,7 @@ void mark_rodata_ro(void)
 	unsigned long text_end =3D PAGE_ALIGN((unsigned long) &__stop___ex_table)=
;
 	unsigned long rodata_end =3D PAGE_ALIGN((unsigned long) &__end_rodata);
 	unsigned long data_start =3D (unsigned long) &_sdata;
+	unsigned long all_end;
=20
 	printk(KERN_INFO "Write protecting the kernel read-only data: %luk\n",
 	       (end - start) >> 10);
@@ -786,10 +787,19 @@ void mark_rodata_ro(void)
 	kernel_set_to_readonly =3D 1;
=20
 	/*
-	 * The rodata section (but not the kernel text!) should also be
-	 * not-executable.
+	 * The rodata/data/bss/brk section (but not the kernel text!)
+	 * should also be not-executable.
+	 *
+	 * We align all_end to PMD_SIZE because the existing mapping
+	 * is a full PMD. If we would align _brk_end to PAGE_SIZE we
+	 * split the PMD and the reminder between _brk_end and the end
+	 * of the PMD will remain mapped executable.
+	 *
+	 * Any PMD which was setup after the one which covers _brk_end
+	 * has been zapped already via cleanup_highmem().
 	 */
-	set_memory_nx(rodata_start, (end - rodata_start) >> PAGE_SHIFT);
+	all_end =3D roundup((unsigned long)_brk_end, PMD_SIZE);
+	set_memory_nx(rodata_start, (all_end - rodata_start) >> PAGE_SHIFT);
=20
 	rodata_test();
=20
diff --git a/arch/xtensa/include/asm/unistd.h b/arch/xtensa/include/asm/uni=
std.h
index 798ee6d..7ab1f52 100644
--- a/arch/xtensa/include/asm/unistd.h
+++ b/arch/xtensa/include/asm/unistd.h
@@ -394,7 +394,8 @@ __SYSCALL(174, sys_chroot, 1)
 #define __NR_pivot_root 			175
 __SYSCALL(175, sys_pivot_root, 2)
 #define __NR_umount 				176
-__SYSCALL(176, sys_umount, 2)
+__SYSCALL(176, sys_oldumount, 1)
+#define __ARCH_WANT_SYS_OLDUMOUNT
 #define __NR_swapoff 				177
 __SYSCALL(177, sys_swapoff, 1)
 #define __NR_sync 				178
diff --git a/block/blk-settings.c b/block/blk-settings.c
index fa1eb04..d55a3e4 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -521,7 +521,7 @@ int blk_stack_limits(struct queue_limits *t, struct que=
ue_limits *b,
 		bottom =3D max(b->physical_block_size, b->io_min) + alignment;
=20
 		/* Verify that top and bottom intervals line up */
-		if (max(top, bottom) & (min(top, bottom) - 1)) {
+		if (max(top, bottom) % min(top, bottom)) {
 			t->misaligned =3D 1;
 			ret =3D -1;
 		}
@@ -562,7 +562,7 @@ int blk_stack_limits(struct queue_limits *t, struct que=
ue_limits *b,
=20
 	/* Find lowest common alignment_offset */
 	t->alignment_offset =3D lcm(t->alignment_offset, alignment)
-		& (max(t->physical_block_size, t->io_min) - 1);
+		% max(t->physical_block_size, t->io_min);
=20
 	/* Verify that new alignment_offset is on a logical block boundary */
 	if (t->alignment_offset & (t->logical_block_size - 1)) {
diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index 9e76a32..f124268 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -505,7 +505,7 @@ int sg_scsi_ioctl(struct request_queue *q, struct gendi=
sk *disk, fmode_t mode,
=20
 	if (bytes && blk_rq_map_kern(q, rq, buffer, bytes, __GFP_WAIT)) {
 		err =3D DRIVER_ERROR << 24;
-		goto out;
+		goto error;
 	}
=20
 	memset(sense, 0, sizeof(sense));
@@ -515,7 +515,6 @@ int sg_scsi_ioctl(struct request_queue *q, struct gendi=
sk *disk, fmode_t mode,
=20
 	blk_execute_rq(q, disk, rq, 0);
=20
-out:
 	err =3D rq->errors & 0xff;	/* only 8 bit SCSI status */
 	if (err) {
 		if (rq->sense_len && rq->sense) {
diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
index a19c027..83187f4 100644
--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -49,7 +49,7 @@ struct skcipher_ctx {
 	struct ablkcipher_request req;
 };
=20
-#define MAX_SGL_ENTS ((PAGE_SIZE - sizeof(struct skcipher_sg_list)) / \
+#define MAX_SGL_ENTS ((4096 - sizeof(struct skcipher_sg_list)) / \
 		      sizeof(struct scatterlist) - 1)
=20
 static inline int skcipher_sndbuf(struct sock *sk)
diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 4007f62..923ac15 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -61,6 +61,7 @@ enum board_ids {
 	/* board IDs by feature in alphabetical order */
 	board_ahci,
 	board_ahci_ign_iferr,
+	board_ahci_nomsi,
 	board_ahci_noncq,
 	board_ahci_nosntf,
 	board_ahci_yes_fbs,
@@ -124,6 +125,13 @@ static const struct ata_port_info ahci_port_info[] =3D=
 {
 		.udma_mask	=3D ATA_UDMA6,
 		.port_ops	=3D &ahci_ops,
 	},
+	[board_ahci_nomsi] =3D {
+		AHCI_HFLAGS	(AHCI_HFLAG_NO_MSI),
+		.flags		=3D AHCI_FLAG_COMMON,
+		.pio_mask	=3D ATA_PIO4,
+		.udma_mask	=3D ATA_UDMA6,
+		.port_ops	=3D &ahci_ops,
+	},
 	[board_ahci_noncq] =3D {
 		AHCI_HFLAGS	(AHCI_HFLAG_NO_NCQ),
 		.flags		=3D AHCI_FLAG_COMMON,
@@ -323,6 +331,11 @@ static const struct pci_device_id ahci_pci_tbl[] =3D {
 	{ PCI_VDEVICE(INTEL, 0x8c87), board_ahci }, /* 9 Series RAID */
 	{ PCI_VDEVICE(INTEL, 0x8c8e), board_ahci }, /* 9 Series RAID */
 	{ PCI_VDEVICE(INTEL, 0x8c8f), board_ahci }, /* 9 Series RAID */
+	{ PCI_VDEVICE(INTEL, 0xa103), board_ahci }, /* Sunrise Point-H AHCI */
+	{ PCI_VDEVICE(INTEL, 0xa103), board_ahci }, /* Sunrise Point-H RAID */
+	{ PCI_VDEVICE(INTEL, 0xa105), board_ahci }, /* Sunrise Point-H RAID */
+	{ PCI_VDEVICE(INTEL, 0xa107), board_ahci }, /* Sunrise Point-H RAID */
+	{ PCI_VDEVICE(INTEL, 0xa10f), board_ahci }, /* Sunrise Point-H RAID */
=20
 	/* JMicron 360/1/3/5/6, match class to avoid IDE function */
 	{ PCI_VENDOR_ID_JMICRON, PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID,
@@ -482,10 +495,10 @@ static const struct pci_device_id ahci_pci_tbl[] =3D =
{
 	{ PCI_VDEVICE(ASMEDIA, 0x0612), board_ahci },	/* ASM1062 */
=20
 	/*
-	 * Samsung SSDs found on some macbooks.  NCQ times out.
-	 * https://bugzilla.kernel.org/show_bug.cgi?id=3D60731
+	 * Samsung SSDs found on some macbooks.  NCQ times out if MSI is
+	 * enabled.  https://bugzilla.kernel.org/show_bug.cgi?id=3D60731
 	 */
-	{ PCI_VDEVICE(SAMSUNG, 0x1600), board_ahci_noncq },
+	{ PCI_VDEVICE(SAMSUNG, 0x1600), board_ahci_nomsi },
=20
 	/* Enmotus */
 	{ PCI_DEVICE(0x1c44, 0x8000), board_ahci },
diff --git a/drivers/ata/libata-sff.c b/drivers/ata/libata-sff.c
index 4cadfa2..8eae157 100644
--- a/drivers/ata/libata-sff.c
+++ b/drivers/ata/libata-sff.c
@@ -2008,13 +2008,15 @@ static int ata_bus_softreset(struct ata_port *ap, u=
nsigned int devmask,
=20
 	DPRINTK("ata%u: bus reset via SRST\n", ap->print_id);
=20
-	/* software reset.  causes dev0 to be selected */
-	iowrite8(ap->ctl, ioaddr->ctl_addr);
-	udelay(20);	/* FIXME: flush */
-	iowrite8(ap->ctl | ATA_SRST, ioaddr->ctl_addr);
-	udelay(20);	/* FIXME: flush */
-	iowrite8(ap->ctl, ioaddr->ctl_addr);
-	ap->last_ctl =3D ap->ctl;
+	if (ap->ioaddr.ctl_addr) {
+		/* software reset.  causes dev0 to be selected */
+		iowrite8(ap->ctl, ioaddr->ctl_addr);
+		udelay(20);	/* FIXME: flush */
+		iowrite8(ap->ctl | ATA_SRST, ioaddr->ctl_addr);
+		udelay(20);	/* FIXME: flush */
+		iowrite8(ap->ctl, ioaddr->ctl_addr);
+		ap->last_ctl =3D ap->ctl;
+	}
=20
 	/* wait the port to become ready */
 	return ata_sff_wait_after_reset(&ap->link, devmask, deadline);
@@ -2215,10 +2217,6 @@ void ata_sff_error_handler(struct ata_port *ap)
=20
 	spin_unlock_irqrestore(ap->lock, flags);
=20
-	/* ignore ata_sff_softreset if ctl isn't accessible */
-	if (softreset =3D=3D ata_sff_softreset && !ap->ioaddr.ctl_addr)
-		softreset =3D NULL;
-
 	/* ignore built-in hardresets if SCR access is not available */
 	if ((hardreset =3D=3D sata_std_hardreset ||
 	     hardreset =3D=3D sata_sff_hardreset) && !sata_scr_valid(&ap->link))
diff --git a/drivers/ata/pata_serverworks.c b/drivers/ata/pata_serverworks.=
c
index 71eaf385..5929dde 100644
--- a/drivers/ata/pata_serverworks.c
+++ b/drivers/ata/pata_serverworks.c
@@ -252,12 +252,18 @@ static void serverworks_set_dmamode(struct ata_port *=
ap, struct ata_device *adev
 	pci_write_config_byte(pdev, 0x54, ultra_cfg);
 }
=20
-static struct scsi_host_template serverworks_sht =3D {
+static struct scsi_host_template serverworks_osb4_sht =3D {
+	ATA_BMDMA_SHT(DRV_NAME),
+	.sg_tablesize	=3D LIBATA_DUMB_MAX_PRD,
+};
+
+static struct scsi_host_template serverworks_csb_sht =3D {
 	ATA_BMDMA_SHT(DRV_NAME),
 };
=20
 static struct ata_port_operations serverworks_osb4_port_ops =3D {
 	.inherits	=3D &ata_bmdma_port_ops,
+	.qc_prep	=3D ata_bmdma_dumb_qc_prep,
 	.cable_detect	=3D serverworks_cable_detect,
 	.mode_filter	=3D serverworks_osb4_filter,
 	.set_piomode	=3D serverworks_set_piomode,
@@ -266,6 +272,7 @@ static struct ata_port_operations serverworks_osb4_port=
_ops =3D {
=20
 static struct ata_port_operations serverworks_csb_port_ops =3D {
 	.inherits	=3D &serverworks_osb4_port_ops,
+	.qc_prep	=3D ata_bmdma_qc_prep,
 	.mode_filter	=3D serverworks_csb_filter,
 };
=20
@@ -405,6 +412,7 @@ static int serverworks_init_one(struct pci_dev *pdev, c=
onst struct pci_device_id
 		}
 	};
 	const struct ata_port_info *ppi[] =3D { &info[id->driver_data], NULL };
+	struct scsi_host_template *sht =3D &serverworks_csb_sht;
 	int rc;
=20
 	rc =3D pcim_enable_device(pdev);
@@ -418,6 +426,7 @@ static int serverworks_init_one(struct pci_dev *pdev, c=
onst struct pci_device_id
 		/* Select non UDMA capable OSB4 if we can't do fixups */
 		if (rc < 0)
 			ppi[0] =3D &info[1];
+		sht =3D &serverworks_osb4_sht;
 	}
 	/* setup CSB5/CSB6 : South Bridge and IDE option RAID */
 	else if ((pdev->device =3D=3D PCI_DEVICE_ID_SERVERWORKS_CSB5IDE) ||
@@ -434,7 +443,7 @@ static int serverworks_init_one(struct pci_dev *pdev, c=
onst struct pci_device_id
 			ppi[1] =3D &ata_dummy_port_info;
 	}
=20
-	return ata_pci_bmdma_init_one(pdev, ppi, &serverworks_sht, NULL, 0);
+	return ata_pci_bmdma_init_one(pdev, ppi, sht, NULL, 0);
 }
=20
 #ifdef CONFIG_PM
diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index 3719c94..763b356 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -521,6 +521,9 @@ static int _request_firmware(const struct firmware **fi=
rmware_p,
 	if (!firmware_p)
 		return -EINVAL;
=20
+	if (!name || name[0] =3D=3D '\0')
+		return -EINVAL;
+
 	*firmware_p =3D firmware =3D kzalloc(sizeof(*firmware), GFP_KERNEL);
 	if (!firmware) {
 		dev_err(device, "%s: kmalloc(struct firmware) failed\n",
diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index dddcb1d..8750d52 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -305,6 +305,9 @@ static void btusb_intr_complete(struct urb *urb)
 			BT_ERR("%s corrupted event packet", hdev->name);
 			hdev->stat.err_rx++;
 		}
+	} else if (urb->status =3D=3D -ENOENT) {
+		/* Avoid suspend failed when usb_kill_urb */
+		return;
 	}
=20
 	if (!test_bit(BTUSB_INTR_RUNNING, &data->flags))
@@ -392,6 +395,9 @@ static void btusb_bulk_complete(struct urb *urb)
 			BT_ERR("%s corrupted ACL packet", hdev->name);
 			hdev->stat.err_rx++;
 		}
+	} else if (urb->status =3D=3D -ENOENT) {
+		/* Avoid suspend failed when usb_kill_urb */
+		return;
 	}
=20
 	if (!test_bit(BTUSB_BULK_RUNNING, &data->flags))
@@ -485,6 +491,9 @@ static void btusb_isoc_complete(struct urb *urb)
 				hdev->stat.err_rx++;
 			}
 		}
+	} else if (urb->status =3D=3D -ENOENT) {
+		/* Avoid suspend failed when usb_kill_urb */
+		return;
 	}
=20
 	if (!test_bit(BTUSB_ISOC_RUNNING, &data->flags))
diff --git a/drivers/char/random.c b/drivers/char/random.c
index c244f0e..edf45ae 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -954,8 +954,8 @@ static void extract_buf(struct entropy_store *r, __u8 *=
out)
 	 * pool while mixing, and hash one final time.
 	 */
 	sha_transform(hash.w, extract, workspace);
-	memset(extract, 0, sizeof(extract));
-	memset(workspace, 0, sizeof(workspace));
+	memzero_explicit(extract, sizeof(extract));
+	memzero_explicit(workspace, sizeof(workspace));
=20
 	/*
 	 * In case the hash function has some recognizable output
@@ -978,7 +978,7 @@ static void extract_buf(struct entropy_store *r, __u8 *=
out)
 	}
=20
 	memcpy(out, &hash, EXTRACT_SIZE);
-	memset(&hash, 0, sizeof(hash));
+	memzero_explicit(&hash, sizeof(hash));
 }
=20
 static ssize_t extract_entropy(struct entropy_store *r, void *buf,
@@ -1010,7 +1010,7 @@ static ssize_t extract_entropy(struct entropy_store *=
r, void *buf,
 	}
=20
 	/* Wipe data just returned from memory */
-	memset(tmp, 0, sizeof(tmp));
+	memzero_explicit(tmp, sizeof(tmp));
=20
 	return ret;
 }
@@ -1047,7 +1047,7 @@ static ssize_t extract_entropy_user(struct entropy_st=
ore *r, void __user *buf,
 	}
=20
 	/* Wipe data just returned from memory */
-	memset(tmp, 0, sizeof(tmp));
+	memzero_explicit(tmp, sizeof(tmp));
=20
 	return ret;
 }
diff --git a/drivers/firewire/core-cdev.c b/drivers/firewire/core-cdev.c
index b97d4f0..ee96b91 100644
--- a/drivers/firewire/core-cdev.c
+++ b/drivers/firewire/core-cdev.c
@@ -1605,8 +1605,7 @@ static int dispatch_ioctl(struct client *client,
 	    _IOC_SIZE(cmd) > sizeof(buffer))
 		return -ENOTTY;
=20
-	if (_IOC_DIR(cmd) =3D=3D _IOC_READ)
-		memset(&buffer, 0, _IOC_SIZE(cmd));
+	memset(&buffer, 0, sizeof(buffer));
=20
 	if (_IOC_DIR(cmd) & _IOC_WRITE)
 		if (copy_from_user(&buffer, arg, _IOC_SIZE(cmd)))
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c b/drivers/gpu/drm/vmwgfx/v=
mwgfx_kms.c
index 7c88f1f..eb9735e 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
@@ -1826,6 +1826,14 @@ int vmw_du_connector_fill_modes(struct drm_connector=
 *connector,
 		DRM_MODE_FLAG_NHSYNC | DRM_MODE_FLAG_PVSYNC)
 	};
 	int i;
+	u32 assumed_bpp =3D 2;
+
+	/*
+	 * If using screen objects, then assume 32-bpp because that's what the
+	 * SVGA device is assuming
+	 */
+	if (dev_priv->sou_priv)
+		assumed_bpp =3D 4;
=20
 	/* Add preferred mode */
 	{
@@ -1836,8 +1844,9 @@ int vmw_du_connector_fill_modes(struct drm_connector =
*connector,
 		mode->vdisplay =3D du->pref_height;
 		vmw_guess_mode_timing(mode);
=20
-		if (vmw_kms_validate_mode_vram(dev_priv, mode->hdisplay * 2,
-					       mode->vdisplay)) {
+		if (vmw_kms_validate_mode_vram(dev_priv,
+						mode->hdisplay * assumed_bpp,
+						mode->vdisplay)) {
 			drm_mode_probed_add(connector, mode);
 		} else {
 			drm_mode_destroy(dev, mode);
@@ -1859,7 +1868,8 @@ int vmw_du_connector_fill_modes(struct drm_connector =
*connector,
 		    bmode->vdisplay > max_height)
 			continue;
=20
-		if (!vmw_kms_validate_mode_vram(dev_priv, bmode->hdisplay * 2,
+		if (!vmw_kms_validate_mode_vram(dev_priv,
+						bmode->hdisplay * assumed_bpp,
 						bmode->vdisplay))
 			continue;
=20
diff --git a/drivers/hv/channel.c b/drivers/hv/channel.c
index f4c3d28..44a1ea4 100644
--- a/drivers/hv/channel.c
+++ b/drivers/hv/channel.c
@@ -207,8 +207,10 @@ int vmbus_open(struct vmbus_channel *newchannel, u32 s=
end_ringbuffer_size,
 	ret =3D vmbus_post_msg(open_msg,
 			       sizeof(struct vmbus_channel_open_channel));
=20
-	if (ret !=3D 0)
+	if (ret !=3D 0) {
+		err =3D ret;
 		goto error1;
+	}
=20
 	t =3D wait_for_completion_timeout(&open_info->waitevent, 5*HZ);
 	if (t =3D=3D 0) {
@@ -400,7 +402,6 @@ int vmbus_establish_gpadl(struct vmbus_channel *channel=
, void *kbuffer,
 	u32 next_gpadl_handle;
 	unsigned long flags;
 	int ret =3D 0;
-	int t;
=20
 	next_gpadl_handle =3D atomic_read(&vmbus_connection.next_gpadl_handle);
 	atomic_inc(&vmbus_connection.next_gpadl_handle);
@@ -447,9 +448,7 @@ int vmbus_establish_gpadl(struct vmbus_channel *channel=
, void *kbuffer,
=20
 		}
 	}
-	t =3D wait_for_completion_timeout(&msginfo->waitevent, 5*HZ);
-	BUG_ON(t =3D=3D 0);
-
+	wait_for_completion(&msginfo->waitevent);
=20
 	/* At this point, we received the gpadl created msg */
 	*gpadl_handle =3D gpadlmsg->gpadl;
@@ -472,7 +471,7 @@ int vmbus_teardown_gpadl(struct vmbus_channel *channel,=
 u32 gpadl_handle)
 	struct vmbus_channel_gpadl_teardown *msg;
 	struct vmbus_channel_msginfo *info;
 	unsigned long flags;
-	int ret, t;
+	int ret;
=20
 	info =3D kmalloc(sizeof(*info) +
 		       sizeof(struct vmbus_channel_gpadl_teardown), GFP_KERNEL);
@@ -494,11 +493,12 @@ int vmbus_teardown_gpadl(struct vmbus_channel *channe=
l, u32 gpadl_handle)
 	ret =3D vmbus_post_msg(msg,
 			       sizeof(struct vmbus_channel_gpadl_teardown));
=20
-	BUG_ON(ret !=3D 0);
-	t =3D wait_for_completion_timeout(&info->waitevent, 5*HZ);
-	BUG_ON(t =3D=3D 0);
+	if (ret)
+		goto post_msg_err;
+
+	wait_for_completion(&info->waitevent);
=20
-	/* Received a torndown response */
+post_msg_err:
 	spin_lock_irqsave(&vmbus_connection.channelmsg_lock, flags);
 	list_del(&info->msglistentry);
 	spin_unlock_irqrestore(&vmbus_connection.channelmsg_lock, flags);
@@ -531,11 +531,28 @@ void vmbus_close(struct vmbus_channel *channel)
=20
 	ret =3D vmbus_post_msg(msg, sizeof(struct vmbus_channel_close_channel));
=20
-	BUG_ON(ret !=3D 0);
+	if (ret) {
+		pr_err("Close failed: close post msg return is %d\n", ret);
+		/*
+		 * If we failed to post the close msg,
+		 * it is perhaps better to leak memory.
+		 */
+		return;
+	}
+
 	/* Tear down the gpadl for the channel's ring buffer */
-	if (channel->ringbuffer_gpadlhandle)
-		vmbus_teardown_gpadl(channel,
-					  channel->ringbuffer_gpadlhandle);
+	if (channel->ringbuffer_gpadlhandle) {
+		ret =3D vmbus_teardown_gpadl(channel,
+					   channel->ringbuffer_gpadlhandle);
+		if (ret) {
+			pr_err("Close failed: teardown gpadl return %d\n", ret);
+			/*
+			 * If we failed to teardown gpadl,
+			 * it is perhaps better to leak memory.
+			 */
+			return;
+		}
+	}
=20
 	/* Cleanup the ring buffers for this channel */
 	hv_ringbuffer_cleanup(&channel->outbound);
diff --git a/drivers/hv/connection.c b/drivers/hv/connection.c
index d7f3df9..96548d7 100644
--- a/drivers/hv/connection.c
+++ b/drivers/hv/connection.c
@@ -284,10 +284,21 @@ int vmbus_post_msg(void *buffer, size_t buflen)
 	 * insufficient resources. Retry the operation a couple of
 	 * times before giving up.
 	 */
-	while (retries < 3) {
-		ret =3D  hv_post_message(conn_id, 1, buffer, buflen);
-		if (ret !=3D HV_STATUS_INSUFFICIENT_BUFFERS)
+	while (retries < 10) {
+		ret =3D hv_post_message(conn_id, 1, buffer, buflen);
+
+		switch (ret) {
+		case HV_STATUS_INSUFFICIENT_BUFFERS:
+			ret =3D -ENOMEM;
+		case -ENOMEM:
+			break;
+		case HV_STATUS_SUCCESS:
 			return ret;
+		default:
+			pr_err("hv_post_msg() failed; error code:%d\n", ret);
+			return -EINVAL;
+		}
+
 		retries++;
 		msleep(100);
 	}
diff --git a/drivers/hv/hv.c b/drivers/hv/hv.c
index 0fb100e..17ed6fb 100644
--- a/drivers/hv/hv.c
+++ b/drivers/hv/hv.c
@@ -158,6 +158,8 @@ int hv_init(void)
 	memset(hv_context.synic_event_page, 0, sizeof(void *) * MAX_NUM_CPUS);
 	memset(hv_context.synic_message_page, 0,
 	       sizeof(void *) * MAX_NUM_CPUS);
+	memset(hv_context.post_msg_page, 0,
+	       sizeof(void *) * MAX_NUM_CPUS);
=20
 	if (!query_hypervisor_presence())
 		goto cleanup;
@@ -258,26 +260,18 @@ u16 hv_post_message(union hv_connection_id connection=
_id,
 		  enum hv_message_type message_type,
 		  void *payload, size_t payload_size)
 {
-	struct aligned_input {
-		u64 alignment8;
-		struct hv_input_post_message msg;
-	};
=20
 	struct hv_input_post_message *aligned_msg;
 	u16 status;
-	unsigned long addr;
=20
 	if (payload_size > HV_MESSAGE_PAYLOAD_BYTE_COUNT)
 		return -EMSGSIZE;
=20
-	addr =3D (unsigned long)kmalloc(sizeof(struct aligned_input), GFP_ATOMIC)=
;
-	if (!addr)
-		return -ENOMEM;
-
 	aligned_msg =3D (struct hv_input_post_message *)
-			(ALIGN(addr, HV_HYPERCALL_PARAM_ALIGN));
+			hv_context.post_msg_page[get_cpu()];
=20
 	aligned_msg->connectionid =3D connection_id;
+	aligned_msg->reserved =3D 0;
 	aligned_msg->message_type =3D message_type;
 	aligned_msg->payload_size =3D payload_size;
 	memcpy((void *)aligned_msg->payload, payload, payload_size);
@@ -285,8 +279,7 @@ u16 hv_post_message(union hv_connection_id connection_i=
d,
 	status =3D do_hypercall(HVCALL_POST_MESSAGE, aligned_msg, NULL)
 		& 0xFFFF;
=20
-	kfree((void *)addr);
-
+	put_cpu();
 	return status;
 }
=20
@@ -347,6 +340,14 @@ void hv_synic_init(void *irqarg)
 		goto cleanup;
 	}
=20
+	hv_context.post_msg_page[cpu] =3D
+		(void *)get_zeroed_page(GFP_ATOMIC);
+
+	if (hv_context.post_msg_page[cpu] =3D=3D NULL) {
+		pr_err("Unable to allocate post msg page\n");
+		goto cleanup;
+	}
+
 	/* Setup the Synic's message page */
 	rdmsrl(HV_X64_MSR_SIMP, simp.as_uint64);
 	simp.simp_enabled =3D 1;
@@ -388,6 +389,8 @@ cleanup:
=20
 	if (hv_context.synic_message_page[cpu])
 		free_page((unsigned long)hv_context.synic_message_page[cpu]);
+	if (hv_context.post_msg_page[cpu])
+		free_page((unsigned long)hv_context.post_msg_page[cpu]);
 	return;
 }
=20
@@ -426,4 +429,5 @@ void hv_synic_cleanup(void *arg)
=20
 	free_page((unsigned long)hv_context.synic_message_page[cpu]);
 	free_page((unsigned long)hv_context.synic_event_page[cpu]);
+	free_page((unsigned long)hv_context.post_msg_page[cpu]);
 }
diff --git a/drivers/hv/hyperv_vmbus.h b/drivers/hv/hyperv_vmbus.h
index 0aee112..be2f3af 100644
--- a/drivers/hv/hyperv_vmbus.h
+++ b/drivers/hv/hyperv_vmbus.h
@@ -485,6 +485,10 @@ struct hv_context {
=20
 	void *synic_message_page[MAX_NUM_CPUS];
 	void *synic_event_page[MAX_NUM_CPUS];
+	/*
+	 * buffer to post messages to the host.
+	 */
+	void *post_msg_page[MAX_NUM_CPUS];
 };
=20
 extern struct hv_context hv_context;
diff --git a/drivers/input/joystick/xpad.c b/drivers/input/joystick/xpad.c
index 2189cbf..0c4c556 100644
--- a/drivers/input/joystick/xpad.c
+++ b/drivers/input/joystick/xpad.c
@@ -979,9 +979,19 @@ static int xpad_probe(struct usb_interface *intf, cons=
t struct usb_device_id *id
 		}
=20
 		ep_irq_in =3D &intf->cur_altsetting->endpoint[1].desc;
-		usb_fill_bulk_urb(xpad->bulk_out, udev,
-				usb_sndbulkpipe(udev, ep_irq_in->bEndpointAddress),
-				xpad->bdata, XPAD_PKT_LEN, xpad_bulk_out, xpad);
+		if (usb_endpoint_is_bulk_out(ep_irq_in)) {
+			usb_fill_bulk_urb(xpad->bulk_out, udev,
+					  usb_sndbulkpipe(udev,
+							  ep_irq_in->bEndpointAddress),
+					  xpad->bdata, XPAD_PKT_LEN,
+					  xpad_bulk_out, xpad);
+		} else {
+			usb_fill_int_urb(xpad->bulk_out, udev,
+					 usb_sndintpipe(udev,
+							ep_irq_in->bEndpointAddress),
+					 xpad->bdata, XPAD_PKT_LEN,
+					 xpad_bulk_out, xpad, 0);
+		}
=20
 		/*
 		 * Submit the int URB immediately rather than waiting for open
diff --git a/drivers/input/mouse/alps.c b/drivers/input/mouse/alps.c
index 9c40c11..64ce6d9 100644
--- a/drivers/input/mouse/alps.c
+++ b/drivers/input/mouse/alps.c
@@ -372,7 +372,13 @@ static psmouse_ret_t alps_process_byte(struct psmouse =
*psmouse)
 	struct alps_data *priv =3D psmouse->private;
 	const struct alps_model_info *model =3D priv->i;
=20
-	if ((psmouse->packet[0] & 0xc8) =3D=3D 0x08) { /* PS/2 packet */
+	/*
+	 * Check if we are dealing with a bare PS/2 packet, presumably from
+	 * a device connected to the external PS/2 port. Because bare PS/2
+	 * protocol does not have enough constant bits to self-synchronize
+	 * properly we only do this if the device is fully synchronized.
+	 */
+	if (!psmouse->out_of_sync_cnt && (psmouse->packet[0] & 0xc8) =3D=3D 0x08)=
 {
 		if (psmouse->pktcnt =3D=3D 3) {
 			alps_report_bare_ps2_packet(psmouse, psmouse->packet,
 						    true);
@@ -745,6 +751,9 @@ int alps_init(struct psmouse *psmouse)
 	/* We are having trouble resyncing ALPS touchpads so disable it for now *=
/
 	psmouse->resync_time =3D 0;
=20
+	/* Allow 2 invalid packets without resetting device */
+	psmouse->resetafter =3D psmouse->pktsize * 2;
+
 	return 0;
=20
 init_fail:
diff --git a/drivers/input/mouse/synaptics.c b/drivers/input/mouse/synaptic=
s.c
index a50e121..bb41f94 100644
--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -495,6 +495,8 @@ static void synaptics_parse_agm(const unsigned char buf=
[],
 	priv->agm_pending =3D true;
 }
=20
+static bool is_forcepad;
+
 static int synaptics_parse_hw_state(const unsigned char buf[],
 				    struct synaptics_data *priv,
 				    struct synaptics_hw_state *hw)
@@ -524,7 +526,7 @@ static int synaptics_parse_hw_state(const unsigned char=
 buf[],
 		hw->left  =3D (buf[0] & 0x01) ? 1 : 0;
 		hw->right =3D (buf[0] & 0x02) ? 1 : 0;
=20
-		if (SYN_CAP_FORCEPAD(priv->ext_cap_0c)) {
+		if (is_forcepad) {
 			/*
 			 * ForcePads, like Clickpads, use middle button
 			 * bits to report primary button clicks.
@@ -1507,6 +1509,18 @@ static const struct dmi_system_id min_max_dmi_table[=
] __initconst =3D {
 	{ }
 };
=20
+static const struct dmi_system_id forcepad_dmi_table[] __initconst =3D {
+#if defined(CONFIG_DMI) && defined(CONFIG_X86)
+	{
+		.matches =3D {
+			DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "HP EliteBook Folio 1040 G1"),
+		},
+	},
+#endif
+	{ }
+};
+
 void __init synaptics_module_init(void)
 {
 	const struct dmi_system_id *min_max_dmi;
@@ -1517,6 +1531,12 @@ void __init synaptics_module_init(void)
 	min_max_dmi =3D dmi_first_match(min_max_dmi_table);
 	if (min_max_dmi)
 		quirk_min_max =3D min_max_dmi->driver_data;
+
+	/*
+	 * Unfortunately ForcePad capability is not exported over PS/2,
+	 * so we have to resort to checking DMI.
+	 */
+	is_forcepad =3D dmi_check_system(forcepad_dmi_table);
 }
=20
 int synaptics_init(struct psmouse *psmouse)
diff --git a/drivers/input/mouse/synaptics.h b/drivers/input/mouse/synaptic=
s.h
index 908d167..6cf156d 100644
--- a/drivers/input/mouse/synaptics.h
+++ b/drivers/input/mouse/synaptics.h
@@ -76,12 +76,9 @@
  *					for noise.
  * 2	0x08	image sensor		image sensor tracks 5 fingers, but only
  *					reports 2.
+ * 2	0x01	uniform clickpad	whole clickpad moves instead of being
+ *					hinged at the top.
  * 2	0x20	report min		query 0x0f gives min coord reported
- * 2	0x80	forcepad		forcepad is a variant of clickpad that
- *					does not have physical buttons but rather
- *					uses pressure above certain threshold to
- *					report primary clicks. Forcepads also have
- *					clickpad bit set.
  */
 #define SYN_CAP_CLICKPAD(ex0c)		((ex0c) & 0x100000) /* 1-button ClickPad *=
/
 #define SYN_CAP_CLICKPAD2BTN(ex0c)	((ex0c) & 0x000100) /* 2-button ClickPa=
d */
@@ -90,7 +87,6 @@
 #define SYN_CAP_ADV_GESTURE(ex0c)	((ex0c) & 0x080000)
 #define SYN_CAP_REDUCED_FILTERING(ex0c)	((ex0c) & 0x000400)
 #define SYN_CAP_IMAGE_SENSOR(ex0c)	((ex0c) & 0x000800)
-#define SYN_CAP_FORCEPAD(ex0c)		((ex0c) & 0x008000)
=20
 /* synaptics modes query bits */
 #define SYN_MODE_ABSOLUTE(m)		((m) & (1 << 7))
diff --git a/drivers/input/serio/i8042-x86ia64io.h b/drivers/input/serio/i8=
042-x86ia64io.h
index bab8238..a5c6a8c 100644
--- a/drivers/input/serio/i8042-x86ia64io.h
+++ b/drivers/input/serio/i8042-x86ia64io.h
@@ -101,6 +101,12 @@ static const struct dmi_system_id __initconst i8042_dm=
i_noloop_table[] =3D {
 	},
 	{
 		.matches =3D {
+			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "X750LN"),
+		},
+	},
+	{
+		.matches =3D {
 			DMI_MATCH(DMI_SYS_VENDOR, "Compaq"),
 			DMI_MATCH(DMI_PRODUCT_NAME , "ProLiant"),
 			DMI_MATCH(DMI_PRODUCT_VERSION, "8500"),
@@ -602,6 +608,22 @@ static const struct dmi_system_id __initconst i8042_dm=
i_notimeout_table[] =3D {
 		},
 	},
 	{
+		/* Fujitsu A544 laptop */
+		/* https://bugzilla.redhat.com/show_bug.cgi?id=3D1111138 */
+		.matches =3D {
+			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "LIFEBOOK A544"),
+		},
+	},
+	{
+		/* Fujitsu AH544 laptop */
+		/* https://bugzilla.kernel.org/show_bug.cgi?id=3D69731 */
+		.matches =3D {
+			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "LIFEBOOK AH544"),
+		},
+	},
+	{
 		/* Fujitsu U574 laptop */
 		/* https://bugzilla.kernel.org/show_bug.cgi?id=3D69731 */
 		.matches =3D {
diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
index 910d2f8..3bf72679 100644
--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -468,6 +468,7 @@ static void __relink_lru(struct dm_buffer *b, int dirty=
)
 	b->list_mode =3D dirty;
 	list_del(&b->lru_list);
 	list_add(&b->lru_list, &c->lru[dirty]);
+	b->last_accessed =3D jiffies;
 }
=20
 /*----------------------------------------------------------------
@@ -1323,9 +1324,9 @@ static void drop_buffers(struct dm_bufio_client *c)
=20
 /*
  * Test if the buffer is unused and too old, and commit it.
- * At if noio is set, we must not do any I/O because we hold
- * dm_bufio_clients_lock and we would risk deadlock if the I/O gets rerout=
ed to
- * different bufio client.
+ * And if GFP_NOFS is used, we must not do any I/O because we hold
+ * dm_bufio_clients_lock and we would risk deadlock if the I/O gets
+ * rerouted to different bufio client.
  */
 static int __cleanup_old_buffer(struct dm_buffer *b, gfp_t gfp,
 				unsigned long max_jiffies)
@@ -1333,7 +1334,7 @@ static int __cleanup_old_buffer(struct dm_buffer *b, =
gfp_t gfp,
 	if (jiffies - b->last_accessed < max_jiffies)
 		return 1;
=20
-	if (!(gfp & __GFP_IO)) {
+	if (!(gfp & __GFP_FS)) {
 		if (test_bit(B_READING, &b->state) ||
 		    test_bit(B_WRITING, &b->state) ||
 		    test_bit(B_DIRTY, &b->state))
@@ -1372,7 +1373,7 @@ static int shrink(struct shrinker *shrinker, struct s=
hrink_control *sc)
 	unsigned long r;
 	unsigned long nr_to_scan =3D sc->nr_to_scan;
=20
-	if (sc->gfp_mask & __GFP_IO)
+	if (sc->gfp_mask & __GFP_FS)
 		dm_bufio_lock(c);
 	else if (!dm_bufio_trylock(c))
 		return !nr_to_scan ? 0 : -1;
diff --git a/drivers/md/dm-log-userspace-transfer.c b/drivers/md/dm-log-use=
rspace-transfer.c
index 1f23e04..e5bd3ef 100644
--- a/drivers/md/dm-log-userspace-transfer.c
+++ b/drivers/md/dm-log-userspace-transfer.c
@@ -272,7 +272,7 @@ int dm_ulog_tfr_init(void)
=20
 	r =3D cn_add_callback(&ulog_cn_id, "dmlogusr", cn_ulog_callback);
 	if (r) {
-		cn_del_callback(&ulog_cn_id);
+		kfree(prealloced_cn_msg);
 		return r;
 	}
=20
diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 86862ea..8158f63 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -591,8 +591,7 @@ struct dm_raid_superblock {
 	__le32 layout;
 	__le32 stripe_sectors;
=20
-	__u8 pad[452];		/* Round struct to 512 bytes. */
-				/* Always set to 0 when writing. */
+	/* Remainder of a logical block is zero-filled when writing (see super_sy=
nc()). */
 } __packed;
=20
 static int read_disk_sb(struct md_rdev *rdev, int size)
@@ -625,7 +624,7 @@ static void super_sync(struct mddev *mddev, struct md_r=
dev *rdev)
 		if ((r->raid_disk >=3D 0) && test_bit(Faulty, &r->flags))
 			failed_devices |=3D (1ULL << r->raid_disk);
=20
-	memset(sb, 0, sizeof(*sb));
+	memset(sb + 1, 0, rdev->sb_size - sizeof(*sb));
=20
 	sb->magic =3D cpu_to_le32(DM_RAID_MAGIC);
 	sb->features =3D cpu_to_le32(0);	/* No features yet */
@@ -660,7 +659,11 @@ static int super_load(struct md_rdev *rdev, struct md_=
rdev *refdev)
 	uint64_t events_sb, events_refsb;
=20
 	rdev->sb_start =3D 0;
-	rdev->sb_size =3D sizeof(*sb);
+	rdev->sb_size =3D bdev_logical_block_size(rdev->meta_bdev);
+	if (rdev->sb_size < sizeof(*sb) || rdev->sb_size > PAGE_SIZE) {
+		DMERR("superblock size of a logical block is no longer valid");
+		return -EINVAL;
+	}
=20
 	ret =3D read_disk_sb(rdev, rdev->sb_size);
 	if (ret)
diff --git a/drivers/media/dvb/frontends/ds3000.c b/drivers/media/dvb/front=
ends/ds3000.c
index 90bf573..2151c99 100644
--- a/drivers/media/dvb/frontends/ds3000.c
+++ b/drivers/media/dvb/frontends/ds3000.c
@@ -925,6 +925,13 @@ struct dvb_frontend *ds3000_attach(const struct ds3000=
_config *config,
 	memcpy(&state->frontend.ops, &ds3000_ops,
 			sizeof(struct dvb_frontend_ops));
 	state->frontend.demodulator_priv =3D state;
+
+	/*
+	 * Some devices like T480 starts with voltage on. Be sure
+	 * to turn voltage off during init, as this can otherwise
+	 * interfere with Unicable SCR systems.
+	 */
+	ds3000_set_voltage(&state->frontend, SEC_VOLTAGE_OFF);
 	return &state->frontend;
=20
 error3:
diff --git a/drivers/media/video/uvc/uvc_driver.c b/drivers/media/video/uvc=
/uvc_driver.c
index 656d4c9..8fd00e8 100644
--- a/drivers/media/video/uvc/uvc_driver.c
+++ b/drivers/media/video/uvc/uvc_driver.c
@@ -2126,6 +2126,15 @@ static struct usb_device_id uvc_ids[] =3D {
 	  .bInterfaceSubClass	=3D 1,
 	  .bInterfaceProtocol	=3D 0,
 	  .driver_info		=3D UVC_QUIRK_PROBE_MINMAX },
+	/* Dell XPS M1330 (OmniVision OV7670 webcam) */
+	{ .match_flags		=3D USB_DEVICE_ID_MATCH_DEVICE
+				| USB_DEVICE_ID_MATCH_INT_INFO,
+	  .idVendor		=3D 0x05a9,
+	  .idProduct		=3D 0x7670,
+	  .bInterfaceClass	=3D USB_CLASS_VIDEO,
+	  .bInterfaceSubClass	=3D 1,
+	  .bInterfaceProtocol	=3D 0,
+	  .driver_info		=3D UVC_QUIRK_PROBE_DEF },
 	/* Apple Built-In iSight */
 	{ .match_flags		=3D USB_DEVICE_ID_MATCH_DEVICE
 				| USB_DEVICE_ID_MATCH_INT_INFO,
diff --git a/drivers/media/video/v4l2-common.c b/drivers/media/video/v4l2-c=
ommon.c
index 5c6100f..d46495d 100644
--- a/drivers/media/video/v4l2-common.c
+++ b/drivers/media/video/v4l2-common.c
@@ -487,16 +487,13 @@ static unsigned int clamp_align(unsigned int x, unsig=
ned int min,
 	/* Bits that must be zero to be aligned */
 	unsigned int mask =3D ~((1 << align) - 1);
=20
+	/* Clamp to aligned min and max */
+	x =3D clamp(x, (min + ~mask) & mask, max & mask);
+
 	/* Round to nearest aligned value */
 	if (align)
 		x =3D (x + (1 << (align - 1))) & mask;
=20
-	/* Clamp to aligned value of min and max */
-	if (x < min)
-		x =3D (min + ~mask) & mask;
-	else if (x > max)
-		x =3D max & mask;
-
 	return x;
 }
=20
diff --git a/drivers/net/can/dev.c b/drivers/net/can/dev.c
index de87f82..1eac27f 100644
--- a/drivers/net/can/dev.c
+++ b/drivers/net/can/dev.c
@@ -352,7 +352,7 @@ void can_free_echo_skb(struct net_device *dev, unsigned=
 int idx)
 	BUG_ON(idx >=3D priv->echo_skb_max);
=20
 	if (priv->echo_skb[idx]) {
-		kfree_skb(priv->echo_skb[idx]);
+		dev_kfree_skb_any(priv->echo_skb[idx]);
 		priv->echo_skb[idx] =3D NULL;
 	}
 }
diff --git a/drivers/net/can/usb/esd_usb2.c b/drivers/net/can/usb/esd_usb2.=
c
index eb8b0e6..9ecf098 100644
--- a/drivers/net/can/usb/esd_usb2.c
+++ b/drivers/net/can/usb/esd_usb2.c
@@ -1097,6 +1097,7 @@ static void esd_usb2_disconnect(struct usb_interface =
*intf)
 			}
 		}
 		unlink_all_urbs(dev);
+		kfree(dev);
 	}
 }
=20
diff --git a/drivers/net/ppp/ppp_generic.c b/drivers/net/ppp/ppp_generic.c
index 3ed983c..4782d79 100644
--- a/drivers/net/ppp/ppp_generic.c
+++ b/drivers/net/ppp/ppp_generic.c
@@ -588,7 +588,7 @@ static long ppp_ioctl(struct file *file, unsigned int c=
md, unsigned long arg)
 			if (file =3D=3D ppp->owner)
 				ppp_shutdown_interface(ppp);
 		}
-		if (atomic_long_read(&file->f_count) <=3D 2) {
+		if (atomic_long_read(&file->f_count) < 2) {
 			ppp_release(NULL, file);
 			err =3D 0;
 		} else
diff --git a/drivers/net/wireless/rt2x00/rt2800.h b/drivers/net/wireless/rt=
2x00/rt2800.h
index 4778620..5396e3b 100644
--- a/drivers/net/wireless/rt2x00/rt2800.h
+++ b/drivers/net/wireless/rt2x00/rt2800.h
@@ -1737,7 +1737,7 @@ struct mac_iveiv_entry {
  * 2 - drop tx power by 12dBm,
  * 3 - increase tx power by 6dBm
  */
-#define BBP1_TX_POWER_CTRL		FIELD8(0x07)
+#define BBP1_TX_POWER_CTRL		FIELD8(0x03)
 #define BBP1_TX_ANTENNA			FIELD8(0x18)
=20
 /*
diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless=
/rt2x00/rt2800usb.c
index 3d4ea1fb..ee7efd2 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -1031,6 +1031,7 @@ static struct usb_device_id rt2800usb_device_table[] =
=3D {
 	/* Ovislink */
 	{ USB_DEVICE(0x1b75, 0x3071) },
 	{ USB_DEVICE(0x1b75, 0x3072) },
+	{ USB_DEVICE(0x1b75, 0xa200) },
 	/* Para */
 	{ USB_DEVICE(0x20b8, 0x8888) },
 	/* Pegatron */
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wirele=
ss/rt2x00/rt2x00queue.c
index 4d792a2..c5bdbe9 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
@@ -148,55 +148,29 @@ void rt2x00queue_align_frame(struct sk_buff *skb)
 	skb_trim(skb, frame_length);
 }
=20
-void rt2x00queue_insert_l2pad(struct sk_buff *skb, unsigned int header_len=
gth)
+/*
+ * H/W needs L2 padding between the header and the paylod if header size
+ * is not 4 bytes aligned.
+ */
+void rt2x00queue_insert_l2pad(struct sk_buff *skb, unsigned int hdr_len)
 {
-	unsigned int payload_length =3D skb->len - header_length;
-	unsigned int header_align =3D ALIGN_SIZE(skb, 0);
-	unsigned int payload_align =3D ALIGN_SIZE(skb, header_length);
-	unsigned int l2pad =3D payload_length ? L2PAD_SIZE(header_length) : 0;
+	unsigned int l2pad =3D (skb->len > hdr_len) ? L2PAD_SIZE(hdr_len) : 0;
=20
-	/*
-	 * Adjust the header alignment if the payload needs to be moved more
-	 * than the header.
-	 */
-	if (payload_align > header_align)
-		header_align +=3D 4;
-
-	/* There is nothing to do if no alignment is needed */
-	if (!header_align)
+	if (!l2pad)
 		return;
=20
-	/* Reserve the amount of space needed in front of the frame */
-	skb_push(skb, header_align);
-
-	/*
-	 * Move the header.
-	 */
-	memmove(skb->data, skb->data + header_align, header_length);
-
-	/* Move the payload, if present and if required */
-	if (payload_length && payload_align)
-		memmove(skb->data + header_length + l2pad,
-			skb->data + header_length + l2pad + payload_align,
-			payload_length);
-
-	/* Trim the skb to the correct size */
-	skb_trim(skb, header_length + l2pad + payload_length);
+	skb_push(skb, l2pad);
+	memmove(skb->data, skb->data + l2pad, hdr_len);
 }
=20
-void rt2x00queue_remove_l2pad(struct sk_buff *skb, unsigned int header_len=
gth)
+void rt2x00queue_remove_l2pad(struct sk_buff *skb, unsigned int hdr_len)
 {
-	/*
-	 * L2 padding is only present if the skb contains more than just the
-	 * IEEE 802.11 header.
-	 */
-	unsigned int l2pad =3D (skb->len > header_length) ?
-				L2PAD_SIZE(header_length) : 0;
+	unsigned int l2pad =3D (skb->len > hdr_len) ? L2PAD_SIZE(hdr_len) : 0;
=20
 	if (!l2pad)
 		return;
=20
-	memmove(skb->data + l2pad, skb->data, header_length);
+	memmove(skb->data + l2pad, skb->data, hdr_len);
 	skb_pull(skb, l2pad);
 }
=20
diff --git a/drivers/of/address.c b/drivers/of/address.c
index 45c1727..53a613f 100644
--- a/drivers/of/address.c
+++ b/drivers/of/address.c
@@ -333,6 +333,22 @@ static struct of_bus *of_match_bus(struct device_node =
*np)
 	return NULL;
 }
=20
+static int of_empty_ranges_quirk(void)
+{
+#ifdef CONFIG_PPC
+	/* To save cycles, we cache the result */
+	static int quirk_state =3D -1;
+
+	if (quirk_state < 0)
+		quirk_state =3D
+			of_machine_is_compatible("Power Macintosh") ||
+			of_machine_is_compatible("MacRISC");
+	return quirk_state;
+#else
+	return false;
+#endif
+}
+
 static int of_translate_one(struct device_node *parent, struct of_bus *bus=
,
 			    struct of_bus *pbus, u32 *addr,
 			    int na, int ns, int pna, const char *rprop)
@@ -358,12 +374,10 @@ static int of_translate_one(struct device_node *paren=
t, struct of_bus *bus,
 	 * This code is only enabled on powerpc. --gcl
 	 */
 	ranges =3D of_get_property(parent, rprop, &rlen);
-#if !defined(CONFIG_PPC)
-	if (ranges =3D=3D NULL) {
+	if (ranges =3D=3D NULL && !of_empty_ranges_quirk()) {
 		pr_err("OF: no ranges; cannot translate\n");
 		return 1;
 	}
-#endif /* !defined(CONFIG_PPC) */
 	if (ranges =3D=3D NULL || rlen =3D=3D 0) {
 		offset =3D of_read_number(addr, na);
 		memset(addr, 0, pna * 4);
diff --git a/drivers/pci/hotplug/pciehp_core.c b/drivers/pci/hotplug/pciehp=
_core.c
index 9350af9..dc126a2 100644
--- a/drivers/pci/hotplug/pciehp_core.c
+++ b/drivers/pci/hotplug/pciehp_core.c
@@ -237,6 +237,13 @@ static int pciehp_probe(struct pcie_device *dev)
 	else if (pciehp_acpi_slot_detection_check(dev->port))
 		goto err_out_none;
=20
+	if (!dev->port->subordinate) {
+		/* Can happen if we run out of bus numbers during probe */
+		dev_err(&dev->device,
+			"Hotplug bridge without secondary bus, ignoring\n");
+		goto err_out_none;
+	}
+
 	ctrl =3D pcie_init(dev);
 	if (!ctrl) {
 		dev_err(&dev->device, "Controller initialization failed\n");
diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index 106be0d..1e6be19 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -173,7 +173,7 @@ static ssize_t modalias_show(struct device *dev, struct=
 device_attribute *attr,
 {
 	struct pci_dev *pci_dev =3D to_pci_dev(dev);
=20
-	return sprintf(buf, "pci:v%08Xd%08Xsv%08Xsd%08Xbc%02Xsc%02Xi%02x\n",
+	return sprintf(buf, "pci:v%08Xd%08Xsv%08Xsd%08Xbc%02Xsc%02Xi%02X\n",
 		       pci_dev->vendor, pci_dev->device,
 		       pci_dev->subsystem_vendor, pci_dev->subsystem_device,
 		       (u8)(pci_dev->class >> 16), (u8)(pci_dev->class >> 8),
diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index f0c8c5d..9b48d61 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -26,6 +26,7 @@
 #include <linux/dmi.h>
 #include <linux/pci-aspm.h>
 #include <linux/ioport.h>
+#include <linux/mm.h>
 #include <asm/dma.h>	/* isa_dma_bridge_buggy */
 #include "pci.h"
=20
@@ -352,6 +353,25 @@ static void __devinit quirk_citrine(struct pci_dev *de=
v)
 }
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_IBM,	PCI_DEVICE_ID_IBM_CITRINE,	qui=
rk_citrine);
=20
+/*  On IBM Crocodile ipr SAS adapters, expand BAR to system page size */
+static void quirk_extend_bar_to_page(struct pci_dev *dev)
+{
+	int i;
+
+	for (i =3D 0; i < PCI_STD_RESOURCE_END; i++) {
+		struct resource *r =3D &dev->resource[i];
+
+		if (r->flags & IORESOURCE_MEM && resource_size(r) < PAGE_SIZE) {
+			r->end =3D PAGE_SIZE - 1;
+			r->start =3D 0;
+			r->flags |=3D IORESOURCE_UNSET;
+			dev_info(&dev->dev, "expanded BAR %d to page size: %pR\n",
+				 i, r);
+		}
+	}
+}
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_IBM, 0x034a, quirk_extend_bar_to_pa=
ge);
+
 /*
  *  S3 868 and 968 chips report region size equal to 32M, but they decode =
64M.
  *  If it's needed, re-allocate the region.
diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc=
_fcoe.c
index 8c6156a..b215f32 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
@@ -407,6 +407,7 @@ static int bnx2fc_rcv(struct sk_buff *skb, struct net_d=
evice *dev,
 	struct fc_frame_header *fh;
 	struct fcoe_rcv_info *fr;
 	struct fcoe_percpu_s *bg;
+	struct sk_buff *tmp_skb;
 	unsigned short oxid;
=20
 	interface =3D container_of(ptype, struct bnx2fc_interface,
@@ -418,6 +419,12 @@ static int bnx2fc_rcv(struct sk_buff *skb, struct net_=
device *dev,
 		goto err;
 	}
=20
+	tmp_skb =3D skb_share_check(skb, GFP_ATOMIC);
+	if (!tmp_skb)
+		goto err;
+
+	skb =3D tmp_skb;
+
 	if (unlikely(eth_hdr(skb)->h_proto !=3D htons(ETH_P_FCOE))) {
 		printk(KERN_ERR PFX "bnx2fc_rcv: Wrong FC type frame\n");
 		goto err;
diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 603a2cb..64c8a80 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -1126,8 +1126,8 @@ static void complete_scsi_command(struct CommandList =
*cp)
 	scsi_set_resid(cmd, ei->ResidualCnt);
=20
 	if (ei->CommandStatus =3D=3D 0) {
-		cmd->scsi_done(cmd);
 		cmd_free(h, cp);
+		cmd->scsi_done(cmd);
 		return;
 	}
=20
@@ -1300,8 +1300,8 @@ static void complete_scsi_command(struct CommandList =
*cp)
 		dev_warn(&h->pdev->dev, "cp %p returned unknown status %x\n",
 				cp, ei->CommandStatus);
 	}
-	cmd->scsi_done(cmd);
 	cmd_free(h, cp);
+	cmd->scsi_done(cmd);
 }
=20
 static int hpsa_scsi_detect(struct ctlr_info *h)
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index d2f8061..f51234e 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -1665,8 +1665,10 @@ static void scsi_restart_operations(struct Scsi_Host=
 *shost)
 	 * is no point trying to lock the door of an off-line device.
 	 */
 	shost_for_each_device(sdev, shost) {
-		if (scsi_device_online(sdev) && sdev->locked)
+		if (scsi_device_online(sdev) && sdev->was_reset && sdev->locked) {
 			scsi_eh_lock_door(sdev);
+			sdev->was_reset =3D 0;
+		}
 	}
=20
 	/*
diff --git a/drivers/spi/spi-dw-mid.c b/drivers/spi/spi-dw-mid.c
index e743a45..c0ca0ee 100644
--- a/drivers/spi/spi-dw-mid.c
+++ b/drivers/spi/spi-dw-mid.c
@@ -88,7 +88,13 @@ err_exit:
=20
 static void mid_spi_dma_exit(struct dw_spi *dws)
 {
+	if (!dws->dma_inited)
+		return;
+
+	dmaengine_terminate_all(dws->txchan);
 	dma_release_channel(dws->txchan);
+
+	dmaengine_terminate_all(dws->rxchan);
 	dma_release_channel(dws->rxchan);
 }
=20
@@ -135,7 +141,7 @@ static int mid_spi_dma_transfer(struct dw_spi *dws, int=
 cs_change)
 	txconf.dst_addr =3D dws->dma_addr;
 	txconf.dst_maxburst =3D LNW_DMA_MSIZE_16;
 	txconf.src_addr_width =3D DMA_SLAVE_BUSWIDTH_4_BYTES;
-	txconf.dst_addr_width =3D DMA_SLAVE_BUSWIDTH_2_BYTES;
+	txconf.dst_addr_width =3D dws->dma_width;
=20
 	txchan->device->device_control(txchan, DMA_SLAVE_CONFIG,
 				       (unsigned long) &txconf);
@@ -157,7 +163,7 @@ static int mid_spi_dma_transfer(struct dw_spi *dws, int=
 cs_change)
 	rxconf.src_addr =3D dws->dma_addr;
 	rxconf.src_maxburst =3D LNW_DMA_MSIZE_16;
 	rxconf.dst_addr_width =3D DMA_SLAVE_BUSWIDTH_4_BYTES;
-	rxconf.src_addr_width =3D DMA_SLAVE_BUSWIDTH_2_BYTES;
+	rxconf.src_addr_width =3D dws->dma_width;
=20
 	rxchan->device->device_control(rxchan, DMA_SLAVE_CONFIG,
 				       (unsigned long) &rxconf);
diff --git a/drivers/spi/spi-dw.c b/drivers/spi/spi-dw.c
index 082458d..9eddaab 100644
--- a/drivers/spi/spi-dw.c
+++ b/drivers/spi/spi-dw.c
@@ -400,9 +400,6 @@ static void pump_transfers(unsigned long data)
 	chip =3D dws->cur_chip;
 	spi =3D message->spi;
=20
-	if (unlikely(!chip->clk_div))
-		chip->clk_div =3D dws->max_freq / chip->speed_hz;
-
 	if (message->state =3D=3D ERROR_STATE) {
 		message->status =3D -EIO;
 		goto early_exit;
@@ -444,7 +441,7 @@ static void pump_transfers(unsigned long data)
 	if (transfer->speed_hz) {
 		speed =3D chip->speed_hz;
=20
-		if (transfer->speed_hz !=3D speed) {
+		if ((transfer->speed_hz !=3D speed) || (!chip->clk_div)) {
 			speed =3D transfer->speed_hz;
 			if (speed > dws->max_freq) {
 				printk(KERN_ERR "MRST SPI0: unsupported"
@@ -683,7 +680,6 @@ static int dw_spi_setup(struct spi_device *spi)
 		dev_err(&spi->dev, "No max speed HZ parameter\n");
 		return -EINVAL;
 	}
-	chip->speed_hz =3D spi->max_speed_hz;
=20
 	chip->tmode =3D 0; /* Tx & Rx */
 	/* Default SPI mode is SCPOL =3D 0, SCPH =3D 0 */
diff --git a/drivers/spi/spi-pl022.c b/drivers/spi/spi-pl022.c
index 5559b22..62b21ca 100644
--- a/drivers/spi/spi-pl022.c
+++ b/drivers/spi/spi-pl022.c
@@ -1078,7 +1078,7 @@ err_rxdesc:
 		     pl022->sgt_tx.nents, DMA_TO_DEVICE);
 err_tx_sgmap:
 	dma_unmap_sg(rxchan->device->dev, pl022->sgt_rx.sgl,
-		     pl022->sgt_tx.nents, DMA_FROM_DEVICE);
+		     pl022->sgt_rx.nents, DMA_FROM_DEVICE);
 err_rx_sgmap:
 	sg_free_table(&pl022->sgt_tx);
 err_alloc_tx_sg:
diff --git a/drivers/staging/iio/impedance-analyzer/ad5933.c b/drivers/stag=
ing/iio/impedance-analyzer/ad5933.c
index 1086e0b..b8819de 100644
--- a/drivers/staging/iio/impedance-analyzer/ad5933.c
+++ b/drivers/staging/iio/impedance-analyzer/ad5933.c
@@ -112,10 +112,10 @@ static struct iio_chan_spec ad5933_channels[] =3D {
 	IIO_CHAN(IIO_TEMP, 0, 1, 1, NULL, 0, 0, 0,
 		 0, AD5933_REG_TEMP_DATA, IIO_ST('s', 14, 16, 0), 0),
 	/* Ring Channels */
-	IIO_CHAN(IIO_VOLTAGE, 0, 1, 0, "real_raw", 0, 0,
+	IIO_CHAN(IIO_VOLTAGE, 0, 1, 0, "real", 0, 0,
 		 (1 << IIO_CHAN_INFO_SCALE_SEPARATE),
 		 AD5933_REG_REAL_DATA, 0, IIO_ST('s', 16, 16, 0), 0),
-	IIO_CHAN(IIO_VOLTAGE, 0, 1, 0, "imag_raw", 0, 0,
+	IIO_CHAN(IIO_VOLTAGE, 0, 1, 0, "imag", 0, 0,
 		 (1 << IIO_CHAN_INFO_SCALE_SEPARATE),
 		 AD5933_REG_IMAG_DATA, 1, IIO_ST('s', 16, 16, 0), 0),
 };
diff --git a/drivers/staging/iio/meter/ade7758_core.c b/drivers/staging/iio=
/meter/ade7758_core.c
index c5dafbd..5a46d91 100644
--- a/drivers/staging/iio/meter/ade7758_core.c
+++ b/drivers/staging/iio/meter/ade7758_core.c
@@ -662,63 +662,63 @@ static const struct attribute_group ade7758_attribute=
_group =3D {
 };
=20
 static struct iio_chan_spec ade7758_channels[] =3D {
-	IIO_CHAN(IIO_VOLTAGE, 0, 1, 0, "raw", 0, 0,
+	IIO_CHAN(IIO_VOLTAGE, 0, 1, 0, NULL, 0, 0,
 		(1 << IIO_CHAN_INFO_SCALE_SHARED),
 		AD7758_WT(AD7758_PHASE_A, AD7758_VOLTAGE),
 		0, IIO_ST('s', 24, 32, 0), 0),
-	IIO_CHAN(IIO_CURRENT, 0, 1, 0, "raw", 0, 0,
+	IIO_CHAN(IIO_CURRENT, 0, 1, 0, NULL, 0, 0,
 		(1 << IIO_CHAN_INFO_SCALE_SHARED),
 		AD7758_WT(AD7758_PHASE_A, AD7758_CURRENT),
 		1, IIO_ST('s', 24, 32, 0), 0),
-	IIO_CHAN(IIO_POWER, 0, 1, 0, "apparent_raw", 0, 0,
+	IIO_CHAN(IIO_POWER, 0, 1, 0, "apparent", 0, 0,
 		(1 << IIO_CHAN_INFO_SCALE_SHARED),
 		AD7758_WT(AD7758_PHASE_A, AD7758_APP_PWR),
 		2, IIO_ST('s', 24, 32, 0), 0),
-	IIO_CHAN(IIO_POWER, 0, 1, 0, "active_raw", 0, 0,
+	IIO_CHAN(IIO_POWER, 0, 1, 0, "active", 0, 0,
 		(1 << IIO_CHAN_INFO_SCALE_SHARED),
 		AD7758_WT(AD7758_PHASE_A, AD7758_ACT_PWR),
 		3, IIO_ST('s', 24, 32, 0), 0),
-	IIO_CHAN(IIO_POWER, 0, 1, 0, "reactive_raw", 0, 0,
+	IIO_CHAN(IIO_POWER, 0, 1, 0, "reactive", 0, 0,
 		(1 << IIO_CHAN_INFO_SCALE_SHARED),
 		AD7758_WT(AD7758_PHASE_A, AD7758_REACT_PWR),
 		4, IIO_ST('s', 24, 32, 0), 0),
-	IIO_CHAN(IIO_VOLTAGE, 0, 1, 0, "raw", 1, 0,
+	IIO_CHAN(IIO_VOLTAGE, 0, 1, 0, NULL, 1, 0,
 		(1 << IIO_CHAN_INFO_SCALE_SHARED),
 		AD7758_WT(AD7758_PHASE_B, AD7758_VOLTAGE),
 		5, IIO_ST('s', 24, 32, 0), 0),
-	IIO_CHAN(IIO_CURRENT, 0, 1, 0, "raw", 1, 0,
+	IIO_CHAN(IIO_CURRENT, 0, 1, 0, NULL, 1, 0,
 		(1 << IIO_CHAN_INFO_SCALE_SHARED),
 		AD7758_WT(AD7758_PHASE_B, AD7758_CURRENT),
 		6, IIO_ST('s', 24, 32, 0), 0),
-	IIO_CHAN(IIO_POWER, 0, 1, 0, "apparent_raw", 1, 0,
+	IIO_CHAN(IIO_POWER, 0, 1, 0, "apparent", 1, 0,
 		(1 << IIO_CHAN_INFO_SCALE_SHARED),
 		AD7758_WT(AD7758_PHASE_B, AD7758_APP_PWR),
 		7, IIO_ST('s', 24, 32, 0), 0),
-	IIO_CHAN(IIO_POWER, 0, 1, 0, "active_raw", 1, 0,
+	IIO_CHAN(IIO_POWER, 0, 1, 0, "active", 1, 0,
 		(1 << IIO_CHAN_INFO_SCALE_SHARED),
 		AD7758_WT(AD7758_PHASE_B, AD7758_ACT_PWR),
 		8, IIO_ST('s', 24, 32, 0), 0),
-	IIO_CHAN(IIO_POWER, 0, 1, 0, "reactive_raw", 1, 0,
+	IIO_CHAN(IIO_POWER, 0, 1, 0, "reactive", 1, 0,
 		(1 << IIO_CHAN_INFO_SCALE_SHARED),
 		AD7758_WT(AD7758_PHASE_B, AD7758_REACT_PWR),
 		9, IIO_ST('s', 24, 32, 0), 0),
-	IIO_CHAN(IIO_VOLTAGE, 0, 1, 0, "raw", 2, 0,
+	IIO_CHAN(IIO_VOLTAGE, 0, 1, 0, NULL, 2, 0,
 		(1 << IIO_CHAN_INFO_SCALE_SHARED),
 		AD7758_WT(AD7758_PHASE_C, AD7758_VOLTAGE),
 		10, IIO_ST('s', 24, 32, 0), 0),
-	IIO_CHAN(IIO_CURRENT, 0, 1, 0, "raw", 2, 0,
+	IIO_CHAN(IIO_CURRENT, 0, 1, 0, NULL, 2, 0,
 		(1 << IIO_CHAN_INFO_SCALE_SHARED),
 		AD7758_WT(AD7758_PHASE_C, AD7758_CURRENT),
 		11, IIO_ST('s', 24, 32, 0), 0),
-	IIO_CHAN(IIO_POWER, 0, 1, 0, "apparent_raw", 2, 0,
+	IIO_CHAN(IIO_POWER, 0, 1, 0, "apparent", 2, 0,
 		(1 << IIO_CHAN_INFO_SCALE_SHARED),
 		AD7758_WT(AD7758_PHASE_C, AD7758_APP_PWR),
 		12, IIO_ST('s', 24, 32, 0), 0),
-	IIO_CHAN(IIO_POWER, 0, 1, 0, "active_raw", 2, 0,
+	IIO_CHAN(IIO_POWER, 0, 1, 0, "active", 2, 0,
 		(1 << IIO_CHAN_INFO_SCALE_SHARED),
 		AD7758_WT(AD7758_PHASE_C, AD7758_ACT_PWR),
 		13, IIO_ST('s', 24, 32, 0), 0),
-	IIO_CHAN(IIO_POWER, 0, 1, 0, "reactive_raw", 2, 0,
+	IIO_CHAN(IIO_POWER, 0, 1, 0, "reactive", 2, 0,
 		(1 << IIO_CHAN_INFO_SCALE_SHARED),
 		AD7758_WT(AD7758_PHASE_C, AD7758_REACT_PWR),
 		14, IIO_ST('s', 24, 32, 0), 0),
diff --git a/drivers/staging/iio/sysfs.h b/drivers/staging/iio/sysfs.h
index 868952b..afcec4f 100644
--- a/drivers/staging/iio/sysfs.h
+++ b/drivers/staging/iio/sysfs.h
@@ -147,7 +147,7 @@ enum iio_event_direction {
=20
 #define IIO_EVENT_CODE_EXTRACT_TYPE(mask) ((mask >> 56) & 0xFF)
=20
-#define IIO_EVENT_CODE_EXTRACT_DIR(mask) ((mask >> 48) & 0xCF)
+#define IIO_EVENT_CODE_EXTRACT_DIR(mask) ((mask >> 48) & 0x7F)
=20
 #define IIO_EVENT_CODE_EXTRACT_CHAN_TYPE(mask) ((mask >> 32) & 0xFF)
=20
diff --git a/drivers/staging/mei/init.c b/drivers/staging/mei/init.c
index 8bf3479..a78e63b 100644
--- a/drivers/staging/mei/init.c
+++ b/drivers/staging/mei/init.c
@@ -132,6 +132,7 @@ struct mei_device *mei_device_init(struct pci_dev *pdev=
)
 	init_waitqueue_head(&dev->wait_recvd_msg);
 	init_waitqueue_head(&dev->wait_stop_wd);
 	dev->mei_state =3D MEI_INITIALIZING;
+	dev->reset_count =3D 0;
 	dev->iamthif_state =3D MEI_IAMTHIF_IDLE;
 	dev->wd_interface_reg =3D false;
=20
@@ -290,6 +291,14 @@ void mei_reset(struct mei_device *dev, int interrupts_=
enabled)
=20
 	dev->need_reset =3D false;
=20
+	dev->reset_count++;
+	if (dev->reset_count > MEI_MAX_CONSEC_RESET) {
+		dev_err(&dev->pdev->dev, "reset: reached maximal consecutive resets: dis=
abling the device\n");
+		dev->mei_state =3D MEI_DISABLED;
+		return;
+	}
+
+
 	if (dev->mei_state !=3D MEI_INITIALIZING) {
 		if (dev->mei_state !=3D MEI_DISABLED &&
 		    dev->mei_state !=3D MEI_POWER_DOWN)
diff --git a/drivers/staging/mei/interrupt.c b/drivers/staging/mei/interrup=
t.c
index 882d106..42b7c9a 100644
--- a/drivers/staging/mei/interrupt.c
+++ b/drivers/staging/mei/interrupt.c
@@ -770,6 +770,7 @@ static void mei_irq_thread_read_bus_message(struct mei_=
device *dev,
 					 */
 					bitmap_set(dev->host_clients_map, 0, 3);
 					dev->mei_state =3D MEI_ENABLED;
+					dev->reset_count =3D 0;
=20
 					/* if wd initialization fails, initialization the AMTHI client,
 					 * otherwise the AMTHI client will be initialized after the WD client=
 connect response
@@ -1527,7 +1528,8 @@ void mei_timer(struct work_struct *work)
 		}
 	}
 out:
-	 schedule_delayed_work(&dev->timer_work, 2 * HZ);
+	 if (dev->mei_state !=3D MEI_DISABLED)
+		schedule_delayed_work(&dev->timer_work, 2 * HZ);
 	 mutex_unlock(&dev->device_lock);
 }
=20
diff --git a/drivers/staging/mei/main.c b/drivers/staging/mei/main.c
index eb05c36..44ed7a8 100644
--- a/drivers/staging/mei/main.c
+++ b/drivers/staging/mei/main.c
@@ -106,6 +106,27 @@ MODULE_DEVICE_TABLE(pci, mei_pci_tbl);
 static DEFINE_MUTEX(mei_mutex);
=20
 /**
+ * mei_quirk_probe - probe for devices that doesn't valid ME interface
+ * @pdev: PCI device structure
+ * @ent: entry into pci_device_table
+ *
+ * returns true if ME Interface is valid, false otherwise
+ */
+static bool __devinit mei_quirk_probe(struct pci_dev *pdev,
+				const struct pci_device_id *ent)
+{
+	u32 reg;
+	if (ent->device =3D=3D MEI_DEV_ID_PBG_1) {
+		pci_read_config_dword(pdev, 0x48, &reg);
+		/* make sure that bit 9 is up and bit 10 is down */
+		if ((reg & 0x600) =3D=3D 0x200) {
+			dev_info(&pdev->dev, "Device doesn't have valid ME Interface\n");
+			return false;
+		}
+	}
+	return true;
+}
+/**
  * mei_probe - Device Initialization Routine
  *
  * @pdev: PCI device structure
@@ -120,6 +141,12 @@ static int __devinit mei_probe(struct pci_dev *pdev,
 	int err;
=20
 	mutex_lock(&mei_mutex);
+
+	if (!mei_quirk_probe(pdev, ent)) {
+		err =3D -ENODEV;
+		goto end;
+	}
+
 	if (mei_device) {
 		err =3D -EEXIST;
 		goto end;
diff --git a/drivers/staging/mei/mei_dev.h b/drivers/staging/mei/mei_dev.h
index af4b1af..264bf23 100644
--- a/drivers/staging/mei/mei_dev.h
+++ b/drivers/staging/mei/mei_dev.h
@@ -64,6 +64,11 @@ extern const uuid_le mei_wd_guid;
 extern const u8 mei_wd_state_independence_msg[3][4];
=20
 /*
+ * maximum number of consecutive resets
+ */
+#define MEI_MAX_CONSEC_RESET  3
+
+/*
  * Number of File descriptors/handles
  * that can be opened to the driver.
  *
@@ -178,7 +183,11 @@ struct mei_io_list {
 	int status;
 };
=20
-/* MEI private device struct */
+/**
+ * mei_device - MEI private device struct
+ *
+ * @reset_count - limits the number of consecutive resets
+ */
 struct mei_device {
 	struct pci_dev *pdev;	/* pointer to pci device struct */
 	/*
@@ -225,6 +234,7 @@ struct mei_device {
 	/*
 	 * mei device  states
 	 */
+	unsigned long reset_count;
 	enum mei_states mei_state;
 	enum mei_init_clients_states init_clients_state;
 	u16 init_clients_timer;
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target=
_core_transport.c
index 898c1de..be1218f 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -3147,8 +3147,7 @@ static void transport_complete_qf(struct se_cmd *cmd)
=20
 	if (cmd->se_cmd_flags & SCF_TRANSPORT_TASK_SENSE) {
 		ret =3D cmd->se_tfo->queue_status(cmd);
-		if (ret)
-			goto out;
+		goto out;
 	}
=20
 	switch (cmd->data_direction) {
diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_c=
ore.c
index d7162a2..145817c 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -360,7 +360,7 @@ uart_get_baud_rate(struct uart_port *port, struct kterm=
ios *termios,
 		 * The spd_hi, spd_vhi, spd_shi, spd_warp kludge...
 		 * Die! Die! Die!
 		 */
-		if (baud =3D=3D 38400)
+		if (try =3D=3D 0 && baud =3D=3D 38400)
 			baud =3D altbaud;
=20
 		/*
diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index 446df6b..613f06a 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -1594,6 +1594,7 @@ int tty_release(struct inode *inode, struct file *fil=
p)
 	int	devpts;
 	int	idx;
 	char	buf[64];
+	long	timeout =3D 0;
=20
 	if (tty_paranoia_check(tty, inode, "tty_release_dev"))
 		return 0;
@@ -1721,7 +1722,11 @@ int tty_release(struct inode *inode, struct file *fi=
lp)
 				    "active!\n", tty_name(tty, buf));
 		tty_unlock();
 		mutex_unlock(&tty_mutex);
-		schedule();
+		schedule_timeout_killable(timeout);
+		if (timeout < 120 * HZ)
+			timeout =3D 2 * timeout + 1;
+		else
+			timeout =3D MAX_SCHEDULE_TIMEOUT;
 	}
=20
 	/*
diff --git a/drivers/tty/vt/consolemap.c b/drivers/tty/vt/consolemap.c
index f343808..fb95acc 100644
--- a/drivers/tty/vt/consolemap.c
+++ b/drivers/tty/vt/consolemap.c
@@ -518,6 +518,8 @@ int con_set_unimap(struct vc_data *vc, ushort ct, struc=
t unipair __user *list)
=20
 	/* Save original vc_unipagdir_loc in case we allocate a new one */
 	p =3D (struct uni_pagedir *)*vc->vc_uni_pagedir_loc;
+	if (!p)
+		return -EINVAL;
 	if (p->readonly) return -EIO;
 =09
 	if (!ct) return 0;
diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index 29e76be..6647081 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -819,11 +819,12 @@ static void acm_tty_set_termios(struct tty_struct *tt=
y,
 	/* FIXME: Needs to clear unsupported bits in the termios */
 	acm->clocal =3D ((termios->c_cflag & CLOCAL) !=3D 0);
=20
-	if (!newline.dwDTERate) {
+	if (C_BAUD(tty) =3D=3D B0) {
 		newline.dwDTERate =3D acm->line.dwDTERate;
 		newctrl &=3D ~ACM_CTRL_DTR;
-	} else
+	} else if (termios_old && (termios_old->c_cflag & CBAUD) =3D=3D B0) {
 		newctrl |=3D  ACM_CTRL_DTR;
+	}
=20
 	if (newctrl !=3D acm->ctrlout)
 		acm_set_control(acm, acm->ctrlout =3D newctrl);
@@ -1509,6 +1510,7 @@ static const struct usb_device_id acm_ids[] =3D {
 	{ USB_DEVICE(0x0572, 0x1328), /* Shiro / Aztech USB MODEM UM-3100 */
 	.driver_info =3D NO_UNION_NORMAL, /* has no union descriptor */
 	},
+	{ USB_DEVICE(0x2184, 0x001c) },	/* GW Instek AFG-2225 */
 	{ USB_DEVICE(0x22b8, 0x6425), /* Motorola MOTOMAGX phones */
 	},
 	/* Motorola H24 HSPA module: */
diff --git a/drivers/usb/core/hcd.c b/drivers/usb/core/hcd.c
index 032e5a6..c0ee52a 100644
--- a/drivers/usb/core/hcd.c
+++ b/drivers/usb/core/hcd.c
@@ -1896,6 +1896,8 @@ int usb_alloc_streams(struct usb_interface *interface=
,
 		return -EINVAL;
 	if (dev->speed !=3D USB_SPEED_SUPER)
 		return -EINVAL;
+	if (dev->state < USB_STATE_CONFIGURED)
+		return -ENODEV;
=20
 	/* Streams only apply to bulk endpoints. */
 	for (i =3D 0; i < num_eps; i++)
diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index 10aec1a..18286ce 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -1633,8 +1633,10 @@ void usb_set_device_state(struct usb_device *udev,
 					|| new_state =3D=3D USB_STATE_SUSPENDED)
 				;	/* No change to wakeup settings */
 			else if (new_state =3D=3D USB_STATE_CONFIGURED)
-				wakeup =3D udev->actconfig->desc.bmAttributes
-					 & USB_CONFIG_ATT_WAKEUP;
+				wakeup =3D (udev->quirks &
+					USB_QUIRK_IGNORE_REMOTE_WAKEUP) ? 0 :
+					udev->actconfig->desc.bmAttributes &
+					USB_CONFIG_ATT_WAKEUP;
 			else
 				wakeup =3D 0;
 		}
diff --git a/drivers/usb/core/quirks.c b/drivers/usb/core/quirks.c
index 3677d22..3dbb18c 100644
--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -43,6 +43,9 @@ static const struct usb_device_id usb_quirk_list[] =3D {
 	/* Creative SB Audigy 2 NX */
 	{ USB_DEVICE(0x041e, 0x3020), .driver_info =3D USB_QUIRK_RESET_RESUME },
=20
+	/* Microsoft Wireless Laser Mouse 6000 Receiver */
+	{ USB_DEVICE(0x045e, 0x00e1), .driver_info =3D USB_QUIRK_RESET_RESUME },
+
 	/* Microsoft LifeCam-VX700 v2.0 */
 	{ USB_DEVICE(0x045e, 0x0770), .driver_info =3D USB_QUIRK_RESET_RESUME },
=20
@@ -154,6 +157,13 @@ static const struct usb_device_id usb_quirk_list[] =3D=
 {
 	/* INTEL VALUE SSD */
 	{ USB_DEVICE(0x8086, 0xf1a5), .driver_info =3D USB_QUIRK_RESET_RESUME },
=20
+	/* USB3503 */
+	{ USB_DEVICE(0x0424, 0x3503), .driver_info =3D USB_QUIRK_RESET_RESUME },
+
+	/* ASUS Base Station(T100) */
+	{ USB_DEVICE(0x0b05, 0x17e0), .driver_info =3D
+			USB_QUIRK_IGNORE_REMOTE_WAKEUP },
+
 	{ }  /* terminating entry must be last */
 };
=20
diff --git a/drivers/usb/gadget/udc-core.c b/drivers/usb/gadget/udc-core.c
index d433fdf..087d402 100644
--- a/drivers/usb/gadget/udc-core.c
+++ b/drivers/usb/gadget/udc-core.c
@@ -358,6 +358,11 @@ static ssize_t usb_udc_softconn_store(struct device *d=
ev,
 {
 	struct usb_udc		*udc =3D container_of(dev, struct usb_udc, dev);
=20
+	if (!udc->driver) {
+		dev_err(dev, "soft-connect without a gadget driver\n");
+		return -EOPNOTSUPP;
+	}
+
 	if (sysfs_streq(buf, "connect")) {
 		if (udc_is_newstyle(udc))
 			usb_gadget_udc_start(udc->gadget, udc->driver);
diff --git a/drivers/usb/host/xhci-hub.c b/drivers/usb/host/xhci-hub.c
index a3b569f..a8bbeed 100644
--- a/drivers/usb/host/xhci-hub.c
+++ b/drivers/usb/host/xhci-hub.c
@@ -21,7 +21,6 @@
  */
=20
 #include <linux/gfp.h>
-#include <linux/device.h>
 #include <asm/unaligned.h>
=20
 #include "xhci.h"
@@ -996,9 +995,7 @@ int xhci_bus_suspend(struct usb_hcd *hcd)
 			t2 |=3D PORT_LINK_STROBE | XDEV_U3;
 			set_bit(port_index, &bus_state->bus_suspended);
 		}
-		if (hcd->self.root_hub->do_remote_wakeup
-				&& device_may_wakeup(hcd->self.controller)) {
-
+		if (hcd->self.root_hub->do_remote_wakeup) {
 			if (t1 & PORT_CONNECT) {
 				t2 |=3D PORT_WKOC_E | PORT_WKDISC_E;
 				t2 &=3D ~PORT_WKCONN_E;
diff --git a/drivers/usb/host/xhci-pci.c b/drivers/usb/host/xhci-pci.c
index e9ce957..a464dbc 100644
--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -118,20 +118,6 @@ static void xhci_pci_quirks(struct device *dev, struct=
 xhci_hcd *xhci)
 		xhci->quirks |=3D XHCI_SPURIOUS_REBOOT;
 		xhci->quirks |=3D XHCI_AVOID_BEI;
 	}
-	if (pdev->vendor =3D=3D PCI_VENDOR_ID_INTEL &&
-	    (pdev->device =3D=3D PCI_DEVICE_ID_INTEL_LYNXPOINT_XHCI ||
-	     pdev->device =3D=3D PCI_DEVICE_ID_INTEL_LYNXPOINT_LP_XHCI)) {
-		/* Workaround for occasional spurious wakeups from S5 (or
-		 * any other sleep) on Haswell machines with LPT and LPT-LP
-		 * with the new Intel BIOS
-		 */
-		/* Limit the quirk to only known vendors, as this triggers
-		 * yet another BIOS bug on some other machines
-		 * https://bugzilla.kernel.org/show_bug.cgi?id=3D66171
-		 */
-		if (pdev->subsystem_vendor =3D=3D PCI_VENDOR_ID_HP)
-			xhci->quirks |=3D XHCI_SPURIOUS_WAKEUP;
-	}
 	if (pdev->vendor =3D=3D PCI_VENDOR_ID_ETRON &&
 			pdev->device =3D=3D PCI_DEVICE_ID_ASROCK_P67) {
 		xhci->quirks |=3D XHCI_RESET_ON_RESUME;
@@ -249,7 +235,7 @@ static int xhci_pci_suspend(struct usb_hcd *hcd, bool d=
o_wakeup)
 			xhci->shared_hcd->state !=3D HC_STATE_SUSPENDED)
 		return -EINVAL;
=20
-	retval =3D xhci_suspend(xhci);
+	retval =3D xhci_suspend(xhci, do_wakeup);
=20
 	return retval;
 }
diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index 4b6abb6..3755274 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -1164,9 +1164,8 @@ static void handle_reset_ep_completion(struct xhci_hc=
d *xhci,
 				false);
 		xhci_ring_cmd_db(xhci);
 	} else {
-		/* Clear our internal halted state and restart the ring(s) */
+		/* Clear our internal halted state */
 		xhci->devs[slot_id]->eps[ep_index].ep_state &=3D ~EP_HALTED;
-		ring_doorbell_for_active_rings(xhci, slot_id, ep_index);
 	}
 }
=20
@@ -1845,22 +1844,13 @@ static int finish_td(struct xhci_hcd *xhci, struct =
xhci_td *td,
 		ep->stopped_td =3D td;
 		return 0;
 	} else {
-		if (trb_comp_code =3D=3D COMP_STALL) {
-			/* The transfer is completed from the driver's
-			 * perspective, but we need to issue a set dequeue
-			 * command for this stalled endpoint to move the dequeue
-			 * pointer past the TD.  We can't do that here because
-			 * the halt condition must be cleared first.  Let the
-			 * USB class driver clear the stall later.
-			 */
-			ep->stopped_td =3D td;
-			ep->stopped_stream =3D ep_ring->stream_id;
-		} else if (xhci_requires_manual_halt_cleanup(xhci,
-					ep_ctx, trb_comp_code)) {
-			/* Other types of errors halt the endpoint, but the
-			 * class driver doesn't call usb_reset_endpoint() unless
-			 * the error is -EPIPE.  Clear the halted status in the
-			 * xHCI hardware manually.
+		if (trb_comp_code =3D=3D COMP_STALL ||
+		    xhci_requires_manual_halt_cleanup(xhci, ep_ctx,
+						      trb_comp_code)) {
+			/* Issue a reset endpoint command to clear the host side
+			 * halt, followed by a set dequeue command to move the
+			 * dequeue pointer past the TD.
+			 * The class driver clears the device side halt later.
 			 */
 			xhci_cleanup_halted_endpoint(xhci,
 					slot_id, ep_index, ep_ring->stream_id,
@@ -1981,9 +1971,7 @@ static int process_ctrl_td(struct xhci_hcd *xhci, str=
uct xhci_td *td,
 		else
 			td->urb->actual_length =3D 0;
=20
-		xhci_cleanup_halted_endpoint(xhci,
-			slot_id, ep_index, 0, td, event_trb);
-		return finish_td(xhci, td, event_trb, event, ep, status, true);
+		return finish_td(xhci, td, event_trb, event, ep, status, false);
 	}
 	/*
 	 * Did we transfer any data, despite the errors that might have
@@ -2515,17 +2503,8 @@ cleanup:
 		if (ret) {
 			urb =3D td->urb;
 			urb_priv =3D urb->hcpriv;
-			/* Leave the TD around for the reset endpoint function
-			 * to use(but only if it's not a control endpoint,
-			 * since we already queued the Set TR dequeue pointer
-			 * command for stalled control endpoints).
-			 */
-			if (usb_endpoint_xfer_control(&urb->ep->desc) ||
-				(trb_comp_code !=3D COMP_STALL &&
-					trb_comp_code !=3D COMP_BABBLE))
-				xhci_urb_free_priv(xhci, urb_priv);
-			else
-				kfree(urb_priv);
+
+			xhci_urb_free_priv(xhci, urb_priv);
=20
 			usb_hcd_unlink_urb_from_ep(bus_to_hcd(urb->dev->bus), urb);
 			if ((urb->actual_length !=3D urb->transfer_buffer_length &&
diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index 4cc1804..5c535a8 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -33,6 +33,8 @@
 #define DRIVER_AUTHOR "Sarah Sharp"
 #define DRIVER_DESC "'eXtensible' Host Controller (xHC) Driver"
=20
+#define	PORT_WAKE_BITS	(PORT_WKOC_E | PORT_WKDISC_E | PORT_WKCONN_E)
+
 /* Some 0.95 hardware can't handle the chain bit on a Link TRB being clear=
ed */
 static int link_quirk;
 module_param(link_quirk, int, S_IRUGO | S_IWUSR);
@@ -867,19 +869,57 @@ static void xhci_clear_command_ring(struct xhci_hcd *=
xhci)
 	xhci_set_cmd_ring_deq(xhci);
 }
=20
+static void xhci_disable_port_wake_on_bits(struct xhci_hcd *xhci)
+{
+	int port_index;
+	__le32 __iomem **port_array;
+	unsigned long flags;
+	u32 t1, t2;
+
+	spin_lock_irqsave(&xhci->lock, flags);
+
+	/* disble usb3 ports Wake bits*/
+	port_index =3D xhci->num_usb3_ports;
+	port_array =3D xhci->usb3_ports;
+	while (port_index--) {
+		t1 =3D readl(port_array[port_index]);
+		t1 =3D xhci_port_state_to_neutral(t1);
+		t2 =3D t1 & ~PORT_WAKE_BITS;
+		if (t1 !=3D t2)
+			writel(t2, port_array[port_index]);
+	}
+
+	/* disble usb2 ports Wake bits*/
+	port_index =3D xhci->num_usb2_ports;
+	port_array =3D xhci->usb2_ports;
+	while (port_index--) {
+		t1 =3D readl(port_array[port_index]);
+		t1 =3D xhci_port_state_to_neutral(t1);
+		t2 =3D t1 & ~PORT_WAKE_BITS;
+		if (t1 !=3D t2)
+			writel(t2, port_array[port_index]);
+	}
+
+	spin_unlock_irqrestore(&xhci->lock, flags);
+}
+
 /*
  * Stop HC (not bus-specific)
  *
  * This is called when the machine transition into S3/S4 mode.
  *
  */
-int xhci_suspend(struct xhci_hcd *xhci)
+int xhci_suspend(struct xhci_hcd *xhci, bool do_wakeup)
 {
 	int			rc =3D 0;
 	unsigned int		delay =3D XHCI_MAX_HALT_USEC;
 	struct usb_hcd		*hcd =3D xhci_to_hcd(xhci);
 	u32			command;
=20
+	/* Clear root port wake on bits if wakeup not allowed. */
+	if (!do_wakeup)
+		xhci_disable_port_wake_on_bits(xhci);
+
 	/* Don't poll the roothubs on bus suspend. */
 	xhci_dbg(xhci, "%s: stopping port polling.\n", __func__);
 	clear_bit(HCD_FLAG_POLL_RH, &hcd->flags);
@@ -2842,60 +2882,33 @@ void xhci_cleanup_stalled_ring(struct xhci_hcd *xhc=
i,
 	}
 }
=20
-/* Deal with stalled endpoints.  The core should have sent the control mes=
sage
- * to clear the halt condition.  However, we need to make the xHCI hardwar=
e
- * reset its sequence number, since a device will expect a sequence number=
 of
- * zero after the halt condition is cleared.
+/* Called when clearing halted device. The core should have sent the contr=
ol
+ * message to clear the device halt condition. The host side of the halt s=
hould
+ * already be cleared with a reset endpoint command issued when the STALL =
tx
+ * event was received.
+ *
  * Context: in_interrupt
  */
+
 void xhci_endpoint_reset(struct usb_hcd *hcd,
 		struct usb_host_endpoint *ep)
 {
 	struct xhci_hcd *xhci;
-	struct usb_device *udev;
-	unsigned int ep_index;
-	unsigned long flags;
-	int ret;
-	struct xhci_virt_ep *virt_ep;
=20
 	xhci =3D hcd_to_xhci(hcd);
-	udev =3D (struct usb_device *) ep->hcpriv;
-	/* Called with a root hub endpoint (or an endpoint that wasn't added
-	 * with xhci_add_endpoint()
-	 */
-	if (!ep->hcpriv)
-		return;
-	ep_index =3D xhci_get_endpoint_index(&ep->desc);
-	virt_ep =3D &xhci->devs[udev->slot_id]->eps[ep_index];
-	if (!virt_ep->stopped_td) {
-		xhci_dbg(xhci, "Endpoint 0x%x not halted, refusing to reset.\n",
-				ep->desc.bEndpointAddress);
-		return;
-	}
-	if (usb_endpoint_xfer_control(&ep->desc)) {
-		xhci_dbg(xhci, "Control endpoint stall already handled.\n");
-		return;
-	}
=20
-	xhci_dbg(xhci, "Queueing reset endpoint command\n");
-	spin_lock_irqsave(&xhci->lock, flags);
-	ret =3D xhci_queue_reset_ep(xhci, udev->slot_id, ep_index);
 	/*
-	 * Can't change the ring dequeue pointer until it's transitioned to the
-	 * stopped state, which is only upon a successful reset endpoint
-	 * command.  Better hope that last command worked!
+	 * We might need to implement the config ep cmd in xhci 4.8.1 note:
+	 * The Reset Endpoint Command may only be issued to endpoints in the
+	 * Halted state. If software wishes reset the Data Toggle or Sequence
+	 * Number of an endpoint that isn't in the Halted state, then software
+	 * may issue a Configure Endpoint Command with the Drop and Add bits set
+	 * for the target endpoint. that is in the Stopped state.
 	 */
-	if (!ret) {
-		xhci_cleanup_stalled_ring(xhci, udev, ep_index);
-		kfree(virt_ep->stopped_td);
-		xhci_ring_cmd_db(xhci);
-	}
-	virt_ep->stopped_td =3D NULL;
-	virt_ep->stopped_stream =3D 0;
-	spin_unlock_irqrestore(&xhci->lock, flags);
=20
-	if (ret)
-		xhci_warn(xhci, "FIXME allocate a new ring segment\n");
+	/* For now just print debug to follow the situation */
+	xhci_dbg(xhci, "Endpoint 0x%x ep reset callback called\n",
+		 ep->desc.bEndpointAddress);
 }
=20
 static int xhci_check_streams_endpoint(struct xhci_hcd *xhci,
diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
index 1bc91c8..2090a03 100644
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -1698,7 +1698,7 @@ void xhci_shutdown(struct usb_hcd *hcd);
 int xhci_gen_setup(struct usb_hcd *hcd, xhci_get_quirks_t get_quirks);
=20
 #ifdef	CONFIG_PM
-int xhci_suspend(struct xhci_hcd *xhci);
+int xhci_suspend(struct xhci_hcd *xhci, bool do_wakeup);
 int xhci_resume(struct xhci_hcd *xhci, bool hibernated);
 #else
 #define	xhci_suspend	NULL
diff --git a/drivers/usb/serial/cp210x.c b/drivers/usb/serial/cp210x.c
index 3de63f5..da92d2d 100644
--- a/drivers/usb/serial/cp210x.c
+++ b/drivers/usb/serial/cp210x.c
@@ -126,8 +126,10 @@ static const struct usb_device_id id_table[] =3D {
 	{ USB_DEVICE(0x10C4, 0x85F8) }, /* Virtenio Preon32 */
 	{ USB_DEVICE(0x10C4, 0x8664) }, /* AC-Services CAN-IF */
 	{ USB_DEVICE(0x10C4, 0x8665) }, /* AC-Services OBD-IF */
+	{ USB_DEVICE(0x10C4, 0x8875) }, /* CEL MeshConnect USB Stick */
 	{ USB_DEVICE(0x10C4, 0x88A4) }, /* MMB Networks ZigBee USB Device */
 	{ USB_DEVICE(0x10C4, 0x88A5) }, /* Planet Innovation Ingeni ZigBee USB De=
vice */
+	{ USB_DEVICE(0x10C4, 0x8946) }, /* Ketra N1 Wireless Interface */
 	{ USB_DEVICE(0x10C4, 0xEA60) }, /* Silicon Labs factory default */
 	{ USB_DEVICE(0x10C4, 0xEA61) }, /* Silicon Labs factory default */
 	{ USB_DEVICE(0x10C4, 0xEA70) }, /* Silicon Labs factory default */
@@ -160,7 +162,9 @@ static const struct usb_device_id id_table[] =3D {
 	{ USB_DEVICE(0x18EF, 0xE00F) }, /* ELV USB-I2C-Interface */
 	{ USB_DEVICE(0x1ADB, 0x0001) }, /* Schweitzer Engineering C662 Cable */
 	{ USB_DEVICE(0x1B1C, 0x1C00) }, /* Corsair USB Dongle */
+	{ USB_DEVICE(0x1BA4, 0x0002) },	/* Silicon Labs 358x factory default */
 	{ USB_DEVICE(0x1BE3, 0x07A6) }, /* WAGO 750-923 USB Service Cable */
+	{ USB_DEVICE(0x1D6F, 0x0010) }, /* Seluxit ApS RF Dongle */
 	{ USB_DEVICE(0x1E29, 0x0102) }, /* Festo CPX-USB */
 	{ USB_DEVICE(0x1E29, 0x0501) }, /* Festo CMSP */
 	{ USB_DEVICE(0x1FB9, 0x0100) }, /* Lake Shore Model 121 Current Source */
diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index 8fe5c13..f6a6205 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -156,6 +156,7 @@ static struct ftdi_sio_quirk ftdi_8u2232c_quirk =3D {
  * /sys/bus/usb/ftdi_sio/new_id, then send patch/report!
  */
 static struct usb_device_id id_table_combined [] =3D {
+	{ USB_DEVICE(FTDI_VID, FTDI_BRICK_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_ZEITCONTROL_TAGTRACE_MIFARE_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_CTI_MINI_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_CTI_NANO_PID) },
@@ -493,6 +494,39 @@ static struct usb_device_id id_table_combined [] =3D {
 	{ USB_DEVICE(MTXORB_VID, MTXORB_FTDI_RANGE_01FD_PID) },
 	{ USB_DEVICE(MTXORB_VID, MTXORB_FTDI_RANGE_01FE_PID) },
 	{ USB_DEVICE(MTXORB_VID, MTXORB_FTDI_RANGE_01FF_PID) },
+	{ USB_DEVICE(MTXORB_VID, MTXORB_FTDI_RANGE_4701_PID) },
+	{ USB_DEVICE(MTXORB_VID, MTXORB_FTDI_RANGE_9300_PID) },
+	{ USB_DEVICE(MTXORB_VID, MTXORB_FTDI_RANGE_9301_PID) },
+	{ USB_DEVICE(MTXORB_VID, MTXORB_FTDI_RANGE_9302_PID) },
+	{ USB_DEVICE(MTXORB_VID, MTXORB_FTDI_RANGE_9303_PID) },
+	{ USB_DEVICE(MTXORB_VID, MTXORB_FTDI_RANGE_9304_PID) },
+	{ USB_DEVICE(MTXORB_VID, MTXORB_FTDI_RANGE_9305_PID) },
+	{ USB_DEVICE(MTXORB_VID, MTXORB_FTDI_RANGE_9306_PID) },
+	{ USB_DEVICE(MTXORB_VID, MTXORB_FTDI_RANGE_9307_PID) },
+	{ USB_DEVICE(MTXORB_VID, MTXORB_FTDI_RANGE_9308_PID) },
+	{ USB_DEVICE(MTXORB_VID, MTXORB_FTDI_RANGE_9309_PID) },
+	{ USB_DEVICE(MTXORB_VID, MTXORB_FTDI_RANGE_930A_PID) },
+	{ USB_DEVICE(MTXORB_VID, MTXORB_FTDI_RANGE_930B_PID) },
+	{ USB_DEVICE(MTXORB_VID, MTXORB_FTDI_RANGE_930C_PID) },
+	{ USB_DEVICE(MTXORB_VID, MTXORB_FTDI_RANGE_930D_PID) },
+	{ USB_DEVICE(MTXORB_VID, MTXORB_FTDI_RANGE_930E_PID) },
+	{ USB_DEVICE(MTXORB_VID, MTXORB_FTDI_RANGE_930F_PID) },
+	{ USB_DEVICE(MTXORB_VID, MTXORB_FTDI_RANGE_9310_PID) },
+	{ USB_DEVICE(MTXORB_VID, MTXORB_FTDI_RANGE_9311_PID) },
+	{ USB_DEVICE(MTXORB_VID, MTXORB_FTDI_RANGE_9312_PID) },
+	{ USB_DEVICE(MTXORB_VID, MTXORB_FTDI_RANGE_9313_PID) },
+	{ USB_DEVICE(MTXORB_VID, MTXORB_FTDI_RANGE_9314_PID) },
+	{ USB_DEVICE(MTXORB_VID, MTXORB_FTDI_RANGE_9315_PID) },
+	{ USB_DEVICE(MTXORB_VID, MTXORB_FTDI_RANGE_9316_PID) },
+	{ USB_DEVICE(MTXORB_VID, MTXORB_FTDI_RANGE_9317_PID) },
+	{ USB_DEVICE(MTXORB_VID, MTXORB_FTDI_RANGE_9318_PID) },
+	{ USB_DEVICE(MTXORB_VID, MTXORB_FTDI_RANGE_9319_PID) },
+	{ USB_DEVICE(MTXORB_VID, MTXORB_FTDI_RANGE_931A_PID) },
+	{ USB_DEVICE(MTXORB_VID, MTXORB_FTDI_RANGE_931B_PID) },
+	{ USB_DEVICE(MTXORB_VID, MTXORB_FTDI_RANGE_931C_PID) },
+	{ USB_DEVICE(MTXORB_VID, MTXORB_FTDI_RANGE_931D_PID) },
+	{ USB_DEVICE(MTXORB_VID, MTXORB_FTDI_RANGE_931E_PID) },
+	{ USB_DEVICE(MTXORB_VID, MTXORB_FTDI_RANGE_931F_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_PERLE_ULTRAPORT_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_PIEGROUP_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_TNC_X_PID) },
@@ -685,6 +719,8 @@ static struct usb_device_id id_table_combined [] =3D {
 	{ USB_DEVICE(FTDI_VID, XSENS_CONVERTER_5_PID) },
 	{ USB_DEVICE(FTDI_VID, XSENS_CONVERTER_6_PID) },
 	{ USB_DEVICE(FTDI_VID, XSENS_CONVERTER_7_PID) },
+	{ USB_DEVICE(XSENS_VID, XSENS_AWINDA_DONGLE_PID) },
+	{ USB_DEVICE(XSENS_VID, XSENS_AWINDA_STATION_PID) },
 	{ USB_DEVICE(XSENS_VID, XSENS_CONVERTER_PID) },
 	{ USB_DEVICE(XSENS_VID, XSENS_MTW_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_OMNI1509) },
diff --git a/drivers/usb/serial/ftdi_sio_ids.h b/drivers/usb/serial/ftdi_si=
o_ids.h
index bd509de..5735fb7 100644
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -30,6 +30,12 @@
=20
 /*** third-party PIDs (using FTDI_VID) ***/
=20
+/*
+ * Certain versions of the official Windows FTDI driver reprogrammed
+ * counterfeit FTDI devices to PID 0. Support these devices anyway.
+ */
+#define FTDI_BRICK_PID		0x0000
+
 #define FTDI_LUMEL_PD12_PID	0x6002
=20
 /*
@@ -143,8 +149,12 @@
  * Xsens Technologies BV products (http://www.xsens.com).
  */
 #define XSENS_VID		0x2639
-#define XSENS_CONVERTER_PID	0xD00D	/* Xsens USB-serial converter */
+#define XSENS_AWINDA_STATION_PID 0x0101
+#define XSENS_AWINDA_DONGLE_PID 0x0102
 #define XSENS_MTW_PID		0x0200	/* Xsens MTw */
+#define XSENS_CONVERTER_PID	0xD00D	/* Xsens USB-serial converter */
+
+/* Xsens devices using FTDI VID */
 #define XSENS_CONVERTER_0_PID	0xD388	/* Xsens USB converter */
 #define XSENS_CONVERTER_1_PID	0xD389	/* Xsens Wireless Receiver */
 #define XSENS_CONVERTER_2_PID	0xD38A
@@ -910,8 +920,8 @@
 #define BAYER_CONTOUR_CABLE_PID        0x6001
=20
 /*
- * The following are the values for the Matrix Orbital FTDI Range
- * Anything in this range will use an FT232RL.
+ * Matrix Orbital Intelligent USB displays.
+ * http://www.matrixorbital.com
  */
 #define MTXORB_VID			0x1B3D
 #define MTXORB_FTDI_RANGE_0100_PID	0x0100
@@ -1170,8 +1180,39 @@
 #define MTXORB_FTDI_RANGE_01FD_PID	0x01FD
 #define MTXORB_FTDI_RANGE_01FE_PID	0x01FE
 #define MTXORB_FTDI_RANGE_01FF_PID	0x01FF
-
-
+#define MTXORB_FTDI_RANGE_4701_PID	0x4701
+#define MTXORB_FTDI_RANGE_9300_PID	0x9300
+#define MTXORB_FTDI_RANGE_9301_PID	0x9301
+#define MTXORB_FTDI_RANGE_9302_PID	0x9302
+#define MTXORB_FTDI_RANGE_9303_PID	0x9303
+#define MTXORB_FTDI_RANGE_9304_PID	0x9304
+#define MTXORB_FTDI_RANGE_9305_PID	0x9305
+#define MTXORB_FTDI_RANGE_9306_PID	0x9306
+#define MTXORB_FTDI_RANGE_9307_PID	0x9307
+#define MTXORB_FTDI_RANGE_9308_PID	0x9308
+#define MTXORB_FTDI_RANGE_9309_PID	0x9309
+#define MTXORB_FTDI_RANGE_930A_PID	0x930A
+#define MTXORB_FTDI_RANGE_930B_PID	0x930B
+#define MTXORB_FTDI_RANGE_930C_PID	0x930C
+#define MTXORB_FTDI_RANGE_930D_PID	0x930D
+#define MTXORB_FTDI_RANGE_930E_PID	0x930E
+#define MTXORB_FTDI_RANGE_930F_PID	0x930F
+#define MTXORB_FTDI_RANGE_9310_PID	0x9310
+#define MTXORB_FTDI_RANGE_9311_PID	0x9311
+#define MTXORB_FTDI_RANGE_9312_PID	0x9312
+#define MTXORB_FTDI_RANGE_9313_PID	0x9313
+#define MTXORB_FTDI_RANGE_9314_PID	0x9314
+#define MTXORB_FTDI_RANGE_9315_PID	0x9315
+#define MTXORB_FTDI_RANGE_9316_PID	0x9316
+#define MTXORB_FTDI_RANGE_9317_PID	0x9317
+#define MTXORB_FTDI_RANGE_9318_PID	0x9318
+#define MTXORB_FTDI_RANGE_9319_PID	0x9319
+#define MTXORB_FTDI_RANGE_931A_PID	0x931A
+#define MTXORB_FTDI_RANGE_931B_PID	0x931B
+#define MTXORB_FTDI_RANGE_931C_PID	0x931C
+#define MTXORB_FTDI_RANGE_931D_PID	0x931D
+#define MTXORB_FTDI_RANGE_931E_PID	0x931E
+#define MTXORB_FTDI_RANGE_931F_PID	0x931F
=20
 /*
  * The Mobility Lab (TML)
diff --git a/drivers/usb/serial/keyspan.c b/drivers/usb/serial/keyspan.c
index b668069..e9b39e3 100644
--- a/drivers/usb/serial/keyspan.c
+++ b/drivers/usb/serial/keyspan.c
@@ -437,24 +437,28 @@ static void	usa26_indat_callback(struct urb *urb)
 		if ((data[0] & 0x80) =3D=3D 0) {
 			/* no errors on individual bytes, only
 			   possible overrun err */
-			if (data[0] & RXERROR_OVERRUN)
-				err =3D TTY_OVERRUN;
-			else
-				err =3D 0;
+			if (data[0] & RXERROR_OVERRUN) {
+				tty_insert_flip_char(tty, 0, TTY_OVERRUN);
+			}
 			for (i =3D 1; i < urb->actual_length ; ++i)
-				tty_insert_flip_char(tty, data[i], err);
+				tty_insert_flip_char(tty, data[i], TTY_NORMAL);
 		} else {
 			/* some bytes had errors, every byte has status */
 			dbg("%s - RX error!!!!", __func__);
 			for (i =3D 0; i + 1 < urb->actual_length; i +=3D 2) {
-				int stat =3D data[i], flag =3D 0;
-				if (stat & RXERROR_OVERRUN)
-					flag |=3D TTY_OVERRUN;
-				if (stat & RXERROR_FRAMING)
-					flag |=3D TTY_FRAME;
-				if (stat & RXERROR_PARITY)
-					flag |=3D TTY_PARITY;
+				int stat =3D data[i];
+				int flag =3D TTY_NORMAL;
+
+				if (stat & RXERROR_OVERRUN) {
+					tty_insert_flip_char(tty, 0,
+								TTY_OVERRUN);
+				}
 				/* XXX should handle break (0x10) */
+				if (stat & RXERROR_PARITY)
+					flag =3D TTY_PARITY;
+				else if (stat & RXERROR_FRAMING)
+					flag =3D TTY_FRAME;
+
 				tty_insert_flip_char(tty, data[i+1], flag);
 			}
 		}
@@ -832,14 +836,19 @@ static void	usa49_indat_callback(struct urb *urb)
 		} else {
 			/* some bytes had errors, every byte has status */
 			for (i =3D 0; i + 1 < urb->actual_length; i +=3D 2) {
-				int stat =3D data[i], flag =3D 0;
-				if (stat & RXERROR_OVERRUN)
-					flag |=3D TTY_OVERRUN;
-				if (stat & RXERROR_FRAMING)
-					flag |=3D TTY_FRAME;
-				if (stat & RXERROR_PARITY)
-					flag |=3D TTY_PARITY;
+				int stat =3D data[i];
+				int flag =3D TTY_NORMAL;
+
+				if (stat & RXERROR_OVERRUN) {
+					tty_insert_flip_char(tty, 0,
+								TTY_OVERRUN);
+				}
 				/* XXX should handle break (0x10) */
+				if (stat & RXERROR_PARITY)
+					flag =3D TTY_PARITY;
+				else if (stat & RXERROR_FRAMING)
+					flag =3D TTY_FRAME;
+
 				tty_insert_flip_char(tty, data[i+1], flag);
 			}
 		}
@@ -900,14 +909,19 @@ static void usa49wg_indat_callback(struct urb *urb)
 				 * some bytes had errors, every byte has status
 				 */
 				for (x =3D 0; x + 1 < len; x +=3D 2) {
-					int stat =3D data[i], flag =3D 0;
-					if (stat & RXERROR_OVERRUN)
-						flag |=3D TTY_OVERRUN;
-					if (stat & RXERROR_FRAMING)
-						flag |=3D TTY_FRAME;
-					if (stat & RXERROR_PARITY)
-						flag |=3D TTY_PARITY;
+					int stat =3D data[i];
+					int flag =3D TTY_NORMAL;
+
+					if (stat & RXERROR_OVERRUN) {
+						tty_insert_flip_char(tty, 0,
+								     TTY_OVERRUN);
+					}
 					/* XXX should handle break (0x10) */
+					if (stat & RXERROR_PARITY)
+						flag =3D TTY_PARITY;
+					else if (stat & RXERROR_FRAMING)
+						flag =3D TTY_FRAME;
+
 					tty_insert_flip_char(tty,
 							data[i+1], flag);
 					i +=3D 2;
@@ -967,25 +981,31 @@ static void usa90_indat_callback(struct urb *urb)
 			if ((data[0] & 0x80) =3D=3D 0) {
 				/* no errors on individual bytes, only
 				   possible overrun err*/
-				if (data[0] & RXERROR_OVERRUN)
-					err =3D TTY_OVERRUN;
-				else
-					err =3D 0;
+				if (data[0] & RXERROR_OVERRUN) {
+					tty_insert_flip_char(tty, 0,
+							     TTY_OVERRUN);
+				}
 				for (i =3D 1; i < urb->actual_length ; ++i)
 					tty_insert_flip_char(tty, data[i],
-									err);
+							     TTY_NORMAL);
 			}  else {
 			/* some bytes had errors, every byte has status */
 				dbg("%s - RX error!!!!", __func__);
 				for (i =3D 0; i + 1 < urb->actual_length; i +=3D 2) {
-					int stat =3D data[i], flag =3D 0;
-					if (stat & RXERROR_OVERRUN)
-						flag |=3D TTY_OVERRUN;
-					if (stat & RXERROR_FRAMING)
-						flag |=3D TTY_FRAME;
-					if (stat & RXERROR_PARITY)
-						flag |=3D TTY_PARITY;
+					int stat =3D data[i];
+					int flag =3D TTY_NORMAL;
+
+					if (stat & RXERROR_OVERRUN) {
+						tty_insert_flip_char(
+								tty, 0,
+								TTY_OVERRUN);
+					}
 					/* XXX should handle break (0x10) */
+					if (stat & RXERROR_PARITY)
+						flag =3D TTY_PARITY;
+					else if (stat & RXERROR_FRAMING)
+						flag =3D TTY_FRAME;
+
 					tty_insert_flip_char(tty, data[i+1],
 									flag);
 				}
diff --git a/drivers/usb/serial/kobil_sct.c b/drivers/usb/serial/kobil_sct.=
c
index ddd1463..16a6420 100644
--- a/drivers/usb/serial/kobil_sct.c
+++ b/drivers/usb/serial/kobil_sct.c
@@ -463,7 +463,8 @@ static int kobil_write(struct tty_struct *tty, struct u=
sb_serial_port *port,
 			);
=20
 			priv->cur_pos =3D priv->cur_pos + length;
-			result =3D usb_submit_urb(port->write_urb, GFP_NOIO);
+			result =3D usb_submit_urb(port->write_urb,
+					GFP_ATOMIC);
 			dbg("%s - port %d Send write URB returns: %i",
 					__func__, port->number, result);
 			todo =3D priv->filled - priv->cur_pos;
@@ -487,7 +488,7 @@ static int kobil_write(struct tty_struct *tty, struct u=
sb_serial_port *port,
 			port->interrupt_in_urb->dev =3D port->serial->dev;
=20
 			result =3D usb_submit_urb(port->interrupt_in_urb,
-								GFP_NOIO);
+					GFP_ATOMIC);
 			dbg("%s - port %d Send read URB returns: %i",
 					__func__, port->number, result);
 		}
diff --git a/drivers/usb/serial/opticon.c b/drivers/usb/serial/opticon.c
index d6c5ed6..e629533 100644
--- a/drivers/usb/serial/opticon.c
+++ b/drivers/usb/serial/opticon.c
@@ -293,7 +293,7 @@ static int opticon_write(struct tty_struct *tty, struct=
 usb_serial_port *port,
=20
 	/* The conncected devices do not have a bulk write endpoint,
 	 * to transmit data to de barcode device the control endpoint is used */
-	dr =3D kmalloc(sizeof(struct usb_ctrlrequest), GFP_NOIO);
+	dr =3D kmalloc(sizeof(struct usb_ctrlrequest), GFP_ATOMIC);
 	if (!dr) {
 		dev_err(&port->dev, "out of memory\n");
 		count =3D -ENOMEM;
diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index d8360be..64ea95d 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -269,6 +269,7 @@ static void option_instat_callback(struct urb *urb);
 #define TELIT_PRODUCT_DE910_DUAL		0x1010
 #define TELIT_PRODUCT_UE910_V2			0x1012
 #define TELIT_PRODUCT_LE920			0x1200
+#define TELIT_PRODUCT_LE910			0x1201
=20
 /* ZTE PRODUCTS */
 #define ZTE_VENDOR_ID				0x19d2
@@ -359,6 +360,7 @@ static void option_instat_callback(struct urb *urb);
=20
 /* Haier products */
 #define HAIER_VENDOR_ID				0x201e
+#define HAIER_PRODUCT_CE81B			0x10f8
 #define HAIER_PRODUCT_CE100			0x2009
=20
 /* Cinterion (formerly Siemens) products */
@@ -586,6 +588,11 @@ static const struct option_blacklist_info zte_1255_bla=
cklist =3D {
 	.reserved =3D BIT(3) | BIT(4),
 };
=20
+static const struct option_blacklist_info telit_le910_blacklist =3D {
+	.sendsetup =3D BIT(0),
+	.reserved =3D BIT(1) | BIT(2),
+};
+
 static const struct option_blacklist_info telit_le920_blacklist =3D {
 	.sendsetup =3D BIT(0),
 	.reserved =3D BIT(1) | BIT(5),
@@ -1135,6 +1142,8 @@ static const struct usb_device_id option_ids[] =3D {
 	{ USB_DEVICE(TELIT_VENDOR_ID, TELIT_PRODUCT_CC864_SINGLE) },
 	{ USB_DEVICE(TELIT_VENDOR_ID, TELIT_PRODUCT_DE910_DUAL) },
 	{ USB_DEVICE(TELIT_VENDOR_ID, TELIT_PRODUCT_UE910_V2) },
+	{ USB_DEVICE(TELIT_VENDOR_ID, TELIT_PRODUCT_LE910),
+		.driver_info =3D (kernel_ulong_t)&telit_le910_blacklist },
 	{ USB_DEVICE(TELIT_VENDOR_ID, TELIT_PRODUCT_LE920),
 		.driver_info =3D (kernel_ulong_t)&telit_le920_blacklist },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, ZTE_PRODUCT_MF622, 0xff, 0=
xff, 0xff) }, /* ZTE WCDMA products */
@@ -1610,6 +1619,7 @@ static const struct usb_device_id option_ids[] =3D {
 	{ USB_DEVICE(LONGCHEER_VENDOR_ID, ZOOM_PRODUCT_4597) },
 	{ USB_DEVICE(LONGCHEER_VENDOR_ID, IBALL_3_5G_CONNECT) },
 	{ USB_DEVICE(HAIER_VENDOR_ID, HAIER_PRODUCT_CE100) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(HAIER_VENDOR_ID, HAIER_PRODUCT_CE81B, 0xf=
f, 0xff, 0xff) },
 	/* Pirelli  */
 	{ USB_DEVICE(PIRELLI_VENDOR_ID, PIRELLI_PRODUCT_C100_1)},
 	{ USB_DEVICE(PIRELLI_VENDOR_ID, PIRELLI_PRODUCT_C100_2)},
diff --git a/drivers/usb/serial/ssu100.c b/drivers/usb/serial/ssu100.c
index bf1f8ea..ad8e5f3 100644
--- a/drivers/usb/serial/ssu100.c
+++ b/drivers/usb/serial/ssu100.c
@@ -599,10 +599,10 @@ static void ssu100_update_lsr(struct usb_serial_port =
*port, u8 lsr,
 			if (*tty_flag =3D=3D TTY_NORMAL)
 				*tty_flag =3D TTY_FRAME;
 		}
-		if (lsr & UART_LSR_OE){
+		if (lsr & UART_LSR_OE) {
 			priv->icount.overrun++;
-			if (*tty_flag =3D=3D TTY_NORMAL)
-				*tty_flag =3D TTY_OVERRUN;
+			tty_insert_flip_char(tty_port_tty_get(&port->port),
+					     0, TTY_OVERRUN);
 		}
 	}
=20
@@ -623,11 +623,8 @@ static int ssu100_process_packet(struct urb *urb,
 	if ((len >=3D 4) &&
 	    (packet[0] =3D=3D 0x1b) && (packet[1] =3D=3D 0x1b) &&
 	    ((packet[2] =3D=3D 0x00) || (packet[2] =3D=3D 0x01))) {
-		if (packet[2] =3D=3D 0x00) {
+		if (packet[2] =3D=3D 0x00)
 			ssu100_update_lsr(port, packet[3], &flag);
-			if (flag =3D=3D TTY_OVERRUN)
-				tty_insert_flip_char(tty, 0, TTY_OVERRUN);
-		}
 		if (packet[2] =3D=3D 0x01)
 			ssu100_update_msr(port, packet[3]);
=20
diff --git a/drivers/usb/storage/transport.c b/drivers/usb/storage/transpor=
t.c
index 0e5c91c..366395c 100644
--- a/drivers/usb/storage/transport.c
+++ b/drivers/usb/storage/transport.c
@@ -1119,6 +1119,31 @@ int usb_stor_Bulk_transport(struct scsi_cmnd *srb, s=
truct us_data *us)
 		 */
 		if (result =3D=3D USB_STOR_XFER_LONG)
 			fake_sense =3D 1;
+
+		/*
+		 * Sometimes a device will mistakenly skip the data phase
+		 * and go directly to the status phase without sending a
+		 * zero-length packet.  If we get a 13-byte response here,
+		 * check whether it really is a CSW.
+		 */
+		if (result =3D=3D USB_STOR_XFER_SHORT &&
+				srb->sc_data_direction =3D=3D DMA_FROM_DEVICE &&
+				transfer_length - scsi_get_resid(srb) =3D=3D
+					US_BULK_CS_WRAP_LEN) {
+			struct scatterlist *sg =3D NULL;
+			unsigned int offset =3D 0;
+
+			if (usb_stor_access_xfer_buf((unsigned char *) bcs,
+					US_BULK_CS_WRAP_LEN, srb, &sg,
+					&offset, FROM_XFER_BUF) =3D=3D
+						US_BULK_CS_WRAP_LEN &&
+					bcs->Signature =3D=3D
+						cpu_to_le32(US_BULK_CS_SIGN)) {
+				US_DEBUGP("Device skipped data phase\n");
+				scsi_set_resid(srb, transfer_length);
+				goto skipped_data_phase;
+			}
+		}
 	}
=20
 	/* See flow chart on pg 15 of the Bulk Only Transport spec for
@@ -1154,6 +1179,7 @@ int usb_stor_Bulk_transport(struct scsi_cmnd *srb, st=
ruct us_data *us)
 	if (result !=3D USB_STOR_XFER_GOOD)
 		return USB_STOR_TRANSPORT_ERROR;
=20
+ skipped_data_phase:
 	/* check bulk status */
 	residue =3D le32_to_cpu(bcs->Residue);
 	US_DEBUGP("Bulk Status S 0x%x T 0x%x R %u Stat 0x%x\n",
diff --git a/drivers/video/cfbcopyarea.c b/drivers/video/cfbcopyarea.c
index bcb5723..6d4bfee 100644
--- a/drivers/video/cfbcopyarea.c
+++ b/drivers/video/cfbcopyarea.c
@@ -55,8 +55,8 @@ bitcpy(struct fb_info *p, unsigned long __iomem *dst, uns=
igned dst_idx,
 	 * If you suspect bug in this function, compare it with this simple
 	 * memmove implementation.
 	 */
-	fb_memmove((char *)dst + ((dst_idx & (bits - 1))) / 8,
-		   (char *)src + ((src_idx & (bits - 1))) / 8, n / 8);
+	memmove((char *)dst + ((dst_idx & (bits - 1))) / 8,
+		(char *)src + ((src_idx & (bits - 1))) / 8, n / 8);
 	return;
 #endif
=20
@@ -221,8 +221,8 @@ bitcpy_rev(struct fb_info *p, unsigned long __iomem *ds=
t, unsigned dst_idx,
 	 * If you suspect bug in this function, compare it with this simple
 	 * memmove implementation.
 	 */
-	fb_memmove((char *)dst + ((dst_idx & (bits - 1))) / 8,
-		   (char *)src + ((src_idx & (bits - 1))) / 8, n / 8);
+	memmove((char *)dst + ((dst_idx & (bits - 1))) / 8,
+		(char *)src + ((src_idx & (bits - 1))) / 8, n / 8);
 	return;
 #endif
=20
@@ -324,7 +324,10 @@ bitcpy_rev(struct fb_info *p, unsigned long __iomem *d=
st, unsigned dst_idx,
 				d0 =3D d0 << left | d1 >> right;
 			}
 			d0 =3D fb_rev_pixels_in_long(d0, bswapmask);
-			FB_WRITEL(comp(d0, FB_READL(dst), first), dst);
+			if (!first)
+				FB_WRITEL(d0, dst);
+			else
+				FB_WRITEL(comp(d0, FB_READL(dst), first), dst);
 			d0 =3D d1;
 			dst--;
 			n -=3D dst_idx+1;
diff --git a/drivers/video/console/bitblit.c b/drivers/video/console/bitbli=
t.c
index 28b1a83..6cbb206 100644
--- a/drivers/video/console/bitblit.c
+++ b/drivers/video/console/bitblit.c
@@ -205,7 +205,6 @@ static void bit_putcs(struct vc_data *vc, struct fb_inf=
o *info,
 static void bit_clear_margins(struct vc_data *vc, struct fb_info *info,
 			      int bottom_only)
 {
-	int bgshift =3D (vc->vc_hi_font_mask) ? 13 : 12;
 	unsigned int cw =3D vc->vc_font.width;
 	unsigned int ch =3D vc->vc_font.height;
 	unsigned int rw =3D info->var.xres - (vc->vc_cols*cw);
@@ -214,7 +213,7 @@ static void bit_clear_margins(struct vc_data *vc, struc=
t fb_info *info,
 	unsigned int bs =3D info->var.yres - bh;
 	struct fb_fillrect region;
=20
-	region.color =3D attr_bgcol_ec(bgshift, vc, info);
+	region.color =3D 0;
 	region.rop =3D ROP_COPY;
=20
 	if (rw && !bottom_only) {
diff --git a/drivers/video/console/fbcon_ccw.c b/drivers/video/console/fbco=
n_ccw.c
index 41b32ae..5a3cbf6 100644
--- a/drivers/video/console/fbcon_ccw.c
+++ b/drivers/video/console/fbcon_ccw.c
@@ -197,9 +197,8 @@ static void ccw_clear_margins(struct vc_data *vc, struc=
t fb_info *info,
 	unsigned int bh =3D info->var.xres - (vc->vc_rows*ch);
 	unsigned int bs =3D vc->vc_rows*ch;
 	struct fb_fillrect region;
-	int bgshift =3D (vc->vc_hi_font_mask) ? 13 : 12;
=20
-	region.color =3D attr_bgcol_ec(bgshift,vc,info);
+	region.color =3D 0;
 	region.rop =3D ROP_COPY;
=20
 	if (rw && !bottom_only) {
diff --git a/drivers/video/console/fbcon_cw.c b/drivers/video/console/fbcon=
_cw.c
index 6a73782..7d3fd9b 100644
--- a/drivers/video/console/fbcon_cw.c
+++ b/drivers/video/console/fbcon_cw.c
@@ -181,9 +181,8 @@ static void cw_clear_margins(struct vc_data *vc, struct=
 fb_info *info,
 	unsigned int bh =3D info->var.xres - (vc->vc_rows*ch);
 	unsigned int rs =3D info->var.yres - rw;
 	struct fb_fillrect region;
-	int bgshift =3D (vc->vc_hi_font_mask) ? 13 : 12;
=20
-	region.color =3D attr_bgcol_ec(bgshift,vc,info);
+	region.color =3D 0;
 	region.rop =3D ROP_COPY;
=20
 	if (rw && !bottom_only) {
diff --git a/drivers/video/console/fbcon_ud.c b/drivers/video/console/fbcon=
_ud.c
index ff0872c..19e3714 100644
--- a/drivers/video/console/fbcon_ud.c
+++ b/drivers/video/console/fbcon_ud.c
@@ -227,9 +227,8 @@ static void ud_clear_margins(struct vc_data *vc, struct=
 fb_info *info,
 	unsigned int rw =3D info->var.xres - (vc->vc_cols*cw);
 	unsigned int bh =3D info->var.yres - (vc->vc_rows*ch);
 	struct fb_fillrect region;
-	int bgshift =3D (vc->vc_hi_font_mask) ? 13 : 12;
=20
-	region.color =3D attr_bgcol_ec(bgshift,vc,info);
+	region.color =3D 0;
 	region.rop =3D ROP_COPY;
=20
 	if (rw && !bottom_only) {
diff --git a/fs/buffer.c b/fs/buffer.c
index 59496e7..c457f84 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -2019,6 +2019,7 @@ int generic_write_end(struct file *file, struct addre=
ss_space *mapping,
 			struct page *page, void *fsdata)
 {
 	struct inode *inode =3D mapping->host;
+	loff_t old_size =3D inode->i_size;
 	int i_size_changed =3D 0;
=20
 	copied =3D block_write_end(file, mapping, pos, len, copied, page, fsdata)=
;
@@ -2038,6 +2039,8 @@ int generic_write_end(struct file *file, struct addre=
ss_space *mapping,
 	unlock_page(page);
 	page_cache_release(page);
=20
+	if (old_size < pos)
+		pagecache_isize_extended(inode, old_size, pos);
 	/*
 	 * Don't mark the inode dirty under page lock. First, it unnecessarily
 	 * makes the holding time of page lock longer. Second, it forces lock
@@ -2258,6 +2261,11 @@ static int cont_expand_zero(struct file *file, struc=
t address_space *mapping,
 		err =3D 0;
=20
 		balance_dirty_pages_ratelimited(mapping);
+
+		if (unlikely(fatal_signal_pending(current))) {
+			err =3D -EINTR;
+			goto out;
+		}
 	}
=20
 	/* page covers the boundary, find the boundary offset */
diff --git a/fs/ecryptfs/inode.c b/fs/ecryptfs/inode.c
index a9be90d..782569b 100644
--- a/fs/ecryptfs/inode.c
+++ b/fs/ecryptfs/inode.c
@@ -1112,7 +1112,7 @@ ecryptfs_setxattr(struct dentry *dentry, const char *=
name, const void *value,
 	}
=20
 	rc =3D vfs_setxattr(lower_dentry, name, value, size, flags);
-	if (!rc)
+	if (!rc && dentry->d_inode)
 		fsstack_copy_attr_all(dentry->d_inode, lower_dentry->d_inode);
 out:
 	return rc;
diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index b7f314f..562ede3 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -1303,13 +1303,6 @@ set_qf_format:
 					"not specified.");
 			return 0;
 		}
-	} else {
-		if (sbi->s_jquota_fmt) {
-			ext3_msg(sb, KERN_ERR, "error: journaled quota format "
-					"specified with no journaling "
-					"enabled.");
-			return 0;
-		}
 	}
 #endif
 	return 1;
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 40f4d06..6858d9d 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1874,6 +1874,7 @@ int ext4_get_block(struct inode *inode, sector_t iblo=
ck,
 				struct buffer_head *bh_result, int create);
=20
 extern struct inode *ext4_iget(struct super_block *, unsigned long);
+extern struct inode *ext4_iget_normal(struct super_block *, unsigned long)=
;
 extern int  ext4_write_inode(struct inode *, struct writeback_control *);
 extern int  ext4_setattr(struct dentry *, struct iattr *);
 extern int  ext4_getattr(struct vfsmount *mnt, struct dentry *dentry,
diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 6d1f577..a308844 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -813,6 +813,10 @@ got:
 		struct buffer_head *block_bitmap_bh;
=20
 		block_bitmap_bh =3D ext4_read_block_bitmap(sb, group);
+		if (!block_bitmap_bh) {
+			err =3D -EIO;
+			goto out;
+		}
 		BUFFER_TRACE(block_bitmap_bh, "get block bitmap access");
 		err =3D ext4_journal_get_write_access(handle, block_bitmap_bh);
 		if (err) {
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 55d4f46..f06857b 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -155,15 +155,14 @@ void ext4_evict_inode(struct inode *inode)
 		goto no_delete;
 	}
=20
-	if (!is_bad_inode(inode))
-		dquot_initialize(inode);
+	if (is_bad_inode(inode))
+		goto no_delete;
+	dquot_initialize(inode);
=20
 	if (ext4_should_order_data(inode))
 		ext4_begin_ordered_truncate(inode, 0);
 	truncate_inode_pages(&inode->i_data, 0);
=20
-	if (is_bad_inode(inode))
-		goto no_delete;
=20
 	handle =3D ext4_journal_start(inode, ext4_blocks_for_truncate(inode)+3);
 	if (IS_ERR(handle)) {
@@ -2410,6 +2409,20 @@ static int ext4_nonda_switch(struct super_block *sb)
 	return 0;
 }
=20
+/* We always reserve for an inode update; the superblock could be there to=
o */
+static int ext4_da_write_credits(struct inode *inode, loff_t pos, unsigned=
 len)
+{
+	if (likely(EXT4_HAS_RO_COMPAT_FEATURE(inode->i_sb,
+				EXT4_FEATURE_RO_COMPAT_LARGE_FILE)))
+		return 1;
+
+	if (pos + len <=3D 0x7fffffffULL)
+		return 1;
+
+	/* We might need to update the superblock to set LARGE_FILE */
+	return 2;
+}
+
 static int ext4_da_write_begin(struct file *file, struct address_space *ma=
pping,
 			       loff_t pos, unsigned len, unsigned flags,
 			       struct page **pagep, void **fsdata)
@@ -2436,7 +2449,8 @@ retry:
 	 * to journalling the i_disksize update if writes to the end
 	 * of file which has an already mapped buffer.
 	 */
-	handle =3D ext4_journal_start(inode, 1);
+	handle =3D ext4_journal_start(inode,
+				ext4_da_write_credits(inode, pos, len));
 	if (IS_ERR(handle)) {
 		ret =3D PTR_ERR(handle);
 		goto out;
@@ -3959,6 +3973,13 @@ bad_inode:
 	return ERR_PTR(ret);
 }
=20
+struct inode *ext4_iget_normal(struct super_block *sb, unsigned long ino)
+{
+	if (ino < EXT4_FIRST_INO(sb) && ino !=3D EXT4_ROOT_INO)
+		return ERR_PTR(-EIO);
+	return ext4_iget(sb, ino);
+}
+
 static int ext4_inode_blocks_set(handle_t *handle,
 				struct ext4_inode *raw_inode,
 				struct ext4_inode_info *ei)
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 2e0e34f..cd39fa7 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -1040,7 +1040,7 @@ static struct dentry *ext4_lookup(struct inode *dir, =
struct dentry *dentry, stru
 					 dentry->d_name.name);
 			return ERR_PTR(-EIO);
 		}
-		inode =3D ext4_iget(dir->i_sb, ino);
+		inode =3D ext4_iget_normal(dir->i_sb, ino);
 		if (inode =3D=3D ERR_PTR(-ESTALE)) {
 			EXT4_ERROR_INODE(dir,
 					 "deleted inode referenced: %u",
@@ -1074,7 +1074,7 @@ struct dentry *ext4_get_parent(struct dentry *child)
 		return ERR_PTR(-EIO);
 	}
=20
-	return d_obtain_alias(ext4_iget(child->d_inode->i_sb, ino));
+	return d_obtain_alias(ext4_iget_normal(child->d_inode->i_sb, ino));
 }
=20
 #define S_SHIFT 12
@@ -1408,31 +1408,38 @@ static int make_indexed_dir(handle_t *handle, struc=
t dentry *dentry,
 		hinfo.hash_version +=3D EXT4_SB(dir->i_sb)->s_hash_unsigned;
 	hinfo.seed =3D EXT4_SB(dir->i_sb)->s_hash_seed;
 	ext4fs_dirhash(name, namelen, &hinfo);
+	memset(frames, 0, sizeof(frames));
 	frame =3D frames;
 	frame->entries =3D entries;
 	frame->at =3D entries;
 	frame->bh =3D bh;
 	bh =3D bh2;
=20
-	ext4_handle_dirty_metadata(handle, dir, frame->bh);
-	ext4_handle_dirty_metadata(handle, dir, bh);
+	retval =3D ext4_handle_dirty_metadata(handle, dir, frame->bh);
+	if (retval)
+		goto out_frames;=09
+	retval =3D ext4_handle_dirty_metadata(handle, dir, bh);
+	if (retval)
+		goto out_frames;=09
=20
 	de =3D do_split(handle,dir, &bh, frame, &hinfo, &retval);
 	if (!de) {
-		/*
-		 * Even if the block split failed, we have to properly write
-		 * out all the changes we did so far. Otherwise we can end up
-		 * with corrupted filesystem.
-		 */
-		ext4_mark_inode_dirty(handle, dir);
-		dx_release(frames);
-		return retval;
+		goto out_frames;
 	}
 	dx_release(frames);
=20
 	retval =3D add_dirent_to_buf(handle, dentry, inode, de, bh);
 	brelse(bh);
 	return retval;
+out_frames:
+	/*
+	 * Even if the block split failed, we have to properly write
+	 * out all the changes we did so far. Otherwise we can end up
+	 * with corrupted filesystem.
+	 */
+	ext4_mark_inode_dirty(handle, dir);
+	dx_release(frames);
+	return retval;
 }
=20
 /*
@@ -1979,7 +1986,7 @@ int ext4_orphan_add(handle_t *handle, struct inode *i=
node)
 	struct ext4_iloc iloc;
 	int err =3D 0, rc;
=20
-	if (!ext4_handle_valid(handle))
+	if (!ext4_handle_valid(handle) || is_bad_inode(inode))
 		return 0;
=20
 	mutex_lock(&EXT4_SB(sb)->s_orphan_lock);
diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index 6e67b97..9e9e67b 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -692,7 +692,7 @@ static void update_backups(struct super_block *sb,
 		    (err =3D ext4_journal_restart(handle, EXT4_MAX_TRANS_DATA)))
 			break;
=20
-		bh =3D sb_getblk(sb, group * bpg + blk_off);
+		bh =3D sb_getblk(sb, (ext4_fsblk_t)group * bpg + blk_off);
 		if (!bh) {
 			err =3D -ENOMEM;
 			break;
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 6581ee7..422be11 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1185,7 +1185,7 @@ static struct inode *ext4_nfs_get_inode(struct super_=
block *sb,
 	 * Currently we don't know the generation for parent directory, so
 	 * a generation of 0 means "accept any"
 	 */
-	inode =3D ext4_iget(sb, ino);
+	inode =3D ext4_iget_normal(sb, ino);
 	if (IS_ERR(inode))
 		return ERR_CAST(inode);
 	if (generation && inode->i_generation !=3D generation) {
@@ -1931,13 +1931,6 @@ set_qf_format:
 					"not specified");
 			return 0;
 		}
-	} else {
-		if (sbi->s_jquota_fmt) {
-			ext4_msg(sb, KERN_ERR, "journaled quota format "
-					"specified with no journaling "
-					"enabled");
-			return 0;
-		}
 	}
 #endif
 	if (test_opt(sb, DIOREAD_NOLOCK)) {
diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 05617bd..c6ac876 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -144,14 +144,28 @@ ext4_listxattr(struct dentry *dentry, char *buffer, s=
ize_t size)
 }
=20
 static int
-ext4_xattr_check_names(struct ext4_xattr_entry *entry, void *end)
+ext4_xattr_check_names(struct ext4_xattr_entry *entry, void *end,
+		       void *value_start)
 {
-	while (!IS_LAST_ENTRY(entry)) {
-		struct ext4_xattr_entry *next =3D EXT4_XATTR_NEXT(entry);
+	struct ext4_xattr_entry *e =3D entry;
+
+	while (!IS_LAST_ENTRY(e)) {
+		struct ext4_xattr_entry *next =3D EXT4_XATTR_NEXT(e);
 		if ((void *)next >=3D end)
 			return -EIO;
-		entry =3D next;
+		e =3D next;
 	}
+
+	while (!IS_LAST_ENTRY(entry)) {
+		if (entry->e_value_size !=3D 0 &&
+		    (value_start + le16_to_cpu(entry->e_value_offs) <
+		     (void *)e + sizeof(__u32) ||
+		     value_start + le16_to_cpu(entry->e_value_offs) +
+		    le32_to_cpu(entry->e_value_size) > end))
+			return -EIO;
+		entry =3D EXT4_XATTR_NEXT(entry);
+	}
+
 	return 0;
 }
=20
@@ -163,7 +177,8 @@ ext4_xattr_check_block(struct buffer_head *bh)
 	if (BHDR(bh)->h_magic !=3D cpu_to_le32(EXT4_XATTR_MAGIC) ||
 	    BHDR(bh)->h_blocks !=3D cpu_to_le32(1))
 		return -EIO;
-	error =3D ext4_xattr_check_names(BFIRST(bh), bh->b_data + bh->b_size);
+	error =3D ext4_xattr_check_names(BFIRST(bh), bh->b_data + bh->b_size,
+				       bh->b_data);
 	return error;
 }
=20
@@ -276,7 +291,7 @@ ext4_xattr_ibody_get(struct inode *inode, int name_inde=
x, const char *name,
 	header =3D IHDR(inode, raw_inode);
 	entry =3D IFIRST(header);
 	end =3D (void *)raw_inode + EXT4_SB(inode->i_sb)->s_inode_size;
-	error =3D ext4_xattr_check_names(entry, end);
+	error =3D ext4_xattr_check_names(entry, end, entry);
 	if (error)
 		goto cleanup;
 	error =3D ext4_xattr_find_entry(&entry, name_index, name,
@@ -403,7 +418,7 @@ ext4_xattr_ibody_list(struct dentry *dentry, char *buff=
er, size_t buffer_size)
 	raw_inode =3D ext4_raw_inode(&iloc);
 	header =3D IHDR(inode, raw_inode);
 	end =3D (void *)raw_inode + EXT4_SB(inode->i_sb)->s_inode_size;
-	error =3D ext4_xattr_check_names(IFIRST(header), end);
+	error =3D ext4_xattr_check_names(IFIRST(header), end, IFIRST(header));
 	if (error)
 		goto cleanup;
 	error =3D ext4_xattr_list_entries(dentry, IFIRST(header),
@@ -914,7 +929,8 @@ ext4_xattr_ibody_find(struct inode *inode, struct ext4_=
xattr_info *i,
 	is->s.here =3D is->s.first;
 	is->s.end =3D (void *)raw_inode + EXT4_SB(inode->i_sb)->s_inode_size;
 	if (ext4_test_inode_state(inode, EXT4_STATE_XATTR)) {
-		error =3D ext4_xattr_check_names(IFIRST(header), is->s.end);
+		error =3D ext4_xattr_check_names(IFIRST(header), is->s.end,
+					       IFIRST(header));
 		if (error)
 			return error;
 		/* Find the named attribute. */
diff --git a/fs/ioprio.c b/fs/ioprio.c
index f79dab8..5b55511 100644
--- a/fs/ioprio.c
+++ b/fs/ioprio.c
@@ -169,14 +169,16 @@ out:
=20
 int ioprio_best(unsigned short aprio, unsigned short bprio)
 {
-	unsigned short aclass =3D IOPRIO_PRIO_CLASS(aprio);
-	unsigned short bclass =3D IOPRIO_PRIO_CLASS(bprio);
+	unsigned short aclass;
+	unsigned short bclass;
=20
-	if (aclass =3D=3D IOPRIO_CLASS_NONE)
-		aclass =3D IOPRIO_CLASS_BE;
-	if (bclass =3D=3D IOPRIO_CLASS_NONE)
-		bclass =3D IOPRIO_CLASS_BE;
+	if (!ioprio_valid(aprio))
+		aprio =3D IOPRIO_PRIO_VALUE(IOPRIO_CLASS_BE, IOPRIO_NORM);
+	if (!ioprio_valid(bprio))
+		bprio =3D IOPRIO_PRIO_VALUE(IOPRIO_CLASS_BE, IOPRIO_NORM);
=20
+	aclass =3D IOPRIO_PRIO_CLASS(aprio);
+	bclass =3D IOPRIO_PRIO_CLASS(bprio);
 	if (aclass =3D=3D bclass)
 		return min(aprio, bprio);
 	if (aclass > bclass)
diff --git a/fs/lockd/mon.c b/fs/lockd/mon.c
index 23d7451..ef744e1 100644
--- a/fs/lockd/mon.c
+++ b/fs/lockd/mon.c
@@ -111,6 +111,12 @@ static int nsm_mon_unmon(struct nsm_handle *nsm, u32 p=
roc, struct nsm_res *res)
=20
 	msg.rpc_proc =3D &clnt->cl_procinfo[proc];
 	status =3D rpc_call_sync(clnt, &msg, 0);
+	if (status =3D=3D -ECONNREFUSED) {
+		dprintk("lockd:	NSM upcall RPC failed, status=3D%d, forcing rebind\n",
+				status);
+		rpc_force_rebind(clnt);
+		status =3D rpc_call_sync(clnt, &msg, 0);
+	}
 	if (status < 0)
 		dprintk("lockd: NSM upcall RPC failed, status=3D%d\n",
 				status);
diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index 61a1303..351989e 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -5612,7 +5612,7 @@ static int nfs41_proc_async_sequence(struct nfs_clien=
t *clp, struct rpc_cred *cr
 	int ret =3D 0;
=20
 	if ((renew_flags & NFS4_RENEW_TIMEOUT) =3D=3D 0)
-		return 0;
+		return -EAGAIN;
 	task =3D _nfs41_proc_sequence(clp, cred, &nfs41_sequence_ops);
 	if (IS_ERR(task))
 		ret =3D PTR_ERR(task);
diff --git a/fs/nfs/nfs4renewd.c b/fs/nfs/nfs4renewd.c
index dc484c0..78071cf9 100644
--- a/fs/nfs/nfs4renewd.c
+++ b/fs/nfs/nfs4renewd.c
@@ -88,10 +88,18 @@ nfs4_renew_state(struct work_struct *work)
 			}
 			nfs_expire_all_delegations(clp);
 		} else {
+			int ret;
+
 			/* Queue an asynchronous RENEW. */
-			ops->sched_state_renewal(clp, cred, renew_flags);
+			ret =3D ops->sched_state_renewal(clp, cred, renew_flags);
 			put_rpccred(cred);
-			goto out_exp;
+			switch (ret) {
+			default:
+				goto out_exp;
+			case -EAGAIN:
+			case -ENOMEM:
+				break;
+			}
 		}
 	} else {
 		dprintk("%s: failed to call renewd. Reason: lease not expired \n",
diff --git a/fs/nfs/nfs4state.c b/fs/nfs/nfs4state.c
index b2e1136..ce4168a 100644
--- a/fs/nfs/nfs4state.c
+++ b/fs/nfs/nfs4state.c
@@ -1447,7 +1447,8 @@ restart:
 			if (status < 0) {
 				set_bit(ops->owner_flag_bit, &sp->so_flags);
 				nfs4_put_state_owner(sp);
-				return nfs4_recovery_handle_error(clp, status);
+				status =3D nfs4_recovery_handle_error(clp, status);
+				return (status !=3D 0) ? status : -EAGAIN;
 			}
=20
 			nfs4_put_state_owner(sp);
@@ -1456,7 +1457,7 @@ restart:
 		spin_unlock(&clp->cl_lock);
 	}
 	rcu_read_unlock();
-	return status;
+	return 0;
 }
=20
 static int nfs4_check_lease(struct nfs_client *clp)
@@ -1729,23 +1730,18 @@ static void nfs4_state_manager(struct nfs_client *c=
lp)
 		if (test_bit(NFS4CLNT_RECLAIM_REBOOT, &clp->cl_state)) {
 			status =3D nfs4_do_reclaim(clp,
 				clp->cl_mvops->reboot_recovery_ops);
-			if (test_bit(NFS4CLNT_LEASE_EXPIRED, &clp->cl_state) ||
-			    test_bit(NFS4CLNT_SESSION_RESET, &clp->cl_state))
-				continue;
-			nfs4_state_end_reclaim_reboot(clp);
-			if (test_bit(NFS4CLNT_RECLAIM_NOGRACE, &clp->cl_state))
+			if (status =3D=3D -EAGAIN)
 				continue;
 			if (status < 0)
 				goto out_error;
+			nfs4_state_end_reclaim_reboot(clp);
 		}
=20
 		/* Now recover expired state... */
 		if (test_and_clear_bit(NFS4CLNT_RECLAIM_NOGRACE, &clp->cl_state)) {
 			status =3D nfs4_do_reclaim(clp,
 				clp->cl_mvops->nograce_recovery_ops);
-			if (test_bit(NFS4CLNT_LEASE_EXPIRED, &clp->cl_state) ||
-			    test_bit(NFS4CLNT_SESSION_RESET, &clp->cl_state) ||
-			    test_bit(NFS4CLNT_RECLAIM_REBOOT, &clp->cl_state))
+			if (status =3D=3D -EAGAIN)
 				continue;
 			if (status < 0)
 				goto out_error;
diff --git a/fs/nfsd/nfs4callback.c b/fs/nfsd/nfs4callback.c
index 809a38a..51b4f43 100644
--- a/fs/nfsd/nfs4callback.c
+++ b/fs/nfsd/nfs4callback.c
@@ -785,8 +785,12 @@ static bool nfsd41_cb_get_slot(struct nfs4_client *clp=
, struct rpc_task *task)
 {
 	if (test_and_set_bit(0, &clp->cl_cb_slot_busy) !=3D 0) {
 		rpc_sleep_on(&clp->cl_cb_waitq, task, NULL);
-		dprintk("%s slot is busy\n", __func__);
-		return false;
+		/* Race breaker */
+		if (test_and_set_bit(0, &clp->cl_cb_slot_busy) !=3D 0) {
+			dprintk("%s slot is busy\n", __func__);
+			return false;
+		}
+		rpc_wake_up_queued_task(&clp->cl_cb_waitq, task);
 	}
 	return true;
 }
diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index eebccfe..9a959de 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -1111,7 +1111,8 @@ static bool need_wrongsec_check(struct svc_rqst *rqst=
p)
 	 */
 	if (argp->opcnt =3D=3D resp->opcnt)
 		return false;
-
+	if (next->opnum =3D=3D OP_ILLEGAL)
+		return false;
 	nextd =3D OPDESC(next);
 	/*
 	 * Rest of 2.6.3.1.1: certain operations will return WRONGSEC
diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanoti=
fy_user.c
index 9860f6b..d57995e 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -65,7 +65,7 @@ static int create_fd(struct fsnotify_group *group, struct=
 fsnotify_event *event)
=20
 	pr_debug("%s: group=3D%p event=3D%p\n", __func__, group, event);
=20
-	client_fd =3D get_unused_fd();
+	client_fd =3D get_unused_fd_flags(group->fanotify_data.f_flags);
 	if (client_fd < 0)
 		return client_fd;
=20
diff --git a/fs/super.c b/fs/super.c
index 2a698f6..531de18 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -68,6 +68,8 @@ static int prune_super(struct shrinker *shrink, struct sh=
rink_control *sc)
=20
 	total_objects =3D sb->s_nr_dentry_unused +
 			sb->s_nr_inodes_unused + fs_objects + 1;
+	if (!total_objects)
+		total_objects =3D 1;
=20
 	if (sc->nr_to_scan) {
 		int	dentries;
diff --git a/fs/ubifs/commit.c b/fs/ubifs/commit.c
index fb3b5c8..b2ca12f 100644
--- a/fs/ubifs/commit.c
+++ b/fs/ubifs/commit.c
@@ -166,15 +166,10 @@ static int do_commit(struct ubifs_info *c)
 	err =3D ubifs_orphan_end_commit(c);
 	if (err)
 		goto out;
-	old_ltail_lnum =3D c->ltail_lnum;
-	err =3D ubifs_log_end_commit(c, new_ltail_lnum);
-	if (err)
-		goto out;
 	err =3D dbg_check_old_index(c, &zroot);
 	if (err)
 		goto out;
=20
-	mutex_lock(&c->mst_mutex);
 	c->mst_node->cmt_no      =3D cpu_to_le64(c->cmt_no);
 	c->mst_node->log_lnum    =3D cpu_to_le32(new_ltail_lnum);
 	c->mst_node->root_lnum   =3D cpu_to_le32(zroot.lnum);
@@ -203,8 +198,9 @@ static int do_commit(struct ubifs_info *c)
 		c->mst_node->flags |=3D cpu_to_le32(UBIFS_MST_NO_ORPHS);
 	else
 		c->mst_node->flags &=3D ~cpu_to_le32(UBIFS_MST_NO_ORPHS);
-	err =3D ubifs_write_master(c);
-	mutex_unlock(&c->mst_mutex);
+
+	old_ltail_lnum =3D c->ltail_lnum;
+	err =3D ubifs_log_end_commit(c, new_ltail_lnum);
 	if (err)
 		goto out;
=20
diff --git a/fs/ubifs/log.c b/fs/ubifs/log.c
index f9fd068..843beda 100644
--- a/fs/ubifs/log.c
+++ b/fs/ubifs/log.c
@@ -110,10 +110,14 @@ static inline long long empty_log_bytes(const struct =
ubifs_info *c)
 	h =3D (long long)c->lhead_lnum * c->leb_size + c->lhead_offs;
 	t =3D (long long)c->ltail_lnum * c->leb_size;
=20
-	if (h >=3D t)
+	if (h > t)
 		return c->log_bytes - h + t;
-	else
+	else if (h !=3D t)
 		return t - h;
+	else if (c->lhead_lnum !=3D c->ltail_lnum)
+		return 0;
+	else
+		return c->log_bytes;
 }
=20
 /**
@@ -453,9 +457,9 @@ out:
  * @ltail_lnum: new log tail LEB number
  *
  * This function is called on when the commit operation was finished. It
- * moves log tail to new position and unmaps LEBs which contain obsolete d=
ata.
- * Returns zero in case of success and a negative error code in case of
- * failure.
+ * moves log tail to new position and updates the master node so that it s=
tores
+ * the new log tail LEB number. Returns zero in case of success and a nega=
tive
+ * error code in case of failure.
  */
 int ubifs_log_end_commit(struct ubifs_info *c, int ltail_lnum)
 {
@@ -483,7 +487,12 @@ int ubifs_log_end_commit(struct ubifs_info *c, int lta=
il_lnum)
 	spin_unlock(&c->buds_lock);
=20
 	err =3D dbg_check_bud_bytes(c);
+	if (err)
+		goto out;
=20
+	err =3D ubifs_write_master(c);
+
+out:
 	mutex_unlock(&c->log_mutex);
 	return err;
 }
diff --git a/fs/ubifs/master.c b/fs/ubifs/master.c
index 278c238..bb9f481 100644
--- a/fs/ubifs/master.c
+++ b/fs/ubifs/master.c
@@ -352,10 +352,9 @@ int ubifs_read_master(struct ubifs_info *c)
  * ubifs_write_master - write master node.
  * @c: UBIFS file-system description object
  *
- * This function writes the master node. The caller has to take the
- * @c->mst_mutex lock before calling this function. Returns zero in case o=
f
- * success and a negative error code in case of failure. The master node i=
s
- * written twice to enable recovery.
+ * This function writes the master node. Returns zero in case of success a=
nd a
+ * negative error code in case of failure. The master node is written twic=
e to
+ * enable recovery.
  */
 int ubifs_write_master(struct ubifs_info *c)
 {
diff --git a/fs/ubifs/super.c b/fs/ubifs/super.c
index 2f467e5..201bcfc 100644
--- a/fs/ubifs/super.c
+++ b/fs/ubifs/super.c
@@ -1985,7 +1985,6 @@ static struct ubifs_info *alloc_ubifs_info(struct ubi=
_volume_desc *ubi)
 		mutex_init(&c->lp_mutex);
 		mutex_init(&c->tnc_mutex);
 		mutex_init(&c->log_mutex);
-		mutex_init(&c->mst_mutex);
 		mutex_init(&c->umount_mutex);
 		mutex_init(&c->bu_mutex);
 		mutex_init(&c->write_reserve_mutex);
diff --git a/fs/ubifs/ubifs.h b/fs/ubifs/ubifs.h
index a39fce5..223dd42 100644
--- a/fs/ubifs/ubifs.h
+++ b/fs/ubifs/ubifs.h
@@ -1044,7 +1044,6 @@ struct ubifs_debug_info;
  *
  * @mst_node: master node
  * @mst_offs: offset of valid master node
- * @mst_mutex: protects the master node area, @mst_node, and @mst_offs
  *
  * @max_bu_buf_len: maximum bulk-read buffer length
  * @bu_mutex: protects the pre-allocated bulk-read buffer and @c->bu
@@ -1284,7 +1283,6 @@ struct ubifs_info {
=20
 	struct ubifs_mst_node *mst_node;
 	int mst_offs;
-	struct mutex mst_mutex;
=20
 	int max_bu_buf_len;
 	struct mutex bu_mutex;
diff --git a/include/drm/drm_pciids.h b/include/drm/drm_pciids.h
index c37fd89..7daeaba 100644
--- a/include/drm/drm_pciids.h
+++ b/include/drm/drm_pciids.h
@@ -56,7 +56,6 @@
 	{0x1002, 0x4C64, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_RV250|RADEON_IS_MOBIL=
ITY}, \
 	{0x1002, 0x4C66, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_RV250|RADEON_IS_MOBIL=
ITY}, \
 	{0x1002, 0x4C67, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_RV250|RADEON_IS_MOBIL=
ITY}, \
-	{0x1002, 0x4C6E, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_RV280|RADEON_IS_MOBIL=
ITY}, \
 	{0x1002, 0x4E44, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_R300}, \
 	{0x1002, 0x4E45, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_R300}, \
 	{0x1002, 0x4E46, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_R300}, \
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index ff039f0..c7e834b 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1060,10 +1060,9 @@ static inline int queue_alignment_offset(struct requ=
est_queue *q)
 static inline int queue_limit_alignment_offset(struct queue_limits *lim, s=
ector_t sector)
 {
 	unsigned int granularity =3D max(lim->physical_block_size, lim->io_min);
-	unsigned int alignment =3D (sector << 9) & (granularity - 1);
+	unsigned int alignment =3D sector_div(sector, granularity >> 9) << 9;
=20
-	return (granularity + lim->alignment_offset - alignment)
-		& (granularity - 1);
+	return (granularity + lim->alignment_offset - alignment) % granularity;
 }
=20
 static inline int bdev_alignment_offset(struct block_device *bdev)
diff --git a/include/linux/compiler-gcc.h b/include/linux/compiler-gcc.h
index 5633053..9ac1a7a 100644
--- a/include/linux/compiler-gcc.h
+++ b/include/linux/compiler-gcc.h
@@ -37,6 +37,9 @@
     __asm__ ("" : "=3Dr"(__ptr) : "0"(ptr));		\
     (typeof(ptr)) (__ptr + (off)); })
=20
+/* Make the optimizer believe the variable can be manipulated arbitrarily.=
 */
+#define OPTIMIZER_HIDE_VAR(var) __asm__ ("" : "=3Dr" (var) : "0" (var))
+
 #ifdef __CHECKER__
 #define __must_be_array(arr) 0
 #else
diff --git a/include/linux/compiler-gcc5.h b/include/linux/compiler-gcc5.h
new file mode 100644
index 0000000..cdd1cc2
--- /dev/null
+++ b/include/linux/compiler-gcc5.h
@@ -0,0 +1,66 @@
+#ifndef __LINUX_COMPILER_H
+#error "Please don't include <linux/compiler-gcc5.h> directly, include <li=
nux/compiler.h> instead."
+#endif
+
+#define __used				__attribute__((__used__))
+#define __must_check			__attribute__((warn_unused_result))
+#define __compiler_offsetof(a, b)	__builtin_offsetof(a, b)
+
+/* Mark functions as cold. gcc will assume any path leading to a call
+   to them will be unlikely.  This means a lot of manual unlikely()s
+   are unnecessary now for any paths leading to the usual suspects
+   like BUG(), printk(), panic() etc. [but let's keep them for now for
+   older compilers]
+
+   Early snapshots of gcc 4.3 don't support this and we can't detect this
+   in the preprocessor, but we can live with this because they're unreleas=
ed.
+   Maketime probing would be overkill here.
+
+   gcc also has a __attribute__((__hot__)) to move hot functions into
+   a special section, but I don't see any sense in this right now in
+   the kernel context */
+#define __cold			__attribute__((__cold__))
+
+#define __UNIQUE_ID(prefix) __PASTE(__PASTE(__UNIQUE_ID_, prefix), __COUNT=
ER__)
+
+#ifndef __CHECKER__
+# define __compiletime_warning(message) __attribute__((warning(message)))
+# define __compiletime_error(message) __attribute__((error(message)))
+#endif /* __CHECKER__ */
+
+/*
+ * Mark a position in code as unreachable.  This can be used to
+ * suppress control flow warnings after asm blocks that transfer
+ * control elsewhere.
+ *
+ * Early snapshots of gcc 4.5 don't support this and we can't detect
+ * this in the preprocessor, but we can live with this because they're
+ * unreleased.  Really, we need to have autoconf for the kernel.
+ */
+#define unreachable() __builtin_unreachable()
+
+/* Mark a function definition as prohibited from being cloned. */
+#define __noclone	__attribute__((__noclone__))
+
+/*
+ * Tell the optimizer that something else uses this function or variable.
+ */
+#define __visible __attribute__((externally_visible))
+
+/*
+ * GCC 'asm goto' miscompiles certain code sequences:
+ *
+ *   http://gcc.gnu.org/bugzilla/show_bug.cgi?id=3D58670
+ *
+ * Work it around via a compiler barrier quirk suggested by Jakub Jelinek.
+ * Fixed in GCC 4.8.2 and later versions.
+ *
+ * (asm goto is automatically volatile - the naming reflects this.)
+ */
+#define asm_volatile_goto(x...)	do { asm goto(x); asm (""); } while (0)
+
+#ifdef CONFIG_ARCH_USE_BUILTIN_BSWAP
+#define __HAVE_BUILTIN_BSWAP32__
+#define __HAVE_BUILTIN_BSWAP64__
+#define __HAVE_BUILTIN_BSWAP16__
+#endif /* CONFIG_ARCH_USE_BUILTIN_BSWAP */
diff --git a/include/linux/compiler-intel.h b/include/linux/compiler-intel.=
h
index cba9593..1a97cac 100644
--- a/include/linux/compiler-intel.h
+++ b/include/linux/compiler-intel.h
@@ -15,6 +15,7 @@
  */
 #undef barrier
 #undef RELOC_HIDE
+#undef OPTIMIZER_HIDE_VAR
=20
 #define barrier() __memory_barrier()
=20
@@ -23,6 +24,12 @@
      __ptr =3D (unsigned long) (ptr);				\
     (typeof(ptr)) (__ptr + (off)); })
=20
+/* This should act as an optimization barrier on var.
+ * Given that this compiler does not have inline assembly, a compiler barr=
ier
+ * is the best we can do.
+ */
+#define OPTIMIZER_HIDE_VAR(var) barrier()
+
 /* Intel ECC compiler doesn't support __builtin_types_compatible_p() */
 #define __must_be_array(a) 0
=20
diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index 320d6c9..7c7546b 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -164,6 +164,10 @@ void ftrace_likely_update(struct ftrace_branch_data *f=
, int val, int expect);
     (typeof(ptr)) (__ptr + (off)); })
 #endif
=20
+#ifndef OPTIMIZER_HIDE_VAR
+#define OPTIMIZER_HIDE_VAR(var) barrier()
+#endif
+
 #endif /* __KERNEL__ */
=20
 #endif /* __ASSEMBLY__ */
diff --git a/include/linux/khugepaged.h b/include/linux/khugepaged.h
index 6b394f0..eeb3079 100644
--- a/include/linux/khugepaged.h
+++ b/include/linux/khugepaged.h
@@ -6,7 +6,8 @@
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 extern int __khugepaged_enter(struct mm_struct *mm);
 extern void __khugepaged_exit(struct mm_struct *mm);
-extern int khugepaged_enter_vma_merge(struct vm_area_struct *vma);
+extern int khugepaged_enter_vma_merge(struct vm_area_struct *vma,
+				      unsigned long vm_flags);
=20
 #define khugepaged_enabled()					       \
 	(transparent_hugepage_flags &				       \
@@ -35,13 +36,13 @@ static inline void khugepaged_exit(struct mm_struct *mm=
)
 		__khugepaged_exit(mm);
 }
=20
-static inline int khugepaged_enter(struct vm_area_struct *vma)
+static inline int khugepaged_enter(struct vm_area_struct *vma,
+				   unsigned long vm_flags)
 {
 	if (!test_bit(MMF_VM_HUGEPAGE, &vma->vm_mm->flags))
 		if ((khugepaged_always() ||
-		     (khugepaged_req_madv() &&
-		      vma->vm_flags & VM_HUGEPAGE)) &&
-		    !(vma->vm_flags & VM_NOHUGEPAGE))
+		     (khugepaged_req_madv() && (vm_flags & VM_HUGEPAGE))) &&
+		    !(vm_flags & VM_NOHUGEPAGE))
 			if (__khugepaged_enter(vma->vm_mm))
 				return -ENOMEM;
 	return 0;
@@ -54,11 +55,13 @@ static inline int khugepaged_fork(struct mm_struct *mm,=
 struct mm_struct *oldmm)
 static inline void khugepaged_exit(struct mm_struct *mm)
 {
 }
-static inline int khugepaged_enter(struct vm_area_struct *vma)
+static inline int khugepaged_enter(struct vm_area_struct *vma,
+				   unsigned long vm_flags)
 {
 	return 0;
 }
-static inline int khugepaged_enter_vma_merge(struct vm_area_struct *vma)
+static inline int khugepaged_enter_vma_merge(struct vm_area_struct *vma,
+					     unsigned long vm_flags)
 {
 	return 0;
 }
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 305fd75..7f40120 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -952,6 +952,7 @@ static inline void unmap_shared_mapping_range(struct ad=
dress_space *mapping,
=20
 extern void truncate_pagecache(struct inode *inode, loff_t old, loff_t new=
);
 extern void truncate_setsize(struct inode *inode, loff_t newsize);
+void pagecache_isize_extended(struct inode *inode, loff_t from, loff_t to)=
;
 extern int vmtruncate(struct inode *inode, loff_t offset);
 extern int vmtruncate_range(struct inode *inode, loff_t offset, loff_t end=
);
=20
diff --git a/include/linux/string.h b/include/linux/string.h
index e033564..8515a4d 100644
--- a/include/linux/string.h
+++ b/include/linux/string.h
@@ -144,5 +144,7 @@ static inline bool strstarts(const char *str, const cha=
r *prefix)
 {
 	return strncmp(str, prefix, strlen(prefix)) =3D=3D 0;
 }
+
+void memzero_explicit(void *s, size_t count);
 #endif
 #endif /* _LINUX_STRING_H_ */
diff --git a/include/linux/usb/quirks.h b/include/linux/usb/quirks.h
index 3e93de7..8eeeb87 100644
--- a/include/linux/usb/quirks.h
+++ b/include/linux/usb/quirks.h
@@ -30,4 +30,7 @@
    descriptor */
 #define USB_QUIRK_DELAY_INIT		0x00000040
=20
+/* device generates spurious wakeup, ignore remote wakeup capability */
+#define USB_QUIRK_IGNORE_REMOTE_WAKEUP	0x00000200
+
 #endif /* __LINUX_USB_QUIRKS_H */
diff --git a/include/net/tcp.h b/include/net/tcp.h
index fe46019..238255b 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -358,13 +358,6 @@ static inline void tcp_dec_quickack_mode(struct sock *=
sk,
 #define	TCP_ECN_DEMAND_CWR	4
 #define	TCP_ECN_SEEN		8
=20
-static __inline__ void
-TCP_ECN_create_request(struct request_sock *req, struct tcphdr *th)
-{
-	if (sysctl_tcp_ecn && th->ece && th->cwr)
-		inet_rsk(req)->ecn_ok =3D 1;
-}
-
 enum tcp_tw_status {
 	TCP_TW_SUCCESS =3D 0,
 	TCP_TW_RST =3D 1,
@@ -652,6 +645,22 @@ struct tcp_skb_cb {
=20
 #define TCP_SKB_CB(__skb)	((struct tcp_skb_cb *)&((__skb)->cb[0]))
=20
+/* RFC3168 : 6.1.1 SYN packets must not have ECT/ECN bits set
+ *
+ * If we receive a SYN packet with these bits set, it means a network is
+ * playing bad games with TOS bits. In order to avoid possible false conge=
stion
+ * notifications, we disable TCP ECN negociation.
+ */
+static inline void
+TCP_ECN_create_request(struct request_sock *req, const struct sk_buff *skb=
)
+{
+	const struct tcphdr *th =3D tcp_hdr(skb);
+
+	if (sysctl_tcp_ecn && th->ece && th->cwr &&
+	    INET_ECN_is_not_ect(TCP_SKB_CB(skb)->ip_dsfield))
+		inet_rsk(req)->ecn_ok =3D 1;
+}
+
 /* Due to TSO, an SKB can be composed of multiple actual
  * packets.  To keep these tracked properly, we use this.
  */
diff --git a/kernel/audit_tree.c b/kernel/audit_tree.c
index 0caf1f8..8a14284 100644
--- a/kernel/audit_tree.c
+++ b/kernel/audit_tree.c
@@ -154,6 +154,7 @@ static struct audit_chunk *alloc_chunk(int count)
 		chunk->owners[i].index =3D i;
 	}
 	fsnotify_init_mark(&chunk->mark, audit_tree_destroy_watch);
+	chunk->mark.mask =3D FS_IN_IGNORED;
 	return chunk;
 }
=20
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 4a14895..2a4bf43 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -36,6 +36,7 @@
 #include <linux/perf_event.h>
 #include <linux/ftrace_event.h>
 #include <linux/hw_breakpoint.h>
+#include <linux/compat.h>
=20
 #include "internal.h"
=20
@@ -3444,6 +3445,25 @@ static long perf_ioctl(struct file *file, unsigned i=
nt cmd, unsigned long arg)
 	return 0;
 }
=20
+#ifdef CONFIG_COMPAT
+static long perf_compat_ioctl(struct file *file, unsigned int cmd,
+				unsigned long arg)
+{
+	switch (_IOC_NR(cmd)) {
+	case _IOC_NR(PERF_EVENT_IOC_SET_FILTER):
+		/* Fix up pointer size (usually 4 -> 8 in 32-on-64-bit case */
+		if (_IOC_SIZE(cmd) =3D=3D sizeof(compat_uptr_t)) {
+			cmd &=3D ~IOCSIZE_MASK;
+			cmd |=3D sizeof(void *) << IOCSIZE_SHIFT;
+		}
+		break;
+	}
+	return perf_ioctl(file, cmd, arg);
+}
+#else
+# define perf_compat_ioctl NULL
+#endif
+
 int perf_event_task_enable(void)
 {
 	struct perf_event *event;
@@ -3910,7 +3930,7 @@ static const struct file_operations perf_fops =3D {
 	.read			=3D perf_read,
 	.poll			=3D perf_poll,
 	.unlocked_ioctl		=3D perf_ioctl,
-	.compat_ioctl		=3D perf_ioctl,
+	.compat_ioctl		=3D perf_compat_ioctl,
 	.mmap			=3D perf_mmap,
 	.fasync			=3D perf_fasync,
 };
diff --git a/kernel/futex.c b/kernel/futex.c
index f31f190..7481595 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -484,8 +484,14 @@ static struct futex_pi_state * alloc_pi_state(void)
 	return pi_state;
 }
=20
+/*
+ * Must be called with the hb lock held.
+ */
 static void free_pi_state(struct futex_pi_state *pi_state)
 {
+	if (!pi_state)
+		return;
+
 	if (!atomic_dec_and_test(&pi_state->refcount))
 		return;
=20
@@ -1399,15 +1405,6 @@ static int futex_requeue(u32 __user *uaddr1, unsigne=
d int flags,
 	}
=20
 retry:
-	if (pi_state !=3D NULL) {
-		/*
-		 * We will have to lookup the pi_state again, so free this one
-		 * to keep the accounting correct.
-		 */
-		free_pi_state(pi_state);
-		pi_state =3D NULL;
-	}
-
 	ret =3D get_futex_key(uaddr1, flags & FLAGS_SHARED, &key1, VERIFY_READ);
 	if (unlikely(ret !=3D 0))
 		goto out;
@@ -1495,6 +1492,8 @@ retry_private:
 		case 0:
 			break;
 		case -EFAULT:
+			free_pi_state(pi_state);
+			pi_state =3D NULL;
 			double_unlock_hb(hb1, hb2);
 			put_futex_key(&key2);
 			put_futex_key(&key1);
@@ -1504,6 +1503,8 @@ retry_private:
 			goto out;
 		case -EAGAIN:
 			/* The owner was exiting, try again. */
+			free_pi_state(pi_state);
+			pi_state =3D NULL;
 			double_unlock_hb(hb1, hb2);
 			put_futex_key(&key2);
 			put_futex_key(&key1);
@@ -1580,6 +1581,7 @@ retry_private:
 	}
=20
 out_unlock:
+	free_pi_state(pi_state);
 	double_unlock_hb(hb1, hb2);
=20
 	/*
@@ -1596,8 +1598,6 @@ out_put_keys:
 out_put_key1:
 	put_futex_key(&key1);
 out:
-	if (pi_state !=3D NULL)
-		free_pi_state(pi_state);
 	return ret ? ret : task_count;
 }
=20
diff --git a/kernel/posix-timers.c b/kernel/posix-timers.c
index e885be1..02824a5 100644
--- a/kernel/posix-timers.c
+++ b/kernel/posix-timers.c
@@ -589,6 +589,7 @@ SYSCALL_DEFINE3(timer_create, const clockid_t, which_cl=
ock,
 			goto out;
 		}
 	} else {
+		memset(&event.sigev_value, 0, sizeof(event.sigev_value));
 		event.sigev_notify =3D SIGEV_SIGNAL;
 		event.sigev_signo =3D SIGALRM;
 		event.sigev_value.sival_int =3D new_timer->it_id;
diff --git a/kernel/power/hibernate.c b/kernel/power/hibernate.c
index 013bd2e..e4ce628 100644
--- a/kernel/power/hibernate.c
+++ b/kernel/power/hibernate.c
@@ -503,8 +503,14 @@ int hibernation_restore(int platform_mode)
 	error =3D dpm_suspend_start(PMSG_QUIESCE);
 	if (!error) {
 		error =3D resume_target_kernel(platform_mode);
-		dpm_resume_end(PMSG_RECOVER);
+		/*
+		 * The above should either succeed and jump to the new kernel,
+		 * or return with an error. Otherwise things are just
+		 * undefined, so let's be paranoid.
+		 */
+		BUG_ON(!error);
 	}
+	dpm_resume_end(PMSG_RECOVER);
 	pm_restore_gfp_mask();
 	ftrace_start();
 	resume_console();
diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index 7c75bbb9..1129062 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -309,7 +309,7 @@ void ftrace_syscall_enter(void *ignore, struct pt_regs =
*regs, long id)
 	int syscall_nr;
=20
 	syscall_nr =3D syscall_get_nr(current, regs);
-	if (syscall_nr < 0)
+	if (syscall_nr < 0 || syscall_nr >=3D NR_syscalls)
 		return;
 	if (!test_bit(syscall_nr, enabled_enter_syscalls))
 		return;
@@ -349,7 +349,7 @@ void ftrace_syscall_exit(void *ignore, struct pt_regs *=
regs, long ret)
 	int syscall_nr;
=20
 	syscall_nr =3D syscall_get_nr(current, regs);
-	if (syscall_nr < 0)
+	if (syscall_nr < 0 || syscall_nr >=3D NR_syscalls)
 		return;
 	if (!test_bit(syscall_nr, enabled_exit_syscalls))
 		return;
@@ -519,6 +519,8 @@ static void perf_syscall_enter(void *ignore, struct pt_=
regs *regs, long id)
 	int size;
=20
 	syscall_nr =3D syscall_get_nr(current, regs);
+	if (syscall_nr < 0 || syscall_nr >=3D NR_syscalls)
+		return;
 	if (!test_bit(syscall_nr, enabled_perf_enter_syscalls))
 		return;
=20
@@ -593,6 +595,8 @@ static void perf_syscall_exit(void *ignore, struct pt_r=
egs *regs, long ret)
 	int size;
=20
 	syscall_nr =3D syscall_get_nr(current, regs);
+	if (syscall_nr < 0 || syscall_nr >=3D NR_syscalls)
+		return;
 	if (!test_bit(syscall_nr, enabled_perf_exit_syscalls))
 		return;
=20
diff --git a/lib/bitmap.c b/lib/bitmap.c
index 0d4a127..dbc526f 100644
--- a/lib/bitmap.c
+++ b/lib/bitmap.c
@@ -129,7 +129,9 @@ void __bitmap_shift_right(unsigned long *dst,
 		lower =3D src[off + k];
 		if (left && off + k =3D=3D lim - 1)
 			lower &=3D mask;
-		dst[k] =3D upper << (BITS_PER_LONG - rem) | lower >> rem;
+		dst[k] =3D lower >> rem;
+		if (rem)
+			dst[k] |=3D upper << (BITS_PER_LONG - rem);
 		if (left && k =3D=3D lim - 1)
 			dst[k] &=3D mask;
 	}
@@ -170,7 +172,9 @@ void __bitmap_shift_left(unsigned long *dst,
 		upper =3D src[k];
 		if (left && k =3D=3D lim - 1)
 			upper &=3D (1UL << left) - 1;
-		dst[k + off] =3D lower  >> (BITS_PER_LONG - rem) | upper << rem;
+		dst[k + off] =3D upper << rem;
+		if (rem)
+			dst[k + off] |=3D lower >> (BITS_PER_LONG - rem);
 		if (left && k + off =3D=3D lim - 1)
 			dst[k + off] &=3D (1UL << left) - 1;
 	}
diff --git a/lib/lzo/lzo1x_decompress_safe.c b/lib/lzo/lzo1x_decompress_saf=
e.c
index 8563081..a1c387f 100644
--- a/lib/lzo/lzo1x_decompress_safe.c
+++ b/lib/lzo/lzo1x_decompress_safe.c
@@ -19,31 +19,21 @@
 #include <linux/lzo.h>
 #include "lzodefs.h"
=20
-#define HAVE_IP(t, x)					\
-	(((size_t)(ip_end - ip) >=3D (size_t)(t + x)) &&	\
-	 (((t + x) >=3D t) && ((t + x) >=3D x)))
+#define HAVE_IP(x)      ((size_t)(ip_end - ip) >=3D (size_t)(x))
+#define HAVE_OP(x)      ((size_t)(op_end - op) >=3D (size_t)(x))
+#define NEED_IP(x)      if (!HAVE_IP(x)) goto input_overrun
+#define NEED_OP(x)      if (!HAVE_OP(x)) goto output_overrun
+#define TEST_LB(m_pos)  if ((m_pos) < out) goto lookbehind_overrun
=20
-#define HAVE_OP(t, x)					\
-	(((size_t)(op_end - op) >=3D (size_t)(t + x)) &&	\
-	 (((t + x) >=3D t) && ((t + x) >=3D x)))
-
-#define NEED_IP(t, x)					\
-	do {						\
-		if (!HAVE_IP(t, x))			\
-			goto input_overrun;		\
-	} while (0)
-
-#define NEED_OP(t, x)					\
-	do {						\
-		if (!HAVE_OP(t, x))			\
-			goto output_overrun;		\
-	} while (0)
-
-#define TEST_LB(m_pos)					\
-	do {						\
-		if ((m_pos) < out)			\
-			goto lookbehind_overrun;	\
-	} while (0)
+/* This MAX_255_COUNT is the maximum number of times we can add 255 to a b=
ase
+ * count without overflowing an integer. The multiply will overflow when
+ * multiplying 255 by more than MAXINT/255. The sum will overflow earlier
+ * depending on the base count. Since the base count is taken from a u8
+ * and a few bits, it is safe to assume that it will always be lower than
+ * or equal to 2*255, thus we can always prevent any overflow by accepting
+ * two less 255 steps. See Documentation/lzo.txt for more information.
+ */
+#define MAX_255_COUNT      ((((size_t)~0) / 255) - 2)
=20
 int lzo1x_decompress_safe(const unsigned char *in, size_t in_len,
 			  unsigned char *out, size_t *out_len)
@@ -75,17 +65,24 @@ int lzo1x_decompress_safe(const unsigned char *in, size=
_t in_len,
 		if (t < 16) {
 			if (likely(state =3D=3D 0)) {
 				if (unlikely(t =3D=3D 0)) {
+					size_t offset;
+					const unsigned char *ip_last =3D ip;
+
 					while (unlikely(*ip =3D=3D 0)) {
-						t +=3D 255;
 						ip++;
-						NEED_IP(1, 0);
+						NEED_IP(1);
 					}
-					t +=3D 15 + *ip++;
+					offset =3D ip - ip_last;
+					if (unlikely(offset > MAX_255_COUNT))
+						return LZO_E_ERROR;
+
+					offset =3D (offset << 8) - offset;
+					t +=3D offset + 15 + *ip++;
 				}
 				t +=3D 3;
 copy_literal_run:
 #if defined(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS)
-				if (likely(HAVE_IP(t, 15) && HAVE_OP(t, 15))) {
+				if (likely(HAVE_IP(t + 15) && HAVE_OP(t + 15))) {
 					const unsigned char *ie =3D ip + t;
 					unsigned char *oe =3D op + t;
 					do {
@@ -101,8 +98,8 @@ copy_literal_run:
 				} else
 #endif
 				{
-					NEED_OP(t, 0);
-					NEED_IP(t, 3);
+					NEED_OP(t);
+					NEED_IP(t + 3);
 					do {
 						*op++ =3D *ip++;
 					} while (--t > 0);
@@ -115,7 +112,7 @@ copy_literal_run:
 				m_pos -=3D t >> 2;
 				m_pos -=3D *ip++ << 2;
 				TEST_LB(m_pos);
-				NEED_OP(2, 0);
+				NEED_OP(2);
 				op[0] =3D m_pos[0];
 				op[1] =3D m_pos[1];
 				op +=3D 2;
@@ -136,13 +133,20 @@ copy_literal_run:
 		} else if (t >=3D 32) {
 			t =3D (t & 31) + (3 - 1);
 			if (unlikely(t =3D=3D 2)) {
+				size_t offset;
+				const unsigned char *ip_last =3D ip;
+
 				while (unlikely(*ip =3D=3D 0)) {
-					t +=3D 255;
 					ip++;
-					NEED_IP(1, 0);
+					NEED_IP(1);
 				}
-				t +=3D 31 + *ip++;
-				NEED_IP(2, 0);
+				offset =3D ip - ip_last;
+				if (unlikely(offset > MAX_255_COUNT))
+					return LZO_E_ERROR;
+
+				offset =3D (offset << 8) - offset;
+				t +=3D offset + 31 + *ip++;
+				NEED_IP(2);
 			}
 			m_pos =3D op - 1;
 			next =3D get_unaligned_le16(ip);
@@ -154,13 +158,20 @@ copy_literal_run:
 			m_pos -=3D (t & 8) << 11;
 			t =3D (t & 7) + (3 - 1);
 			if (unlikely(t =3D=3D 2)) {
+				size_t offset;
+				const unsigned char *ip_last =3D ip;
+
 				while (unlikely(*ip =3D=3D 0)) {
-					t +=3D 255;
 					ip++;
-					NEED_IP(1, 0);
+					NEED_IP(1);
 				}
-				t +=3D 7 + *ip++;
-				NEED_IP(2, 0);
+				offset =3D ip - ip_last;
+				if (unlikely(offset > MAX_255_COUNT))
+					return LZO_E_ERROR;
+
+				offset =3D (offset << 8) - offset;
+				t +=3D offset + 7 + *ip++;
+				NEED_IP(2);
 			}
 			next =3D get_unaligned_le16(ip);
 			ip +=3D 2;
@@ -174,7 +185,7 @@ copy_literal_run:
 #if defined(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS)
 		if (op - m_pos >=3D 8) {
 			unsigned char *oe =3D op + t;
-			if (likely(HAVE_OP(t, 15))) {
+			if (likely(HAVE_OP(t + 15))) {
 				do {
 					COPY8(op, m_pos);
 					op +=3D 8;
@@ -184,7 +195,7 @@ copy_literal_run:
 					m_pos +=3D 8;
 				} while (op < oe);
 				op =3D oe;
-				if (HAVE_IP(6, 0)) {
+				if (HAVE_IP(6)) {
 					state =3D next;
 					COPY4(op, ip);
 					op +=3D next;
@@ -192,7 +203,7 @@ copy_literal_run:
 					continue;
 				}
 			} else {
-				NEED_OP(t, 0);
+				NEED_OP(t);
 				do {
 					*op++ =3D *m_pos++;
 				} while (op < oe);
@@ -201,7 +212,7 @@ copy_literal_run:
 #endif
 		{
 			unsigned char *oe =3D op + t;
-			NEED_OP(t, 0);
+			NEED_OP(t);
 			op[0] =3D m_pos[0];
 			op[1] =3D m_pos[1];
 			op +=3D 2;
@@ -214,15 +225,15 @@ match_next:
 		state =3D next;
 		t =3D next;
 #if defined(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS)
-		if (likely(HAVE_IP(6, 0) && HAVE_OP(4, 0))) {
+		if (likely(HAVE_IP(6) && HAVE_OP(4))) {
 			COPY4(op, ip);
 			op +=3D t;
 			ip +=3D t;
 		} else
 #endif
 		{
-			NEED_IP(t, 3);
-			NEED_OP(t, 0);
+			NEED_IP(t + 3);
+			NEED_OP(t);
 			while (t > 0) {
 				*op++ =3D *ip++;
 				t--;
diff --git a/lib/string.c b/lib/string.c
index dc4a863..40136f6 100644
--- a/lib/string.c
+++ b/lib/string.c
@@ -583,6 +583,22 @@ void *memset(void *s, int c, size_t count)
 EXPORT_SYMBOL(memset);
 #endif
=20
+/**
+ * memzero_explicit - Fill a region of memory (e.g. sensitive
+ *		      keying data) with 0s.
+ * @s: Pointer to the start of the area.
+ * @count: The size of the area.
+ *
+ * memzero_explicit() doesn't need an arch-specific version as
+ * it just invokes the one of memset() implicitly.
+ */
+void memzero_explicit(void *s, size_t count)
+{
+	memset(s, 0, count);
+	OPTIMIZER_HIDE_VAR(s);
+}
+EXPORT_SYMBOL(memzero_explicit);
+
 #ifndef __HAVE_ARCH_MEMCPY
 /**
  * memcpy - Copy one area of memory to another
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index ed0ed8a..79166c2 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -682,7 +682,7 @@ int do_huge_pmd_anonymous_page(struct mm_struct *mm, st=
ruct vm_area_struct *vma,
 	if (haddr >=3D vma->vm_start && haddr + HPAGE_PMD_SIZE <=3D vma->vm_end) =
{
 		if (unlikely(anon_vma_prepare(vma)))
 			return VM_FAULT_OOM;
-		if (unlikely(khugepaged_enter(vma)))
+		if (unlikely(khugepaged_enter(vma, vma->vm_flags)))
 			return VM_FAULT_OOM;
 		page =3D alloc_hugepage_vma(transparent_hugepage_defrag(vma),
 					  vma, haddr, numa_node_id(), 0);
@@ -1493,7 +1493,7 @@ int hugepage_madvise(struct vm_area_struct *vma,
 		 * register it here without waiting a page fault that
 		 * may not happen any time soon.
 		 */
-		if (unlikely(khugepaged_enter_vma_merge(vma)))
+		if (unlikely(khugepaged_enter_vma_merge(vma, *vm_flags)))
 			return -ENOMEM;
 		break;
 	case MADV_NOHUGEPAGE:
@@ -1625,7 +1625,8 @@ int __khugepaged_enter(struct mm_struct *mm)
 	return 0;
 }
=20
-int khugepaged_enter_vma_merge(struct vm_area_struct *vma)
+int khugepaged_enter_vma_merge(struct vm_area_struct *vma,
+			       unsigned long vm_flags)
 {
 	unsigned long hstart, hend;
 	if (!vma->anon_vma)
@@ -1641,11 +1642,11 @@ int khugepaged_enter_vma_merge(struct vm_area_struc=
t *vma)
 	 * If is_pfn_mapping() is true is_learn_pfn_mapping() must be
 	 * true too, verify it here.
 	 */
-	VM_BUG_ON(is_linear_pfn_mapping(vma) || vma->vm_flags & VM_NO_THP);
+	VM_BUG_ON(is_linear_pfn_mapping(vma) || vm_flags & VM_NO_THP);
 	hstart =3D (vma->vm_start + ~HPAGE_PMD_MASK) & HPAGE_PMD_MASK;
 	hend =3D vma->vm_end & HPAGE_PMD_MASK;
 	if (hstart < hend)
-		return khugepaged_enter(vma);
+		return khugepaged_enter(vma, vm_flags);
 	return 0;
 }
=20
diff --git a/mm/memory.c b/mm/memory.c
index 483e665..5a7f314 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1178,8 +1178,10 @@ again:
 			if (unlikely(page_mapcount(page) < 0))
 				print_bad_pte(vma, addr, ptent, page);
 			force_flush =3D !__tlb_remove_page(tlb, page);
-			if (force_flush)
+			if (force_flush) {
+				addr +=3D PAGE_SIZE;
 				break;
+			}
 			continue;
 		}
 		/*
diff --git a/mm/mmap.c b/mm/mmap.c
index 6182c8a..f2badbf 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -796,7 +796,7 @@ struct vm_area_struct *vma_merge(struct mm_struct *mm,
 				end, prev->vm_pgoff, NULL);
 		if (err)
 			return NULL;
-		khugepaged_enter_vma_merge(prev);
+		khugepaged_enter_vma_merge(prev, vm_flags);
 		return prev;
 	}
=20
@@ -815,7 +815,7 @@ struct vm_area_struct *vma_merge(struct mm_struct *mm,
 				next->vm_pgoff - pglen, NULL);
 		if (err)
 			return NULL;
-		khugepaged_enter_vma_merge(area);
+		khugepaged_enter_vma_merge(area, vm_flags);
 		return area;
 	}
=20
@@ -1741,7 +1741,7 @@ int expand_upwards(struct vm_area_struct *vma, unsign=
ed long address)
 		}
 	}
 	vma_unlock_anon_vma(vma);
-	khugepaged_enter_vma_merge(vma);
+	khugepaged_enter_vma_merge(vma, vma->vm_flags);
 	return error;
 }
 #endif /* CONFIG_STACK_GROWSUP || CONFIG_IA64 */
@@ -1792,7 +1792,7 @@ int expand_downwards(struct vm_area_struct *vma,
 		}
 	}
 	vma_unlock_anon_vma(vma);
-	khugepaged_enter_vma_merge(vma);
+	khugepaged_enter_vma_merge(vma, vma->vm_flags);
 	return error;
 }
=20
diff --git a/mm/page_cgroup.c b/mm/page_cgroup.c
index 2d123f9..6f4ef53 100644
--- a/mm/page_cgroup.c
+++ b/mm/page_cgroup.c
@@ -160,6 +160,7 @@ static void free_page_cgroup(void *addr)
 			sizeof(struct page_cgroup) * PAGES_PER_SECTION;
=20
 		BUG_ON(PageReserved(page));
+		kmemleak_free(addr);
 		free_pages_exact(addr, table_size);
 	}
 }
diff --git a/mm/truncate.c b/mm/truncate.c
index 40d186f..143883a 100644
--- a/mm/truncate.c
+++ b/mm/truncate.c
@@ -20,6 +20,7 @@
 #include <linux/buffer_head.h>	/* grr. try_to_release_page,
 				   do_invalidatepage */
 #include <linux/cleancache.h>
+#include <linux/rmap.h>
 #include "internal.h"
=20
=20
@@ -575,12 +576,64 @@ void truncate_setsize(struct inode *inode, loff_t new=
size)
=20
 	oldsize =3D inode->i_size;
 	i_size_write(inode, newsize);
-
+	if (newsize > oldsize)
+		pagecache_isize_extended(inode, oldsize, newsize);
 	truncate_pagecache(inode, oldsize, newsize);
 }
 EXPORT_SYMBOL(truncate_setsize);
=20
 /**
+ * pagecache_isize_extended - update pagecache after extension of i_size
+ * @inode:	inode for which i_size was extended
+ * @from:	original inode size
+ * @to:		new inode size
+ *
+ * Handle extension of inode size either caused by extending truncate or b=
y
+ * write starting after current i_size. We mark the page straddling curren=
t
+ * i_size RO so that page_mkwrite() is called on the nearest write access =
to
+ * the page.  This way filesystem can be sure that page_mkwrite() is calle=
d on
+ * the page before user writes to the page via mmap after the i_size has b=
een
+ * changed.
+ *
+ * The function must be called after i_size is updated so that page fault
+ * coming after we unlock the page will already see the new i_size.
+ * The function must be called while we still hold i_mutex - this not only
+ * makes sure i_size is stable but also that userspace cannot observe new
+ * i_size value before we are prepared to store mmap writes at new inode s=
ize.
+ */
+void pagecache_isize_extended(struct inode *inode, loff_t from, loff_t to)
+{
+	int bsize =3D 1 << inode->i_blkbits;
+	loff_t rounded_from;
+	struct page *page;
+	pgoff_t index;
+
+	WARN_ON(to > inode->i_size);
+
+	if (from >=3D to || bsize =3D=3D PAGE_CACHE_SIZE)
+		return;
+	/* Page straddling @from will not have any hole block created? */
+	rounded_from =3D round_up(from, bsize);
+	if (to <=3D rounded_from || !(rounded_from & (PAGE_CACHE_SIZE - 1)))
+		return;
+
+	index =3D from >> PAGE_CACHE_SHIFT;
+	page =3D find_lock_page(inode->i_mapping, index);
+	/* Page not cached? Nothing to do */
+	if (!page)
+		return;
+	/*
+	 * See clear_page_dirty_for_io() for details why set_page_dirty()
+	 * is needed.
+	 */
+	if (page_mkclean(page))
+		set_page_dirty(page);
+	unlock_page(page);
+	page_cache_release(page);
+}
+EXPORT_SYMBOL(pagecache_isize_extended);
+
+/**
  * vmtruncate - unmap mappings "freed" by truncate() syscall
  * @inode: inode of the file used
  * @newsize: file offset to start truncating
diff --git a/net/ceph/crypto.c b/net/ceph/crypto.c
index 85f3bc0..21e777b 100644
--- a/net/ceph/crypto.c
+++ b/net/ceph/crypto.c
@@ -90,11 +90,82 @@ static struct crypto_blkcipher *ceph_crypto_alloc_ciphe=
r(void)
=20
 static const u8 *aes_iv =3D (u8 *)CEPH_AES_IV;
=20
+/*
+ * Should be used for buffers allocated with ceph_kvmalloc().
+ * Currently these are encrypt out-buffer (ceph_buffer) and decrypt
+ * in-buffer (msg front).
+ *
+ * Dispose of @sgt with teardown_sgtable().
+ *
+ * @prealloc_sg is to avoid memory allocation inside sg_alloc_table()
+ * in cases where a single sg is sufficient.  No attempt to reduce the
+ * number of sgs by squeezing physically contiguous pages together is
+ * made though, for simplicity.
+ */
+static int setup_sgtable(struct sg_table *sgt, struct scatterlist *preallo=
c_sg,
+			 const void *buf, unsigned int buf_len)
+{
+	struct scatterlist *sg;
+	const bool is_vmalloc =3D is_vmalloc_addr(buf);
+	unsigned int off =3D offset_in_page(buf);
+	unsigned int chunk_cnt =3D 1;
+	unsigned int chunk_len =3D PAGE_ALIGN(off + buf_len);
+	int i;
+	int ret;
+
+	if (buf_len =3D=3D 0) {
+		memset(sgt, 0, sizeof(*sgt));
+		return -EINVAL;
+	}
+
+	if (is_vmalloc) {
+		chunk_cnt =3D chunk_len >> PAGE_SHIFT;
+		chunk_len =3D PAGE_SIZE;
+	}
+
+	if (chunk_cnt > 1) {
+		ret =3D sg_alloc_table(sgt, chunk_cnt, GFP_NOFS);
+		if (ret)
+			return ret;
+	} else {
+		WARN_ON(chunk_cnt !=3D 1);
+		sg_init_table(prealloc_sg, 1);
+		sgt->sgl =3D prealloc_sg;
+		sgt->nents =3D sgt->orig_nents =3D 1;
+	}
+
+	for_each_sg(sgt->sgl, sg, sgt->orig_nents, i) {
+		struct page *page;
+		unsigned int len =3D min(chunk_len - off, buf_len);
+
+		if (is_vmalloc)
+			page =3D vmalloc_to_page(buf);
+		else
+			page =3D virt_to_page(buf);
+
+		sg_set_page(sg, page, len, off);
+
+		off =3D 0;
+		buf +=3D len;
+		buf_len -=3D len;
+	}
+	WARN_ON(buf_len !=3D 0);
+
+	return 0;
+}
+
+static void teardown_sgtable(struct sg_table *sgt)
+{
+	if (sgt->orig_nents > 1)
+		sg_free_table(sgt);
+}
+
 static int ceph_aes_encrypt(const void *key, int key_len,
 			    void *dst, size_t *dst_len,
 			    const void *src, size_t src_len)
 {
-	struct scatterlist sg_in[2], sg_out[1];
+	struct scatterlist sg_in[2], prealloc_sg;
+	struct sg_table sg_out;
 	struct crypto_blkcipher *tfm =3D ceph_crypto_alloc_cipher();
 	struct blkcipher_desc desc =3D { .tfm =3D tfm, .flags =3D 0 };
 	int ret;
@@ -110,16 +181,18 @@ static int ceph_aes_encrypt(const void *key, int key_=
len,
=20
 	*dst_len =3D src_len + zero_padding;
=20
-	crypto_blkcipher_setkey((void *)tfm, key, key_len);
 	sg_init_table(sg_in, 2);
 	sg_set_buf(&sg_in[0], src, src_len);
 	sg_set_buf(&sg_in[1], pad, zero_padding);
-	sg_init_table(sg_out, 1);
-	sg_set_buf(sg_out, dst, *dst_len);
+	ret =3D setup_sgtable(&sg_out, &prealloc_sg, dst, *dst_len);
+	if (ret)
+		goto out_tfm;
+
+	crypto_blkcipher_setkey((void *)tfm, key, key_len);
 	iv =3D crypto_blkcipher_crt(tfm)->iv;
 	ivsize =3D crypto_blkcipher_ivsize(tfm);
-
 	memcpy(iv, aes_iv, ivsize);
+
 	/*
 	print_hex_dump(KERN_ERR, "enc key: ", DUMP_PREFIX_NONE, 16, 1,
 		       key, key_len, 1);
@@ -128,16 +201,22 @@ static int ceph_aes_encrypt(const void *key, int key_=
len,
 	print_hex_dump(KERN_ERR, "enc pad: ", DUMP_PREFIX_NONE, 16, 1,
 			pad, zero_padding, 1);
 	*/
-	ret =3D crypto_blkcipher_encrypt(&desc, sg_out, sg_in,
+	ret =3D crypto_blkcipher_encrypt(&desc, sg_out.sgl, sg_in,
 				     src_len + zero_padding);
-	crypto_free_blkcipher(tfm);
-	if (ret < 0)
+	if (ret < 0) {
 		pr_err("ceph_aes_crypt failed %d\n", ret);
+		goto out_sg;
+	}
 	/*
 	print_hex_dump(KERN_ERR, "enc out: ", DUMP_PREFIX_NONE, 16, 1,
 		       dst, *dst_len, 1);
 	*/
-	return 0;
+
+out_sg:
+	teardown_sgtable(&sg_out);
+out_tfm:
+	crypto_free_blkcipher(tfm);
+	return ret;
 }
=20
 static int ceph_aes_encrypt2(const void *key, int key_len, void *dst,
@@ -145,7 +224,8 @@ static int ceph_aes_encrypt2(const void *key, int key_l=
en, void *dst,
 			     const void *src1, size_t src1_len,
 			     const void *src2, size_t src2_len)
 {
-	struct scatterlist sg_in[3], sg_out[1];
+	struct scatterlist sg_in[3], prealloc_sg;
+	struct sg_table sg_out;
 	struct crypto_blkcipher *tfm =3D ceph_crypto_alloc_cipher();
 	struct blkcipher_desc desc =3D { .tfm =3D tfm, .flags =3D 0 };
 	int ret;
@@ -161,17 +241,19 @@ static int ceph_aes_encrypt2(const void *key, int key=
_len, void *dst,
=20
 	*dst_len =3D src1_len + src2_len + zero_padding;
=20
-	crypto_blkcipher_setkey((void *)tfm, key, key_len);
 	sg_init_table(sg_in, 3);
 	sg_set_buf(&sg_in[0], src1, src1_len);
 	sg_set_buf(&sg_in[1], src2, src2_len);
 	sg_set_buf(&sg_in[2], pad, zero_padding);
-	sg_init_table(sg_out, 1);
-	sg_set_buf(sg_out, dst, *dst_len);
+	ret =3D setup_sgtable(&sg_out, &prealloc_sg, dst, *dst_len);
+	if (ret)
+		goto out_tfm;
+
+	crypto_blkcipher_setkey((void *)tfm, key, key_len);
 	iv =3D crypto_blkcipher_crt(tfm)->iv;
 	ivsize =3D crypto_blkcipher_ivsize(tfm);
-
 	memcpy(iv, aes_iv, ivsize);
+
 	/*
 	print_hex_dump(KERN_ERR, "enc  key: ", DUMP_PREFIX_NONE, 16, 1,
 		       key, key_len, 1);
@@ -182,23 +264,30 @@ static int ceph_aes_encrypt2(const void *key, int key=
_len, void *dst,
 	print_hex_dump(KERN_ERR, "enc  pad: ", DUMP_PREFIX_NONE, 16, 1,
 			pad, zero_padding, 1);
 	*/
-	ret =3D crypto_blkcipher_encrypt(&desc, sg_out, sg_in,
+	ret =3D crypto_blkcipher_encrypt(&desc, sg_out.sgl, sg_in,
 				     src1_len + src2_len + zero_padding);
-	crypto_free_blkcipher(tfm);
-	if (ret < 0)
+	if (ret < 0) {
 		pr_err("ceph_aes_crypt2 failed %d\n", ret);
+		goto out_sg;
+	}
 	/*
 	print_hex_dump(KERN_ERR, "enc  out: ", DUMP_PREFIX_NONE, 16, 1,
 		       dst, *dst_len, 1);
 	*/
-	return 0;
+
+out_sg:
+	teardown_sgtable(&sg_out);
+out_tfm:
+	crypto_free_blkcipher(tfm);
+	return ret;
 }
=20
 static int ceph_aes_decrypt(const void *key, int key_len,
 			    void *dst, size_t *dst_len,
 			    const void *src, size_t src_len)
 {
-	struct scatterlist sg_in[1], sg_out[2];
+	struct sg_table sg_in;
+	struct scatterlist sg_out[2], prealloc_sg;
 	struct crypto_blkcipher *tfm =3D ceph_crypto_alloc_cipher();
 	struct blkcipher_desc desc =3D { .tfm =3D tfm };
 	char pad[16];
@@ -210,16 +299,16 @@ static int ceph_aes_decrypt(const void *key, int key_=
len,
 	if (IS_ERR(tfm))
 		return PTR_ERR(tfm);
=20
-	crypto_blkcipher_setkey((void *)tfm, key, key_len);
-	sg_init_table(sg_in, 1);
 	sg_init_table(sg_out, 2);
-	sg_set_buf(sg_in, src, src_len);
 	sg_set_buf(&sg_out[0], dst, *dst_len);
 	sg_set_buf(&sg_out[1], pad, sizeof(pad));
+	ret =3D setup_sgtable(&sg_in, &prealloc_sg, src, src_len);
+	if (ret)
+		goto out_tfm;
=20
+	crypto_blkcipher_setkey((void *)tfm, key, key_len);
 	iv =3D crypto_blkcipher_crt(tfm)->iv;
 	ivsize =3D crypto_blkcipher_ivsize(tfm);
-
 	memcpy(iv, aes_iv, ivsize);
=20
 	/*
@@ -228,12 +317,10 @@ static int ceph_aes_decrypt(const void *key, int key_=
len,
 	print_hex_dump(KERN_ERR, "dec  in: ", DUMP_PREFIX_NONE, 16, 1,
 		       src, src_len, 1);
 	*/
-
-	ret =3D crypto_blkcipher_decrypt(&desc, sg_out, sg_in, src_len);
-	crypto_free_blkcipher(tfm);
+	ret =3D crypto_blkcipher_decrypt(&desc, sg_out, sg_in.sgl, src_len);
 	if (ret < 0) {
 		pr_err("ceph_aes_decrypt failed %d\n", ret);
-		return ret;
+		goto out_sg;
 	}
=20
 	if (src_len <=3D *dst_len)
@@ -251,7 +338,12 @@ static int ceph_aes_decrypt(const void *key, int key_l=
en,
 	print_hex_dump(KERN_ERR, "dec out: ", DUMP_PREFIX_NONE, 16, 1,
 		       dst, *dst_len, 1);
 	*/
-	return 0;
+
+out_sg:
+	teardown_sgtable(&sg_in);
+out_tfm:
+	crypto_free_blkcipher(tfm);
+	return ret;
 }
=20
 static int ceph_aes_decrypt2(const void *key, int key_len,
@@ -259,7 +351,8 @@ static int ceph_aes_decrypt2(const void *key, int key_l=
en,
 			     void *dst2, size_t *dst2_len,
 			     const void *src, size_t src_len)
 {
-	struct scatterlist sg_in[1], sg_out[3];
+	struct sg_table sg_in;
+	struct scatterlist sg_out[3], prealloc_sg;
 	struct crypto_blkcipher *tfm =3D ceph_crypto_alloc_cipher();
 	struct blkcipher_desc desc =3D { .tfm =3D tfm };
 	char pad[16];
@@ -271,17 +364,17 @@ static int ceph_aes_decrypt2(const void *key, int key=
_len,
 	if (IS_ERR(tfm))
 		return PTR_ERR(tfm);
=20
-	sg_init_table(sg_in, 1);
-	sg_set_buf(sg_in, src, src_len);
 	sg_init_table(sg_out, 3);
 	sg_set_buf(&sg_out[0], dst1, *dst1_len);
 	sg_set_buf(&sg_out[1], dst2, *dst2_len);
 	sg_set_buf(&sg_out[2], pad, sizeof(pad));
+	ret =3D setup_sgtable(&sg_in, &prealloc_sg, src, src_len);
+	if (ret)
+		goto out_tfm;
=20
 	crypto_blkcipher_setkey((void *)tfm, key, key_len);
 	iv =3D crypto_blkcipher_crt(tfm)->iv;
 	ivsize =3D crypto_blkcipher_ivsize(tfm);
-
 	memcpy(iv, aes_iv, ivsize);
=20
 	/*
@@ -290,12 +383,10 @@ static int ceph_aes_decrypt2(const void *key, int key=
_len,
 	print_hex_dump(KERN_ERR, "dec   in: ", DUMP_PREFIX_NONE, 16, 1,
 		       src, src_len, 1);
 	*/
-
-	ret =3D crypto_blkcipher_decrypt(&desc, sg_out, sg_in, src_len);
-	crypto_free_blkcipher(tfm);
+	ret =3D crypto_blkcipher_decrypt(&desc, sg_out, sg_in.sgl, src_len);
 	if (ret < 0) {
 		pr_err("ceph_aes_decrypt failed %d\n", ret);
-		return ret;
+		goto out_sg;
 	}
=20
 	if (src_len <=3D *dst1_len)
@@ -325,7 +416,11 @@ static int ceph_aes_decrypt2(const void *key, int key_=
len,
 		       dst2, *dst2_len, 1);
 	*/
=20
-	return 0;
+out_sg:
+	teardown_sgtable(&sg_in);
+out_tfm:
+	crypto_free_blkcipher(tfm);
+	return ret;
 }
=20
=20
diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
index 7a239f0..e85a8d2 100644
--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -99,7 +99,12 @@ struct workqueue_struct *ceph_msgr_wq;
=20
 int ceph_msgr_init(void)
 {
-	ceph_msgr_wq =3D alloc_workqueue("ceph-msgr", WQ_NON_REENTRANT, 0);
+	/*
+	 * The number of active work items is limited by the number of
+	 * connections, so leave @max_active at default.
+	 */
+	ceph_msgr_wq =3D alloc_workqueue("ceph-msgr",
+				       WQ_NON_REENTRANT | WQ_MEM_RECLAIM, 0);
 	if (!ceph_msgr_wq) {
 		pr_err("msgr_init failed to create workqueue\n");
 		return -ENOMEM;
diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index 223085f..115157b 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -1333,11 +1333,11 @@ struct sk_buff *__ip_make_skb(struct sock *sk,
 	iph->ihl =3D 5;
 	iph->tos =3D inet->tos;
 	iph->frag_off =3D df;
-	ip_select_ident(skb, sk);
 	iph->ttl =3D ttl;
 	iph->protocol =3D sk->sk_protocol;
 	iph->saddr =3D fl4->saddr;
 	iph->daddr =3D fl4->daddr;
+	ip_select_ident(skb, sk);
=20
 	if (opt) {
 		iph->ihl +=3D opt->optlen>>2;
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 92d7138..26eb8e2 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1352,7 +1352,7 @@ int tcp_v4_conn_request(struct sock *sk, struct sk_bu=
ff *skb)
 		goto drop_and_free;
=20
 	if (!want_cookie || tmp_opt.tstamp_ok)
-		TCP_ECN_create_request(req, tcp_hdr(skb));
+		TCP_ECN_create_request(req, skb);
=20
 	if (want_cookie) {
 		isn =3D cookie_v4_init_sequence(sk, skb, &req->mss);
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index c69358c..057a9d2 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -1254,7 +1254,7 @@ static int tcp_v6_conn_request(struct sock *sk, struc=
t sk_buff *skb)
 	ipv6_addr_copy(&treq->rmt_addr, &ipv6_hdr(skb)->saddr);
 	ipv6_addr_copy(&treq->loc_addr, &ipv6_hdr(skb)->daddr);
 	if (!want_cookie || tmp_opt.tstamp_ok)
-		TCP_ECN_create_request(req, tcp_hdr(skb));
+		TCP_ECN_create_request(req, skb);
=20
 	treq->iif =3D sk->sk_bound_dev_if;
=20
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 8260cd5..24ec86f 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -382,10 +382,12 @@ static void ieee80211_do_stop(struct ieee80211_sub_if=
_data *sdata,
 	u32 hw_reconf_flags =3D 0;
 	int i;
 	enum nl80211_channel_type orig_ct;
+	bool cancel_scan;
=20
 	clear_bit(SDATA_STATE_RUNNING, &sdata->state);
=20
-	if (local->scan_sdata =3D=3D sdata)
+	cancel_scan =3D local->scan_sdata =3D=3D sdata;
+	if (cancel_scan)
 		ieee80211_scan_cancel(local);
=20
 	/*
@@ -543,6 +545,9 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_d=
ata *sdata,
=20
 	ieee80211_recalc_ps(local, -1);
=20
+	if (cancel_scan)
+		flush_delayed_work(&local->scan_work);
+
 	if (local->open_count =3D=3D 0) {
 		if (local->ops->napi_poll)
 			napi_disable(&local->napi);
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 71d8564..2064612 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1470,11 +1470,14 @@ ieee80211_rx_h_defragment(struct ieee80211_rx_data =
*rx)
 	sc =3D le16_to_cpu(hdr->seq_ctrl);
 	frag =3D sc & IEEE80211_SCTL_FRAG;
=20
-	if (likely((!ieee80211_has_morefrags(fc) && frag =3D=3D 0) ||
-		   is_multicast_ether_addr(hdr->addr1))) {
-		/* not fragmented */
+	if (likely(!ieee80211_has_morefrags(fc) && frag =3D=3D 0))
+		goto out;
+
+	if (is_multicast_ether_addr(hdr->addr1)) {
+		rx->local->dot11MulticastReceivedFrameCount++;
 		goto out;
 	}
+
 	I802_DEBUG_INC(rx->local->rx_handlers_fragments);
=20
 	if (skb_linearize(rx->skb))
@@ -1567,10 +1570,7 @@ ieee80211_rx_h_defragment(struct ieee80211_rx_data *=
rx)
  out:
 	if (rx->sta)
 		rx->sta->rx_packets++;
-	if (is_multicast_ether_addr(hdr->addr1))
-		rx->local->dot11MulticastReceivedFrameCount++;
-	else
-		ieee80211_led_rx(rx->local);
+	ieee80211_led_rx(rx->local);
 	return RX_CONTINUE;
 }
=20
diff --git a/net/sunrpc/svcsock.c b/net/sunrpc/svcsock.c
index 296192c..5e3080c 100644
--- a/net/sunrpc/svcsock.c
+++ b/net/sunrpc/svcsock.c
@@ -1054,17 +1054,12 @@ static int receive_cb_reply(struct svc_sock *svsk, =
struct svc_rqst *rqstp)
 	xid =3D *p++;
 	calldir =3D *p;
=20
-	if (bc_xprt)
-		req =3D xprt_lookup_rqst(bc_xprt, xid);
-
-	if (!req) {
-		printk(KERN_NOTICE
-			"%s: Got unrecognized reply: "
-			"calldir 0x%x xpt_bc_xprt %p xid %08x\n",
-			__func__, ntohl(calldir),
-			bc_xprt, xid);
+	if (!bc_xprt)
 		return -EAGAIN;
-	}
+	spin_lock_bh(&bc_xprt->transport_lock);
+	req =3D xprt_lookup_rqst(bc_xprt, xid);
+	if (!req)
+		goto unlock_notfound;
=20
 	memcpy(&req->rq_private_buf, &req->rq_rcv_buf, sizeof(struct xdr_buf));
 	/*
@@ -1075,11 +1070,21 @@ static int receive_cb_reply(struct svc_sock *svsk, =
struct svc_rqst *rqstp)
 	dst =3D &req->rq_private_buf.head[0];
 	src =3D &rqstp->rq_arg.head[0];
 	if (dst->iov_len < src->iov_len)
-		return -EAGAIN; /* whatever; just giving up. */
+		goto unlock_eagain; /* whatever; just giving up. */
 	memcpy(dst->iov_base, src->iov_base, src->iov_len);
 	xprt_complete_rqst(req->rq_task, svsk->sk_reclen);
 	rqstp->rq_arg.len =3D 0;
+	spin_unlock_bh(&bc_xprt->transport_lock);
 	return 0;
+unlock_notfound:
+	printk(KERN_NOTICE
+		"%s: Got unrecognized reply: "
+		"calldir 0x%x xpt_bc_xprt %p xid %08x\n",
+		__func__, ntohl(calldir),
+		bc_xprt, ntohl(xid));
+unlock_eagain:
+	spin_unlock_bh(&bc_xprt->transport_lock);
+	return -EAGAIN;
 }
=20
 static int copy_pages_to_kvecs(struct kvec *vec, struct page **pages, int =
len)
diff --git a/security/integrity/evm/evm_main.c b/security/integrity/evm/evm=
_main.c
index 3439872..0d29603 100644
--- a/security/integrity/evm/evm_main.c
+++ b/security/integrity/evm/evm_main.c
@@ -218,9 +218,12 @@ int evm_inode_setxattr(struct dentry *dentry, const ch=
ar *xattr_name,
 {
 	const struct evm_ima_xattr_data *xattr_data =3D xattr_value;
=20
-	if ((strcmp(xattr_name, XATTR_NAME_EVM) =3D=3D 0)
-	    && (xattr_data->type =3D=3D EVM_XATTR_HMAC))
-		return -EPERM;
+	if (strcmp(xattr_name, XATTR_NAME_EVM) =3D=3D 0) {
+		if (!xattr_value_len)
+			return -EINVAL;
+		if (xattr_data->type !=3D EVM_IMA_XATTR_DIGSIG)
+			return -EPERM;
+	}
 	return evm_protect_xattr(dentry, xattr_name, xattr_value,
 				 xattr_value_len);
 }
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 69477ff..0cd7097a 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -435,6 +435,7 @@ next_inode:
 				list_entry(sbsec->isec_head.next,
 					   struct inode_security_struct, list);
 		struct inode *inode =3D isec->inode;
+		list_del_init(&isec->list);
 		spin_unlock(&sbsec->isec_lock);
 		inode =3D igrab(inode);
 		if (inode) {
@@ -443,7 +444,6 @@ next_inode:
 			iput(inode);
 		}
 		spin_lock(&sbsec->isec_lock);
-		list_del_init(&isec->list);
 		goto next_inode;
 	}
 	spin_unlock(&sbsec->isec_lock);
diff --git a/sound/core/pcm_compat.c b/sound/core/pcm_compat.c
index 91cdf94..4dbb66e 100644
--- a/sound/core/pcm_compat.c
+++ b/sound/core/pcm_compat.c
@@ -204,6 +204,8 @@ static int snd_pcm_status_user_compat(struct snd_pcm_su=
bstream *substream,
 	if (err < 0)
 		return err;
=20
+	if (clear_user(src, sizeof(*src)))
+		return -EFAULT;
 	if (put_user(status.state, &src->state) ||
 	    put_user(status.trigger_tstamp.tv_sec, &src->trigger_tstamp.tv_sec) |=
|
 	    put_user(status.trigger_tstamp.tv_nsec, &src->trigger_tstamp.tv_nsec)=
 ||
diff --git a/sound/pci/emu10k1/emu10k1_callback.c b/sound/pci/emu10k1/emu10=
k1_callback.c
index a0afa50..f35284b 100644
--- a/sound/pci/emu10k1/emu10k1_callback.c
+++ b/sound/pci/emu10k1/emu10k1_callback.c
@@ -85,6 +85,8 @@ snd_emu10k1_ops_setup(struct snd_emux *emux)
  * get more voice for pcm
  *
  * terminate most inactive voice and give it as a pcm voice.
+ *
+ * voice_lock is already held.
  */
 int
 snd_emu10k1_synth_get_voice(struct snd_emu10k1 *hw)
@@ -92,12 +94,10 @@ snd_emu10k1_synth_get_voice(struct snd_emu10k1 *hw)
 	struct snd_emux *emu;
 	struct snd_emux_voice *vp;
 	struct best_voice best[V_END];
-	unsigned long flags;
 	int i;
=20
 	emu =3D hw->synth;
=20
-	spin_lock_irqsave(&emu->voice_lock, flags);
 	lookup_voices(emu, hw, best, 1); /* no OFF voices */
 	for (i =3D 0; i < V_END; i++) {
 		if (best[i].voice >=3D 0) {
@@ -113,11 +113,9 @@ snd_emu10k1_synth_get_voice(struct snd_emu10k1 *hw)
 			vp->emu->num_voices--;
 			vp->ch =3D -1;
 			vp->state =3D SNDRV_EMUX_ST_OFF;
-			spin_unlock_irqrestore(&emu->voice_lock, flags);
 			return ch;
 		}
 	}
-	spin_unlock_irqrestore(&emu->voice_lock, flags);
=20
 	/* not found */
 	return -ENOMEM;
diff --git a/sound/pci/hda/hda_intel.c b/sound/pci/hda/hda_intel.c
index fea6895..dcc95c5 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -2667,6 +2667,7 @@ static int __devinit azx_create(struct snd_card *card=
, struct pci_dev *pci,
 	struct azx *chip;
 	int i, err;
 	unsigned short gcap;
+	unsigned int dma_bits =3D 64;
 	static struct snd_device_ops ops =3D {
 		.dev_free =3D azx_dev_free,
 	};
@@ -2754,9 +2755,14 @@ static int __devinit azx_create(struct snd_card *car=
d, struct pci_dev *pci,
 	gcap =3D azx_readw(chip, GCAP);
 	snd_printdd(SFX "chipset global capabilities =3D 0x%x\n", gcap);
=20
+	/* AMD devices support 40 or 48bit DMA, take the safe one */
+	if (chip->pci->vendor =3D=3D PCI_VENDOR_ID_AMD)
+		dma_bits =3D 40;
+
 	/* disable SB600 64bit support for safety */
 	if (chip->pci->vendor =3D=3D PCI_VENDOR_ID_ATI) {
 		struct pci_dev *p_smbus;
+		dma_bits =3D 40;
 		p_smbus =3D pci_get_device(PCI_VENDOR_ID_ATI,
 					 PCI_DEVICE_ID_ATI_SBX00_SMBUS,
 					 NULL);
@@ -2779,9 +2785,11 @@ static int __devinit azx_create(struct snd_card *car=
d, struct pci_dev *pci,
 		chip->align_buffer_size =3D 0;
=20
 	/* allow 64bit DMA address if supported by H/W */
-	if ((gcap & ICH6_GCAP_64OK) && !pci_set_dma_mask(pci, DMA_BIT_MASK(64)))
-		pci_set_consistent_dma_mask(pci, DMA_BIT_MASK(64));
-	else {
+	if (!(gcap & ICH6_GCAP_64OK))
+		dma_bits =3D 32;
+	if (!pci_set_dma_mask(pci, DMA_BIT_MASK(dma_bits))) {
+		pci_set_consistent_dma_mask(pci, DMA_BIT_MASK(dma_bits));
+	} else {
 		pci_set_dma_mask(pci, DMA_BIT_MASK(32));
 		pci_set_consistent_dma_mask(pci, DMA_BIT_MASK(32));
 	}
diff --git a/sound/soc/codecs/sgtl5000.c b/sound/soc/codecs/sgtl5000.c
index b5d4a97..c8cdf91 100644
--- a/sound/soc/codecs/sgtl5000.c
+++ b/sound/soc/codecs/sgtl5000.c
@@ -1304,8 +1304,7 @@ static int sgtl5000_probe(struct snd_soc_codec *codec=
)
=20
 	/* enable small pop, introduce 400ms delay in turning off */
 	snd_soc_update_bits(codec, SGTL5000_CHIP_REF_CTRL,
-				SGTL5000_SMALL_POP,
-				SGTL5000_SMALL_POP);
+				SGTL5000_SMALL_POP, 1);
=20
 	/* disable short cut detector */
 	snd_soc_write(codec, SGTL5000_CHIP_SHORT_CTRL, 0);
diff --git a/sound/soc/codecs/sgtl5000.h b/sound/soc/codecs/sgtl5000.h
index d3a68bb..0bd6e1c 100644
--- a/sound/soc/codecs/sgtl5000.h
+++ b/sound/soc/codecs/sgtl5000.h
@@ -275,7 +275,7 @@
 #define SGTL5000_BIAS_CTRL_MASK			0x000e
 #define SGTL5000_BIAS_CTRL_SHIFT		1
 #define SGTL5000_BIAS_CTRL_WIDTH		3
-#define SGTL5000_SMALL_POP			0x0001
+#define SGTL5000_SMALL_POP			0
=20
 /*
  * SGTL5000_CHIP_MIC_CTRL
diff --git a/sound/soc/sh/fsi.c b/sound/soc/sh/fsi.c
index 3d7016e..4a2c639 100644
--- a/sound/soc/sh/fsi.c
+++ b/sound/soc/sh/fsi.c
@@ -1096,8 +1096,7 @@ static struct snd_soc_dai_ops fsi_dai_ops =3D {
 static struct snd_pcm_hardware fsi_pcm_hardware =3D {
 	.info =3D		SNDRV_PCM_INFO_INTERLEAVED	|
 			SNDRV_PCM_INFO_MMAP		|
-			SNDRV_PCM_INFO_MMAP_VALID	|
-			SNDRV_PCM_INFO_PAUSE,
+			SNDRV_PCM_INFO_MMAP_VALID,
 	.formats		=3D FSI_FMTS,
 	.rates			=3D FSI_RATES,
 	.rate_min		=3D 8000,
diff --git a/sound/usb/card.c b/sound/usb/card.c
index 3b79a4a..b3ac389 100644
--- a/sound/usb/card.c
+++ b/sound/usb/card.c
@@ -568,18 +568,19 @@ static void snd_usb_audio_disconnect(struct usb_devic=
e *dev,
 {
 	struct snd_card *card;
 	struct list_head *p;
+	bool was_shutdown;
=20
 	if (chip =3D=3D (void *)-1L)
 		return;
=20
 	card =3D chip->card;
 	down_write(&chip->shutdown_rwsem);
+	was_shutdown =3D chip->shutdown;
 	chip->shutdown =3D 1;
 	up_write(&chip->shutdown_rwsem);
=20
 	mutex_lock(&register_mutex);
-	chip->num_interfaces--;
-	if (chip->num_interfaces <=3D 0) {
+	if (!was_shutdown) {
 		snd_card_disconnect(card);
 		/* release the pcm resources */
 		list_for_each(p, &chip->pcm_list) {
@@ -593,6 +594,10 @@ static void snd_usb_audio_disconnect(struct usb_device=
 *dev,
 		list_for_each(p, &chip->mixer_list) {
 			snd_usb_mixer_disconnect(p);
 		}
+	}
+
+	chip->num_interfaces--;
+	if (chip->num_interfaces <=3D 0) {
 		usb_chip[chip->index] =3D NULL;
 		mutex_unlock(&register_mutex);
 		snd_card_free_when_closed(card);
diff --git a/virt/kvm/iommu.c b/virt/kvm/iommu.c
index c946700..e32c93c 100644
--- a/virt/kvm/iommu.c
+++ b/virt/kvm/iommu.c
@@ -43,13 +43,13 @@ static void kvm_iommu_put_pages(struct kvm *kvm,
 				gfn_t base_gfn, unsigned long npages);
=20
 static pfn_t kvm_pin_pages(struct kvm *kvm, struct kvm_memory_slot *slot,
-			   gfn_t gfn, unsigned long size)
+			   gfn_t gfn, unsigned long npages)
 {
 	gfn_t end_gfn;
 	pfn_t pfn;
=20
 	pfn     =3D gfn_to_pfn_memslot(kvm, slot, gfn);
-	end_gfn =3D gfn + (size >> PAGE_SHIFT);
+	end_gfn =3D gfn + npages;
 	gfn    +=3D 1;
=20
 	if (is_error_pfn(pfn))
@@ -117,7 +117,7 @@ int kvm_iommu_map_pages(struct kvm *kvm, struct kvm_mem=
ory_slot *slot)
 		 * Pin all pages we are about to map in memory. This is
 		 * important because we unmap and unpin in 4kb steps later.
 		 */
-		pfn =3D kvm_pin_pages(kvm, slot, gfn, page_size);
+		pfn =3D kvm_pin_pages(kvm, slot, gfn, page_size >> PAGE_SHIFT);
 		if (is_error_pfn(pfn)) {
 			gfn +=3D 1;
 			continue;
@@ -129,7 +129,7 @@ int kvm_iommu_map_pages(struct kvm *kvm, struct kvm_mem=
ory_slot *slot)
 		if (r) {
 			printk(KERN_ERR "kvm_iommu_map_address:"
 			       "iommu failed to map pfn=3D%llx\n", pfn);
-			kvm_unpin_pages(kvm, pfn, page_size);
+			kvm_unpin_pages(kvm, pfn, page_size >> PAGE_SHIFT);
 			goto unmap_pages;
 		}
=20
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index d83aa5e..8b0617a 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -52,6 +52,7 @@
=20
 #include <asm/processor.h>
 #include <asm/io.h>
+#include <asm/ioctl.h>
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
=20
@@ -1766,6 +1767,9 @@ static long kvm_vcpu_ioctl(struct file *filp,
 	if (vcpu->kvm->mm !=3D current->mm)
 		return -EIO;
=20
+	if (unlikely(_IOC_TYPE(ioctl) !=3D KVMIO))
+		return -EINVAL;
+
 #if defined(CONFIG_S390) || defined(CONFIG_PPC)
 	/*
 	 * Special cases: vcpu ioctls that are asynchronous to vcpu execution,
=0D
--=-RgCyPFCDhQU5Y3OPX3cz--

--=-mPMtw4CtwxEZNBBbOUT3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUAVI3ax+e/yOyVhhEJAQoxhw/+O+fd9HXHppwKGiyXThNedRir4E6QN084
6uN+KJNZV5G1/e3WDZRKhYPoxCbFBaY+1R9f7Td5ZrpCmWKtuGSFir7vQpjHFSwV
U8o4aVmTXnGu3wAWQuhiSu9iQ4Umt9K4yLWx9PiYdMBsTVudp8arTHKm3ZyflHqZ
J+XYqST+SCH6RzwKGWJXrfsVrYiHFYwMyeoM5rhJ6GDwcuai8hZsyEqQrzBySPlQ
Is9h5Hy0DPXySnztZTzlcGm57yQc0QR+gLqEMUXxelLZNm/S1ONpelWiEDmoo8XC
HKtoJe8D+nib7m81NG6z6F6bydl/CxTvfoYdytKerHpjrrqxiPQm7uryD8THDUBh
OqgkpXBHy2ORTwZlxVY9ZJInO9mHhZGz0mx2WDq/ayoSiDF9WzwRtnWy1NV8GRnh
b0ySuBoflr66KXdazeZTOHLtIxiN3T+9TEy0GJr8HwSOeD6i+Y+2uEQ6P0dhbV+P
ixZX/aIEzA70/JtEur6IPzX1I/fkVkiUImMhvuDoaYIe/TwLZX8j9BIQw6ChGgRE
0DhohwGXCAdkS4lI2hj8F9TcoIseFadxivbj7T0HWJopupMKNPut/DqshL51swKQ
OTN+fNCSix9cdF+co2yCnYiV7zTFf5piYr6WU8txxM1b3xk8zcfnUq1WmRTJCq3I
KsXR54urN2Y=
=QUav
-----END PGP SIGNATURE-----

--=-mPMtw4CtwxEZNBBbOUT3--
