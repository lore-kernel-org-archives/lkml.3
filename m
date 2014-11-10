Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751676AbaKJAca (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 19:32:30 -0500
Received: from cantor2.suse.de ([195.135.220.15]:55515 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751311AbaKJAc3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 19:32:29 -0500
Date: Mon, 10 Nov 2014 11:32:21 +1100
From: NeilBrown <neilb@suse.de>
To: =?UTF-8?B?0JXQstCz0LXQvdC40Lkg0J/QvtC70Y/QutC+0LI=?= 
	<zbr@ioremap.net>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        GTA04 owners <gta04-owner@goldelico.com>
Subject: Re: [PATCH] w1: support auto-load of w1_bq27000 module.
Message-ID: <20141110113221.17cb1535@notabene.brown>
In-Reply-To: <18301415578289@web5g.yandex.ru>
References: <20141108103249.4f86786c@notabene.brown>
	<18301415578289@web5g.yandex.ru>
X-Mailer: Claws Mail 3.10.1-162-g4d0ed6 (GTK+ 2.24.24; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/oG_KpANRhK7=dosA7DD.B1X"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/oG_KpANRhK7=dosA7DD.B1X
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Mon, 10 Nov 2014 03:11:29 +0300 =D0=95=D0=B2=D0=B3=D0=B5=D0=BD=D0=B8=D0=
=B9 =D0=9F=D0=BE=D0=BB=D1=8F=D0=BA=D0=BE=D0=B2 <zbr@ioremap.net> wrote:

> Hi
>=20
> 08.11.2014, 02:33, "NeilBrown" <neilb@suse.de>:
> > 1/ change request_module call to zero-pad single digit
> > =C2=A0=C2=A0=C2=A0family numbers. =C2=A0This appears to be the intentio=
n of
> > =C2=A0=C2=A0=C2=A0the code, but not what it actually does.
> >
> > =C2=A0=C2=A0=C2=A0This means that the alias created for W1_FAMILY_SMEM_=
01
> > =C2=A0=C2=A0=C2=A0might actually be useful.
> >
> > 2/ Define a family name for the BQ27000 battery charge monitor.
> > =C2=A0=C2=A0=C2=A0Unfortunately this is the same number as W1_FAMILY_SM=
EM_01
> > =C2=A0=C2=A0=C2=A0so if both a compiled on a system, one module might n=
eed to
> > =C2=A0=C2=A0=C2=A0be blacklisted.
> >
> > 3/ Add a MODULE_ALIAS for the bq27000.
> >
> > Signed-off-by: NeilBrown <neilb@suse.de>
>=20
> Looks good to me.
> Acked-by: Evgeniy Polyakov <zbr@ioremap.net>
>=20
> Which tree should this patch use to get into the kernel?

MAINTAINERS lists you as the maintainer, so I though you would know.

When is doubt: send to akpm .. or gregkh.
It looks like greg has more Signed-off-by's in drivers/w1 than akpm,
so I'll add your acked-by and send to him.

Thanks,
NeilBrown

--Sig_/oG_KpANRhK7=dosA7DD.B1X
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVGAHlTnsnt1WYoG5AQLfWA/+JX7iSX5Wv+CyThWd2h4TIEpyu4/TSPmm
r5eXdBDj8reiOYVLQbGNGwANmUvz9xw4C/kHucktZ31L7fhjP3AdURlbAqRujA3R
sMZH4u4+2iiG3HNboP0GiEuOz6LtakIoyf6Q58L3Il7ZwKk0lu6mFgoViHfdT84B
QVd1VvM9VNXXyYg2EZ/pR39cUaRWAcF1NTizDgVTp56Uqf6abT8GFVh4osMliNAO
4mg8fRuEEDerPCVngKhGrK3Yq8bi+kN+tuhEl9+wl9+m9ekV/aVeZFT0hOkIWqMe
ObeusvQ5RmwjTGR1NkqZURB8hQ/lgJLqXcHVE9vb+yuF9svQFhGZ0c0vz5Hu+Czz
619l2GhDZXVme3Gho9YLlzCkQJsF9U7PeP2Kdhg/bxgqSBJXfVj22BHTLENdIiom
4qJc9jf/xtWSz8EXw1CkIe6SfyT9PltdsgpXu1WwMvFheGEBrTks+DuvG6hV1d48
2+pFn/V+S/riWAgOjLU6y8F5Lg7VvULQs/21OGxjKfHI4cfBibdr+g3tGR3QsZ6W
uT5X0HF5bYEIFC+a6A4Qrp23tO2VFtdzyLNsETRNWJL/ppS8JLd+37viWuzKGItX
S68iJq3RwEyDWZ8hZqwDtP88XGtTYEy00HUXcG7klHbrxktfOYmZjKjvTlQcfKcJ
P66m3crPIdQ=
=uFz4
-----END PGP SIGNATURE-----

--Sig_/oG_KpANRhK7=dosA7DD.B1X--
