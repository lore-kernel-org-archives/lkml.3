Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757340Ab3EXSXt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 14:23:49 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57549 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753829Ab3EXSXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 14:23:48 -0400
Date: Fri, 24 May 2013 11:23:47 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.0.80
Message-ID: <20130524182347.GA3110@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="huq684BweRXVnRxX"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--huq684BweRXVnRxX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

I'm announcing the release of the 3.0.80 kernel.

All users of the 3.0 kernel series must upgrade.

The updated 3.0.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-3.0.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                              |    2 +-
 drivers/hwmon/abituguru.c             |   16 ++++++++++------
 drivers/media/dvb/mantis/mantis_dvb.c |    6 ++++--
 fs/btrfs/ioctl.c                      |   10 +++++-----
 4 files changed, 20 insertions(+), 14 deletions(-)

Alan Cox (1):
      media: mantis: fix silly crash case

Gabriel de Perthuis (1):
      btrfs: don't stop searching after encountering the wrong item

Greg Kroah-Hartman (1):
      Linux 3.0.80

Wei Yongjun (1):
      hwmon: fix error return code in abituguru_probe()


--huq684BweRXVnRxX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRn7AyAAoJEDjbvchgkmk+CB4P/024tJrsn2R0AqMpdyrStEVZ
oMFdoCv1imDocRZcDH9TzRGxscTkBayONya0s3pWu8hiNbv++rS4RS59ny96Qrnk
xwL/Di5zEgmZNKXhx2SZq4kmG7IVmdj9H3DGI66GlTa04mr/McL+YvMX+rrJCpnH
ZWqlxvc8RtFq+T/OQ4PXINC/n2ZtG9QiCcsq+TSiiqaTAHXfxVO3skij8Xtq+hLd
8Derfpftiqqu6pkAbIYnljDBmeKr+jZjpkTlciICUK/mYJG2R/96h6HzRVgZ+rKv
rptySWMUXYK06Kwn+eCUtFioKjG5kp39Je+BOIx4CKpHGg3uxx+BsQHIzEhhFkl0
ayUofmCuEc9b5udi53Mh8NbCl1asN4vgPWLpj0u4oM2+lsNh73kswlxmzAmk2iNn
UHHmZNoghP5FDyK+Lwxl5c1OCfZBl4PXN0n19U+xwazmJVASyqqfLmD/mp2glcNj
tiaf+kMr1KG2AlPzXMrB/IJpKhxbDo+kLoLRfr94+pY9pwy5PGWk351wN+BWRs9p
TQoThGbG+sAQNrV7oZwA8Q6fnhvPqCBd4S5PLQr/gsQKvjdr0/R3sjtLtICxYdNs
iWPVeGqebR8SnhX9ehEKMMmTtTEFC7Jhy6vmdT2Gu318u1vcJ4eES43KoMUdFX5F
AK2SGD02X4Rp2bRGaNGc
=Ukl7
-----END PGP SIGNATURE-----

--huq684BweRXVnRxX--
