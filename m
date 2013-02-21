Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753173Ab3BUKOy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 05:14:54 -0500
Received: from cantor2.suse.de ([195.135.220.15]:32900 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752317Ab3BUKOs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 05:14:48 -0500
Date: Thu, 21 Feb 2013 11:14:45 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT] trivial
Message-ID: <alpine.LNX.2.00.1302211105410.17024@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull from

  git://git.kernel.org/pub/scm/linux/kernel/git/jikos/trivial.git for-linus

to receive assorted tiny fixes queued in trivial tree.


Andrew Murray (1):
      of: fix spelling mistake in comment

Javi Merino (1):
      of: add missing documentation for of_platform_populate()

Jesper Dangaard Brouer (1):
      percpu_counter.h: comment code for better readability

Jesper Juhl (3):
      pcmcia: avoid static analysis complaint about use-after-free
      net: mvneta: remove unneeded version.h include
      IB: cxgb3: delay freeing mem untill entirely done with it

Jiri Kosina (1):
      time: x86: report_lost_ticks doesn't exist any more

Johan Hovold (1):
      ARM: at91/ide: remove unsused at91-ide Kconfig entry

Jorrit Schippers (1):
      treewide: Replace incomming with incoming in all comments and strings

Kusanagi Kouichi (1):
      Revert "Documentation: ABI: /sys/devices/system/cpu/cpu#/node"

Liu Bo (1):
      btrfs: fix comment typos

Masanari Iida (4):
      xtensa: Fix home page URL in Kconfig
      h8300: Fix home page URL in h8300/README
      treewide: Fix typo in various drivers
      sound: soc: Fix typo in sound/codecs

Olaf Hering (1):
      x86, efi: fix comment typo in head_32.S

Paul Gortmaker (2):
      Documentation: update top level 00-INDEX file with new additions
      DocBook: update EXPORT_SYMBOL entry to point at export.h

Philippe De Muyter (1):
      fs/jfs: Fix typo in comment : 'how may' -> 'how many'

Tim Blechmann (1):
      powerpc: fix typo (utilties -> utilities)

Wade Cline (1):
      Update ibmvscsi module name in Kconfig.

Wang Sheng-Hui (1):
      btrfs: remove unnecessary cur_trans set before goto loop in join_transaction

 Documentation/00-INDEX                             |  149 ++++++++++++++++++--
 Documentation/ABI/testing/sysfs-devices-system-cpu |   14 --
 Documentation/DocBook/kernel-hacking.tmpl          |    4 +-
 Documentation/x86/x86_64/boot-options.txt          |    4 -
 arch/h8300/README                                  |    2 +-
 .../cavium-octeon/executive/cvmx-helper-util.c     |    4 +-
 arch/mips/include/asm/octeon/cvmx-helper-util.h    |    4 +-
 arch/powerpc/platforms/85xx/p1022_ds.c             |    8 +-
 arch/powerpc/platforms/86xx/mpc8610_hpcd.c         |    4 +-
 arch/x86/kernel/cpu/perf_event_amd_ibs.c           |    2 +-
 arch/xtensa/Kconfig                                |    2 +-
 drivers/bluetooth/ath3k.c                          |    2 +-
 drivers/devfreq/exynos4_bus.c                      |    2 +-
 drivers/firewire/ohci.c                            |    2 +-
 drivers/gpu/drm/i915/i915_debugfs.c                |    2 +-
 drivers/hid/Kconfig                                |    2 +-
 drivers/ide/Kconfig                                |    5 -
 drivers/infiniband/hw/cxgb3/iwch_provider.c        |    2 +-
 drivers/isdn/hardware/eicon/divacapi.h             |    6 +-
 drivers/isdn/hardware/eicon/pc.h                   |    4 +-
 drivers/isdn/mISDN/l1oip_core.c                    |    2 +-
 drivers/media/platform/soc_camera/mx2_camera.c     |    2 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c   |    2 +-
 drivers/net/ethernet/marvell/mvneta.c              |    1 -
 drivers/net/ethernet/mellanox/mlx4/en_main.c       |    2 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c   |    2 +-
 drivers/net/irda/ali-ircc.c                        |    2 +-
 drivers/of/address.c                               |    2 +-
 drivers/of/platform.c                              |    1 +
 drivers/pcmcia/rsrc_nonstatic.c                    |    6 +-
 drivers/rpmsg/virtio_rpmsg_bus.c                   |    2 +-
 drivers/scsi/Kconfig                               |    2 +-
 drivers/staging/android/binder.h                   |    2 +-
 drivers/staging/octeon/ethernet.c                  |    2 +-
 drivers/target/sbp/sbp_target.c                    |    2 +-
 drivers/tty/ipwireless/hardware.c                  |    4 +-
 fs/btrfs/extent-tree.c                             |    6 +-
 fs/btrfs/relocation.c                              |    4 +-
 fs/btrfs/transaction.c                             |    1 -
 fs/cifs/link.c                                     |    2 +-
 fs/hpfs/inode.c                                    |    2 +-
 fs/jfs/super.c                                     |    2 +-
 fs/ocfs2/cluster/tcp.c                             |    2 +-
 fs/qnx6/inode.c                                    |    2 +-
 include/linux/dma-buf.h                            |    2 +-
 include/linux/percpu_counter.h                     |    2 +-
 include/net/irda/irlmp.h                           |    2 +-
 include/net/irda/irttp.h                           |    2 +-
 net/bluetooth/hci_core.c                           |    2 +-
 net/caif/cfcnfg.c                                  |    2 +-
 net/irda/timer.c                                   |    2 +-
 net/sctp/sm_make_chunk.c                           |    2 +-
 scripts/basic/fixdep.c                             |    2 +-
 sound/soc/codecs/ab8500-codec.c                    |    2 +-
 sound/soc/codecs/wm8974.c                          |    6 +-
 sound/soc/codecs/wm8978.c                          |    6 +-
 sound/soc/codecs/wm8983.c                          |    6 +-
 sound/soc/codecs/wm8985.c                          |    6 +-
 58 files changed, 215 insertions(+), 110 deletions(-)

-- 
Jiri Kosina
SUSE Labs
