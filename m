Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758212Ab3GMRr2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jul 2013 13:47:28 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:46792 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752058Ab3GMRr0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jul 2013 13:47:26 -0400
Date: Sat, 13 Jul 2013 10:47:27 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.0.86
Message-ID: <20130713174727.GA4773@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FCuugMFkClbJLl1L"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--FCuugMFkClbJLl1L
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

I'm announcing the release of the 3.0.86 kernel.

All users of the 3.0 kernel series must upgrade.

The updated 3.0.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-3.0.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 MAINTAINERS                |    1 +
 Makefile                   |    2 +-
 block/genhd.c              |    2 +-
 crypto/algapi.c            |    3 ++-
 drivers/block/nbd.c        |    3 ++-
 drivers/cdrom/cdrom.c      |    2 +-
 drivers/scsi/osd/osd_uld.c |    2 +-
 drivers/scsi/sd.c          |    2 +-
 fs/hpfs/map.c              |    3 ++-
 fs/hpfs/super.c            |    8 +++++++-
 fs/nfsd/nfs4xdr.c          |    2 +-
 net/ceph/auth_none.c       |    6 ++++++
 12 files changed, 26 insertions(+), 10 deletions(-)

Ben Hutchings (1):
      SCSI: sd: Fix parsing of 'temporary ' cache mode prefix

Greg Kroah-Hartman (2):
      MAINTAINERS: add stable_kernel_rules.txt to stable maintainer information
      Linux 3.0.86

J. Bruce Fields (1):
      nfsd4: fix decoding of compounds across page boundaries

Jonathan Salwan (1):
      drivers/cdrom/cdrom.c: use kzalloc() for failing hardware

Kees Cook (2):
      block: do not pass disk names as format strings
      crypto: sanitize argument for format string

Mikulas Patocka (1):
      hpfs: better test for errors

Tyler Hicks (1):
      libceph: Fix NULL pointer dereference in auth client code


--FCuugMFkClbJLl1L
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR4ZKvAAoJEDjbvchgkmk+QfIP/171SQFZD29nsoJxhquQ5bMq
8kYK0Df6veOVTUJdJsnZI/fq/jtlXO/tGeynpW0WXogiQQ0vUFTs87oUY5hyR/81
SQFWQCSmqRMwWZOsjZLIehF2Uhhx3afvI8CuRW9qfvwZQXwARppclwTuzVdNf1iH
L6eGbJl9CesU7SO7b3jb0Wqmxd4C9j4akECzFrpKI64U9MjrqsMJu+X49CeQ6wN1
Vs1a/Nq3nHusKNYgZHv5el1xg3SfQSLukcNUn88/2h2ZorUT6OrbCxuGFV3c+YE6
9bED6xJLcRPgsS+t2jaWx3UUN16WoJUW1miy2l3a7vslkHKxcCCESxgenp8MA79n
TgT4iifIObMn1/Iql2YnZTFTh5qRuMoxUdmXn5JF9LBEq2UnlwhSRag7PJjlfH1w
Iab6kuRsm9K2MBFo2xNfeSKEBKS6jvVZ4XlLkbNW+C58I+m63SH745FZ9XFMPjXv
Sz8T1tSw6Lakx11sgwtg0BgdlSq93V8SzHR+XTIi94VrLu9aQBIMwoalJVxTkaRh
pzuOG2jqyS2vtZKlP17WK0ALAIZVeavwaPJJc2N9CkcdHyFt0dZC9H1oLDyPd0Xy
v271YgaDxBIkVgY6ydqgBB6+CGV7qFlh5spMy22FxC2MXxWyicX8BkBMuWPXcjJN
lG8U0wiUPExuP2fmPqch
=yQDT
-----END PGP SIGNATURE-----

--FCuugMFkClbJLl1L--
