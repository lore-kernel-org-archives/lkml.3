Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755088Ab3CAUHZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 15:07:25 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:51654 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753496Ab3CATqA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 14:46:00 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: [ 00/46] 3.4.35-stable review
Date: Fri,  1 Mar 2013 11:44:48 -0800
Message-Id: <20130301194432.263409302@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.4.35 release.
There are 46 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun Mar  3 19:44:00 UTC 2013.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.35-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.4.35-rc1

Alexey Klimov <klimov.linux@gmail.com>
    usb hid quirks for Masterkit MA901 usb radio

James Ralston <james.d.ralston@intel.com>
    ata_piix: Add Device IDs for Intel Wellsburg PCH

Seth Heasley <seth.heasley@intel.com>
    ata_piix: IDE-mode SATA patch for Intel Avoton DeviceIDs

Vinson Lee <vlee@twitter.com>
    perf tools: Fix build with bison 2.3 and older.

Ian Abbott <abbotti@mev.co.uk>
    staging: comedi: check s->async for poll(), read() and write()

Ian Abbott <abbotti@mev.co.uk>
    staging: comedi: ni_labpc: set up command4 register *after* command3

Ian Abbott <abbotti@mev.co.uk>
    staging: comedi: ni_labpc: correct differential channel sequence for AI commands

Joseph Salisbury <joseph.salisbury@canonical.com>
    ACPI: Add DMI entry for Sony VGN-FW41E_H

Rajanikanth H.V <rajanikanth.hv@stericsson.com>
    ab8500_btemp: Demote initcall sequence

Lee Jones <lee.jones@linaro.org>
    ab8500-chargalg: Only root should have write permission on sysfs file

Li Zefan <lizefan@huawei.com>
    cgroup: fix exit() vs rmdir() race

Li Zefan <lizefan@huawei.com>
    cpuset: fix cpuset_print_task_mems_allowed() vs rename() race

Seiji Aguchi <seiji.aguchi@hds.com>
    pstore: Avoid deadlock in panic and emergency-restart path

Felix Fietkau <nbd@openwrt.org>
    ath9k_hw: fix calibration issues on chainmask that don't include chain 0

Helge Deller <deller@gmx.de>
    unbreak automounter support on 64-bit kernel with 32-bit userspace (v2)

Miklos Szeredi <mszeredi@suse.cz>
    fuse: don't WARN when nlink is zero

Michael S. Tsirkin <mst@redhat.com>
    vhost: fix length for cross region descriptor

J. Bruce Fields <bfields@redhat.com>
    svcrpc: make svc_age_temp_xprts enqueue under sv_lock

majianpeng <majianpeng@gmail.com>
    nfsd: Fix memleak

Lukas Czerner <lczerner@redhat.com>
    ext4: fix free clusters calculation in bigalloc filesystem

Lukas Czerner <lczerner@redhat.com>
    ext4: fix xattr block allocation/release with bigalloc

Niu Yawei <yawei.niu@gmail.com>
    ext4: fix race in ext4_mb_add_n_trim()

Eryu Guan <guaneryu@gmail.com>
    ext4: check bh in ext4_read_block_bitmap()

Dan Carpenter <dan.carpenter@oracle.com>
    media: rc: unlock on error in show_protocols()

Jan Kara <jack@suse.cz>
    fs: Fix possible use-after-free with AIO

Xi Wang <xi.wang@gmail.com>
    sysctl: fix null checking in bin_dn_node_address()

Tejun Heo <tj@kernel.org>
    firewire: add minor number range check to fw_device_init()

Tejun Heo <tj@kernel.org>
    block: fix synchronization and limit check in blk_alloc_devt()

Tejun Heo <tj@kernel.org>
    idr: fix a subtle bug in idr_get_next()

Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
    xen/blkback: Don't trust the handle from the frontend.

Jan Beulich <JBeulich@suse.com>
    xen-blkback: do not leak mode property

Tomas Henzl <thenzl@redhat.com>
    block: fix ext_devt_idr handling

Xiaowei.Hu <xiaowei.hu@oracle.com>
    ocfs2: ac->ac_allow_chain_relink=0 won't disable group relink

Jeff Liu <jeff.liu@oracle.com>
    ocfs2: fix ocfs2_init_security_and_acl() to initialize acl correctly

Jan Kara <jack@suse.cz>
    ocfs2: fix possible use-after-free with AIO

Nicholas Bellinger <nab@linux-iscsi.org>
    target: Add missing mapped_lun bounds checking during make_mappedlun setup

Nicholas Bellinger <nab@linux-iscsi.org>
    target: Fix lookup of dynamic NodeACLs during cached demo-mode operation

H. Peter Anvin <hpa@linux.intel.com>
    x86: Make sure we can boot in the case the BDA contains pure garbage

Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
    doc, kernel-parameters: Document 'console=hvc<n>'

Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
    doc, xen: Mention 'earlyprintk=xen' in the documentation.

Matt Fleming <matt.fleming@intel.com>
    x86, efi: Make "noefi" really disable EFI runtime serivces

Steven Rostedt (Red Hat) <rostedt@goodmis.org>
    ftrace: Call ftrace cleanup module notifier after all other notifiers

Tejun Heo <tj@kernel.org>
    posix-timer: Don't call idr_find() with out-of-range ID

Joerg Roedel <joro@8bytes.org>
    iommu/amd: Initialize device table after dma_ops

Theodore Ts'o <tytso@mit.edu>
    quota: autoload the quota_v2 module for QFMT_VFS_V1 quota format

David Henningsson <david.henningsson@canonical.com>
    ALSA: hda - hdmi: Make jacks phantom, if they're not detectable


-------------

Diffstat:

 Documentation/kernel-parameters.txt           |  5 +++
 Makefile                                      |  4 +-
 arch/x86/kernel/head.c                        | 53 +++++++++++++++++----------
 arch/x86/platform/efi/efi.c                   |  5 ++-
 block/genhd.c                                 | 15 ++++----
 block/partition-generic.c                     |  2 +-
 drivers/acpi/sleep.c                          |  8 ++++
 drivers/ata/ata_piix.c                        | 17 +++++++++
 drivers/block/xen-blkback/blkback.c           |  1 -
 drivers/block/xen-blkback/xenbus.c            | 49 ++++++++++++-------------
 drivers/firewire/core-device.c                |  4 ++
 drivers/hid/hid-core.c                        |  1 +
 drivers/hid/hid-ids.h                         |  3 ++
 drivers/iommu/amd_iommu_init.c                |  9 ++++-
 drivers/media/rc/rc-main.c                    |  4 +-
 drivers/net/wireless/ath/ath9k/ar9003_calib.c |  2 +
 drivers/net/wireless/ath/ath9k/ar9003_phy.c   |  2 +-
 drivers/net/wireless/ath/ath9k/hw.h           |  1 +
 drivers/power/ab8500_btemp.c                  |  2 +-
 drivers/power/abx500_chargalg.c               |  2 +-
 drivers/staging/comedi/comedi_fops.c          |  8 ++--
 drivers/staging/comedi/drivers/ni_labpc.c     | 35 ++++++++++--------
 drivers/target/target_core_device.c           | 13 ++-----
 drivers/target/target_core_fabric_configfs.c  | 12 +++++-
 drivers/target/target_core_internal.h         |  2 +-
 drivers/target/target_core_tpg.c              | 10 +----
 drivers/vhost/vhost.c                         |  2 +-
 fs/direct-io.c                                |  2 +-
 fs/ext4/balloc.c                              | 13 +++++--
 fs/ext4/mballoc.c                             |  6 +--
 fs/ext4/xattr.c                               |  7 ++--
 fs/fuse/dir.c                                 |  9 ++++-
 fs/nfsd/nfs4state.c                           |  2 +
 fs/ocfs2/aops.c                               |  2 +-
 fs/ocfs2/suballoc.c                           |  7 ++--
 fs/ocfs2/suballoc.h                           |  2 +-
 fs/ocfs2/xattr.c                              |  2 +-
 fs/pstore/platform.c                          | 35 +++++++++++++++---
 include/linux/auto_fs.h                       | 25 ++++---------
 include/linux/pstore.h                        |  6 +++
 include/linux/quota.h                         |  1 +
 kernel/cgroup.c                               |  8 ++++
 kernel/cpuset.c                               | 12 +++++-
 kernel/posix-timers.c                         |  7 ++++
 kernel/sysctl_binary.c                        |  3 +-
 kernel/trace/ftrace.c                         | 46 ++++++++++++++++-------
 lib/idr.c                                     |  9 ++++-
 net/sunrpc/svc_xprt.c                         | 15 +-------
 sound/pci/hda/patch_hdmi.c                    |  3 ++
 tools/perf/Makefile                           |  4 +-
 tools/perf/util/parse-events.y                |  1 -
 tools/perf/util/pmu.y                         |  1 -
 52 files changed, 319 insertions(+), 180 deletions(-)


