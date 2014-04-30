Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758076AbaD3I0d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 04:26:33 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:45011 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751622AbaD3I0a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 04:26:30 -0400
Message-ID: <5360B3B1.1080906@ti.com>
Date: Wed, 30 Apr 2014 11:26:25 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Masanari Iida <standby24x7@gmail.com>, <plagnioj@jcrosoft.com>,
        <linux-fbdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] video: fbdev: Fix format string mismatch in wm8505fb.c
References: <1398774115-15353-1-git-send-email-standby24x7@gmail.com>
In-Reply-To: <1398774115-15353-1-git-send-email-standby24x7@gmail.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="d1OCbi8kpG626AL5g43DthdkKL1meMVHN"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--d1OCbi8kpG626AL5g43DthdkKL1meMVHN
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 29/04/14 15:21, Masanari Iida wrote:
> Fix format string mismatch in contrast_show().
>=20
> Signed-off-by: Masanari Iida <standby24x7@gmail.com>
> ---
>  drivers/video/fbdev/wm8505fb.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/video/fbdev/wm8505fb.c b/drivers/video/fbdev/wm850=
5fb.c
> index 537d199..d2fafbb 100644
> --- a/drivers/video/fbdev/wm8505fb.c
> +++ b/drivers/video/fbdev/wm8505fb.c
> @@ -162,7 +162,7 @@ static ssize_t contrast_show(struct device *dev,
>  	struct fb_info *info =3D dev_get_drvdata(dev);
>  	struct wm8505fb_info *fbi =3D to_wm8505fb_info(info);
> =20
> -	return sprintf(buf, "%d\n", fbi->contrast);
> +	return sprintf(buf, "%u\n", fbi->contrast);
>  }
> =20
>  static ssize_t contrast_store(struct device *dev,
>=20

Thanks, queued this and the 2/2 patch for 3.16.

 Tomi



--d1OCbi8kpG626AL5g43DthdkKL1meMVHN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTYLOxAAoJEPo9qoy8lh71Kz0P/0h9DKP4Y/AwEtN1VIKgIl6/
TPK/J8PD9w4/QEIF5FXnLGRUrDUD3fxJCXF/fpybmMf09Pfcgvo7xZtrIBtvlLT3
4fxv5y5yQQtk8ejKEKEt2R5qiqKdx++qj+U0xyCvSdhnslyo9au7Hk0dunxtl0Nh
QpE0eUlGT7x90PpT8b6dkyX8UQ24tzm3oW4JXfQYZw+tNY2DBRaA+zE5oRPBEnlr
nzzU/CNEctrqY5wHTm7G/TUV1OhWI6Ufk8c4RtsfXOvNVwtFj1ByPsr/V+zTidNh
4bk2JkP4MDpfNac5AhM6ZtamyYS43GbwvnHXCbCkt0q5zXg7f7ZjZWLswJ4Ioi0L
6dMZsgQlW/TF9ROe+LMwx5fe4OPpVjF6tQlAmSzfnbtqnB0Jbl71j7/+dq/C9GVz
eqwp9xVfU5hulemmgSVNpGnfliPrSS2grJWFxMSLG2307ur7dhrKEAIwJcNVLaL4
ln1z9i63+yBYH6bPW40jYVo119IKCo7n/OdFrpeLeCNg/HTKdvl+19xhEK2A8LPd
fhysbBdiwu7oaFJKn8ZNSbBIEVIYYBIJAeVQ6+3qAA2tcB6UTB1McYTetDEF9jpX
deILeK7IwXHFokVDRPMg9b4YoCo/0snVEyD8lKnUBxH9aegwFMV8QfgANsiY7zP8
aFmAlL5DerJtPLPzupd5
=+lpk
-----END PGP SIGNATURE-----

--d1OCbi8kpG626AL5g43DthdkKL1meMVHN--
