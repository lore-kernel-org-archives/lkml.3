Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754758AbaIOT0p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 15:26:45 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54509 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754494AbaIOT0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 15:26:38 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        stable@vger.kernel.org
Subject: [PATCH 3.16 000/158] 3.16.3-stable review
Date: Mon, 15 Sep 2014 12:23:59 -0700
Message-Id: <20140915192542.872134685@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.16.3 release.
There are 158 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed Sep 17 19:25:26 UTC 2014.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.16.3-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.16.3-rc1

David Howells <dhowells@redhat.com>
    KEYS: Fix termination condition in assoc array garbage collection

David Howells <dhowells@redhat.com>
    KEYS: Fix use-after-free in assoc_array_gc()

Pavel Shilovsky <pshilovsky@samba.org>
    CIFS: Fix SMB2 readdir error handling

Linus Torvalds <torvalds@linux-foundation.org>
    vfs: fix bad hashing of dentries

Mario Kleiner <mario.kleiner.de@gmail.com>
    drm/nouveau: Bump version from 1.1.1 to 1.1.2

Mario Kleiner <mario.kleiner.de@gmail.com>
    drm/nouveau: Dis/Enable vblank irqs during suspend/resume.

Bart Van Assche <bvanassche@acm.org>
    IB/srp: Fix deadlock between host removal and multipathd

Jeff Moyer <jmoyer@redhat.com>
    dm table: propagate QUEUE_FLAG_NO_SG_MERGE

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

Sage Weil <sage@redhat.com>
    libceph: gracefully handle large reply messages from the mon

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
    md/raid5: avoid livelock caused by non-aligned writes.

NeilBrown <neilb@suse.de>
    md/raid1,raid10: always abort recover on write error.

Al Viro <viro@zeniv.linux.org.uk>
    fix copy_tree() regression

Ilya Dryomov <ilya.dryomov@inktank.com>
    rbd: rework rbd_request_fn()

Al Viro <viro@zeniv.linux.org.uk>
    __generic_file_write_iter(): fix handling of sync error after DIO

Vignesh Raman <Vignesh_Raman@mentor.com>
    Bluetooth: Avoid use of session socket after the session gets freed

Johan Hedberg <johan.hedberg@intel.com>
    Bluetooth: Fix using uninitialized variable when pairing

Vladimir Davydov <vdavydov@parallels.com>
    Bluetooth: never linger on process exit

Johan Hedberg <johan.hedberg@intel.com>
    Bluetooth: Fix tracking local SSP authentication requirement

Marcel Holtmann <marcel@holtmann.org>
    Bluetooth: Fix merge of advertising data and scan response data

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

Hans de Goede <hdegoede@redhat.com>
    ACPI / video: Disable native_backlight on HP ENVY 15 Notebook PC

Hans de Goede <hdegoede@redhat.com>
    ACPI / video: Add a disable_native_backlight quirk

Hans de Goede <hdegoede@redhat.com>
    ACPI / video: Fix use_native_backlight selection logic

Jiri Kosina <jkosina@suse.cz>
    ACPI / cpuidle: fix deadlock between cpuidle_lock and cpu_hotplug.lock

Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
    ACPI / scan: not cache _SUN value in struct acpi_device_pnp

Lv Zheng <lv.zheng@intel.com>
    ACPI / EC: Add support to disallow QR_EC to be issued before completing previous QR_EC

Lv Zheng <lv.zheng@intel.com>
    ACPI / EC: Add support to disallow QR_EC to be issued when SCI_EVT isn't set

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI / scan: Allow ACPI drivers to bind to PNP device objects

Lan Tianyu <tianyu.lan@intel.com>
    ACPI: Run fixed event device notifications in process context

Alan Cox <alan@linux.intel.com>
    spi/pxa2xx: Add ACPI ID for Intel Braswell

Tang Chen <tangchen@cn.fujitsu.com>
    ACPI / hotplug: Check scan handlers in acpi_scan_hot_remove()

David E. Box <david.e.box@linux.intel.com>
    ACPICA: Namespace: Properly null terminate objects detached from a namespace node

David E. Box <david.e.box@linux.intel.com>
    ACPICA: Utilities: Fix memory leak in acpi_ut_copy_iobject_to_iobject

Sebastian Reichel <sre@kernel.org>
    bq2415x_charger: Fix Atomic Sleep Bug

Ben Hutchings <ben@decadent.org.uk>
    bfa: Fix undefined bit shift on big-endian architectures with 32-bit DMA address

Peter Ujfalusi <peter.ujfalusi@ti.com>
    ASoC: omap-twl4030: Fix typo in 2nd dai link's platform_name

Jarkko Nikula <jarkko.nikula@linux.intel.com>
    ASoC: rt5640: Do not allow regmap to use bulk read-write operations

Andreas Färber <afaerber@suse.de>
    ASoC: axi: Fix ADI AXI SPDIF specification

Daniel Mack <zonque@gmail.com>
    ASoC: pxa-ssp: drop SNDRV_PCM_FMTBIT_S24_LE

Dan Carpenter <dan.carpenter@oracle.com>
    ASoC: pxa: pxa-ssp: small leak in probe()

Jie Yang <yang.jie@intel.com>
    ASoC: Intel: Cleanup HSW pcm format support

Peter Ujfalusi <peter.ujfalusi@ti.com>
    ASoC: tlv320aic31xx: Do not ignore errors in aic31xx_device_init()

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

Markos Chandras <markos.chandras@imgtec.com>
    MIPS: CPS: Initialize EVA before bringing up VPEs from secondary cores

Markos Chandras <markos.chandras@imgtec.com>
    MIPS: Malta: EVA: Rename 'eva_entry' to 'platform_eva_init'

Markos Chandras <markos.chandras@imgtec.com>
    MIPS: EVA: Add new EVA header

Aaro Koskinen <aaro.koskinen@nsn.com>
    MIPS: OCTEON: make get_system_type() thread-safe

Markos Chandras <markos.chandras@imgtec.com>
    MIPS: Malta: Improve system memory detection for '{e, }memsize' >= 2G

Markos Chandras <markos.chandras@imgtec.com>
    MIPS: scall64-o32: Fix indirect syscall detection

Markos Chandras <markos.chandras@imgtec.com>
    MIPS: syscall: Fix AUDIT value for O32 processes on MIPS64

Alex Smith <alex@alex-smith.me.uk>
    MIPS: asm/reg.h: Make 32- and 64-bit definitions available at the same time

Huacai Chen <chenhc@lemote.com>
    MIPS: Remove BUG_ON(!is_fpu_owner()) in do_ade()

Huacai Chen <chenhc@lemote.com>
    MIPS: tlbex: Fix a missing statement for HUGETLB

Paul Burton <paul.burton@imgtec.com>
    MIPS: Prevent user from setting FCSR cause bits

James Hogan <james.hogan@imgtec.com>
    MIPS: smp-mt: Fix link error when PROC_FS=n

Alex Smith <alex@alex-smith.me.uk>
    MIPS: ptrace: Avoid smp_processor_id() when retrieving FPU IR

Alex Smith <alex@alex-smith.me.uk>
    MIPS: ptrace: Change GP regset to use correct core dump register layout

Alex Smith <alex@alex-smith.me.uk>
    MIPS: ptrace: Test correct task's flags in task_user_regset_view()

Alex Smith <alex.smith@imgtec.com>
    MIPS: O32/32-bit: Fix bug which can cause incorrect system call restarts

Jeffrey Deans <jeffrey.deans@imgtec.com>
    MIPS: GIC: Prevent array overrun

Tony Battersby <tonyb@cybernetics.com>
    fix regression in SCSI_IOCTL_SEND_COMMAND

Juergen Gross <jgross@suse.com>
    SCSI: save command pool address of Scsi_Host

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

James Bottomley <JBottomley@Parallels.com>
    scsi: use short driver name for per-driver cmd slab caches

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

Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
    powerpc/cpuidle: Fix parsing of idle state flags from device-tree

Felipe Balbi <balbi@ti.com>
    regulator: tps65218: fix DCDC4 linear voltage range

Nikesh Oswal <nikesh@opensource.wolfsonmicro.com>
    regulator: arizona-ldo1: remove bypass functionality

Tony Lindgren <tony@atomide.com>
    mfd: twl4030-power: Fix PM idle pin configuration to not conflict with regulators

Jeff Mahoney <jeffm@suse.com>
    drivers/mfd/rtsx_usb.c: export device table

Michael Welling <mwelling@emacinc.com>
    mfd: omap-usb-host: Fix improper mask use.

Sasha Levin <sasha.levin@oracle.com>
    kernel/smp.c:on_each_cpu_cond(): fix warning in fallback path

Li Zhong <zhong@linux.vnet.ibm.com>
    mm: fix potential infinite loop in dissolve_free_huge_pages()

Pranith Kumar <bobby.prani@gmail.com>
    sh: fix build error by adding generic ioport_{map/unmap}()

Ben Hutchings <ben@decadent.org.uk>
    ocfs2: do not write error flag to user structure we cannot copy from/to

Jan Kara <jack@suse.cz>
    fanotify: fix double free of pending permission events

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

Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
    powerpc/cpufreq: Add pr_warn() on OPAL firmware failures

Christian Borntraeger <borntraeger@de.ibm.com>
    s390/locking: Reenable optimistic spinning

Mark A. Greer <mgreer@animalcreek.com>
    spi: omap2-mcspi: Configure hardware when slave driver changes mode

Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
    spi: orion: fix incorrect handling of cell-index DT property

Joerg Roedel <jroedel@suse.de>
    iommu/amd: Fix cleanup_domain for mass device removal

Joerg Roedel <jroedel@suse.de>
    iommu/vt-d: Defer domain removal if device is assigned to a driver

Gavin Shan <gwshan@linux.vnet.ibm.com>
    powerpc/powernv: Fix IOMMU group lost

Alex Williamson <alex.williamson@redhat.com>
    iommu/vt-d: Exclude devices using RMRRs from IOMMU API domains

Paul Bolle <pebolle@tiscali.nl>
    media: sms: Remove CONFIG_ prefix from Kconfig symbols

Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
    media: v4l: vb2: Fix stream start and buffer completion race

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

Jan Kara <jack@suse.cz>
    reiserfs: Fix use after free in journal teardown

Jeff Mahoney <jeffm@suse.com>
    reiserfs: fix corruption introduced by balance_leaf refactor


-------------

Diffstat:

 .../devicetree/bindings/sound/adi,axi-spdif-tx.txt |   2 +-
 Makefile                                           |   4 +-
 arch/arm/boot/dts/omap3-n900.dts                   |   2 +-
 arch/mips/cavium-octeon/setup.c                    |  18 +-
 arch/mips/include/asm/eva.h                        |  43 ++++
 .../include/asm/mach-malta/kernel-entry-init.h     |  22 +-
 arch/mips/include/asm/ptrace.h                     |   2 +-
 arch/mips/include/asm/reg.h                        | 260 +++++++++++++--------
 arch/mips/include/asm/syscall.h                    |   8 +-
 arch/mips/kernel/binfmt_elfo32.c                   |  32 ++-
 arch/mips/kernel/cps-vec.S                         |   4 +
 arch/mips/kernel/irq-gic.c                         |   6 +-
 arch/mips/kernel/ptrace.c                          | 196 +++++++++++++---
 arch/mips/kernel/ptrace32.c                        |   2 +-
 arch/mips/kernel/scall64-o32.S                     |  12 +-
 arch/mips/kernel/smp-mt.c                          |   2 +
 arch/mips/kernel/unaligned.c                       |   1 -
 arch/mips/mm/tlbex.c                               |   1 +
 arch/mips/mti-malta/malta-memory.c                 |  14 +-
 arch/powerpc/include/asm/machdep.h                 |   6 +-
 arch/powerpc/include/asm/pgtable-ppc64.h           |   2 +-
 arch/powerpc/include/asm/pte-hash64-64k.h          |  30 ++-
 arch/powerpc/kernel/iommu.c                        |  38 +--
 arch/powerpc/mm/hash_native_64.c                   |  40 +---
 arch/powerpc/mm/hugepage-hash64.c                  |  88 ++++++-
 arch/powerpc/mm/numa.c                             |   2 +-
 arch/powerpc/mm/pgtable_64.c                       |  38 +--
 arch/powerpc/mm/tlb_hash64.c                       |   2 +-
 arch/powerpc/platforms/powernv/pci-ioda.c          |   2 +-
 arch/powerpc/platforms/pseries/hotplug-memory.c    |   2 +-
 arch/powerpc/platforms/pseries/iommu.c             |  20 +-
 arch/powerpc/platforms/pseries/lpar.c              |  20 +-
 arch/s390/Kconfig                                  |   1 +
 arch/sh/include/asm/io_noioport.h                  |  11 +
 block/blk-cgroup.c                                 |   7 +
 block/scsi_ioctl.c                                 |   9 +-
 drivers/acpi/acpica/nsobject.c                     |  11 +
 drivers/acpi/acpica/utcopy.c                       |   6 +
 drivers/acpi/ec.c                                  |  21 +-
 drivers/acpi/processor_idle.c                      |   4 +-
 drivers/acpi/scan.c                                |  35 +--
 drivers/acpi/video.c                               |  45 +++-
 drivers/block/rbd.c                                | 196 ++++++++++------
 drivers/bluetooth/btmrvl_drv.h                     |   1 +
 drivers/bluetooth/btmrvl_main.c                    |  25 +-
 drivers/char/tpm/tpm-interface.c                   |  73 ++++--
 drivers/char/tpm/tpm_tis.c                         |  31 +++
 drivers/cpufreq/powernv-cpufreq.c                  |  18 +-
 drivers/cpuidle/cpuidle-powernv.c                  |  16 +-
 drivers/firmware/efi/vars.c                        |   8 +-
 drivers/gpu/drm/nouveau/nouveau_display.c          |  11 +
 drivers/gpu/drm/nouveau/nouveau_drm.h              |   4 +-
 drivers/gpu/drm/radeon/cik.c                       |  13 +-
 drivers/infiniband/core/iwcm.c                     |  27 +++
 drivers/infiniband/ulp/srp/ib_srp.c                |  38 ++-
 drivers/iommu/amd_iommu.c                          |  10 +-
 drivers/iommu/intel-iommu.c                        |  57 ++++-
 drivers/md/dm-table.c                              |  13 ++
 drivers/md/raid1.c                                 |   8 +-
 drivers/md/raid10.c                                |  14 +-
 drivers/md/raid5.c                                 |   4 +-
 drivers/media/common/siano/Kconfig                 |   3 +-
 drivers/media/i2c/mt9v032.c                        |   4 +-
 drivers/media/media-device.c                       |   2 -
 drivers/media/platform/vsp1/vsp1_video.c           |   2 -
 drivers/media/platform/vsp1/vsp1_video.h           |   1 -
 drivers/media/tuners/xc4000.c                      |  20 +-
 drivers/media/tuners/xc5000.c                      |  22 +-
 drivers/media/usb/au0828/au0828-video.c            |  34 +--
 drivers/media/v4l2-core/videobuf2-core.c           |   4 +-
 drivers/mfd/omap-usb-host.c                        |   2 +-
 drivers/mfd/rtsx_usb.c                             |   1 +
 drivers/mfd/twl4030-power.c                        |  20 +-
 drivers/mtd/ftl.c                                  |   1 -
 drivers/mtd/nand/omap2.c                           |   2 +-
 drivers/power/bq2415x_charger.c                    |   8 +-
 drivers/regulator/arizona-ldo1.c                   |   2 -
 drivers/regulator/tps65218-regulator.c             |   2 +-
 drivers/scsi/bfa/bfa_ioc.h                         |   2 +-
 drivers/scsi/scsi.c                                |  16 +-
 drivers/scsi/scsi_devinfo.c                        |   1 +
 drivers/scsi/scsi_scan.c                           |  16 +-
 drivers/scsi/scsi_transport_srp.c                  |   3 +-
 drivers/scsi/sd.c                                  |   5 +
 drivers/scsi/storvsc_drv.c                         | 113 ++++++---
 drivers/spi/spi-omap2-mcspi.c                      |  14 ++
 drivers/spi/spi-orion.c                            |  10 +-
 drivers/spi/spi-pxa2xx.c                           |   1 +
 drivers/xen/events/events_fifo.c                   |  48 ++--
 fs/cifs/cifsglob.h                                 |   7 +-
 fs/cifs/file.c                                     |   6 +-
 fs/cifs/inode.c                                    |  11 +-
 fs/cifs/readdir.c                                  |   6 +-
 fs/cifs/smb1ops.c                                  |   7 +
 fs/cifs/smb2file.c                                 |   2 +-
 fs/cifs/smb2inode.c                                |   2 +-
 fs/cifs/smb2maperror.c                             |   4 +-
 fs/cifs/smb2ops.c                                  |  11 +-
 fs/cifs/smb2pdu.c                                  |  14 +-
 fs/dcache.c                                        |   3 +-
 fs/namei.c                                         |   4 +-
 fs/namespace.c                                     | 100 ++++++--
 fs/notify/fanotify/fanotify.c                      |   9 +-
 fs/notify/fanotify/fanotify_user.c                 |  12 +
 fs/notify/notification.c                           |  18 +-
 fs/ocfs2/ioctl.c                                   | 129 ++++------
 fs/pnode.c                                         |   1 +
 fs/proc/array.c                                    |  11 +-
 fs/reiserfs/do_balan.c                             | 111 +++++----
 fs/reiserfs/journal.c                              |  22 +-
 fs/reiserfs/lbalance.c                             |   5 +-
 fs/reiserfs/reiserfs.h                             |   9 +-
 fs/reiserfs/super.c                                |   6 +-
 fs/xfs/xfs_aops.c                                  |  61 +++++
 fs/xfs/xfs_dquot.c                                 |   3 +-
 fs/xfs/xfs_file.c                                  |  21 +-
 fs/xfs/xfs_log_recover.c                           |  51 ++--
 fs/xfs/xfs_qm.c                                    |   8 +-
 include/acpi/acpi_bus.h                            |   1 -
 include/linux/capability.h                         |   5 +-
 include/linux/fsnotify_backend.h                   |   2 +
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
 mm/filemap.c                                       |   2 +-
 mm/hugetlb.c                                       |   3 +
 net/bluetooth/hci_event.c                          |  23 +-
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
 sound/soc/codecs/tlv320aic31xx.c                   |   9 +-
 sound/soc/codecs/wm8994.c                          |   9 +-
 sound/soc/codecs/wm_adsp.c                         |   2 +
 sound/soc/intel/sst-baytrail-pcm.c                 |   2 +-
 sound/soc/intel/sst-haswell-pcm.c                  |  27 ++-
 sound/soc/omap/omap-twl4030.c                      |   2 +-
 sound/soc/pxa/pxa-ssp.c                            |   7 +-
 sound/soc/samsung/i2s.c                            |  16 +-
 sound/soc/soc-pcm.c                                |   1 +
 tools/testing/selftests/Makefile                   |   1 +
 tools/testing/selftests/mount/Makefile             |  17 ++
 .../selftests/mount/unprivileged-remount-test.c    | 242 +++++++++++++++++++
 158 files changed, 2370 insertions(+), 1021 deletions(-)


