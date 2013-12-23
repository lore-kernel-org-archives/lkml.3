Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757590Ab3LWQtw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 11:49:52 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:52554 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757456Ab3LWQtt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 11:49:49 -0500
Date: Mon, 23 Dec 2013 10:48:58 -0600
From: Felipe Balbi <balbi@ti.com>
To: Vivek Gautam <gautamvivek1987@gmail.com>
CC: Vivek Gautam <gautam.vivek@samsung.com>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>, Felipe Balbi <balbi@ti.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Kukjin Kim <kgene.kim@samsung.com>, kishon <kishon@ti.com>,
        Jingoo Han <jg1.han@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>, Julius Werner <jwerner@chromium.org>,
        Kamil Debski <k.debski@samsung.com>
Subject: Re: [PATCH v2 1/4] phy: Add new Exynos5 USB 3.0 PHY driver
Message-ID: <20131223164828.GF28679@saruman.home>
Reply-To: <balbi@ti.com>
References: <1386151747-3209-1-git-send-email-gautam.vivek@samsung.com>
 <1386151747-3209-2-git-send-email-gautam.vivek@samsung.com>
 <CAFp+6iF+15barZ=H_0h2VfNWSyxEr=MJy7Mtfn90PqWwXFFMSA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3xoW37o/FfUZJwQG"
Content-Disposition: inline
In-Reply-To: <CAFp+6iF+15barZ=H_0h2VfNWSyxEr=MJy7Mtfn90PqWwXFFMSA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--3xoW37o/FfUZJwQG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Dec 23, 2013 at 02:41:15PM +0530, Vivek Gautam wrote:
> On Wed, Dec 4, 2013 at 3:39 PM, Vivek Gautam <gautam.vivek@samsung.com> w=
rote:
> > Add a new driver for the USB 3.0 PHY on Exynos5 series of SoCs.
> > The new driver uses the generic PHY framework and will interact
> > with DWC3 controller present on Exynos5 series of SoCs.
> > Thereby, removing old phy-samsung-usb3 driver and related code
> > used untill now which was based on usb/phy framework.
> >
> > Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
> > ---
>=20
> a humble ping !! :-)
> Any comments on this patch ?

This is Kishon's domain. I think he's on vacations by now...

> > diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
> > index a344f3d..67e9045 100644
> > --- a/drivers/phy/Kconfig
> > +++ b/drivers/phy/Kconfig
> > @@ -51,4 +51,12 @@ config PHY_EXYNOS_DP_VIDEO
> >         help
> >           Support for Display Port PHY found on Samsung EXYNOS SoCs.
> >
> > +config PHY_EXYNOS5_USB3
> > +       tristate "Exynos5 SoC series USB 3.0 PHY driver"
> > +       depends on ARCH_EXYNOS5

I would add || COMPILE_TEST here and make sure this builds on other
arches too.

The rest of the driver looks all right to my eyes.

Reviewed-by: Felipe Balbi <balbi@ti.com>

--=20
balbi

--3xoW37o/FfUZJwQG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJSuGl6AAoJEIaOsuA1yqREy+gP/0XbDqsxXTFCyx67Dv2CRiS7
mCiLqvRy5sN1ctLE+UH3rfG5ZdjVJ7mTEbcKBDysAjr0GjtliBI1HIyZaYWX2meh
t8YNDNjB8ZduqXr/xS4DbMSRjVgwUg4Vbtpi/uMtEYitTa+KEd0qvlgZ2CIHJKoe
OuSXz3xogdxoR+FqSB6Ys/SVYoWals+46kTpI0k+SKhpG8R2cEIANCZcyRjMC4LR
aVUZzlKywwo07CqM+DdM9woBa3EIiG+n3YeatZoL7CIvZkD8qFBkPlkVM0gE3s2e
jCfNkp+PtDZqfdbeqtschTZArldKBR+jif22FkL0NQcwKF8ZrhwLayvE8bR1dOfT
S26zOq1sugpdSvrWuWMw14Vf/VXuaCvjlvjw4MFnb9Ns7IWLSeoXEs6ymIcvhAU2
ipcWrQnXluynN1/ypoMS0ADLfP7akUyV226w/bEEXUsjosKyjTWfjSJIFFQDGa8T
/HUKSmO9rfp/DO826m8xxb7jgtKfdQKz1yQHeER4rQMyztvQ+JjMAl5uv0KqYXeg
LYY4NNvkQXmVW4ryL9Byo+MxGPlNdoSQDrw7Jr8K/Sia54fsXouF1AyXQiIIjxPK
Ic/I9C55vRc4oHcK7LPu+nRirr9QDy5DlTFoc8iPvViJbzlX1g+5zkFZHkeAyJYW
y9PPyRqFzbdHkApCEZD1
=CED7
-----END PGP SIGNATURE-----

--3xoW37o/FfUZJwQG--
