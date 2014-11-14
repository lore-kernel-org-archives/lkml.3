Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161728AbaKNRaM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 12:30:12 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:50321 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161519AbaKNRaC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 12:30:02 -0500
Date: Fri, 14 Nov 2014 09:30:01 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.14.24
Message-ID: <20141114173001.GA2321@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yrj/dFKFPuw6o+aM"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--yrj/dFKFPuw6o+aM
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.14.24 kernel.

All users of the 3.14 kernel series must upgrade.

The updated 3.14.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-3.14.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dsu=
mmary

thanks,

greg k-h

------------

 Makefile                                          |    2=20
 arch/arc/boot/dts/nsimosci.dts                    |    2=20
 arch/arc/include/asm/cache.h                      |   27 +++++
 arch/arc/include/asm/kgdb.h                       |   32 +++---
 arch/arc/kernel/head.S                            |   45 +++++++-
 arch/arc/mm/cache_arc700.c                        |  113 +++++------------=
-----
 arch/mips/include/asm/ftrace.h                    |    4=20
 arch/mips/mm/tlbex.c                              |    6 -
 arch/powerpc/platforms/pseries/dlpar.c            |    4=20
 arch/sh/kernel/cpu/sh3/setup-sh770x.c             |    6 -
 arch/um/drivers/ubd_kern.c                        |    5=20
 arch/x86/Kconfig                                  |    7 -
 arch/x86/ia32/ia32entry.S                         |   18 +++
 arch/x86/include/asm/elf.h                        |    5=20
 arch/x86/include/asm/iosf_mbi.h                   |   55 ++++++++++
 arch/x86/include/asm/kvm_host.h                   |   16 ++-
 arch/x86/include/uapi/asm/vmx.h                   |    2=20
 arch/x86/kernel/apic/apic.c                       |    4=20
 arch/x86/kernel/cpu/common.c                      |    2=20
 arch/x86/kernel/cpu/intel.c                       |   17 +++
 arch/x86/kernel/iosf_mbi.c                        |   15 ++
 arch/x86/kernel/signal.c                          |    5=20
 arch/x86/kernel/tsc.c                             |    5=20
 arch/x86/kernel/xsave.c                           |    7 -
 arch/x86/kvm/emulate.c                            |   99 ++++++++++++++---=
--
 arch/x86/kvm/i8254.c                              |    2=20
 arch/x86/kvm/svm.c                                |    8 -
 arch/x86/kvm/vmx.c                                |   24 +++-
 arch/x86/kvm/x86.c                                |   38 ++++++-
 arch/x86/mm/pageattr.c                            |    2=20
 block/blk-settings.c                              |    4=20
 block/scsi_ioctl.c                                |    3=20
 crypto/algif_skcipher.c                           |    2=20
 drivers/ata/libata-sff.c                          |   20 +--
 drivers/ata/pata_serverworks.c                    |   13 ++
 drivers/base/core.c                               |    4=20
 drivers/block/drbd/drbd_interval.c                |    4=20
 drivers/block/rbd.c                               |    2=20
 drivers/block/xen-blkback/blkback.c               |    1=20
 drivers/char/random.c                             |   10 -
 drivers/cpufreq/cpufreq.c                         |   23 +++-
 drivers/cpufreq/intel_pstate.c                    |   60 ++++++++++-
 drivers/edac/cpc925_edac.c                        |    2=20
 drivers/edac/e7xxx_edac.c                         |    2=20
 drivers/edac/i3200_edac.c                         |    4=20
 drivers/edac/i82860_edac.c                        |    2=20
 drivers/gpu/drm/ast/ast_mode.c                    |    4=20
 drivers/gpu/drm/cirrus/cirrus_drv.c               |    2=20
 drivers/gpu/drm/i915/intel_panel.c                |    8 -
 drivers/gpu/drm/nouveau/core/subdev/bios/dcb.c    |    1=20
 drivers/gpu/drm/qxl/qxl_display.c                 |   16 +--
 drivers/gpu/drm/radeon/si_dpm.c                   |    2=20
 drivers/gpu/drm/tilcdc/tilcdc_drv.c               |   60 +++++++++--
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.c               |    6 -
 drivers/gpu/drm/vmwgfx/vmwgfx_kms.c               |   16 ++-
 drivers/hid/hid-ids.h                             |    5=20
 drivers/hid/usbhid/hid-core.c                     |   26 ++++-
 drivers/hid/usbhid/hid-quirks.c                   |    3=20
 drivers/i2c/busses/i2c-at91.c                     |    2=20
 drivers/iio/common/st_sensors/st_sensors_buffer.c |    2=20
 drivers/input/serio/i8042-x86ia64io.h             |   22 ++++
 drivers/md/dm-bufio.c                             |    5=20
 drivers/md/dm-log-userspace-transfer.c            |    2=20
 drivers/media/dvb-frontends/ds3000.c              |    7 +
 drivers/media/i2c/tda7432.c                       |    2=20
 drivers/media/tuners/m88ts2022.c                  |    2=20
 drivers/media/usb/em28xx/em28xx-cards.c           |   11 --
 drivers/media/usb/em28xx/em28xx-core.c            |   12 ++
 drivers/media/usb/em28xx/em28xx-video.c           |   10 +
 drivers/media/usb/uvc/uvc_driver.c                |    9 +
 drivers/media/v4l2-core/v4l2-common.c             |    9 -
 drivers/mfd/rtsx_pcr.c                            |    2=20
 drivers/mfd/ti_am335x_tscadc.c                    |    5=20
 drivers/mmc/host/rtsx_pci_sdmmc.c                 |    7 +
 drivers/mmc/host/sdhci-pci.c                      |   12 ++
 drivers/mmc/host/sdhci-pci.h                      |    1=20
 drivers/mtd/ubi/fastmap.c                         |    1=20
 drivers/net/Kconfig                               |    2=20
 drivers/net/macvtap.c                             |   16 +--
 drivers/net/ppp/ppp_generic.c                     |    2=20
 drivers/net/tun.c                                 |   25 +++-
 drivers/net/usb/ax88179_178a.c                    |    7 +
 drivers/net/virtio_net.c                          |   24 ++--
 drivers/net/vxlan.c                               |   15 +-
 drivers/net/wireless/iwlwifi/mvm/tx.c             |    8 -
 drivers/net/wireless/rt2x00/rt2800.h              |    4=20
 drivers/net/wireless/rt2x00/rt2800lib.c           |    6 +
 drivers/net/wireless/rt2x00/rt2800usb.c           |    5=20
 drivers/of/base.c                                 |   88 ++++-------------
 drivers/of/selftest.c                             |   66 +++++++++++-
 drivers/of/testcase-data/tests-phandle.dtsi       |    2=20
 drivers/pci/pci-sysfs.c                           |   14 +-
 drivers/pinctrl/pinctrl-baytrail.c                |    2=20
 drivers/platform/x86/acer-wmi.c                   |   11 ++
 drivers/power/charger-manager.c                   |    5=20
 drivers/regulator/max77693.c                      |    2=20
 drivers/scsi/qla2xxx/tcm_qla2xxx.c                |   11 +-
 drivers/spi/spi-fsl-dspi.c                        |    4=20
 drivers/spi/spi-pl022.c                           |    2=20
 drivers/spi/spi-pxa2xx.c                          |    7 -
 drivers/staging/iio/impedance-analyzer/ad5933.c   |   15 +-
 drivers/staging/iio/meter/ade7758.h               |    1=20
 drivers/staging/iio/meter/ade7758_core.c          |   57 ++---------
 drivers/staging/iio/meter/ade7758_ring.c          |    5=20
 drivers/target/target_core_device.c               |    3=20
 drivers/target/target_core_pr.c                   |    6 -
 drivers/target/target_core_pr.h                   |    2=20
 drivers/target/target_core_tpg.c                  |    8 +
 drivers/target/target_core_transport.c            |    3=20
 drivers/tty/serial/serial_core.c                  |    2=20
 drivers/tty/tty_io.c                              |    7 +
 drivers/usb/class/cdc-acm.c                       |    6 -
 drivers/usb/core/hcd.c                            |    2=20
 drivers/usb/core/hub.c                            |    3=20
 drivers/usb/core/quirks.c                         |   10 +
 drivers/usb/dwc3/ep0.c                            |    4=20
 drivers/usb/dwc3/gadget.c                         |   19 ++-
 drivers/usb/dwc3/gadget.h                         |    2=20
 drivers/usb/gadget/f_acm.c                        |    7 -
 drivers/usb/gadget/f_fs.c                         |    2=20
 drivers/usb/gadget/udc-core.c                     |    5=20
 drivers/usb/musb/musb_cppi41.c                    |    3=20
 drivers/usb/musb/musb_dsps.c                      |    4=20
 drivers/usb/phy/phy.c                             |    3=20
 drivers/usb/serial/cp210x.c                       |    1=20
 drivers/usb/serial/ftdi_sio.c                     |    3=20
 drivers/usb/serial/ftdi_sio_ids.h                 |   12 ++
 drivers/usb/serial/kobil_sct.c                    |    5=20
 drivers/usb/serial/opticon.c                      |    2=20
 drivers/usb/serial/option.c                       |   10 +
 drivers/usb/storage/transport.c                   |   26 +++++
 drivers/video/console/bitblit.c                   |    3=20
 drivers/video/console/fbcon_ccw.c                 |    3=20
 drivers/video/console/fbcon_cw.c                  |    3=20
 drivers/video/console/fbcon_ud.c                  |    3=20
 drivers/virtio/virtio_pci.c                       |   33 +++++-
 fs/btrfs/file-item.c                              |    2=20
 fs/buffer.c                                       |    8 +
 fs/dcache.c                                       |    5=20
 fs/ext3/super.c                                   |    7 -
 fs/ext4/bitmap.c                                  |   12 --
 fs/ext4/ext4.h                                    |   13 ++
 fs/ext4/extents.c                                 |    6 -
 fs/ext4/ialloc.c                                  |    7 -
 fs/ext4/inline.c                                  |    3=20
 fs/ext4/inode.c                                   |   39 ++++++-
 fs/ext4/ioctl.c                                   |   13 +-
 fs/ext4/mmp.c                                     |    6 -
 fs/ext4/namei.c                                   |   43 ++------
 fs/ext4/resize.c                                  |    5=20
 fs/ext4/super.c                                   |   32 ++----
 fs/ext4/xattr.c                                   |   38 +++++--
 fs/jbd2/recovery.c                                |    1=20
 fs/jffs2/jffs2_fs_sb.h                            |    2=20
 fs/jffs2/wbuf.c                                   |   17 ---
 fs/lockd/mon.c                                    |    6 +
 fs/namei.c                                        |    3=20
 fs/namespace.c                                    |    3=20
 fs/nfsd/nfs4proc.c                                |    3=20
 fs/pstore/inode.c                                 |    4=20
 fs/quota/dquot.c                                  |    2=20
 fs/super.c                                        |    2=20
 fs/ubifs/commit.c                                 |   10 -
 fs/ubifs/log.c                                    |   19 ++-
 fs/ubifs/master.c                                 |    7 -
 fs/ubifs/super.c                                  |    1=20
 fs/ubifs/ubifs.h                                  |    2=20
 fs/xfs/xfs_mount.c                                |    1=20
 fs/xfs/xfs_sb.c                                   |   24 +++-
 include/drm/drm_pciids.h                          |    1=20
 include/linux/blkdev.h                            |    5=20
 include/linux/hid.h                               |    1=20
 include/linux/mm.h                                |    1=20
 include/linux/of.h                                |   84 +++++++++++++---
 include/linux/oom.h                               |    3=20
 include/linux/string.h                            |    5=20
 include/linux/sunrpc/xprt.h                       |    1=20
 include/linux/usb/quirks.h                        |    3=20
 include/net/ipv6.h                                |    2=20
 include/uapi/drm/vmwgfx_drm.h                     |    2=20
 kernel/freezer.c                                  |    3=20
 kernel/module.c                                   |    2=20
 kernel/posix-timers.c                             |    1=20
 kernel/power/hibernate.c                          |    8 +
 kernel/power/process.c                            |   40 +++++++
 kernel/sched/core.c                               |   19 ++-
 kernel/trace/trace_syscalls.c                     |    8 -
 lib/bitmap.c                                      |    8 +
 lib/string.c                                      |   16 +++
 mm/huge_memory.c                                  |    4=20
 mm/memcontrol.c                                   |   35 ++++++
 mm/oom_kill.c                                     |   17 +++
 mm/page_alloc.c                                   |   15 ++
 mm/page_cgroup.c                                  |    1=20
 mm/percpu.c                                       |    2=20
 mm/truncate.c                                     |   56 ++++++++++
 net/ceph/messenger.c                              |    6 -
 net/ipv4/fib_semantics.c                          |    2=20
 net/ipv4/gre_offload.c                            |    2=20
 net/ipv4/ip_output.c                              |   12 +-
 net/ipv4/ip_tunnel_core.c                         |    3=20
 net/ipv4/tcp.c                                    |   59 +++--------
 net/ipv6/output_core.c                            |   33 ++++++
 net/mac80211/rate.c                               |    2=20
 net/netlink/af_netlink.c                          |    2=20
 net/sunrpc/clnt.c                                 |    3=20
 net/sunrpc/xprtsock.c                             |    4=20
 security/integrity/evm/evm_main.c                 |   16 ++-
 security/selinux/hooks.c                          |    2=20
 sound/core/pcm_compat.c                           |    2=20
 sound/pci/hda/hda_intel.c                         |    3=20
 sound/pci/hda/patch_hdmi.c                        |    2=20
 sound/soc/codecs/tlv320aic3x.c                    |   13 ++
 sound/soc/soc-dapm.c                              |   25 ++--
 sound/usb/card.c                                  |    9 +
 virt/kvm/iommu.c                                  |    8 -
 216 files changed, 1740 insertions(+), 773 deletions(-)

Adel Gadllah (4):
      USB: quirks: enable device-qualifier quirk for another Elan touchscre=
en
      USB: quirks: enable device-qualifier quirk for yet another Elan touch=
screen
      HID: usbhid: enable always-poll quirk for Elan Touchscreen 009b
      HID: usbhid: enable always-poll quirk for Elan Touchscreen 016f

Al Viro (3):
      missing data dependency barrier in prepend_name()
      kill wbuf_queued/wbuf_dwork_lock
      fix misuses of f_count() in ppp and netlink

Alan Stern (1):
      usb-storage: handle a skipped data phase

Alex Deucher (2):
      drm/radeon/dpm: disable ulv support on SI
      drm/radeon: remove invalid pci id

Alexander Stein (1):
      spi: fsl-dspi: Fix CTAR selection

Alexey Khoroshilov (1):
      dm log userspace: fix memory leak in dm_ulog_tfr_init failure path

Andriy Skulysh (1):
      sh: fix sh770x SCIF memory regions

Andy Honig (2):
      KVM: x86: Prevent host from panicking on shared MSR writes.
      KVM: x86: Improve thread safety in pit

Andy Lutomirski (3):
      x86_64, entry: Filter RFLAGS.NT on entry from userspace
      x86_64, entry: Fix out of bounds read on sysenter
      x86, apic: Handle a bad TSC more gracefully

Anton Kolesov (1):
      ARC: Update order of registers in KGDB to match GDB 7.5

Antti Palosaari (1):
      media: m88ts2022: fix 32bit overflow on filter calc

Arjun Sreedharan (1):
      usb: phy: return -ENODEV on failure of try_module_get

Artem Bityutskiy (3):
      UBIFS: remove mst_mutex
      UBIFS: fix a race condition
      UBIFS: fix free log space calculation

Axel Lin (1):
      media: tda7432: Fix setting TDA7432_MUTE bit for TDA7432_RF register

Ben Hutchings (4):
      drivers/net: Disable UFO through virtio
      drivers/net, ipv6: Select IPv6 fragment idents for virtio UFO packets
      drivers/net: macvtap and tun depend on INET
      x86: Reject x32 executables if x32 ABI not supported

Ben Skeggs (1):
      drm/nouveau/bios: memset dcb struct to zero before parsing

Benjamin Coddington (2):
      lockd: Try to reconnect if statd has moved
      SUNRPC: Don't wake tasks during connection abort

Benjamin Herrenschmidt (1):
      drm/ast: Fix HW cursor image

Bryan O'Donoghue (1):
      x86: Add cpu_detect_cache_sizes to init_intel() add Quark legacy_cach=
e()

Canek Pel=E1ez Vald=E9s (1):
      rt2x00: support Ralink 5362.

Chris Ball (1):
      mfd: rtsx_pcr: Fix MSI enable error handling

Chris Mason (1):
      Btrfs: fix kfree on list_head in btrfs_lookup_csums_range error clean=
up

Cong Wang (1):
      freezer: Do not freeze tasks killed by OOM killer

Cyril Brulebois (1):
      wireless: rt2x00: add new rt2800usb device

Dan Streetman (1):
      powerpc: use device_online/offline() instead of cpu_up/down()

Dan Williams (1):
      USB: option: add Haier CE81B CDMA modem

Daniel Borkmann (1):
      random: add and use memzero_explicit() for clearing data

Daniel Mack (1):
      ASoC: soc-dapm: fix use after free

Daniele Palmas (1):
      usb: option: add support for Telit LE910

Darrick J. Wong (4):
      jbd2: free bh when descriptor block checksum fails
      ext4: check EA value offset when loading
      ext4: check s_chksum_driver when looking for bg csum presence
      ext4: enable journal checksum when metadata checksum feature enabled

David Cohen (1):
      pinctrl: baytrail: show output gpio state correctly on Intel Baytrail

David Daney (1):
      MIPS: tlbex: Properly fix HUGE TLB Refill exception handler

David E. Box (2):
      x86, iosf: Make IOSF driver modular and usable by more drivers
      x86/platform/intel/iosf: Add Braswell PCI ID

Derek Browne (1):
      mmc: sdhci-pci: SDIO host controller support for Intel Quark X1000

Dexuan Cui (1):
      x86, pageattr: Prevent overflow in slow_virt_to_phys() for X86_PAE

Dirk Brandewie (4):
      cpufreq: expose scaling_cur_freq sysfs file for set_policy() drivers
      intel_pstate: Add CPU IDs for Broadwell processors
      intel_pstate: Fix BYT frequency reporting
      intel_pstate: Correct BYT VID values.

Dmitry Eremin-Solenikov (1):
      spi: pxa2xx: toggle clocks on suspend if not disabled by runtime PM

Dmitry Kasatkin (2):
      evm: properly handle INTEGRITY_NOXATTRS EVM status
      evm: check xattr value length and type in evm_inode_setxattr()

Dmitry Lavnikevich (1):
      ASoC: tlv320aic3x: fix PLL D configuration

Dmitry Monakhov (2):
      ext4: grab missed write_count for EXT4_IOC_SWAP_BOOT
      ext4: Replace open coded mdata csum feature to helper function

Emmanuel Grumbach (1):
      Revert "iwlwifi: mvm: treat EAPOLs like mgmt frames wrt rate"

Eric Dumazet (1):
      tcp: md5: do not use alloc_percpu()

Eric Rannaud (1):
      fs: allow open(dir, O_TMPFILE|..., 0) with mode 0

Eric Sandeen (2):
      ext4: fix reservation overflow in ext4_da_write_begin
      xfs: avoid false quotacheck after unclean shutdown

Eric W. Biederman (1):
      mnt: Prevent pivot_root from creating a loop in the mount tree

Ezequiel Garcia (1):
      drm/tilcdc: Fix the error path in tilcdc_load()

Felipe Balbi (3):
      usb: dwc3: gadget: fix set_halt() bug with pending transfers
      usb: gadget: function: acm: make f_acm pass USB20CV Chapter9
      usb: gadget: udc: core: fix kernel oops with soft-connect

Frank Schaefer (2):
      media: em28xx: check if a device has audio earlier"
      media: em28xx-v4l: give back all active video buffers to the vb2 core=
 properly on streaming stop

Frans Klaver (1):
      usb: serial: ftdi_sio: add Awinda Station and Dongle products

Grant Likely (1):
      of: Fix overflow bug in string property parsing functions

Greg Kroah-Hartman (2):
      PCI: Rename sysfs 'enabled' file back to 'enable'
      Linux 3.14.24

Guenter Roeck (1):
      Revert "percpu: free percpu allocation info for uniprocessor system"

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

Jan Kara (11):
      vfs: fix data corruption when blocksize < pagesize for mmaped data
      ext4: don't check quota format when there are no quota files
      ext4: fix mmap data corruption when blocksize < pagesize
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

Johan Hovold (8):
      USB: cdc-acm: add device id for GW Instek AFG-2225
      USB: cdc-acm: only raise DTR on transitions from B0
      USB: core: add device-qualifier quirk
      USB: quirks: enable device-qualifier quirk for Elan Touchscreen
      HID: usbhid: add always-poll quirk
      HID: usbhid: enable always-poll quirk for Elan Touchscreen
      USB: opticon: fix non-atomic allocation in write path
      USB: kobil_sct: fix non-atomic allocation in write path

Johannes Weiner (2):
      mm: memcontrol: do not iterate uninitialized memcgs
      mm: page_alloc: fix zone allocation fairness on UP

Josh Boyer (1):
      drm/vmwgfx: Fix drm.h include

Karl Beldan (1):
      mac80211: fix typo in starting baserate for rts_cts_rate_idx

Kirill Tkhai (2):
      sched: Use dl_bw_of() under RCU read lock
      sched: Use rq->rd in sched_setaffinity() under RCU read lock

Krzysztof Kozlowski (2):
      power: charger-manager: Fix NULL pointer exception with missing cm-fu=
el-gauge
      regulator: max77693: Fix use of uninitialized regulator config

Lai Jiangshan (1):
      drbd: compute the end before rb_insert_augmented()

Lars-Peter Clausen (5):
      staging:iio:ad5933: Fix NULL pointer deref when enabling buffer
      staging:iio:ad5933: Drop "raw" from channel names
      staging:iio:ade7758: Fix NULL pointer deref when enabling buffer
      staging:iio:ade7758: Fix check if channels are enabled in prenable
      staging:iio:ade7758: Remove "raw" from channel name

Li RongQing (4):
      vxlan: fix a use after free in vxlan_encap_bypass
      vxlan: using pskb_may_pull as early as possible
      vxlan: fix a free after use
      ipv4: fix a potential use after free in ip_tunnel_core.c

Libin Yang (2):
      ALSA: hda - add PCI IDs for Intel Braswell
      ALSA: hda - add codec ID for Braswell display audio codec

Maciej Matraszek (1):
      media: v4l2-common: fix overflow in v4l_bound_align_image()

Marc-Andr=E9 Lureau (1):
      qxl: don't create too large primary surface

Markos Chandras (1):
      MIPS: ftrace: Fix a microMIPS build problem

Mathias Krause (1):
      posix-timers: Fix stack info leak in timer_create()

Michael S. Tsirkin (2):
      virtio_pci: fix virtio spec compliance on restore
      kvm: x86: don't kill guest on unknown exit reason

Michal Hocko (1):
      OOM, PM: OOM killed task shouldn't escape PM suspend

Mika Westerberg (1):
      cpufreq: intel_pstate: Add CPU ID for Braswell processor

Mike Snitzer (1):
      block: fix alignment_offset math that assumes io_min is a power-of-2

Mikulas Patocka (3):
      fs: make cont_expand_zero interruptible
      dm bufio: when done scanning return from __scan immediately
      framebuffer: fix border color

Nadav Amit (3):
      KVM: x86: Check non-canonical addresses upon WRMSR
      KVM: x86: Fix wrong masking on relative jump/call
      KVM: x86: Emulator fixes for eip canonical checks on near branches

Nathaniel Ting (1):
      USB: serial: cp210x: add Silicon Labs 358x VID and PID

Nicholas Bellinger (1):
      target: Fix APTPL metadata handling for dynamic MappedLUNs

Olaf Hering (1):
      drm/cirrus: bind also to qemu-xen-traditional

Oleg Nesterov (2):
      x86, fpu: __restore_xstate_sig()->math_state_restore() needs preempt_=
disable()
      x86, fpu: shift drop_init_fpu() from save_xstate_sig() to handle_sign=
al()

Ondrej Kozina (1):
      crypto: algif - avoid excessive use of socket buffer in skcipher

Ondrej Zary (1):
      libata-sff: Fix controllers with no ctl port

Ong Boon Leong (3):
      x86, iosf: Added Quark MBI identifiers
      x86, iosf: Add Quark X1000 PCI ID
      x86, iosf: Add PCI ID macros for better readability

Pali Roh=E1r (1):
      cpufreq: intel_pstate: Fix setting max_perf_pct in performance policy

Paul Fertser (1):
      media: usb: uvc: add a quirk for Dell XPS M1330 webcam

Perry Hung (1):
      usb: serial: ftdi_sio: add "bricked" FTDI device PID

Peter Hurley (2):
      serial: Fix divide-by-zero fault in uart_get_divisor()
      tty: Fix high cpu load if tty is unreleaseable

Petr Matousek (1):
      kvm: vmx: handle invvpid vm exit gracefully

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

Robert Baldyga (1):
      usb: gadget: f_fs: remove redundant ffs_data_get()

Robin van der Gracht (1):
      iio: st_sensors: Fix buffer copy

Roger Pau Monn=E9 (1):
      xen-blkback: fix leak on grant map error path

Roger Tseng (1):
      mmc: rtsx_pci_sdmmc: fix incorrect last byte in R2 response

Scot Doyle (1):
      drm/i915: don't warn if backlight unexpectedly enabled

Scott Carter (1):
      pata_serverworks: disable 64-KB DMA transfers on Broadcom OSB4 IDE Co=
ntroller

Sebastian Andrzej Siewior (2):
      mfd: ti_am335x_tscadc: Fix TSC resume
      usb: musb: dsps: start OTG timer on resume again

Sinclair Yeh (1):
      drm/vmwgfx: Filter out modes those cannot be supported by the current=
 VRAM size.

Stephen Smalley (1):
      selinux: fix inode security list corruption

Takashi Iwai (2):
      ALSA: pcm: Zero-clear reserved fields of PCM status ioctl in compat m=
ode
      ALSA: usb-audio: Fix device_del() sysfs warnings at disconnect

Tetsuo Handa (1):
      fs: Fix theoretical division by 0 in super_cache_scan().

Theodore Ts'o (1):
      ext4: add ext4_iget_normal() which is to be used for dir tree lookups

Thomas Gleixner (1):
      usb: musb: cppi41: restart hrtimer only if not yet done

Thorsten Knabe (1):
      um: ubd: Fix for processes stuck in D state forever

Tom Herbert (1):
      gre: Use inner mac length when computing tunnel length

Trond Myklebust (1):
      SUNRPC: Add missing support for RPC_CLNT_CREATE_NO_RETRANS_TIMEOUT

Ulrich Eckhardt (1):
      media: ds3000: fix LNB supply voltage on Tevii S480 on initialization

Valdis Kletnieks (1):
      pstore: Fix duplicate {console,ftrace}-efi entries

Vasily Averin (1):
      ipv4: dst_entry leak in ip_send_unicast_reply()

Vignesh R (1):
      mfd: ti_am335x_tscadc: Fix TSC operation after ADC continouous mode

Vineet Gupta (4):
      ARC: [nsimosci] Allow "headless" models to boot
      ARC: [SMP] General Fixes
      ARC: fix mmuv2 warning
      ARC: Disable caches in early boot if so configured

Wang Nan (1):
      cgroup/kmemleak: add kmemleak_free() for cgroup deallocations.

Wolfram Sang (1):
      i2c: at91: don't account as iowait

Xose Vazquez Perez (1):
      wireless: rt2x00: add new rt2800usb devices

Yijing Wang (1):
      sysfs: driver core: Fix glue dir race condition by gdp_mutex

Yu Zhao (1):
      mm: free compound page with correct order


--yrj/dFKFPuw6o+aM
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUZjwZAAoJEDjbvchgkmk+QB8QAIFU5e7go1wCVBKQ/4Bs0+DI
3m3KAc0lA3b5NfBO3/w4VPRaBsS8cuVhwhpa67MkMJAf7ES4Elz11G83bW/DyHc4
yFLEydUm6VkmaJzUhtYVbtEY6sZvJia8cPsZQ6SBw1/clhya1wZOR7nVXbZBQOIg
Kb7I6k1tehhXaofYoPjQlWcq26WwBrH71NbFJt1Q5heJfGkZ2TP5zgNE5QTa+0R4
b3dxv2UCycH7XBtBNLMIHt7NRBTphpYFuOfn36tWzFcGEh//ne4GfQRQ/Ts/RxP0
YWaiHBjbT2ZKG28ca6TZ4Tnjs+lhAEHBoJhfVMT/3i+BHd4wxg+B0PvAn1Kx6uYE
BE7y7jzKSjavX+3AILiwi9Nm9dQZvY8B7YfXkbHQL5FO3R2C94KUxodur3UYzXl6
BTOOkkNW+OCMuXja/4kyudqfX3hbZtXpO4iqhoPlz3orbhaeRI+edcnH/lcfzy3Q
eIJj8fJsxrmopfT2zQ4jYo0q6UVyDcztSUgiveHBVWYdyvbxjW4I/ntJgip3MLJg
wK+0+6+tX9k8baiGNuTdbxkn5jezYQgbw1eLZRHrXolpizzXWYyhnSY1yQudkWCE
1c2gRpyHkRBdZwyVbxO9cEtO8r83E9QE15mNm+Dkjt7iL3sQDDQriS0beLvH95mH
ohA7ilFkRNkpNzk3iKM0
=rP3Q
-----END PGP SIGNATURE-----

--yrj/dFKFPuw6o+aM--
