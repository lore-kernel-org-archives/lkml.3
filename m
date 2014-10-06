Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752705AbaJFWWX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 18:22:23 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34700 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751289AbaJFWWU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 18:22:20 -0400
Date: Tue, 7 Oct 2014 00:22:19 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] trivial for 3.18 merge window
Message-ID: <alpine.LNX.2.00.1410070006570.31343@pobox.suse.cz>
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

to receive


- usual pile from trivial tree everyone is so eagerly waiting for



----------------------------------------------------------------
Arnd Hannemann (1):
      doc: queue-sysfs: minor fixes

Emilio López (1):
      genirq: fix reference in devm_request_threaded_irq comment

Fam Zheng (1):
      Documentation: Fix null_blk parameter irq_mode to irqmode

Geert Uytterhoeven (8):
      mm: Fix CROSS_MEMORY_ATTACH help text grammar
      cx25840: fix comment
      cx23885: Spelling s/compuations/computations/
      lib: rhashtable: Spelling s/compuate/compute/
      paride/pcd: Fix grammar
      powerpc/simpleboot: fix comment
      MIPS: fix comment spelling
      mei: fix comments

Harish Jenny K N (1):
      lockup-watchdogs: Fix a typo

Hayato Suzuki (1):
      Documentation: treewide: fix typos and grammar

Horia Geanta (1):
      dma-debug: modify check_for_stack output

Jesper Dangaard Brouer (1):
      treewide: fix synchronize_rcu() in comments

Junien Fridrick (1):
      Documentation: ABI/testing: Spelling s/calss/class/

Kyle McMartin (1):
      checkstack.pl: port to AArch64

Li Zhong (1):
      powerpc: Fix comment typos in hotplug-memory.c

Masanari Iida (4):
      treewide: Fix typo in printk
      treewide: fix errors in printk
      Documentation: Docbook: Fix generated DocBook/kernel-api.xml
      treewide: Fix typos in Kconfig

Michael Ellerman (1):
      kprobes: update jprobe_example.c for do_fork() change

Oscar Utbult (1):
      Documentation: change "&" to "and" in Documentation/applying-patches.txt

Paul Bolle (3):
      Documentation: au1xxx-ide.c has moved
      fs: fix comment for 'CONFIG_LBADF'
      gpio: fix 'CONFIG_GPIO_IRQCHIP' comments

Pavel Machek (2):
      stmmac.txt: fix typo
      init/do_mounts: better syntax description

Rahul Bedarkar (1):
      Documentation: kmemleak: correct spelling mistake

Rasmus Villemoes (1):
      fs/btrfs/tree-log.c: Fix closing brace followed by if

Raymond L. Rivera (2):
      CodingStyle: fix a minor typo
      linux/pagemap.h: Fixed a typo in a code comment.

Richard Genoud (1):
      tty: doc: Fix grammar in serial/tty

Richard Weinberger (2):
      score: Remove GENERIC_HAS_IOMAP
      Remove MN10300_PROC_MN2WS0038

Simon Danner (2):
      Documentation: update links in Changes
      Documentation: remove obsolete pcmcia-cs from Changes

Yegor Yefremov (1):
      Documentation: serial: fix header path

 Documentation/ABI/testing/sysfs-class-net           |  2 +-
 Documentation/Changes                               | 21 +++++----------------
 Documentation/CodingStyle                           |  2 +-
 Documentation/applying-patches.txt                  |  2 +-
 Documentation/block/null_blk.txt                    |  4 ++--
 Documentation/block/queue-sysfs.txt                 |  6 +++---
 .../devicetree/bindings/clock/arm-integrator.txt    |  2 +-
 .../devicetree/bindings/crypto/fsl-sec6.txt         |  2 +-
 .../devicetree/bindings/iio/adc/vf610-adc.txt       |  2 +-
 Documentation/devicetree/bindings/mfd/s2mps11.txt   |  2 +-
 Documentation/devicetree/bindings/mtd/gpmc-nand.txt |  6 +++---
 .../devicetree/bindings/net/samsung-sxgbe.txt       |  2 +-
 Documentation/devicetree/bindings/net/stmmac.txt    |  2 +-
 .../devicetree/bindings/pci/host-generic-pci.txt    |  2 +-
 .../devicetree/bindings/phy/phy-bindings.txt        |  2 +-
 .../bindings/power_supply/charger-manager.txt       |  2 +-
 .../devicetree/bindings/sound/st,sta350.txt         |  2 +-
 .../devicetree/bindings/vendor-prefixes.txt         |  2 +-
 .../devicetree/bindings/video/atmel,lcdc.txt        |  4 ++--
 .../devicetree/bindings/video/fsl,imx-fb.txt        |  2 +-
 Documentation/kmemleak.txt                          |  2 +-
 Documentation/lockup-watchdogs.txt                  |  2 +-
 Documentation/mips/AU1xxx_IDE.README                |  2 +-
 Documentation/serial/serial-rs485.txt               |  2 +-
 Documentation/serial/tty.txt                        |  4 ++--
 arch/blackfin/Kconfig                               |  2 +-
 arch/blackfin/mach-common/ints-priority.c           |  2 +-
 arch/m68k/Kconfig.devices                           |  2 +-
 arch/mips/cavium-octeon/Kconfig                     |  2 +-
 arch/mips/lantiq/falcon/sysctrl.c                   |  2 +-
 arch/mips/lantiq/xway/sysctrl.c                     |  2 +-
 arch/mips/pci/pci-lantiq.c                          |  2 +-
 arch/mn10300/Kconfig                                |  2 +-
 arch/powerpc/boot/simpleboot.c                      |  2 +-
 arch/powerpc/platforms/powernv/opal.c               |  2 +-
 arch/powerpc/platforms/pseries/hotplug-memory.c     |  4 ++--
 arch/score/Kconfig                                  |  3 ---
 block/blk-core.c                                    |  8 ++++----
 block/genhd.c                                       |  2 +-
 drivers/block/paride/pcd.c                          |  4 ++--
 drivers/crypto/qat/qat_common/adf_ctl_drv.c         |  2 +-
 drivers/gpu/drm/i915/intel_bios.c                   |  2 +-
 drivers/i2c/busses/Kconfig                          |  2 +-
 drivers/i2c/busses/i2c-s3c2410.c                    |  2 +-
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c         |  2 +-
 drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c       |  2 +-
 drivers/irqchip/Kconfig                             |  2 +-
 drivers/media/i2c/cx25840/cx25840-ir.c              |  2 +-
 drivers/media/pci/cx23885/cx23888-ir.c              |  2 +-
 drivers/media/usb/gspca/stv06xx/stv06xx_vv6410.c    |  2 +-
 drivers/misc/mei/pci-me.c                           |  4 ++--
 drivers/misc/mei/pci-txe.c                          |  4 ++--
 drivers/net/bonding/bond_sysfs_slave.c              |  2 +-
 drivers/net/ethernet/mellanox/mlx4/cmd.c            |  4 ++--
 drivers/net/ethernet/qlogic/netxen/netxen_nic_hw.c  |  2 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c      |  2 +-
 drivers/net/ethernet/via/via-velocity.c             |  2 +-
 drivers/net/wireless/libertas/cfg.c                 |  2 +-
 drivers/net/wireless/libertas_tf/main.c             |  2 +-
 drivers/platform/x86/Kconfig                        |  4 ++--
 drivers/scsi/aic7xxx/Kconfig.aic79xx                |  2 +-
 drivers/scsi/fnic/fnic_debugfs.c                    |  2 +-
 drivers/scsi/fnic/fnic_trace.c                      |  2 +-
 drivers/scsi/nsp32.c                                |  2 +-
 drivers/scsi/pcmcia/nsp_cs.c                        |  2 +-
 drivers/scsi/qla2xxx/qla_nx2.c                      |  2 +-
 drivers/usb/host/Kconfig                            |  2 +-
 drivers/video/backlight/88pm860x_bl.c               |  2 +-
 fs/btrfs/tree-log.c                                 |  3 ++-
 fs/stack.c                                          |  2 +-
 include/linux/clk.h                                 |  2 +-
 include/linux/gpio/driver.h                         |  4 ++--
 include/linux/kfifo.h                               |  2 +-
 include/linux/pagemap.h                             |  2 +-
 include/linux/percpu-refcount.h                     |  2 +-
 init/do_mounts.c                                    |  3 ++-
 ipc/util.c                                          |  6 +++---
 kernel/auditsc.c                                    |  2 +-
 kernel/irq/devres.c                                 |  2 +-
 lib/bitmap.c                                        |  4 ++--
 lib/dma-debug.c                                     |  2 +-
 lib/idr.c                                           |  2 +-
 lib/rhashtable.c                                    |  4 ++--
 lib/vsprintf.c                                      |  2 +-
 mm/filemap.c                                        |  2 +-
 net/mac802154/wpan.c                                |  2 +-
 net/netfilter/ipset/ip_set_core.c                   |  2 +-
 net/rds/af_rds.c                                    |  2 +-
 samples/kprobes/jprobe_example.c                    |  9 ++++-----
 scripts/checkstack.pl                               |  7 +++++--
 scripts/sign-file                                   |  2 +-
 security/inode.c                                    |  2 +-
 92 files changed, 125 insertions(+), 135 deletions(-)

-- 
Jiri Kosina
SUSE Labs
