Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754221AbaBFAjD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 19:39:03 -0500
Received: from ozlabs.org ([203.10.76.45]:39367 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753623AbaBFAjB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 19:39:01 -0500
Date: Thu, 6 Feb 2014 11:38:45 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: jaegeuk.kim@samsung.com
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: bad commits in the f2fs tree
Message-Id: <20140206113845.081b6847d8263f2fd37adefd@canb.auug.org.au>
In-Reply-To: <1391646482.25542.72.camel@kjgkr>
References: <20140206110401.7888b06cbd651b842404b902@canb.auug.org.au>
	<1391646482.25542.72.camel@kjgkr>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__6_Feb_2014_11_38_45_+1100_gvJnKgqab+Ba0b67"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__6_Feb_2014_11_38_45_+1100_gvJnKgqab+Ba0b67
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jaegeuk,

On Thu, 06 Feb 2014 09:28:02 +0900 Jaegeuk Kim <jaegeuk.kim@samsung.com> wr=
ote:
>
> 2014-02-06 (=EB=AA=A9), 11:04 +1100, Stephen Rothwell:
> >=20
> > Looking at the f2fs tree today, it has *copies* of several commits that
> > are in Linus' tree (including b522196a6ffb "Linus 3.14-rc1" which is
> > commit 38dbfb59d117 in Linus' tree).  I assume this happened when you
> > tried to rewrite your tree. :-(
>=20
> I fixed that.

I have refetched your tree and will use it today.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__6_Feb_2014_11_38_45_+1100_gvJnKgqab+Ba0b67
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJS8tmbAAoJEMDTa8Ir7ZwVqNkP/Av9ZAcga4vD8iAetDcVE4ot
3TLDROdpc9Ug6zpGA9K4T4AVqud3A5aSW9YapnJrN/m3HrFy3XkcmCerw9EjcXmW
BBZYoegmr33cpcRPE6rpZgg/IViRcVKGLysMYe3JGaTijCM4vBVgux3vwGidcvTT
jyhblOPhYVwdLxQ+2JL/VQjqAU8G9drg8xLz3I24dW7X1GdYw0vuWW40BAhUqyzX
0P7ZU2DhIIJumEHdUm5xswRwlAoPECd7wGcxg9oD6Ldz00a/TkzUA1u91mtYRsto
CHPCl4CFiuFMZhKR25KN5owwWnW/sQ6QeppzNlqHx7ZxWWF4ZrzZXlACOGHB5ySc
uoOcfgacj6U2z8ogHMj9I9xGUcJ4/eYr+03ahrZwyiKaoPjks7sii9PZfPHfl9qo
uwW50KBgGK+DDa3hMemSNX6JUxoBYCgor7v4iGXphpeCvBL0VKDWuOPPjKgTqy8a
mEnIxpRYD7DhHiJsu/znnud1Y8uNGKUqFphn0b4sX0FGosi9k4whYXtj+3jtw3w0
L86uyJY7YpAguNERPoz2ejsRwHb4jFbewEs8UE031rsf7FS0qwaYZZkxi6lA3dEF
vU/iwrhRlTSXO/Myp66h1Neh+YA0f4z1E5q0ymz08JeG2EX4vhL1eBeg7cKHHy9p
2/i0IljDxd58QZyMwYVy
=SGjN
-----END PGP SIGNATURE-----

--Signature=_Thu__6_Feb_2014_11_38_45_+1100_gvJnKgqab+Ba0b67--
