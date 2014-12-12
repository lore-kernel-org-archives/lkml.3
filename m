Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965836AbaLLKlz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 05:41:55 -0500
Received: from cantor2.suse.de ([195.135.220.15]:47977 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932345AbaLLKlx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 05:41:53 -0500
Date: Fri, 12 Dec 2014 11:41:51 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] trivial
Message-ID: <alpine.LNX.2.00.1412121121140.6575@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull from

  git://git.kernel.org/pub/scm/linux/kernel/git/jikos/trivial.git for-linus

to receive 3.19 merge window updates queued in trivial tree.

=====
- usual stuff: documentation updates, printk() fixes, etc.
=====

You are going to receive one conflict, that was reported in linux-next 
here:

	https://lkml.org/lkml/2014/12/2/1033

and it's trivial to fix. If you want me to prepare branch with the 
conflict resolved, please let me know.

Thanks.

----------------------------------------------------------------
Alex Pilon (1):
      scsi: mpt2sas: fix ioctl in comment

Alistair Popple (1):
      IBM Akebono: Remove obsolete config select

Andrey Utkin (1):
      Replace mentions of "list_struct" to "list_head"

Daniel Thompson (1):
      gpio: msm-v1: make boolean argument more obvious

Finn Thain (1):
      scsi: Fix "choir" and "beeing" malaprops

Frans Klaver (2):
      gadget_configfs.txt: fix spelling of 'function'
      kernel: trace: fix printk message

Geert Uytterhoeven (4):
      usb: gadget: zero: Spelling s/infrastucture/infrastructure/
      isci: Spelling s/stucture/structure/
      clk: st: Spelling s/stucture/structure/
      cpufreq: cpufreq-dt: Move newline to end of error message

Ian Campbell (1):
      arm: fix wording of "Crotex" in CONFIG_ARCH_EXYNOS3 help

James Hartley (1):
      clocksource: Fix 'clcoksource' typo in comment

Julia Lawall (1):
      ps3rom: fix error return code

Masanari Iida (2):
      treewide: Fix company name in module descriptions
      treewide: fix typo in printk and Kconfig

Masatake YAMATO (1):
      intel_ips: fix a type in error message

Michael Opdenacker (1):
      mod_devicetable.h: grammar fix in comment

Paul Bolle (3):
      powerpc: Fix comment typos 'CONFiG_ALTIVEC'
      powerpc: Fix comment typo 'CONIFG_8xx'
      PCI: Fix comment typo 'COMFIG_PM_OPS'

Radek Dostal (1):
      ARM: dts: bcm63138: change "interupts" to "interrupts"

Roman Mindalev (1):
      usb: Fix typo in usb-serial-simple.c

Seth Jennings (1):
      zbud, zswap: change module author email

 .../devicetree/bindings/clock/st/st,flexgen.txt    |  2 +-
 Documentation/scsi/scsi_eh.txt                     |  4 +--
 Documentation/usb/gadget_configfs.txt              |  2 +-
 arch/arm/boot/dts/bcm63138.dtsi                    |  2 +-
 arch/arm/mach-exynos/Kconfig                       |  2 +-
 arch/mips/cavium-octeon/setup.c                    |  4 +--
 arch/mips/pci/pci-octeon.c                         |  2 +-
 arch/powerpc/kvm/e500_mmu_host.c                   |  6 ++--
 arch/powerpc/lib/copyuser_power7.S                 |  2 +-
 arch/powerpc/lib/memcpy_power7.S                   |  2 +-
 arch/powerpc/mm/mmu_decl.h                         |  2 +-
 arch/powerpc/platforms/44x/Kconfig                 |  1 -
 drivers/clk/Kconfig                                |  2 +-
 drivers/cpufreq/cpufreq-dt.c                       |  2 +-
 drivers/gpio/gpio-msm-v1.c                         |  2 +-
 drivers/gpio/gpio-spear-spics.c                    |  2 +-
 drivers/gpu/drm/radeon/mkregtable.c                | 24 +++++++--------
 drivers/isdn/mISDN/l1oip_core.c                    |  2 +-
 drivers/media/pci/cx18/cx18-driver.h               |  2 +-
 drivers/media/pci/ttpci/budget-patch.c             |  2 +-
 drivers/net/ethernet/atheros/atl1c/atl1c_main.c    |  2 +-
 drivers/pci/pci-driver.c                           |  4 +--
 drivers/pinctrl/spear/pinctrl-plgpio.c             |  2 +-
 drivers/platform/x86/intel_ips.c                   |  2 +-
 drivers/s390/char/tape_3590.c                      |  4 +--
 drivers/scsi/aha152x.c                             |  2 +-
 drivers/scsi/isci/task.c                           |  2 +-
 drivers/scsi/mac_scsi.c                            |  2 +-
 drivers/scsi/megaraid/megaraid_sas_base.c          |  2 +-
 drivers/scsi/mpt2sas/mpt2sas_ctl.h                 |  2 +-
 drivers/scsi/ps3rom.c                              |  1 +
 drivers/target/target_core_xcopy.c                 |  2 +-
 drivers/tty/serial/Kconfig                         |  2 +-
 drivers/usb/gadget/function/f_hid.c                |  2 +-
 drivers/usb/gadget/legacy/zero.c                   |  2 +-
 drivers/usb/host/ehci-sysfs.c                      |  2 +-
 drivers/usb/host/fotg210-hcd.c                     |  2 +-
 drivers/usb/host/fusbh200-hcd.c                    |  2 +-
 drivers/usb/serial/usb-serial-simple.c             |  2 +-
 drivers/video/fbdev/exynos/exynos_mipi_dsi.c       |  2 +-
 .../video/fbdev/exynos/exynos_mipi_dsi_common.c    |  2 +-
 fs/reiserfs/journal.c                              |  2 +-
 include/linux/list.h                               | 34 +++++++++++-----------
 include/linux/mod_devicetable.h                    |  2 +-
 include/linux/plist.h                              | 10 +++----
 include/linux/rculist.h                            |  8 ++---
 include/scsi/scsi_host.h                           |  2 +-
 kernel/time/clocksource.c                          |  2 +-
 kernel/trace/trace.c                               |  2 +-
 mm/zbud.c                                          |  2 +-
 mm/zswap.c                                         |  2 +-
 scripts/kconfig/list.h                             |  6 ++--
 .../multibuff/device_app/aio_multibuff.c           |  2 +-
 tools/usb/usbip/libsrc/list.h                      |  2 +-
 54 files changed, 95 insertions(+), 95 deletions(-)

-- 
Jiri Kosina
SUSE Labs
