Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754107AbaGaW6G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 18:58:06 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52815 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752535AbaGaW6C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 18:58:02 -0400
Date: Thu, 31 Jul 2014 15:57:34 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.14.15
Message-ID: <20140731225734.GA4076@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sdtB3X0nJg68CQEu"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--sdtB3X0nJg68CQEu
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.14.15 kernel.

All users of the 3.14 kernel series must upgrade.

The updated 3.14.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-3.14.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dsu=
mmary

thanks,

greg k-h

------------

 Makefile                                  |    4 ++
 arch/parisc/include/uapi/asm/signal.h     |    2 -
 arch/s390/kernel/ptrace.c                 |   12 ++++++--
 arch/x86/boot/header.S                    |   26 +++++++++++++++---
 arch/x86/boot/tools/build.c               |   37 ++++++++++++++++++++-----
 arch/x86/kernel/entry_32.S                |    9 +++---
 block/blk-cgroup.c                        |    7 ++++
 block/blk-tag.c                           |   33 ++++-------------------
 block/compat_ioctl.c                      |    1=20
 drivers/ata/ahci.c                        |    1=20
 drivers/ata/libata-core.c                 |   12 ++++++--
 drivers/base/platform.c                   |    9 ++++--
 drivers/gpu/drm/radeon/cik.c              |    2 +
 drivers/gpu/drm/radeon/evergreen.c        |    1=20
 drivers/gpu/drm/radeon/r600.c             |    1=20
 drivers/gpu/drm/radeon/si.c               |    1=20
 drivers/hwmon/smsc47m192.c                |    4 ++
 drivers/input/input.c                     |    6 ++--
 drivers/input/mouse/synaptics.c           |    5 ++-
 drivers/media/dvb-frontends/tda10071.c    |    6 +++-
 drivers/media/usb/hdpvr/hdpvr-video.c     |    6 ++--
 drivers/media/v4l2-core/v4l2-dv-timings.c |    4 +-
 drivers/parport/Kconfig                   |   12 ++++----
 drivers/staging/media/omap4iss/Kconfig    |    2 -
 fs/coredump.c                             |    2 -
 fs/namei.c                                |    3 +-
 fs/nfs/nfs3acl.c                          |   43 +++++++++++++++++++++++++=
+++++
 fs/nfs/nfs3proc.c                         |    4 +-
 include/linux/libata.h                    |    1=20
 kernel/trace/trace.c                      |    2 -
 kernel/trace/trace_clock.c                |    9 +++---
 mm/hugetlb.c                              |    1=20
 mm/slab_common.c                          |    2 -
 net/wireless/nl80211.c                    |   11 +++----
 34 files changed, 197 insertions(+), 84 deletions(-)

Antti Palosaari (1):
      media: tda10071: force modulation to QPSK on DVB-S

Arnd Bergmann (1):
      media: staging: tighten omap4iss dependencies

Christian K=F6nig (1):
      drm/radeon: fix irq ring buffer overflow handling

Christoph Hellwig (2):
      nfs: only show Posix ACLs in listxattr if actually present
      block: don't assume last put of shared tags is for the host

Dmitry Torokhov (1):
      Input: fix defuzzing logic

Greg Kroah-Hartman (1):
      Linux 3.14.15

Guenter Roeck (2):
      hwmon: (smsc47m192) Fix temperature limit and vrm write operations
      platform_get_irq: Revert to platform_get_resource if of_irq_get fails

Hans Verkuil (1):
      media: hdpvr: fix two audio bugs

Hans de Goede (1):
      Input: synaptics - add min/max quirk for pnp-id LEN2002 (Edge E531)

Jerome Glisse (1):
      drm/radeon: fix cut and paste issue for hawaii.

Johannes Berg (1):
      nl80211: move set_qos_map command into split state

John David Anglin (1):
      parisc: Remove SA_RESTORER define

Kevin Hao (1):
      libata: support the ata host which implements a queue depth less than=
 32

Linus Torvalds (1):
      Fix gcc-4.9.0 miscompilation of load_balance() in scheduler

Martin Schwidefsky (1):
      s390/ptrace: fix PSW mask check

Michael Brown (1):
      x86/efi: Include a .bss section within the PE/COFF headers

Mikulas Patocka (2):
      block: provide compat ioctl for BLKZEROOUT
      slab_common: fix the check for duplicate slab names

Naoya Horiguchi (1):
      mm: hugetlb: fix copy_hugetlb_page_range()

Randy Dunlap (1):
      parport: fix menu breakage

Rickard Strandqvist (1):
      media: media: v4l2-core: v4l2-dv-timings.c: Cleaning up code wrong va=
lue used in aspect ratio

Romain Degez (1):
      ahci: add support for the Promise FastTrak TX8660 SATA HBA (ahci mode)

Silesh C V (1):
      coredump: fix the setting of PF_DUMPCORE

Sven Wegener (1):
      x86_32, entry: Store badsys error code in %eax

Tejun Heo (2):
      libata: introduce ata_host->n_tags to avoid oops on SAS controllers
      blkcg: don't call into policy draining if root_blkg is already gone

Tony Luck (1):
      tracing: Fix wraparound problems in "uptime" trace clock

Vasily Averin (1):
      fs: umount on symlink leaks mnt count


--sdtB3X0nJg68CQEu
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT2sneAAoJEDjbvchgkmk+HaYQAKTy6LGHQ+mSLlx3jY2eHNm1
zFxr5PGDQTVYkI3hmtdOjcjJ49lmYl2/Nuq8a4ijzCopSzydf5ksLxUojRue3v/6
av5D+2AAHZ7gxYN1QQBbszy5iJAHYoX+sjoxCx+EPyGlOzs45dZCDAWzUZafAPVd
BX48Kgo2BM2COZFblhtO1K/0gtRcBVSItRnoLxQxCGYCYKU3qROl75QBaZCJOtPX
eaVnoPg6uFLOQPT0LSxxdqy86WBlUCAtO6u8V7xyb40TyuquG0+rhFSZDI2659b2
b6hht3WjitP+KBrWIp+kB7gl1s9aroHwmrdetLxMRDDbAGLtTMsKaAlxnxnnSF3y
Xen81ciO8Il9N7a8TFKtLAjIm+t1CNzoq5hMOHklLr+7VvSQ9Om5XcnHkoZoXj46
dTOdZLnK35K1FbHrllr1qJAn+27AE9lwpW7+rQkE/92MQ60cRXjJUYGJpGtDiWTz
ayvK6rRiLUCHxGG1abLhatG0ybH4M5aatxXDs8x9MiTu/3iqHeT7oTtuR69XVlX1
Fu23cLr+hwMQkONZI0N0wwP560n9PK2yL62kpj/tnAVjxEHKJU7Cu+hmIKsNynjr
/eNdHWvMsJAgsAUNbjZFc8VTrlSZCmqO7ilDyEzU5iaqhYv0EbcySFS8Rb8waMve
KQvZR6XkAPVeMTMdbnP6
=ZUPc
-----END PGP SIGNATURE-----

--sdtB3X0nJg68CQEu--
