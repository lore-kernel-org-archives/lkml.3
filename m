Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753065AbaD0Ahk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2014 20:37:40 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57809 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753032AbaD0Ahg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2014 20:37:36 -0400
Date: Sat, 26 Apr 2014 17:38:18 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.10.38
Message-ID: <20140427003818.GA3228@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZPt4rx8FFjLCG7dd"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ZPt4rx8FFjLCG7dd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

I'm announcing the release of the 3.10.38 kernel.

All users of the 3.10 kernel series must upgrade.

The updated 3.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-3.10.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                  |    2 -
 arch/sparc/Kconfig                        |    2 -
 arch/sparc/include/asm/uaccess_64.h       |    4 +--
 arch/sparc/kernel/pci.c                   |    4 +--
 arch/sparc/kernel/process_64.c            |    4 ++-
 arch/sparc/kernel/syscalls.S              |    4 +--
 arch/x86/kernel/early-quirks.c            |   15 +++++--------
 drivers/char/ipmi/ipmi_bt_sm.c            |    2 -
 drivers/staging/comedi/drivers/8255_pci.c |   34 ++++++++++++++++++++++++++++++
 drivers/tty/tty_io.c                      |   23 +++++++++++++++-----
 fs/btrfs/disk-io.c                        |    4 +++
 fs/ext4/extents.c                         |   29 +++++++++++++++++++++++--
 fs/fs-writeback.c                         |   31 +++++++++++++++++++--------
 fs/jffs2/compr_rtime.c                    |    4 +--
 fs/jffs2/nodelist.h                       |    2 -
 fs/jffs2/nodemgmt.c                       |   14 ++++++++----
 include/linux/backing-dev.h               |    2 -
 kernel/exit.c                             |   21 +++++++++++-------
 kernel/pid_namespace.c                    |    4 ++-
 kernel/user_namespace.c                   |   11 ++++-----
 mm/backing-dev.c                          |   16 ++++++++++----
 net/bluetooth/hci_event.c                 |    8 ++++++-
 22 files changed, 176 insertions(+), 64 deletions(-)

Ajesh Kunhipurayil Vijayan (1):
      jffs2: Fix crash due to truncation of csize

Claudio Takahasi (1):
      Bluetooth: Fix removing Long Term Key

Dave Kleikamp (2):
      Revert "sparc64: Fix __copy_{to,from}_user_inatomic defines."
      sparc64: don't treat 64-bit syscall return codes as 32-bit

David S. Miller (1):
      sparc64: Make sure %pil interrupts are enabled during hypervisor yield.

Derek Basehore (1):
      backing_dev: fix hung task on sync

Eric Whitney (2):
      ext4: fix error return from ext4_ext_handle_uninitialized_extents()
      ext4: fix partial cluster handling for bigalloc file systems

Greg Kroah-Hartman (1):
      Linux 3.10.38

Hannes Reinecke (1):
      tty: Set correct tty name in 'active' sysfs attribute

Hidetoshi Seto (1):
      Btrfs: skip submitting barrier for missing device

Ian Abbott (1):
      staging: comedi: 8255_pci: initialize MITE data window

Jan Kara (1):
      bdi: avoid oops on device removal

Jiri Slaby (1):
      Char: ipmi_bt_sm, fix infinite loop

Kamlakant Patel (1):
      jffs2: Fix segmentation fault found in stress test

Li Zefan (2):
      jffs2: avoid soft-lockup in jffs2_reserve_space_gc()
      jffs2: remove from wait queue after schedule()

Mikulas Patocka (1):
      user namespace: fix incorrect memory barriers

Neil Horman (1):
      x86: Adjust irq remapping quirk for older revisions of 5500/5520 chipsets

Oleg Nesterov (3):
      pid_namespace: pidns_get() should check task_active_pid_ns() != NULL
      wait: fix reparent_leader() vs EXIT_DEAD->EXIT_ZOMBIE race
      exit: call disassociate_ctty() before exit_task_namespaces()

Paul Gortmaker (1):
      sparc32: fix build failure for arch_jump_label_transform

oftedal (1):
      sparc: PCI: Fix incorrect address calculation of PCI Bridge windows on Simba-bridges


--ZPt4rx8FFjLCG7dd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTXFF6AAoJEDjbvchgkmk++6MP/15QJNS6TQ5meHO9YbrJhBPf
xJoulMxj2ZEoQU2dF4snOjGj2RifgR7OF+mGzSOX3mazJJtX3yzHhD5Qa8uCcuHb
qtAHh9rOr68Ks99h1J5zcnlkCIzy2fnWm7c0+fTYeQpjDpiUNCvjniJI8wFBuDi0
P9fvldZhfjYg3d7lx0dSGdCeNf/1e+G1ipuV1M5WaSlBWtCuUyM/a8+4jzqrd4TS
Xh4GVYslaUeNdgh0VuaxbhQRAxid87C1vX6m9zQHiN+olP7n/ArH67i+kL2kvHva
UVPK743RNZP4AtfocixF4XE24S4aMrzZLiKUtENRLtChRuKjQoxjeRAT91xh2k1+
VzMMcfT0+puR9KsnTkdAUOZ8RksjXFXXmeS0uOTgsKDaimapkQ9npMVuMkObGmg2
v224MC/n2aJb1M2EednX1bae753opOPnNJ6xdsIwD/7sdR30rUGCA84cT4l5a7Rh
jeZ9YDwroOIzmhGFNrQJHo0pcApeEzNtkoKexCBAlPwbzwbFDAV9PGYwNoEJxc0d
0LeOPu7MX1kK1Sp8tcAzXgqZh+j/eVxj/inAX3i0GTxgXjEXKJVUw0q8hdpmGPlA
kwON8haSsQGYbQzfll4ZzCOL8gGZ+uwbZ17ODXkb425upZytScZ9ye7HlE+cQ1JB
BPVR5H+T6LrJWN3q5Wnd
=zrnL
-----END PGP SIGNATURE-----

--ZPt4rx8FFjLCG7dd--
