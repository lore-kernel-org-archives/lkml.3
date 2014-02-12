Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752871AbaBLPuX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 10:50:23 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:40866 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751620AbaBLPuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 10:50:20 -0500
Date: Wed, 12 Feb 2014 15:50:06 +0000
From: Mark Brown <broonie@kernel.org>
To: Heiko =?iso-8859-1?Q?St=FCbner?= <heiko@sntech.de>
Cc: grant.likely@linaro.org, robh+dt@kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Liam Girdwood <lgirdwood@gmail.com>
Message-ID: <20140212155006.GY28112@sirena.org.uk>
References: <2573561.oCYNnnL0gm@phil>
 <2193931.Kqcd3TrslU@phil>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nSY6dmU9u4MMxp1o"
Content-Disposition: inline
In-Reply-To: <2193931.Kqcd3TrslU@phil>
X-Cookie: Oh no, not again.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 3/3] regulator: ti-abb-regulator: do not open-code
 counting and access of dt array elements
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nSY6dmU9u4MMxp1o
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 12, 2014 at 01:01:42AM +0100, Heiko St=FCbner wrote:
> From: Heiko Stuebner <heiko.stuebner@bqreaders.com>
>=20
> Open coding the counting of elements in a dt-property is abstracted by th=
e newly
> introduced of_property_count_uXX_elems functions. Additionally the raw it=
eration
> over the states element exposes the endian conversion and dtb-format deta=
ils,
> which according to Mark Rutland "would be nice to limit [...] to of_ help=
er
> functions".

Applied, thanks.

--nSY6dmU9u4MMxp1o
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS+5grAAoJELSic+t+oim9EAkQAJn7aNfA+njghBy9NcAuyyJT
+Z2HlBW3tFUyulrH1OMQ8z5Ee6zOzI5zFUWsMWwOGiM/IAE0McwjjLz6M5ya1nF+
ZhEYlygOY23uvEWp2NKSk5VwUodhGsjxSppIP0QZAU3OBWMnEIYQ3GdrzfJy2KAb
bATwFEmmfrldxsSuFkG0XvyFjpJYWDpS9r0PhUrNHoAPoBr8z8UwVwAMc58tnKSQ
9RsRyJswJwEWSYDNA3/e16cB3KmG5urvoB9d2P2yeXROTMp52Mn1bkx2IIN78m6p
XHVf3ON7+0vqsOcfEWIyB2B1y+yvtNx5FAWAfURepuNNXxtHCYuqRIA7oyV/hLxQ
28SVvKO2GjWeZXZVfCuHs4Gw2WydhC/rRDzDZWuasbicKnpAEPsT72dPZ5X3tzyd
yGlLl3WIoQ5z2nZiMbm8dArCPBoDL+1o5gr7c+WTy2tRQ1ajDyoxpw1UB4eFcyik
WZFbGgYvlyrflMDWo1Dcq4nUdyfaeHy5b+ZFO+vhK8K6qWTILOU/L5gSZ8s3mXbh
rmKM5D6kUAZisDr/9HqP/kIDWBrI6FzDiOZuifpMDtaEDYAurzmkFv42Pw3boF9t
lyfCzxFRIAgivq8TwrehFjQ50CWEJtmqvU1X6+mFHjSh6K/QyJwpJqDWk0rZ/kAe
qGgqq5FLP+wBFKwBQebM
=JAbe
-----END PGP SIGNATURE-----

--nSY6dmU9u4MMxp1o--
