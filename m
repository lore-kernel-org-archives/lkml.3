Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754669AbaIZJpj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 05:45:39 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60957 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754637AbaIZJpg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 05:45:36 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux@roeck-us.net, satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        linux-kernel@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 000/142] 3.12.29-stable review
Date: Fri, 26 Sep 2014 11:45:33 +0200
Message-Id: <cover.1411724723.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.12.29 release.
There are 142 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Tue Sep 30 11:45:24 CEST 2014.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	http://kernel.org/pub/linux/kernel/people/jirislaby/stable-review/patch-3.12.29-rc1.xz
and the diffstat can be found below.

thanks,
js

===============


Aaro Koskinen (1):
  MIPS: OCTEON: make get_system_type() thread-safe

Al Viro (1):
  dcache.c: get rid of pointless macros

Alan Cox (1):
  spi/pxa2xx: Add ACPI ID for Intel Braswell

Alex Deucher (3):
  drm/radeon: load the lm63 driver for an lm64 thermal chip.
  drm/radeon: enable bapm by default on desktop TN/RL boards
  drm/radeon/TN: only enable bapm on MSI systems

Alexander Usyskin (1):
  mei: nfc: fix memory leak in error path

Andrey Utkin (1):
  powerpc/mm/numa: Fix break placement

Aneesh Kumar K.V (7):
  powerpc/mm: Use read barrier when creating real_pte
  powerpc/thp: Add write barrier after updating the valid bit
  powerpc/thp: Don't recompute vsid and ssize in loop on invalidate
  powerpc/thp: Invalidate old 64K based hash page mapping before insert
    of 4k pte
  powerpc/thp: Handle combo pages in invalidate
  powerpc/thp: Invalidate with vpn in loop
  powerpc/thp: Use ACCESS_ONCE when loading pmdp

Anton Blanchard (1):
  ibmveth: Fix endian issues with rx_no_buffer statistic

Arjun Sreedharan (1):
  pata_scc: propagate return value of scc_wait_after_reset

Bart Van Assche (1):
  IB/srp: Fix deadlock between host removal and multipathd

Ben Hutchings (1):
  bfa: Fix undefined bit shift on big-endian architectures with 32-bit
    DMA address

Charles Keepax (1):
  ASoC: wm8994: Prevent double lock of accdet_lock mutex on wm1811

Chris Mason (1):
  xfs: don't zero partial page cache pages during O_DIRECT writes

Christian Borntraeger (1):
  s390/locking: Reenable optimistic spinning

Christian König (1):
  drm/radeon: set VM base addr using the PFP v2

Chuck Lever (1):
  svcrdma: Select NFSv4.1 backchannel transport based on forward channel

Dan Carpenter (1):
  ASoC: pxa: pxa-ssp: small leak in probe()

Daniel Mack (2):
  ASoC: adau1701: fix adau1701_reg_read()
  ASoC: pxa-ssp: drop SNDRV_PCM_FMTBIT_S24_LE

Darrick J. Wong (2):
  jbd2: fix infinite loop when recovering corrupt journal blocks
  jbd2: fix descriptor block size handling errors with journal_csum

Dave Chinner (4):
  xfs: ensure verifiers are attached to recovered buffers
  xfs: quotacheck leaves dquot buffers without verifiers
  xfs: don't dirty buffers beyond EOF
  xfs: don't zero partial page cache pages during O_DIRECT writes

David E. Box (1):
  ACPICA: Utilities: Fix memory leak in acpi_ut_copy_iobject_to_iobject

Dmitry Monakhov (1):
  ext4: update i_disksize coherently with block allocation on error path

Doug Ledford (1):
  RDMA/uapi: Include socket.h in rdma_user_cm.h

Eric Paris (1):
  CAPABILITIES: remove undefined caps from all processes

Eric W. Biederman (2):
  mnt: Change the default remount atime from relatime to the existing
    value
  mnt: Add tests for unprivileged remount cases that have found to be
    faulty

Filipe Manana (2):
  Btrfs: fix csum tree corruption, duplicate and outdated checksums
  Btrfs: read lock extent buffer while walking backrefs

Gavin Shan (2):
  powerpc/pseries: Failure on removing device node
  powerpc/pseries: Avoid deadlock on removing ddw

Greg Kroah-Hartman (1):
  USB: fix build error with CONFIG_PM_RUNTIME disabled

Guenter Roeck (1):
  firmware: Do not use WARN_ON(!spin_is_locked())

Guido Martínez (6):
  drm/tilcdc: panel: fix dangling sysfs connector node
  drm/tilcdc: slave: fix dangling sysfs connector node
  drm/tilcdc: tfp410: fix dangling sysfs connector node
  drm/tilcdc: panel: fix leak when unloading the module
  drm/tilcdc: fix release order on exit
  drm/tilcdc: fix double kfree

Hannes Reinecke (1):
  scsi_scan: Restrict sequential scan to 256 LUNs

Hans de Goede (1):
  xhci: Treat not finding the event_seg on COMP_STOP the same as
    COMP_STOP_INVAL

Holger Paradies (1):
  staging/rtl8188eu: add 0df6:0076 Sitecom Europe B.V.

Huacai Chen (2):
  MIPS: tlbex: Fix a missing statement for HUGETLB
  MIPS: Remove BUG_ON(!is_fpu_owner()) in do_ade()

Huang Rui (1):
  usb: xhci: amd chipset also needs short TX quirk

Ilya Dryomov (3):
  libceph: set last_piece in ceph_msg_data_pages_cursor_init() correctly
  libceph: add process_one_ticket() helper
  libceph: do not hard code max auth ticket len

James Forshaw (1):
  USB: whiteheat: Added bounds checking for bulk command response

James Ralston (1):
  ahci: Add Device IDs for Intel 9 Series PCH

Janusz Dziemidowicz (1):
  scsi: do not issue SCSI RSOC command to Promise Vtrak E610f

Jarkko Nikula (2):
  ASoC: max98090: Fix missing free_irq
  ASoC: rt5640: Do not allow regmap to use bulk read-write operations

Jarkko Sakkinen (1):
  tpm: missing tpm_chip_put in tpm_get_random()

Jason Gunthorpe (1):
  tpm: Provide a generic means to override the chip returned timeouts

Jaša Bartelj (1):
  USB: ftdi_sio: Added PID for new ekey device

Jeff Moyer (1):
  aio: add missing smp_rmb() in read_events_ring

Jeffrey Deans (1):
  MIPS: GIC: Prevent array overrun

Jiri Kosina (2):
  ACPI / cpuidle: fix deadlock between cpuidle_lock and cpu_hotplug.lock
  drm/i915: read HEAD register back in init_ring_common() to enforce
    ordering

Joerg Roedel (1):
  iommu/amd: Fix cleanup_domain for mass device removal

Johan Hovold (1):
  USB: ftdi_sio: add Basic Micro ATOM Nano USB2Serial PID

Jonas Bonn (1):
  openrisc: Rework signal handling

K. Y. Srinivasan (7):
  Drivers: scsi: storvsc: Implement a eh_timed_out handler
  Drivers: scsi: storvsc: Filter commands based on the storage protocol
    version
  Drivers: scsi: storvsc: Change the limits to reflect the values on the
    host
  Drivers: scsi: storvsc: Set cmd_per_lun to reflect value supported by
    the Host
  Drivers: scsi: storvsc: Fix a bug in handling VMBUS protocol version
  drivers: scsi: storvsc: Set srb_flags in all cases
  drivers: scsi: storvsc: Correctly handle TEST_UNIT_READY failure

Kevin Hao (1):
  mtd/ftl: fix the double free of the buffers allocated in build_maps()

Kinglong Mee (1):
  NFSD: Decrease nfsd_users in nfsd_startup_generic fail

Larry Finger (1):
  staging: r8188eu: Add new USB ID

Laurent Pinchart (1):
  media: v4l: vsp1: Remove the unneeded vsp1_video_buffer video field

Linus Torvalds (1):
  vfs: fix bad hashing of dentries

Liu Bo (2):
  Btrfs: fix compressed write corruption on enospc
  Btrfs: fix crash on endio of reading corrupted block

Martin K. Petersen (1):
  scsi: add a blacklist flag which enables VPD page inquiries

Mauro Carvalho Chehab (3):
  media: xc5000: Fix get_frequency()
  media: xc4000: Fix get_frequency()
  media: au0828: Only alt setting logic when needed

Michael Welling (1):
  mfd: omap-usb-host: Fix improper mask use.

Murali Karicheri (1):
  ahci: add pcid for Marvel 0x9182 controller

NeilBrown (4):
  md/raid1,raid10: always abort recover on write error.
  md/raid6: avoid data corruption during recovery of double-degraded
    RAID6
  md/raid10: fix memory leak when reshaping a RAID10.
  md/raid10: Fix memory leak when raid10 reshape completes.

Nikesh Oswal (1):
  regulator: arizona-ldo1: remove bypass functionality

Oleg Nesterov (1):
  vm_is_stack: use for_each_thread() rather then buggy
    while_each_thread()

Paul Bolle (1):
  media: sms: Remove CONFIG_ prefix from Kconfig symbols

Paul Burton (1):
  MIPS: Prevent user from setting FCSR cause bits

Pavel Shilovsky (6):
  CIFS: Fix STATUS_CANNOT_DELETE error mapping for SMB2
  CIFS: Fix async reading on reconnects
  CIFS: Fix wrong directory attributes after rename
  CIFS: Fix wrong filename length for SMB2
  CIFS: Fix wrong restart readdir for SMB1
  CIFS: Fix directory rename error

Peter Chen (1):
  usb: ehci: using wIndex + 1 for hub port

Prarit Bhargava (2):
  x86: Add check for number of available vectors before CPU down
  x86, cpu hotplug: Fix stack frame warning in
    check_irq_vectors_for_cpu_disable()

Praveen Diwakar (1):
  ASoC: wm_adsp: Add missing MODULE_LICENSE

Qiao Zhou (1):
  ASoC: pcm: fix dpcm_path_put in dpcm runtime update

Roger Quadros (2):
  usb: hub: Prevent hub autosuspend if usbcore.autosuspend is -1
  mtd: nand: omap: Fix 1-bit Hamming code scheme, omap_calculate_ecc()

Ronald Wahl (1):
  carl9170: fix sending URBs with wrong type when using full-speed

Sage Weil (1):
  libceph: gracefully handle large reply messages from the mon

Salva Peiró (1):
  media: media-device: Remove duplicated memset() in
    media_enum_entities()

Sasha Levin (1):
  kernel/smp.c:on_each_cpu_cond(): fix warning in fallback path

Scott Jiang (1):
  ASoC: blackfin: use samples to set silence

Steve French (1):
  CIFS: Possible null ptr deref in SMB2_tcon

Steve Wise (1):
  RDMA/iwcm: Use a default listen backlog if needed

Steven Rostedt (Red Hat) (2):
  ring-buffer: Always reset iterator to reader page
  ring-buffer: Up rb_iter_peek() loop count to 3

Sylwester Nawrocki (1):
  ASoC: samsung: Correct I2S DAI suspend/resume ops

Takashi Iwai (1):
  Btrfs: Fix memory corruption by ulist_add_merge() on 32bit arch

Tejun Heo (2):
  blkcg: don't call into policy draining if root_blkg is already gone
  libata: widen Crucial M550 blacklist matching

Tetsuo Handa (5):
  drm/ttm: Fix possible division by 0 in ttm_dma_pool_shrink_scan().
  drm/ttm: Choose a pool to shrink correctly in
    ttm_dma_pool_shrink_scan().
  drm/ttm: Use mutex_trylock() to avoid deadlock inside shrinker
    functions.
  drm/ttm: Fix possible stack overflow by recursive shrinker calls.
  drm/ttm: Pass GFP flags in order to avoid deadlock.

Theodore Ts'o (1):
  ext4: fix BUG_ON in mb_free_blocks()

Thomas Gleixner (1):
  futex: Unlock hb->lock in futex_wait_requeue_pi() error path

Thomas Petazzoni (1):
  spi: orion: fix incorrect handling of cell-index DT property

Trond Myklebust (1):
  NFSv4: Fix problems with close in the presence of a delegation

Vignesh Raman (1):
  Bluetooth: Avoid use of session socket after the session gets freed

Vincent Stehlé (1):
  usb: host: ohci-spear: fix ohci_dump parameters

Vladimir Davydov (1):
  Bluetooth: never linger on process exit

Will Deacon (1):
  arm64: flush TLS registers during exec

 arch/arm64/kernel/process.c                        |  18 ++
 arch/arm64/kernel/sys_compat.c                     |   6 +
 arch/mips/cavium-octeon/setup.c                    |  18 +-
 arch/mips/kernel/irq-gic.c                         |   6 +-
 arch/mips/kernel/ptrace.c                          |   3 +-
 arch/mips/kernel/unaligned.c                       |   1 -
 arch/mips/mm/tlbex.c                               |   1 +
 arch/openrisc/kernel/entry.S                       |  59 ++---
 arch/openrisc/kernel/signal.c                      | 198 ++++++++--------
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
 arch/x86/include/asm/irq.h                         |   1 +
 arch/x86/kernel/irq.c                              |  77 +++++++
 arch/x86/kernel/smpboot.c                          |   6 +
 block/blk-cgroup.c                                 |   7 +
 drivers/acpi/acpica/utcopy.c                       |   6 +
 drivers/acpi/processor_idle.c                      |   4 +-
 drivers/ata/ahci.c                                 |  10 +
 drivers/ata/libata-core.c                          |   2 +-
 drivers/ata/pata_scc.c                             |  15 +-
 drivers/char/tpm/tpm.c                             |  69 ++++--
 drivers/char/tpm/tpm.h                             |   3 +
 drivers/char/tpm/tpm_tis.c                         |  31 +++
 drivers/firmware/efi/vars.c                        |   8 +-
 drivers/gpu/drm/i915/intel_ringbuffer.c            |   3 +
 drivers/gpu/drm/radeon/cik.c                       |   5 +-
 drivers/gpu/drm/radeon/radeon_atombios.c           |   4 +-
 drivers/gpu/drm/radeon/si.c                        |   2 +-
 drivers/gpu/drm/radeon/trinity_dpm.c               |  11 +-
 drivers/gpu/drm/tilcdc/tilcdc_drv.c                |   7 +-
 drivers/gpu/drm/tilcdc/tilcdc_panel.c              |   5 +-
 drivers/gpu/drm/tilcdc/tilcdc_slave.c              |   1 +
 drivers/gpu/drm/tilcdc/tilcdc_tfp410.c             |   1 +
 drivers/gpu/drm/ttm/ttm_page_alloc.c               |  29 ++-
 drivers/gpu/drm/ttm/ttm_page_alloc_dma.c           |  34 +--
 drivers/infiniband/core/iwcm.c                     |  27 +++
 drivers/infiniband/ulp/srp/ib_srp.c                |  38 ++-
 drivers/iommu/amd_iommu.c                          |  10 +-
 drivers/md/raid1.c                                 |   8 +-
 drivers/md/raid10.c                                |  14 +-
 drivers/md/raid5.c                                 |   2 +
 drivers/media/common/siano/Kconfig                 |   3 +-
 drivers/media/media-device.c                       |   2 -
 drivers/media/platform/vsp1/vsp1_video.c           |   2 -
 drivers/media/platform/vsp1/vsp1_video.h           |   1 -
 drivers/media/tuners/xc4000.c                      |  20 +-
 drivers/media/tuners/xc5000.c                      |  22 +-
 drivers/media/usb/au0828/au0828-video.c            |  34 +--
 drivers/mfd/omap-usb-host.c                        |   2 +-
 drivers/misc/mei/nfc.c                             |  11 +-
 drivers/mtd/ftl.c                                  |   1 -
 drivers/mtd/nand/omap2.c                           |   2 +-
 drivers/net/ethernet/ibm/ibmveth.c                 |  18 +-
 drivers/net/wireless/ath/carl9170/carl9170.h       |   1 +
 drivers/net/wireless/ath/carl9170/usb.c            |  31 ++-
 drivers/regulator/arizona-ldo1.c                   |   2 -
 drivers/scsi/bfa/bfa_ioc.h                         |   2 +-
 drivers/scsi/scsi_devinfo.c                        |   1 +
 drivers/scsi/scsi_scan.c                           |  16 +-
 drivers/scsi/sd.c                                  |   5 +
 drivers/scsi/storvsc_drv.c                         | 113 ++++++---
 drivers/spi/spi-orion.c                            |  10 +-
 drivers/spi/spi-pxa2xx.c                           |   1 +
 drivers/staging/rtl8188eu/os_dep/usb_intf.c        |   2 +
 drivers/usb/core/hub.c                             |   8 +-
 drivers/usb/host/ehci-hub.c                        |   2 +-
 drivers/usb/host/ohci-spear.c                      |   2 +-
 drivers/usb/host/xhci-pci.c                        |   4 +
 drivers/usb/host/xhci-ring.c                       |   3 +-
 drivers/usb/serial/ftdi_sio.c                      |   3 +
 drivers/usb/serial/ftdi_sio_ids.h                  |   7 +
 drivers/usb/serial/whiteheat.c                     |   7 +-
 fs/aio.c                                           |   6 +
 fs/btrfs/backref.c                                 |  14 +-
 fs/btrfs/extent_io.c                               |   1 +
 fs/btrfs/file-item.c                               |   2 +-
 fs/btrfs/inode.c                                   |  12 +
 fs/btrfs/ulist.h                                   |  15 ++
 fs/cifs/cifsglob.h                                 |   5 -
 fs/cifs/file.c                                     |   4 +-
 fs/cifs/inode.c                                    |  11 +-
 fs/cifs/readdir.c                                  |   4 +-
 fs/cifs/smb2file.c                                 |   2 +-
 fs/cifs/smb2inode.c                                |   2 +-
 fs/cifs/smb2maperror.c                             |   2 +-
 fs/cifs/smb2ops.c                                  |   2 +-
 fs/cifs/smb2pdu.c                                  |   5 +-
 fs/dcache.c                                        |   5 +-
 fs/ext4/inode.c                                    |  10 +-
 fs/ext4/mballoc.c                                  |   5 +
 fs/ext4/super.c                                    |   5 +-
 fs/jbd2/commit.c                                   |  21 +-
 fs/jbd2/journal.c                                  |  56 +++--
 fs/jbd2/recovery.c                                 |  33 +--
 fs/jbd2/revoke.c                                   |   6 +-
 fs/namei.c                                         |   4 +-
 fs/namespace.c                                     |   8 +
 fs/nfs/nfs4proc.c                                  |  17 +-
 fs/nfsd/nfs4callback.c                             |   3 +-
 fs/nfsd/nfssvc.c                                   |   5 +-
 fs/proc/array.c                                    |  11 +-
 fs/xfs/xfs_aops.c                                  |  61 +++++
 fs/xfs/xfs_dquot.c                                 |   3 +-
 fs/xfs/xfs_file.c                                  |  21 +-
 fs/xfs/xfs_log_recover.c                           |  51 ++--
 fs/xfs/xfs_qm.c                                    |   8 +-
 include/linux/capability.h                         |   5 +-
 include/linux/jbd2.h                               |  30 ++-
 include/linux/sunrpc/svc_xprt.h                    |   1 +
 include/scsi/scsi_device.h                         |   1 +
 include/scsi/scsi_devinfo.h                        |   5 +
 include/uapi/rdma/rdma_user_cm.h                   |   1 +
 kernel/audit.c                                     |   2 +-
 kernel/capability.c                                |   4 +
 kernel/futex.c                                     |   1 +
 kernel/smp.c                                       |   2 +-
 kernel/trace/ring_buffer.c                         |  31 ++-
 mm/util.c                                          |   9 +-
 net/bluetooth/l2cap_sock.c                         |   3 +-
 net/bluetooth/rfcomm/core.c                        |   7 +-
 net/bluetooth/rfcomm/sock.c                        |   3 +-
 net/bluetooth/sco.c                                |   6 +-
 net/ceph/auth_x.c                                  | 256 +++++++++++----------
 net/ceph/messenger.c                               |   2 +-
 net/ceph/mon_client.c                              |   8 +
 net/sunrpc/svcsock.c                               |   2 +
 net/sunrpc/xprt.c                                  |   2 +-
 net/sunrpc/xprtrdma/svc_rdma_transport.c           |   1 +
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
 151 files changed, 1725 insertions(+), 731 deletions(-)
 create mode 100644 tools/testing/selftests/mount/Makefile
 create mode 100644 tools/testing/selftests/mount/unprivileged-remount-test.c

-- 
2.1.0

