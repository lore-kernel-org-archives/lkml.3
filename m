Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755722AbaIOThI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 15:37:08 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55101 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755666AbaIOThC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 15:37:02 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        stable@vger.kernel.org
Subject: [PATCH 3.14 000/114] 3.14.19-stable review
Date: Mon, 15 Sep 2014 12:25:00 -0700
Message-Id: <20140915192641.428509513@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.14.19 release.
There are 114 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed Sep 17 19:26:26 UTC 2014.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.14.19-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.14.19-rc1

David Howells <dhowells@redhat.com>
    KEYS: Fix termination condition in assoc array garbage collection

David Howells <dhowells@redhat.com>
    KEYS: Fix use-after-free in assoc_array_gc()

Sage Weil <sage@redhat.com>
    libceph: gracefully handle large reply messages from the mon

Linus Torvalds <torvalds@linux-foundation.org>
    vfs: fix bad hashing of dentries

Mario Kleiner <mario.kleiner.de@gmail.com>
    drm/nouveau: Bump version from 1.1.1 to 1.1.2

Bart Van Assche <bvanassche@acm.org>
    IB/srp: Fix deadlock between host removal and multipathd

Tejun Heo <tj@kernel.org>
    blkcg: don't call into policy draining if root_blkg is already gone

Roger Quadros <rogerq@ti.com>
    mtd: nand: omap: Fix 1-bit Hamming code scheme, omap_calculate_ecc()

Kevin Hao <haokexin@gmail.com>
    mtd/ftl: fix the double free of the buffers allocated in build_maps()

Pavel Shilovsky <pshilovsky@samba.org>
    CIFS: Fix wrong restart readdir for SMB1

Pavel Shilovsky <pshilovsky@samba.org>
    CIFS: Fix wrong filename length for SMB2

Pavel Shilovsky <pshilovsky@samba.org>
    CIFS: Fix directory rename error

Miklos Szeredi <mszeredi@suse.cz>
    vfs: add d_is_dir()

Pavel Shilovsky <pshilovsky@samba.org>
    CIFS: Fix wrong directory attributes after rename

Steve French <smfrench@gmail.com>
    CIFS: Possible null ptr deref in SMB2_tcon

Pavel Shilovsky <pshilovsky@samba.org>
    CIFS: Fix async reading on reconnects

Pavel Shilovsky <pshilovsky@samba.org>
    CIFS: Fix STATUS_CANNOT_DELETE error mapping for SMB2

Ilya Dryomov <ilya.dryomov@inktank.com>
    libceph: do not hard code max auth ticket len

Ilya Dryomov <ilya.dryomov@inktank.com>
    libceph: add process_one_ticket() helper

Ilya Dryomov <ilya.dryomov@inktank.com>
    libceph: set last_piece in ceph_msg_data_pages_cursor_init() correctly

Chris Mason <clm@fb.com>
    xfs: don't zero partial page cache pages during O_DIRECT write

Dave Chinner <dchinner@redhat.com>
    xfs: don't zero partial page cache pages during O_DIRECT writes

Dave Chinner <dchinner@redhat.com>
    xfs: don't dirty buffers beyond EOF

Dave Chinner <dchinner@redhat.com>
    xfs: quotacheck leaves dquot buffers without verifiers

Dave Chinner <dchinner@redhat.com>
    xfs: ensure verifiers are attached to recovered buffers

Doug Ledford <dledford@redhat.com>
    RDMA/uapi: Include socket.h in rdma_user_cm.h

Steve Wise <swise@opengridcomputing.com>
    RDMA/iwcm: Use a default listen backlog if needed

NeilBrown <neilb@suse.de>
    md/raid10: Fix memory leak when raid10 reshape completes.

NeilBrown <neilb@suse.de>
    md/raid10: fix memory leak when reshaping a RAID10.

NeilBrown <neilb@suse.de>
    md/raid6: avoid data corruption during recovery of double-degraded RAID6

NeilBrown <neilb@suse.de>
    md/raid1,raid10: always abort recover on write error.

Al Viro <viro@zeniv.linux.org.uk>
    fix copy_tree() regression

Vignesh Raman <Vignesh_Raman@mentor.com>
    Bluetooth: Avoid use of session socket after the session gets freed

Vladimir Davydov <vdavydov@parallels.com>
    Bluetooth: never linger on process exit

Chin-Ran Lo <crlo@marvell.com>
    Bluetooth: btmrvl: wait for HOST_SLEEP_ENABLE event in suspend

Al Viro <viro@zeniv.linux.org.uk>
    fix EBUSY on umount() from MNT_SHRINKABLE

Al Viro <viro@zeniv.linux.org.uk>
    get rid of propagate_umount() mistakenly treating slaves as busy.

Eric W. Biederman <ebiederm@xmission.com>
    mnt: Add tests for unprivileged remount cases that have found to be faulty

Eric W. Biederman <ebiederm@xmission.com>
    mnt: Change the default remount atime from relatime to the existing value

Eric W. Biederman <ebiederm@xmission.com>
    mnt: Correct permission checks in do_remount

Eric W. Biederman <ebiederm@xmission.com>
    mnt: Move the test for MNT_LOCK_READONLY from change_mount_flags into do_remount

Eric W. Biederman <ebiederm@xmission.com>
    mnt: Only change user settable mount flags in remount

Steven Rostedt (Red Hat) <rostedt@goodmis.org>
    ring-buffer: Up rb_iter_peek() loop count to 3

Steven Rostedt (Red Hat) <rostedt@goodmis.org>
    ring-buffer: Always reset iterator to reader page

David Vrabel <david.vrabel@citrix.com>
    xen/events/fifo: reset control block and local HEADs on resume

Jiri Kosina <jkosina@suse.cz>
    ACPI / cpuidle: fix deadlock between cpuidle_lock and cpu_hotplug.lock

Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
    ACPI / scan: not cache _SUN value in struct acpi_device_pnp

Lan Tianyu <tianyu.lan@intel.com>
    ACPI: Run fixed event device notifications in process context

Alan Cox <alan@linux.intel.com>
    spi/pxa2xx: Add ACPI ID for Intel Braswell

Tang Chen <tangchen@cn.fujitsu.com>
    ACPI / hotplug: Check scan handlers in acpi_scan_hot_remove()

David E. Box <david.e.box@linux.intel.com>
    ACPICA: Utilities: Fix memory leak in acpi_ut_copy_iobject_to_iobject

Sebastian Reichel <sre@kernel.org>
    bq2415x_charger: Fix Atomic Sleep Bug

Ben Hutchings <ben@decadent.org.uk>
    bfa: Fix undefined bit shift on big-endian architectures with 32-bit DMA address

Jarkko Nikula <jarkko.nikula@linux.intel.com>
    ASoC: rt5640: Do not allow regmap to use bulk read-write operations

Andreas Färber <afaerber@suse.de>
    ASoC: axi: Fix ADI AXI SPDIF specification

Daniel Mack <zonque@gmail.com>
    ASoC: pxa-ssp: drop SNDRV_PCM_FMTBIT_S24_LE

Dan Carpenter <dan.carpenter@oracle.com>
    ASoC: pxa: pxa-ssp: small leak in probe()

Jarkko Nikula <jarkko.nikula@linux.intel.com>
    ASoC: max98090: Fix missing free_irq

Daniel Mack <zonque@gmail.com>
    ASoC: adau1701: fix adau1701_reg_read()

Sylwester Nawrocki <s.nawrocki@samsung.com>
    ASoC: samsung: Correct I2S DAI suspend/resume ops

Scott Jiang <scott.jiang.linux@gmail.com>
    ASoC: blackfin: use samples to set silence

Praveen Diwakar <praveen.diwakar@intel.com>
    ASoC: wm_adsp: Add missing MODULE_LICENSE

Qiao Zhou <zhouqiao@marvell.com>
    ASoC: pcm: fix dpcm_path_put in dpcm runtime update

Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
    ASoC: wm8994: Prevent double lock of accdet_lock mutex on wm1811

Aaro Koskinen <aaro.koskinen@nsn.com>
    MIPS: OCTEON: make get_system_type() thread-safe

Alex Smith <alex@alex-smith.me.uk>
    MIPS: asm/reg.h: Make 32- and 64-bit definitions available at the same time

Huacai Chen <chenhc@lemote.com>
    MIPS: Remove BUG_ON(!is_fpu_owner()) in do_ade()

Huacai Chen <chenhc@lemote.com>
    MIPS: tlbex: Fix a missing statement for HUGETLB

Paul Burton <paul.burton@imgtec.com>
    MIPS: Prevent user from setting FCSR cause bits

Alex Smith <alex@alex-smith.me.uk>
    MIPS: ptrace: Change GP regset to use correct core dump register layout

Alex Smith <alex@alex-smith.me.uk>
    MIPS: ptrace: Test correct task's flags in task_user_regset_view()

Alex Smith <alex.smith@imgtec.com>
    MIPS: O32/32-bit: Fix bug which can cause incorrect system call restarts

Jeffrey Deans <jeffrey.deans@imgtec.com>
    MIPS: GIC: Prevent array overrun

Bart Van Assche <bvanassche@acm.org>
    scsi_transport_srp: Fix fast_io_fail_tmo=dev_loss_tmo=off behavior

Janusz Dziemidowicz <rraptorr@nails.eu.org>
    scsi: do not issue SCSI RSOC command to Promise Vtrak E610f

Martin K. Petersen <martin.petersen@oracle.com>
    scsi: add a blacklist flag which enables VPD page inquiries

Hannes Reinecke <hare@suse.de>
    scsi_scan: Restrict sequential scan to 256 LUNs

K. Y. Srinivasan <kys@microsoft.com>
    drivers: scsi: storvsc: Correctly handle TEST_UNIT_READY failure

K. Y. Srinivasan <kys@microsoft.com>
    drivers: scsi: storvsc: Set srb_flags in all cases

K. Y. Srinivasan <kys@microsoft.com>
    Drivers: scsi: storvsc: Fix a bug in handling VMBUS protocol version

K. Y. Srinivasan <kys@microsoft.com>
    Drivers: scsi: storvsc: Set cmd_per_lun to reflect value supported by the Host

K. Y. Srinivasan <kys@microsoft.com>
    Drivers: scsi: storvsc: Change the limits to reflect the values on the host

K. Y. Srinivasan <kys@microsoft.com>
    Drivers: scsi: storvsc: Filter commands based on the storage protocol version

K. Y. Srinivasan <kys@microsoft.com>
    Drivers: scsi: storvsc: Implement a eh_timed_out handler

Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
    powerpc/thp: Use ACCESS_ONCE when loading pmdp

Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
    powerpc/thp: Invalidate with vpn in loop

Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
    powerpc/thp: Handle combo pages in invalidate

Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
    powerpc/thp: Invalidate old 64K based hash page mapping before insert of 4k pte

Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
    powerpc/thp: Don't recompute vsid and ssize in loop on invalidate

Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
    powerpc/thp: Add write barrier after updating the valid bit

Gavin Shan <gwshan@linux.vnet.ibm.com>
    powerpc/pseries: Avoid deadlock on removing ddw

Gavin Shan <gwshan@linux.vnet.ibm.com>
    powerpc/pseries: Failure on removing device node

Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
    powerpc/mm: Use read barrier when creating real_pte

Andrey Utkin <andrey.krieger.utkin@gmail.com>
    powerpc/mm/numa: Fix break placement

Nikesh Oswal <nikesh@opensource.wolfsonmicro.com>
    regulator: arizona-ldo1: remove bypass functionality

Michael Welling <mwelling@emacinc.com>
    mfd: omap-usb-host: Fix improper mask use.

Sasha Levin <sasha.levin@oracle.com>
    kernel/smp.c:on_each_cpu_cond(): fix warning in fallback path

Eric Paris <eparis@redhat.com>
    CAPABILITIES: remove undefined caps from all processes

Stefan Berger <stefanb@linux.vnet.ibm.com>
    tpm: Properly clean sysfs entries in error path

Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
    tpm: Provide a generic means to override the chip returned timeouts

Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
    tpm: missing tpm_chip_put in tpm_get_random()

Guenter Roeck <linux@roeck-us.net>
    firmware: Do not use WARN_ON(!spin_is_locked())

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: use packet2 for nop on hawaii with old firmware

Christian Borntraeger <borntraeger@de.ibm.com>
    s390/locking: Reenable optimistic spinning

Mark A. Greer <mgreer@animalcreek.com>
    spi: omap2-mcspi: Configure hardware when slave driver changes mode

Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
    spi: orion: fix incorrect handling of cell-index DT property

Joerg Roedel <jroedel@suse.de>
    iommu/amd: Fix cleanup_domain for mass device removal

Paul Bolle <pebolle@tiscali.nl>
    media: sms: Remove CONFIG_ prefix from Kconfig symbols

Laurent Pinchart <laurent.pinchart@ideasonboard.com>
    media: v4l: vsp1: Remove the unneeded vsp1_video_buffer video field

Philipp Zabel <p.zabel@pengutronix.de>
    media: mt9v032: fix hblank calculation

Salva Peiró <speiro@ai2.upv.es>
    media: media-device: Remove duplicated memset() in media_enum_entities()

Mauro Carvalho Chehab <m.chehab@samsung.com>
    media: au0828: Only alt setting logic when needed

Mauro Carvalho Chehab <m.chehab@samsung.com>
    media: xc4000: Fix get_frequency()

Mauro Carvalho Chehab <m.chehab@samsung.com>
    media: xc5000: Fix get_frequency()


-------------

Diffstat:

 .../devicetree/bindings/sound/adi,axi-spdif-tx.txt |   2 +-
 Makefile                                           |   4 +-
 arch/mips/cavium-octeon/setup.c                    |  18 +-
 arch/mips/include/asm/ptrace.h                     |   2 +-
 arch/mips/include/asm/reg.h                        | 260 +++++++++++++--------
 arch/mips/kernel/binfmt_elfo32.c                   |  32 ++-
 arch/mips/kernel/irq-gic.c                         |   6 +-
 arch/mips/kernel/ptrace.c                          | 192 ++++++++++++---
 arch/mips/kernel/unaligned.c                       |   1 -
 arch/mips/mm/tlbex.c                               |   1 +
 arch/powerpc/include/asm/machdep.h                 |   6 +-
 arch/powerpc/include/asm/pgtable-ppc64.h           |   2 +-
 arch/powerpc/include/asm/pte-hash64-64k.h          |  30 ++-
 arch/powerpc/mm/hash_native_64.c                   |  40 +---
 arch/powerpc/mm/hugepage-hash64.c                  |  88 ++++++-
 arch/powerpc/mm/numa.c                             |   2 +-
 arch/powerpc/mm/pgtable_64.c                       |  38 +--
 arch/powerpc/mm/tlb_hash64.c                       |   2 +-
 arch/powerpc/platforms/pseries/hotplug-memory.c    |   2 +-
 arch/powerpc/platforms/pseries/iommu.c             |  20 +-
 arch/powerpc/platforms/pseries/lpar.c              |  20 +-
 arch/s390/Kconfig                                  |   1 +
 block/blk-cgroup.c                                 |   7 +
 drivers/acpi/acpica/utcopy.c                       |   6 +
 drivers/acpi/processor_idle.c                      |   4 +-
 drivers/acpi/scan.c                                |  33 +--
 drivers/bluetooth/btmrvl_drv.h                     |   1 +
 drivers/bluetooth/btmrvl_main.c                    |  25 +-
 drivers/char/tpm/tpm-interface.c                   |  73 ++++--
 drivers/char/tpm/tpm_tis.c                         |  31 +++
 drivers/firmware/efi/vars.c                        |   8 +-
 drivers/gpu/drm/nouveau/nouveau_drm.h              |   4 +-
 drivers/gpu/drm/radeon/cik.c                       |  13 +-
 drivers/infiniband/core/iwcm.c                     |  27 +++
 drivers/infiniband/ulp/srp/ib_srp.c                |  38 ++-
 drivers/iommu/amd_iommu.c                          |  10 +-
 drivers/md/raid1.c                                 |   8 +-
 drivers/md/raid10.c                                |  14 +-
 drivers/md/raid5.c                                 |   2 +
 drivers/media/common/siano/Kconfig                 |   3 +-
 drivers/media/i2c/mt9v032.c                        |   4 +-
 drivers/media/media-device.c                       |   2 -
 drivers/media/platform/vsp1/vsp1_video.c           |   2 -
 drivers/media/platform/vsp1/vsp1_video.h           |   1 -
 drivers/media/tuners/xc4000.c                      |  20 +-
 drivers/media/tuners/xc5000.c                      |  22 +-
 drivers/media/usb/au0828/au0828-video.c            |  34 +--
 drivers/mfd/omap-usb-host.c                        |   2 +-
 drivers/mtd/ftl.c                                  |   1 -
 drivers/mtd/nand/omap2.c                           |   2 +-
 drivers/power/bq2415x_charger.c                    |   8 +-
 drivers/regulator/arizona-ldo1.c                   |   2 -
 drivers/scsi/bfa/bfa_ioc.h                         |   2 +-
 drivers/scsi/scsi_devinfo.c                        |   1 +
 drivers/scsi/scsi_scan.c                           |  16 +-
 drivers/scsi/scsi_transport_srp.c                  |   3 +-
 drivers/scsi/sd.c                                  |   5 +
 drivers/scsi/storvsc_drv.c                         | 113 ++++++---
 drivers/spi/spi-omap2-mcspi.c                      |  14 ++
 drivers/spi/spi-orion.c                            |  10 +-
 drivers/spi/spi-pxa2xx.c                           |   1 +
 drivers/xen/events/events_fifo.c                   |  48 ++--
 fs/cifs/cifsglob.h                                 |   5 -
 fs/cifs/file.c                                     |   4 +-
 fs/cifs/inode.c                                    |  11 +-
 fs/cifs/readdir.c                                  |   4 +-
 fs/cifs/smb2file.c                                 |   2 +-
 fs/cifs/smb2inode.c                                |   2 +-
 fs/cifs/smb2maperror.c                             |   2 +-
 fs/cifs/smb2ops.c                                  |   2 +-
 fs/cifs/smb2pdu.c                                  |   5 +-
 fs/dcache.c                                        |   3 +-
 fs/namei.c                                         |  27 ++-
 fs/namespace.c                                     | 100 ++++++--
 fs/pnode.c                                         |   1 +
 fs/proc/array.c                                    |  11 +-
 fs/xfs/xfs_aops.c                                  |  61 +++++
 fs/xfs/xfs_dquot.c                                 |   3 +-
 fs/xfs/xfs_file.c                                  |  21 +-
 fs/xfs/xfs_log_recover.c                           |  51 ++--
 fs/xfs/xfs_qm.c                                    |   8 +-
 include/acpi/acpi_bus.h                            |   1 -
 include/linux/capability.h                         |   5 +-
 include/linux/dcache.h                             |   7 +-
 include/linux/mount.h                              |   9 +-
 include/linux/tpm.h                                |   3 +
 include/scsi/scsi_device.h                         |   1 +
 include/scsi/scsi_devinfo.h                        |   5 +
 include/uapi/rdma/rdma_user_cm.h                   |   1 +
 kernel/audit.c                                     |   2 +-
 kernel/capability.c                                |   4 +
 kernel/smp.c                                       |   2 +-
 kernel/trace/ring_buffer.c                         |  31 ++-
 lib/assoc_array.c                                  |   6 +-
 net/bluetooth/l2cap_sock.c                         |   3 +-
 net/bluetooth/rfcomm/core.c                        |   7 +-
 net/bluetooth/rfcomm/sock.c                        |   3 +-
 net/bluetooth/sco.c                                |   6 +-
 net/ceph/auth_x.c                                  | 256 ++++++++++----------
 net/ceph/messenger.c                               |   2 +-
 net/ceph/mon_client.c                              |   8 +
 security/commoncap.c                               |   3 +
 sound/soc/blackfin/bf5xx-i2s-pcm.c                 |   8 +-
 sound/soc/codecs/adau1701.c                        |   6 +-
 sound/soc/codecs/max98090.c                        |   2 +-
 sound/soc/codecs/rt5640.c                          |   1 +
 sound/soc/codecs/wm8994.c                          |   9 +-
 sound/soc/codecs/wm_adsp.c                         |   2 +
 sound/soc/pxa/pxa-ssp.c                            |   7 +-
 sound/soc/samsung/i2s.c                            |  16 +-
 sound/soc/soc-pcm.c                                |   1 +
 tools/testing/selftests/Makefile                   |   1 +
 tools/testing/selftests/mount/Makefile             |  17 ++
 .../selftests/mount/unprivileged-remount-test.c    | 242 +++++++++++++++++++
 114 files changed, 1700 insertions(+), 689 deletions(-)


