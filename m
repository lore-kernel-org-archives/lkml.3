Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754702Ab3CCWcE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 17:32:04 -0500
Received: from mail-pb0-f42.google.com ([209.85.160.42]:51399 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754544Ab3CCWcB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 17:32:01 -0500
Date: Mon, 4 Mar 2013 06:32:15 +0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.8.2
Message-ID: <20130303223215.GA22949@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="n8g4imXOkfNTN/H1"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--n8g4imXOkfNTN/H1
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.8.2 kernel.

All users of the 3.8 kernel series must upgrade.

The updated 3.8.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-3.8.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dsu=
mmary

thanks,

greg k-h

------------

 Documentation/kernel-parameters.txt          |    5=20
 Makefile                                     |    2=20
 arch/x86/boot/compressed/eboot.c             |   26 +++-
 arch/x86/kernel/apic/apic.c                  |    2=20
 arch/x86/kernel/head.c                       |   53 ++++++---
 arch/x86/platform/efi/efi.c                  |    5=20
 block/genhd.c                                |   15 +-
 block/partition-generic.c                    |    2=20
 drivers/acpi/Kconfig                         |    3=20
 drivers/acpi/sleep.c                         |    8 +
 drivers/ata/ahci.c                           |   24 ++++
 drivers/ata/ata_piix.c                       |   17 +++
 drivers/block/nbd.c                          |   10 +
 drivers/block/xen-blkback/blkback.c          |    7 -
 drivers/block/xen-blkback/xenbus.c           |   49 ++++-----
 drivers/block/xen-blkfront.c                 |   13 +-
 drivers/firewire/core-device.c               |    4=20
 drivers/firmware/efivars.c                   |  144 ++++++++++++++++++++++=
+++--
 drivers/hid/hid-core.c                       |    2=20
 drivers/hid/hid-ids.h                        |    4=20
 drivers/hid/hid-sony.c                       |   18 ++-
 drivers/infiniband/ulp/srp/ib_srp.c          |   42 ++++---
 drivers/infiniband/ulp/srp/ib_srp.h          |    1=20
 drivers/iommu/amd_iommu_init.c               |   10 -
 drivers/media/pci/cx18/cx18-alsa-main.c      |    2=20
 drivers/media/pci/cx18/cx18-alsa-pcm.h       |    2=20
 drivers/media/pci/ivtv/ivtv-alsa-main.c      |    2=20
 drivers/media/pci/ivtv/ivtv-alsa-pcm.h       |    2=20
 drivers/media/platform/omap/omap_vout.c      |   12 +-
 drivers/media/rc/rc-main.c                   |    4=20
 drivers/media/v4l2-core/v4l2-device.c        |   30 ++---
 drivers/net/wireless/b43/main.c              |    3=20
 drivers/power/ab8500_btemp.c                 |    2=20
 drivers/power/abx500_chargalg.c              |    2=20
 drivers/power/bq27x00_battery.c              |    2=20
 drivers/staging/comedi/comedi_fops.c         |    8 -
 drivers/target/target_core_device.c          |   13 --
 drivers/target/target_core_fabric_configfs.c |   12 +-
 drivers/target/target_core_internal.h        |    2=20
 drivers/target/target_core_tpg.c             |   10 -
 drivers/usb/dwc3/core.h                      |    2=20
 drivers/usb/dwc3/gadget.c                    |   98 ++++++++++++------
 fs/direct-io.c                               |    2=20
 fs/ext4/balloc.c                             |   13 +-
 fs/ext4/extents.c                            |   25 ++--
 fs/ext4/indirect.c                           |    9 +
 fs/ext4/inline.c                             |    2=20
 fs/ext4/inode.c                              |   11 --
 fs/ext4/mballoc.c                            |    6 -
 fs/ext4/mmp.c                                |    2=20
 fs/ext4/page-io.c                            |    9 -
 fs/ext4/resize.c                             |    8 -
 fs/ext4/super.c                              |   12 +-
 fs/ext4/xattr.c                              |   10 +
 fs/fuse/dir.c                                |    9 +
 fs/nfsd/nfs4state.c                          |    2=20
 fs/ocfs2/aops.c                              |    2=20
 fs/ocfs2/suballoc.c                          |    7 -
 fs/ocfs2/suballoc.h                          |    2=20
 fs/ocfs2/xattr.c                             |    2=20
 fs/pstore/platform.c                         |   35 +++++-
 fs/ubifs/orphan.c                            |   12 +-
 fs/ubifs/ubifs.h                             |    6 -
 fs/xfs/xfs_bmap.c                            |  114 +++++++++++++++++----
 include/linux/llist.h                        |   25 ----
 include/linux/pstore.h                       |    6 +
 include/linux/quota.h                        |    1=20
 kernel/cgroup.c                              |    8 +
 kernel/cpuset.c                              |   12 +-
 kernel/posix-timers.c                        |    7 +
 kernel/sysctl_binary.c                       |    3=20
 kernel/trace/ftrace.c                        |   46 ++++++--
 kernel/workqueue.c                           |   36 +++++-
 lib/idr.c                                    |    9 +
 mm/mmap.c                                    |   27 +++++
 net/sunrpc/svc.c                             |    9 -
 net/sunrpc/svc_xprt.c                        |   72 ++++++-------
 sound/pci/bt87x.c                            |   19 +++
 sound/pci/emu10k1/emu10k1_main.c             |    6 +
 sound/pci/hda/patch_hdmi.c                   |    3=20
 80 files changed, 887 insertions(+), 376 deletions(-)

Adam Thomas (2):
      UBIFS: fix use of freed ubifs_orphan objects
      UBIFS: fix double free of ubifs_orphan objects

Al Viro (1):
      media: omap_vout: find_vma() needs ->mmap_sem held

Alexey Klimov (1):
      usb hid quirks for Masterkit MA901 usb radio

Bart Van Assche (4):
      IB/srp: Track connection state properly
      IB/srp: Avoid sending a task management function needlessly
      IB/srp: Avoid endless SCSI error handling loop
      IB/srp: Fail I/O requests if the transport is offline

Dan Carpenter (1):
      media: rc: unlock on error in show_protocols()

Dave Chinner (1):
      xfs: xfs_bmap_add_attrfork_local is too generic

David Henningsson (1):
      ALSA: hda - hdmi: Make jacks phantom, if they're not detectable

Eryu Guan (1):
      ext4: check bh in ext4_read_block_bitmap()

Felipe Balbi (1):
      usb: dwc3: gadget: change HIRD threshold to 12

Fernando Luis V=E1zquez Cao (2):
      HID: add support for Sony RF receiver with USB product id 0x0374
      HID: clean up quirk for Sony RF receivers

Florian Zeitz (1):
      ALSA: emu10k1: Load firmware when it was already cached

Greg Kroah-Hartman (1):
      Linux 3.8.2

H. Peter Anvin (1):
      x86: Make sure we can boot in the case the BDA contains pure garbage

Hans Verkuil (1):
      media: cx18/ivtv: fix regression: remove __init from a non-init funct=
ion

Ian Abbott (1):
      staging: comedi: check s->async for poll(), read() and write()

J. Bruce Fields (2):
      svcrpc: make svc_age_temp_xprts enqueue under sv_lock
      svcrpc: fix rpc server shutdown races

James Ralston (2):
      ata_piix: Add Device IDs for Intel Wellsburg PCH
      ahci: Add Device IDs for Intel Wellsburg PCH

Jan Beulich (1):
      xen-blkback: do not leak mode property

Jan Kara (3):
      ocfs2: fix possible use-after-free with AIO
      fs: Fix possible use-after-free with AIO
      ext4: fix possible use-after-free with AIO

Jeff Liu (1):
      ocfs2: fix ocfs2_init_security_and_acl() to initialize acl correctly

Joerg Roedel (1):
      iommu/amd: Initialize device table after dma_ops

Joseph Salisbury (1):
      ACPI: Add DMI entry for Sony VGN-FW41E_H

Konrad Rzeszutek Wilk (4):
      doc, xen: Mention 'earlyprintk=3Dxen' in the documentation.
      doc, kernel-parameters: Document 'console=3Dhvc<n>'
      xen/blkback: Don't trust the handle from the frontend.
      xen-blkfront: drop the use of llist_for_each_entry_safe

Larry Finger (1):
      b43: Fix lockdep splat on module unload

Laurent Pinchart (1):
      media: v4l: Reset subdev v4l2_dev field to NULL if registration fails

Lee Jones (1):
      ab8500-chargalg: Only root should have write permission on sysfs file

Lee, Chun-Yi (1):
      x86, efi: Allow slash in file path of initrd

Li Zefan (2):
      cpuset: fix cpuset_print_task_mems_allowed() vs rename() race
      cgroup: fix exit() vs rmdir() race

Linus Torvalds (1):
      mm: do not grow the stack vma just because of an overrun on preceding=
 vma

Lukas Czerner (2):
      ext4: fix xattr block allocation/release with bigalloc
      ext4: fix free clusters calculation in bigalloc filesystem

Mathias Krause (1):
      x86/apic: Fix parsing of the 'lapic' cmdline option

Matt Fleming (3):
      x86, efi: Make "noefi" really disable EFI runtime serivces
      efivarfs: Validate filenames much more aggressively
      efivarfs: guid part of filenames are case-insensitive

Mihail Zenkov (1):
      ALSA: emu10k1: Fix regression in emu1010 firmware loading

Miklos Szeredi (1):
      fuse: don't WARN when nlink is zero

NeilBrown (1):
      bq27x00_battery: Fix bugs introduced with BQ27425 support

Nicholas Bellinger (2):
      target: Fix lookup of dynamic NodeACLs during cached demo-mode operat=
ion
      target: Add missing mapped_lun bounds checking during make_mappedlun =
setup

Niu Yawei (1):
      ext4: fix race in ext4_mb_add_n_trim()

Paolo Bonzini (1):
      nbd: fsync and kill block device on shutdown

Pratyush Anand (4):
      usb: dwc3: Enable usb2 LPM only when connected as usb2.0
      usb: dwc3: gadget: fix missed isoc
      usb: dwc3: gadget: fix isoc END TRANSFER Condition
      usb: dwc3: gadget: fix skip LINK_TRB on ISOC

Rajanikanth H.V (1):
      ab8500_btemp: Demote initcall sequence

Roger Pau Monne (1):
      xen-blkback: use balloon pages for persistent grants

Seiji Aguchi (1):
      pstore: Avoid deadlock in panic and emergency-restart path

Seth Heasley (2):
      ata_piix: IDE-mode SATA patch for Intel Avoton DeviceIDs
      ahci: AHCI-mode SATA patch for Intel Avoton DeviceIDs

Steven Rostedt (Red Hat) (1):
      ftrace: Call ftrace cleanup module notifier after all other notifiers

Takashi Iwai (1):
      ALSA: bt87x: Make load_all parameter working again

Tejun Heo (5):
      posix-timer: Don't call idr_find() with out-of-range ID
      idr: fix a subtle bug in idr_get_next()
      block: fix synchronization and limit check in blk_alloc_devt()
      firewire: add minor number range check to fw_device_init()
      workqueue: consider work function when searching for busy work items

Theodore Ts'o (3):
      quota: autoload the quota_v2 module for QFMT_VFS_V1 quota format
      ext4: return ENOMEM if sb_getblk() fails
      ext4: release sysfs kobject when failing to enable quotas on mount

Thomas Renninger (1):
      ACPI: Overriding ACPI tables via initrd only works with an initrd and=
 on X86

Tomas Henzl (1):
      block: fix ext_devt_idr handling

Xi Wang (1):
      sysctl: fix null checking in bin_dn_node_address()

Xiaowei.Hu (1):
      ocfs2: ac->ac_allow_chain_relink=3D0 won't disable group relink

majianpeng (1):
      nfsd: Fix memleak


--n8g4imXOkfNTN/H1
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRM89vAAoJEDjbvchgkmk+stsQAIVmCIJdaIKbH1oZbYBphpFl
rnijLj7p/Js3s2by0EfKCNnASWLsRg4gAVYK8gVePOdpr95o7RYCFwNYNqDMhJ/8
Il9BM24GJNvd2rW5GcqhztgF+5mqbXwTf7ZhcAVBj2yi+wQd99yMF0eeGjbOEE59
YtWBNgEua8w1amnTqafA5fGIjA5948DqQYJtIajqq+Vf1F3tjpqAd1iKOBObfNfN
xxFFvekMNiZ62EiLBrqtLcomEUDEsAz5/ygqDFMavwRTj+DxPclWiABfsFKBjy8M
g3RN8FOrGGSv9Cg9C7PkxSA/x9N8f76ZhUSdMznDYF23uLNorKKnv23moQgLHu+p
AJ62ZC38uewZ/OYhxwcyz8iYiTvAcR3Crs4DD3tJN3TFU1hQIm7SB0Et3Fz3iDEO
Cm9kld2ifAUnK4eZGZ5j/CAvZYOafJo1RfPgrzv2tM8xgoj00/7AKLHKJu9f9Ahh
na2cKfrrOmU9vdiw2rTl494uD07X72NgmWD3BYD+ztMOWh36ZtvzjsoK/ir0Dz+b
eeoQNMGriioi6OKvy4rgcPcAYrd0SAAakrn4XH/GSyI1csTeeBXwCDzvewEXacFA
72SyNA6v+DeeQwsga9/KaVqkHGWbQ0nLcW8KYtl1VSGRu48QMy1cnb7aq59dm8V3
j0+357jmI7IzuQLrBLtX
=CINz
-----END PGP SIGNATURE-----

--n8g4imXOkfNTN/H1--
