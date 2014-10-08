Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754713AbaJHXyh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 19:54:37 -0400
Received: from ozlabs.org ([103.22.144.67]:41946 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750979AbaJHXy1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 19:54:27 -0400
Date: Thu, 9 Oct 2014 10:54:18 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Prasad Joshi <prasadjoshi.linux@gmail.com>,
        =?UTF-8?B?SsO2cm4=?= Engel <joern@logfs.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: status of the logfs tree?
Message-ID: <20141009105418.32aad6ab@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/m+iv15T6OF.euIMgDwp06m/"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/m+iv15T6OF.euIMgDwp06m/
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

The top commit in the logfs tree was committed in November 2012.  Is
there any intention to ask Linus to merge this tree?  Or should I just
drop it completely?

It is a pain because it takes considerable time for git to actually
merge it.

$ git log --oneline origin/master..logfs/master =20
339466142b3f Fix the call to BUG() caused by no free segment found
ab2ec19f42dc logfs: fix possible memory leak in logfs_mtd_can_write_buf()
$ git diff --stat origin/master...logfs/master=20
 fs/logfs/dev_mtd.c | 2 +-
 fs/logfs/super.c   | 6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/m+iv15T6OF.euIMgDwp06m/
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUNc6vAAoJEMDTa8Ir7ZwVF7sP/Rd/F+Pazrhsw7ULLy53Viph
GNJk7i9YpOtum+Tu0IpiqVsdC2Ee4F4k78ESWP4y1RlO6WBdvZY+1SYK139dUTsE
HHbM5AZ4KiQTz+JnY2RjWDmPK7j+nam2zpCud4Exg8RxvR2rQGueSHuhafXOWwfs
RCrDrV4V4N03SLats8d3gI4a5asI0X03HDA3HHT9VnqsgtN24H7T2ZG/KorjYiYp
Oj6+lwRx+dk8JYSuw/l8GYT6zGlUBjz2dbm2tArGTiPDPGJRe4N5ZcJQaqYRoZVg
Hm4lFSwap7lF40CdfyS0BP61eyta140IyeSc7CdnzrSPXC2/KEBo+pxG4lrbOmuC
tFdXo8mm9Q5ZugFEcrRhbYf25qCbPMx8TgyFmM7AHLWzrKJZrelsbcg/zsVTJNU7
ONkNNrAHH/KKYG2huor4J0HK7x3bS5NGNs0ZLRG9n0Fs8ZvQVRUMa5Bms9oRNnJr
0DylY9y5kt3snrX6Awy5A8j5k1IkUvtcYAQzqbfQFHIbVE1VePJSqQpFO0aGtFiC
S1r2L3nw36brrexeWDLlhIKI1iEtPUu0Nim8lv0d+YwTIa3T6H0Dlm7TMpgIkT3A
FRQ8nPDXmAuBJnnT0nNj5lfTJOeenu1pxpzVlvS8j41f2j4NZDxnOXEmBUkAN2Ry
sM3M+aFRVDxG6Sqpp4FD
=dHx1
-----END PGP SIGNATURE-----

--Sig_/m+iv15T6OF.euIMgDwp06m/--
