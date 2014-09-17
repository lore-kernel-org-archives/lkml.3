Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932121AbaIQUth (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 16:49:37 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54531 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932089AbaIQUte (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 16:49:34 -0400
Date: Wed, 17 Sep 2014 13:48:45 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.16.3
Message-ID: <20140917204845.GA20863@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="huq684BweRXVnRxX"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--huq684BweRXVnRxX
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.16.3 kernel.

All users of the 3.16 kernel series must upgrade.

The updated 3.16.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-3.16.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dsu=
mmary

thanks,

greg k-h

------------

 Documentation/devicetree/bindings/sound/adi,axi-spdif-tx.txt |    2=20
 Makefile                                                     |    2=20
 arch/arm/boot/dts/omap3-n900.dts                             |    2=20
 arch/mips/cavium-octeon/setup.c                              |   18=20
 arch/mips/include/asm/eva.h                                  |   43 +
 arch/mips/include/asm/mach-malta/kernel-entry-init.h         |   22=20
 arch/mips/include/asm/ptrace.h                               |    2=20
 arch/mips/include/asm/reg.h                                  |  260 ++++++=
+----
 arch/mips/include/asm/syscall.h                              |    8=20
 arch/mips/kernel/binfmt_elfo32.c                             |   32 -
 arch/mips/kernel/cps-vec.S                                   |    4=20
 arch/mips/kernel/irq-gic.c                                   |    6=20
 arch/mips/kernel/ptrace.c                                    |  196 ++++++=
--
 arch/mips/kernel/ptrace32.c                                  |    2=20
 arch/mips/kernel/scall64-o32.S                               |   12=20
 arch/mips/kernel/smp-mt.c                                    |    2=20
 arch/mips/kernel/unaligned.c                                 |    1=20
 arch/mips/mm/tlbex.c                                         |    1=20
 arch/mips/mti-malta/malta-memory.c                           |   14=20
 arch/powerpc/include/asm/machdep.h                           |    6=20
 arch/powerpc/include/asm/pgtable-ppc64.h                     |    2=20
 arch/powerpc/include/asm/pte-hash64-64k.h                    |   30 +
 arch/powerpc/kernel/iommu.c                                  |   38 -
 arch/powerpc/mm/hash_native_64.c                             |   40 -
 arch/powerpc/mm/hugepage-hash64.c                            |   88 +++
 arch/powerpc/mm/numa.c                                       |    2=20
 arch/powerpc/mm/pgtable_64.c                                 |   38 -
 arch/powerpc/mm/tlb_hash64.c                                 |    2=20
 arch/powerpc/platforms/powernv/pci-ioda.c                    |    2=20
 arch/powerpc/platforms/pseries/hotplug-memory.c              |    2=20
 arch/powerpc/platforms/pseries/iommu.c                       |   20=20
 arch/powerpc/platforms/pseries/lpar.c                        |   20=20
 arch/s390/Kconfig                                            |    1=20
 arch/sh/include/asm/io_noioport.h                            |   11=20
 block/scsi_ioctl.c                                           |    9=20
 drivers/acpi/acpica/nsobject.c                               |   11=20
 drivers/acpi/acpica/utcopy.c                                 |    6=20
 drivers/acpi/ec.c                                            |   21=20
 drivers/acpi/processor_idle.c                                |    4=20
 drivers/acpi/scan.c                                          |   35 -
 drivers/acpi/video.c                                         |   45 +
 drivers/block/rbd.c                                          |  196 +++++-=
--
 drivers/bluetooth/btmrvl_drv.h                               |    1=20
 drivers/bluetooth/btmrvl_main.c                              |   25 +
 drivers/char/tpm/tpm-interface.c                             |   73 ++-
 drivers/char/tpm/tpm_tis.c                                   |   31 +
 drivers/cpufreq/powernv-cpufreq.c                            |   18=20
 drivers/cpuidle/cpuidle-powernv.c                            |   16=20
 drivers/firmware/efi/vars.c                                  |    8=20
 drivers/gpu/drm/nouveau/nouveau_display.c                    |   11=20
 drivers/gpu/drm/nouveau/nouveau_drm.h                        |    4=20
 drivers/gpu/drm/radeon/cik.c                                 |   13=20
 drivers/infiniband/core/iwcm.c                               |   27 +
 drivers/infiniband/ulp/srp/ib_srp.c                          |   38 +
 drivers/iommu/amd_iommu.c                                    |   10=20
 drivers/iommu/intel-iommu.c                                  |   57 +-
 drivers/md/dm-table.c                                        |   13=20
 drivers/md/raid1.c                                           |    8=20
 drivers/md/raid10.c                                          |   14=20
 drivers/md/raid5.c                                           |    4=20
 drivers/media/common/siano/Kconfig                           |    3=20
 drivers/media/i2c/mt9v032.c                                  |    4=20
 drivers/media/media-device.c                                 |    2=20
 drivers/media/platform/vsp1/vsp1_video.c                     |    2=20
 drivers/media/platform/vsp1/vsp1_video.h                     |    1=20
 drivers/media/tuners/xc4000.c                                |   20=20
 drivers/media/tuners/xc5000.c                                |   22=20
 drivers/media/usb/au0828/au0828-video.c                      |   34 -
 drivers/media/v4l2-core/videobuf2-core.c                     |    4=20
 drivers/mfd/omap-usb-host.c                                  |    2=20
 drivers/mfd/rtsx_usb.c                                       |    1=20
 drivers/mfd/twl4030-power.c                                  |   20=20
 drivers/mtd/ftl.c                                            |    1=20
 drivers/mtd/nand/omap2.c                                     |    2=20
 drivers/power/bq2415x_charger.c                              |    8=20
 drivers/regulator/arizona-ldo1.c                             |    2=20
 drivers/regulator/tps65218-regulator.c                       |    2=20
 drivers/scsi/bfa/bfa_ioc.h                                   |    2=20
 drivers/scsi/scsi.c                                          |   16=20
 drivers/scsi/scsi_devinfo.c                                  |    1=20
 drivers/scsi/scsi_scan.c                                     |   16=20
 drivers/scsi/scsi_transport_srp.c                            |    3=20
 drivers/scsi/sd.c                                            |    5=20
 drivers/scsi/storvsc_drv.c                                   |  113 +++-
 drivers/spi/spi-omap2-mcspi.c                                |   14=20
 drivers/spi/spi-orion.c                                      |   10=20
 drivers/spi/spi-pxa2xx.c                                     |    1=20
 drivers/xen/events/events_fifo.c                             |   48 +-
 fs/cifs/cifsglob.h                                           |    7=20
 fs/cifs/file.c                                               |    6=20
 fs/cifs/inode.c                                              |   11=20
 fs/cifs/readdir.c                                            |    6=20
 fs/cifs/smb1ops.c                                            |    7=20
 fs/cifs/smb2file.c                                           |    2=20
 fs/cifs/smb2inode.c                                          |    2=20
 fs/cifs/smb2maperror.c                                       |    4=20
 fs/cifs/smb2ops.c                                            |   11=20
 fs/cifs/smb2pdu.c                                            |   14=20
 fs/dcache.c                                                  |    3=20
 fs/namei.c                                                   |    4=20
 fs/namespace.c                                               |  100 +++-
 fs/notify/fanotify/fanotify.c                                |    9=20
 fs/notify/fanotify/fanotify_user.c                           |   12=20
 fs/notify/notification.c                                     |   18=20
 fs/ocfs2/ioctl.c                                             |  129 +----
 fs/pnode.c                                                   |    1=20
 fs/proc/array.c                                              |   11=20
 fs/reiserfs/do_balan.c                                       |  111 ++--
 fs/reiserfs/journal.c                                        |   22=20
 fs/reiserfs/lbalance.c                                       |    5=20
 fs/reiserfs/reiserfs.h                                       |    9=20
 fs/reiserfs/super.c                                          |    6=20
 fs/xfs/xfs_aops.c                                            |   61 ++
 fs/xfs/xfs_dquot.c                                           |    3=20
 fs/xfs/xfs_file.c                                            |   21=20
 fs/xfs/xfs_log_recover.c                                     |   51 +-
 fs/xfs/xfs_qm.c                                              |    8=20
 include/acpi/acpi_bus.h                                      |    1=20
 include/linux/capability.h                                   |    5=20
 include/linux/fsnotify_backend.h                             |    2=20
 include/linux/mount.h                                        |    9=20
 include/linux/tpm.h                                          |    3=20
 include/scsi/scsi_device.h                                   |    1=20
 include/scsi/scsi_devinfo.h                                  |    5=20
 include/uapi/rdma/rdma_user_cm.h                             |    1=20
 kernel/audit.c                                               |    2=20
 kernel/capability.c                                          |    4=20
 kernel/smp.c                                                 |    2=20
 kernel/trace/ring_buffer.c                                   |   31 -
 lib/assoc_array.c                                            |    6=20
 mm/filemap.c                                                 |    2=20
 mm/hugetlb.c                                                 |    3=20
 net/bluetooth/hci_event.c                                    |   23=20
 net/bluetooth/l2cap_sock.c                                   |    3=20
 net/bluetooth/rfcomm/core.c                                  |    7=20
 net/bluetooth/rfcomm/sock.c                                  |    3=20
 net/bluetooth/sco.c                                          |    6=20
 net/ceph/auth_x.c                                            |  256 +++++-=
----
 net/ceph/messenger.c                                         |    2=20
 net/ceph/mon_client.c                                        |    8=20
 security/commoncap.c                                         |    3=20
 sound/soc/blackfin/bf5xx-i2s-pcm.c                           |    8=20
 sound/soc/codecs/adau1701.c                                  |    6=20
 sound/soc/codecs/max98090.c                                  |    2=20
 sound/soc/codecs/rt5640.c                                    |    1=20
 sound/soc/codecs/tlv320aic31xx.c                             |    9=20
 sound/soc/codecs/wm8994.c                                    |    9=20
 sound/soc/codecs/wm_adsp.c                                   |    2=20
 sound/soc/intel/sst-baytrail-pcm.c                           |    2=20
 sound/soc/intel/sst-haswell-pcm.c                            |   27 -
 sound/soc/omap/omap-twl4030.c                                |    2=20
 sound/soc/pxa/pxa-ssp.c                                      |    7=20
 sound/soc/samsung/i2s.c                                      |   16=20
 sound/soc/soc-pcm.c                                          |    1=20
 tools/testing/selftests/Makefile                             |    1=20
 tools/testing/selftests/mount/Makefile                       |   17=20
 tools/testing/selftests/mount/unprivileged-remount-test.c    |  242 ++++++=
++++
 157 files changed, 2362 insertions(+), 1020 deletions(-)

Aaro Koskinen (1):
      MIPS: OCTEON: make get_system_type() thread-safe

Al Viro (4):
      get rid of propagate_umount() mistakenly treating slaves as busy.
      fix EBUSY on umount() from MNT_SHRINKABLE
      __generic_file_write_iter(): fix handling of sync error after DIO
      fix copy_tree() regression

Alan Cox (1):
      spi/pxa2xx: Add ACPI ID for Intel Braswell

Alex Deucher (1):
      drm/radeon: use packet2 for nop on hawaii with old firmware

Alex Smith (5):
      MIPS: O32/32-bit: Fix bug which can cause incorrect system call resta=
rts
      MIPS: ptrace: Test correct task's flags in task_user_regset_view()
      MIPS: ptrace: Change GP regset to use correct core dump register layo=
ut
      MIPS: ptrace: Avoid smp_processor_id() when retrieving FPU IR
      MIPS: asm/reg.h: Make 32- and 64-bit definitions available at the sam=
e time

Alex Williamson (1):
      iommu/vt-d: Exclude devices using RMRRs from IOMMU API domains

Andreas F=E4rber (1):
      ASoC: axi: Fix ADI AXI SPDIF specification

Andrey Utkin (1):
      powerpc/mm/numa: Fix break placement

Aneesh Kumar K.V (7):
      powerpc/mm: Use read barrier when creating real_pte
      powerpc/thp: Add write barrier after updating the valid bit
      powerpc/thp: Don't recompute vsid and ssize in loop on invalidate
      powerpc/thp: Invalidate old 64K based hash page mapping before insert=
 of 4k pte
      powerpc/thp: Handle combo pages in invalidate
      powerpc/thp: Invalidate with vpn in loop
      powerpc/thp: Use ACCESS_ONCE when loading pmdp

Bart Van Assche (2):
      scsi_transport_srp: Fix fast_io_fail_tmo=3Ddev_loss_tmo=3Doff behavior
      IB/srp: Fix deadlock between host removal and multipathd

Ben Hutchings (2):
      ocfs2: do not write error flag to user structure we cannot copy from/=
to
      bfa: Fix undefined bit shift on big-endian architectures with 32-bit =
DMA address

Charles Keepax (1):
      ASoC: wm8994: Prevent double lock of accdet_lock mutex on wm1811

Chin-Ran Lo (1):
      Bluetooth: btmrvl: wait for HOST_SLEEP_ENABLE event in suspend

Chris Mason (1):
      xfs: don't zero partial page cache pages during O_DIRECT writes

Christian Borntraeger (1):
      s390/locking: Reenable optimistic spinning

Dan Carpenter (1):
      ASoC: pxa: pxa-ssp: small leak in probe()

Daniel Mack (2):
      ASoC: adau1701: fix adau1701_reg_read()
      ASoC: pxa-ssp: drop SNDRV_PCM_FMTBIT_S24_LE

Dave Chinner (4):
      xfs: ensure verifiers are attached to recovered buffers
      xfs: quotacheck leaves dquot buffers without verifiers
      xfs: don't dirty buffers beyond EOF
      xfs: don't zero partial page cache pages during O_DIRECT writes

David E. Box (2):
      ACPICA: Utilities: Fix memory leak in acpi_ut_copy_iobject_to_iobject
      ACPICA: Namespace: Properly null terminate objects detached from a na=
mespace node

David Howells (2):
      KEYS: Fix use-after-free in assoc_array_gc()
      KEYS: Fix termination condition in assoc array garbage collection

David Vrabel (1):
      xen/events/fifo: reset control block and local HEADs on resume

Doug Ledford (1):
      RDMA/uapi: Include socket.h in rdma_user_cm.h

Eric Paris (1):
      CAPABILITIES: remove undefined caps from all processes

Eric W. Biederman (5):
      mnt: Only change user settable mount flags in remount
      mnt: Move the test for MNT_LOCK_READONLY from change_mount_flags into=
 do_remount
      mnt: Correct permission checks in do_remount
      mnt: Change the default remount atime from relatime to the existing v=
alue
      mnt: Add tests for unprivileged remount cases that have found to be f=
aulty

Felipe Balbi (1):
      regulator: tps65218: fix DCDC4 linear voltage range

Gavin Shan (3):
      powerpc/powernv: Fix IOMMU group lost
      powerpc/pseries: Failure on removing device node
      powerpc/pseries: Avoid deadlock on removing ddw

Greg Kroah-Hartman (1):
      Linux 3.16.3

Guenter Roeck (1):
      firmware: Do not use WARN_ON(!spin_is_locked())

Hannes Reinecke (1):
      scsi_scan: Restrict sequential scan to 256 LUNs

Hans de Goede (3):
      ACPI / video: Fix use_native_backlight selection logic
      ACPI / video: Add a disable_native_backlight quirk
      ACPI / video: Disable native_backlight on HP ENVY 15 Notebook PC

Huacai Chen (2):
      MIPS: tlbex: Fix a missing statement for HUGETLB
      MIPS: Remove BUG_ON(!is_fpu_owner()) in do_ade()

Ilya Dryomov (4):
      rbd: rework rbd_request_fn()
      libceph: set last_piece in ceph_msg_data_pages_cursor_init() correctly
      libceph: add process_one_ticket() helper
      libceph: do not hard code max auth ticket len

James Bottomley (1):
      scsi: use short driver name for per-driver cmd slab caches

James Hogan (1):
      MIPS: smp-mt: Fix link error when PROC_FS=3Dn

Jan Kara (2):
      reiserfs: Fix use after free in journal teardown
      fanotify: fix double free of pending permission events

Janusz Dziemidowicz (1):
      scsi: do not issue SCSI RSOC command to Promise Vtrak E610f

Jarkko Nikula (2):
      ASoC: max98090: Fix missing free_irq
      ASoC: rt5640: Do not allow regmap to use bulk read-write operations

Jarkko Sakkinen (1):
      tpm: missing tpm_chip_put in tpm_get_random()

Jason Gunthorpe (1):
      tpm: Provide a generic means to override the chip returned timeouts

Jeff Mahoney (2):
      reiserfs: fix corruption introduced by balance_leaf refactor
      drivers/mfd/rtsx_usb.c: export device table

Jeff Moyer (1):
      dm table: propagate QUEUE_FLAG_NO_SG_MERGE

Jeffrey Deans (1):
      MIPS: GIC: Prevent array overrun

Jie Yang (1):
      ASoC: Intel: Cleanup HSW pcm format support

Jiri Kosina (1):
      ACPI / cpuidle: fix deadlock between cpuidle_lock and cpu_hotplug.lock

Joerg Roedel (2):
      iommu/vt-d: Defer domain removal if device is assigned to a driver
      iommu/amd: Fix cleanup_domain for mass device removal

Johan Hedberg (2):
      Bluetooth: Fix tracking local SSP authentication requirement
      Bluetooth: Fix using uninitialized variable when pairing

Juergen Gross (1):
      SCSI: save command pool address of Scsi_Host

K. Y. Srinivasan (7):
      Drivers: scsi: storvsc: Implement a eh_timed_out handler
      Drivers: scsi: storvsc: Filter commands based on the storage protocol=
 version
      Drivers: scsi: storvsc: Change the limits to reflect the values on th=
e host
      Drivers: scsi: storvsc: Set cmd_per_lun to reflect value supported by=
 the Host
      Drivers: scsi: storvsc: Fix a bug in handling VMBUS protocol version
      drivers: scsi: storvsc: Set srb_flags in all cases
      drivers: scsi: storvsc: Correctly handle TEST_UNIT_READY failure

Kevin Hao (1):
      mtd/ftl: fix the double free of the buffers allocated in build_maps()

Lan Tianyu (1):
      ACPI: Run fixed event device notifications in process context

Laurent Pinchart (2):
      media: v4l: vsp1: Remove the unneeded vsp1_video_buffer video field
      media: v4l: vb2: Fix stream start and buffer completion race

Li Zhong (1):
      mm: fix potential infinite loop in dissolve_free_huge_pages()

Linus Torvalds (1):
      vfs: fix bad hashing of dentries

Lv Zheng (2):
      ACPI / EC: Add support to disallow QR_EC to be issued when SCI_EVT is=
n't set
      ACPI / EC: Add support to disallow QR_EC to be issued before completi=
ng previous QR_EC

Marcel Holtmann (1):
      Bluetooth: Fix merge of advertising data and scan response data

Mario Kleiner (2):
      drm/nouveau: Dis/Enable vblank irqs during suspend/resume.
      drm/nouveau: Bump version from 1.1.1 to 1.1.2

Mark A. Greer (1):
      spi: omap2-mcspi: Configure hardware when slave driver changes mode

Markos Chandras (6):
      MIPS: syscall: Fix AUDIT value for O32 processes on MIPS64
      MIPS: scall64-o32: Fix indirect syscall detection
      MIPS: Malta: Improve system memory detection for '{e, }memsize' >=3D =
2G
      MIPS: EVA: Add new EVA header
      MIPS: Malta: EVA: Rename 'eva_entry' to 'platform_eva_init'
      MIPS: CPS: Initialize EVA before bringing up VPEs from secondary cores

Martin K. Petersen (1):
      scsi: add a blacklist flag which enables VPD page inquiries

Mauro Carvalho Chehab (3):
      media: xc5000: Fix get_frequency()
      media: xc4000: Fix get_frequency()
      media: au0828: Only alt setting logic when needed

Michael Welling (1):
      mfd: omap-usb-host: Fix improper mask use.

NeilBrown (5):
      md/raid1,raid10: always abort recover on write error.
      md/raid5: avoid livelock caused by non-aligned writes.
      md/raid6: avoid data corruption during recovery of double-degraded RA=
ID6
      md/raid10: fix memory leak when reshaping a RAID10.
      md/raid10: Fix memory leak when raid10 reshape completes.

Nikesh Oswal (1):
      regulator: arizona-ldo1: remove bypass functionality

Paul Bolle (1):
      media: sms: Remove CONFIG_ prefix from Kconfig symbols

Paul Burton (1):
      MIPS: Prevent user from setting FCSR cause bits

Pavel Shilovsky (7):
      CIFS: Fix STATUS_CANNOT_DELETE error mapping for SMB2
      CIFS: Fix async reading on reconnects
      CIFS: Fix wrong directory attributes after rename
      CIFS: Fix directory rename error
      CIFS: Fix wrong filename length for SMB2
      CIFS: Fix wrong restart readdir for SMB1
      CIFS: Fix SMB2 readdir error handling

Peter Ujfalusi (2):
      ASoC: tlv320aic31xx: Do not ignore errors in aic31xx_device_init()
      ASoC: omap-twl4030: Fix typo in 2nd dai link's platform_name

Philipp Zabel (1):
      media: mt9v032: fix hblank calculation

Pranith Kumar (1):
      sh: fix build error by adding generic ioport_{map/unmap}()

Praveen Diwakar (1):
      ASoC: wm_adsp: Add missing MODULE_LICENSE

Qiao Zhou (1):
      ASoC: pcm: fix dpcm_path_put in dpcm runtime update

Rafael J. Wysocki (1):
      ACPI / scan: Allow ACPI drivers to bind to PNP device objects

Roger Quadros (1):
      mtd: nand: omap: Fix 1-bit Hamming code scheme, omap_calculate_ecc()

Sage Weil (1):
      libceph: gracefully handle large reply messages from the mon

Salva Peir=F3 (1):
      media: media-device: Remove duplicated memset() in media_enum_entitie=
s()

Sasha Levin (1):
      kernel/smp.c:on_each_cpu_cond(): fix warning in fallback path

Scott Jiang (1):
      ASoC: blackfin: use samples to set silence

Sebastian Reichel (1):
      bq2415x_charger: Fix Atomic Sleep Bug

Stefan Berger (1):
      tpm: Properly clean sysfs entries in error path

Steve French (1):
      CIFS: Possible null ptr deref in SMB2_tcon

Steve Wise (1):
      RDMA/iwcm: Use a default listen backlog if needed

Steven Rostedt (Red Hat) (2):
      ring-buffer: Always reset iterator to reader page
      ring-buffer: Up rb_iter_peek() loop count to 3

Sylwester Nawrocki (1):
      ASoC: samsung: Correct I2S DAI suspend/resume ops

Tang Chen (1):
      ACPI / hotplug: Check scan handlers in acpi_scan_hot_remove()

Thomas Petazzoni (1):
      spi: orion: fix incorrect handling of cell-index DT property

Tony Battersby (1):
      fix regression in SCSI_IOCTL_SEND_COMMAND

Tony Lindgren (1):
      mfd: twl4030-power: Fix PM idle pin configuration to not conflict wit=
h regulators

Vaidyanathan Srinivasan (2):
      powerpc/cpufreq: Add pr_warn() on OPAL firmware failures
      powerpc/cpuidle: Fix parsing of idle state flags from device-tree

Vignesh Raman (1):
      Bluetooth: Avoid use of session socket after the session gets freed

Vladimir Davydov (1):
      Bluetooth: never linger on process exit

Yasuaki Ishimatsu (1):
      ACPI / scan: not cache _SUN value in struct acpi_device_pnp


--huq684BweRXVnRxX
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUGfOtAAoJEDjbvchgkmk+ThQP+wWJGYc5olsfxWhKuzXPq1g/
fnRH98vppsO0aCVWvZ+3Mrk2gXiyVdWtHoAgQI6S+gjHgox9AnWFI2exNs5BTpW9
NuufizYzXMw4C1hZQxCW88CFzR3yA6Q8kJCZltDnsgADtStxbNEEB3YXe3X41BCS
0wHpZaz6R6uaGs+svqSDevSn6yjHErT4Lj2KSqk5Rn2Xh72CqEA5mglY8Dh8iraj
eQGoL59P+iViE0oqdtCQd5GLnz5ezR09Iy4HT/FkYXbtryg+PDpDbsoJFEWNrFii
AhpWt9dJqX0RJzw0Rx51UWSFxCItCpgJtELYcuzhCb+2RRfh8G47pvKYdxwuGqfL
/x15Blg3vWjgS/4+DwBjLLzYaKL3bHs/Mu7qvolU/zioRJmVttHyLdbvVcMze3Ah
cRTRYMPL6udcK0LAN1u03Skfvlmjz8nzv7fErbo9rHc9ZbCBeDe9aPj026R6tuhS
GQuYPiEqZwxQpy6mCxWDr2QwkfsK3EHUbjZqp8mlctV423AtGPCDoFohxJ8o94Ra
Hys9l90vYujXsROhAn9L2O3mDTBr3C0Vtr1XqgW7A6xWUjQv3W7TRDxdwOKWbdkG
sSLgz6gQOGXdxr4VQjbE6PrXmCUz0fJXE7L4sJ8zQc7chVXNGq25oReI/ZRZSEpp
BroErpDhhSygBm5icuYG
=8RFL
-----END PGP SIGNATURE-----

--huq684BweRXVnRxX--
