Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751771AbaDAOOI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 10:14:08 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:58165 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751531AbaDAOOG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 10:14:06 -0400
Date: Tue, 1 Apr 2014 09:11:35 -0500
From: Felipe Balbi <balbi@ti.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
CC: <linux@arm.linux.org.uk>, <tony@atomide.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <tomi.valkeinen@ti.com>, <eduardo.valentin@ti.com>, <arnd@arndb.de>,
        <balbi@ti.com>
Subject: Re: [PATCH] ARM: OMAP2+: Fix config name for USB3 PHY
Message-ID: <20140401141135.GA4717@saruman.home>
Reply-To: <balbi@ti.com>
References: <1396347274-32750-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AqsLC8rIMeq19msA"
Content-Disposition: inline
In-Reply-To: <1396347274-32750-1-git-send-email-kishon@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--AqsLC8rIMeq19msA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 01, 2014 at 03:44:34PM +0530, Kishon Vijay Abraham I wrote:
> commit a70143 (drivers: phy: usb3/pipe3: Adapt pipe3 driver to Generic PHY
> Framework) moved phy-omap-usb3 driver in drivers/usb/phy to drivers/phy a=
nd
> also renamed the file to phy-ti-pipe3. It also renamed the config from
> OMAP_USB3 to TI_PIPE3 in Kconfig. However the config name was not changed=
 in
> omap2plus_defconfig. Fixed it here.
>=20
> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>

Acked-by: Felipe Balbi <balbi@ti.com>

> ---
>  arch/arm/configs/omap2plus_defconfig |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/arch/arm/configs/omap2plus_defconfig b/arch/arm/configs/omap=
2plus_defconfig
> index a966795..a4e8d01 100644
> --- a/arch/arm/configs/omap2plus_defconfig
> +++ b/arch/arm/configs/omap2plus_defconfig
> @@ -226,7 +226,7 @@ CONFIG_USB_DWC3=3Dm
>  CONFIG_USB_TEST=3Dy
>  CONFIG_NOP_USB_XCEIV=3Dy
>  CONFIG_OMAP_USB2=3Dy
> -CONFIG_OMAP_USB3=3Dy
> +CONFIG_TI_PIPE3=3Dy
>  CONFIG_AM335X_PHY_USB=3Dy
>  CONFIG_USB_GADGET=3Dy
>  CONFIG_USB_GADGET_DEBUG=3Dy
> --=20
> 1.7.9.5
>=20

--=20
balbi

--AqsLC8rIMeq19msA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTOskXAAoJEIaOsuA1yqREKwgP/ikXoe5qAZO9M5WhJPxwN7vQ
lJ1NwAgwH1hHbEzk7GxGAfdM4qFsQG/1cPMl/g0sw/csP7VhCIDrpkawkXMsp5Q9
jq8vGgURSpwy7o6mP2ZRv3HhoyPObfLWmCO/9gvGSsMCNGP0tBmTTPTS2vdkY4Ys
yNL/9u/7A6pbtvE535GVfmG6zONe3+RCr4Y/syYvc3Ltpju+/yU9fIm0wCkhf126
NpvpsEiZ3VccYyiGDBobnyEhrJJ/VjQEcqX3vl9oqEP2fFrsP9U0C4rqXsgFrfJx
wCQyNiC9ujkcfts+fyTFPlYV0zjHnIMS6n7EXspzEbvRTh5PdLdoX3+EihsM72iY
dVAQ6VOflpoSUKu9knnjwPCYCJMHgCl8D26PGVRxsSYyazdnGzWJfIVHuzMsraDv
h13Ft1ys7SV4fAs+upWE7nVXvzKewVT8tgAlpKSZRm0Kfdh8ao7uBOGFekpb6yZx
VhfVRXqIw8fcuuh8gO2r/ev1VbpDgUYRDs8OD8qBclsvRseEgv1JRzxKYnIWq1C4
owV54oAkcXZky8kkdGC0+rhmhm+QVbhEFTBcGBupVSSsXzwZ7CpROTN0c2g20Fkh
AErwVJO2/P0mrwsHxDUTjZVlG2Y9PoPfrnDOl3XlI8IH+glbH3Cuk8dA2YxRe0Um
tbTABohEdHadzJH0HM5A
=5EQU
-----END PGP SIGNATURE-----

--AqsLC8rIMeq19msA--
