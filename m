Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752613AbaH1T3X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 15:29:23 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:59476 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750942AbaH1T3V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 15:29:21 -0400
Date: Thu, 28 Aug 2014 14:28:39 -0500
From: Felipe Balbi <balbi@ti.com>
To: Vivek Gautam <gautam.vivek@samsung.com>
CC: <linux-usb@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-samsung-soc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-omap@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <balbi@ti.com>, <kishon@ti.com>,
        <kgene.kim@samsung.com>
Subject: Re: [PATCH 4/5] usb: dwc3: Adding Kconfig dependency for Exynos7
Message-ID: <20140828192824.GR16689@saruman.home>
Reply-To: <balbi@ti.com>
References: <1409212920-28526-1-git-send-email-gautam.vivek@samsung.com>
 <1409212920-28526-5-git-send-email-gautam.vivek@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AonAANj1daC6QcQu"
Content-Disposition: inline
In-Reply-To: <1409212920-28526-5-git-send-email-gautam.vivek@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--AonAANj1daC6QcQu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 28, 2014 at 01:31:59PM +0530, Vivek Gautam wrote:
> The Exynos-DWC3 USB 3.0 DRD controller is also present on
> Exynos7 platform, so adding the dependency on ARCH_EXYNOS7
> for this driver.
>=20
> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
> ---
>  drivers/usb/dwc3/Kconfig |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/usb/dwc3/Kconfig b/drivers/usb/dwc3/Kconfig
> index 785510a..e235894 100644
> --- a/drivers/usb/dwc3/Kconfig
> +++ b/drivers/usb/dwc3/Kconfig
> @@ -55,7 +55,7 @@ config USB_DWC3_OMAP
> =20
>  config USB_DWC3_EXYNOS
>  	tristate "Samsung Exynos Platform"
> -	depends on ARCH_EXYNOS || COMPILE_TEST
> +	depends on (ARCH_EXYNOS || ARCH_EXYNOS7) || COMPILE_TEST

wait when building for ARCH_EXYNOS7 you don't get ARCH_EXYNOS ?

--=20
balbi

--AonAANj1daC6QcQu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJT/4LYAAoJEIaOsuA1yqRE8D8P/0x6TC8uZM5+NMPlJeCa1R+t
yRV5KHQibRTl9idBNyoIFZjim70TLGTqGrSAlFr5zT5esgHjuqW5pcKzFWncW4vm
ABDbsTc+feZPYUUqQLvp6oxJiAkmhWUzjXqPsAXEC0NqhqJbvXhFjgiQHyRyeOd1
af0x8JR0gZoCupzu6kb6RiX2G5Gk/b8144YdBt2kKO2VvF70UJGTBx8y5eLtawg2
6esK6yOegPsoUILf9zODwFb1Dhp6L0rFmvPpT6SdPTzaMEhQdC8Z5MVjwwdGj7vf
oJthXNzF66B2P6MFRp1/kEcTbXjYjE3pDo4gqrOJ4dkPDbC02O8hAMnftSZfCmgE
wazv1fCvntDh/UponwC5aB8GRRcKiLRaD7YXtRpT1qEu/8nwhi9WggUt3v7NsBfl
qX75K95iKQlducc2PGnq8pCD1JqOjqliHGsit3kQsYOcILrUVHHzvGGVOTlnpgx4
66tZLXdLyFBevYpSiihAkYr7Vj3o6igTKhemVatl7u5FAoIKjvpPJxLvGVLJ8090
FBV/cfO6I5IhiPrmA1C+EVvpIpdFPCK/VbkpAfuXZ8dXgIEW/BtcHHf88HzxJ1Sq
7aSrnD7fBNZnp7gLHqjl31Z13JsDNB51IZUcba3iP0N1qvoRp/81+8U9+JfZHBu8
MZy6TVrQuNYo7Kh+FOmD
=QabP
-----END PGP SIGNATURE-----

--AonAANj1daC6QcQu--
