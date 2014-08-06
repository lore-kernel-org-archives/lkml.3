Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755661AbaHFL1b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 07:27:31 -0400
Received: from ozlabs.org ([103.22.144.67]:42924 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754118AbaHFL1a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 07:27:30 -0400
Date: Wed, 6 Aug 2014 21:27:20 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Richard Weinberger <richard@nod.at>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>
Subject: Re: [GIT PULL] Global signal cleanup
Message-ID: <20140806212720.66dbd58b@canb.auug.org.au>
In-Reply-To: <53E20F1E.2080606@nod.at>
References: <53E20F1E.2080606@nod.at>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/E=u+L6=k3oyshtyASGDyD1V"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/E=u+L6=k3oyshtyASGDyD1V
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, 06 Aug 2014 13:18:54 +0200 Richard Weinberger <richard@nod.at> wrot=
e:
>
> the following changes since commit 19583ca584d6f574384e17fe7613dfaeadcdc4=
a6:
>=20
>   Linux 3.16 (2014-08-03 15:25:02 -0700)
>=20
> are available in the git repository at:
>=20
>   git://git.kernel.org/pub/scm/linux/kernel/git/rw/misc.git signal-cleanup

This has all been rebased onto v3.16 but none of the patches changed.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/E=u+L6=k3oyshtyASGDyD1V
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJT4hEfAAoJEMDTa8Ir7ZwVYWkP/RPnY8WkaWMtiuOF0bG3+l0b
aWVMG7OqJkXQLvLkjgxW19AHEvkEjd89Paptp0LGKCM6XI0MQRV678aPlwI/3SXM
KcZewCULEhgcZIo9tfXBRc0IF1pCl6HNGO+jaZCCYTCIsnrejSOV0b35O5pb6DSA
Y44lUIb6qIAS/fMMYX97hoLzY8XxMNGeLQKiTsKjMReutVJKHi7xN7/k+4QmdQG5
rixfygnESI6UNNG8Yu7EXeXGsn+wD4qkmCscqtcmDyrYPShP5ZdSaEUv9fadHgll
i9wxTScY9PirTsdzDV3GeDFzdYhY6o0vnNwwEhee76+tS4oa712bT7UjhM3/QRsd
OuP0WEoTua9JWFzFYTdLvg596hgIeL4QPh3ROcHMczxGioIqUbGbI84HujnbKerI
3zLXmet06Wyb+u754STTkXfsqylPzF7sf59y26bBmAlwevJKDBvFahdcVlZfP3xj
M+8YEoK90Lzi9Swglg4SLR7WEKTvA8tu3Oebw2wnwweTcar6+L7W8FCf3kO3686L
Pv7y9Y8hcwF+owOdc5RLnF+fgBiw5WxFSWYy77TCcE1yvRXmtc7fgMJlMbJaP60I
A0YhZzJnodHBNmapB8jERKT9LqlXU3B+PQXtfRzX1AD44BE1oOLT/yE+8P+AkJPq
u3fPgJalIC1KVRRAY//G
=rlUB
-----END PGP SIGNATURE-----

--Sig_/E=u+L6=k3oyshtyASGDyD1V--
