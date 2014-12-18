Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751739AbaLRAbV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 19:31:21 -0500
Received: from ozlabs.org ([103.22.144.67]:33823 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751682AbaLRAbU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 19:31:20 -0500
Date: Thu, 18 Dec 2014 11:31:08 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Prasad Joshi <prasadjoshi.linux@gmail.com>,
        =?UTF-8?B?SsO2cm4=?= Engel <joern@logfs.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: status of the logfs tree?
Message-ID: <20141218113108.150d2edd@canb.auug.org.au>
In-Reply-To: <20141013113304.599de9d2@canb.auug.org.au>
References: <20141009105418.32aad6ab@canb.auug.org.au>
	<20141013113304.599de9d2@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/ekCyowV_mpHT+pw./dvnl0V"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/ekCyowV_mpHT+pw./dvnl0V
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, 13 Oct 2014 11:33:04 +1100 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> On Thu, 9 Oct 2014 10:54:18 +1100 Stephen Rothwell <sfr@canb.auug.org.au>=
 wrote:
> >
> > The top commit in the logfs tree was committed in November 2012.  Is
> > there any intention to ask Linus to merge this tree?  Or should I just
> > drop it completely?
> >=20
> > It is a pain because it takes considerable time for git to actually
> > merge it.
> >=20
> > $ git log --oneline origin/master..logfs/master =20
> > 339466142b3f Fix the call to BUG() caused by no free segment found
> > ab2ec19f42dc logfs: fix possible memory leak in logfs_mtd_can_write_buf=
()
> > $ git diff --stat origin/master...logfs/master=20
> >  fs/logfs/dev_mtd.c | 2 +-
> >  fs/logfs/super.c   | 6 +++---
> >  2 files changed, 4 insertions(+), 4 deletions(-)
>=20
> Ping?

Ping?

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/ekCyowV_mpHT+pw./dvnl0V
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUkiBRAAoJEMDTa8Ir7ZwVNzEP/jOPH8rtpcKiZdOJKv7FuejJ
2XgK39pYRNG5uh4bBR+QGipgCZM0x9bDv7TKs5gZ6nv2VwUBfllvwtuuE9/lV2Q4
RJnFYxsKbSUtaORZ0uSMd6vQ3YehWzt/AUY91yCY6Q6/nwny3qVhQD+IYEkb/rY6
YUHOB7vZRcM+LLR563PflEbsyf6kcHgPq4zyBarpfCrTAxRZzxQRAjmSWSXgEa++
6qQUd4NPfKl8AVCUToIyAz8tV/L0JTk+CZypSVHhK1ZIvVsFUmFua4pzhl1C7boq
OlvtdUPcgTzR53DLP18TukJp2jSYHtw47/pK7yR0NX3oSv6PmOWM5SUgji5IkG/S
64chdnO9vZ4uSYTlAeJK/maVe5x+FRDCp29kUDSKpvumnxwtPTVzj3bhiIv/YX2+
6jwl9WUw922/T8i5WWvFcOglBxIWiURXcao0bWgz9KEXeyaGYjrbfKa498OfCyZR
odEuEiCs+ZaY6jEYQRK6jRc/hK7W/LtRogCDI3QW7fXTIThdQoQrw10d7c2E9BhS
gVBJnBs+5+YeTFmdjnS5JviTYnv817m0ZpBT2Lm9YMdTQfskwqlYXxXqdY2caQLO
62cbZZK0DJ5UlD1bfmh/gP28lty3r0Z5CCTmZZ/DDj1etp8l4P1ft6sC59d96KVK
+aFkpDrxglc6LDih4xCW
=Fr8D
-----END PGP SIGNATURE-----

--Sig_/ekCyowV_mpHT+pw./dvnl0V--
