Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755386Ab3KVKkN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 05:40:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18467 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751497Ab3KVKkM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 05:40:12 -0500
Subject: GFS2: Pull request (fixes)
From: Steven Whitehouse <swhiteho@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-/PYAlK5ZPiYRIicBvsCO"
Organization: Red Hat UK Ltd
Date: Fri, 22 Nov 2013 10:39:33 +0000
Message-ID: <1385116773.2739.3.camel@menhir>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-/PYAlK5ZPiYRIicBvsCO
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

Please consider pulling the following fixes,

Steve.

--------------------------------------------------------------------
The following changes since commit ea0341e071527d5cec350917b01ab901af09d758=
:

  GFS2: Fix ref count bug relating to atomic_open (2013-11-21 18:47:57 +000=
0)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/steve/gfs2-3.0-fixes.git ta=
gs/gfs2-fixes

for you to fetch changes up to ea0341e071527d5cec350917b01ab901af09d758:

  GFS2: Fix ref count bug relating to atomic_open (2013-11-21 18:47:57 +000=
0)

----------------------------------------------------------------
A couple of small, but important bug fixes for GFS2. The first one
fixes a possible NULL pointer dereference, and the second one
resolves a reference counting issue in one of the lesser used paths
through atomic_open.

----------------------------------------------------------------

 fs/gfs2/glock.c |    3 ++-
 fs/gfs2/inode.c |    5 ++++-
 2 files changed, 6 insertions(+), 2 deletions(-)



--=-/PYAlK5ZPiYRIicBvsCO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJSjzRhAAoJEMrg3m4a/8jSS8YP/AzK1wc/4awQQF1N5awKYY0b
rVBbnoWhuMfla6jrjPs7T0yHFNgyfMrqamURqMj8ptRhNWR1zU/udpne6rac6OHp
OkzlYjwqauUzV/Iuwo2MepEwwyAIt+CDFBLdxbYjLv9hPhAnvkEBfTZrxz2PPx2b
aD/TJOaiULmvQ7YV9YZeiZGVxOs53QnmPdI+3uYU61UEV9j1h58U4V9YQaNzgJbi
/T8GG+hTOOW7916qrIRENeJfAdmsG4iG6zEENo6roeWPhab0gifffWdneOzVy8pH
juDEByYQGKMwuQ5S6s/JAz678bTNDu0vCuGeYCXR6GGabRsrPWcR4Bz+Ujlv2fPd
CUdxQLk6RiJtluyPNBswezHTpsXQMxLYLbfB0hU54ajzfJs83oE6gw71scUIS4/v
MoOFJOkupr0/MGal73nkpVAxPNlENsB3tNkc8HHSzwuSK9Gq4mkMW9/mWX6KPHYz
6IvayWOFJE8q48BG+S2/U8OUunEzdO6JNFuiYzAYjVg6pgXcrck1rVzgEsesg64Y
3NP5NhDm7lOgcoWd9Je+Gov5hxi53CV9XgVahDE9Omcgj3sytummNUhXptH48zey
FzNfaPbaSOyKL/K82mRloquNsfUBTraVY8M6WmXTf6wJDaSSNeo9CxaXjIBrp51i
doD76yaaBS/6g46VWs7r
=CETJ
-----END PGP SIGNATURE-----

--=-/PYAlK5ZPiYRIicBvsCO--

