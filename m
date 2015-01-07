Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752030AbbAGKYt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 05:24:49 -0500
Received: from ozlabs.org ([103.22.144.67]:33254 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751004AbbAGKYs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 05:24:48 -0500
Date: Wed, 7 Jan 2015 21:24:39 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Sedat Dilek <sedat.dilek@gmail.com>
Cc: linux-next <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Missing next-$date git-tag when pulled-in linux-next.git on top
 of linus.git
Message-ID: <20150107212439.7254d389@canb.auug.org.au>
In-Reply-To: <CA+icZUVVPe68VGwRcc5ztxGwHi83wHJVeiJMUuBynm2LypoaZA@mail.gmail.com>
References: <CA+icZUVVPe68VGwRcc5ztxGwHi83wHJVeiJMUuBynm2LypoaZA@mail.gmail.com>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/uhU2+1irw3w4kt+JbztFIuO"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/uhU2+1irw3w4kt+JbztFIuO
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Sedat,

On Wed, 7 Jan 2015 09:24:57 +0100 Sedat Dilek <sedat.dilek@gmail.com> wrote:
>
> My workflow looks like this
>=20
> # Get mainline Git tree
> $ git clone $LINUS_GIT_URL
>=20
> # Checkout latest mainline (rc) tag (aka -next's "origin" commit-id)
> $ git checkout -b Linux-v3.19-rc3 v3.19-rc3
>=20
> # Base to pull in current -next
> $ git checkout -b Linux-next-20150107
>=20
> # Pull in stuff from next-20150107
> $ git pull git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.=
git
> tags/next-20150107

Just do

$ git pull git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.gi=
t master

That should also fetch the next- tag.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/uhU2+1irw3w4kt+JbztFIuO
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUrQltAAoJEMDTa8Ir7ZwVuRcP/3hSHL1v5/73c2vBFQz8wfSz
+sRCigtkdGMFfFHikFPBYoJVi0mVeZw2E5KMpFwxtQ0PR9Lxdzgd7B6gHNeBA0K2
LGIxlI/G9Q+VUfqsocCTk1DH7CDNn22wa912GyrY9YsWsjHbASNJqKZO1kiuk7YF
rUTCkHu18rU3uNbQ815SuTRlJ0Ubi/Z2J0NfsBj0P8HMkmoV9ZkQLpVyKBsCBbjg
aSuZfvOJV8QFmVM9ocehuVuUg3z7sNMG3EFqt9tte2AldO5SiLHebGqcbJ17+fcP
0o9MPayxrjnsaZ1f3C3WClznx2pVQnplsmlPi8MDBJEhfUEM3p9AfZZhjJou9cY1
q+pPeVbWCLz7OLrCLo4bASSWFQHVDFxCQAoZ0ekevnvq4NrV2+Sr+mKqud8RARWm
k9u6XUW+ncnm8C+lc8vuUg1joGtCBMZ3+WucEUSoDWUH653TZ5vGiaeXj/LnXdUn
dNaC0mV85+BqDRdMOOpOQRqEg6u6fgClV9PdPtouATnsSrTBv1PenMD+F0vJskRK
SUJNiP7CHIFUR3wr1Fl4mVWRQJ0KjVo4JSqkI+bbPEm43kzp85gV6McTxKgfxMG5
HIf/ZaknLbJ1Iay7QmnuCFUrmcxM+0Fs7H3O2wrfEJDAPRyjRUuKjMwM3y+ijfxr
1qvunotwYV8oSG6ZV6zg
=xeHh
-----END PGP SIGNATURE-----

--Sig_/uhU2+1irw3w4kt+JbztFIuO--
