Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754662Ab3CCWbX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 17:31:23 -0500
Received: from mail-pb0-f48.google.com ([209.85.160.48]:36035 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754544Ab3CCWbW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 17:31:22 -0500
Date: Mon, 4 Mar 2013 06:31:36 +0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.4.35
Message-ID: <20130303223136.GA19140@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2fHTh5uZTiUOsy+g"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2fHTh5uZTiUOsy+g
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.4.35 kernel.

All users of the 3.4 kernel series must upgrade.

The updated 3.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-3.4.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dsu=
mmary

thanks,

greg k-h

------------

 Documentation/kernel-parameters.txt           |    5 ++
 Makefile                                      |    2=20
 arch/x86/kernel/head.c                        |   53 ++++++++++++++++-----=
-----
 arch/x86/platform/efi/efi.c                   |    5 +-
 block/genhd.c                                 |   15 +++----
 block/partition-generic.c                     |    2=20
 drivers/acpi/sleep.c                          |    8 +++
 drivers/ata/ata_piix.c                        |   17 ++++++++
 drivers/block/xen-blkback/blkback.c           |    1=20
 drivers/block/xen-blkback/xenbus.c            |   49 +++++++++++----------=
---
 drivers/firewire/core-device.c                |    4 +
 drivers/hid/hid-core.c                        |    1=20
 drivers/hid/hid-ids.h                         |    3 +
 drivers/iommu/amd_iommu_init.c                |    9 +++-
 drivers/media/rc/rc-main.c                    |    4 +
 drivers/net/wireless/ath/ath9k/ar9003_calib.c |    2=20
 drivers/net/wireless/ath/ath9k/ar9003_phy.c   |    2=20
 drivers/net/wireless/ath/ath9k/hw.h           |    1=20
 drivers/power/ab8500_btemp.c                  |    2=20
 drivers/power/abx500_chargalg.c               |    2=20
 drivers/staging/comedi/comedi_fops.c          |    8 +--
 drivers/staging/comedi/drivers/ni_labpc.c     |   35 +++++++++--------
 drivers/target/target_core_device.c           |   13 +-----
 drivers/target/target_core_fabric_configfs.c  |   12 ++++-
 drivers/target/target_core_internal.h         |    2=20
 drivers/target/target_core_tpg.c              |   10 ----
 drivers/vhost/vhost.c                         |    2=20
 fs/direct-io.c                                |    2=20
 fs/ext4/balloc.c                              |   13 ++++--
 fs/ext4/mballoc.c                             |    6 +-
 fs/ext4/xattr.c                               |    7 +--
 fs/fuse/dir.c                                 |    9 +++-
 fs/nfsd/nfs4state.c                           |    2=20
 fs/ocfs2/aops.c                               |    2=20
 fs/ocfs2/suballoc.c                           |    7 +--
 fs/ocfs2/suballoc.h                           |    2=20
 fs/ocfs2/xattr.c                              |    2=20
 fs/pstore/platform.c                          |   35 ++++++++++++++---
 include/linux/auto_fs.h                       |   25 +++---------
 include/linux/pstore.h                        |    6 ++
 include/linux/quota.h                         |    1=20
 kernel/cgroup.c                               |    8 +++
 kernel/cpuset.c                               |   12 ++++-
 kernel/posix-timers.c                         |    7 +++
 kernel/sysctl_binary.c                        |    3 -
 kernel/trace/ftrace.c                         |   46 +++++++++++++++-------
 lib/idr.c                                     |    9 +++-
 net/sunrpc/svc_xprt.c                         |   15 -------
 sound/pci/hda/patch_hdmi.c                    |    3 +
 tools/perf/Makefile                           |    4 -
 tools/perf/util/parse-events.y                |    1=20
 tools/perf/util/pmu.y                         |    1=20
 52 files changed, 318 insertions(+), 179 deletions(-)

Alexey Klimov (1):
      usb hid quirks for Masterkit MA901 usb radio

Dan Carpenter (1):
      media: rc: unlock on error in show_protocols()

David Henningsson (1):
      ALSA: hda - hdmi: Make jacks phantom, if they're not detectable

Eryu Guan (1):
      ext4: check bh in ext4_read_block_bitmap()

Felix Fietkau (1):
      ath9k_hw: fix calibration issues on chainmask that don't include chai=
n 0

Greg Kroah-Hartman (1):
      Linux 3.4.35

H. Peter Anvin (1):
      x86: Make sure we can boot in the case the BDA contains pure garbage

Helge Deller (1):
      unbreak automounter support on 64-bit kernel with 32-bit userspace (v=
2)

Ian Abbott (3):
      staging: comedi: ni_labpc: correct differential channel sequence for =
AI commands
      staging: comedi: ni_labpc: set up command4 register *after* command3
      staging: comedi: check s->async for poll(), read() and write()

J. Bruce Fields (1):
      svcrpc: make svc_age_temp_xprts enqueue under sv_lock

James Ralston (1):
      ata_piix: Add Device IDs for Intel Wellsburg PCH

Jan Beulich (1):
      xen-blkback: do not leak mode property

Jan Kara (2):
      ocfs2: fix possible use-after-free with AIO
      fs: Fix possible use-after-free with AIO

Jeff Liu (1):
      ocfs2: fix ocfs2_init_security_and_acl() to initialize acl correctly

Joerg Roedel (1):
      iommu/amd: Initialize device table after dma_ops

Joseph Salisbury (1):
      ACPI: Add DMI entry for Sony VGN-FW41E_H

Konrad Rzeszutek Wilk (3):
      doc, xen: Mention 'earlyprintk=3Dxen' in the documentation.
      doc, kernel-parameters: Document 'console=3Dhvc<n>'
      xen/blkback: Don't trust the handle from the frontend.

Lee Jones (1):
      ab8500-chargalg: Only root should have write permission on sysfs file

Li Zefan (2):
      cpuset: fix cpuset_print_task_mems_allowed() vs rename() race
      cgroup: fix exit() vs rmdir() race

Lukas Czerner (2):
      ext4: fix xattr block allocation/release with bigalloc
      ext4: fix free clusters calculation in bigalloc filesystem

Matt Fleming (1):
      x86, efi: Make "noefi" really disable EFI runtime serivces

Michael S. Tsirkin (1):
      vhost: fix length for cross region descriptor

Miklos Szeredi (1):
      fuse: don't WARN when nlink is zero

Nicholas Bellinger (2):
      target: Fix lookup of dynamic NodeACLs during cached demo-mode operat=
ion
      target: Add missing mapped_lun bounds checking during make_mappedlun =
setup

Niu Yawei (1):
      ext4: fix race in ext4_mb_add_n_trim()

Rajanikanth H.V (1):
      ab8500_btemp: Demote initcall sequence

Seiji Aguchi (1):
      pstore: Avoid deadlock in panic and emergency-restart path

Seth Heasley (1):
      ata_piix: IDE-mode SATA patch for Intel Avoton DeviceIDs

Steven Rostedt (Red Hat) (1):
      ftrace: Call ftrace cleanup module notifier after all other notifiers

Tejun Heo (4):
      posix-timer: Don't call idr_find() with out-of-range ID
      idr: fix a subtle bug in idr_get_next()
      block: fix synchronization and limit check in blk_alloc_devt()
      firewire: add minor number range check to fw_device_init()

Theodore Ts'o (1):
      quota: autoload the quota_v2 module for QFMT_VFS_V1 quota format

Tomas Henzl (1):
      block: fix ext_devt_idr handling

Vinson Lee (1):
      perf tools: Fix build with bison 2.3 and older.

Xi Wang (1):
      sysctl: fix null checking in bin_dn_node_address()

Xiaowei.Hu (1):
      ocfs2: ac->ac_allow_chain_relink=3D0 won't disable group relink

majianpeng (1):
      nfsd: Fix memleak


--2fHTh5uZTiUOsy+g
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRM89IAAoJEDjbvchgkmk+tgUP/ikhiI0R3wxO5YlcKgS+H7qf
I5Sr8pQ7Xsu+hv9ytTlcP3O5MXaa5O2F5Mmbht3x0pZBdq7nLEXk2TydKjZtCBuN
ngve+RT0Re+DeRfqxqiYxzKRG3Efz9qDR2WHy9BChx/AlQ7BuAiJqE2CybZxU2Dv
s9USsGhFBXQNq15toWtr4SBGnts5Hcyu0YW1j29KfXTs8TRjaHRb95JTYrZ/faBr
IJwsH1LDb9NyD1/iNkYmm+8v6rlEvHxhlZuX/2doe1kQ1fQ3LtRX9tchhnPmF4Ia
DhaX+7itbIgUdPEo8gzNrpXs9MuBfjp9AwOWY2sRg8iDiQm/hI11xO8uNXfrvi6C
ffcQHoAMzSqCtoZo+bCyvMb8XQFnUb0BK7pP+vv4gShMbUwlnO/6imCKBEQ10o5Z
+c48d3zTnCihYKH6HSM+qa4UrMEkGPLO1L1wNUyYnntdWu+0WYl5hhF/T20iTX6k
6OLIUo2vNGscevTynTy9afWx1oh7q6Y/XFzVDYvFAObXMwGy8bux78FTYJhCOcGQ
Wdc1ZUQs/tHVM3VXeJUh10PMc3UdfxX3rdvsdZphNze9L9LNjCfj9YfGyG4rWAXi
2GgY9Ya+ewXnwSgRWCVDKdi3uFNfgdL09g5ElK5lhsNUQ8eMho2Giyu+38irFTiG
LQlQBdPIPyb+M3WklH5o
=4TRM
-----END PGP SIGNATURE-----

--2fHTh5uZTiUOsy+g--
