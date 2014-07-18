Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422763AbaGRNqi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 09:46:38 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:51901 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422744AbaGRNqg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 09:46:36 -0400
Date: Fri, 18 Jul 2014 08:45:57 -0500
From: Felipe Balbi <balbi@ti.com>
To: Lothar =?iso-8859-1?Q?Wa=DFmann?= <LW@KARO-electronics.de>
CC: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>,
        George Cherian <george.cherian@ti.com>,
        <linux-arm-kernel@lists.infradead.org>, Roger Quadros <rogerq@ti.com>
Subject: Re: [PATCH 3/9] usb: musb_am335x: source cleanup
Message-ID: <20140718134557.GC24914@saruman.home>
Reply-To: <balbi@ti.com>
References: <1405675890-8802-1-git-send-email-LW@KARO-electronics.de>
 <1405675890-8802-2-git-send-email-LW@KARO-electronics.de>
 <1405675890-8802-3-git-send-email-LW@KARO-electronics.de>
 <1405675890-8802-4-git-send-email-LW@KARO-electronics.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vOmOzSkFvhd7u8Ms"
Content-Disposition: inline
In-Reply-To: <1405675890-8802-4-git-send-email-LW@KARO-electronics.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--vOmOzSkFvhd7u8Ms
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 18, 2014 at 11:31:24AM +0200, Lothar Wa=DFmann wrote:
> - remove comma after end of list delimiter
>   The empty entry must always be the last item in the list, thus there
>   is no point in having a trailing comma to facilitate adding
>   succeding entries.
>   Remove the comma, so that inadvertedly adding an entry after the end
>   of list sentinel will produce a compile time error rather than an
>   unreachable entry in the list.
> - consistently use tabs for indentation
>=20
> Signed-off-by: Lothar Wa=DFmann <LW@KARO-electronics.de>
> ---
>  drivers/usb/musb/musb_am335x.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/usb/musb/musb_am335x.c b/drivers/usb/musb/musb_am335=
x.c
> index 1e58ed2..164c868 100644
> --- a/drivers/usb/musb/musb_am335x.c
> +++ b/drivers/usb/musb/musb_am335x.c
> @@ -21,14 +21,14 @@ err:
> =20
>  static const struct of_device_id am335x_child_of_match[] =3D {
>  	{ .compatible =3D "ti,am33xx-usb" },
> -	{  },
> +	{  }

makes not difference, but fine.

>  };
>  MODULE_DEVICE_TABLE(of, am335x_child_of_match);
> =20
>  static struct platform_driver am335x_child_driver =3D {
>  	.probe		=3D am335x_child_probe,
> -	.driver         =3D {
> -		.name   =3D "am335x-usb-childs",
> +	.driver		=3D {
> +		.name	=3D "am335x-usb-childs",

thanks, still not a bug fix.

>  		.of_match_table	=3D am335x_child_of_match,
>  	},
>  };
> --=20
> 1.7.10.4
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

--=20
balbi

--vOmOzSkFvhd7u8Ms
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTySUVAAoJEIaOsuA1yqRENikP/jDY/mTSUQ/rtd6vKtbryaUd
11yxVqR08gARW9FEZkh37KmLG6D6MqREo1fb4rnVVGT0xsxifjYZpiLPWdZ1OHjd
z4syoN2kfRx/oelNj+qbODBS/XUEagTh8nImtL9wUZm42aLZyISAsPuAzAcZ/kEM
Eod20e3RO1b4/+QkP5HreaIoT9m9/whVkKVDqOe1UWzRU0hHxCjumEfw9m2dib5k
UQE6lXLoihbbXMczeUuWXDX/Y7EdtY1/Xd36M0/OXwK9gt1dbHrPJIS9sqVdlTOq
u1thD0YP0w6DE90t/wHwOKK/FJ76NvowHPxc+PcwvAlKG0L5a/emUmS6J9K060FA
oXXU1I413OjaK2UjwjOL3ExKbTmMFLgGvQ5IMYZl6dH4rPYQdTfHHS4CM7SPuRNM
pA0RQp5vOmkhB1YLH8B5hSmU9PfCZhhPmPo/HkWh/kmUVwxYBFWV7g6DvEIaOIxM
FZVls14svvlcdbl3ppu8Usu+jJ0S7lbnSBBZYWBoa7H9bpM8iO9N+SusnXooG2+G
aZiAxmU2O9Sy898vWg6S9TKhdaIg+5nV2K7UJKKUZRkWENPY5sRqSLqFFbZSKkUJ
/bm4znCQK1p4J3Hom/L4L7VseSCTxPiGzulLIN+TzMycPNDJt0pjw414EaJF7O9G
5DxzyXAJHrJ+FNKig6DY
=rzYc
-----END PGP SIGNATURE-----

--vOmOzSkFvhd7u8Ms--
