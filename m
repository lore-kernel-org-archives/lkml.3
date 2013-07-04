Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755320Ab3GDN05 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 09:26:57 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46844 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752996Ab3GDN0z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 09:26:55 -0400
Date: Thu, 4 Jul 2013 15:26:51 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT] trivial
Message-ID: <alpine.LNX.2.00.1307041506510.26857@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull from

  git://git.kernel.org/pub/scm/linux/kernel/git/jikos/trivial.git for-linus

to receive usual stuff from trivial tree.

You are going to get trivial conflict in kerneldoc comment in 
kernel/irq/generic-chip.c (with ccc414f8 from your tree). Suggested 
resolution is just taking the version from your tree, discarding what 
comes from trivial.git.

Thanks.

Aaro Koskinen (1):
      Documentation/cgroups/memory.txt: fix stat file documentation

Anatol Pomozov (1):
      doc: fix misspellings with 'codespell' tool

Chen Gang (1):
      spinlock_api_smp.h: fix preprocessor comments

Geert Uytterhoeven (2):
      scsi: Spelling hsot -> host
      treewide: relase -> release

Joe Perches (2):
      sgi: xpc: Convert use of typedef ctl_table to struct ctl_table
      frv: Convert use of typedef ctl_table to struct ctl_table

Masanari Iida (2):
      treewide: Fix typo in printk
      treewide: Fix typo in printk

Paul Bolle (4):
      rcu: Fix Documentation typo 'CONFIG_RCU_NOCB_CPUS'
      exynos4-is: Fix Kconfig comment
      Fix warning typo "CONFIG_RELCOATABLE"
      lguest: fix CONFIG_PAE -> CONFIG_x86_PAE in comment

Paul Gortmaker (1):
      sysctl/net.txt: delete reference to obsolete 2.4.x kernel

Phil Viana (1):
      md: bcache: Fixed a typo with the word 'arithmetic'

Robert P. J. Day (4):
      kernel-doc: Update references to SGML to refs to XML instead.
      include/linux/cpu.h: Update comments to reflect reality
      open firmware: "/aliasas" -> "/aliases"
      doc: device tree: clarify stuff in usage-model.txt.

Sachin Kamat (1):
      doc: clk: Fix incorrect wording

Stefan Behrens (1):
      btrfs: fix btrfs_extend_item() comment

Stefan Huber (7):
      Documentation/video4linux/soc-camera.txt fix a typo
      Documentation/early-userspace/README fix a typo
      Documentation/virtual/kvm/api.txt fix a typo
      Documentation/video4linux/si476x.txt fix a typo
      Documentation/DocBook/media/v4l fix a typo
      Documentation/networking/ieee802154 fix a typo
      Documentation/arm/IXP4xx fix a typo

Steven Rostedt (2):
      tracing: Put trace_puts() comment above trace_puts() macro for kernel doc
      sprintf: hex_string(): fix comment

Thorsten Glaser (1):
      update AMD powerflags comments

Uwe Kleine-König (1):
      irq/generic-chip: fix a few kernel-doc entries

Zhang Yanfei (2):
      mm/sparse: Remove unused ret in sparse_index_init
      Documentation/kdump: Remove TODO in this document

 Documentation/DocBook/drm.tmpl                     |    6 +++---
 Documentation/DocBook/media/dvb/frontend.xml       |    2 +-
 Documentation/DocBook/media/v4l/controls.xml       |    2 +-
 Documentation/DocBook/media/v4l/pixfmt-nv12mt.xml  |    2 +-
 Documentation/DocBook/writing_usb_driver.tmpl      |    2 +-
 Documentation/arm/IXP4xx                           |    2 +-
 Documentation/bcache.txt                           |   10 +++++-----
 Documentation/block/queue-sysfs.txt                |    2 +-
 Documentation/cgroups/memory.txt                   |    6 +++---
 Documentation/clk.txt                              |    2 +-
 Documentation/device-mapper/cache.txt              |    2 +-
 .../bindings/arm/samsung/interrupt-combiner.txt    |    6 +++---
 .../devicetree/bindings/arm/spear/shirq.txt        |    2 +-
 .../devicetree/bindings/clock/silabs,si5351.txt    |    2 +-
 .../devicetree/bindings/mmc/synopsis-dw-mshc.txt   |    2 +-
 .../devicetree/bindings/powerpc/4xx/emac.txt       |    2 +-
 .../devicetree/bindings/spi/brcm,bcm2835-spi.txt   |    2 +-
 .../bindings/timer/samsung,exynos4210-mct.txt      |    2 +-
 .../devicetree/bindings/usb/am33xx-usb.txt         |    2 +-
 Documentation/devicetree/bindings/usb/omap-usb.txt |    2 +-
 Documentation/devicetree/usage-model.txt           |   11 ++++++-----
 Documentation/dynamic-debug-howto.txt              |    2 +-
 Documentation/early-userspace/README               |    2 +-
 Documentation/fb/cirrusfb.txt                      |    2 +-
 Documentation/filesystems/jfs.txt                  |    2 +-
 Documentation/filesystems/qnx6.txt                 |    2 +-
 Documentation/filesystems/vfat.txt                 |    2 +-
 Documentation/kdump/kdump.txt                      |    8 --------
 Documentation/kernel-doc-nano-HOWTO.txt            |   11 ++++++-----
 Documentation/kernel-per-CPU-kthreads.txt          |    2 +-
 Documentation/laptops/dslm.c                       |    2 +-
 Documentation/media-framework.txt                  |    2 +-
 Documentation/metag/kernel-ABI.txt                 |    2 +-
 Documentation/misc-devices/mei/mei.txt             |    2 +-
 Documentation/networking/ieee802154.txt            |    2 +-
 Documentation/networking/ip-sysctl.txt             |    2 +-
 Documentation/networking/netlink_mmap.txt          |   12 ++++++------
 Documentation/pinctrl.txt                          |    2 +-
 Documentation/sysctl/net.txt                       |    6 +++---
 Documentation/thermal/exynos_thermal_emulation     |    2 +-
 Documentation/video4linux/si476x.txt               |    2 +-
 Documentation/video4linux/soc-camera.txt           |    2 +-
 Documentation/virtual/kvm/api.txt                  |    8 ++++----
 Documentation/vm/pagemap.txt                       |    2 +-
 Documentation/w1/slaves/w1_ds28e04                 |    2 +-
 Makefile                                           |    2 +-
 arch/frv/kernel/pm.c                               |    8 ++++----
 arch/frv/kernel/sysctl.c                           |    4 ++--
 arch/powerpc/relocs_check.pl                       |   10 +++++-----
 arch/x86/kernel/cpu/powerflags.c                   |    8 ++++----
 drivers/cpufreq/s3c2416-cpufreq.c                  |    2 +-
 drivers/gpu/drm/drm_fb_cma_helper.c                |    4 ++--
 drivers/gpu/drm/radeon/radeon_fb.c                 |    2 +-
 drivers/infiniband/ulp/isert/ib_isert.c            |    2 +-
 drivers/input/misc/da9055_onkey.c                  |    2 +-
 drivers/lguest/page_tables.c                       |    2 +-
 drivers/md/bcache/bset.c                           |    4 ++--
 drivers/media/dvb-frontends/stv0367.c              |    2 +-
 drivers/media/platform/exynos4-is/Kconfig          |    2 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c       |    2 +-
 drivers/misc/dummy-irq.c                           |    2 +-
 drivers/misc/lattice-ecp3-config.c                 |    2 +-
 drivers/misc/mei/hbm.c                             |    2 +-
 drivers/misc/mei/init.c                            |    2 +-
 drivers/misc/sgi-xp/xpc_main.c                     |    6 +++---
 drivers/net/ethernet/intel/igb/e1000_phy.c         |    2 +-
 drivers/net/ethernet/mellanox/mlx4/main.c          |    2 +-
 drivers/net/ethernet/neterion/vxge/vxge-main.c     |    2 +-
 .../ethernet/qlogic/qlcnic/qlcnic_sriov_common.c   |    2 +-
 drivers/net/wireless/ath/ath9k/Kconfig             |    2 +-
 drivers/nfc/pn533.c                                |    2 +-
 drivers/of/fdt.c                                   |    2 +-
 drivers/of/pdt.c                                   |    2 +-
 drivers/s390/char/vmur.c                           |    2 +-
 drivers/scsi/aic7xxx_old/aic7xxx.seq               |    2 +-
 drivers/scsi/libfc/fc_fcp.c                        |    2 +-
 drivers/scsi/libiscsi_tcp.c                        |    2 +-
 drivers/scsi/pm8001/pm80xx_hwi.c                   |    2 +-
 drivers/scsi/pmcraid.c                             |    2 +-
 drivers/scsi/scsi_error.c                          |    2 +-
 drivers/tty/serial/serial-tegra.c                  |    2 +-
 drivers/usb/musb/musb_dsps.c                       |    2 +-
 drivers/usb/musb/omap2430.c                        |    2 +-
 drivers/video/omap2/displays/panel-n8x0.c          |    2 +-
 fs/btrfs/ctree.c                                   |    2 +-
 fs/btrfs/free-space-cache.c                        |    2 +-
 include/linux/cpu.h                                |    3 +--
 include/linux/kernel.h                             |    5 ++---
 include/linux/spinlock_api_smp.h                   |    2 +-
 kernel/irq/generic-chip.c                          |    6 +++---
 lib/Kconfig.kgdb                                   |    4 ++--
 lib/vsprintf.c                                     |    2 +-
 mm/mmu_notifier.c                                  |    2 +-
 mm/sparse.c                                        |    3 +--
 sound/pci/hda/hda_codec.c                          |    2 +-
 tools/testing/ktest/ktest.pl                       |    2 +-
 96 files changed, 144 insertions(+), 153 deletions(-)

-- 
Jiri Kosina
SUSE Labs
