Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752640AbbAML07 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 06:26:59 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:32769 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751865AbbAML04 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 06:26:56 -0500
Message-ID: <54B500FA.60705@ti.com>
Date: Tue, 13 Jan 2015 13:26:50 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
CC: <linux-omap@vger.kernel.org>, <linux-fbdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fbdev: omap2: Fix typo in tvc_probe_pdata
References: <1420463387-26391-1-git-send-email-linux@rasmusvillemoes.dk>
In-Reply-To: <1420463387-26391-1-git-send-email-linux@rasmusvillemoes.dk>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="cQxp8Hj3cjm8oKQAmukRGDnGqGBnLL4No"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--cQxp8Hj3cjm8oKQAmukRGDnGqGBnLL4No
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 05/01/15 15:09, Rasmus Villemoes wrote:
> Assigning ddata->invert_polarity to itself is not very useful; the
> context suggests that the right-hand side should have been
> pdata->invert_polarity.
>=20
> Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
> ---
>  drivers/video/fbdev/omap2/displays-new/connector-analog-tv.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/video/fbdev/omap2/displays-new/connector-analog-tv=
=2Ec b/drivers/video/fbdev/omap2/displays-new/connector-analog-tv.c
> index 9a2b5ce58545..8511c648a15c 100644
> --- a/drivers/video/fbdev/omap2/displays-new/connector-analog-tv.c
> +++ b/drivers/video/fbdev/omap2/displays-new/connector-analog-tv.c
> @@ -208,7 +208,7 @@ static int tvc_probe_pdata(struct platform_device *=
pdev)
>  	ddata->in =3D in;
> =20
>  	ddata->connector_type =3D pdata->connector_type;
> -	ddata->invert_polarity =3D ddata->invert_polarity;
> +	ddata->invert_polarity =3D pdata->invert_polarity;
> =20
>  	dssdev =3D &ddata->dssdev;
>  	dssdev->name =3D pdata->name;

Good catch, thanks! Queueing for 3.20 (as no one is using that flag in
3.19).

 Tomi



--cQxp8Hj3cjm8oKQAmukRGDnGqGBnLL4No
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUtQD6AAoJEPo9qoy8lh71qeYP/joXqnk3VuGV1O6bl91308z5
RQ4tu++yvbBZHcELlZmZ0grx1zztnje3+/mFi2FqgCEmCZzIqAVtbbQHrwxsZjSe
ZwnK6rho44fijtbecZ8Y6iBjU1rrmrBGJmYcCrO3LMLgeyb+/Nhn6CJql9o6n/HT
/sg+s1f1i+nzTQmD5xCPCM39rJAg9x+J3m8R0HXYVJ733dX5N4DIzXSKW3IBpnZH
scdn7hKeY1B1b9YKDhzB5HHTSdcn4fUtlGiLW6Y7E7XKywtvOOcXzrxALm4PsgTM
o/rmQSU5HD1Sbp69QQChAnAx7iP3cs+ZhqmGPvTSb6PFGlbJTrArY+3LtoD0Y41L
zgsFz+anpC/ZjP9nWKHhQ673yljkAOLkrU5JJJY0+VfG0ifXuPApbHdEn692lf4Z
sks/46quvMSYmVwogi/VTaK9zZS2yF4RrqgmPywax6mn/BI+lGVrm86ugV0pB34r
RAMPsriOftJrQNGALENdSS/Jz5zs0PvaH1i415B+lHmiNbsAfErYeXf1fO9OOxHo
Aiu7cwbBUlI5nUVW2KAdDsNXReJebyO0T92LQGuEJ2kOS4D/z5uzsCpU5jO3loQU
XZyp7PKd5WK+i051yDHjU0qpm00LD8mJaWBR5rUoeblMck0BkhcabBYFhCWGZyjn
AhYMOlOftDHOW+Kd08vH
=49jG
-----END PGP SIGNATURE-----

--cQxp8Hj3cjm8oKQAmukRGDnGqGBnLL4No--
