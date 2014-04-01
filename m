Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751260AbaDAJPH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 05:15:07 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:54006 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751057AbaDAJPF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 05:15:05 -0400
Message-ID: <533A8382.7070603@ti.com>
Date: Tue, 1 Apr 2014 12:14:42 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: <jon@ringle.org>
CC: <plagnioj@jcrosoft.com>, <linux-fbdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Jon Ringle <jringle@gridpoint.com>
Subject: Re: [PATCH] video: da8xx-fb: Add support for Densitron 84-0023-001T
References: <1394042711-7907-1-git-send-email-jon@ringle.org>
In-Reply-To: <1394042711-7907-1-git-send-email-jon@ringle.org>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="5WcMEqgm29hEBKNQEq3u5xcd7xKmwcESq"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--5WcMEqgm29hEBKNQEq3u5xcd7xKmwcESq
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi,

On 05/03/14 20:05, jon@ringle.org wrote:
> From: Jon Ringle <jringle@gridpoint.com>
>=20
> Signed-off-by: Jon Ringle <jringle@gridpoint.com>
> ---
>  drivers/video/da8xx-fb.c | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
>=20
> diff --git a/drivers/video/da8xx-fb.c b/drivers/video/da8xx-fb.c
> index e7f5937..83c43b2 100644
> --- a/drivers/video/da8xx-fb.c
> +++ b/drivers/video/da8xx-fb.c
> @@ -243,6 +243,20 @@ static struct fb_videomode known_lcd_panels[] =3D =
{
>  		.sync           =3D FB_SYNC_HOR_HIGH_ACT | FB_SYNC_VERT_HIGH_ACT,
>  		.flag           =3D 0,
>  	},
> +	[3] =3D {
> +		/* Densitron 84-0023-001T */
> +		.name           =3D "Densitron_LCD",

I think the name should be a bit better. Why it is not something like
"Densitron_84-0023-001T", which is the style the other panels use?

 Tomi



--5WcMEqgm29hEBKNQEq3u5xcd7xKmwcESq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJTOoOCAAoJEPo9qoy8lh71D9sP/3QXO/iKaz2KCNEF3+TW60Z9
2U26Q83LAxbjuDySvd/+q0XxOik+nmNwhzxy2EIOc1fY+/6AvA5O7Tt5whUHeo8m
Vh9UGjyVwNmFlKucoLfBuWXZZhyYU1q1Bw75C+cishkDteSiOjIk/f+hN2RS+WG/
qEffASyz8JpJi6EuFSFbzzssp0NLdqMbxOLScaH5Hth5On7q+yZAYxh43qc5w5tD
EoS3ysq6PShN9xuotOY8l8/2a+rX5FU7gsWEl+799OHF1TEw2hL1ugGkp0/6D8do
3219i2q4P5r5S+oARi/n9bGkcCtjDAEtUuQM3/6TjyB1jxNikkYPzjf57FXkU5qt
GStu9nYNU30Q3XV9sxxRF+VT7QUvgp+sIgWrJwJ4MnV9MHo8PJvx/Vz2V5vVd6U7
zZ6xbJMW725W61JiuWc86hw469y8/PMIQST/bffBH3zvSK6MA+CTh7qebDyfavu6
So23BbUluIPvlF39x1spCihomhl32uBLjAchIiuNVgW3JMZRrgHYKHreUERTBNU9
tyCSKTRXH5tHN5wjJlUcsqd2S0YDS+jUzZcSCaDtrSq11d8XC4k7u3Y+lGj0iMo3
7Q8sDoowOUNs3E/iTSQ2WsgcsVGUC7ptCriaXHkOE4MACR+9fLx2npdvs29EViLx
BfAkzlWAKnkuBwxV0J0d
=0E9e
-----END PGP SIGNATURE-----

--5WcMEqgm29hEBKNQEq3u5xcd7xKmwcESq--
