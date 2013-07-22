Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754939Ab3GVBmr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jul 2013 21:42:47 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39413 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754702Ab3GVBmp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jul 2013 21:42:45 -0400
Date: Sun, 21 Jul 2013 18:42:58 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.4.54
Message-ID: <20130722014258.GA10172@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5mCyUwZo2JvN/JJP"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5mCyUwZo2JvN/JJP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

I'm announcing the release of the 3.4.54 kernel.

All users of the 3.4 kernel series must upgrade.

The updated 3.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-3.4.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                    |    2 +-
 arch/arm/kernel/perf_event.c                |    1 +
 arch/x86/xen/time.c                         |   17 ++---------------
 drivers/acpi/ec.c                           |    4 ++++
 drivers/ata/ahci.c                          |    1 +
 drivers/ata/libahci.c                       |    3 +--
 drivers/dma/pl330.c                         |    4 ++--
 drivers/net/wireless/rtlwifi/rtl8192cu/rf.c |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/sw.c |    1 +
 drivers/pci/quirks.c                        |    2 ++
 drivers/pcmcia/at91_cf.c                    |    4 ++--
 drivers/rtc/rtc-rv3029c2.c                  |    2 +-
 drivers/usb/gadget/f_mass_storage.c         |    2 ++
 drivers/usb/host/xhci-mem.c                 |    4 ++++
 drivers/usb/host/xhci-plat.c                |    1 +
 drivers/usb/serial/option.c                 |    4 ----
 drivers/usb/serial/qcserial.c               |    8 +++++++-
 fs/cifs/cifs_unicode.h                      |    8 ++++----
 fs/cifs/cifsencrypt.c                       |    6 +++---
 fs/cifs/inode.c                             |    5 +++++
 fs/ext3/namei.c                             |    7 ++-----
 fs/ext4/extents.c                           |    4 ++--
 fs/ext4/inode.c                             |    4 ++--
 fs/ext4/mballoc.c                           |   11 ++++++++---
 fs/ext4/namei.c                             |    7 ++-----
 fs/jbd2/transaction.c                       |    2 +-
 fs/ocfs2/xattr.c                            |   10 ++++++++++
 kernel/irq/manage.c                         |    6 +++---
 kernel/timer.c                              |    8 +++++---
 29 files changed, 80 insertions(+), 60 deletions(-)

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

George Cherian (1):
      usb: host: xhci-plat: release mem region while removing module

Greg Kroah-Hartman (1):
      Linux 3.4.54

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

Larry Finger (2):
      rtlwifi: rtl8192cu: Add new USB ID for TP-Link TL-WN8200ND
      rtlwifi: rtl8192cu: Fix duplicate if test

Laszlo Ersek (1):
      xen/time: remove blocked time accounting from xen "clockchip"

Mathias Nyman (1):
      xhci: check for failed dma pool allocation

Shane Huang (2):
      ahci: Add AMD CZ SATA device ID
      ahci: remove pmp link online check in FBS EH

Steve French (2):
      CIFS use sensible file nlink values if unprovided
      Handle big endianness in NTLM (ntlmv2) authentication

Theodore Ts'o (2):
      jbd2: fix theoretical race in jbd2__journal_restart
      ext4: don't allow ext4_free_blocks() to fail due to ENOMEM

UCHINO Satoshi (1):
      usb: gadget: f_mass_storage: add missing memory barrier for thread_wakeup_needed


--5mCyUwZo2JvN/JJP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR7I4iAAoJEDjbvchgkmk+7ycQAInjYdmd5q1c48Vaq2zy7P0D
ukT98kUHdsDPoYJFLQtPX8cvrNbT9PkZorKLJIiZT3EOtAiAvRY6IwS7MZEpGZEI
tSUF6sNKrZEXSrPAVBbSwM2Uk6bMOautWfSfDL9jUXV72wJmrBX4tchZdSGzTugt
pu/7YIT9waHBHG7/M6HmbfJklhyslOR4PYIB94dH+gvHBCm2uxdhNlMvdFXbFXyK
+pTHKP/oa3zmiXAv1M0chZJRKvjQymmHZILSC2Vzlex6D7BjXGZC8LWcm81b3p1c
BOMyFsISdlbZ06HLKoTNG6i4OZ6dJkvvCYAI0km/3SHMDwU2LhxOuUZm9mM50Hbj
pDRDh0m+AOAKA1igd+9tT/ZIJBySxRg74Ii/KY/h7QxpmstvmB4myjHpbGJ7QICP
9+yuEljYC2hfSQBGssy1WLK7w8MmoGn0nN6WSYiz06OZwZErLIy0pApsYn2nFPxJ
tSfZ+DLgTAM9XPBsbK/DcDHJ5SFUTiuK+RN2QqdRmcapbYEp/fixDMiHfkWCEQT+
KTMCs+UQXvBIIm6X6MCmoz0tmq64qfFSIiU39nBfSG6TgJNrlZfiHQY3iWLbprYp
brBGDvSPVcxAqL8sn53Lhns3mDTftW651ZdJgRlAyUjBwseNrIWjoJViPuUuhqCt
bI+CsT0NUQ0/YEhz8bu8
=0yNs
-----END PGP SIGNATURE-----

--5mCyUwZo2JvN/JJP--
