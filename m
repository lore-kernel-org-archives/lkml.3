Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753513Ab3KOXXA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 18:23:00 -0500
Received: from cantor2.suse.de ([195.135.220.15]:32915 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751699Ab3KOXWv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 18:22:51 -0500
Date: Sat, 16 Nov 2013 00:22:43 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT] trivial
Message-ID: <alpine.LNX.2.00.1311160019490.6919@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull from

  git://git.kernel.org/pub/scm/linux/kernel/git/jikos/trivial.git for-linus

to receive 


- usual earth-shaking, news-breaking, rocket science pile from trivial.git



You are going to encounter this merge conflict:

	https://lkml.org/lkml/2013/10/15/425

The resolution is rather simple -- just replace any occurence of 
'indentified' in net/netfilter/xt_set.c by 'identified' :)

If you want me to prepare a branch with this conflict resolved, just let 
me know, I'll be happy to do that.

Thanks.



Anoop Thomas Mathew (1):
      doc: typo on word accounting in kprobes.c in mutliple architectures

Ezequiel Garcia (1):
      clk: fixed-factor: Fix a trivial typo

Geert Uytterhoeven (2):
      kexec: Typo s/the/then/
      mm/Kconfig: Grammar s/an/a/

Henrik Austad (2):
      mm: update 00-INDEX
      doc: add missing files to timers/00-INDEX

Jingoo Han (1):
      SCSI: remove unnecessary pci_set_drvdata()

LABBE Corentin (1):
      Correct some typos for word frequency

Masanari Iida (3):
      treewide: Fix typo in Kconfig
      treewide: Fix typo in printk
      doc: usb: Fix typo in Documentation/usb/gadget_configs.txt

Maxime Jayat (1):
      treewide: Fix common typo in "identify"

Michael Opdenacker (2):
      treewide: fix "distingush" typo
      treewide: fix "usefull" typo

Michael Witten (2):
      Docs: Kconfig: `devlopers' -> `developers'
      DRM: comment: `halve' -> `half'

Paul Gortmaker (1):
      NUMA: fix typos in Kconfig help text

Raghavendra K T (1):
      Documentation/kvm: Update cpuid documentation for steal time and pv eoi

Xie XiuQi (3):
      irq: Fix some trivial typos in comments
      mm: Fix some trivial typos in comments
      timekeeping: Fix some trivial typos in comments

Xishi Qiu (1):
      doc: Documentation/DMA-attributes.txt fix typo

Zhang Yanfei (1):
      __page_to_pfn: Fix typo in comment

 Documentation/DMA-attributes.txt                   |    6 +++---
 Documentation/timers/00-INDEX                      |    4 ++++
 Documentation/usb/gadget_configfs.txt              |    6 +++---
 Documentation/virtual/kvm/cpuid.txt                |    7 +++++++
 Documentation/vm/00-INDEX                          |   20 ++++++++++++--------
 arch/arc/kernel/kprobes.c                          |    2 +-
 arch/arm/mach-sti/Kconfig                          |    4 ++--
 arch/ia64/kernel/kprobes.c                         |    2 +-
 arch/m32r/include/asm/mmu_context.h                |    2 +-
 arch/mips/include/asm/octeon/cvmx-pip.h            |    4 ++--
 arch/mn10300/include/asm/mmu_context.h             |    2 +-
 arch/powerpc/kernel/kprobes.c                      |    2 +-
 arch/powerpc/platforms/pseries/nvram.c             |    2 +-
 arch/s390/kernel/kprobes.c                         |    2 +-
 arch/sh/include/asm/mmu_context.h                  |    2 +-
 arch/sparc/kernel/kprobes.c                        |    2 +-
 arch/x86/kernel/cpu/amd.c                          |    2 +-
 arch/x86/kernel/cpu/intel_cacheinfo.c              |    2 +-
 arch/x86/kernel/cpu/scattered.c                    |    2 +-
 drivers/acpi/acpica/utobject.c                     |    2 +-
 drivers/base/dma-contiguous.c                      |    2 +-
 drivers/clk/clk-fixed-factor.c                     |    2 +-
 drivers/cpufreq/Kconfig.x86                        |    2 +-
 drivers/cpufreq/exynos-cpufreq.c                   |    2 +-
 drivers/dma/Kconfig                                |    2 +-
 drivers/fmc/Kconfig                                |    2 +-
 drivers/gpu/drm/drm_irq.c                          |    4 ++--
 drivers/infiniband/ulp/isert/Kconfig               |    4 ++--
 drivers/input/serio/i8042.c                        |    2 +-
 drivers/md/raid5.h                                 |    2 +-
 drivers/media/i2c/Kconfig                          |    2 +-
 drivers/media/i2c/adv7183.c                        |    2 +-
 drivers/media/i2c/s5c73m3/s5c73m3-core.c           |    2 +-
 drivers/media/rc/keymaps/rc-dib0700-nec.c          |    2 +-
 drivers/media/rc/keymaps/rc-dib0700-rc5.c          |    2 +-
 drivers/mfd/Kconfig                                |    4 ++--
 drivers/mtd/nand/docg4.c                           |    2 +-
 drivers/net/ethernet/mellanox/mlx4/fw.c            |    2 +-
 .../net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c    |    2 +-
 drivers/net/irda/ali-ircc.c                        |    2 +-
 drivers/net/irda/nsc-ircc.c                        |    2 +-
 drivers/net/wireless/ath/ath10k/pci.c              |    2 +-
 drivers/net/wireless/ath/ath5k/dma.c               |    2 +-
 drivers/regulator/tps65910-regulator.c             |    2 +-
 drivers/s390/scsi/zfcp_dbf.c                       |    6 +++---
 drivers/scsi/arcmsr/arcmsr_hba.c                   |    1 -
 drivers/scsi/atp870u.c                             |    2 --
 drivers/scsi/bfa/bfad.c                            |    1 -
 drivers/scsi/bnx2i/bnx2i_hwi.c                     |   16 ++++++++--------
 drivers/scsi/bnx2i/bnx2i_iscsi.c                   |   14 +++++++-------
 drivers/scsi/csiostor/csio_init.c                  |    2 --
 drivers/scsi/dc395x.c                              |    1 -
 drivers/scsi/fnic/fnic_main.c                      |    1 -
 drivers/scsi/gdth.c                                |    2 --
 drivers/scsi/hpsa.c                                |    1 -
 drivers/scsi/lpfc/lpfc_init.c                      |    3 ---
 drivers/scsi/megaraid/megaraid_mbox.c              |    6 ------
 drivers/scsi/megaraid/megaraid_sas_base.c          |    5 -----
 drivers/scsi/mvsas/mv_init.c                       |    1 -
 drivers/scsi/mvsas/mv_sas.c                        |    2 +-
 drivers/scsi/mvumi.c                               |    2 --
 drivers/scsi/ncr53c8xx.c                           |    2 +-
 drivers/scsi/pm8001/pm8001_init.c                  |    1 -
 drivers/scsi/pmcraid.c                             |    1 -
 drivers/scsi/qla2xxx/qla_os.c                      |    1 -
 drivers/scsi/qla4xxx/ql4_os.c                      |    1 -
 drivers/scsi/stex.c                                |    2 --
 drivers/scsi/sym53c8xx_2/sym_glue.h                |    2 +-
 drivers/scsi/tmscsim.c                             |    1 -
 drivers/scsi/ufs/ufshcd-pci.c                      |    1 -
 drivers/scsi/vmw_pvscsi.c                          |    2 --
 drivers/staging/iio/adc/ad7606.h                   |    2 +-
 drivers/usb/core/Kconfig                           |    2 +-
 fs/btrfs/Kconfig                                   |    3 ++-
 include/asm-generic/memory_model.h                 |    2 +-
 include/linux/amba/serial.h                        |    2 +-
 include/linux/devfreq.h                            |    2 +-
 include/linux/mfd/si476x-core.h                    |    2 +-
 include/linux/netdevice.h                          |    2 +-
 include/net/bluetooth/l2cap.h                      |    2 +-
 init/Kconfig                                       |    4 ++--
 kernel/irq/chip.c                                  |    2 +-
 kernel/irq/manage.c                                |    2 +-
 kernel/kexec.c                                     |    2 +-
 kernel/time/timekeeping.c                          |    3 ++-
 mm/Kconfig                                         |    2 +-
 mm/slub.c                                          |    2 +-
 net/can/af_can.c                                   |    2 +-
 net/netfilter/xt_set.c                             |    4 ++--
 net/vmw_vsock/Kconfig                              |    2 +-
 sound/soc/codecs/alc5632.c                         |    2 +-
 91 files changed, 118 insertions(+), 139 deletions(-)

-- 
Jiri Kosina
SUSE Labs
