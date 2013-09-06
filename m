Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751496Ab3IFMAu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 08:00:50 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52269 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751110Ab3IFMAs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 08:00:48 -0400
Date: Fri, 6 Sep 2013 14:00:45 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT] trivial for 3.12 merge window
Message-ID: <alpine.LNX.2.00.1309061224020.26934@pobox.suse.cz>
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

to receive usual trivial updates all over the tree -- mostly typo fixes 
and documentation updates.

You are going to receive three very simple merge conflicts ... if you want 
me to prepare a branch with those fixed up, just let me know. Thanks.


Bernhard M. Wiedemann (1):
      zram: doc fixes

Chen Gang (1):
      include/linux/coda.h: remove useless '#else'

Chris Cheney (1):
      credits: update contact information for Chris Cheney

Cristian Stoica (1):
      crypto: fix typo in comment

Daniel Borkmann (1):
      doc: printk-formats: fix format specifier to %p[Ii]4[hnbl]

Geert Uytterhoeven (2):
      Documentation/SubmittingPatches: Request summaries for commit references
      Documentation/printk-formats.txt: No casts needed for u64/s64

Hu Tao (1):
      doc: fix a typo about irq affinity

Jens Frederich (1):
      power: Documentation: Update s2ram link

Jingoo Han (1):
      Documentation: replace strict_strtoul() with kstrtoul()

Jiri Kosina (1):
      Merge branch 'master' into for-next

Joe Perches (4):
      docproc: Move printk file location
      treewide: Add __GFP_NOWARN to k.alloc calls with v.alloc fallbacks
      treewide: Fix printks with 0x%#
      treewide: Convert retrun typos to return

Li Zhong (1):
      Fix comment typo for init_cma_reserved_pageblock

Libin (1):
      Documentation/kmemcheck: update kmemcheck documentation

Martin Nordholts (1):
      Documentation: development-process: Update -mm and -next URLs

Masanari Iida (5):
      doc: devicetree: bindings: Fix typo in bindings
      doc: Fix typo in doucmentations
      treewide: Fix typo in printk
      doc: filesystems : Fix typo in Documentations/filesystems
      doc: Fix typo "is is" in Documentations

Matthias Schid (1):
      scsi/megaraid fixed several typos in comments

Michael Witten (1):
      Docs: Comment: Fixed egregious typos

Murilo Opsfelder Araujo (1):
      doc: fix a typo in Documentation/00-INDEX

Oleksandr Kravchenko (1):
      Documentation: devres: add IIO device alloc/free functions to list

Paul Bolle (1):
      ppc: init_32: Fix error typo "CONFIG_START_KERNEL"

Paul Gortmaker (2):
      Documentation: fix typo and update version in cachetlb.txt
      Documentation: remove reference to 2.7 kernel in early-userspace

Sachin Kamat (4):
      Documentation: clk: Fix a trivial typo in audss
      Documentation: leds: Fix a typo
      Documentation: pinctrl: Fix example code
      spi/documentation: Fix usage of __initdata

Sebastian Capella (1):
      PM / Hibernate: add section for resume options

Stefan Huber (10):
      Documentation/devicetree/bindings/net/can/ fix a typo
      Documentation/devicetree/bindings/clock/ fix a typo
      Documentation/hwmon/abituguru-datasheet fix a typo
      Documentation/acpi/enumeration.txt fix a typo
      Documentation/sound/alsa/ fix a typo
      Documentation/fb/viafb.modes fix a typo
      Documentation/scsi/hptiop.txt fix a typo
      Documentation/devicetree/bindings/c6x/ fix a typo
      Documentation/zh_CN/SubmittingPatches fix a typo
      Documentation/devicetree/bindings/serial/ fix a typo

Tang Chen (1):
      page_isolation: Fix a comment typo in test_pages_isolated()

Uwe Kleine-König (1):
      spi/bitbang: trivial: fix doubled word "use"

Xishi Qiu (3):
      doc: documentation/hwspinlock.txt fix typo
      mm/hotplug: fix a typo in Documentation/memory-hotplug.txt
      doc: Documentation/cputopology.txt fix typo

Yacine Belkadi (2):
      ktime: fix some scripts/kernel-doc warnings
      workqueue: fix some scripts/kernel-doc warnings

Zoltan Kiss (1):
      Documentation/trace: Correcting and extending tracepoint documentation

 CREDITS                                            |   11 +-
 Documentation/00-INDEX                             |    2 +-
 Documentation/ABI/testing/sysfs-block-zram         |    9 +-
 Documentation/DocBook/device-drivers.tmpl          |    2 +-
 Documentation/DocBook/media/v4l/vidioc-g-parm.xml  |    4 +-
 Documentation/IRQ-affinity.txt                     |    4 +-
 Documentation/SubmittingPatches                    |   10 ++
 Documentation/acpi/enumeration.txt                 |    2 +-
 Documentation/arm/OMAP/omap_pm                     |    2 +-
 Documentation/block/cfq-iosched.txt                |    2 +-
 Documentation/cachetlb.txt                         |    6 +-
 Documentation/cputopology.txt                      |    2 +-
 Documentation/development-process/2.Process        |    4 +-
 Documentation/devicetree/bindings/arm/ste-u300.txt |    2 +-
 .../devicetree/bindings/arm/vexpress-sysreg.txt    |    4 +-
 Documentation/devicetree/bindings/c6x/dscr.txt     |    2 +-
 .../devicetree/bindings/clock/clk-exynos-audss.txt |    2 +-
 .../devicetree/bindings/clock/st,nomadik.txt       |    2 +-
 .../devicetree/bindings/dma/atmel-dma.txt          |    4 +-
 .../devicetree/bindings/dma/fsl-imx-dma.txt        |    2 +-
 .../devicetree/bindings/dma/ste-dma40.txt          |    4 +-
 Documentation/devicetree/bindings/mfd/cros-ec.txt  |    2 +-
 .../devicetree/bindings/net/can/atmel-can.txt      |    2 +-
 .../bindings/pinctrl/atmel,at91-pinctrl.txt        |    2 +-
 Documentation/devicetree/bindings/serial/rs485.txt |    2 +-
 Documentation/dma-buf-sharing.txt                  |    2 +-
 Documentation/driver-model/devres.txt              |    4 +
 Documentation/early-userspace/README               |    3 +-
 Documentation/fb/fbcon.txt                         |    2 +-
 Documentation/fb/viafb.modes                       |    2 +-
 Documentation/fb/viafb.txt                         |    2 +-
 Documentation/filesystems/btrfs.txt                |    2 +-
 Documentation/filesystems/ext4.txt                 |    2 +-
 Documentation/filesystems/nfs/Exporting            |    2 +-
 Documentation/filesystems/nfs/pnfs.txt             |    2 +-
 Documentation/filesystems/qnx6.txt                 |    2 +-
 Documentation/filesystems/relay.txt                |    2 +-
 Documentation/filesystems/sysfs-tagging.txt        |    2 +-
 Documentation/filesystems/xfs.txt                  |    2 +-
 Documentation/fmc/carrier.txt                      |    2 +-
 Documentation/hwmon/abituguru-datasheet            |    2 +-
 Documentation/hwmon/submitting-patches             |    2 +-
 Documentation/hwspinlock.txt                       |    2 +-
 Documentation/i2c/upgrading-clients                |    4 +-
 Documentation/kmemcheck.txt                        |    6 +-
 Documentation/leds/leds-lm3556.txt                 |    2 +-
 Documentation/leds/leds-lp3944.txt                 |    2 +-
 Documentation/memory-hotplug.txt                   |    2 +-
 Documentation/mtd/nand_ecc.txt                     |    2 +-
 Documentation/pinctrl.txt                          |    8 +-
 Documentation/power/basic-pm-debugging.txt         |   10 +-
 Documentation/power/swsusp.txt                     |   15 +++-
 Documentation/printk-formats.txt                   |    6 +-
 Documentation/rapidio/rapidio.txt                  |    2 +-
 Documentation/scsi/hptiop.txt                      |    2 +-
 Documentation/sound/alsa/README.maya44             |    2 +-
 Documentation/sound/alsa/compress_offload.txt      |    4 +-
 Documentation/spi/spi-summary                      |    2 +-
 Documentation/sysfs-rules.txt                      |    2 +-
 Documentation/target/tcm_mod_builder.py            |    2 +-
 Documentation/trace/ftrace.txt                     |    4 +-
 Documentation/trace/tracepoints.txt                |   19 +++-
 Documentation/virtual/kvm/api.txt                  |    2 +-
 Documentation/x86/boot.txt                         |    2 +-
 Documentation/zh_CN/SubmittingPatches              |    2 +-
 arch/parisc/kernel/signal.c                        |    2 +-
 arch/powerpc/mm/init_32.c                          |    2 +-
 crypto/api.c                                       |    2 +-
 drivers/block/drbd/drbd_bitmap.c                   |    2 +-
 drivers/clocksource/acpi_pm.c                      |    4 +-
 drivers/crypto/ux500/hash/hash_core.c              |    2 +-
 drivers/gpu/drm/radeon/r300.c                      |    2 +-
 drivers/infiniband/hw/ehca/ipz_pt_fn.c             |    3 +-
 drivers/media/usb/gspca/vicam.c                    |    2 +-
 drivers/net/ethernet/chelsio/cxgb3/cxgb3_offload.c |    2 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c    |    2 +-
 .../net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c    |    4 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c     |    2 +-
 drivers/net/ethernet/sis/sis900.c                  |    2 +-
 drivers/net/wireless/cw1200/wsm.c                  |    2 +-
 drivers/net/wireless/iwlwifi/mvm/time-event.c      |    2 +-
 drivers/net/wireless/rtlwifi/rtl8188ee/fw.c        |    4 +-
 drivers/net/wireless/rtlwifi/rtl8192de/dm.c        |    2 +-
 drivers/net/wireless/rtlwifi/rtl8723ae/fw.c        |    4 +-
 drivers/power/88pm860x_charger.c                   |    4 +-
 drivers/power/pm2301_charger.c                     |    2 +-
 drivers/scsi/bfa/bfad_im.c                         |    2 +-
 drivers/scsi/cxgbi/libcxgbi.h                      |    8 +-
 drivers/scsi/hpsa.c                                |    2 +-
 drivers/scsi/lpfc/lpfc_attr.c                      |    8 +-
 drivers/scsi/lpfc/lpfc_bsg.c                       |    2 +-
 drivers/scsi/megaraid/megaraid_mbox.c              |   10 +-
 drivers/scsi/megaraid/megaraid_mm.c                |    2 +-
 drivers/scsi/megaraid/megaraid_sas_fusion.h        |    2 +-
 drivers/scsi/qla2xxx/qla_bsg.c                     |    2 +-
 drivers/scsi/qla2xxx/qla_mr.c                      |    2 +-
 drivers/spi/spi-bitbang.c                          |    2 +-
 drivers/tty/serial/kgdboc.c                        |    2 +-
 fs/btrfs/send.c                                    |    2 +-
 fs/ext4/super.c                                    |    4 +-
 fs/gfs2/dir.c                                      |    2 +-
 include/linux/coda.h                               |    1 -
 include/linux/ktime.h                              |   28 +++---
 kernel/workqueue.c                                 |  107 ++++++++++++--------
 mm/memory-failure.c                                |    2 +-
 mm/page_alloc.c                                    |    2 +-
 mm/page_isolation.c                                |    8 +-
 net/sched/sch_choke.c                              |    3 +-
 sound/pci/ens1370.c                                |    2 +-
 sound/pci/via82xx.c                                |    2 +-
 110 files changed, 280 insertions(+), 211 deletions(-)

-- 
Jiri Kosina
SUSE Labs
