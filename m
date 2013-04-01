Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756534Ab3DAMVV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 08:21:21 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51838 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752145Ab3DAMVU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 08:21:20 -0400
Date: Mon, 1 Apr 2013 13:21:17 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org,
        Bengt Jonsson <bengt.g.jonsson@stericsson.com>
Subject: Re: [PATCH 13/33] regulator: ab8500-ext: Add support for
 AB8505/AB9540
Message-ID: <20130401122117.GC18636@opensource.wolfsonmicro.com>
References: <1364487093-19551-1-git-send-email-lee.jones@linaro.org>
 <1364487093-19551-14-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KN5l+BnMqAQyZLvT"
Content-Disposition: inline
In-Reply-To: <1364487093-19551-14-git-send-email-lee.jones@linaro.org>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--KN5l+BnMqAQyZLvT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 28, 2013 at 04:11:13PM +0000, Lee Jones wrote:
> From: Bengt Jonsson <bengt.g.jonsson@stericsson.com>
>=20
> The external regulator driver checks for old AB8500 HW
> to apply a fix. This patch adds a check to see that
> it is a AB8500 (not AB8505/AB9540).

Please squash bug fixes into the original patches.

--KN5l+BnMqAQyZLvT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRWXu2AAoJELSic+t+oim9ejIP/jn/VPFwp2V6EqeglhB+gFaj
Y7m6R5U8EOoMfgNgjmlntnO2x2aQeM0QayP76HbwJHG+wbP8brethrn2Pc3VHghg
lS9D5x41z6GCNeFsU+t63Tpp+Tn3PuBWXazTOLSrO+Qc0czRVJRFL1LbfH4wWmrm
zDBCZ6xgxKOLGTcdfXgmXoNzLV7dmf0BSE84VDSmcJ7OAIQeYf/JGvF6K8FalKTJ
SICG3EFpwpaYeUOGkneFhwbV1H00/7IS7buRS/C2TKG73uMx4+clnCgHpSV/UWIY
NENNzBRzRAp6vnttoReMHUMh55zn8ZvHbswME3G/Nj+MSm+FJubHld2lJQgGw+zc
bi9ChVhRALYIPx/g58xCqdbGwzQGT9nNHJm6n79gbOmb/YOZB0L/KdZPntLGogrP
t3T1EijfPxA1hlo21T9Z3KVgzoxtmcuRPbPFLqC2FQBe9BiWoJ8in06pUfOCxkjt
3+2aIiTRF8qEjNkNGB7xeKJWkkBrjqJ5H/n9WgclVpmr+1BpM07lREFGNISP68lT
nObl9s+RDYxEMATKwVGoz1gIymOR4CWU31iDaVZrfDp/6LwMjGaopwN7oaGjcyaK
QychXpZwBNB4Ir1oPQhQvOl5Lvz9tlwwEFxtTRkyVCRqy3uIC182jggOYIpD+03m
AtcdAn3v+QFXA+9XCmxA
=Pc2s
-----END PGP SIGNATURE-----

--KN5l+BnMqAQyZLvT--
