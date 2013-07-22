Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755007Ab3GVBoM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jul 2013 21:44:12 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39422 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754833Ab3GVBoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jul 2013 21:44:10 -0400
Date: Sun, 21 Jul 2013 18:44:23 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.9.11
Message-ID: <20130722014423.GA12972@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="a8Wt8u1KmwUX3Y2C"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--a8Wt8u1KmwUX3Y2C
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.9.11 kernel.

Note, this is the LAST 3.9-stable kernel.  It is now dead, end-of-life,
not to be touched by me again, please move to 3.10 now, you have been
warned.

All users of the 3.9 kernel series must upgrade.

The updated 3.9.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-3.9.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dsu=
mmary

thanks,

greg k-h

------------

 Makefile                                    |    2 -
 arch/x86/xen/time.c                         |   17 +------------
 drivers/acpi/acpica/hwxfsleep.c             |    8 ++++--
 drivers/acpi/device_pm.c                    |   23 ++++++++++++++----
 drivers/acpi/ec.c                           |    4 +++
 drivers/ata/libahci.c                       |    3 --
 drivers/block/nbd.c                         |    7 ++++-
 drivers/dma/pl330.c                         |    4 +--
 drivers/hv/ring_buffer.c                    |   10 ++++----
 drivers/hv/vmbus_drv.c                      |    2 -
 drivers/net/wireless/rtlwifi/rtl8192cu/rf.c |    2 -
 drivers/net/wireless/rtlwifi/rtl8723ae/sw.c |    6 ++--
 drivers/pci/iov.c                           |    5 +---
 drivers/pci/probe.c                         |   14 ++++++-----
 drivers/pci/xen-pcifront.c                  |    7 ++---
 drivers/pcmcia/at91_cf.c                    |    4 +--
 drivers/rtc/rtc-rv3029c2.c                  |    2 -
 drivers/usb/gadget/f_mass_storage.c         |    2 +
 drivers/usb/host/xhci-mem.c                 |    4 +++
 drivers/usb/host/xhci-plat.c                |    1=20
 fs/btrfs/ctree.c                            |    3 +-
 fs/btrfs/send.c                             |   35 +++++++++++++++++++++++=
+++++
 fs/cifs/cifs_unicode.h                      |    8 +++---
 fs/cifs/cifsencrypt.c                       |    6 ++--
 fs/cifs/file.c                              |    9 +++----
 fs/cifs/inode.c                             |    5 ++++
 fs/ext3/namei.c                             |    7 +----
 fs/ext4/extents.c                           |    4 +--
 fs/ext4/file.c                              |   14 +++++------
 fs/ext4/inline.c                            |    2 -
 fs/ext4/inode.c                             |    4 +--
 fs/ext4/mballoc.c                           |   11 ++++++--
 fs/ext4/namei.c                             |    7 +----
 fs/ext4/resize.c                            |    4 ---
 fs/jbd2/journal.c                           |    3 +-
 fs/jbd2/transaction.c                       |    2 -
 fs/ocfs2/xattr.c                            |   10 ++++++++
 include/linux/nbd.h                         |    1=20
 kernel/cgroup.c                             |   25 +++++++++++++++-----
 kernel/irq/manage.c                         |    6 ++--
 kernel/timer.c                              |    8 ++++--
 mm/memcontrol.c                             |    8 ------
 mm/page_alloc.c                             |    4 +++
 43 files changed, 195 insertions(+), 118 deletions(-)

Al Viro (1):
      ext3,ext4: don't mess with dir_file->f_pos in htree_dirblock_to_tree()

Axel Lin (1):
      drivers/rtc/rtc-rv3029c2.c: fix disabling AIE irq

Bart Van Assche (1):
      timer: Fix jiffies wrap behavior of round_jiffies_common()

Bartlomiej Zolnierkiewicz (1):
      drivers/dma/pl330.c: fix locking in pl330_free_chan_resources()

Ben Hutchings (1):
      genirq: Fix can_request_irq() for IRQs without an action

George Cherian (1):
      usb: host: xhci-plat: release mem region while removing module

Greg Kroah-Hartman (1):
      Linux 3.9.11

Jan Kara (4):
      ext4: fix data offset overflow on 32-bit archs in ext4_inline_data_fi=
emap()
      ext4: fix overflows in SEEK_HOLE, SEEK_DATA implementations
      ext4: fix data offset overflow in ext4_xattr_fiemap() on 32-bit archs
      ext4: fix overflow when counting used blocks on 32-bit architectures

Jason Wang (1):
      drivers: hv: switch to use mb() instead of smp_mb()

Jiang Liu (1):
      PCI: Fix refcount issue in pci_create_root_bus() error recovery path

Joachim Eastwood (1):
      pcmcia: at91_cf: fix gpio_get_value in at91_cf_get_status

Josef Bacik (2):
      Btrfs: fix estale with btrfs send
      Btrfs: only do the tree_mod_log_free_eb if this is our last ref

Junxiao Bi (1):
      ocfs2: xattr: fix inlined xattr reflink

Konrad Rzeszutek Wilk (1):
      xen/pcifront: Deal with toolstack missing 'XenbusStateClosing' state.

Lan Tianyu (1):
      ACPI / EC: Add HP Folio 13 to ec_dmi_table in order to skip DSDT scan

Larry Finger (2):
      rtlwifi: rtl8723ae: Fix typo in firmware names
      rtlwifi: rtl8192cu: Fix duplicate if test

Laszlo Ersek (1):
      xen/time: remove blocked time accounting from xen "clockchip"

Li Zefan (1):
      cgroup: fix umount vs cgroup_event_remove() race

Lv Zheng (1):
      ACPICA: Do not use extended sleep registers unless HW-reduced bit is =
set

Maarten ter Huurne (1):
      ext4: fix corruption when online resizing a fs with 1K block size

Mathias Nyman (1):
      xhci: check for failed dma pool allocation

Michal Hocko (1):
      memcg, kmem: fix reference count handling on the error path

Paul Clements (1):
      nbd: correct disconnect behavior

Pavel Shilovsky (1):
      CIFS: Fix a deadlock when a file is reopened

Rafael J. Wysocki (1):
      ACPI / PM: Fix corner case in acpi_bus_update_power()

Shane Huang (1):
      ahci: remove pmp link online check in FBS EH

Steve French (2):
      CIFS use sensible file nlink values if unprovided
      Handle big endianness in NTLM (ntlmv2) authentication

Theodore Ts'o (3):
      jbd2: move superblock checksum calculation to jbd2_write_superblock()
      jbd2: fix theoretical race in jbd2__journal_restart
      ext4: don't allow ext4_free_blocks() to fail due to ENOMEM

UCHINO Satoshi (1):
      usb: gadget: f_mass_storage: add missing memory barrier for thread_wa=
keup_needed

Wanpeng Li (1):
      mm/memory-hotplug: fix lowmem count overflow when offline pages

Xudong Hao (1):
      PCI: Finish SR-IOV VF setup before adding the device


--a8Wt8u1KmwUX3Y2C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR7I53AAoJEDjbvchgkmk+MNkP/0yt/3clQ5CKxbvLyeRu8Xbf
W45akcFLOmB+mLlFCKCSXxFTbSRuauvZtnlj8isMv+8g1socZ1h4g/QZd+VbEVo/
a9FpMvgHm6v+NwPATTiKiche3VgMoj7JVHhHjxRQiI4+jvuElBSklcG1Tk2E22Zb
6Q8AVkoER5wt/tdAIDNrYpiKskk2cyIqa4gZMJQ1piVDI6QAtAYGBDs4XeyIMaB8
CiCbcTeuCNJpXKUeJ9jjHoyea5YGl56CPgpU57tmNGjas5RHIJkZyje9orwun/9a
NqRrPcliVrWqA6zVeBgWFbV4RajUVSHiHtSh7IlofYsN/o8OLy39FXB6BinjvN4P
9931nCWkT/mj/OxpMkkj/uQNRDnLojMP25S33Ql2EndDrglL5WMMr8ntDVZJ3kbu
T1CxUlkzzPVit+1z+kbeaTsnj1/nB6bx+YPThgushoBsli9oGNUhTCfE/ve+9zv4
Zzl624RYSwooXNBva+hJmgIjlqpR+6xWdLsP8LStzwD6prlYo/2ekmuSlylTZdqj
KHL0hJheZBQeynNxTRcjNQeivRti8nSvDBy2Q582CQk7Gd4e3QQkLOxicGzGWs06
D2xuRNE78HZCRLFhIhFqMnjjEwyozOLOmGIkDdyjgQLduih1SYgYAqjueaVjqtcr
QW6b+mN4CXOI+KCJs8Gh
=/k69
-----END PGP SIGNATURE-----

--a8Wt8u1KmwUX3Y2C--
