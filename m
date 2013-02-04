Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754019Ab3BDKWl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 05:22:41 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36886 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753072Ab3BDKWk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 05:22:40 -0500
Date: Mon, 4 Feb 2013 10:22:39 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@ingics.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regmap: Export regmap_async_complete_cb
Message-ID: <20130204102239.GF4720@opensource.wolfsonmicro.com>
References: <1359821653.26710.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+jhVVhN62yS6hEJ8"
Content-Disposition: inline
In-Reply-To: <1359821653.26710.1.camel@phoenix>
X-Cookie: Your domestic life may be harmonious.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+jhVVhN62yS6hEJ8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Feb 03, 2013 at 12:14:13AM +0800, Axel Lin wrote:
> This fixes below build error when CONFIG_REGMAP=3Dy && CONFIG_REGMAP_SPI=
=3Dm
>=20
> ERROR: "regmap_async_complete_cb" [drivers/base/regmap/regmap-spi.ko] und=
efined!
> make[1]: *** [__modpost] Error 1
> make: *** [modules] Error 2

Applied, thanks.

--+jhVVhN62yS6hEJ8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRD4voAAoJELSic+t+oim9oN0P/1+JbpO+E99c5597TOHA4Mdp
wPXjUpHYRz9WDVtg/KIa5R3OAi/liNLRkOdx8BAbUl6wX1tWChOQommF+KrLion9
JOqmkx0djRZs2JKOL+aNwreIMFqBt3clyjEO5WbEYOomPUxXcpDUIEdXcaNA8KaE
BvPsrcByVtwRUvbPZq2XYhbrVJ6JhnAf1I/UcxeiA8bJ1v+OjwlMvzisHqYqwQgP
1G/L0EVVjMfSKU9buf6ORIsePqyEIKv6/IcBU1TodWG8zlFKepFkB/OCVTuJmZS/
y0GnN0J4ez4A7O8Vt8Nj3PsDfaoHJ0Dvblw8eOqpL1/e8fw5N7hy9s/wPk3D/bFJ
3br7wNmftS92Xb2JZjhR7wpA7ZdMouvDCaquJhP7VgMcwONmOQZJ4reJikAycGSp
soeRVB7qgUfTQeWbI2cmlal9+Om95FLoQupxJYZS8ivjWV3SvKU6z56xhxPbA9gx
o9htcNKsjonaSyGIyZHZ4HRqmLy+dBz2lE+nEMDFdZopFpveYWgoChMdrDnL9nkN
yEArlyWYghdvmGlljWEnoFARp5Vv/pV6ChR5fSVmtOt/UJYRybXdZ2KjCk4OPtb6
THGpFEvtx7ysZxgzTcrd4fK4Zb0OEFD0YnSsFShcUnpGpCIwEBWX/P3fY0cHlIFQ
90A/8a4TypBsSO6lkw/T
=aeLG
-----END PGP SIGNATURE-----

--+jhVVhN62yS6hEJ8--
