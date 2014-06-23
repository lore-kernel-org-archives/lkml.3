Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753818AbaFWLfO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 07:35:14 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:53135 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753348AbaFWLfM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 07:35:12 -0400
Message-ID: <53A810E9.4070707@ti.com>
Date: Mon, 23 Jun 2014 14:35:05 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Fabian Frederick <fabf@skynet.be>, <linux-kernel@vger.kernel.org>
CC: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
Subject: Re: [PATCH 1/1] drivers/video/fbdev/sis/sis_main.c: remove unnecessary
 test on unsigned value
References: <1402516440-20554-1-git-send-email-fabf@skynet.be>
In-Reply-To: <1402516440-20554-1-git-send-email-fabf@skynet.be>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="S2H6sdCBVgATSNQV21w5sbkGdG05vuglk"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--S2H6sdCBVgATSNQV21w5sbkGdG05vuglk
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 11/06/14 22:54, Fabian Frederick wrote:
> unsigned value is never < 0
>=20
> Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
> Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>
> Signed-off-by: Fabian Frederick <fabf@skynet.be>
> ---
>  drivers/video/fbdev/sis/sis_main.c | 4 ----
>  1 file changed, 4 deletions(-)
>=20
> diff --git a/drivers/video/fbdev/sis/sis_main.c b/drivers/video/fbdev/s=
is/sis_main.c
> index 22ad028..3f12a2d 100644
> --- a/drivers/video/fbdev/sis/sis_main.c
> +++ b/drivers/video/fbdev/sis/sis_main.c
> @@ -1572,10 +1572,6 @@ sisfb_check_var(struct fb_var_screeninfo *var, s=
truct fb_info *info)
>  	/* Adapt RGB settings */
>  	sisfb_bpp_to_var(ivideo, var);
> =20
> -	/* Sanity check for offsets */
> -	if(var->xoffset < 0) var->xoffset =3D 0;
> -	if(var->yoffset < 0) var->yoffset =3D 0;
> -
>  	if(var->xres > var->xres_virtual)
>  		var->xres_virtual =3D var->xres;
> =20
>=20

Thanks, queued for 3.17.

 Tomi



--S2H6sdCBVgATSNQV21w5sbkGdG05vuglk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTqBDpAAoJEPo9qoy8lh71g2QP/jaIZKHPBEPkkAESL/BSQ/0n
8y0OlObmRndjQK8OpWGTGfqMf0EYAyz73I9xIUo8sRvUvucHkLGOD0GG7HbtDfjk
PXKbVLba2I7p/YESkg/upzgi81bB2X8T3iEG9l7DXua09y8S0iAJ9kBjQ/jeWeM2
m/TWtfHjM3tDZ9+kJObYI8ybKIVUHxdC4rbX7bR7KLrTu+iJcJ8jvP3jJLP5MBKV
Ei91/39KZNl/G1brVLLKR4GTFjxDFf4FiBy7T68UO9VQuTcSqBtB5RyEAhtXUsnX
C2ezxOpIZJtXQWygYGQcEuo8T0T5cGkgX0Ih8NtMofHF40Q+dCdWstITQXJPKmsP
I/FeECJ1YjZ7N7X5cqzdiPSR3q06pvbLLzOU16TD44JnFK7TllRtLe3Zumd3vy6e
10pbpNWT8vxgbMPB9oWO/p8Niwp+REg4wqzaIANUtPHipZBzd4gUu7eJlTYgQG8a
ifqK3WKdXlDucVsWa5qy5cGHa0MkJ8/YEhtjXcr/aKScHDQ5MsJnLYrOnA+Scn0K
boq7I9xB35RxVAeqNQsDbVPD7FCxXKLzyl8BUl0gV6HOE1JMYX0gga3ghQi1+1yI
3PSs2GZBmgpKvqBoLgiSfOnQnJ3ogMJs2mYYIYZAti7PXo88WsduG20lfn081VeZ
3kp+OIsKyLjx0dPrC+Tj
=IlsZ
-----END PGP SIGNATURE-----

--S2H6sdCBVgATSNQV21w5sbkGdG05vuglk--
