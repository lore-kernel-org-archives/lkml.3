Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932339AbaDBOTQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 10:19:16 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40805 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932160AbaDBOTP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 10:19:15 -0400
Date: Wed, 2 Apr 2014 16:19:12 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-kernel@vger.kernel.org
Subject: [GIT] trivial
Message-ID: <alpine.LNX.2.00.1404021511490.32122@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull

  git://git.kernel.org/pub/scm/linux/kernel/git/jikos/trivial.git for-linus

to receive:



- updates from trivial tree; usual rocket science -- mostly documentation 
  and comment updates



Alexander Shiyan (1):
      mmc: core: typo fix in printk specifier

Brian Campbell (1):
      user_namespace.c: Remove duplicated word in comment

Geert Uytterhoeven (1):
      CREDITS: fix formatting

Jiang Liu (1):
      driver core: unexport static function create_syslog_header

Li Zhong (1):
      sparse: fix comment

Masanari Iida (5):
      mm: Fix warning on make htmldocs caused by slab.c
      treewide: Fix typo in Documentation/DocBook
      ixgbe: Fix format string in ixgbe_fcoe.
      doc: DocBook: Fix typos in xml and template file
      doc: fix double words

Olaf Hering (1):
      Documentation: update URL to hfsplus Technote 1150

Paul Bolle (5):
      Kconfig: Remove useless "default N" lines
      doc: Insert MODULE_ in module-signing macros
      net-sysfs: fix comment typo 'CONFIG_SYFS'
      ARM: spear: clean up editing mistake
      isdn: capi: fix "CAPI_VERSION" comment

Pavel Machek (1):
      Bluetooth: add module name for btwilink

Richard Genoud (1):
      gpio: update path to documentation

Sachin Kamat (1):
      ata: ata-samsung_cf: cleanup in header file

Vladimir Davydov (1):
      idr: remove unused prototype of idr_free()

 CREDITS                                            |    4 ++--
 Documentation/DocBook/media/dvb/dvbproperty.xml    |    2 +-
 Documentation/DocBook/media/v4l/compat.xml         |    2 +-
 Documentation/DocBook/media_api.tmpl               |    2 +-
 .../filesystems/autofs4-mount-control.txt          |    2 +-
 Documentation/filesystems/hfsplus.txt              |    2 +-
 Documentation/futex-requeue-pi.txt                 |    2 +-
 Documentation/input/multi-touch-protocol.txt       |    2 +-
 Documentation/kmemcheck.txt                        |    2 +-
 Documentation/memory-barriers.txt                  |    2 +-
 Documentation/module-signing.txt                   |   10 +++++-----
 Documentation/networking/spider_net.txt            |    2 +-
 Documentation/power/devices.txt                    |    2 +-
 Documentation/security/Smack.txt                   |    2 +-
 Documentation/trace/ring-buffer-design.txt         |    2 +-
 Documentation/usb/WUSB-Design-overview.txt         |    2 +-
 Documentation/virtual/kvm/api.txt                  |    2 +-
 Documentation/vm/unevictable-lru.txt               |    2 +-
 arch/arc/Kconfig                                   |    1 -
 arch/arm/mach-spear/Kconfig                        |    2 +-
 arch/cris/arch-v32/drivers/Kconfig                 |    2 --
 arch/s390/include/asm/cio.h                        |    2 +-
 block/blk-core.c                                   |    2 +-
 block/blk-map.c                                    |    2 +-
 drivers/ata/libata-core.c                          |    4 ++--
 drivers/base/bus.c                                 |    2 +-
 drivers/bluetooth/Kconfig                          |    3 ++-
 drivers/gpu/drm/drm_crtc_helper.c                  |    2 +-
 drivers/input/sparse-keymap.c                      |    2 +-
 drivers/misc/mic/Kconfig                           |    2 --
 drivers/mmc/core/host.c                            |    2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_fcoe.c      |    2 +-
 drivers/regulator/core.c                           |    2 +-
 drivers/scsi/scsi_transport_iscsi.c                |    6 +++---
 drivers/staging/android/Kconfig                    |    2 --
 drivers/staging/bcm/Kconfig                        |    1 -
 drivers/staging/frontier/Kconfig                   |    1 -
 drivers/staging/media/go7007/Kconfig               |    3 ---
 drivers/staging/rtl8187se/Kconfig                  |    1 -
 drivers/staging/rtl8188eu/Kconfig                  |    1 -
 drivers/staging/rtl8192e/rtl8192e/Kconfig          |    1 -
 drivers/staging/rtl8192u/Kconfig                   |    1 -
 drivers/staging/rtl8712/Kconfig                    |    2 --
 drivers/staging/usbip/Kconfig                      |    4 ----
 drivers/usb/core/Kconfig                           |    1 -
 drivers/usb/core/message.c                         |    2 +-
 drivers/usb/core/urb.c                             |    2 +-
 drivers/usb/host/Kconfig                           |    3 ---
 fs/buffer.c                                        |    2 +-
 fs/debugfs/inode.c                                 |    6 +++---
 include/drm/drm_fb_helper.h                        |    2 +-
 include/linux/gpio.h                               |    2 +-
 include/linux/hsi/hsi.h                            |    2 +-
 include/linux/idr.h                                |    1 -
 include/linux/kfifo.h                              |    2 +-
 include/linux/pipe_fs_i.h                          |    2 +-
 include/linux/platform_data/ata-samsung_cf.h       |    9 ++++-----
 include/linux/skbuff.h                             |    2 +-
 include/linux/spi/spi.h                            |    8 ++++----
 include/linux/usb/composite.h                      |    2 +-
 include/net/mac80211.h                             |    6 +++---
 include/uapi/linux/capi.h                          |    2 +-
 kernel/relay.c                                     |    2 +-
 kernel/signal.c                                    |    2 +-
 mm/sparse.c                                        |    2 +-
 net/core/dev.c                                     |    2 +-
 net/core/net-sysfs.c                               |    2 +-
 67 files changed, 70 insertions(+), 97 deletions(-)

-- 
Jiri Kosina
SUSE Labs
