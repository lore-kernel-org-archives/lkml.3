Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161702AbaKNR3d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 12:29:33 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:50315 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161501AbaKNR3a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 12:29:30 -0500
Date: Fri, 14 Nov 2014 09:29:29 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.10.60
Message-ID: <20141114172929.GA2247@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6TrnltStXW4iwmi0"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--6TrnltStXW4iwmi0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.10.60 kernel.

All users of the 3.10 kernel series must upgrade.

The updated 3.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-3.10.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dsu=
mmary

thanks,

greg k-h

------------

 Makefile                                        |    2=20
 arch/arc/boot/dts/nsimosci.dts                  |    2=20
 arch/arc/include/asm/kgdb.h                     |   32 ++++---
 arch/mips/mm/tlbex.c                            |    6 +
 arch/x86/ia32/ia32entry.S                       |   18 ++++
 arch/x86/include/asm/elf.h                      |    5 -
 arch/x86/include/asm/kvm_host.h                 |   16 +++
 arch/x86/include/uapi/asm/processor-flags.h     |    2=20
 arch/x86/kernel/apic/apic.c                     |    4=20
 arch/x86/kernel/cpu/common.c                    |    2=20
 arch/x86/kernel/entry_64.S                      |    2=20
 arch/x86/kernel/process_32.c                    |    2=20
 arch/x86/kernel/process_64.c                    |    2=20
 arch/x86/kernel/signal.c                        |    5 +
 arch/x86/kernel/tsc.c                           |    5 -
 arch/x86/kernel/xsave.c                         |    7 -
 arch/x86/kvm/emulate.c                          |   99 +++++++++++++++++--=
-----
 arch/x86/kvm/i8254.c                            |    2=20
 arch/x86/kvm/svm.c                              |    8 -
 arch/x86/kvm/vmx.c                              |   17 ++--
 arch/x86/kvm/x86.c                              |   38 ++++++++-
 arch/x86/mm/pageattr.c                          |    2=20
 block/blk-settings.c                            |    4=20
 block/scsi_ioctl.c                              |    3=20
 crypto/algif_skcipher.c                         |    2=20
 drivers/ata/libata-sff.c                        |   20 ++--
 drivers/ata/pata_serverworks.c                  |   13 ++-
 drivers/base/core.c                             |    4=20
 drivers/block/drbd/drbd_interval.c              |    4=20
 drivers/block/rbd.c                             |    2=20
 drivers/char/random.c                           |   10 +-
 drivers/cpufreq/intel_pstate.c                  |    1=20
 drivers/edac/cpc925_edac.c                      |    2=20
 drivers/edac/e7xxx_edac.c                       |    2=20
 drivers/edac/i3200_edac.c                       |    4=20
 drivers/edac/i82860_edac.c                      |    2=20
 drivers/gpu/drm/ast/ast_mode.c                  |    4=20
 drivers/gpu/drm/nouveau/core/subdev/bios/dcb.c  |    1=20
 drivers/gpu/drm/tilcdc/tilcdc_drv.c             |   60 ++++++++++++--
 drivers/i2c/busses/i2c-at91.c                   |    2=20
 drivers/input/serio/i8042-x86ia64io.h           |   22 +++++
 drivers/lguest/x86/core.c                       |    2=20
 drivers/md/dm-bufio.c                           |    1=20
 drivers/md/dm-log-userspace-transfer.c          |    2=20
 drivers/media/dvb-frontends/ds3000.c            |    7 +
 drivers/media/i2c/tda7432.c                     |    2=20
 drivers/media/usb/em28xx/em28xx-video.c         |   10 +-
 drivers/media/v4l2-core/v4l2-common.c           |    9 --
 drivers/mfd/rtsx_pcr.c                          |    2=20
 drivers/mmc/host/rtsx_pci_sdmmc.c               |    7 +
 drivers/mtd/ubi/fastmap.c                       |    1=20
 drivers/net/Kconfig                             |    2=20
 drivers/net/ppp/ppp_generic.c                   |    2=20
 drivers/net/usb/ax88179_178a.c                  |    7 +
 drivers/net/wireless/rt2x00/rt2800usb.c         |    1=20
 drivers/of/base.c                               |   88 +++++--------------=
--
 drivers/of/selftest.c                           |   66 ++++++++++++++--
 drivers/platform/x86/acer-wmi.c                 |   11 ++
 drivers/scsi/qla2xxx/tcm_qla2xxx.c              |   11 ++
 drivers/spi/spi-pl022.c                         |    2=20
 drivers/spi/spi-pxa2xx.c                        |    7 +
 drivers/staging/iio/impedance-analyzer/ad5933.c |   15 +--
 drivers/staging/iio/meter/ade7758.h             |    1=20
 drivers/staging/iio/meter/ade7758_core.c        |   57 ++-----------
 drivers/staging/iio/meter/ade7758_ring.c        |    5 -
 drivers/target/target_core_device.c             |    3=20
 drivers/target/target_core_pr.c                 |    6 -
 drivers/target/target_core_pr.h                 |    2=20
 drivers/target/target_core_tpg.c                |    8 +
 drivers/target/target_core_transport.c          |    3=20
 drivers/tty/serial/serial_core.c                |    2=20
 drivers/tty/tty_io.c                            |    7 +
 drivers/usb/class/cdc-acm.c                     |    6 -
 drivers/usb/core/hcd.c                          |    2=20
 drivers/usb/dwc3/ep0.c                          |    4=20
 drivers/usb/dwc3/gadget.c                       |   19 +++-
 drivers/usb/dwc3/gadget.h                       |    2=20
 drivers/usb/gadget/f_acm.c                      |    7 -
 drivers/usb/gadget/udc-core.c                   |    5 +
 drivers/usb/serial/cp210x.c                     |    1=20
 drivers/usb/serial/ftdi_sio.c                   |    3=20
 drivers/usb/serial/ftdi_sio_ids.h               |   12 ++
 drivers/usb/serial/opticon.c                    |    2=20
 drivers/usb/serial/option.c                     |   10 ++
 drivers/usb/storage/transport.c                 |   26 ++++++
 drivers/video/console/bitblit.c                 |    3=20
 drivers/video/console/fbcon_ccw.c               |    3=20
 drivers/video/console/fbcon_cw.c                |    3=20
 drivers/video/console/fbcon_ud.c                |    3=20
 drivers/virtio/virtio_pci.c                     |   33 +++++++-
 fs/btrfs/file-item.c                            |    2=20
 fs/buffer.c                                     |    8 +
 fs/ext3/super.c                                 |    7 -
 fs/ext4/ext4.h                                  |    5 -
 fs/ext4/ialloc.c                                |    4=20
 fs/ext4/inode.c                                 |   24 +++++
 fs/ext4/ioctl.c                                 |   10 ++
 fs/ext4/namei.c                                 |    4=20
 fs/ext4/resize.c                                |    2=20
 fs/ext4/super.c                                 |   13 +--
 fs/ext4/xattr.c                                 |   32 +++++--
 fs/jbd2/recovery.c                              |    1=20
 fs/jffs2/jffs2_fs_sb.h                          |    2=20
 fs/jffs2/wbuf.c                                 |   17 ----
 fs/lockd/mon.c                                  |    6 +
 fs/namespace.c                                  |    3=20
 fs/nfsd/nfs4proc.c                              |    3=20
 fs/pstore/inode.c                               |    4=20
 fs/quota/dquot.c                                |    2=20
 fs/super.c                                      |    2=20
 fs/ubifs/commit.c                               |   10 --
 fs/ubifs/log.c                                  |   19 +++-
 fs/ubifs/master.c                               |    7 -
 fs/ubifs/super.c                                |    1=20
 fs/ubifs/ubifs.h                                |    2=20
 include/drm/drm_pciids.h                        |    1=20
 include/linux/blkdev.h                          |    5 -
 include/linux/compiler-gcc.h                    |    3=20
 include/linux/compiler-intel.h                  |    7 +
 include/linux/compiler.h                        |    4=20
 include/linux/mm.h                              |    1=20
 include/linux/of.h                              |   84 ++++++++++++++++----
 include/linux/oom.h                             |    3=20
 include/linux/string.h                          |    5 -
 kernel/freezer.c                                |    3=20
 kernel/module.c                                 |    2=20
 kernel/posix-timers.c                           |    1=20
 kernel/power/hibernate.c                        |    8 +
 kernel/power/process.c                          |   40 +++++++++
 kernel/trace/trace_syscalls.c                   |    8 -
 lib/bitmap.c                                    |    8 +
 lib/string.c                                    |   16 +++
 mm/oom_kill.c                                   |   17 ++++
 mm/page_alloc.c                                 |    8 +
 mm/page_cgroup.c                                |    1=20
 mm/percpu.c                                     |    2=20
 mm/truncate.c                                   |   58 +++++++++++++-
 net/ceph/messenger.c                            |    3=20
 net/ipv4/fib_semantics.c                        |    2=20
 net/ipv4/ip_output.c                            |   12 ++
 net/mac80211/rate.c                             |    2=20
 net/netlink/af_netlink.c                        |    2=20
 security/integrity/evm/evm_main.c               |    9 +-
 security/selinux/hooks.c                        |    2=20
 sound/core/pcm_compat.c                         |    2=20
 virt/kvm/iommu.c                                |    8 -
 146 files changed, 1029 insertions(+), 421 deletions(-)

Al Viro (2):
      kill wbuf_queued/wbuf_dwork_lock
      fix misuses of f_count() in ppp and netlink

Alan Stern (1):
      usb-storage: handle a skipped data phase

Alex Deucher (1):
      drm/radeon: remove invalid pci id

Alexey Khoroshilov (1):
      dm log userspace: fix memory leak in dm_ulog_tfr_init failure path

Andy Honig (2):
      KVM: x86: Prevent host from panicking on shared MSR writes.
      KVM: x86: Improve thread safety in pit

Andy Lutomirski (3):
      x86_64, entry: Filter RFLAGS.NT on entry from userspace
      x86_64, entry: Fix out of bounds read on sysenter
      x86, apic: Handle a bad TSC more gracefully

Anton Kolesov (1):
      ARC: Update order of registers in KGDB to match GDB 7.5

Artem Bityutskiy (3):
      UBIFS: remove mst_mutex
      UBIFS: fix a race condition
      UBIFS: fix free log space calculation

Axel Lin (1):
      media: tda7432: Fix setting TDA7432_MUTE bit for TDA7432_RF register

Ben Hutchings (2):
      drivers/net: macvtap and tun depend on INET
      x86: Reject x32 executables if x32 ABI not supported

Ben Skeggs (1):
      drm/nouveau/bios: memset dcb struct to zero before parsing

Benjamin Coddington (1):
      lockd: Try to reconnect if statd has moved

Benjamin Herrenschmidt (1):
      drm/ast: Fix HW cursor image

Cesar Eduardo Barros (1):
      crypto: more robust crypto_memneq

Chris Ball (1):
      mfd: rtsx_pcr: Fix MSI enable error handling

Chris Mason (1):
      Btrfs: fix kfree on list_head in btrfs_lookup_csums_range error clean=
up

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

Darrick J. Wong (3):
      jbd2: free bh when descriptor block checksum fails
      ext4: check EA value offset when loading
      ext4: check s_chksum_driver when looking for bg csum presence

David Daney (1):
      MIPS: tlbex: Properly fix HUGE TLB Refill exception handler

Dexuan Cui (1):
      x86, pageattr: Prevent overflow in slow_virt_to_phys() for X86_PAE

Dmitry Eremin-Solenikov (1):
      spi: pxa2xx: toggle clocks on suspend if not disabled by runtime PM

Dmitry Kasatkin (1):
      evm: check xattr value length and type in evm_inode_setxattr()

Dmitry Monakhov (1):
      ext4: grab missed write_count for EXT4_IOC_SWAP_BOOT

Eric Sandeen (1):
      ext4: fix reservation overflow in ext4_da_write_begin

Eric W. Biederman (1):
      mnt: Prevent pivot_root from creating a loop in the mount tree

Ezequiel Garcia (1):
      drm/tilcdc: Fix the error path in tilcdc_load()

Felipe Balbi (3):
      usb: dwc3: gadget: fix set_halt() bug with pending transfers
      usb: gadget: function: acm: make f_acm pass USB20CV Chapter9
      usb: gadget: udc: core: fix kernel oops with soft-connect

Frank Schaefer (1):
      media: em28xx-v4l: give back all active video buffers to the vb2 core=
 properly on streaming stop

Frans Klaver (1):
      usb: serial: ftdi_sio: add Awinda Station and Dongle products

Grant Likely (1):
      of: Fix overflow bug in string property parsing functions

Greg Kroah-Hartman (1):
      Linux 3.10.60

Guenter Roeck (1):
      Revert "percpu: free percpu allocation info for uniprocessor system"

H. Peter Anvin (1):
      x86, flags: Rename X86_EFLAGS_BIT1 to X86_EFLAGS_FIXED

Hans de Goede (4):
      Input: i8042 - add noloop quirk for Asus X750LN
      Input: i8042 - quirks for Fujitsu Lifebook A544 and Lifebook AH544
      usb: Do not allow usb_alloc_streams on unconfigured devices
      acer-wmi: Add acpi_backlight=3Dvideo quirk for the Acer KAV80

Ian Morgan (1):
      ax88179_178a: fix bonding failure

Ilya Dryomov (1):
      libceph: ceph-msgr workqueue needs a resque worker

Imre Deak (1):
      PM / Sleep: fix recovery during resuming from hibernation

J. Bruce Fields (1):
      nfsd4: fix crash on unknown operation number

Jack Pham (1):
      usb: dwc3: gadget: Properly initialize LINK TRB

Jan Kara (10):
      vfs: fix data corruption when blocksize < pagesize for mmaped data
      ext4: don't check quota format when there are no quota files
      ext4: fix overflow when updating superblock backups after resize
      ext4: fix oops when loading block bitmap failed
      lib/bitmap.c: fix undefined shift in __bitmap_shift_{left|right}()
      scsi: Fix error handling in SCSI_IOCTL_SEND_COMMAND
      ext3: Don't check quota format when there are no quota files
      quota: Properly return errors from dquot_writeback_dquots()
      mm: Remove false WARN_ON from pagecache_isize_extended()
      rbd: Fix error recovery in rbd_obj_read_sync()

Jason Baron (4):
      i82860_edac: Report CE events properly
      i3200_edac: Report CE events properly
      e7xxx_edac: Report CE events properly
      cpc925_edac: Report UE events properly

Jiri Pirko (1):
      ipv4: fix nexthop attlen check in fib_nh_match

Joe Thornber (1):
      dm bufio: update last_accessed when relinking a buffer

Joern Engel (1):
      qla_target: don't delete changed nacls

Johan Hovold (3):
      USB: cdc-acm: add device id for GW Instek AFG-2225
      USB: cdc-acm: only raise DTR on transitions from B0
      USB: opticon: fix non-atomic allocation in write path

Karl Beldan (1):
      mac80211: fix typo in starting baserate for rts_cts_rate_idx

Lai Jiangshan (1):
      drbd: compute the end before rb_insert_augmented()

Lars-Peter Clausen (5):
      staging:iio:ad5933: Fix NULL pointer deref when enabling buffer
      staging:iio:ad5933: Drop "raw" from channel names
      staging:iio:ade7758: Fix NULL pointer deref when enabling buffer
      staging:iio:ade7758: Fix check if channels are enabled in prenable
      staging:iio:ade7758: Remove "raw" from channel name

Maciej Matraszek (1):
      media: v4l2-common: fix overflow in v4l_bound_align_image()

Mathias Krause (1):
      posix-timers: Fix stack info leak in timer_create()

Michael S. Tsirkin (2):
      virtio_pci: fix virtio spec compliance on restore
      kvm: x86: don't kill guest on unknown exit reason

Michal Hocko (1):
      OOM, PM: OOM killed task shouldn't escape PM suspend

Mike Snitzer (1):
      block: fix alignment_offset math that assumes io_min is a power-of-2

Mikulas Patocka (2):
      fs: make cont_expand_zero interruptible
      framebuffer: fix border color

Nadav Amit (3):
      KVM: x86: Check non-canonical addresses upon WRMSR
      KVM: x86: Fix wrong masking on relative jump/call
      KVM: x86: Emulator fixes for eip canonical checks on near branches

Nathaniel Ting (1):
      USB: serial: cp210x: add Silicon Labs 358x VID and PID

Nicholas Bellinger (1):
      target: Fix APTPL metadata handling for dynamic MappedLUNs

Oleg Nesterov (2):
      x86, fpu: __restore_xstate_sig()->math_state_restore() needs preempt_=
disable()
      x86, fpu: shift drop_init_fpu() from save_xstate_sig() to handle_sign=
al()

Ondrej Kozina (1):
      crypto: algif - avoid excessive use of socket buffer in skcipher

Ondrej Zary (1):
      libata-sff: Fix controllers with no ctl port

Pali Roh=E1r (1):
      cpufreq: intel_pstate: Fix setting max_perf_pct in performance policy

Perry Hung (1):
      usb: serial: ftdi_sio: add "bricked" FTDI device PID

Peter Hurley (2):
      serial: Fix divide-by-zero fault in uart_get_divisor()
      tty: Fix high cpu load if tty is unreleaseable

Prarit Bhargava (1):
      modules, lock around setting of MODULE_STATE_UNFORMED

Quentin Casasnovas (1):
      kvm: fix excessive pages un-pinning in kvm_iommu_map error path.

Quinn Tran (1):
      target: Fix queue full status NULL pointer for SCF_TRANSPORT_TASK_SEN=
SE

Rabin Vincent (1):
      tracing/syscalls: Ignore numbers outside NR_syscalls' range

Ray Jui (1):
      spi: pl022: Fix incorrect dma_unmap_sg

Richard Genoud (1):
      UBI: add missing kmem_cache_free() in process_pool_aeb error path

Roger Tseng (1):
      mmc: rtsx_pci_sdmmc: fix incorrect last byte in R2 response

Scott Carter (1):
      pata_serverworks: disable 64-KB DMA transfers on Broadcom OSB4 IDE Co=
ntroller

Stephen Smalley (1):
      selinux: fix inode security list corruption

Takashi Iwai (1):
      ALSA: pcm: Zero-clear reserved fields of PCM status ioctl in compat m=
ode

Tetsuo Handa (1):
      fs: Fix theoretical division by 0 in super_cache_scan().

Theodore Ts'o (1):
      ext4: add ext4_iget_normal() which is to be used for dir tree lookups

Ulrich Eckhardt (1):
      media: ds3000: fix LNB supply voltage on Tevii S480 on initialization

Valdis Kletnieks (1):
      pstore: Fix duplicate {console,ftrace}-efi entries

Vasily Averin (1):
      ipv4: dst_entry leak in ip_send_unicast_reply()

Vineet Gupta (1):
      ARC: [nsimosci] Allow "headless" models to boot

Wang Nan (1):
      cgroup/kmemleak: add kmemleak_free() for cgroup deallocations.

Wolfram Sang (1):
      i2c: at91: don't account as iowait

Yijing Wang (1):
      sysfs: driver core: Fix glue dir race condition by gdp_mutex


--6TrnltStXW4iwmi0
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUZjv5AAoJEDjbvchgkmk+QfQQALTxwc2U+28hhrjop3DC5Qmp
4RDZQbzSkEfDVeGH1iPWrnYaoSt6Xfgy3gt2aef3x2K+lpJl84BjVJ7+XCUvjCpa
3YbcKtfG48aMb+0syLUX9tVbrnrRW9I+JmCK2KVFVqiF3tUDRxBN/e8s4+plszXl
/nimPAqTaVkqKOSCQ/6+Fp8dSFuhZp8xdotds9K9eSTatsoKPlhgz0mfLZVx6lKM
S7BfbZY0ARYaGvYQxKmL1XbEv1IUtMzs5baA4X9y9ErYCI7Rt9PLYC10PIHsIyOl
h7cqJ3W2eD8F0ReFWPYMosXTr0rArsfUW9/O4idHsWoC9FPy4YYT0KlERizhhs4q
Q1z+6MmO5NOlENDe8bVxpy4PzVzTE4n153rBr6dlvddTe5j2xDQmRn9zLuXH3MJh
UDfFs78KRh7gPg58bZFN287hgP56bvio5DtvtIVNpVXL0z41Qpu+Aj9O5JGibMxS
3nCVfO5ps6+3tVb5LW91bbiWdFrWhGkcUJ2GvUhvXKBrcqU3vcFIFuH3g1DzCm5g
NkiI3STj6Yd9FGFUGVmwbAJVSfCtBLAqHiSl2K3eQKVeykMvl2hlRWSQ5WKIDOk3
m9wBTPFK6n6EqigKpEcFkwTDf4s/VcLGuZ3/szxaI7iGbTRo+RX5oxVGDg8gLFPl
9vI8LsRAg1IoA8aLkA7S
=Ul9F
-----END PGP SIGNATURE-----

--6TrnltStXW4iwmi0--
