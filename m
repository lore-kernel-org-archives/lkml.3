Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933429AbaDIOpI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 10:45:08 -0400
Received: from top.free-electrons.com ([176.31.233.9]:33110 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932786AbaDIOpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 10:45:06 -0400
Date: Wed, 9 Apr 2014 16:43:48 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Boris BREZILLON <boris.brezillon@free-electrons.com>
Cc: Randy Dunlap <rdunlap@infradead.org>,
        Emilio =?iso-8859-1?Q?L=F3pez?= <emilio@elopez.com.ar>,
        Mike Turquette <mturquette@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/15] ARM: sunxi: dt: list all pinctrl compatible strings
Message-ID: <20140409144348.GC28585@lukather>
References: <1397051478-4113-1-git-send-email-boris.brezillon@free-electrons.com>
 <1397051478-4113-2-git-send-email-boris.brezillon@free-electrons.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UFHRwCdBEJvubb2X"
Content-Disposition: inline
In-Reply-To: <1397051478-4113-2-git-send-email-boris.brezillon@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UFHRwCdBEJvubb2X
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Apr 09, 2014 at 03:51:04PM +0200, Boris BREZILLON wrote:
> List all sunxi pinctrl compatible strings in order to be able to grep for
> those values.
>=20
> Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
> ---
>  .../devicetree/bindings/pinctrl/allwinner,sunxi-pinctrl.txt      | 9 +++=
++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
>=20
> diff --git a/Documentation/devicetree/bindings/pinctrl/allwinner,sunxi-pi=
nctrl.txt b/Documentation/devicetree/bindings/pinctrl/allwinner,sunxi-pinct=
rl.txt
> index dff0e5f..0e7e9a1 100644
> --- a/Documentation/devicetree/bindings/pinctrl/allwinner,sunxi-pinctrl.t=
xt
> +++ b/Documentation/devicetree/bindings/pinctrl/allwinner,sunxi-pinctrl.t=
xt
> @@ -6,8 +6,13 @@ the first two functions being GPIO in and out. The confi=
guration on
>  the pins includes drive strength and pull-up.
> =20
>  Required properties:
> -- compatible: "allwinner,<soc>-pinctrl". Supported SoCs for now are:
> -  sun5i-a13.
> +- compatible: Should be one of the followings (depending on you SoC):
> +  "allwinner,sun4i-a10-pinctrl"
> +  "allwinner,sun5i-a10s-pinctrl"
> +  "allwinner,sun5i-a13-pinctrl"
> +  "allwinner,sun6i-a31-pinctrl"
> +  "allwinner,sun6i-a31-pinctrl"

Copy and paste error ? :)

Thanks!
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--UFHRwCdBEJvubb2X
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJTRVykAAoJEBx+YmzsjxAgZXgP/iRxKepemAUKfhK6G2LFK86n
n8xMGGfAODoA58j276F+7elmdfV5PdYFUZ494zhXM7/RixqSzp8R2MeGKr/MPlxR
oTSkIHuAO2/hUaTmCP0o1eJFn22N5B7aNZp2SbIFeUeD2LSHQjGTct+SBvMYWYMo
7RplEMuP3SnD2crcgG2Km6Q2Kncq3fIYpkjJ/T56SkaEAQNNgdx150zzx2gkE9wZ
79WdhnZdVnKvmO/dXScweDLh2R3hlvuHCDbSFBUWFbcD1vscXSss8Xgd8iVK05BU
Q/Ft3lrbAa8uhb7ne+ntQO9F+14WvKiYRZowd9OnION60e8lid2SfnqwstijLFWF
P2mFnQSI4YDH9oauDTQtAFb9/zJLubEns9XEJP/YrT6aWqE6rgtYIJAAji/1b0bB
IoKWK7ScZ3aDZEJTYP8PfUfJyXxRdbddG0TznSGMB0WZ7v6Z/2Cm5DHHl1OstRZe
76fcl3ritMfec6GKCoAvjKfwf+B0EWIJhZ3QWg9QxfbN+Z7w4Sn2ptEwslBx4iWL
QBDlcxnRupcWAkBDNPclmZBsn11fmFcvMx3nAMpzuIzEeOyZvjJasHvLkWn92NEw
HcXWfof/GYvYwbIDw39Z/vDDluGbEELstH1ZMKbiiPbUbS4Q1jtiiTSgkOoEDp85
pkYB/HCHAmnEPGRlhGwh
=5NKS
-----END PGP SIGNATURE-----

--UFHRwCdBEJvubb2X--
