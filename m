Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753034AbbAOL06 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 06:26:58 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:56308 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751525AbbAOL05 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 06:26:57 -0500
Message-ID: <54B7A3F7.8010107@ti.com>
Date: Thu, 15 Jan 2015 13:26:47 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        LFBDEV <linux-fbdev@vger.kernel.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fbdev: ssd1307fb: drop unused function ssd1307fb_write_data()
References: <1421090474-4243-1-git-send-email-prabhakar.csengg@gmail.com>
In-Reply-To: <1421090474-4243-1-git-send-email-prabhakar.csengg@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="iAsx0Ap6tldKTsjOk47HWk4MaaDidxePF"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--iAsx0Ap6tldKTsjOk47HWk4MaaDidxePF
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 12/01/15 21:21, Lad, Prabhakar wrote:
> this patch drops the unused function ssd1307fb_write_data().
>=20
> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> ---
>  drivers/video/fbdev/ssd1307fb.c | 17 -----------------
>  1 file changed, 17 deletions(-)
>=20
> diff --git a/drivers/video/fbdev/ssd1307fb.c b/drivers/video/fbdev/ssd1=
307fb.c
> index a7ecaa6..c891f11 100644
> --- a/drivers/video/fbdev/ssd1307fb.c
> +++ b/drivers/video/fbdev/ssd1307fb.c
> @@ -122,23 +122,6 @@ static inline int ssd1307fb_write_cmd(struct i2c_c=
lient *client, u8 cmd)
>  	return ret;
>  }
> =20
> -static inline int ssd1307fb_write_data(struct i2c_client *client, u8 d=
ata)
> -{
> -	struct ssd1307fb_array *array;
> -	int ret;
> -
> -	array =3D ssd1307fb_alloc_array(1, SSD1307FB_DATA);
> -	if (!array)
> -		return -ENOMEM;
> -
> -	array->data[0] =3D data;
> -
> -	ret =3D ssd1307fb_write_array(client, array, 1);
> -	kfree(array);
> -
> -	return ret;
> -}
> -
>  static void ssd1307fb_update_display(struct ssd1307fb_par *par)
>  {
>  	struct ssd1307fb_array *array;
>=20

Thanks, queued for 3.20.

 Tomi



--iAsx0Ap6tldKTsjOk47HWk4MaaDidxePF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUt6P3AAoJEPo9qoy8lh71oAgP+wcK9Obgxnlz8C+J5vM36D+t
bVAFoDbOK3gLWOXkM9LB0Er3M1emBLHwPI6u4kiYsLGpiBodemP4/gajRIQ3GK5V
POQQCGlSm9h/t6gq0DlP3k8sSPokAv8RRjXE8oHqbkpWjXfjgzZB4xq+7YpHWhD8
BdzcW0hQvM0XOlz9zkLdoUDuM0dNox8VYxFyN8XzDEtpWUFH8I69plSNsnSG79Zy
O8/0NpFK3g/5rQjVbv6usKNy9OGi+W7BlABxG89YnRno032sTeDykrt8HF+OZ4p7
vN00fO7rZfClibkfEcTHN4dj9mlNWwPUpo9JEiiwN/fmwmwuaEXKXCybFHWt5osv
NbvVgCdM35uZ1UVX7cqpZnktgSjSFd4frkRc+6zMNQg5FyH4s66DTHYuw0a9VXDq
IvrydwigLJznorxAXI2/2+3Akd6Qgz+RGxzwp9gyWUYllPkmdDbhVtvkMhqqJB2t
SyhE9xM0nZzP31ov8MCuSGGewIBsQHl5mjZjWJowNUqUDx1bukNFjBkHLfeMTKvW
omk0Gwe//4oAHVNzBNy1dbyVH8z4J9SHeGuk+QuCRLWAnBkzJhyuMclUtl2Q7TiW
q1hPTDYQwTHqmj1ixEYUYEs2mGMtsEIxJZf0C0qi6RfXPoq2T5egllEVpd+rjLzo
hPOoBza5Lg0rJiGvxlty
=qp6D
-----END PGP SIGNATURE-----

--iAsx0Ap6tldKTsjOk47HWk4MaaDidxePF--
