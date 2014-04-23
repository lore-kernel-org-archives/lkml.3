Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752352AbaDWADs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 20:03:48 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50767 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750940AbaDWADp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 20:03:45 -0400
Date: Tue, 22 Apr 2014 17:06:35 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.13.11
Message-ID: <20140423000635.GA32144@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="n8g4imXOkfNTN/H1"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--n8g4imXOkfNTN/H1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

NOTE

This is the LAST 3.13.y release.  It is now end-of-life.  Please move to
3.14.y now.

-----------

I'm announcing the release of the 3.13.11 kernel.

All users of the 3.13 kernel series must upgrade.

The updated 3.13.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-3.13.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                  |    2 -
 arch/sparc/Kconfig                        |    2 -
 arch/sparc/kernel/process_64.c            |    4 ++-
 arch/sparc/kernel/syscalls.S              |    4 +--
 arch/x86/kernel/cpu/mshyperv.c            |    6 ++++
 arch/x86/kernel/early-quirks.c            |   15 ++++-------
 drivers/acpi/button.c                     |    4 +++
 drivers/char/ipmi/ipmi_bt_sm.c            |    2 -
 drivers/pci/host/pcie-designware.c        |    8 +++---
 drivers/pci/pci.c                         |    3 ++
 drivers/scsi/sd.c                         |    4 +--
 drivers/staging/comedi/drivers/8255_pci.c |   34 +++++++++++++++++++++++++
 drivers/tty/ipwireless/tty.c              |    3 --
 drivers/tty/tty_buffer.c                  |   20 +++------------
 drivers/tty/tty_io.c                      |   23 ++++++++++++-----
 drivers/usb/gadget/u_serial.c             |    4 +--
 fs/btrfs/disk-io.c                        |    4 +++
 fs/btrfs/transaction.c                    |   14 +++-------
 fs/ext4/extents.c                         |   40 ++++++++++++++++++++++++++----
 fs/fs-writeback.c                         |   31 ++++++++++++++++-------
 fs/jffs2/compr_rtime.c                    |    4 +--
 fs/jffs2/nodelist.h                       |    2 -
 fs/jffs2/nodemgmt.c                       |   14 +++++++---
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
 34 files changed, 221 insertions(+), 106 deletions(-)

Ajesh Kunhipurayil Vijayan (1):
      jffs2: Fix crash due to truncation of csize

Alan Stern (1):
      SCSI: sd: don't fail if the device doesn't recognize SYNCHRONIZE CACHE

Bjorn Helgaas (1):
      PCI: Enable INTx in pci_reenable_device() only when MSI/MSI-X not enabled

Claudio Takahasi (1):
      Bluetooth: Fix removing Long Term Key

Dave Kleikamp (1):
      sparc64: don't treat 64-bit syscall return codes as 32-bit

David S. Miller (1):
      sparc64: Make sure %pil interrupts are enabled during hypervisor yield.

Derek Basehore (1):
      backing_dev: fix hung task on sync

Eric Whitney (3):
      ext4: fix error return from ext4_ext_handle_uninitialized_extents()
      ext4: fix partial cluster handling for bigalloc file systems
      ext4: fix premature freeing of partial clusters split across leaf blocks

Greg Kroah-Hartman (1):
      Linux 3.13.11

Hannes Reinecke (1):
      tty: Set correct tty name in 'active' sysfs attribute

Hidetoshi Seto (1):
      Btrfs: skip submitting barrier for missing device

Ian Abbott (1):
      staging: comedi: 8255_pci: initialize MITE data window

Jan Kara (1):
      bdi: avoid oops on device removal

Jason Wang (1):
      x86, hyperv: Bypass the timer_irq_works() check

Jiri Slaby (1):
      Char: ipmi_bt_sm, fix infinite loop

Josef Bacik (1):
      Btrfs: fix deadlock with nested trans handles

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

Paul Gortmaker (1):
      sparc32: fix build failure for arch_jump_label_transform

Peter Hurley (1):
      tty: Fix low_latency BUG

Roberto Sassu (1):
      ima: restore the original behavior for sending data with ima template


--n8g4imXOkfNTN/H1
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTVwQLAAoJEDjbvchgkmk+SogQANcj8tyj03izGmSY3R02AwjM
hw0Mj8I2UU8+pRjS2OdtG6XQBkDtQ+DIvI2WyZEQigsiNGNDl5BXmGndnkiRxth6
0IsSowIpiSGnPdrefwHUPGo/eHTePL6Fj/JQTgdgqUbLzgYvNgTlFR/q1lBhrGWn
Y79OXrFmlM74H1AGcpfsAwW3aPUaGRGn6HyeWjQuh8c7tN/xLfQzsn4ElEha7ZwX
S3VgvuNnxm3pWsixGpdbmUDJYYSRghdOA3eSRJKfOWM37quQi4xngWpeJdlpcte4
EHPGp1fU8DeFBP8H2usTRmnqM6KiUsbSCH2c4H8w6xuUBozw/WTNXo8E3Sgu1Uhg
62UmqfokmiuQ+BEQc2yZuXcXQVu6guKPSVpcKrThqAsa7wd0jQBZ64u5xZnFOgYx
dZoLT717ybUZXz7sjb1o7V0SHipbBXwlV37yUCWenBDnvVI4xEPMzKAU1V+yLPVJ
W+yidtGq9KNaBI9LXjJddK3A6uHFMIOydO44jDXHhVxxTEG0rNHbcW2GacQL5RGy
Wd8MAqxUqrBS0UzpzvN6k29vs7G/MhgivCMqyAv4d/YXjyP5h+/R88wo//niaY6r
bz+Xfb3ftlazwCfSjAuIqaqUnaTNlmt0/W6+/EZSNhXh0DdfgJg1IxBwpf8f+98+
RBkFpcaLtofT1PkXeemB
=sqp9
-----END PGP SIGNATURE-----

--n8g4imXOkfNTN/H1--
