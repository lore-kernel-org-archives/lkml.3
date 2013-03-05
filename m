Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752969Ab3CEHEX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 02:04:23 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58988 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752440Ab3CEHEW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 02:04:22 -0500
Date: Tue, 5 Mar 2013 15:03:41 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@ingics.com>
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>,
        "Jett.Zhou" <jtzhou@marvell.com>, Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND 1/3] regulator: core: Add enable_is_inverted flag
 to indicate set enable_mask bits to disable
Message-ID: <20130305070339.GE9391@opensource.wolfsonmicro.com>
References: <1362464160.1111.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4Epv4kl9IRBfg3rk"
Content-Disposition: inline
In-Reply-To: <1362464160.1111.1.camel@phoenix>
X-Cookie: Beware of Bigfoot!
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--4Epv4kl9IRBfg3rk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 05, 2013 at 02:16:00PM +0800, Axel Lin wrote:
> Add enable_is_inverted flag to indicate set enable_mask bits to disable
> when using regulator_enable_regmap and friends APIs.
>=20
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> Reviewed-by: Haojian Zhuang <haojian.zhuang@gmail.com>
> ---
> This patch was sent on https://lkml.org/lkml/2013/2/16/14.
> This resend is against linux-next tree (20130305).

This doesn't apply against v3.9-rc1...  what are the dependencies?

--4Epv4kl9IRBfg3rk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRNZi2AAoJELSic+t+oim9qmMP/Ra/A/IseMMFEmdvv7Sx/ScR
0OaERenrXHVkEhxbRGRDtfJPqjFMUxrHhU6YF3t/nyFgCbe19l6OWXKOt7kYTEpo
O9KU+m3ml0erQ1FKdhugi/dVC9pT5WDEFprJKsxuy1XDlJb0eahHMpYhNJwBnXMR
C4QD7a7WvkCrT7FOzENL+eUAEC/YgCe9ZRkMCTVFAntNhxaoyuaR7CBvpG20WM7G
7fjSmHkJ1H5NAIJK71rJdjhCwCIrv3GLhENR9aH0o5eTYX3777uSVETftRPdrS/I
6QLHrUKePZJWR+Ze/A14HMzlc/BWyMCAxOTvFiKKOJXj4k4VC692nbf0gJpZ4D4z
SFeNSI5JWSrE417iRE3NGOWBEM8nmzwdpgVJw8zRMkGfNZjIpxZiOXXmDjXsV0Ce
E8l+zfAf81vRL4q5lXbPgFC3NWaBDCuQ/Du3P0iHNvWwohpK3Mn45pDWffAJznZm
OvKP7MAvR+Gh4IM8Mvn1kg53N1isW3XxWRKjAaUE8XOb+94QuNVMcCULV0oqt55Z
5wp3hlo91h21iX1pGXASwsc/oi8S9NOv+h0TJeloNztkGt7zIsqyg245XMpU+BDJ
OOk6XbfMGTwkKQL5uFtityXh8TVIHiJCUw8T0cBtj+PMBlNiDiGWBE2Qysm/JIX+
Z7yVAJXPrRut4Yo0Y9jZ
=vXsT
-----END PGP SIGNATURE-----

--4Epv4kl9IRBfg3rk--
