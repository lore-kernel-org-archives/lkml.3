Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752941AbaFDLhs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 07:37:48 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59510 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752914AbaFDLhp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 07:37:45 -0400
Date: Wed, 4 Jun 2014 13:37:43 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-kernel@vger.kernel.org
Subject: [GIT] trivial for 3.16 merge window
Message-ID: <alpine.LNX.2.00.1406041324100.11302@pobox.suse.cz>
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


- usual pile of patches from trivial tree that make the world go round


There is a trivial conflict in 
Documentation/devicetree/bindings/arm/omap/omap.txt between 38b248db60e 
from your tree and c98be0c96d from trivial.git, which is easy to fix (DRA7 
EVM got renamed to DRA742 EVM in the doc). If you want me to prepare a 
branch with conflict fixed, please let me know.

----------------------------------------------------------------
Alan (1):
      doc: Note need of bc in the kernel build from 3.10 onwards

Carlos Garcia (1):
      doc: spelling error changes

Geert Uytterhoeven (11):
      drm/exynos: Spelling s/contro/control/
      of: Improve grammar for of_alias_get_id() documentation
      ath6kl: Spelling s/determnine/determine/
      ath10k: Improve grammar in comments
      dma: imx-sdma: Spelling s/determnine/determine/
      of: Spelling s/anonymouns/anonymous/
      arm64: mm: Remove superfluous "the" in comment
      aic7xxx: Spelling s/termnation/termination/
      wimax: Spelling s/than/that/, wording s/destinatary/recipient/
      Kconfig.debug: Grammar s/addition/additional/
      of: dma: doc fixes

Hiroshige Sato (1):
      mm: Fix printk typo in dmapool.c

Ilya Dryomov (1):
      doc: printk-formats: do not mention casts for u64/s64

Javier Martinez Canillas (2):
      dma-buf: fix trivial typo error
      dma-buf: update exp_name when using dma_buf_export()

Pali Rohár (1):
      radio-bcm2048.c: fix wrong overflow check

Paul Bolle (3):
      modpost: Fix comment typo "Modules.symvers"
      aic7xxx: Remove obsolete preprocessor define
      staging: go7007: remove reference to CONFIG_KMOD

Petr Oros (1):
      doc: fix incorrect formula to calculate CommitLimit value

Ryan Desfosses (1):
      pci: change "foo* bar" to "foo *bar"

 Documentation/Changes                                        |  5 +++++
 Documentation/DMA-attributes.txt                             |  2 +-
 Documentation/devicetree/bindings/arm/omap/omap.txt          |  2 +-
 Documentation/devicetree/bindings/bus/mvebu-mbus.txt         |  2 +-
 Documentation/devicetree/bindings/dma/dma.txt                |  4 ++--
 Documentation/devicetree/bindings/dma/fsl-imx-sdma.txt       |  2 +-
 Documentation/devicetree/bindings/gpio/gpio-mcp23s08.txt     |  2 +-
 Documentation/devicetree/bindings/mmc/k3-dw-mshc.txt         |  2 +-
 Documentation/devicetree/bindings/mmc/samsung-sdhci.txt      |  2 +-
 Documentation/devicetree/bindings/mtd/gpmc-nand.txt          |  2 +-
 Documentation/devicetree/bindings/mtd/gpmc-nor.txt           |  2 +-
 Documentation/devicetree/bindings/mtd/gpmc-onenand.txt       |  2 +-
 .../devicetree/bindings/pinctrl/brcm,bcm11351-pinctrl.txt    | 12 ++++++------
 Documentation/devicetree/bindings/powerpc/4xx/reboot.txt     |  2 +-
 Documentation/devicetree/bindings/powerpc/fsl/dcsr.txt       |  2 +-
 Documentation/devicetree/bindings/regulator/regulator.txt    |  2 +-
 Documentation/devicetree/bindings/spi/spi-bus.txt            |  2 +-
 Documentation/dma-buf-sharing.txt                            |  6 +++---
 Documentation/dynamic-debug-howto.txt                        |  2 +-
 Documentation/edac.txt                                       |  2 +-
 Documentation/fb/sm501.txt                                   |  2 +-
 Documentation/fb/sstfb.txt                                   |  2 +-
 Documentation/filesystems/proc.txt                           |  7 ++++---
 Documentation/filesystems/sharedsubtree.txt                  |  2 +-
 Documentation/gpio/consumer.txt                              |  2 +-
 Documentation/hid/uhid.txt                                   |  2 +-
 Documentation/input/alps.txt                                 |  2 +-
 Documentation/input/input.txt                                |  2 +-
 Documentation/mtd/nand/pxa3xx-nand.txt                       |  2 +-
 Documentation/networking/can.txt                             |  2 +-
 Documentation/networking/dccp.txt                            |  2 +-
 Documentation/powerpc/transactional_memory.txt               |  2 +-
 Documentation/printk-formats.txt                             |  4 ++--
 Documentation/rbtree.txt                                     |  2 +-
 Documentation/rfkill.txt                                     |  2 +-
 Documentation/robust-futexes.txt                             |  2 +-
 Documentation/s390/monreader.txt                             |  2 +-
 Documentation/security/Yama.txt                              |  2 +-
 Documentation/sound/alsa/ALSA-Configuration.txt              |  4 ++--
 Documentation/trace/events.txt                               |  2 +-
 Documentation/usb/mass-storage.txt                           |  2 +-
 Documentation/virtual/kvm/api.txt                            |  2 +-
 Documentation/vm/transhuge.txt                               |  4 ++--
 Documentation/x86/earlyprintk.txt                            |  2 +-
 Documentation/x86/i386/IO-APIC.txt                           |  2 +-
 arch/arm64/include/asm/pgtable.h                             |  2 +-
 drivers/base/dma-buf.c                                       |  2 +-
 drivers/gpu/drm/exynos/exynos_drm_ipp.c                      |  2 +-
 drivers/net/wireless/ath/ath10k/wmi.h                        |  4 ++--
 drivers/net/wireless/ath/ath6kl/wmi.h                        |  2 +-
 drivers/of/base.c                                            |  4 ++--
 drivers/pci/pci.c                                            |  6 +++---
 drivers/scsi/aic7xxx/aic79xx.h                               |  2 +-
 drivers/scsi/aic7xxx/aic7xxx_osm.c                           | 10 ----------
 drivers/staging/media/bcm2048/radio-bcm2048.c                |  2 +-
 drivers/staging/media/go7007/go7007.txt                      |  1 -
 include/linux/of_platform.h                                  |  2 +-
 include/net/wimax.h                                          |  4 ++--
 lib/Kconfig.debug                                            |  4 ++--
 mm/dmapool.c                                                 |  4 ++--
 scripts/mod/modpost.c                                        |  2 +-
 61 files changed, 84 insertions(+), 89 deletions(-)

-- 
Jiri Kosina
SUSE Labs
