Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753309AbaKZVqY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 16:46:24 -0500
Received: from ozlabs.org ([103.22.144.67]:43494 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750811AbaKZVqW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 16:46:22 -0500
Date: Thu, 27 Nov 2014 08:46:14 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: James Morris <jmorris@namei.org>
Cc: Kees Cook <keescook@chromium.org>, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, Pranith Kumar <bobby.prani@gmail.com>
Subject: Re: [PULL] seccomp update (next)
Message-ID: <20141127084614.209450b9@canb.auug.org.au>
In-Reply-To: <alpine.LRH.2.11.1411270022240.22560@namei.org>
References: <20141125194319.GA9328@www.outflux.net>
	<alpine.LRH.2.11.1411270022240.22560@namei.org>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/foTiUGKX5T0aR23Wa/rWWth"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/foTiUGKX5T0aR23Wa/rWWth
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi James,

On Thu, 27 Nov 2014 00:23:06 +1100 (AEDT) James Morris <jmorris@namei.org> =
wrote:
>
> On Tue, 25 Nov 2014, Kees Cook wrote:
>=20
> > Please pull these seccomp changes for next.
> >=20
> > Thanks!
> >=20
> > -Kees
> >=20
> > The following changes since commit 5d01410fe4d92081f349b013a2e7a95429e4=
f2c9:
> >=20
> >   Linux 3.18-rc6 (2014-11-23 15:25:20 -0800)
> >=20
> > are available in the git repository at:
> >=20
> >   git://git.kernel.org/pub/scm/linux/kernel/git/kees/linux.git tags/sec=
comp-next
> >=20
> > for you to fetch changes up to cb24de187b9a0717246f05afc0f2be070e075d80:
> >=20
> >   seccomp: Replace smp_read_barrier_depends() with lockless_dereference=
() (2014-11-25 11:40:24 -0800)
> >=20
> > ----------------------------------------------------------------
> > Improves SMP dereferencing with new macro.
> >=20
> > ----------------------------------------------------------------
> > Pranith Kumar (1):
> >       seccomp: Replace smp_read_barrier_depends() with lockless_derefer=
ence()
> >=20
> >  kernel/seccomp.c | 7 +++----
> >  1 file changed, 3 insertions(+), 4 deletions(-)
> >=20
>=20
> This is what I get when pulling to my next branch:
>=20
> 9128 files changed, 468773 insertions(+), 340317 deletions(-)

That would be because your tree is based on v3.17 and Kees' is based on
v3.18-rc6 ...

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/foTiUGKX5T0aR23Wa/rWWth
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUdkosAAoJEMDTa8Ir7ZwVIRAP+gLky5YSvgjNQgm1SMvdJnjV
9wGq5KkoEW8AJ5eKR+V34zG3q5ImN3BwV1NYounREuyowwY0OOq/BbiO25n1lunV
n29QN0bCmv7r4D/WkPZ/X4Ox4WR1AymtY2cgILWqfD6ZIP4AWWABvegy+2UXgy+/
PkdU5OEFXzVJv7rxAMTwy4g3WppkrF6O0RoPH9LS617fTauPqk4w+BpQbh+z4fiQ
UUE2pVDarX1T427Xf21k5pvkU1cEzR3ZOXiXgfndUP4ITJiTG6MUH2k4c7La8MGQ
Rehvci5ZiO7pFLv0D6hLzMrkZEmENV5MrSaed7iHf7qjlIX35usyd0S31IELK7vU
pS8pqwNu+knSRosxnW7lpgUt96XtrGrp/oJIBj2v4UNdtgRWGrjK5nBs+5P12cJU
cgs2vWz/FLmK9IeGyieqwHHzXURewcxdtW6sRNwOsUCrZthw4q/R4ahLfDWFElD2
1bLJEKXcoRLOO/fALf+JnfEFDqzeJAchB0MgpryrKbnLilvntVl6gcmZ5eub/cgS
iOOxSjhrMYybAwH34gMHVQn5INjdMD/3wkeIYepkK+vCdI7XA/8H1J2nTQwBk/zV
Z/XgYSqIJvweW/f8wynw8iRYtxO42FWmsV9X2+XrVU2DYxYfo4ojHBeaeYXUgAlV
S0F/GzqFxo1mrsu1z2QE
=60+/
-----END PGP SIGNATURE-----

--Sig_/foTiUGKX5T0aR23Wa/rWWth--
