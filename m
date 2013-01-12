Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755675Ab3ALAEv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 19:04:51 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60346 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754688Ab3ALAEu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 19:04:50 -0500
Date: Sat, 12 Jan 2013 00:04:47 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Olof Johansson <olof@lixom.net>, voice.shen@atmel.com,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, linux-sound@vger.kernel.org
Subject: Re: [PATCH 0/2 v2] at91/ssc: fixes on ASoC tree for 3.8
Message-ID: <20130112000447.GD7873@opensource.wolfsonmicro.com>
References: <cover.1357912706.git.nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oj4kGyHlBMXGt3Le"
Content-Disposition: inline
In-Reply-To: <cover.1357912706.git.nicolas.ferre@atmel.com>
X-Cookie: You are magnetic in your bearing.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--oj4kGyHlBMXGt3Le
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 11, 2013 at 03:08:29PM +0100, Nicolas Ferre wrote:
> Hi Mark, Olof, Arnd,
>=20
> This series goes on top of Linus' v3.8-rc3 and fixes an error that
> we have while compiling DTBs for AT91:
> ERROR (phandle_references): Reference to non-existent node or label
> "pinctrl_ssc0_tx"

Applied both.

--oj4kGyHlBMXGt3Le
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQ8KiYAAoJELSic+t+oim9F5wP/ji9hCzTqpjUdKy0K08VSPkQ
3OC3C3O5RGovPzIdIyauHB56LdT1UeOxIi7B9KbG1BZxLsNpSWMhWjnVofOpWmsA
dYqlRZHgXquOILIyJ88cZkj2wD3OMfuWBVdJAg86yzaWx2c4NoRNlQrYpiPW6DFT
S31jJu+P8ilzKa+Xq2xr0PEvhptsRlwGjBhoGRqtGXLhAezya8mE2GEzCEwxJR+D
OKTip20pyFFRHrhcxUXXOBvQz42HvZqgI0RsnymBMfWr7GdssnSUiJsnHsKUa8P6
3cX3L7t43lOtOyFRjo09rVXXo2c68iu5M08J/fFkEwHeN+j0lW0fKy9iV9Jn97pa
EFFkCprL5Gqmum9ekuYyEYnB94puNx0Co2aNKH2FxNVcH7cXfw7nyf1YvPxblHRM
RVIHoIXWgFXcnvuLQqeIhuddY/cWSK/mNf7Y2d1wdMF8FIn5l1kPgHgnN8Abv9GK
xMMDcaIScKLbXNp8OETDrKPOgRGMzTrI+sh+mLY1iUrv1V1h0GcyBY5Hkr29xj4t
gqZr+xNN19xgtG3p6PE795t66/0ebeoC9KBF83z0RaXIIizRC4HPk/P2gtn4WPei
1H1NmrH1CKLvbATy2tObhh+F3iheFLWKImZBUG7JFya/FpQK2AlaYn04gbUS81Bb
ZiAaLpLKxSYbs3jsUp8E
=KBEf
-----END PGP SIGNATURE-----

--oj4kGyHlBMXGt3Le--
