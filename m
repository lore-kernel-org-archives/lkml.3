Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754857Ab3GVBmP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jul 2013 21:42:15 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39403 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753922Ab3GVBmN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jul 2013 21:42:13 -0400
Date: Sun, 21 Jul 2013 18:42:26 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.0.87
Message-ID: <20130722014226.GB31697@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EVF5PPMfhYS0aIcm"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--EVF5PPMfhYS0aIcm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

I'm announcing the release of the 3.0.87 kernel.

All users of the 3.0 kernel series must upgrade.

The updated 3.0.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-3.0.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                            |    2 +-
 arch/arm/kernel/perf_event.c        |    1 +
 arch/x86/xen/time.c                 |   17 ++---------------
 drivers/acpi/ec.c                   |    4 ++++
 drivers/ata/ahci.c                  |    1 +
 drivers/ata/libahci.c               |    3 +--
 drivers/dma/pl330.c                 |    4 ++--
 drivers/pci/quirks.c                |    2 ++
 drivers/pcmcia/at91_cf.c            |    4 ++--
 drivers/rtc/rtc-rv3029c2.c          |    2 +-
 drivers/usb/gadget/f_mass_storage.c |    2 ++
 drivers/usb/host/xhci-mem.c         |    4 ++++
 drivers/usb/serial/option.c         |    4 ----
 drivers/usb/serial/qcserial.c       |    8 +++++++-
 fs/ext3/namei.c                     |    7 ++-----
 fs/ext4/extents.c                   |    4 ++--
 fs/ext4/inode.c                     |    4 ++--
 fs/ext4/namei.c                     |    7 ++-----
 fs/jbd2/transaction.c               |    2 +-
 fs/ocfs2/xattr.c                    |   10 ++++++++++
 kernel/irq/manage.c                 |    6 +++---
 kernel/timer.c                      |    8 +++++---
 22 files changed, 57 insertions(+), 49 deletions(-)

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

Dan Williams (1):
      USB: option,qcserial: move Novatel Gobi1K IDs to qcserial

Greg Kroah-Hartman (1):
      Linux 3.0.87

Jan Kara (2):
      ext4: fix data offset overflow in ext4_xattr_fiemap() on 32-bit archs
      ext4: fix overflow when counting used blocks on 32-bit architectures

Jed Davis (1):
      ARM: 7765/1: perf: Record the user-mode PC in the call chain.

Joachim Eastwood (1):
      pcmcia: at91_cf: fix gpio_get_value in at91_cf_get_status

Junxiao Bi (1):
      ocfs2: xattr: fix inlined xattr reflink

Lan Tianyu (1):
      ACPI / EC: Add HP Folio 13 to ec_dmi_table in order to skip DSDT scan

Laszlo Ersek (1):
      xen/time: remove blocked time accounting from xen "clockchip"

Mathias Nyman (1):
      xhci: check for failed dma pool allocation

Shane Huang (2):
      ahci: Add AMD CZ SATA device ID
      ahci: remove pmp link online check in FBS EH

Theodore Ts'o (1):
      jbd2: fix theoretical race in jbd2__journal_restart

UCHINO Satoshi (1):
      usb: gadget: f_mass_storage: add missing memory barrier for thread_wakeup_needed


--EVF5PPMfhYS0aIcm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR7I4CAAoJEDjbvchgkmk+3bcP/RPabQej3+KoBvV7UqZs8GG6
rVoQ3BVaOdTBlsAEEBalsY+O2Du+ZVCOMfuIjShH0sPMe7EJnb5QVthRM0sH4Dk2
ikq73Nc/kNxQv75TXiiVDMcdpMfA86iAUANg+7Wz32IE8AAi5ZL9MkycJABjX+Yy
k0r3MPNilgzwLMzgAHLVXT499Nmwswg//WV7X6gJ4JJCPjmpvrora7U5H1Kpl7qy
edj4v17SBRXOU3/ies4SFEFOyCgXZ9bCvuWJWYBnXjAHS5EmHviEWIPdVeQR1rVJ
/klJ2On9vvUqUASzXK41+4Q80yEOKNEZ7frTsu1GVvR9zapiTN00LkV845SiRhJh
sRsCNk9qT3cabC4O3+Dxd+XlMCGo1WVoejAcX0wPP2bfXRyoQayXrBFrS1xIyp68
axH4MH+9OHP4Zu9lC+UXSckd9xljfYVLnMWqIbhbolO+uIU8UFSDt1SX2nAlu2+y
p0sXj8j6xo3gjEA5QQ5vWQd07BmFcLt46SUdwKXC+67UTzRodDz1fwmMIeuDUJ2U
+ti8hZCWtSofjzR8wUF5ye88R+6Qv3vIrhXvAVraSl2Rx62um7Pnrei0giJDzd+i
JLUf56J8XJJmK9yktymz6XHUaZoMPtc/iXMFnu6IlqJioXuZb5LpbvLMYE9dJwUT
klPGGy5aNdu/sv7n+Dxb
=uTtq
-----END PGP SIGNATURE-----

--EVF5PPMfhYS0aIcm--
