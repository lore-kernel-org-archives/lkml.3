Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755865Ab3A1NHa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 08:07:30 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:56990 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751773Ab3A1NH1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 08:07:27 -0500
Date: Mon, 28 Jan 2013 15:07:03 +0200
From: Felipe Balbi <balbi@ti.com>
To: Vivek Gautam <gautamvivek1987@gmail.com>
CC: <balbi@ti.com>, Vivek Gautam <gautam.vivek@samsung.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-samsung-soc@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <sarah.a.sharp@linux.intel.com>,
        <kgene.kim@samsung.com>, <dianders@chromium.org>,
        <sylvester.nawrocki@gmail.com>, <tomasz.figa@gmail.com>
Subject: Re: [PATCH 4/4] usb: phy: samsung: Enable runtime power management
 on samsung-usb3
Message-ID: <20130128130703.GO28698@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1359373348-18320-1-git-send-email-gautam.vivek@samsung.com>
 <1359373348-18320-5-git-send-email-gautam.vivek@samsung.com>
 <20130128120909.GG28698@arwen.pp.htv.fi>
 <CAFp+6iHjzSKyya-t6dtsVQdOuhBTsCgWu+NFnDXFeRWwnBt-Jw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XVTPT6MZt3zd/C+/"
Content-Disposition: inline
In-Reply-To: <CAFp+6iHjzSKyya-t6dtsVQdOuhBTsCgWu+NFnDXFeRWwnBt-Jw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--XVTPT6MZt3zd/C+/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Jan 28, 2013 at 06:34:15PM +0530, Vivek Gautam wrote:
> >> @@ -65,7 +67,22 @@ static u32 samsung_usb3_phy_set_refclk(struct samsu=
ng_usbphy *sphy)
> >>       return reg;
> >>  }
> >>
> >> -static int samsung_exynos5_usb3_phy_enable(struct samsung_usbphy *sph=
y)
> >> +/*
> >> + * Sets the phy clk as ref_pad_clk (XusbXTI) which is clock from exte=
rnal PLL.
> >> + */
> >> +static u32 samsung_usb3_phy_set_refclk_ext(void)
> >> +{
> >> +     u32 reg;
> >> +
> >> +     reg =3D PHYCLKRST_REFCLKSEL_PAD_REFCLK |
> >> +             PHYCLKRST_FSEL_PAD_100MHZ |
> >> +             PHYCLKRST_MPLL_MULTIPLIER_100MHZ_REF;
> >> +
> >> +     return reg;
> >> +}
> >
> > I wonder if you really need this small function (likewise for
> > set_refclk_int()). They don't do much, so you could just inline them on
> > the only caller.
> >
>=20
> Created this just to keep symmetry, ;-)
> will move this in the caller only.

you can have a patch before this series moving the refclk_int() to the
caller, then you will have symmetry ;-)

--=20
balbi

--XVTPT6MZt3zd/C+/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRBnf3AAoJEIaOsuA1yqRErg8P/A8LL74pdW99KzZlcXcWj7jG
y+T6DDAYmR/5rN3mQZ968mNz1OHUH+T5sYxlKndNl38t9Y04RnSyBUl72GgvXC+I
eIvJdsNVY4F8g8BEl+6xFvYqWXltVUCQN5YH+28cSaCKp2bTXofdBv2cdKWMbORg
a3UnyVvNNm5uGq0Nzhq3/PFRp0AIYSF94anJ4kGpYiU1Q1aCtvsgGwLLI65xY18l
2WupvL5ngJAatO8kd6oH7bHrUy4RybHL1T+IJrYZRgYlXx5zwXqm6WlIIheR55If
xl5tZVbJqL0hWd8RztY2CwW/nFVuZRWkGMd5TFaQsG6wMZ86HL5dMpAAsZS7heLA
bqDd3HF0qIuNPyiHRDge14OQgsrXwdVZC4ET3+1oI2O5cdg/l1NM1APbS/in7JKo
F7fBMzRtVeQuBWIByIgoWD+Jd1ZsHc2C0xcJX0AxLLjd4NyokbcueB90PxwiR+jx
f7BDUo9/xvD56smI/8L9tn5uXX0qqPU+rYSYMw9GxAGsIeHoKYWmT8B4QblGRLwr
JFwdW8NUCO4QXuzqsfaYYGtYor1mq43myjJPLiCRpCK7X+88Hrtr00zGSxQVUhFG
p0Jv4RWRQF54IKrjSVX0qiQiD2YEajAUf/6YNZqspY1y23xH8wOEjopbwq8Oz47G
VVei9MpJZsMXsxeJMSsY
=4DDU
-----END PGP SIGNATURE-----

--XVTPT6MZt3zd/C+/--
