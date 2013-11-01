Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755844Ab3KALfS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 07:35:18 -0400
Received: from sauhun.de ([89.238.76.85]:39824 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751919Ab3KALfQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 07:35:16 -0400
Date: Fri, 1 Nov 2013 12:35:09 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Cc: linux-i2c@vger.kernel.org, sjg@chromium.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, ben-linux@fluff.org,
        grant.likely@secretlab.ca, broonie@kernel.org, dianders@chromium.org,
        cpgs@samsung.com
Subject: Re: [PATCH v12] i2c: exynos5: add High Speed I2C controller driver
Message-ID: <20131101113509.GA6734@katana>
References: <1354021236-28596-2-git-send-email-ch.naveen@samsung.com>
 <1381901442-29222-1-git-send-email-ch.naveen@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+QahgC5+KEYLbs62"
Content-Disposition: inline
In-Reply-To: <1381901442-29222-1-git-send-email-ch.naveen@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+QahgC5+KEYLbs62
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 16, 2013 at 11:00:42AM +0530, Naveen Krishna Chatradhi wrote:
> Adds support for High Speed I2C driver found in Exynos5 and
> later SoCs from Samsung.
>=20
> Driver only supports Device Tree method.
>=20
> Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
> Signed-off-by: Taekgyun Ko <taeggyun.ko@samsung.com>
> Reviewed-by: Simon Glass <sjg@google.com>
> Tested-by: Andrew Bresticker <abrestic@google.com>
> Signed-off-by: Yuvaraj Kumar C D <yuvaraj.cd@samsung.com>
> Signed-off-by: Andrew Bresticker <abrestic@google.com>

Rebased to v3.12-rc4 and Applied to for-next, thanks!


--+QahgC5+KEYLbs62
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJSc5HtAAoJEBQN5MwUoCm2G+wQAKOUy1Box1K1WRim36Z0LZfA
35OE0VmGBlO/YcviO4IXApuPZ8SKZI6HAE5V5fvpJtwu+LZDZshuh/XVOZTgeH6i
SDowmDAVkBKRo3odCQXEuoNOM0adtUDDunP492YBmnuSRdXBt59rQcSDlDsmRYg9
ftp+dTJBnwGjN/tYsAyVx51+f4KeEFEgX/Tf790cSYySHNVc0EKeObJN+vBVXP1u
Xd/PDfkYArCWaEOEMtvNHdUCAmk6JrtHdYJ0+BUdEN03W8iA6v9UhAn1E2cuccAl
odXS8rKzUFYW3wzoLSKunJDiVk8LuPpRZm90wPfLHIlP1n12BeYkIM1MabtKYTtw
QBDndkVHSbaOXotLaiGqSEb0ARmT86tH1sKC1PODytDrpi+OHrwKt2o6QngWRMXR
fxq1rhYwOtMTxbbYCsZmlb7ylt04YGGeh7HiZH/TneuqwvVOtN+ZZLhdwHsQtbuN
qKNjTV452Ep69PixwMELdgQ8tAp/kfRyAIlImjIVtFYS55NEIqvCalG/OLRmxj2H
hux+QcRTqS4g6EuNe4DWN+tnW/zWj7HsmFIebTnNyAzBICbOWt5r0u0Xd4iXUl93
oV7agsOeFkgIPvWxUVgadT+ui3XNz8jOzPOdJRz2y+/wVgniRahz/lhdlwPb6H6s
NASfvrkJi6nUe0/Wq+rQ
=Vpe6
-----END PGP SIGNATURE-----

--+QahgC5+KEYLbs62--
