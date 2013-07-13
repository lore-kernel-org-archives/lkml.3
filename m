Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933292Ab3GMSwl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jul 2013 14:52:41 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:44022 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758048Ab3GMSwk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jul 2013 14:52:40 -0400
Date: Sat, 13 Jul 2013 11:52:40 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.4.53
Message-ID: <20130713185240.GA568@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lrZ03NoBR/3+SXJZ"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--lrZ03NoBR/3+SXJZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

I'm announcing the release of the 3.4.53 kernel.

All users of the 3.4 kernel series must upgrade.

The updated 3.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-3.4.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 MAINTAINERS                        |    1 +
 Makefile                           |    2 +-
 block/genhd.c                      |    2 +-
 crypto/algapi.c                    |    3 ++-
 drivers/block/nbd.c                |    3 ++-
 drivers/cdrom/cdrom.c              |    2 +-
 drivers/power/charger-manager.c    |    2 +-
 drivers/scsi/osd/osd_uld.c         |    2 +-
 drivers/scsi/sd.c                  |    2 +-
 drivers/tty/serial/8250/8250_pci.c |    4 ----
 fs/hpfs/map.c                      |    3 ++-
 fs/hpfs/super.c                    |    8 +++++++-
 fs/nfsd/nfs4xdr.c                  |    2 +-
 kernel/time/tick-sched.c           |    1 -
 net/ceph/auth_none.c               |    6 ++++++
 15 files changed, 27 insertions(+), 16 deletions(-)

Ben Hutchings (1):
      SCSI: sd: Fix parsing of 'temporary ' cache mode prefix

Greg Kroah-Hartman (4):
      MAINTAINERS: add stable_kernel_rules.txt to stable maintainer information
      Revert "serial: 8250_pci: add support for another kind of NetMos Technology PCI 9835 Multi-I/O Controller"
      Revert "sched: Add missing call to calc_load_exit_idle()"
      Linux 3.4.53

J. Bruce Fields (1):
      nfsd4: fix decoding of compounds across page boundaries

Jonathan Salwan (1):
      drivers/cdrom/cdrom.c: use kzalloc() for failing hardware

Kees Cook (3):
      charger-manager: Ensure event is not used as format string
      block: do not pass disk names as format strings
      crypto: sanitize argument for format string

Mikulas Patocka (1):
      hpfs: better test for errors

Tyler Hicks (1):
      libceph: Fix NULL pointer dereference in auth client code


--lrZ03NoBR/3+SXJZ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR4aH4AAoJEDjbvchgkmk+KsEQAItn8uDYV3FVCMef7kJDYL3w
g488hxcPKieTJ9xR92r6xwIerQLvi1uCXcs5pmKUWCXOQRIzIL/+ZfUAR3d2idUq
qKU2CYGmlR2p2Xxy1hne7u16Apy82+dN15o/b25gMmPlMAXlaURLtX9rO13r2ATw
lLytAnco0WqIbYwoHHJ/YDb1UaD9V7XJ2kVliX5A039wNoEn7l6oAGB4GvrOLMC0
iiEsOhpVGW84yno+kX4eMiy2wav8Tdm16B6S2n8YTko7AbjHKfTGIWHD5hRfdPnW
p/Se2LgaDcksynVnjs1xCkHanIT0m0bUQqtsSSkuyUO3nkMLcnijVHq3SoGcdSD4
O1b8e9zgdnsEPtgT/p5FC6iUagMqWq4hvcCh9VXqHskd5sM2tA6WR429FDeQDfb6
wEa/Nl6PhGy4/FhZKFxK8N94ksnn48LAuWkIv1Kdiw24S1f3K/Pt9HEelcYUBwLu
FUbd+WBCfpuVSI6bDgICsxsPIU2WxQgfR+k8WYJxOo5H1x4PTbM88tZ+ewVM8pYF
DTraAVivUKigUxp45Jz9G4bvT7ytAyWNEtvkwdO/e3V6L/ReTqv2cRtzVV+NUdOz
DW66KYsQY66FCj+yw4KbASHuQuQScFY/jlijQmBqUf1CG0OXe+8qfcacoARG7wY7
8RMmHOrFgIdkUkiQeHDh
=VJz1
-----END PGP SIGNATURE-----

--lrZ03NoBR/3+SXJZ--
