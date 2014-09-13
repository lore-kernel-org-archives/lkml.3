Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752190AbaIMCKD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 22:10:03 -0400
Received: from ozlabs.org ([103.22.144.67]:36120 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751889AbaIMCKA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 22:10:00 -0400
Date: Sat, 13 Sep 2014 12:09:53 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: Tree for Sep 12
Message-ID: <20140913120953.301f0d39@canb.auug.org.au>
In-Reply-To: <20140913115950.0331951e@canb.auug.org.au>
References: <20140912173817.3c719e7d@canb.auug.org.au>
	<54132FC7.1080004@infradead.org>
	<20140913115950.0331951e@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/x.vjQV06OHHGJz454uZhOAB"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/x.vjQV06OHHGJz454uZhOAB
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Randy,

On Sat, 13 Sep 2014 11:59:50 +1000 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> On Fri, 12 Sep 2014 10:39:19 -0700 Randy Dunlap <rdunlap@infradead.org> w=
rote:
> >
> > On 09/12/14 00:38, Stephen Rothwell wrote:
> > >=20
> > > Changes since 20140911:
> > >=20
> > ---------------------------------------------------------------------
> > >=20
> > > I have created today's linux-next tree at
> > > git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
> > > (patches at http://www.kernel.org/pub/linux/kernel/next/ ).
> >=20
> > No patch tarball?
>=20
> Hmm, sorry I didn't notice this:
>=20
> Pushing patch to kernel.org ...
> patch-v3.17-rc4-next-20140912 (1/1)
>   100 %      2,494.2 KiB / 15.7 MiB =3D 0.155   1.9 MiB/s       0:08     =
       =20
>    2554072 [=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D]  100%
> Compressing: .gz: 100% .xz: 100%
> Calculating sha256 for /pub/linux/kernel/next/patch-v3.17-rc4-next-201409=
12.gz ... logged.
> Cannot open lock file
>=20
> Randy: I will try to reupload the patch

The reupload appears to have worked.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/x.vjQV06OHHGJz454uZhOAB
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUE6d1AAoJEMDTa8Ir7ZwVi54P/0Wxz0PCKuWykrr1weZrClEY
PjNjFdrzIFIadXCT/yXde38SrJoma5ZvYO6zpV1GMAim7NqQyQNq32RBuUkF2prX
lPsXY5vRR2y0F/0LEScnIxQ2XHXbTiIjZMdPjnfjmZKBxq+xujX9yOZOXDNUm1/J
qdTstzH1XMdK/Sf3YaaJglQ2y+BwNh1FT8GTkbvwqG0+5njBX+7EzM9yCUzkCBb3
b4lxGR0y51IudOxCNds4Az26SsW29T52uE5CSN3h/j9ubXzsCOM1VvDr5wToKgJP
wVLSMc+9et6jfRUoWG69MatE3yJvzhH+IC6a4apzwRKxhPNOZl2Z3n9G85Dqinsr
tWZ26ySvQVtjsg4AYNm/ArGHhh2iyVV6lZ3PQtdSqGJtT7yVTiAPNdBItOGk5mPk
uFgxP9/u0CkVmQz5CjpZZtA2g1u42fxjqY3dQWCqLBzHcVEJA1txvwFKRCPFx1u8
TrIY20bjpMFij2am5+O2nTTurTDgLAibtruNJbB37lA+ioGoGYrD7NCCcV4bRw6p
9Iq76sx62S9v9IxyBTfo2IVjByCl5oCaUXPA8ZUvC2WGM/+3PiSydPRj4pKL9usf
vs/HlktNBL7k8tXz95R+ylux4WZGSSURheymzSTEly3W7lq4StVpsEUD/hGQ1P10
GsNJIsEm+pOpsWTXs/do
=3upk
-----END PGP SIGNATURE-----

--Sig_/x.vjQV06OHHGJz454uZhOAB--
