Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755492Ab3AUT4j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 14:56:39 -0500
Received: from mail-pb0-f53.google.com ([209.85.160.53]:60627 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752699Ab3AUT4i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 14:56:38 -0500
Date: Mon, 21 Jan 2013 11:56:34 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.0.60
Message-ID: <20130121195634.GB6665@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5vNYLRcllDrimb99"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5vNYLRcllDrimb99
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.0.60 kernel.

All users of the 3.0 kernel series must upgrade.

The updated 3.0.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.g=
it linux-3.0.y
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git=
;a=3Dsummary

thanks,

greg k-h

------------

 Makefile                                 |    2=20
 arch/powerpc/platforms/embedded6xx/wii.c |    6 +-
 arch/s390/include/asm/timex.h            |   28 +++++++++++
 arch/s390/kernel/time.c                  |    2=20
 arch/s390/kvm/interrupt.c                |    2=20
 arch/sh/include/asm/elf.h                |    4 -
 arch/x86/kernel/entry_32.S               |    1=20
 arch/x86/kernel/setup.c                  |   78 ++++++++++++++++++++++++++=
+++++
 drivers/block/drbd/drbd_req.c            |    1=20
 drivers/pci/intel-iommu.c                |   31 ++++++++++++
 drivers/staging/vt6656/bssdb.h           |    1=20
 drivers/staging/vt6656/int.h             |    1=20
 drivers/staging/vt6656/iocmd.h           |   33 ++++++-------
 drivers/staging/vt6656/iowpa.h           |    8 +--
 drivers/target/tcm_fc/tfc_sess.c         |   12 +++-
 drivers/tty/serial/ifx6x60.c             |    1=20
 drivers/usb/core/message.c               |   53 ++++++++++++---------
 drivers/usb/host/xhci-mem.c              |   11 +++-
 drivers/usb/serial/option.c              |    9 +++
 fs/ext4/inode.c                          |    2=20
 20 files changed, 226 insertions(+), 60 deletions(-)

Alan Stern (1):
      USB: fix endpoint-disabling for failed config changes

Ben Hutchings (1):
      staging: vt6656: Fix inconsistent structure packing

Bj=F8rn Mork (2):
      USB: option: add TP-LINK HSUPA Modem MA180
      USB: option: blacklist network interface on ONDA MT8205 4G LTE

Eric Sandeen (1):
      ext4: init pagevec in ext4_da_block_invalidatepages

Frediano Ziglio (1):
      xen: Fix stack corruption in xen_failsafe_callback for 32bit PVOPS gu=
ests.

Greg Kroah-Hartman (1):
      Linux 3.0.60

Heiko Carstens (1):
      s390/time: fix sched_clock() overflow

Jesse Barnes (1):
      x86/Sandy Bridge: reserve pages when integrated graphics is present

Julius Werner (1):
      xhci: fix null-pointer dereference when destroying half-built segment=
 rings

Mark Rustad (2):
      tcm_fc: Do not indicate retry capability to initiators
      tcm_fc: Do not report target role when target is not defined

Philipp Reisner (1):
      drbd: add missing part_round_stats to _drbd_start_io_acct

Shuah Khan (1):
      powerpc: fix wii_memory_fixups() compile error on 3.0.y tree

Thomas Schwinge (1):
      sh: Fix FDPIC binary loader

Tom Mingarelli (1):
      intel-iommu: Prevent devices with RMRRs from being placed into SI Dom=
ain

chao bi (1):
      serial:ifx6x60:Delete SPI timer when shut down port


--5vNYLRcllDrimb99
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQ/Z1yAAoJEDjbvchgkmk+ugoP/A2wuTXaU2JbqmNfI7wG2+BE
e2jOcEhM2YpmymWEepxFmjK5CefQ2X/V654Z6Q1b2tRekt1hHcZj7n1ugovBzivl
QWNkdCna4is0Zz2EfvbIJNMXLUfavab83UQxLBEPdHOmHuO9Z3aWcRMLPJKEGOu/
6Lnj/i6I/wdawHBTv94AP1EgTKVrVOaDQXH4jUZ3z63PEzP/YllCyL52tf854koZ
0VnkLblNhHWWq49DxqugjMMLGtuvrZ4USfkey+LMDwk5xf5IcPvTommFXoqiLBZI
lR53f4XOGWWn2xlpgt5A1dJ8QiQoPqsJ3rslU76YphxInsTKtLBSepCoTO4znzmF
ETgZ/1Mm9GFG/Ut/O4+c/W5nf3kdLbU14nEfSwHvIw/k80b90A5dGMt9PP2r/IhH
Ev/UR1y1++na09lCjSSEyHKpMl9HUxhh7hBR5rHwAuqfYPhdpwJDcWMZ+IRlIw6O
ye4m8bm7pvaeWhLgshsGQiSLxauJaE0lXEasR9Gt9PhO0THqBN3o9CVEQyNqx8Jf
9l+95YTfifaTYf8hDkwIrT8pKHODJQhjtwyE8V2/95fcg7ZxpG/5BwI+dhFzt9Z4
q9sHPcuzNhROr1XDLFQ/N4EhnwKcOacDQwjRna+buIZ5DXF4gLsSJoN+aH/a+Ky/
Pz5CTjBvuLDdFyNQYY+V
=r76S
-----END PGP SIGNATURE-----

--5vNYLRcllDrimb99--
