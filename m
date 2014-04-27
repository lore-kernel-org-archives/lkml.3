Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753128AbaD0AiH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2014 20:38:07 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57817 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753105AbaD0AiD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2014 20:38:03 -0400
Date: Sat, 26 Apr 2014 17:38:44 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.14.2
Message-ID: <20140427003844.GA3297@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ikeVEW9yuYc//A+q"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ikeVEW9yuYc//A+q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

I'm announcing the release of the 3.14.2 kernel.

All users of the 3.14 kernel series must upgrade.

The updated 3.14.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-3.14.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                  |    2 -
 arch/x86/kernel/cpu/mshyperv.c            |    6 ++++
 arch/x86/kernel/early-quirks.c            |   15 ++++-------
 drivers/acpi/button.c                     |    4 +++
 drivers/char/ipmi/ipmi_bt_sm.c            |    2 -
 drivers/pci/host/pcie-designware.c        |    8 +++---
 drivers/scsi/sd.c                         |    4 +--
 drivers/staging/comedi/comedi_buf.c       |   37 ++++++++++++++++++++++++++-
 drivers/staging/comedi/comedi_fops.c      |   18 ++++++++++---
 drivers/staging/comedi/comedi_internal.h  |    2 +
 drivers/staging/comedi/drivers/8255_pci.c |   34 +++++++++++++++++++++++++
 drivers/tty/ipwireless/tty.c              |    3 --
 drivers/tty/tty_buffer.c                  |   20 +++------------
 drivers/tty/tty_io.c                      |   23 ++++++++++++-----
 drivers/usb/gadget/u_serial.c             |    4 +--
 fs/btrfs/disk-io.c                        |    4 +++
 fs/btrfs/extent-tree.c                    |    3 +-
 fs/btrfs/transaction.c                    |   14 +++-------
 fs/ext4/extents.c                         |   40 ++++++++++++++++++++++++++----
 fs/fs-writeback.c                         |   31 ++++++++++++++++-------
 fs/jffs2/compr_rtime.c                    |    4 +--
 fs/jffs2/nodelist.h                       |    2 -
 fs/jffs2/nodemgmt.c                       |   14 +++++++---
 fs/kernfs/dir.c                           |    2 -
 fs/kernfs/inode.c                         |   14 +++++++---
 fs/posix_acl.c                            |    5 ++-
 fs/xfs/xfs_da_btree.c                     |    2 -
 include/linux/backing-dev.h               |    2 -
 include/linux/tty.h                       |    2 -
 kernel/exit.c                             |   21 +++++++++------
 kernel/pid_namespace.c                    |    4 ++-
 kernel/user_namespace.c                   |   11 +++-----
 mm/backing-dev.c                          |   16 +++++++++---
 net/bluetooth/hci_event.c                 |    8 +++++-
 security/integrity/ima/ima.h              |    2 -
 security/integrity/ima/ima_fs.c           |    2 +
 security/integrity/ima/ima_template_lib.c |   10 +++++--
 37 files changed, 279 insertions(+), 116 deletions(-)

Ajesh Kunhipurayil Vijayan (1):
      jffs2: Fix crash due to truncation of csize

Alan Stern (1):
      SCSI: sd: don't fail if the device doesn't recognize SYNCHRONIZE CACHE

Claudio Takahasi (1):
      Bluetooth: Fix removing Long Term Key

Dan Carpenter (1):
      fs: NULL dereference in posix_acl_to_xattr()

Derek Basehore (1):
      backing_dev: fix hung task on sync

Eric Whitney (3):
      ext4: fix error return from ext4_ext_handle_uninitialized_extents()
      ext4: fix partial cluster handling for bigalloc file systems
      ext4: fix premature freeing of partial clusters split across leaf blocks

Greg Kroah-Hartman (1):
      Linux 3.14.2

Hannes Reinecke (1):
      tty: Set correct tty name in 'active' sysfs attribute

Hidetoshi Seto (1):
      Btrfs: skip submitting barrier for missing device

Ian Abbott (2):
      staging: comedi: 8255_pci: initialize MITE data window
      staging: comedi: fix circular locking dependency in comedi_mmap()

Jan Kara (1):
      bdi: avoid oops on device removal

Jason Wang (1):
      x86, hyperv: Bypass the timer_irq_works() check

Jiri Slaby (1):
      Char: ipmi_bt_sm, fix infinite loop

Josef Bacik (2):
      Btrfs: fix deadlock with nested trans handles
      Btrfs: check for an extent_op on the locked ref

Kamlakant Patel (1):
      jffs2: Fix segmentation fault found in stress test

Lan Tianyu (1):
      ACPI / button: Add ACPI Button event via netlink routine

Li Zefan (2):
      jffs2: avoid soft-lockup in jffs2_reserve_space_gc()
      jffs2: remove from wait queue after schedule()

Mark Tinguely (1):
      xfs: fix directory hash ordering bug

Mikulas Patocka (1):
      user namespace: fix incorrect memory barriers

Mohit Kumar (2):
      PCI: designware: Fix RC BAR to be single 64-bit non-prefetchable memory BAR
      PCI: designware: Fix iATU programming for cfg1, io and mem viewport

Neil Horman (1):
      x86: Adjust irq remapping quirk for older revisions of 5500/5520 chipsets

Oleg Nesterov (3):
      pid_namespace: pidns_get() should check task_active_pid_ns() != NULL
      wait: fix reparent_leader() vs EXIT_DEAD->EXIT_ZOMBIE race
      exit: call disassociate_ctty() before exit_task_namespaces()

Peter Hurley (1):
      tty: Fix low_latency BUG

Richard Cochran (1):
      kernfs: fix off by one error.

Roberto Sassu (1):
      ima: restore the original behavior for sending data with ima template

Tejun Heo (1):
      kernfs: protect lazy kernfs_iattrs allocation with mutex


--ikeVEW9yuYc//A+q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTXFGUAAoJEDjbvchgkmk+xqsP/2jID845C20ZEiw8uWwRxOr0
213CjTl4atH8O0yxsoQp4rrPhNoyhN47WvWcOsVcp20bnEET1rZCU72qqbn6WB7R
2YDYXg3cBqaAWc5y7LrUOo1msAoICsM6rb451CgKJD0lkHt0CngH2H+7lBvKKaNO
AoG1AypHOpFc8ig7TGZ1i3Af3m/96OQF7tQX+pKQC9tzJNech+f/VaO5S4IgaV3L
XkG19I8ar3PerMz8hM0GZrsXljW9DL3uQLiIoqOOzAXXTP4jD0bx7EH+R2V/PqsD
4C+hm7DJJepEbUkEibriY/R7yi/lsE2NIPfRCU5NA8AIs7K+06VtKV1kCOeBENFs
sKJTI2yhYB1kSdsGkmKDFLWQGPpTftaicSmSwNZOsJfsDh8gMzfJGYDDs4vIA17g
uRedweDJqF6uCSzSS6WLKF1vDbCRQEDgMQDf7+FbcBYxidqaW0NtTbEZfM6vhdw2
JwUubS3eOFo0ltDF7Y4W5QBhBNV1khDHKtEN6lrhLc0RaAGPTMcAWed8KfVRHEC4
b6t2pn/PownnrJnbzPcUvmXZWCFFLzA4ZPuh1hquypPcLfCF3NeUBW/0Tnv5kRXJ
YLwYCP4Et5nGLdFImgXxBG2cPmAmbqQ5RTghLsP1Gsk6A2JxBgwDfhzrRMmx9SOJ
x/11Og9zX8mVG/iNjkYd
=aLDJ
-----END PGP SIGNATURE-----

--ikeVEW9yuYc//A+q--
