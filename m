Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757089Ab3LBViE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 16:38:04 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38145 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752804Ab3LBTGo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:06:44 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: [PATCH 3.4 00/60] 3.4.72-stable review
Date: Mon,  2 Dec 2013 11:05:41 -0800
Message-Id: <20131202190330.152596462@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
User-Agent: quilt/0.60-8.1.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.4.72 release.
There are 60 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed Dec  4 19:01:45 UTC 2013.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.72-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.4.72-rc1

Nanno Langstraat <langstr@gmail.com>
    HID: apple: option to swap the 'Option' ("Alt") and 'Command' ("Flag") keys.

Stefan Achatz <erazor_de@users.sourceforge.net>
    HID: roccat: fix Coverity CID 141438

Mauro Carvalho Chehab <m.chehab@samsung.com>
    media: lirc_zilog: Don't use dynamic static allocation

Steven Rostedt (Red Hat) <rostedt@goodmis.org>
    ftrace: Fix function graph with loading of modules

Alex Williamson <alex.williamson@redhat.com>
    KVM: Fix iommu map/unmap to handle memory slot moves

Marcelo Tosatti <mtosatti@redhat.com>
    KVM: perform an invalid memslot step for gpa base change

Tom Gundersen <teg@jklm.no>
    Input: i8042 - add PNP modaliases

Steven Rostedt (Red Hat) <rostedt@goodmis.org>
    tracing: Allow events to have NULL strings

Kailang Yang <kailang@realtek.com>
    ALSA: hda/realtek - Set pcbeep amp for ALC668

Peter Zijlstra <peterz@infradead.org>
    cpuset: Fix memory allocator deadlock

Michael Neuling <mikey@neuling.org>
    powerpc/signals: Improved mark VSX not saved with small contexts fix

NeilBrown <neilb@suse.de>
    md: fix calculation of stacking limits on level change.

Jerome Glisse <jglisse@redhat.com>
    radeon: workaround pinning failure on low ram gpu

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon/si: fix define for MC_SEQ_TRAIN_WAKEUP_CNTL

Ben Skeggs <bskeggs@redhat.com>
    drm/nouveau: when bailing out of a pushbuf ioctl, do not remove previous fence

Daniel Vetter <daniel.vetter@ffwll.ch>
    drm/i915: flush cursors harder

Jakob Bornecrantz <jakob@vmware.com>
    drm/ttm: Handle in-memory region copies

Dan Williams <dcbw@redhat.com>
    prism54: set netdev type to "wlan"

Andreas Bießmann <andreas@biessmann.de>
    avr32: fix out-of-range jump in large kernels

Andreas Bießmann <andreas@biessmann.de>
    avr32: setup crt for early panic()

Paul Moore <pmoore@redhat.com>
    selinux: correct locking in selinux_netlbl_socket_connect)

Yinghai Lu <yinghai@kernel.org>
    PCI: Remove duplicate pci_disable_device() from pcie_portdrv_remove()

Mathias Krause <minipli@googlemail.com>
    audit: fix info leak in AUDIT_GET requests

Mathias Krause <minipli@googlemail.com>
    audit: use nlmsg_len() to get message payload length

Tyler Hicks <tyhicks@canonical.com>
    audit: printk USER_AVC messages when audit isn't enabled

Avinash Patil <patila@marvell.com>
    mwifiex: correct packet length for packets from SDIO interface

Aaron Lu <aaron.lu@intel.com>
    PM / hibernate: Avoid overflow in hibernate_preallocate_memory()

Mikulas Patocka <mpatocka@redhat.com>
    dm: allocate buffer for messages with small number of arguments using GFP_NOIO

Stanislaw Gruszka <stf_xl@wp.pl>
    rt2400pci: fix RSSI read

Ursula Braun <ursula.braun@de.ibm.com>
    qeth: avoid buffer overflow in snmp ioctl

Larry Finger <Larry.Finger@lwfinger.net>
    rtlwifi: rtl8192cu: Fix incorrect signal strength for unassociated AP

Larry Finger <Larry.Finger@lwfinger.net>
    rtlwifi: rtl8192se: Fix incorrect signal strength for unassociated AP

Larry Finger <Larry.Finger@lwfinger.net>
    rtlwifi: rtl8192de: Fix incorrect signal strength for unassociated AP

Malcolm Priestley <tvboxspy@gmail.com>
    staging: vt6656: [BUG] Fix for TX USB resets from vendors driver.

Vegard Nossum <vegard.nossum@oracle.com>
    xen/blkback: fix reference counting

Theodore Ts'o <tytso@mit.edu>
    ext4: avoid bh leak in retry path of ext4_expand_extra_isize_ea()

Huang Shijie <b32955@freescale.com>
    mtd: gpmi: fix kernel BUG due to racing DMA operations

Wang Haitao <wang.haitao1@zte.com.cn>
    mtd: map: fixed bug in 64-bit systems

Brian Norris <computersforpeace@gmail.com>
    mtd: nand: hack ONFI for non-power-of-2 dimensions

Mikulas Patocka <mpatocka@redhat.com>
    loop: fix crash if blk_alloc_queue fails

Jan Kara <jack@suse.cz>
    IB/ipath: Convert ipath_user_sdma_pin_pages() to use get_user_pages_fast()

Eric Seppanen <eric@purestorage.com>
    iscsi-target: chap auth shouldn't match username with trailing garbage

Eric Seppanen <eric@purestorage.com>
    iscsi-target: fix extract_param to handle buffer length corner case

Samir Benmendil <samir.benmendil@gmail.com>
    ahci: add Marvell 9230 to the AHCI PCI device list

xiangliang yu <yxlraid@gmail.com>
    ahci: disabled FBS prior to issuing software reset

Larry Finger <Larry.Finger@lwfinger.net>
    rtlwifi: rtl8192cu: Fix more pointer arithmetic errors

Felipe Pena <felipensp@gmail.com>
    rtlwifi: rtl8192se: Fix wrong assignment

Ryan Mallon <rmallon@gmail.com>
    vsprintf: check real user/group id for %pK

Shan Hai <shan.hai@windriver.com>
    drivers/libata: Set max sector to 65535 for Slimtype DVD A DS8A9SH drive

Gwendal Grignou <gwendal@google.com>
    libata: Fix display of sata speed

Marc Kleine-Budde <mkl@pengutronix.de>
    can: flexcan: fix flexcan_chip_start() on imx6

Ilija Hadzic <ihadzic@research.bell-labs.com>
    devpts: plug the memory leak in kill_sb

KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
    alarmtimer: return EINVAL instead of ENOTSUPP if rtcdev doesn't exist

Takashi Iwai <tiwai@suse.de>
    ASoC: blackfin: Fix missing break

Nicolin Chen <b42378@freescale.com>
    ASoC: wm8962: Turn on regcache_cache_only before disabling regulator

Phil Edworthy <phil.edworthy@renesas.com>
    ASoC: ak4642: prevent un-necessary changes to SG_SL1

Johan Hovold <jhovold@gmail.com>
    backlight: atmel-pwm-bl: fix reported brightness

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Staging: tidspbridge: disable driver

Jonathan Austin <jonathan.austin@arm.com>
    ARM: integrator_cp: Set LCD{0,1} enable lines when turning on CLCD

Russell King <rmk+kernel@arm.linux.org.uk>
    ARM: sa11x0/assabet: ensure CS2 is configured appropriately


-------------

Diffstat:

 Documentation/sysctl/kernel.txt               | 25 +++++++---
 Makefile                                      |  4 +-
 arch/arm/mach-integrator/integrator_cp.c      |  3 +-
 arch/arm/mach-sa1100/assabet.c                |  3 ++
 arch/avr32/boot/u-boot/head.S                 | 35 +++++++++++---
 arch/avr32/kernel/entry-avr32b.S              |  3 +-
 arch/avr32/kernel/head.S                      | 20 --------
 arch/powerpc/kernel/signal_32.c               | 16 +++----
 arch/powerpc/kernel/signal_64.c               |  6 +++
 drivers/ata/ahci.c                            |  2 +
 drivers/ata/libahci.c                         | 16 +++++++
 drivers/ata/libata-core.c                     |  1 +
 drivers/ata/libata-transport.c                | 16 +++----
 drivers/block/loop.c                          |  4 +-
 drivers/block/xen-blkback/blkback.c           |  3 +-
 drivers/gpu/drm/i915/intel_display.c          |  4 ++
 drivers/gpu/drm/nouveau/nouveau_gem.c         |  3 +-
 drivers/gpu/drm/radeon/radeon_legacy_crtc.c   | 28 +++++++++++
 drivers/gpu/drm/radeon/sid.h                  |  2 +-
 drivers/gpu/drm/ttm/ttm_bo_util.c             |  4 +-
 drivers/hid/hid-apple.c                       | 22 +++++++++
 drivers/hid/hid-roccat-kovaplus.c             |  4 ++
 drivers/infiniband/hw/ipath/ipath_user_sdma.c |  7 +--
 drivers/input/serio/i8042-x86ia64io.h         |  2 +
 drivers/md/dm-table.c                         | 18 ++++++-
 drivers/md/md.c                               |  1 +
 drivers/mtd/nand/gpmi-nand/gpmi-nand.c        |  4 +-
 drivers/mtd/nand/nand_base.c                  | 15 +++++-
 drivers/net/can/flexcan.c                     | 12 -----
 drivers/net/wireless/mwifiex/sdio.c           |  3 ++
 drivers/net/wireless/prism54/islpci_dev.c     |  7 ++-
 drivers/net/wireless/rt2x00/rt2400pci.c       |  2 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/mac.c  |  6 +--
 drivers/net/wireless/rtlwifi/rtl8192cu/trx.c  |  8 ++--
 drivers/net/wireless/rtlwifi/rtl8192de/trx.c  |  2 +-
 drivers/net/wireless/rtlwifi/rtl8192se/rf.c   |  2 +-
 drivers/net/wireless/rtlwifi/rtl8192se/trx.c  |  2 +-
 drivers/pci/pcie/portdrv_pci.c                |  1 -
 drivers/s390/net/qeth_core_main.c             |  6 ++-
 drivers/staging/media/lirc/lirc_zilog.c       | 12 ++++-
 drivers/staging/tidspbridge/Kconfig           |  2 +-
 drivers/staging/vt6656/baseband.c             | 11 +++++
 drivers/staging/vt6656/rndis.h                |  1 +
 drivers/target/iscsi/iscsi_target_auth.c      |  5 +-
 drivers/target/iscsi/iscsi_target_nego.c      |  2 +-
 drivers/video/backlight/atmel-pwm-bl.c        |  4 +-
 fs/devpts/inode.c                             |  1 +
 fs/ext4/xattr.c                               |  1 +
 include/linux/mtd/map.h                       |  4 +-
 include/trace/ftrace.h                        |  5 +-
 kernel/audit.c                                |  5 +-
 kernel/cpuset.c                               |  8 +++-
 kernel/power/snapshot.c                       |  6 ++-
 kernel/time/alarmtimer.c                      |  4 +-
 kernel/trace/ftrace.c                         | 68 +++++++++++++--------------
 lib/vsprintf.c                                | 33 +++++++++++--
 security/selinux/netlabel.c                   |  6 +--
 sound/pci/hda/patch_realtek.c                 |  1 +
 sound/soc/blackfin/bf5xx-i2s.c                |  1 +
 sound/soc/codecs/ak4642.c                     |  2 +-
 sound/soc/codecs/wm8962.c                     |  2 +
 virt/kvm/kvm_main.c                           | 25 +++++-----
 62 files changed, 363 insertions(+), 168 deletions(-)


