Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756041AbaAVPZ2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 10:25:28 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38184 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755223AbaAVPZX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 10:25:23 -0500
Date: Wed, 22 Jan 2014 16:25:20 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-kernel@vger.kernel.org
Subject: [GIT] trivial for 3.14
Message-ID: <alpine.LNX.2.00.1401221601020.27143@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-2
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull from

  git://git.kernel.org/pub/scm/linux/kernel/git/jikos/trivial.git for-linus

to receive


- usual rocket science stuff from trivial.git



You are going to get an easy-to-fix conflict in 
drivers/gpu/drm/qxl/Kconfig, please let me know if you want me to prepare 
a branch with this sorted out for you to pull.

Alan (2):
      vio: remove dangly makefile bits
      mkregtable: Fix sscanf handling

Antonio Ospite (1):
      drivers/gpu/drm/qxl/Kconfig: reformat the help text

Ben Hutchings (1):
      DocBook: Make mandocs parallel-safe

David E. Narvaez (1):
      doc: Fix typo in USB Gadget Documentation

Emilio López (1):
      drivers: fix typo in DEVTMPFS_MOUNT Kconfig help text

Fam Zheng (1):
      slab: struct kmem_cache is protected by slab_mutex

Geert Uytterhoeven (3):
      asm-generic: uaccess: Spelling s/a ny/any/
      thermal: rcar: comment spelling
      of/Kconfig: Spelling s/one/once/

Krzysztof Ha³asa (1):
      IXP4xx: remove '1 &&' from a condition check in ixp4xx_restart()

Laszlo Papp (1):
      doc: driver-model/platform.txt: fix a typo

Li Zhong (2):
      Fix comment typo for alloc_netdev_mqs()
      neighbour.h: fix comment

Masanari Iida (5):
      treewide: Fix typo in Kconfig
      drm: fix typos in comment in /gpu/drm/exynos
      treewide: Fix typos in printk
      treewide: fix comments and printk msgs
      sched: Fix warning on make htmldocs caused by wait.h

Paul Gortmaker (1):
      Kconfig: fix spelling in CONTEXT_TRACKING_FORCE help text

Pavel Machek (1):
      lp5523, lp8501: comment improvements

Qiang Huang (1):
      cgroup, doc: make cgroup_disable doc more accurate

Randy Dunlap (1):
      scripts/kernel-doc: make unknown function prototype a Warning instead of an Error

Richard Weinberger (1):
      Documentation: Update x86_64/boot-options.txt

Rob Landley (1):
      Documentation: update /proc/uptime field description

Robert P. J. Day (2):
      DocBook: include !Emm/util.c in kernel-api to include, kzfree and more
      work around xmlto bug in htmldocs

Sachin Kamat (3):
      PM / devfreq: Fix trivial typo in exynos4_bus.c
      mtd: onenand: fix comment header
      arm: fix comment header and macro name

Sankha Narayan Guria (1):
      staging: usbip: Remove double initialization of msg_namelen variable

Silvan Jegen (1):
      doc: Fix trivial spelling mistake in efi-stub.txt

Stefan Raspl (1):
      documentation: Add links to TRACE_EVENT documentation

Stefan Weil (2):
      doc: Fix typo (acces_process_vm -> access_process_vm)
      Documentation: Fix size parameter for snprintf

Viresh Kumar (1):
      tracepoint: comment fix "binay" -> "binary"

Xishi Qiu (2):
      doc: fix some typos in documentations
      doc: fix some typos

ZHAO Gang (1):
      doc: Add "*.svg" to DocBook/.gitignore

 Documentation/DocBook/.gitignore              |    1 +
 Documentation/DocBook/Makefile                |    5 +++--
 Documentation/DocBook/kernel-api.tmpl         |    1 +
 Documentation/IRQ-domain.txt                  |    2 +-
 Documentation/driver-model/platform.txt       |    2 +-
 Documentation/efi-stub.txt                    |    2 +-
 Documentation/email-clients.txt               |    2 +-
 Documentation/filesystems/Locking             |    2 +-
 Documentation/filesystems/proc.txt            |    2 +-
 Documentation/io-mapping.txt                  |    2 +-
 Documentation/kernel-parameters.txt           |    9 ++++++++-
 Documentation/laptops/hpfall.c                |    2 +-
 Documentation/md.txt                          |    2 +-
 Documentation/rfkill.txt                      |    2 +-
 Documentation/rt-mutex-design.txt             |    2 +-
 Documentation/static-keys.txt                 |    4 ++--
 Documentation/usb/gadget_multi.txt            |    2 +-
 Documentation/x86/x86_64/boot-options.txt     |   23 -----------------------
 arch/arm/mach-at91/Kconfig.non_dt             |    2 +-
 arch/arm/mach-imx/mach-pca100.c               |    2 +-
 arch/arm/mach-ixp4xx/common.c                 |    2 +-
 arch/arm64/kvm/handle_exit.c                  |    2 +-
 arch/mips/ralink/cevt-rt3352.c                |    2 +-
 arch/mips/ralink/timer.c                      |    2 +-
 arch/powerpc/platforms/52xx/mpc52xx_lpbfifo.c |    2 +-
 arch/powerpc/platforms/powernv/opal-flash.c   |    4 ++--
 arch/x86/Kconfig                              |    2 +-
 drivers/base/Kconfig                          |    2 +-
 drivers/block/Makefile                        |    1 -
 drivers/cdrom/Makefile                        |    1 -
 drivers/char/Makefile                         |    1 -
 drivers/char/msm_smd_pkt.c                    |    2 +-
 drivers/devfreq/exynos/exynos4_bus.c          |    2 +-
 drivers/devfreq/exynos/exynos5_bus.c          |    2 +-
 drivers/gpu/drm/exynos/exynos_drm_crtc.c      |    4 ++--
 drivers/gpu/drm/exynos/exynos_drm_fimc.c      |    2 +-
 drivers/gpu/drm/exynos/exynos_drm_g2d.c       |    2 +-
 drivers/gpu/drm/exynos/exynos_drm_gem.c       |    2 +-
 drivers/gpu/drm/exynos/exynos_drm_gem.h       |    2 +-
 drivers/gpu/drm/exynos/exynos_drm_gsc.c       |    4 ++--
 drivers/gpu/drm/exynos/exynos_drm_ipp.c       |    2 +-
 drivers/gpu/drm/exynos/exynos_drm_ipp.h       |    4 ++--
 drivers/gpu/drm/qxl/Kconfig                   |    8 +++++---
 drivers/gpu/drm/radeon/mkregtable.c           |    2 +-
 drivers/i2c/busses/i2c-exynos5.c              |    2 +-
 drivers/i2c/busses/i2c-stu300.c               |    2 +-
 drivers/iio/adc/twl6030-gpadc.c               |    2 +-
 drivers/isdn/hisax/hfc4s8s_l1.c               |    2 +-
 drivers/isdn/mISDN/Kconfig                    |    2 +-
 drivers/leds/leds-lp5523.c                    |   10 +++++++++-
 drivers/leds/leds-lp8501.c                    |    2 +-
 drivers/media/platform/ti-vpe/vpdma.c         |    4 ++--
 drivers/misc/fsa9480.c                        |    2 +-
 drivers/misc/mei/nfc.c                        |    2 +-
 drivers/mtd/onenand/samsung.h                 |    2 --
 drivers/net/wan/lmc/lmc_main.c                |    2 +-
 drivers/net/wireless/libertas/cmdresp.c       |    2 +-
 drivers/of/Kconfig                            |    2 +-
 drivers/scsi/Kconfig                          |    4 ++--
 drivers/scsi/qla2xxx/qla_nx2.c                |    2 +-
 drivers/scsi/qla4xxx/ql4_83xx.c               |    2 +-
 drivers/staging/usbip/usbip_common.c          |    1 -
 drivers/thermal/rcar_thermal.c                |    2 +-
 drivers/tty/serial/crisv10.c                  |    2 +-
 drivers/usb/serial/kobil_sct.c                |    2 +-
 drivers/video/udlfb.c                         |    2 +-
 drivers/xen/Kconfig                           |    2 +-
 fs/btrfs/tests/free-space-tests.c             |    4 ++--
 include/asm-generic/uaccess.h                 |    2 +-
 include/linux/amba/sp810.h                    |    8 +++-----
 include/linux/slab_def.h                      |    2 +-
 include/linux/tracepoint.h                    |    2 +-
 include/linux/wait.h                          |    4 ++--
 include/uapi/linux/neighbour.h                |    2 +-
 init/Kconfig                                  |    2 +-
 net/core/dev.c                                |    2 +-
 net/netfilter/ipset/Kconfig                   |    2 +-
 net/nfc/digital_dep.c                         |    2 +-
 net/nfc/hci/llc_shdlc.c                       |    2 +-
 79 files changed, 105 insertions(+), 116 deletions(-)

-- 
Jiri Kosina
SUSE Labs
