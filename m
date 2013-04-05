Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161723Ab3DEG5S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 02:57:18 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:55008 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755185Ab3DEG5Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 02:57:16 -0400
Message-ID: <515E75BC.20604@ti.com>
Date: Fri, 5 Apr 2013 09:57:00 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: <jg1.han@samsung.com>
CC: <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <linux-fbdev@vger.kernel.org>, <FlorianSchandinat@gmx.de>,
        <s.trumtrar@pengutronix.de>, <plagnioj@jcrosoft.com>
Subject: Re: [PATCH RESEND] fbmon: use VESA_DMT_VSYNC_HIGH to fix typo
References: <8984685.165951364521249756.JavaMail.weblogic@epml18>
In-Reply-To: <8984685.165951364521249756.JavaMail.weblogic@epml18>
X-Enigmail-Version: 1.4.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="------------enig4249E8C466D3C5A781E9B0C9"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--------------enig4249E8C466D3C5A781E9B0C9
Content-Type: text/plain; charset=EUC-KR
Content-Transfer-Encoding: quoted-printable

Hi,

On 2013-03-29 03:40, Jingoo Han wrote:
> VESA_DMT_VSYNC_HIGH should be used instead of VESA_DMT_HSYNC_HIGH,
> because FB_SYNC_VERT_HIGH_ACT is related to vsync, not to hsync.
>=20
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> Cc: Steffen Trumtrar <s.trumtrar@pengutronix.de>
> Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>
> ---
>  drivers/video/fbmon.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>=20
> diff --git a/drivers/video/fbmon.c b/drivers/video/fbmon.c
> index 94ad0f7..7f67099 100644
> --- a/drivers/video/fbmon.c
> +++ b/drivers/video/fbmon.c
> @@ -1400,7 +1400,7 @@ int fb_videomode_from_videomode(const struct vide=
omode *vm,
>  	fbmode->vmode =3D 0;
>  	if (vm->dmt_flags & VESA_DMT_HSYNC_HIGH)
>  		fbmode->sync |=3D FB_SYNC_HOR_HIGH_ACT;
> -	if (vm->dmt_flags & VESA_DMT_HSYNC_HIGH)
> +	if (vm->dmt_flags & VESA_DMT_VSYNC_HIGH)
>  		fbmode->sync |=3D FB_SYNC_VERT_HIGH_ACT;
>  	if (vm->data_flags & DISPLAY_FLAGS_INTERLACED)
>  		fbmode->vmode |=3D FB_VMODE_INTERLACED;

I'll apply this to fbdev fixes.

 Tomi




--------------enig4249E8C466D3C5A781E9B0C9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with undefined - http://www.enigmail.net/

iQIcBAEBAgAGBQJRXnW8AAoJEPo9qoy8lh71uokP/3o1AXKvr93wv2ogtCyFWcFO
CkyzRMB1dpcmts6GasRcCSSxf8+4tiFEfZfu0uSKBVZf90IE1C7fbD+TdXd+sU8B
td9x7RmSi2zWWTupoHLWZP4tL6UMsJCWcbFVQ0i2cZMYzcVcsPlg2COoZekfia9E
9Mtqc71KP9MJmoPDy9HpSfFImI26cZjlIJr94+Xp2RS/h8/shnkEk9R2LnIPKZkK
n/ioEgicBRdmoUaQAQRew9boHB2oBjn97RlwQmUqBtvNxCgwBQ3y/Ydxjc1yUkip
xGb/GWUl1iVIc37/0Qi5Zq++5fZK6BC+79tdIfwdx6G8oXJGwi4a4a5cwsUWltj3
UOkIjhz0jEPi5J/yovOUtqSEAln6jiqSXHQqY8CbyaJuz8nW87b/GGolTYNBBzmM
GetvEoKv47pY7o3tcZssciWXMeHmljDsaQp95Wpri7gTsEykGpxKnirP8JHXPGC5
F6G6aWl3juC3Xeo5qe46kVnNcwIUD1CRhCl0Q1Q/QNqA+x4OLffnqHJQlHtzHEGn
irMKFgRqqkTUpeL4LmlRT/hUzorwuhWzOt+fzGHhhJePCnZeujs6WteNIvLklnZT
qABz+xF78CDxnwsDZg9IZNfmXT3fwAye6snX/xSJ6T0fieGOzo4yoYXU7PKiD1+S
8bQu0aTNcyTpp+TFNC84
=V2so
-----END PGP SIGNATURE-----

--------------enig4249E8C466D3C5A781E9B0C9--
