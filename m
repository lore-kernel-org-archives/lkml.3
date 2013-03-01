Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752347Ab3CATpK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 14:45:10 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:51290 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192Ab3CATpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 14:45:05 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: [ 00/77] 3.8.2-stable review
Date: Fri,  1 Mar 2013 11:43:45 -0800
Message-Id: <20130301194351.913471337@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
User-Agent: quilt/0.60-2.1.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.8.2 release.
There are 77 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun Mar  3 19:42:25 UTC 2013.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.8.2-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.8.2-rc1

Matt Fleming <matt.fleming@intel.com>
    efivarfs: guid part of filenames are case-insensitive

Matt Fleming <matt.fleming@intel.com>
    efivarfs: Validate filenames much more aggressively

Thomas Renninger <trenn@suse.de>
    ACPI: Overriding ACPI tables via initrd only works with an initrd and on X86

Lee, Chun-Yi <joeyli.kernel@gmail.com>
    x86, efi: Allow slash in file path of initrd

Alexey Klimov <klimov.linux@gmail.com>
    usb hid quirks for Masterkit MA901 usb radio

James Ralston <james.d.ralston@intel.com>
    ahci: Add Device IDs for Intel Wellsburg PCH

Seth Heasley <seth.heasley@intel.com>
    ahci: AHCI-mode SATA patch for Intel Avoton DeviceIDs

James Ralston <james.d.ralston@intel.com>
    ata_piix: Add Device IDs for Intel Wellsburg PCH

Seth Heasley <seth.heasley@intel.com>
    ata_piix: IDE-mode SATA patch for Intel Avoton DeviceIDs

Ian Abbott <abbotti@mev.co.uk>
    staging: comedi: check s->async for poll(), read() and write()

Joseph Salisbury <joseph.salisbury@canonical.com>
    ACPI: Add DMI entry for Sony VGN-FW41E_H

Rajanikanth H.V <rajanikanth.hv@stericsson.com>
    ab8500_btemp: Demote initcall sequence

Lee Jones <lee.jones@linaro.org>
    ab8500-chargalg: Only root should have write permission on sysfs file

NeilBrown <neilb@suse.de>
    bq27x00_battery: Fix bugs introduced with BQ27425 support

Li Zefan <lizefan@huawei.com>
    cgroup: fix exit() vs rmdir() race

Li Zefan <lizefan@huawei.com>
    cpuset: fix cpuset_print_task_mems_allowed() vs rename() race

Seiji Aguchi <seiji.aguchi@hds.com>
    pstore: Avoid deadlock in panic and emergency-restart path

Tejun Heo <tj@kernel.org>
    workqueue: consider work function when searching for busy work items

Miklos Szeredi <mszeredi@suse.cz>
    fuse: don't WARN when nlink is zero

Fernando Luis Vázquez Cao <fernando_b1@lab.ntt.co.jp>
    HID: clean up quirk for Sony RF receivers

Fernando Luis Vázquez Cao <fernando_b1@lab.ntt.co.jp>
    HID: add support for Sony RF receiver with USB product id 0x0374

J. Bruce Fields <bfields@redhat.com>
    svcrpc: fix rpc server shutdown races

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

Theodore Ts'o <tytso@mit.edu>
    ext4: release sysfs kobject when failing to enable quotas on mount

Eryu Guan <guaneryu@gmail.com>
    ext4: check bh in ext4_read_block_bitmap()

Theodore Ts'o <tytso@mit.edu>
    ext4: return ENOMEM if sb_getblk() fails

Dan Carpenter <dan.carpenter@oracle.com>
    media: rc: unlock on error in show_protocols()

Al Viro <viro@ZenIV.linux.org.uk>
    media: omap_vout: find_vma() needs ->mmap_sem held

Laurent Pinchart <laurent.pinchart@ideasonboard.com>
    media: v4l: Reset subdev v4l2_dev field to NULL if registration fails

Hans Verkuil <hans.verkuil@cisco.com>
    media: cx18/ivtv: fix regression: remove __init from a non-init function

Jan Kara <jack@suse.cz>
    ext4: fix possible use-after-free with AIO

Jan Kara <jack@suse.cz>
    fs: Fix possible use-after-free with AIO

Paolo Bonzini <pbonzini@redhat.com>
    nbd: fsync and kill block device on shutdown

Xi Wang <xi.wang@gmail.com>
    sysctl: fix null checking in bin_dn_node_address()

Tejun Heo <tj@kernel.org>
    firewire: add minor number range check to fw_device_init()

Tejun Heo <tj@kernel.org>
    block: fix synchronization and limit check in blk_alloc_devt()

Tejun Heo <tj@kernel.org>
    idr: fix a subtle bug in idr_get_next()

Roger Pau Monne <roger.pau@citrix.com>
    xen-blkback: use balloon pages for persistent grants

Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
    xen-blkfront: drop the use of llist_for_each_entry_safe

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

Mathias Krause <minipli@googlemail.com>
    x86/apic: Fix parsing of the 'lapic' cmdline option

Steven Rostedt (Red Hat) <rostedt@goodmis.org>
    ftrace: Call ftrace cleanup module notifier after all other notifiers

Tejun Heo <tj@kernel.org>
    posix-timer: Don't call idr_find() with out-of-range ID

Joerg Roedel <joro@8bytes.org>
    iommu/amd: Initialize device table after dma_ops

Adam Thomas <adamthomas1111@gmail.com>
    UBIFS: fix double free of ubifs_orphan objects

Adam Thomas <adamthomas1111@gmail.com>
    UBIFS: fix use of freed ubifs_orphan objects

Larry Finger <Larry.Finger@lwfinger.net>
    b43: Fix lockdep splat on module unload

Felipe Balbi <balbi@ti.com>
    usb: dwc3: gadget: change HIRD threshold to 12

Pratyush Anand <pratyush.anand@st.com>
    usb: dwc3: gadget: fix skip LINK_TRB on ISOC

Pratyush Anand <pratyush.anand@st.com>
    usb: dwc3: gadget: fix isoc END TRANSFER Condition

Pratyush Anand <pratyush.anand@st.com>
    usb: dwc3: gadget: fix missed isoc

Pratyush Anand <pratyush.anand@st.com>
    usb: dwc3: Enable usb2 LPM only when connected as usb2.0

Theodore Ts'o <tytso@mit.edu>
    quota: autoload the quota_v2 module for QFMT_VFS_V1 quota format

Bart Van Assche <bvanassche@acm.org>
    IB/srp: Fail I/O requests if the transport is offline

Bart Van Assche <bvanassche@acm.org>
    IB/srp: Avoid endless SCSI error handling loop

Bart Van Assche <bvanassche@acm.org>
    IB/srp: Avoid sending a task management function needlessly

Bart Van Assche <bvanassche@acm.org>
    IB/srp: Track connection state properly

Florian Zeitz <florob@babelmonkeys.de>
    ALSA: emu10k1: Load firmware when it was already cached

Mihail Zenkov <mihail.zenkov@gmail.com>
    ALSA: emu10k1: Fix regression in emu1010 firmware loading

David Henningsson <david.henningsson@canonical.com>
    ALSA: hda - hdmi: Make jacks phantom, if they're not detectable

Takashi Iwai <tiwai@suse.de>
    ALSA: bt87x: Make load_all parameter working again

Linus Torvalds <torvalds@linux-foundation.org>
    mm: do not grow the stack vma just because of an overrun on preceding vma


-------------

Diffstat:

 Documentation/kernel-parameters.txt          |   5 ++
 Makefile                                     |   4 +-
 arch/x86/boot/compressed/eboot.c             |  26 ++++--
 arch/x86/kernel/apic/apic.c                  |   2 +-
 arch/x86/kernel/head.c                       |  53 +++++++----
 arch/x86/platform/efi/efi.c                  |   5 +-
 block/genhd.c                                |  15 ++--
 block/partition-generic.c                    |   2 +-
 drivers/acpi/Kconfig                         |   3 +-
 drivers/acpi/sleep.c                         |   8 ++
 drivers/ata/ahci.c                           |  24 +++++
 drivers/ata/ata_piix.c                       |  17 ++++
 drivers/block/nbd.c                          |  10 +++
 drivers/block/xen-blkback/blkback.c          |   7 +-
 drivers/block/xen-blkback/xenbus.c           |  49 +++++-----
 drivers/block/xen-blkfront.c                 |  13 ++-
 drivers/firewire/core-device.c               |   4 +
 drivers/firmware/efivars.c                   | 144 ++++++++++++++++++++++++++++--
 drivers/hid/hid-core.c                       |   2 +
 drivers/hid/hid-ids.h                        |   4 +
 drivers/hid/hid-sony.c                       |  18 +++-
 drivers/infiniband/ulp/srp/ib_srp.c          |  42 +++++----
 drivers/infiniband/ulp/srp/ib_srp.h          |   1 +
 drivers/iommu/amd_iommu_init.c               |  10 +--
 drivers/media/pci/cx18/cx18-alsa-main.c      |   2 +-
 drivers/media/pci/cx18/cx18-alsa-pcm.h       |   2 +-
 drivers/media/pci/ivtv/ivtv-alsa-main.c      |   2 +-
 drivers/media/pci/ivtv/ivtv-alsa-pcm.h       |   2 +-
 drivers/media/platform/omap/omap_vout.c      |  12 +--
 drivers/media/rc/rc-main.c                   |   4 +-
 drivers/media/v4l2-core/v4l2-device.c        |  30 +++----
 drivers/net/wireless/b43/main.c              |   3 +-
 drivers/power/ab8500_btemp.c                 |   2 +-
 drivers/power/abx500_chargalg.c              |   2 +-
 drivers/power/bq27x00_battery.c              |   2 -
 drivers/staging/comedi/comedi_fops.c         |   8 +-
 drivers/target/target_core_device.c          |  13 +--
 drivers/target/target_core_fabric_configfs.c |  12 ++-
 drivers/target/target_core_internal.h        |   2 +-
 drivers/target/target_core_tpg.c             |  10 +--
 drivers/usb/dwc3/core.h                      |   2 -
 drivers/usb/dwc3/gadget.c                    |  98 +++++++++++++-------
 fs/direct-io.c                               |   2 +-
 fs/ext4/balloc.c                             |  13 ++-
 fs/ext4/extents.c                            |  25 +++---
 fs/ext4/indirect.c                           |   9 +-
 fs/ext4/inline.c                             |   2 +-
 fs/ext4/inode.c                              |  11 +--
 fs/ext4/mballoc.c                            |   6 +-
 fs/ext4/mmp.c                                |   2 +
 fs/ext4/page-io.c                            |   9 +-
 fs/ext4/resize.c                             |   8 +-
 fs/ext4/super.c                              |  12 ++-
 fs/ext4/xattr.c                              |  10 ++-
 fs/fuse/dir.c                                |   9 +-
 fs/nfsd/nfs4state.c                          |   2 +
 fs/ocfs2/aops.c                              |   2 +-
 fs/ocfs2/suballoc.c                          |   7 +-
 fs/ocfs2/suballoc.h                          |   2 +-
 fs/ocfs2/xattr.c                             |   2 +-
 fs/pstore/platform.c                         |  35 ++++++--
 fs/ubifs/orphan.c                            |  12 ++-
 fs/ubifs/ubifs.h                             |   6 +-
 include/linux/llist.h                        |  25 ------
 include/linux/pstore.h                       |   6 ++
 include/linux/quota.h                        |   1 +
 kernel/cgroup.c                              |   8 ++
 kernel/cpuset.c                              |  12 ++-
 kernel/posix-timers.c                        |   7 ++
 kernel/sysctl_binary.c                       |   3 +-
 kernel/trace/ftrace.c                        |  46 +++++++---
 kernel/workqueue.c                           |  36 ++++++--
 lib/idr.c                                    |   9 +-
 mm/mmap.c                                    |  27 ++++++
 net/sunrpc/svc.c                             |   9 --
 net/sunrpc/svc_xprt.c                        |  72 +++++++--------
 sound/pci/bt87x.c                            |  19 +++-
 sound/pci/emu10k1/emu10k1_main.c             |   6 ++
 sound/pci/hda/patch_hdmi.c                   |   3 +
 79 files changed, 795 insertions(+), 356 deletions(-)


