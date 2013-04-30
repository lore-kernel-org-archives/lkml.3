Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759596Ab3D3Ibz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 04:31:55 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54622 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759465Ab3D3Ibt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 04:31:49 -0400
Date: Tue, 30 Apr 2013 10:31:46 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT] trivial
Message-ID: <alpine.LNX.2.00.1304300953530.20139@pobox.suse.cz>
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

to receive 3.10 merge window updates from trivial queue.


==
Usual stuff, mostly comment fixes, typo fixes, printk fixes and small code 
cleanups.
==


You are going to get two conflicts:

drivers/clk/mvebu/clk-core.c: conflict between 07f42258893d and 
4cb24e68a5af (change of '>' to '>=' in the condition).

drivers/misc/mei/interrupt.c: conflict between 393b148f9d0 and 
4c6e22b8a93; the function has been renamed and the comment updated 
accordingly, so the hunk coming from 393b148f9d0 could be just discarded.

Both conflicts are trivial to solve, but if you want me to prepare a 
branch with this resolved for you to pull, please let me know.

Thanks.




Chen Gang (1):
      drivers/isdn: delete 'break' after 'return'

Claudiu Ghioc (1):
      hugetlb: fix sparse warning for hugetlb_register_node

Cody P Schafer (1):
      mmzone: correct "pags" to "pages" in comment.

David P Hilton (1):
      iostats.txt: add easy-to-find description for field 6

Joe Perches (3):
      m32r: Convert print_symbol to %pSR
      gfs2: Convert print_symbol to %pSR
      mm: Convert print_symbol to %pSR

Li Zhong (1):
      x86 cmpxchg.h: fix wrong comment

Marek Belisko (1):
      arm: irq-armada-370-xp: fix comment typo

Masanari Iida (10):
      doc: virtual: Fix typos in virtio-spec.txt
      treewide: Fix typos in printk and comment
      f2fs: Fix typo in comments
      treewide: Fix typos in printk
      doc: DocBook/media : Fix typo in dvbproperty.xml
      treewide: Fix typos in kernel messages
      mei: Fix comments in drivers/misc/mei
      treewide: Fix typo in printks
      doc: devicetree: Fix various typos
      treewide: Fix typo in printk and comments

Michel Lespinasse (1):
      gitignore: ignore generated hz.bc file

Paul Bolle (12):
      sfc: Fix Kconfig typo "----help---"
      itg3200: fix incorrect ifdef comment
      arc: fix incorrect ifdef comment
      doc: Remove text on tracepoint samples
      irq: versatile: rename Kconfig macro in printk
      doc: put proper reference to CONFIG_MODULE_SIG_ENFORCE
      radio-shark: Fix printk "CONFIG_LED_CLASS"
      sound: Remove stray pluses from Kconfig file
      Remove spurious _H suffixes from ifdef comments
      kernel-parameters: remove outdated 'noresidual' parameter
      doc: Fix typo "CONFIG_CGROUP_CGROUP_MEMCG_SWAP"
      pm44xx: Fix comment for "CONFIG_CPU_IDLE"

Vincent Stehlé (1):
      docbook: fix 8250 naming in device-drivers

Wang YanQing (1):
      pata_pdc2027x: Fix compiler warning

Zhang Yanfei (11):
      driver: hv: remove cast for kmalloc return value
      driver: tty: vt: remove cast for kmalloc return value
      fs: ufs: remove cast for kmalloc return value
      driver: gpu: drm: i915: remove cast for kzalloc return value
      arm: remove cast for kzalloc return value
      fs: befs: remove cast for kmalloc return value
      driver: tty: serial: remove cast for kzalloc return value
      ia64: remove cast for kmalloc return value
      powerpc: remove cast for kmalloc/kzalloc return value
      net: sctp: remove cast for kmalloc/kzalloc return value
      driver: usb: storage: remove cast for kmalloc return value

 Documentation/DocBook/device-drivers.tmpl          |    2 +-
 Documentation/DocBook/media/dvb/dvbproperty.xml    |    6 ++--
 Documentation/cgroups/memory.txt                   |    2 +-
 .../devicetree/bindings/i2c/i2c-s3c2410.txt        |    2 +-
 Documentation/devicetree/bindings/leds/tca6507.txt |    2 +-
 .../devicetree/bindings/metag/meta-intc.txt        |    2 +-
 .../bindings/pinctrl/atmel,at91-pinctrl.txt        |    2 +-
 .../bindings/pinctrl/brcm,bcm2835-gpio.txt         |    2 +-
 .../bindings/power_supply/qnap-poweroff.txt        |    2 +-
 .../bindings/regulator/max8997-regulator.txt       |    2 +-
 .../devicetree/bindings/usb/samsung-usbphy.txt     |    2 +-
 Documentation/iostats.txt                          |    2 +
 Documentation/kernel-parameters.txt                |    4 +--
 Documentation/trace/tracepoints.txt                |   15 ------------
 Documentation/virtual/virtio-spec.txt              |    6 ++--
 arch/arc/kernel/disasm.c                           |    2 +-
 arch/arc/plat-arcfpga/Kconfig                      |    2 +-
 arch/arm/kernel/topology.c                         |    2 +-
 arch/arm/kvm/arm.c                                 |    2 +-
 arch/arm/mach-mvebu/irq-armada-370-xp.c            |    2 +-
 arch/arm/mach-omap2/pm44xx.c                       |    4 +-
 arch/blackfin/include/asm/bfin_sport3.h            |    2 +-
 arch/ia64/kernel/mca_drv.c                         |    2 +-
 arch/m32r/kernel/traps.c                           |    6 +---
 arch/powerpc/kernel/nvram_64.c                     |    3 +-
 arch/powerpc/kvm/book3s_pr.c                       |    2 +-
 arch/s390/kernel/irq.c                             |    2 +-
 arch/s390/kvm/trace.h                              |    2 +-
 arch/x86/include/asm/cmpxchg.h                     |    2 +-
 drivers/ata/pata_pdc2027x.c                        |    2 +
 drivers/ata/sata_fsl.c                             |    2 +-
 drivers/clk/mvebu/clk-core.c                       |    4 +-
 drivers/crypto/caam/ctrl.c                         |    2 +-
 drivers/gpu/drm/i915/intel_dp.c                    |    2 +-
 drivers/gpu/drm/i915/intel_sdvo.c                  |    2 +-
 drivers/gpu/drm/radeon/radeon_irq_kms.c            |    2 +-
 drivers/hv/hv.c                                    |    5 +--
 drivers/i2c/busses/i2c-puv3.c                      |    2 +-
 drivers/irqchip/irq-versatile-fpga.c               |    2 +-
 drivers/isdn/i4l/isdn_tty.c                        |    1 -
 drivers/media/pci/saa7164/saa7164-core.c           |    2 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c    |    2 +-
 drivers/media/radio/radio-shark.c                  |    2 +-
 drivers/media/radio/radio-shark2.c                 |    2 +-
 drivers/media/usb/dvb-usb/opera1.c                 |    2 +-
 drivers/misc/mei/amthif.c                          |    6 ++--
 drivers/misc/mei/client.c                          |   24 ++++++++++----------
 drivers/misc/mei/hbm.c                             |    9 ++++---
 drivers/misc/mei/hw-me.c                           |    8 +++---
 drivers/misc/mei/interrupt.c                       |    6 ++--
 drivers/misc/mei/pci-me.c                          |    1 +
 drivers/misc/mei/wd.c                              |    1 +
 drivers/net/ethernet/atheros/atl1c/atl1c_hw.c      |    2 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_dcb.c    |    4 +-
 drivers/net/ethernet/sfc/Kconfig                   |    2 +-
 drivers/net/ethernet/ti/cpts.c                     |    2 +-
 drivers/power/pm2301_charger.c                     |    2 +-
 drivers/remoteproc/remoteproc_core.c               |    2 +-
 drivers/rtc/Kconfig                                |    4 +-
 drivers/rtc/rtc-max8997.c                          |    2 +-
 drivers/scsi/be2iscsi/be_iscsi.c                   |    2 +-
 drivers/scsi/be2iscsi/be_mgmt.c                    |    2 +-
 drivers/scsi/bnx2i/bnx2i.h                         |   12 +++++-----
 drivers/scsi/csiostor/csio_mb.c                    |   12 +++++-----
 drivers/scsi/lpfc/lpfc_bsg.c                       |    2 +-
 drivers/scsi/mpt3sas/mpt3sas_config.c              |    2 +-
 drivers/scsi/osd/osd_initiator.c                   |    2 +-
 drivers/scsi/qla4xxx/ql4_nx.c                      |    2 +-
 drivers/tty/serial/icom.c                          |    3 +-
 drivers/tty/vt/consolemap.c                        |    3 +-
 drivers/usb/misc/iowarrior.c                       |    4 +-
 drivers/usb/misc/uss720.c                          |    2 +-
 drivers/usb/storage/isd200.c                       |    3 +-
 drivers/video/amifb.c                              |    2 +-
 drivers/video/auo_k190x.c                          |    2 +-
 drivers/video/exynos/exynos_dp_core.c              |    4 +-
 drivers/video/goldfishfb.c                         |    2 +-
 drivers/video/s1d13xxxfb.c                         |    2 +-
 drivers/video/ssd1307fb.c                          |    4 +-
 fs/befs/btree.c                                    |    3 +-
 fs/f2fs/f2fs.h                                     |    2 +-
 fs/f2fs/gc.c                                       |    2 +-
 fs/f2fs/super.c                                    |    2 +-
 fs/gfs2/glock.c                                    |    4 +-
 fs/gfs2/trans.c                                    |    3 +-
 fs/nfs/objlayout/objio_osd.c                       |    2 +-
 fs/nfs/objlayout/objlayout.h                       |    2 +-
 fs/ufs/util.c                                      |    3 +-
 include/linux/evm.h                                |    2 +-
 include/linux/iio/gyro/itg3200.h                   |    2 +-
 include/linux/ima.h                                |    4 +-
 include/linux/integrity.h                          |    2 +-
 include/linux/mmzone.h                             |    2 +-
 include/net/sctp/sctp.h                            |    2 +-
 include/sound/pcm.h                                |    2 +-
 include/trace/events/timer.h                       |   10 ++++----
 kernel/.gitignore                                  |    1 +
 mm/hugetlb.c                                       |    4 +-
 mm/memory.c                                        |    8 +++---
 mm/slab.c                                          |    8 ++----
 net/sctp/protocol.c                                |    2 +-
 sound/pci/mixart/mixart.c                          |    2 +-
 sound/soc/codecs/wm8974.c                          |    2 +-
 sound/soc/ux500/Kconfig                            |    4 +-
 tools/perf/tests/attr.c                            |    2 +-
 tools/perf/tests/parse-events.c                    |    2 +-
 tools/power/cpupower/debug/i386/intel_gsic.c       |    2 +-
 107 files changed, 166 insertions(+), 186 deletions(-)

-- 
Jiri Kosina
SUSE Labs
