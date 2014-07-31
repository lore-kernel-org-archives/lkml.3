Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754001AbaGaW5b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 18:57:31 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52805 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906AbaGaW50 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 18:57:26 -0400
Date: Thu, 31 Jul 2014 15:56:58 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.10.51
Message-ID: <20140731225658.GA3997@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VS++wcV0S1rZb1Fb"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--VS++wcV0S1rZb1Fb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.10.51 kernel.

All users of the 3.10 kernel series must upgrade.

The updated 3.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-3.10.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dsu=
mmary

thanks,

greg k-h

------------

 Makefile                               |    4 ++-
 arch/parisc/include/uapi/asm/signal.h  |    2 -
 arch/s390/kernel/ptrace.c              |    9 ++++++--
 arch/x86/boot/header.S                 |   26 +++++++++++++++++++----
 arch/x86/boot/tools/build.c            |   37 ++++++++++++++++++++++++++--=
-----
 arch/x86/kernel/entry_32.S             |    9 ++++----
 block/blk-cgroup.c                     |    7 ++++++
 block/blk-tag.c                        |   33 ++++++-----------------------
 block/compat_ioctl.c                   |    1=20
 drivers/ata/ahci.c                     |    1=20
 drivers/ata/libata-core.c              |   12 ++++++++--
 drivers/hwmon/smsc47m192.c             |    4 ++-
 drivers/input/input.c                  |    6 +++--
 drivers/media/dvb-frontends/tda10071.c |    6 ++++-
 drivers/media/usb/hdpvr/hdpvr-video.c  |    6 ++---
 fs/coredump.c                          |    2 -
 include/linux/libata.h                 |    1=20
 kernel/trace/trace.c                   |    2 -
 kernel/trace/trace_clock.c             |    9 ++++----
 mm/hugetlb.c                           |    1=20
 mm/slab_common.c                       |    2 +
 net/netfilter/nfnetlink_queue_core.c   |   29 ++++++++++++++++++-------
 22 files changed, 140 insertions(+), 69 deletions(-)

Antti Palosaari (1):
      media: tda10071: force modulation to QPSK on DVB-S

Christoph Hellwig (1):
      block: don't assume last put of shared tags is for the host

Christoph Lameter (1):
      slab_common: Do not check for duplicate slab names

Dmitry Torokhov (1):
      Input: fix defuzzing logic

Greg Kroah-Hartman (1):
      Linux 3.10.51

Guenter Roeck (1):
      hwmon: (smsc47m192) Fix temperature limit and vrm write operations

Hans Verkuil (1):
      media: hdpvr: fix two audio bugs

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

Zoltan Kiss (1):
      core, nfqueue, openvswitch: Orphan frags in skb_zerocopy and handle e=
rrors


--VS++wcV0S1rZb1Fb
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT2sm6AAoJEDjbvchgkmk+MxAQAL1qOBUz7SjPVc0CckY1PGvu
5GS4rBQMQFHRnqQn7LOVX1RzPXMQ/Hwm7VItPScvGqqIJOfOxAP/JqmKiFEkMSVS
+lEKimpMA5mRpm1A2G+8XyTWPJBxy+iyggUN17H02m5vntcywxheQik1WIipw/tH
mM/V1SwbOPN0RRKMlLm20Sae49l+q//TZBe+VwzRQhjbUTbBqLij6ngnFlNXEAAH
i5XFlO0XtU/O94VMUTiQTWev0LnRMLS031QGcqtz37lb6GO11os2CegLBCcK93hJ
g2aCJ7iFt0iI8i75kmC1bcA3p/sxl9Z3+NTlXcLk6EPqhvwvwb4+EP1zm+mZTC5N
PozZezd3zoTobyog4mN/XyAB+ImHLONoztzyNjK7Yd6hNWxL6kbdgpbvKw+OzJeD
qDYZowS3b0J2GWH95du44vippiJA/CfIqDzgnrlAq+dIvSJuHp5tZgETyRkyjKwI
Kl0Avmk5HwfzxCr+1vIRwBnJZLwKam+m+3on1AyLN4geMWT3s3yfZpesfLfdLVHz
BEHAvtCDGFAGw5lPlZCz+NhCeVMxABGw0HOG781/cmiYiyzN/QSpxXDGDh37BmTJ
r373XM6/mCLzLhKVV4WIPwcNZWz76BGaYWDsZPbbZp7uAc0TXuznj6Tnts/ZKeEN
GvyODihnMsU+ojHsaqHa
=5s6u
-----END PGP SIGNATURE-----

--VS++wcV0S1rZb1Fb--
