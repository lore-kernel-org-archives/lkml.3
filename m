Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757833Ab3GZIqA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 04:46:00 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:44970 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755329Ab3GZIp4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 04:45:56 -0400
Message-ID: <51F23735.5050806@ti.com>
Date: Fri, 26 Jul 2013 11:45:41 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Oskar Andero <oskar.andero@sonymobile.com>
CC: <linux-kernel@vger.kernel.org>, <linux-fbdev@vger.kernel.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Radovan Lekanovic <Radovan.Lekanovic@sonymobile.com>,
        Shingo Nakao <shingo.x.nakao@sonymobile.com>,
        Milo Kim <milo.kim@ti.com>, Richard Purdie <rpurdie@rpsys.net>
Subject: Re: [PATCH] backlight: lp855x: set zero brightness at FBBLANK
References: <1372767354-16499-1-git-send-email-oskar.andero@sonymobile.com>
In-Reply-To: <1372767354-16499-1-git-send-email-oskar.andero@sonymobile.com>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="rWSJk7OuUR725RuIldDGlcmIShsqo4kT9"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--rWSJk7OuUR725RuIldDGlcmIShsqo4kT9
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 02/07/13 15:15, Oskar Andero wrote:
> From: Shingo Nakao <shingo.x.nakao@sonymobile.com>
>=20
> When backlight turns on early from display, a white line can be
> seen on the screen. Therefore make sure backlight is off when we
> are under an fb blank event.
>=20
> Signed-off-by: Shingo Nakao <shingo.x.nakao@sonymobile.com>
> Cc: Milo Kim <milo.kim@ti.com>
> Cc: Richard Purdie <rpurdie@rpsys.net>
> Signed-off-by: Oskar Andero <oskar.andero@sonymobile.com>
> ---
>  drivers/video/backlight/lp855x_bl.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/video/backlight/lp855x_bl.c b/drivers/video/backli=
ght/lp855x_bl.c
> index a0e1e02..c0b41f1 100644
> --- a/drivers/video/backlight/lp855x_bl.c
> +++ b/drivers/video/backlight/lp855x_bl.c
> @@ -246,7 +246,7 @@ static int lp855x_bl_update_status(struct backlight=
_device *bl)
>  {
>  	struct lp855x *lp =3D bl_get_data(bl);
> =20
> -	if (bl->props.state & BL_CORE_SUSPENDED)
> +	if (bl->props.state & (BL_CORE_SUSPENDED | BL_CORE_FBBLANK))
>  		bl->props.brightness =3D 0;
> =20
>  	if (lp->mode =3D=3D PWM_BASED) {
>=20

Thanks, I've applied this into my 3.12/fbdev branch.

 Tomi



--rWSJk7OuUR725RuIldDGlcmIShsqo4kT9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJR8jc1AAoJEPo9qoy8lh71aZkP/0uNDwBtecB2iPYoLXY650v+
FJYJGy2yU+puPtu9A4CRpcjt5YSmG8SK1LKwBcliZ3mQkwb1YuPuz5q552gjsHKG
RHhwdmhun0Lg8IbS49fqN/y93PmZRbdgzEi3vWer8h4qvW5JfBMBUZCw8FiXB+rD
9eQYcD1kpzfkP/HPMOHAE/49PU9ptJdUQ3UYld86mQmCxl5Nj3HbiPAPTsPO3tO6
Ryy4myoXg5tfTHU8Hqfl87zkXtnZ6ryO0vXifcvBO3iuLTPQH3ZMcob963xiIOtF
Klkt+G5HOD9sKKM1phPCm0qCt424cQnT146rnF1/uhCGcZX5CvvLpB1hw6vr6jqp
py0iKJ/86C+FXlvAAXQS7jdd2awT/coASoZGJX/KdK9kmZd5ykoSQz3rDVQjYVND
sOiZqvBDgLoRj7cVpdoITlSCDDF5SoH2bW0bLXS18ISRBA1swQSqHWHSiXzqqg8j
m/SI547+zJxNlXpNXRC1ROHxY5qTyXjTqnHllHTGRY6uesw2Nw02T9VusSdaoMvp
i7BpBXczSu7M0AGlg2TTsOZG3V1Ley1c7cVfKMBDDWIJ3NnyqbFv6u7mC0sp/pwJ
RGWskZhKR+SeqNOFiHicioOeXwXcjiZ1cjztUM3X88KfvDQZb2s6ng66l/nxlxGn
jlYFdEgMTogYD/HptwF7
=or9S
-----END PGP SIGNATURE-----

--rWSJk7OuUR725RuIldDGlcmIShsqo4kT9--
