Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933407Ab3DGLdO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Apr 2013 07:33:14 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60642 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932975Ab3DGLdM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Apr 2013 07:33:12 -0400
Date: Sun, 7 Apr 2013 12:33:09 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Chen Gang <gang.chen@asianux.com>
Cc: =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
        Greg KH <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] Drivers: Base: Regmap: fix warnings, use %zu instead
 of %d for printf format
Message-ID: <20130407113308.GP6597@opensource.wolfsonmicro.com>
References: <5160E113.9080502@asianux.com>
 <8761zybtdg.fsf@nemi.mork.no>
 <51613B16.3030406@asianux.com>
 <51613D37.6060901@asianux.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="X78YbkCBd9ye7Cvs"
Content-Disposition: inline
In-Reply-To: <51613D37.6060901@asianux.com>
X-Cookie: Make a wish, it might come true.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--X78YbkCBd9ye7Cvs
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Apr 07, 2013 at 05:32:39PM +0800, Chen Gang wrote:
>=20
>   fix warnings (with EXTRA_CFLAGS=3D-W):
>     format =E2=80=98%d=E2=80=99 expects argument of type =E2=80=98int=E2=
=80=99,
>     but argument 4 has type =E2=80=98size_t=E2=80=99 [-Wformat]
>=20
> Signed-off-by: Chen Gang <gang.chen@asianux.com>

I've already applied a patch for this from someone else.

--X78YbkCBd9ye7Cvs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRYVltAAoJELSic+t+oim957sQAIpRdAl1EpBBmMsR//dEfuLt
3nItGTK7DLlaHMzSSnITP1WHP7GaZ5ohFMcFc55sE2Nr+NiM+YiUyOQMhVJNH7pb
OW7JDJx3PmCl8vQVdsukEJR/8IDwBlQxJKk1jHXYdKyWTjZDfO1HYLKe8cOgWWYG
WtoX50f+Em/C6bIA8VuHRd8Ens9sU9mSiCCqz1GmK7oNnzkcxEIH5UO8IoTsSXBW
Deh/fZJaRiZR2U1BgCbP9SjgBJWzERvlLDg/kfG8Iyd+GpNsOT4MHiEtIz1lJKdL
wOpb9WclXtAMzlbOgnZEgR3YNYKrJ8se/6gKFCrNxKKte9H7ESzdX5yXOR4tZM15
DP2y8Kz0UmeBFeSGVKomwwszHGUdFlYiDWgdXln7EbeRxEDP9LeyDjK5C9pnqbKL
vlnxciCXdvaDxND4RnR78cL9tv2A83hvP3oJ0jmSjEYMNpj6EjdXTaWyqHcxY5Fx
eAIVpq9iSC+Efxk150DE3BegWioIBGPcMd2KDdJ6y4H2tZMojK2Z1ErTUAxmn9xF
eCjEA4vHTUpUv9Q4vNQVJkZ2QTWovvlxzjPFECb+7U7n/UO9Rp2w8RQoWrI2erfI
hBj++EQf/iOEweQ5Rh7k4BaIaoBj98OhvePyHcF6g4HauYViA3CST+Pyj1VIk/QF
uCdrcoNFVIuV8/D4QfuH
=8aNl
-----END PGP SIGNATURE-----

--X78YbkCBd9ye7Cvs--
