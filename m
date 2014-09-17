Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757017AbaIQUtH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 16:49:07 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54523 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756944AbaIQUsr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 16:48:47 -0400
Date: Wed, 17 Sep 2014 13:47:57 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.14.19
Message-ID: <20140917204757.GA14361@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8t9RHnE3ZwKMSgU+"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--8t9RHnE3ZwKMSgU+
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.14.19 kernel.

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

 Documentation/devicetree/bindings/sound/adi,axi-spdif-tx.txt |    2=20
 Makefile                                                     |    2=20
 arch/mips/cavium-octeon/setup.c                              |   18=20
 arch/mips/include/asm/ptrace.h                               |    2=20
 arch/mips/include/asm/reg.h                                  |  260 ++++++=
+----
 arch/mips/kernel/binfmt_elfo32.c                             |   32 -
 arch/mips/kernel/irq-gic.c                                   |    6=20
 arch/mips/kernel/ptrace.c                                    |  192 ++++++=
--
 arch/mips/kernel/unaligned.c                                 |    1=20
 arch/mips/mm/tlbex.c                                         |    1=20
 arch/powerpc/include/asm/machdep.h                           |    6=20
 arch/powerpc/include/asm/pgtable-ppc64.h                     |    2=20
 arch/powerpc/include/asm/pte-hash64-64k.h                    |   30 +
 arch/powerpc/mm/hash_native_64.c                             |   40 -
 arch/powerpc/mm/hugepage-hash64.c                            |   88 +++
 arch/powerpc/mm/numa.c                                       |    2=20
 arch/powerpc/mm/pgtable_64.c                                 |   38 -
 arch/powerpc/mm/tlb_hash64.c                                 |    2=20
 arch/powerpc/platforms/pseries/hotplug-memory.c              |    2=20
 arch/powerpc/platforms/pseries/iommu.c                       |   20=20
 arch/powerpc/platforms/pseries/lpar.c                        |   20=20
 arch/s390/Kconfig                                            |    1=20
 drivers/acpi/acpica/utcopy.c                                 |    6=20
 drivers/acpi/processor_idle.c                                |    4=20
 drivers/acpi/scan.c                                          |   33 -
 drivers/bluetooth/btmrvl_drv.h                               |    1=20
 drivers/bluetooth/btmrvl_main.c                              |   25 +
 drivers/char/tpm/tpm-interface.c                             |   73 ++-
 drivers/char/tpm/tpm_tis.c                                   |   31 +
 drivers/firmware/efi/vars.c                                  |    8=20
 drivers/gpu/drm/nouveau/nouveau_drm.h                        |    4=20
 drivers/gpu/drm/radeon/cik.c                                 |   13=20
 drivers/infiniband/core/iwcm.c                               |   27 +
 drivers/infiniband/ulp/srp/ib_srp.c                          |   38 +
 drivers/iommu/amd_iommu.c                                    |   10=20
 drivers/md/raid1.c                                           |    8=20
 drivers/md/raid10.c                                          |   14=20
 drivers/md/raid5.c                                           |    2=20
 drivers/media/common/siano/Kconfig                           |    3=20
 drivers/media/i2c/mt9v032.c                                  |    4=20
 drivers/media/media-device.c                                 |    2=20
 drivers/media/platform/vsp1/vsp1_video.c                     |    2=20
 drivers/media/platform/vsp1/vsp1_video.h                     |    1=20
 drivers/media/tuners/xc4000.c                                |   20=20
 drivers/media/tuners/xc5000.c                                |   22=20
 drivers/media/usb/au0828/au0828-video.c                      |   34 -
 drivers/mfd/omap-usb-host.c                                  |    2=20
 drivers/mtd/ftl.c                                            |    1=20
 drivers/mtd/nand/omap2.c                                     |    2=20
 drivers/power/bq2415x_charger.c                              |    8=20
 drivers/regulator/arizona-ldo1.c                             |    2=20
 drivers/scsi/bfa/bfa_ioc.h                                   |    2=20
 drivers/scsi/scsi_devinfo.c                                  |    1=20
 drivers/scsi/scsi_scan.c                                     |   16=20
 drivers/scsi/scsi_transport_srp.c                            |    3=20
 drivers/scsi/sd.c                                            |    5=20
 drivers/scsi/storvsc_drv.c                                   |  113 +++-
 drivers/spi/spi-omap2-mcspi.c                                |   14=20
 drivers/spi/spi-orion.c                                      |   10=20
 drivers/spi/spi-pxa2xx.c                                     |    1=20
 drivers/xen/events/events_fifo.c                             |   48 +-
 fs/cifs/cifsglob.h                                           |    5=20
 fs/cifs/file.c                                               |    4=20
 fs/cifs/inode.c                                              |   11=20
 fs/cifs/readdir.c                                            |    4=20
 fs/cifs/smb2file.c                                           |    2=20
 fs/cifs/smb2inode.c                                          |    2=20
 fs/cifs/smb2maperror.c                                       |    2=20
 fs/cifs/smb2ops.c                                            |    2=20
 fs/cifs/smb2pdu.c                                            |    5=20
 fs/dcache.c                                                  |    3=20
 fs/namei.c                                                   |   27 -
 fs/namespace.c                                               |  100 +++-
 fs/pnode.c                                                   |    1=20
 fs/proc/array.c                                              |   11=20
 fs/xfs/xfs_aops.c                                            |   61 ++
 fs/xfs/xfs_dquot.c                                           |    3=20
 fs/xfs/xfs_file.c                                            |   21=20
 fs/xfs/xfs_log_recover.c                                     |   51 +-
 fs/xfs/xfs_qm.c                                              |    8=20
 include/acpi/acpi_bus.h                                      |    1=20
 include/linux/capability.h                                   |    5=20
 include/linux/dcache.h                                       |    7=20
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
 sound/soc/codecs/wm8994.c                                    |    9=20
 sound/soc/codecs/wm_adsp.c                                   |    2=20
 sound/soc/pxa/pxa-ssp.c                                      |    7=20
 sound/soc/samsung/i2s.c                                      |   16=20
 sound/soc/soc-pcm.c                                          |    1=20
 tools/testing/selftests/Makefile                             |    1=20
 tools/testing/selftests/mount/Makefile                       |   17=20
 tools/testing/selftests/mount/unprivileged-remount-test.c    |  242 ++++++=
++++
 113 files changed, 1692 insertions(+), 688 deletions(-)

Aaro Koskinen (1):
      MIPS: OCTEON: make get_system_type() thread-safe

Al Viro (3):
      get rid of propagate_umount() mistakenly treating slaves as busy.
      fix EBUSY on umount() from MNT_SHRINKABLE
      fix copy_tree() regression

Alan Cox (1):
      spi/pxa2xx: Add ACPI ID for Intel Braswell

Alex Deucher (1):
      drm/radeon: use packet2 for nop on hawaii with old firmware

Alex Smith (4):
      MIPS: O32/32-bit: Fix bug which can cause incorrect system call resta=
rts
      MIPS: ptrace: Test correct task's flags in task_user_regset_view()
      MIPS: ptrace: Change GP regset to use correct core dump register layo=
ut
      MIPS: asm/reg.h: Make 32- and 64-bit definitions available at the sam=
e time

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

Ben Hutchings (1):
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

David E. Box (1):
      ACPICA: Utilities: Fix memory leak in acpi_ut_copy_iobject_to_iobject

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

Gavin Shan (2):
      powerpc/pseries: Failure on removing device node
      powerpc/pseries: Avoid deadlock on removing ddw

Greg Kroah-Hartman (1):
      Linux 3.14.19

Guenter Roeck (1):
      firmware: Do not use WARN_ON(!spin_is_locked())

Hannes Reinecke (1):
      scsi_scan: Restrict sequential scan to 256 LUNs

Huacai Chen (2):
      MIPS: tlbex: Fix a missing statement for HUGETLB
      MIPS: Remove BUG_ON(!is_fpu_owner()) in do_ade()

Ilya Dryomov (3):
      libceph: set last_piece in ceph_msg_data_pages_cursor_init() correctly
      libceph: add process_one_ticket() helper
      libceph: do not hard code max auth ticket len

Janusz Dziemidowicz (1):
      scsi: do not issue SCSI RSOC command to Promise Vtrak E610f

Jarkko Nikula (2):
      ASoC: max98090: Fix missing free_irq
      ASoC: rt5640: Do not allow regmap to use bulk read-write operations

Jarkko Sakkinen (1):
      tpm: missing tpm_chip_put in tpm_get_random()

Jason Gunthorpe (1):
      tpm: Provide a generic means to override the chip returned timeouts

Jeffrey Deans (1):
      MIPS: GIC: Prevent array overrun

Jiri Kosina (1):
      ACPI / cpuidle: fix deadlock between cpuidle_lock and cpu_hotplug.lock

Joerg Roedel (1):
      iommu/amd: Fix cleanup_domain for mass device removal

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

Laurent Pinchart (1):
      media: v4l: vsp1: Remove the unneeded vsp1_video_buffer video field

Linus Torvalds (1):
      vfs: fix bad hashing of dentries

Mario Kleiner (1):
      drm/nouveau: Bump version from 1.1.1 to 1.1.2

Mark A. Greer (1):
      spi: omap2-mcspi: Configure hardware when slave driver changes mode

Martin K. Petersen (1):
      scsi: add a blacklist flag which enables VPD page inquiries

Mauro Carvalho Chehab (3):
      media: xc5000: Fix get_frequency()
      media: xc4000: Fix get_frequency()
      media: au0828: Only alt setting logic when needed

Michael Welling (1):
      mfd: omap-usb-host: Fix improper mask use.

Miklos Szeredi (1):
      vfs: add d_is_dir()

NeilBrown (4):
      md/raid1,raid10: always abort recover on write error.
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

Pavel Shilovsky (6):
      CIFS: Fix STATUS_CANNOT_DELETE error mapping for SMB2
      CIFS: Fix async reading on reconnects
      CIFS: Fix wrong directory attributes after rename
      CIFS: Fix directory rename error
      CIFS: Fix wrong filename length for SMB2
      CIFS: Fix wrong restart readdir for SMB1

Philipp Zabel (1):
      media: mt9v032: fix hblank calculation

Praveen Diwakar (1):
      ASoC: wm_adsp: Add missing MODULE_LICENSE

Qiao Zhou (1):
      ASoC: pcm: fix dpcm_path_put in dpcm runtime update

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

Vignesh Raman (1):
      Bluetooth: Avoid use of session socket after the session gets freed

Vladimir Davydov (1):
      Bluetooth: never linger on process exit

Yasuaki Ishimatsu (1):
      ACPI / scan: not cache _SUN value in struct acpi_device_pnp


--8t9RHnE3ZwKMSgU+
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUGfN9AAoJEDjbvchgkmk+pFMP/1zYu/gPJi1TxYIBBN9X7/zT
RUoQtVKXu+FUVmUx4TWPyACmxeX4JbX4ML5/jq3Yrn9fBLuJCro5+v460RHKLYvh
LMCwTCNhksS47Cow7k2rBma93fbujnW4aWTiPTOHPc2Lm7v0FX4LaM31wtLrXyIf
XRT9wtjhCZuMa/ytxAv33qS1PT6Cex3fVgd7w0ijmKCuqsE9PFamIAdQwwQNm4Vb
iM5+Gviws05WU1ekmlXIkzacSueH51Zu9Nv/j1tgyPJR3Pt48NBHS8wlKBTWP1IH
UffXGApYc1mA07T/Jt+8zBpoeUQOSqYsfK8RUv+M5dwZI2BTLyUjgRO+Jw3Q8wfb
+2lN0hCJ5fOH3ySbeURSiwiL6bcCmuMd4MZjUK/5zqD9XBpwYnQuqqupAevmaaTO
5hCDLHuops9a+Y8E6Aa8dqUZtNzEtT9WVl/UoLAs4ggL+Kd8BaiZlTbFRvIkANtx
X9DZcxzOG40r1xJobVGoj7X3aVdgqTZktmhWnWrszIh+I7K011KmWVLjN1nK+wNA
v2CAUoiii1y1e/RKIxYkYxJQwVtBxTeDmV/XXxxji284wTDptJ+iJUeyQPXL5xIb
EyYNFdkdGtkvAFW8D+lJtQcfiagUHYZsi9WFm5SX0KEfmBHxJxJ/xQ9QmBrOXNgX
Gw5htdpr+hjXh2a5LinN
=Jhod
-----END PGP SIGNATURE-----

--8t9RHnE3ZwKMSgU+--
