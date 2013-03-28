Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754718Ab3C1AQq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 20:16:46 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45085 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753353Ab3C1AQp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 20:16:45 -0400
Date: Thu, 28 Mar 2013 00:16:43 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com,
        Mustapha Ben Zoubeir 
	<mustapha.ben.zoubeir-nonst@stericsson.com>
Subject: Re: [PATCH 28/46] regulator: ab8500: Delete useless fixed_uV field
Message-ID: <20130328001643.GP18316@opensource.wolfsonmicro.com>
References: <1363881583-15234-1-git-send-email-lee.jones@linaro.org>
 <1363881583-15234-29-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="F6Ec0KOT7XisNHGe"
Content-Disposition: inline
In-Reply-To: <1363881583-15234-29-git-send-email-lee.jones@linaro.org>
X-Cookie: Your aim is high and to the right.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--F6Ec0KOT7XisNHGe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 21, 2013 at 03:59:25PM +0000, Lee Jones wrote:
> From: Mustapha Ben Zoubeir <mustapha.ben.zoubeir-nonst@stericsson.com>
>=20
> The fixed_uV property residing in ab8500_ext_regulator_info is
> currently unused. We remove it here.

This is definitely a bugfix to an earlier commit in the series, can we
please have these squashed into the original commits?

--F6Ec0KOT7XisNHGe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRU4vlAAoJELSic+t+oim92c8P/jONEaz7yd6d1BDP1g2A9jhg
pXO7xtvR8RtxfvBpdsp+imoBAVvueQsn3o3siuclzFglTdyh97pqQ7CN/T5vgBzK
tFBjqA0hqgxNjlsZzt39NbomRwjfwe/oG1KP0s9DNplZAX+7ejG76HBJ4xan6DJo
uf+N+M1ME+Fr08I3mLJk6wTLO/QiY0YYpS6RPrezhSFZgSE7fnD82cy6ZXRhVv6/
SyLrF2imdyEj/j44+xz2Y51U9QbSTHKrrcMGJB6+GqdE4UfyLkbJ1El6EJHZPbka
ehpqkE43jYU1io/kcZe0k36hkdBP8GJUwukYwRlgZWrkyjXJJZG/AQDeDYzQGBp+
cs9sQg7rWSmxhntJ0APhzMGMynyK5fPo800gOzHTOmJP3Uro/PBGfsLtBYv5sfD5
ZAcNy1+ISFPGUCAv3mON/y6X55Tkd13l7dfdqUUnz0Kf2P6Hzql6jyRF0wsr83p2
6paHCHQE9wZF+jT5AEyGyP7fQLNEYsoUGDSyy1D7B7e3FWwnnRGBvQiJcBv5xw9g
zn+Ry7qpnhMIiqN5C3Mx/iljohdvMiRMPWkNBC6wiR/WOH0V1rWvyhDzdOqHZvbJ
pnxAZpyibIpRhrBsxflX20yeUG9Rp5YfWDTSSFMck8NuCnj47bXFakHaSdFv1gZS
TO33Is4RUcDR24FFCg26
=DYC4
-----END PGP SIGNATURE-----

--F6Ec0KOT7XisNHGe--
