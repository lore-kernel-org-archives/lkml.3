Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751184Ab3I0AZO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 20:25:14 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36198 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750764Ab3I0AZN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 20:25:13 -0400
Date: Thu, 26 Sep 2013 17:25:11 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.0.97
Message-ID: <20130927002511.GA8283@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GvXjxJ+pjyke8COw"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--GvXjxJ+pjyke8COw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

I'm announcing the release of the 3.0.97 kernel.

All users of the 3.0 kernel series must upgrade.

The updated 3.0.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-3.0.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                    |    2 +-
 arch/arm/mach-versatile/pci.c               |    6 +++---
 arch/powerpc/kernel/align.c                 |   10 ++++++++++
 crypto/api.c                                |    7 ++++++-
 drivers/hid/hid-core.c                      |   19 ++++++++++++++-----
 drivers/hid/hid-ntrig.c                     |    3 ++-
 drivers/hid/hid-pl.c                        |   10 ++++++++--
 drivers/net/wireless/ath/ath9k/ar9003_phy.c |    4 ++++
 drivers/net/wireless/ath/ath9k/xmit.c       |    1 +
 drivers/scsi/sd.c                           |   11 +++--------
 drivers/staging/comedi/drivers/dt282x.c     |    3 ++-
 drivers/usb/class/cdc-wdm.c                 |   13 +++++++++----
 drivers/usb/core/config.c                   |    3 ++-
 drivers/usb/host/xhci.c                     |   22 ++++++++++++++++++++++
 drivers/usb/serial/mos7720.c                |    6 +++---
 drivers/xen/grant-table.c                   |   13 +++++++++++--
 fs/cifs/connect.c                           |    2 ++
 fs/fuse/dir.c                               |    4 ++++
 fs/fuse/file.c                              |    3 ++-
 fs/isofs/inode.c                            |   16 +++++-----------
 fs/ocfs2/extent_map.c                       |    1 -
 include/linux/hid.h                         |    4 +++-
 include/linux/rculist.h                     |    5 +++--
 mm/huge_memory.c                            |    2 ++
 mm/memcontrol.c                             |    8 +++++++-
 sound/pci/hda/hda_intel.c                   |    1 +
 sound/soc/codecs/wm8960.c                   |    6 +++---
 27 files changed, 133 insertions(+), 52 deletions(-)

Alan Stern (1):
      SCSI: sd: Fix potential out-of-bounds access

Anand Avati (1):
      fuse: invalidate inode attributes on xattr modification

Anton Blanchard (1):
      powerpc: Handle unaligned ldbrx/stdbrx

Dan Carpenter (2):
      staging: comedi: dt282x: dt282x_ai_insn_read() always fails
      USB: mos7720: use GFP_ATOMIC under spinlock

Felix Fietkau (2):
      ath9k: always clear ps filter bit on new assoc
      ath9k: avoid accessing MRC registers on single-chain devices

Greg Kroah-Hartman (1):
      Linux 3.0.97

Greg Thelen (1):
      memcg: fix multiple large threshold notifications

Hans de Goede (1):
      usb: config->desc.bLength may not exceed amount of data returned by the device

Herbert Xu (1):
      crypto: api - Fix race condition in larval lookup

Jan Kara (1):
      isofs: Refuse RW mount of the filesystem instead of making it RO

Jeff Layton (1):
      cifs: ensure that srv_mutex is held when dealing with ssocket pointer

Jie Liu (1):
      ocfs2: fix the end cluster offset of FIEMAP

Johan Hovold (1):
      USB: mos7720: fix big-endian control requests

Kees Cook (4):
      HID: pantherlord: validate output report details
      HID: validate HID report id size
      HID: ntrig: validate feature report details
      HID: check for NULL field when setting values

Libin (1):
      mm/huge_memory.c: fix potential NULL pointer dereference

Maxim Patlasov (1):
      fuse: postpone end_page_writeback() in fuse_writepage_locked()

Mike Dyer (1):
      ASoC: wm8960: Fix PLL register writes

Oliver Neukum (1):
      USB: cdc-wdm: fix race between interrupt handler and tasklet

Peter Maydell (1):
      ARM: PCI: versatile: Fix SMAP register offsets

Roger Pau Monne (1):
      xen-gnt: prevent adding duplicate gnt callbacks

Shawn Nematbakhsh (1):
      usb: xhci: Disable runtime PM suspend for quirky controllers

Takashi Iwai (1):
      ALSA: hda - Add Toshiba Satellite C870 to MSI blacklist

Tejun Heo (1):
      rculist: list_first_or_null_rcu() should use list_entry_rcu()


--GvXjxJ+pjyke8COw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJSRNBnAAoJEDjbvchgkmk+My8QAMWnfW+j/sa3tzc6vG5qyAgb
4r+Fd/Cz0bPd6yCJ0d/NLKVHRxxxV5e3qQFKOvKlil2ZTRw34NLimCjGBielHZCQ
9pX/13K3JLMo7blFWe3GeyOAxfUCElGPfRi/G0+mC5DW4E83dM2yRnKOq+BfIguq
5TWqjbIKiK3t+YyKjLtd0AIJLhXqgtBsLbBUIXdlvq7kBeBkNhQXv7JTX93CBLPE
Lyns+rEEtUDn2H1U2Aw12XNVYQR+bYRAsjQfh2Tt5dHtVTa4GpHAZ/SvPn1Y2P5B
zcxQ+0u8LQJaAMtEBhHBxQ+cTfapFuATXyp1YEoXgg2sF6LFUBZmeFZ8ckeRrf2N
ewPzTxQ0OUFp1bSp4DZWfvSRi4szWY8kev7qcizEcwLUml6Yd8VeCb83Hp4tOxgb
HYx0ZamFlgDcmOdAqlmGuQf8QKn5jYjiB0TwSHlg91i7gq08RGZht65HKX6VgRnr
PfI028U336LciAQHJMtAazX0QDz18ndJVuZR8+s/9yQ3/3kfHLVwYbjfCarew2dl
J9nMLsFsvkQht+cpkf0I7mhltdI/FGJDzVH6iKibNzUvEozdKAu8cjC0UW8y8IoT
FVdcYB697rwmguXhmCwSl0WoSOYwkJxVlyizzTPf2YRHWCda7IkXYirHifF/K7sT
tj96Vfgj4xQdTzvU/muN
=v4Ym
-----END PGP SIGNATURE-----

--GvXjxJ+pjyke8COw--
