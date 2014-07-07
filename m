Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753874AbaGGXyf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 19:54:35 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55614 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753661AbaGGXy1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 19:54:27 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        stable@vger.kernel.org
Subject: [PATCH 3.14 00/94] 3.14.12-stable review
Date: Mon,  7 Jul 2014 16:56:50 -0700
Message-Id: <20140707235756.780319003@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.254.g50f84e3
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.14.12 release.
There are 94 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed Jul  9 23:57:44 UTC 2014.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.14.12-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.14.12-rc1

Mikulas Patocka <mpatocka@redhat.com>
    sym53c8xx_2: Set DID_REQUEUE return code when aborting squeue

Joonsoo Kim <iamjoonsoo.kim@lge.com>
    slab: fix oops when reading /proc/slab_allocators

Rik van Riel <riel@redhat.com>
    mm/numa: Remove BUG_ON() in __handle_mm_fault()

Zhichuang SUN <sunzc522@gmail.com>
    drivers/video/fbdev/fb-puv3.c: Add header files for function unifb_mmap

Chen Gang <gang.chen.5i5j@gmail.com>
    arch/unicore32/mm/alignment.c: include "asm/pgtable.h" to avoid compiling error

Sander Eikelenboom <linux@eikelenboom.it>
    ALSA: usb-audio: Prevent printk ratelimiting from spamming kernel log while DEBUG not defined

Tim Gardner <tim.gardner@canonical.com>
    ALSA: usb-audio: Suppress repetitive debug messages from retire_playback_urb()

Richard Guy Briggs <rgb@redhat.com>
    audit: remove superfluous new- prefix in AUDIT_LOGIN messages

Anatol Pomozov <anatol.pomozov@gmail.com>
    aio: block io_destroy() until all context requests are completed

Imre Deak <imre.deak@intel.com>
    drm/i915: fix display power sw state reporting

Micky Ching <micky_ching@realsil.com.cn>
    mmc: rtsx: add R1-no-CRC mmc command type handle

Hans de Goede <hdegoede@redhat.com>
    brcmfmac: Fix brcmf_chip_ai_coredisable not applying reset bits to BCMA_IOCTL

Florian Westphal <fw@strlen.de>
    netfilter: nf_nat: fix oops on netns removal

Peter Hurley <peter@hurleysoftware.com>
    tty: Correct INPCK handling

Peter Hurley <peter@hurleysoftware.com>
    serial: Fix IGNBRK handling

Stephen Boyd <sboyd@codeaurora.org>
    clk: qcom: Fix mmcc-8974's PLL configurations

Stephen Boyd <sboyd@codeaurora.org>
    clk: qcom: Fix clk_rcg2_is_enabled() check

Jack Morgenstein <jackm@dev.mellanox.co.il>
    mlx4_core: Fix incorrect FLAGS1 bitmap test in mlx4_QUERY_FUNC_CAP

Michal Nazarewicz <mina86@mina86.com>
    mm: page_alloc: fix CMA area initialisation when pageblock > MAX_ORDER

Thomas Gleixner <tglx@linutronix.de>
    irqchip: spear_shirq: Fix interrupt offset

NeilBrown <neilb@suse.de>
    md: flush writes before starting a recovery.

Steven Rostedt (Red Hat) <rostedt@goodmis.org>
    tracing: Remove ftrace_stop/start() from reading the trace file

Michal Nazarewicz <mina86@mina86.com>
    tools: ffs-test: fix header values endianess

J. Bruce Fields <bfields@redhat.com>
    nfsd: fix rare symlink decoding bug

Dan Carpenter <dan.carpenter@oracle.com>
    staging: iio/ad7291: fix error code in ad7291_probe()

Adam Thomson <Adam.Thomson.Opensource@diasemi.com>
    iio: of_iio_channel_get_by_name() returns non-null pointers for error legs

Xiaoming Gao <newtongao@tencent.com>
    kvm: fix wrong address when writing Hyper-V tsc page

Paolo Bonzini <pbonzini@redhat.com>
    KVM: x86: preserve the high 32-bits of the PAT register

Nadav Amit <namit@cs.technion.ac.il>
    KVM: x86: Increase the number of fixed MTRR regs to 10

Jan Kara <jack@suse.cz>
    ext4: Fix hole punching for files with indirect blocks

Jan Kara <jack@suse.cz>
    ext4: Fix buffer double free in ext4_alloc_branch()

Tejun Heo <tj@kernel.org>
    blkcg: fix use-after-free in __blkg_release_rcu() by making blkcg_gq refcnt an atomic_t

Steve French <smfrench@gmail.com>
    CIFS: fix mount failure with broken pathnames when smb3 mount with mapchars option

Björn Baumbach <bb@sernet.de>
    fs/cifs: fix regression in cifs_create_mf_symlink()

Rafał Miłecki <zajec5@gmail.com>
    b43: fix frequency reported on G-PHY with /new/ firmware

Maxime Ripard <maxime.ripard@free-electrons.com>
    net: allwinner: emac: Add missing free_irq

ChiaHao <andy.jhshiu@gmail.com>
    arm64: Bug fix in stack alignment exception

David R. Piegdon <lkml@p23q.org>
    ARM: OMAP2+: Fix parser-bug in platform muxing code

Steve Capper <steve.capper@linaro.org>
    arm64: mm: Make icache synchronisation logic huge page aware

David Rientjes <rientjes@google.com>
    mm, pcp: allow restoring percpu_pagelist_fraction default

Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
    hugetlb: fix copy_hugetlb_page_range() to handle migration/hwpoisoned entry

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    iwlwifi: pcie: try to get ownership several times

Felix Fietkau <nbd@openwrt.org>
    mac80211: fix a memory leak on sta rate selection table

Arik Nemtsov <arik@wizery.com>
    mac80211: don't check netdev state for debugfs read/write

Krzysztof Hałasa <khalasa@piap.pl>
    mac80211: fix IBSS join by initializing last_scan_completed

Doug Smythies <doug.smythies@gmail.com>
    intel_pstate: Correct rounding in busy calculation

Fabio Baltieri <fabio.baltieri@gmail.com>
    hwmon: (ina2xx) Cast to s16 on shunt and current regs

Ilya Dryomov <ilya.dryomov@inktank.com>
    rbd: handle parent_overlap on writes correctly

Alex Elder <elder@linaro.org>
    rbd: use reference counts for image requests

Lukas Czerner <lczerner@redhat.com>
    dm thin: update discard_granularity to reflect the thin-pool blocksize

Marcin Kraglak <marcin.kraglak@tieto.com>
    Bluetooth: Allow change security level on ATT_CID in slave role

Johan Hedberg <johan.hedberg@intel.com>
    Bluetooth: Fix locking of hdev when calling into SMP code

Johan Hedberg <johan.hedberg@intel.com>
    Bluetooth: Fix indicating discovery state when canceling inquiry

Johan Hedberg <johan.hedberg@intel.com>
    Bluetooth: Fix check for connection encryption

Johan Hedberg <johan.hedberg@intel.com>
    Bluetooth: Fix SSP acceptor just-works confirmation without MITM

Thomas Hellstrom <thellstrom@vmware.com>
    drm/vmwgfx: Fix incorrect write to read-only register v2:

Jani Nikula <jani.nikula@intel.com>
    drm/i915: set backlight duty cycle after backlight enable for gen4

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915: Avoid div-by-zero when pixel_multiplier is zero

Ilia Mirkin <imirkin@alum.mit.edu>
    drm/gk208/gr: add missing registers to grctx init

Mario Kleiner <mario.kleiner.de@gmail.com>
    drm/nv50-/mc: fix kms pageflip events by reordering irq handling order.

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon/cik: fix typo in EOP packet

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon/dpm: fix vddci setup typo on cayman

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon/dpm: fix typo in vddci setup for eg/btc

Marek Olšák <marek.olsak@amd.com>
    drm/radeon: don't allow RADEON_GEM_DOMAIN_CPU for command submission

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon/atom: fix dithering on certain panels

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon/dp: fix lane/clock setup for dp 1.2 capable devices

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: fix typo in radeon_connector_is_dp12_capable()

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: only apply hdmi bpc pll flags when encoder mode is hdmi

Mario Kleiner <mario.kleiner.de@gmail.com>
    drm/nouveau/kms: reference vblank for crtc during pageflip.

Mario Kleiner <mario.kleiner.de@gmail.com>
    drm/nouveau/disp/nv04-nv40: abort scanoutpos query on vga analog.

Mario Kleiner <mario.kleiner.de@gmail.com>
    drm/nouveau/kms/nv04-nv40: fix pageflip events via special case.

Alex Deucher <alexander.deucher@amd.com>
    vgaswitcheroo: switch the mux to the igp on power down when runpm is enabled

Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
    mtd: pxa3xx_nand: make the driver work on big-endian systems

pekon gupta <pekon@ti.com>
    mtd: nand: omap: fix BCHx ecc.correct to return detected bit-flips in erased-page

Pekon Gupta <pekon@ti.com>
    mtd: eLBC NAND: fix subpage write support

Stanislaw Gruszka <stf_xl@wp.pl>
    rt2x00: fix rfkill regression on rt2500pci

Stanislaw Gruszka <sgruszka@redhat.com>
    rt2x00: disable TKIP on USB

Michal Nazarewicz <mina86@mina86.com>
    usb: gadget: f_fs: fix NULL pointer dereference when there are no strings

Michal Nazarewicz <mina86@mina86.com>
    usb: gadget: f_fs: resurect usb_functionfs_descs_head structure

Johan Hovold <johan@kernel.org>
    USB: ftdi_sio: fix null deref at port probe

Peter Chen <peter.chen@freescale.com>
    usb: chipidea: udc: delete td from req's td list at ep_dequeue

Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
    usb: musb: Fix panic upon musb_am335x module removal

Thomas Gleixner <tglx@linutronix.de>
    usb: musb: Ensure that cppi41 timer gets armed on premature DMA TX irq

Linus Walleij <linus.walleij@linaro.org>
    usb: musb: ux500: don't propagate the OF node

Bjørn Mork <bjorn@mork.no>
    usb: option: add/modify Olivetti Olicard modems

Oliver Neukum <oneukum@suse.de>
    USB: option: add device ID for SpeedUp SU9800 usb 3g modem

Wang, Yu <yu.y.wang@intel.com>
    xhci: Fix runtime suspended xhci from blocking system suspend.

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: correct burst count field for isoc transfers on 1.0 xhci hosts

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: Use correct SLOT ID when handling a reset device command

Paolo Bonzini <pbonzini@redhat.com>
    virtio-scsi: fix various bad behavior on aborted requests

Ulrich Obergfell <uobergfe@redhat.com>
    scsi_error: fix invalid setting of host byte

Paolo Bonzini <pbonzini@redhat.com>
    virtio-scsi: avoid cancelling uninitialized work items

Brian King <brking@linux.vnet.ibm.com>
    ibmvscsi: Add memory barriers for send / receive

Brian King <brking@linux.vnet.ibm.com>
    ibmvscsi: Abort init sequence during error recovery


-------------

Diffstat:

 Documentation/sysctl/vm.txt                        |  3 +-
 Makefile                                           |  4 +-
 arch/arm/mach-omap2/mux.c                          |  6 +-
 arch/arm64/kernel/entry.S                          |  1 -
 arch/arm64/mm/flush.c                              |  3 +-
 arch/unicore32/mm/alignment.c                      |  1 +
 arch/x86/include/asm/kvm_host.h                    |  4 +-
 arch/x86/kvm/x86.c                                 |  2 +-
 block/blk-cgroup.c                                 |  7 +-
 block/blk-cgroup.h                                 | 17 ++---
 drivers/block/rbd.c                                | 19 ++++-
 drivers/clk/qcom/clk-rcg2.c                        |  2 +-
 drivers/clk/qcom/mmcc-msm8974.c                    | 13 ++--
 drivers/cpufreq/intel_pstate.c                     |  5 +-
 drivers/gpu/drm/i915/intel_panel.c                 |  5 +-
 drivers/gpu/drm/i915/intel_pm.c                    | 17 ++++-
 drivers/gpu/drm/i915/intel_sdvo.c                  |  4 +-
 drivers/gpu/drm/nouveau/core/engine/disp/nv04.c    |  8 ++
 .../gpu/drm/nouveau/core/engine/graph/ctxnv108.c   |  2 +
 drivers/gpu/drm/nouveau/core/subdev/mc/nv50.c      |  2 +-
 drivers/gpu/drm/nouveau/core/subdev/mc/nv98.c      |  2 +-
 drivers/gpu/drm/nouveau/core/subdev/mc/nvc0.c      |  2 +-
 drivers/gpu/drm/nouveau/nouveau_display.c          | 17 ++++-
 drivers/gpu/drm/radeon/atombios_crtc.c             | 48 ++++++------
 drivers/gpu/drm/radeon/atombios_dp.c               | 17 ++++-
 drivers/gpu/drm/radeon/atombios_encoders.c         |  5 +-
 drivers/gpu/drm/radeon/cikd.h                      |  2 +-
 drivers/gpu/drm/radeon/cypress_dpm.c               |  2 +-
 drivers/gpu/drm/radeon/ni_dpm.c                    |  2 +-
 drivers/gpu/drm/radeon/radeon_connectors.c         |  2 +-
 drivers/gpu/drm/radeon/radeon_cs.c                 |  6 ++
 drivers/gpu/drm/vmwgfx/vmwgfx_fb.c                 |  1 -
 drivers/gpu/vga/vga_switcheroo.c                   |  3 +-
 drivers/hwmon/ina2xx.c                             |  7 +-
 drivers/iio/inkern.c                               |  6 +-
 drivers/irqchip/spear-shirq.c                      |  2 +-
 drivers/md/dm-thin.c                               |  3 +-
 drivers/md/md.c                                    | 13 ++++
 drivers/mmc/host/rtsx_pci_sdmmc.c                  |  3 +
 drivers/mtd/nand/fsl_elbc_nand.c                   | 14 ++++
 drivers/mtd/nand/omap2.c                           |  2 +-
 drivers/mtd/nand/pxa3xx_nand.c                     |  4 +-
 drivers/net/ethernet/allwinner/sun4i-emac.c        |  1 +
 drivers/net/ethernet/mellanox/mlx4/fw.c            |  2 +-
 drivers/net/wireless/b43/xmit.c                    | 10 ++-
 .../net/wireless/brcm80211/brcmfmac/sdio_chip.c    |  5 +-
 drivers/net/wireless/iwlwifi/pcie/trans.c          | 26 ++++---
 drivers/net/wireless/rt2x00/rt2500pci.c            |  7 +-
 drivers/net/wireless/rt2x00/rt2x00.h               |  1 +
 drivers/net/wireless/rt2x00/rt2x00dev.c            | 24 +++++-
 drivers/net/wireless/rt2x00/rt2x00mac.c            |  2 +
 drivers/scsi/ibmvscsi/ibmvscsi.c                   | 13 +++-
 drivers/scsi/scsi_error.c                          |  8 +-
 drivers/scsi/sym53c8xx_2/sym_hipd.c                |  4 +
 drivers/scsi/virtio_scsi.c                         | 26 ++++++-
 drivers/staging/iio/adc/ad7291.c                   |  4 +-
 drivers/tty/n_tty.c                                | 19 ++---
 drivers/tty/serial/8250/8250_core.c                |  2 +-
 drivers/tty/serial/altera_uart.c                   |  6 ++
 drivers/tty/serial/amba-pl010.c                    |  2 +-
 drivers/tty/serial/amba-pl011.c                    |  2 +-
 drivers/tty/serial/atmel_serial.c                  |  2 +-
 drivers/tty/serial/bcm63xx_uart.c                  |  2 +-
 drivers/tty/serial/bfin_uart.c                     |  2 +-
 drivers/tty/serial/dz.c                            |  2 +-
 drivers/tty/serial/efm32-uart.c                    |  2 +-
 drivers/tty/serial/fsl_lpuart.c                    |  2 +-
 drivers/tty/serial/ip22zilog.c                     |  2 +-
 drivers/tty/serial/m32r_sio.c                      |  2 +-
 drivers/tty/serial/max310x.c                       |  2 +-
 drivers/tty/serial/mcf.c                           |  6 ++
 drivers/tty/serial/mfd.c                           |  2 +-
 drivers/tty/serial/mpsc.c                          |  2 +-
 drivers/tty/serial/msm_serial.c                    |  2 +-
 drivers/tty/serial/mxs-auart.c                     |  2 +-
 drivers/tty/serial/netx-serial.c                   |  2 +-
 drivers/tty/serial/pmac_zilog.c                    |  2 +-
 drivers/tty/serial/pnx8xxx_uart.c                  |  2 +-
 drivers/tty/serial/pxa.c                           |  2 +-
 drivers/tty/serial/sb1250-duart.c                  |  2 +-
 drivers/tty/serial/sccnxp.c                        |  2 +-
 drivers/tty/serial/serial_ks8695.c                 |  2 +-
 drivers/tty/serial/serial_txx9.c                   |  2 +-
 drivers/tty/serial/sirfsoc_uart.c                  |  2 +-
 drivers/tty/serial/st-asc.c                        |  2 +-
 drivers/tty/serial/sunsab.c                        |  2 +-
 drivers/tty/serial/sunsu.c                         |  2 +-
 drivers/tty/serial/sunzilog.c                      |  2 +-
 drivers/tty/serial/ucc_uart.c                      |  2 +-
 drivers/tty/serial/vr41xx_siu.c                    |  2 +-
 drivers/tty/serial/zs.c                            |  2 +-
 drivers/usb/chipidea/udc.c                         |  7 ++
 drivers/usb/gadget/f_fs.c                          | 12 +--
 drivers/usb/host/xhci-ring.c                       |  9 ++-
 drivers/usb/host/xhci.c                            | 10 ++-
 drivers/usb/musb/musb_am335x.c                     | 23 ++----
 drivers/usb/musb/musb_cppi41.c                     |  2 +-
 drivers/usb/musb/ux500.c                           |  1 -
 drivers/usb/serial/ftdi_sio.c                      |  7 +-
 drivers/usb/serial/option.c                        | 26 +++++--
 drivers/video/fb-puv3.c                            |  2 +
 fs/aio.c                                           | 36 ++++++++-
 fs/cifs/cifs_unicode.c                             |  7 +-
 fs/cifs/link.c                                     |  2 +-
 fs/ext4/indirect.c                                 | 20 ++++-
 fs/nfsd/nfs4proc.c                                 |  9 ---
 fs/nfsd/nfs4xdr.c                                  | 13 +++-
 include/uapi/linux/usb/functionfs.h                |  7 ++
 kernel/auditsc.c                                   |  2 +-
 kernel/sysctl.c                                    |  3 +-
 kernel/trace/trace.c                               |  2 -
 mm/hugetlb.c                                       | 71 ++++++++++-------
 mm/memory.c                                        |  3 -
 mm/page_alloc.c                                    | 56 ++++++++++----
 mm/slab.c                                          | 89 +++++++++++++++++-----
 net/bluetooth/hci_conn.c                           |  2 +-
 net/bluetooth/hci_event.c                          | 11 ++-
 net/bluetooth/l2cap_sock.c                         |  5 --
 net/bluetooth/mgmt.c                               |  7 +-
 net/mac80211/debugfs_netdev.c                      |  6 +-
 net/mac80211/ibss.c                                |  1 +
 net/mac80211/sta_info.c                            |  1 +
 net/netfilter/nf_nat_core.c                        | 35 ++++++++-
 sound/usb/pcm.c                                    |  3 +-
 tools/usb/ffs-test.c                               |  4 +-
 125 files changed, 707 insertions(+), 303 deletions(-)


