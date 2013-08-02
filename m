Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751766Ab3HBKRi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 06:17:38 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37559 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751635Ab3HBKRg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 06:17:36 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: [ 00/39] 3.4.56-stable review
Date: Fri,  2 Aug 2013 18:18:10 +0800
Message-Id: <20130802101456.800497005@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.4.841.g1a3f60e
User-Agent: quilt/0.60-5.1.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.4.56 release.
There are 39 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun Aug  4 10:13:49 UTC 2013.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.56-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.4.56-rc1

Wanpeng Li <liwanp@linux.vnet.ibm.com>
    mm/memory-hotplug: fix lowmem count overflow when offline pages

Michael S. Tsirkin <mst@redhat.com>
    virtio_net: fix race in RX VQ processing

Michael S. Tsirkin <mst@redhat.com>
    virtio: support unlocked queue poll

Linus Torvalds <torvalds@linux-foundation.org>
    s390: move dummy io_remap_pfn_range() to asm/pgtable.h

Steffen Maier <maier@linux.vnet.ibm.com>
    zfcp: status read buffers on first adapter open with link down

Clemens Ladisch <clemens@ladisch.de>
    firewire: fix libdc1394/FlyCap2 iso event regression

David Vrabel <david.vrabel@citrix.com>
    xen/evtchn: avoid a deadlock when unbinding an event channel

NeilBrown <neilb@suse.de>
    md/raid10: remove use-after-free bug.

NeilBrown <neilb@suse.de>
    md/raid5: fix interaction of 'replace' and 'recovery'.

Al Viro <viro@zeniv.linux.org.uk>
    livelock avoidance in sget()

Rick Farina (Zero_Chaos) <zerochaos@gentoo.org>
    USB: serial: ftdi_sio: add more RT Systems ftdi devices

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon/atom: initialize more atom interpretor elements to 0

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: improve dac adjust heuristics for legacy pdac

Mark Kettenis <kettenis@openbsd.org>
    drm/radeon: fix combios tables on older cards

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: fix endian issues with DP handling (v3)

Mikulas Patocka <mpatocka@redhat.com>
    dm verity: fix inability to use a few specific devices sizes

Toshi Kani <toshi.kani@hp.com>
    ACPI / memhotplug: Fix a stale pointer in error path

Anton Blanchard <anton@samba.org>
    powerpc/modules: Module CRC relocation fix causes perf issues

Tejun Heo <tj@kernel.org>
    libata: make it clear that sata_inic162x is experimental

Youquan Song <youquan.song@intel.com>
    ata: Fix DVD not dectected at some platform with Wellsburg PCH

Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
    xen/blkback: Check device permissions before allowing OP_DISCARD

Josef Bacik <jbacik@fusionio.com>
    Btrfs: re-add root to dead root list if we stop dropping it

Josef Bacik <jbacik@fusionio.com>
    Btrfs: fix lock leak when resuming snapshot deletion

Ian Abbott <abbotti@mev.co.uk>
    staging: comedi: COMEDI_CANCEL ioctl should wake up read/write

William Gulland <wgulland@google.com>
    usb: Clear both buffers when clearing a control transfer TT buffer.

Jóhann B. Guðmundsson <johannbg@fedoraproject.org>
    USB: misc: Add Manhattan Hi-Speed USB DVI Converter to sisusbvga

Johan Hovold <jhovold@gmail.com>
    USB: ti_usb_3410_5052: fix dynamic-id matching

Felipe Balbi <balbi@ti.com>
    usb: dwc3: gadget: don't prevent gadget from being probed if we fail

Huang Rui <ray.huang@amd.com>
    usb: dwc3: fix wrong bit mask in dwc3_event_type

Sarah Sharp <sarah.a.sharp@linux.intel.com>
    xhci: Avoid NULL pointer deref when host dies.

Oleksij Rempel <linux@rempel-privat.de>
    xhci: fix null pointer dereference on ring_doorbell_for_active_rings

George Cherian <george.cherian@ti.com>
    usb: host: xhci: Enable XHCI_SPURIOUS_SUCCESS for all controllers with xhci 1.0

zhangwei(Jovi) <jovi.zhangwei@huawei.com>
    tracing: Fix irqs-off tag display in syscall tracing

Saurav Kashyap <saurav.kashyap@qlogic.com>
    SCSI: qla2xxx: Properly set the tagging for commands.

Ewan D. Milne <emilne@redhat.com>
    SCSI: sd: fix crash when UA received on DIF enabled device

Nicolin Chen <b42378@freescale.com>
    ASoC: wm8962: Remove remaining direct register cache accesses

Chih-Chung Chang <chihchung@chromium.org>
    ASoC: max98088 - fix element type of the register cache.

Ren Bigcren <bigcren.ren@sonymobile.com>
    USB: storage: Add MicroVault Flash Drive to unusual_devs

Joern Engel <joern@logfs.org>
    iscsi-target: Fix tfc_tpg_nacl_auth_cit configfs length overflow


-------------

Diffstat:

 Makefile                                     |   4 +-
 arch/powerpc/include/asm/module.h            |   5 +-
 arch/powerpc/kernel/vmlinux.lds.S            |   3 -
 arch/s390/include/asm/pgtable.h              |   4 +
 drivers/acpi/acpi_memhotplug.c               |   1 +
 drivers/ata/Kconfig                          |   2 +-
 drivers/ata/ata_piix.c                       |   2 +-
 drivers/ata/sata_inic162x.c                  |  14 +++
 drivers/block/xen-blkback/blkback.c          |  13 ++-
 drivers/firewire/core-cdev.c                 |   3 +
 drivers/firewire/ohci.c                      |  10 +-
 drivers/gpu/drm/radeon/atom.c                |   5 +
 drivers/gpu/drm/radeon/atombios_dp.c         |  43 +++++++-
 drivers/gpu/drm/radeon/radeon_combios.c      | 151 ++++++++-------------------
 drivers/md/dm-verity.c                       |   5 +-
 drivers/md/raid10.c                          |   8 +-
 drivers/md/raid5.c                           |  15 ++-
 drivers/md/raid5.h                           |   1 +
 drivers/net/virtio_net.c                     |   5 +-
 drivers/s390/scsi/zfcp_aux.c                 |   5 +-
 drivers/s390/scsi/zfcp_fsf.c                 |  23 ++--
 drivers/scsi/qla2xxx/qla_iocb.c              |  11 +-
 drivers/scsi/sd.c                            |  22 ++--
 drivers/staging/comedi/comedi_fops.c         |   7 +-
 drivers/target/iscsi/iscsi_target_configfs.c |   2 +-
 drivers/usb/core/hub.c                       |   9 ++
 drivers/usb/dwc3/core.h                      |   4 +-
 drivers/usb/dwc3/gadget.c                    |   1 +
 drivers/usb/host/xhci-pci.c                  |   1 -
 drivers/usb/host/xhci-ring.c                 |   2 +-
 drivers/usb/host/xhci.c                      |  13 ++-
 drivers/usb/misc/sisusbvga/sisusb.c          |   1 +
 drivers/usb/serial/ftdi_sio.c                |  31 +++++-
 drivers/usb/serial/ftdi_sio_ids.h            |  34 +++++-
 drivers/usb/serial/ti_usb_3410_5052.c        |   2 +-
 drivers/usb/storage/unusual_devs.h           |   7 ++
 drivers/virtio/virtio_ring.c                 |  54 ++++++++--
 drivers/xen/evtchn.c                         |  21 +---
 fs/btrfs/extent-tree.c                       |  13 +++
 fs/super.c                                   |  25 ++---
 include/linux/firewire-cdev.h                |   4 +-
 include/linux/firewire.h                     |   1 +
 include/linux/virtio.h                       |   4 +
 kernel/trace/trace_syscalls.c                |   3 +
 mm/page_alloc.c                              |   4 +
 sound/soc/codecs/max98088.c                  |   2 +-
 sound/soc/codecs/wm8962.c                    |  24 +++--
 47 files changed, 388 insertions(+), 236 deletions(-)


