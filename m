Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756864AbaIQUsW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 16:48:22 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54513 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756472AbaIQUsU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 16:48:20 -0400
Date: Wed, 17 Sep 2014 13:47:31 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.10.55
Message-ID: <20140917204731.GA8837@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="envbJBWh7q8WU6mo"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--envbJBWh7q8WU6mo
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.10.55 kernel.

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

 Makefile                                                  |    2=20
 arch/mips/cavium-octeon/setup.c                           |   18=20
 arch/mips/include/asm/reg.h                               |  260 +++++++++=
-----
 arch/mips/include/asm/thread_info.h                       |    2=20
 arch/mips/kernel/binfmt_elfo32.c                          |   32 -
 arch/mips/kernel/irq-gic.c                                |    6=20
 arch/mips/kernel/ptrace.c                                 |    3=20
 arch/mips/kernel/scall32-o32.S                            |    2=20
 arch/mips/kernel/scall64-64.S                             |    2=20
 arch/mips/kernel/scall64-n32.S                            |    2=20
 arch/mips/kernel/scall64-o32.S                            |    2=20
 arch/mips/kernel/unaligned.c                              |    1=20
 arch/mips/mm/c-r4k.c                                      |    5=20
 arch/mips/mm/tlbex.c                                      |    1=20
 arch/openrisc/kernel/entry.S                              |   59 +--
 arch/openrisc/kernel/signal.c                             |  198 +++++-----
 arch/powerpc/include/asm/pte-hash64-64k.h                 |   32 +
 arch/powerpc/mm/numa.c                                    |    2=20
 arch/powerpc/platforms/pseries/hotplug-memory.c           |    2=20
 block/blk-cgroup.c                                        |    7=20
 drivers/acpi/acpica/utcopy.c                              |    6=20
 drivers/acpi/processor_idle.c                             |    4=20
 drivers/acpi/scan.c                                       |   15=20
 drivers/char/tpm/tpm.c                                    |   69 ++-
 drivers/char/tpm/tpm.h                                    |    3=20
 drivers/char/tpm/tpm_tis.c                                |   31 +
 drivers/firmware/efi/vars.c                               |    8=20
 drivers/infiniband/core/iwcm.c                            |   27 +
 drivers/infiniband/ulp/srp/ib_srp.c                       |   38 +-
 drivers/iommu/amd_iommu.c                                 |   10=20
 drivers/md/raid1.c                                        |    8=20
 drivers/md/raid10.c                                       |   11=20
 drivers/md/raid5.c                                        |    2=20
 drivers/media/media-device.c                              |    2=20
 drivers/media/tuners/xc4000.c                             |   20 -
 drivers/media/tuners/xc5000.c                             |   22 -
 drivers/media/usb/au0828/au0828-video.c                   |   34 -
 drivers/mfd/omap-usb-host.c                               |    2=20
 drivers/mtd/ftl.c                                         |    1=20
 drivers/mtd/nand/omap2.c                                  |    2=20
 drivers/regulator/arizona-ldo1.c                          |    2=20
 drivers/scsi/bfa/bfa_ioc.h                                |    2=20
 drivers/scsi/storvsc_drv.c                                |   19 +
 drivers/spi/spi-omap2-mcspi.c                             |   14=20
 drivers/spi/spi-orion.c                                   |   10=20
 fs/cifs/cifsglob.h                                        |    5=20
 fs/cifs/file.c                                            |    4=20
 fs/cifs/inode.c                                           |    6=20
 fs/cifs/readdir.c                                         |    4=20
 fs/cifs/smb2file.c                                        |    2=20
 fs/cifs/smb2inode.c                                       |    2=20
 fs/cifs/smb2maperror.c                                    |    2=20
 fs/cifs/smb2ops.c                                         |    2=20
 fs/cifs/smb2pdu.c                                         |    5=20
 fs/dcache.c                                               |    5=20
 fs/namei.c                                                |    4=20
 fs/namespace.c                                            |   59 ++-
 fs/proc/array.c                                           |   11=20
 fs/xfs/xfs_aops.c                                         |   61 +++
 fs/xfs/xfs_dquot.c                                        |    3=20
 fs/xfs/xfs_file.c                                         |   21 +
 fs/xfs/xfs_qm.c                                           |    8=20
 include/linux/capability.h                                |    5=20
 include/linux/ceph/messenger.h                            |    2=20
 include/linux/mount.h                                     |    9=20
 kernel/audit.c                                            |    2=20
 kernel/capability.c                                       |    4=20
 kernel/smp.c                                              |    2=20
 kernel/trace/ring_buffer.c                                |   31 -
 net/bluetooth/l2cap_sock.c                                |    3=20
 net/bluetooth/rfcomm/core.c                               |    7=20
 net/bluetooth/rfcomm/sock.c                               |    3=20
 net/bluetooth/sco.c                                       |    6=20
 net/ceph/auth_x.c                                         |  256 +++++++--=
----
 net/ceph/messenger.c                                      |    8=20
 net/ceph/mon_client.c                                     |   16=20
 security/commoncap.c                                      |    3=20
 sound/soc/codecs/max98090.c                               |    2=20
 sound/soc/codecs/wm_adsp.c                                |    2=20
 sound/soc/pxa/pxa-ssp.c                                   |    4=20
 sound/soc/samsung/i2s.c                                   |   16=20
 sound/soc/soc-pcm.c                                       |    1=20
 tools/testing/selftests/Makefile                          |    1=20
 tools/testing/selftests/mount/Makefile                    |   17=20
 tools/testing/selftests/mount/unprivileged-remount-test.c |  242 +++++++++=
++++
 85 files changed, 1276 insertions(+), 570 deletions(-)

Aaro Koskinen (1):
      MIPS: OCTEON: make get_system_type() thread-safe

Al Viro (1):
      dcache.c: get rid of pointless macros

Alex Smith (1):
      MIPS: asm/reg.h: Make 32- and 64-bit definitions available at the sam=
e time

Andrey Utkin (1):
      powerpc/mm/numa: Fix break placement

Aneesh Kumar K.V (1):
      powerpc/mm: Use read barrier when creating real_pte

Bart Van Assche (1):
      IB/srp: Fix deadlock between host removal and multipathd

Ben Hutchings (1):
      bfa: Fix undefined bit shift on big-endian architectures with 32-bit =
DMA address

Chris Mason (1):
      xfs: don't zero partial page cache pages during O_DIRECT writes

Daniel Mack (1):
      ASoC: pxa-ssp: drop SNDRV_PCM_FMTBIT_S24_LE

Dave Chinner (3):
      xfs: quotacheck leaves dquot buffers without verifiers
      xfs: don't dirty buffers beyond EOF
      xfs: don't zero partial page cache pages during O_DIRECT writes

David E. Box (1):
      ACPICA: Utilities: Fix memory leak in acpi_ut_copy_iobject_to_iobject

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

Gavin Shan (1):
      powerpc/pseries: Failure on removing device node

Greg Kroah-Hartman (1):
      Linux 3.10.55

Guenter Roeck (1):
      firmware: Do not use WARN_ON(!spin_is_locked())

Huacai Chen (2):
      MIPS: tlbex: Fix a missing statement for HUGETLB
      MIPS: Remove BUG_ON(!is_fpu_owner()) in do_ade()

Ilya Dryomov (4):
      libceph: set last_piece in ceph_msg_data_pages_cursor_init() correctly
      libceph: add process_one_ticket() helper
      libceph: do not hard code max auth ticket len
      libceph: rename ceph_msg::front_max to front_alloc_len

Jarkko Nikula (1):
      ASoC: max98090: Fix missing free_irq

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

Jonas Bonn (1):
      openrisc: Rework signal handling

K. Y. Srinivasan (2):
      Drivers: scsi: storvsc: Implement a eh_timed_out handler
      drivers: scsi: storvsc: Correctly handle TEST_UNIT_READY failure

Kevin Hao (1):
      mtd/ftl: fix the double free of the buffers allocated in build_maps()

Lan Tianyu (1):
      ACPI: Run fixed event device notifications in process context

Linus Torvalds (1):
      vfs: fix bad hashing of dentries

Mark A. Greer (1):
      spi: omap2-mcspi: Configure hardware when slave driver changes mode

Markos Chandras (1):
      MIPS: asm: thread_info: Add _TIF_SECCOMP flag

Mauro Carvalho Chehab (3):
      media: xc5000: Fix get_frequency()
      media: xc4000: Fix get_frequency()
      media: au0828: Only alt setting logic when needed

Michael Welling (1):
      mfd: omap-usb-host: Fix improper mask use.

NeilBrown (4):
      md/raid6: avoid data corruption during recovery of double-degraded RA=
ID6
      md/raid10: fix memory leak when reshaping a RAID10.
      md/raid10: Fix memory leak when raid10 reshape completes.
      md/raid1,raid10: always abort recover on write error.

Nikesh Oswal (1):
      regulator: arizona-ldo1: remove bypass functionality

Paul Burton (1):
      MIPS: Prevent user from setting FCSR cause bits

Pavel Shilovsky (5):
      CIFS: Fix STATUS_CANNOT_DELETE error mapping for SMB2
      CIFS: Fix async reading on reconnects
      CIFS: Fix wrong directory attributes after rename
      CIFS: Fix wrong filename length for SMB2
      CIFS: Fix wrong restart readdir for SMB1

Praveen Diwakar (1):
      ASoC: wm_adsp: Add missing MODULE_LICENSE

Qiao Zhou (1):
      ASoC: pcm: fix dpcm_path_put in dpcm runtime update

Ralf Baechle (2):
      MIPS: Cleanup flags in syscall flags handlers.
      MIPS: Fix accessing to per-cpu data when flushing the cache

Roger Quadros (1):
      mtd: nand: omap: Fix 1-bit Hamming code scheme, omap_calculate_ecc()

Sage Weil (1):
      libceph: gracefully handle large reply messages from the mon

Salva Peir=F3 (1):
      media: media-device: Remove duplicated memset() in media_enum_entitie=
s()

Sasha Levin (1):
      kernel/smp.c:on_each_cpu_cond(): fix warning in fallback path

Steve French (1):
      CIFS: Possible null ptr deref in SMB2_tcon

Steve Wise (1):
      RDMA/iwcm: Use a default listen backlog if needed

Steven Rostedt (Red Hat) (2):
      ring-buffer: Always reset iterator to reader page
      ring-buffer: Up rb_iter_peek() loop count to 3

Sylwester Nawrocki (1):
      ASoC: samsung: Correct I2S DAI suspend/resume ops

Tejun Heo (1):
      blkcg: don't call into policy draining if root_blkg is already gone

Thomas Petazzoni (1):
      spi: orion: fix incorrect handling of cell-index DT property

Vignesh Raman (1):
      Bluetooth: Avoid use of session socket after the session gets freed

Vladimir Davydov (1):
      Bluetooth: never linger on process exit


--envbJBWh7q8WU6mo
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUGfNjAAoJEDjbvchgkmk+USMQAM7Kt4Mfj3m1tblV8sVlJqnP
O67+8imeJOdXgfajuhUeYxEGosGxZ1dKcr3VPs0M+4NClUNsv7orKhY6J0dgtEch
6cFTbBnKxg7A1VgM3Jzm/hwfrHzdjmWQWhHab1/RD0o6fyS/5b5RxlLIpSf6ks3K
UPTx69IEDqH2pHM5XLX+EQDE1erQAEHwBQldu6OLC2kCiQFnl/JC9M7aXIpV4UVa
yu07uh9jvaDGrDY5Xd/4NnySfRJj7TPfW1Y8GlT0CPiOKkwGvNwa+XvwSqNPnW05
1VG/Fu96AfCO0hPucCoIW3+13myqbM/+OdLoWIBmQ/RnfyqzIzLf24UsJrPzE+R4
35cUzoki939ng5htsGem4xtOoALTsFZBQgwLgW3dSQZq4o/oEHxHelcj7ibCnKyU
yEQApxeaPnifhzpgS8mev7qAQTDj6n9OhKbaVVZjaVHQzFobhxBWPOZmM6zadqmP
LIXEgAMnBV4zcYWfkO5Z4KsxpGZnaZuFUVyno4DKZe2WcBAry1zTACre8FagPITy
z+2xGEOD88SFIuRoyQkami8nBRlJBju6UU6naK4Xa+9lI5wZMqyw6yJWwziJR+yR
xLvb2qJRHF4OJr+8v3n9AoaQ/cxRq8kMlFr7BoRbCTJA7EDPCWt+qtDp0VG1ow6n
Aal04OXImmOcxWx+uujV
=aSAv
-----END PGP SIGNATURE-----

--envbJBWh7q8WU6mo--
