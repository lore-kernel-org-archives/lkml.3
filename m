Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752903AbaGUHtV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 03:49:21 -0400
Received: from ozlabs.org ([103.22.144.67]:44047 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752140AbaGUHtU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 03:49:20 -0400
Date: Mon, 21 Jul 2014 17:49:13 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build warning after merge of the random tree
Message-ID: <20140721174913.09d5de01@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/0EdBJA5nAhChs1z7=l7yNmJ"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/0EdBJA5nAhChs1z7=l7yNmJ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Ted,

After merging the random tree, today's linux-next build (x86_64
allmodconfig) produced this warning:

drivers/char/random.c: In function 'SYSC_getrandom':
drivers/char/random.c:1526:6: warning: unused variable 'r' [-Wunused-variab=
le]
  int r;
      ^

Introduced by commit 386474e168a8 ("random: introduce getrandom(2) system c=
all").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/0EdBJA5nAhChs1z7=l7yNmJ
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJTzMX+AAoJEMDTa8Ir7ZwVjd0P/i8qFgiAe1tRX6JfRoLyu+AX
IygVK+VEFJnvLXpXgevV6OvVPmKCAcw0C0xFhFj5z0qop0H/5q8HsC7tRSc75wc+
7PjEPIkndnVbmVcRhJ6gt4FkL/rBKlcp8mn5GPCb2OzM/rNj/MdBORJ6mbWFTZmq
/9v8KTvs2HlLc5L8e7Ar5+jQDDnt7f0HKWeM+RuOKZV0LExRYEObNQU7jnhxqv1k
YX1/Dgfa76Y71Xr2SUoETt9fjKYtE0Autz9NtR1P3aqZ/8HHfHkgVdvvYpZ1BptF
C4AzRTERiU3eYQ31lwWahsUGyf5JnxNJ8UPjm+pIcx+HHY3dzGfvuhE3Wo7x23NJ
dGK/t36mWAxLa6F/tOntrB9+g20UQF0TuOIDNtInlgXNiaiGZoVcmD+rOJOg3CKn
wuFaFRI//A8Xx7i5+j9J/gPjFRijN5BQ0SmXt6wxCck2ijBrCHJmbEsliXt2lhj6
XSYUu1LgvqxLokCoprCCwUlcnGr2qjHXZpKp8Uwo8m2G+1eAhbRdDMz+CJNTYiDD
Oocq3L7lrbCiyZm1C8S+A9bm5fAs1TWHysFvTO1OrFRATTu+0DWrG4LsW61wfB2n
TwgzOZzL9mUAByaI76Uq1S7+CD54t9wFZWXimGcKEED7enM3AnaanueTc2QlBC7N
lCoX915EaSHRoLhyYnQC
=tWC+
-----END PGP SIGNATURE-----

--Sig_/0EdBJA5nAhChs1z7=l7yNmJ--
