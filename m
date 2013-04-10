Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937006Ab3DJWrG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 18:47:06 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56017 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759912Ab3DJWrD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 18:47:03 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: [ 00/64] 3.8.7-stable review
Date: Wed, 10 Apr 2013 15:45:57 -0700
Message-Id: <20130410224333.114387235@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
User-Agent: quilt/0.60-5.1.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.8.7 release.
There are 64 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri Apr 12 22:41:50 UTC 2013.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.8.7-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.8.7-rc1

Tim Gardner <tim.gardner@canonical.com>
    rt2x00: rt2x00pci_regbusy_read() - only print register access failure once

Bing Zhao <bzhao@marvell.com>
    mwifiex: complete last internal scan

Wei Yongjun <yongjun_wei@trendmicro.com.cn>
    can: gw: use kmem_cache_free() instead of kfree()

Trond Myklebust <Trond.Myklebust@netapp.com>
    NFSv4: Doh! Typo in the fix to nfs41_walk_client_list

Alex Williamson <alex.williamson@redhat.com>
    vfio-pci: Fix possible integer overflow

hayeswang <hayeswang@realtek.com>
    r8169: fix auto speed down issue

Jani Nikula <jani.nikula@intel.com>
    drm/i915: add quirk to invert brightness on Packard Bell NCL20

Jani Nikula <jani.nikula@intel.com>
    drm/i915: add quirk to invert brightness on eMachines e725

Jani Nikula <jani.nikula@intel.com>
    drm/i915: add quirk to invert brightness on eMachines G725

Thomas Abraham <thomas.ab@samsung.com>
    ARM: EXYNOS: Fix crash on soft reset on EXYNOS5440

Jonghwan Choi <jhbird.choi@samsung.com>
    cpufreq: exynos: Get booting freq value in exynos_cpufreq_init

Maxim Mikityanskiy <maxtram95@gmail.com>
    msi-wmi: Fix memory leak

Richard Guy Briggs <rbriggs@redhat.com>
    thermal: return an error on failure to register thermal class

Bjorn Helgaas <bhelgaas@google.com>
    Revert "PCI/ACPI: Request _OSC control before scanning PCI root bus"

Jan Beulich <JBeulich@suse.com>
    x86: Fix rebuild with EFI_STUB enabled

Lauri Kasanen <cand@gmx.com>
    drm/i915: Fix build failure

Trond Myklebust <Trond.Myklebust@netapp.com>
    NFSv4/4.1: Fix bugs in nfs4[01]_walk_client_list

Trond Myklebust <Trond.Myklebust@netapp.com>
    NFSv4: Fix a memory leak in nfs4_discover_server_trunking

Chuck Lever <chuck.lever@oracle.com>
    SUNRPC: Remove extra xprt_put()

Arnd Bergmann <arnd@arndb.de>
    block: avoid using uninitialized value in from queue_var_store

Christopher Harvey <charvey@matrox.com>
    drm/mgag200: Index 24 in extended CRTC registers is 24 in hex, not decimal.

Jussi Kivilinna <jussi.kivilinna@iki.fi>
    crypto: gcm - fix assumption that assoc has one segment

Linus Walleij <linus.walleij@linaro.org>
    crypto: ux500 - add missing comma

Linus Torvalds <torvalds@linux-foundation.org>
    spinlocks and preemption points need to be at least compiler barriers

Robert Tivy <rtivy@ti.com>
    remoteproc: fix FW_CONFIG typo

Sjur Brændeland <sjur.brandeland@stericsson.com>
    remoteproc: fix error path of handle_vdev

Dmitry Tarnyagin <dmitry.tarnyagin@stericsson.com>
    remoteproc/ste: fix memory leak on shutdown

Li Fei <fei.li@intel.com>
    hwspinlock: fix __hwspin_lock_request error path

Paul Moore <pmoore@redhat.com>
    x86: remove the x32 syscall bitmask from syscall_get_nr()

Johannes Berg <johannes.berg@intel.com>
    mac80211: fix remain-on-channel cancel crash

Stone Piao <piaoyun@marvell.com>
    mwifiex: limit channel number not to overflow memory

Michael Wolf <mjw@linux.vnet.ibm.com>
    powerpc: pSeries_lpar_hpte_remove fails from Adjunct partition being performed before the ANDCOND test

Jan Kiszka <jan.kiszka@siemens.com>
    ftrace: Consistently restore trace function on sysctl enabling

Youquan Song <youquan.song@intel.com>
    ata_piix: Fix DVD not dectected at some Haswell platforms

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    PCI/PM: Disable runtime PM of PCIe ports

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    PCI/ACPI: Always resume devices on ACPI wakeup notifications

Jay Estabrook <jay.estabrook@gmail.com>
    alpha: Add irongate_io to PCI bus resources

David Daney <david.daney@cavium.com>
    MIPS: Unbreak function tracer for 64-bit kernel.

David Woodhouse <dwmw2@infradead.org>
    libata: fix DMA to stack in reading devslp_timing parameters

Shan Hai <shan.hai@windriver.com>
    libata: Set max sector to 65535 for Slimtype DVD A DS8A8SH drive

Shan Hai <shan.hai@windriver.com>
    libata: Use integer return value for atapi_command_packet_set

Jakub Kicinski <jakub.kicinski@intel.com>
    ixgbe: fix registration order of driver and DCA nofitication

Yinghai Lu <yinghai@kernel.org>
    EISA/PCI: Fix bus res reference

Yinghai Lu <yinghai@kernel.org>
    EISA/PCI: Init EISA early, before PNP

Jan Stancek <jstancek@redhat.com>
    mm: prevent mmap_cache race in find_vma()

Johan Hovold <jhovold@gmail.com>
    Revert "drivers/rtc/rtc-at91rm9200.c: use a variable for storing IMR"

Ilija Hadzic <ihadzic@research.bell-labs.com>
    drm: correctly restore mappings if drm_open fails

Adam Jackson <ajax@redhat.com>
    drm/i915: Be sure to turn hsync/vsync back on at crt enable (v2)

Maarten Lankhorst <maarten.lankhorst@canonical.com>
    drm/nouveau: fix handling empty channel list in ioctl's

David Henningsson <david.henningsson@canonical.com>
    ALSA: hda - fix typo in proc output

Rainer Koenig <Rainer.Koenig@ts.fujitsu.com>
    ALSA: hda - Enabling Realtek ALC 671 codec

Mengdong Lin <mengdong.lin@intel.com>
    ALSA: hda - bug fix on return value when getting HDMI ELD info

Jan Kara <jack@suse.cz>
    reiserfs: Fix warning and inode leak when deleting inode with xattrs

Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
    UBIFS: make space fixup work in the remount case

Gabriel Fernandez <gabriel.fernandez@stericsson.com>
    gpio: stmpe: pass DT node to irqdomain

Anatolij Gustschin <agust@denx.de>
    spi/mpc512x-psc: optionally keep PSC SS asserted across xfer segmensts

Girish K S <girishks2000@gmail.com>
    spi/s3c64xx: modified error interrupt handling and init

Benjamin Tissoires <benjamin.tissoires@redhat.com>
    HID: magicmouse: fix race between input_register() and probe()

David Daney <david.daney@cavium.com>
    MIPS: Fix logic errors in bitops.c

Lars-Peter Clausen <lars@metafoo.de>
    regmap: cache Fix regcache-rbtree sync

Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
    regmap: Initialize `map->debugfs' before regcache

Lars-Peter Clausen <lars@metafoo.de>
    ASoC: spear_pcm: Update to new pcm_new() API

Lars-Peter Clausen <lars@metafoo.de>
    ASoC: dma-sh7760: Fix compile error

Sascha Hauer <s.hauer@pengutronix.de>
    ASoC: imx-ssi: Fix occasional AC97 reset failure


-------------

Diffstat:

 Makefile                                      |   4 +-
 arch/alpha/kernel/sys_nautilus.c              |   5 ++
 arch/arm/mach-exynos/common.c                 |   6 +-
 arch/mips/kernel/mcount.S                     |  11 ++-
 arch/mips/lib/bitops.c                        |  16 ++--
 arch/powerpc/platforms/pseries/lpar.c         |   8 +-
 arch/x86/boot/compressed/Makefile             |   5 +-
 arch/x86/include/asm/syscall.h                |   4 +-
 block/blk-sysfs.c                             |   2 +
 crypto/gcm.c                                  |  17 +++-
 drivers/acpi/pci_root.c                       | 121 +++++++++++++-------------
 drivers/ata/ata_piix.c                        |  14 ++-
 drivers/ata/libata-core.c                     |   6 +-
 drivers/base/regmap/regcache-rbtree.c         |   2 +-
 drivers/base/regmap/regmap.c                  |   4 +-
 drivers/cpufreq/exynos-cpufreq.c              |   4 +-
 drivers/crypto/ux500/cryp/cryp_core.c         |   2 +-
 drivers/eisa/pci_eisa.c                       |  67 +++++++++-----
 drivers/gpio/gpio-stmpe.c                     |  15 +++-
 drivers/gpu/drm/drm_fops.c                    |   6 +-
 drivers/gpu/drm/i915/i915_gem_execbuffer.c    |   2 +-
 drivers/gpu/drm/i915/intel_crt.c              |  40 ++++-----
 drivers/gpu/drm/i915/intel_display.c          |   9 ++
 drivers/gpu/drm/mgag200/mgag200_mode.c        |  13 +--
 drivers/gpu/drm/nouveau/nouveau_abi16.c       |  18 ++--
 drivers/hid/hid-magicmouse.c                  |  29 ++++--
 drivers/hwspinlock/hwspinlock_core.c          |   2 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c |  11 ++-
 drivers/net/ethernet/realtek/r8169.c          |  28 +++++-
 drivers/net/wireless/mwifiex/cfg80211.c       |   3 +-
 drivers/net/wireless/mwifiex/scan.c           |  11 ++-
 drivers/net/wireless/rt2x00/rt2x00pci.c       |   4 +-
 drivers/pci/pci-acpi.c                        |  15 ++--
 drivers/pci/pcie/portdrv_pci.c                |  13 ---
 drivers/platform/x86/msi-wmi.c                |   4 +-
 drivers/remoteproc/Kconfig                    |   2 +-
 drivers/remoteproc/remoteproc_core.c          |   4 +-
 drivers/remoteproc/ste_modem_rproc.c          |   7 +-
 drivers/rtc/rtc-at91rm9200.c                  |  50 ++++-------
 drivers/rtc/rtc-at91rm9200.h                  |   1 +
 drivers/spi/spi-mpc512x-psc.c                 |   2 +-
 drivers/spi/spi-s3c64xx.c                     |  41 +++++----
 drivers/thermal/thermal_sys.c                 |   1 +
 drivers/vfio/pci/vfio_pci.c                   |   3 +-
 fs/nfs/nfs4client.c                           |  45 ++++++----
 fs/nfs/nfs4state.c                            |   8 +-
 fs/reiserfs/xattr.c                           |   4 +-
 fs/ubifs/super.c                              |  12 +--
 include/linux/ata.h                           |   2 +-
 include/linux/libata.h                        |   1 +
 include/linux/preempt.h                       |  22 +++--
 include/linux/spinlock_up.h                   |  29 +++---
 kernel/trace/ftrace.c                         |   8 +-
 mm/mmap.c                                     |   2 +-
 mm/nommu.c                                    |   2 +-
 net/can/gw.c                                  |   6 +-
 net/mac80211/cfg.c                            |   6 +-
 net/mac80211/ieee80211_i.h                    |   3 +-
 net/mac80211/offchannel.c                     |  23 +++--
 net/sunrpc/clnt.c                             |   4 +-
 sound/pci/hda/hda_codec.c                     |   2 +-
 sound/pci/hda/hda_eld.c                       |   2 +-
 sound/pci/hda/patch_realtek.c                 |   4 +-
 sound/soc/fsl/imx-ssi.c                       |   5 ++
 sound/soc/sh/dma-sh7760.c                     |   4 +-
 sound/soc/spear/spear_pcm.c                   |  12 +--
 66 files changed, 503 insertions(+), 335 deletions(-)


