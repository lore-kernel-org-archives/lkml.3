Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753474AbbAXOkZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2015 09:40:25 -0500
Received: from down.free-electrons.com ([37.187.137.238]:56090 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753348AbbAXOkW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2015 09:40:22 -0500
Date: Sat, 24 Jan 2015 15:39:45 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Priit Laes <plaes@plaes.org>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: dts: sun4i: Add initial dts for Gemei G9 tablet
Message-ID: <20150124143945.GD8470@lukather>
References: <1422045409-1251-1-git-send-email-plaes@plaes.org>
 <20150123212203.GB8470@lukather>
 <1422050375.1799.9.camel@plaes.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="C+ts3FVlLX8+P6JN"
Content-Disposition: inline
In-Reply-To: <1422050375.1799.9.camel@plaes.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--C+ts3FVlLX8+P6JN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Jan 23, 2015 at 11:59:35PM +0200, Priit Laes wrote:
>=20
> On Fri, 2015-01-23 at 22:22 +0100, Maxime Ripard wrote:
> > On Fri, Jan 23, 2015 at 10:36:49PM +0200, Priit Laes wrote:
> > > Gemei G9 is an A10 based tablet, with 1G RAM, 16G NAND, 1024x768=20
> > > IPS LCD display, stereo speakers, 1.3MP front camera and 5 MP
> > > rear camera, 8000mAh battery, GT901 2+1 touchscreen, Bosch BMA250=20
> > > accelerometer and RTL8188CUS USB wifi. It also has MicroSD slot,=20
> > > miniHDMI, 1 x MicroUSB OTG port and 1 x MicroUSB host port and=20
> > > 3.5mm headphone jack.
> > > More details are available at: http://linux-sunxi.org/Gemei_G9
> > >=20
> [..]
> > >=20
> > > +/ {
> > > +    model =3D "Gemei G9 Tablet";
> > > +    compatible =3D "gemei,g9", "allwinner,sun4i-a10";
> > > +};
> > > +
> > > +/*
> > > + * http://linux-sunxi.org/Gemei_G9
> >=20
> > Please don't put URL in the DT. This is very likely to change in the=20
> > future, and won't be valid anymore.
>=20
> OK! The URL in commit message is ok to stay?

Yeah, I'm not that fond of it, but it's not that important either.

> > > +&i2c1 {
> > > +    pinctrl-names =3D "default";
> > > +    pinctrl-0 =3D <&i2c1_pins_a>;
> > > +    status =3D "okay";
> > > +
> > > +    /* Accelerometer */
> > > +    bma250@18 {
> > > +        compatible =3D "bosch,bma250";
> > > +        reg =3D <0x18>;
> >=20
> > Is there a driver for this? It looks weird that it doesn't need more=20
> > properties than that.
>=20
> Yes, it's supported by drivers/iio/accel/bma180.c though I have to=20
> admit that this name is a bit misleading. (bosch-bma.c would=20
> better, I guess).
>=20
> And I was a bit surprised that it worked out of the box too, but the=20
> device was present under /sys and I was able to read x, y, z and=20
> temperature values.

Cool :)

There's no interrupt wired to it then?

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--C+ts3FVlLX8+P6JN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUw66xAAoJEBx+YmzsjxAgIYgP/0hzJ56oAv4Ha9skO9oxWF0u
ZQUPtG1W9D9U5B48cAQlE8wM7GCQZzLywE3VOXl8lO+GYKxlSW+2iGHgb8gKUjJj
65tB0meD+I2tJFlQ+tdV7/dHKgICf+QPZaPM7NfCB/lhv4SYuLHOI1m0KLUgmEVx
n481k6GgEd9pNPHbY0P6oSmFcOHkifqofhzLdqM552Mz79iRU3oVM3l6Vl49wxoa
ZxdM5sHgVptkYru9S2xfAGq1reAPe2KOouW74iMEtkFsTGNFLEgw7ACIrzqLohbE
V26EQ5UXraIBZrUr6LLd2rOBrkG+8EjxPs71f/NAGPChQ5KaSllB+sWDP6IvJpD2
gvySfeJyxRPuxHnHhC/5T+bByskBa5LNjxf7r0fHhTyK/VMOiVIGXMmWVsw0gwhs
lfbU3FCj4gpAyqpg6KMaY835S6yyEjCBi33yzKAgdknemWLNkw96Ms854YR6K534
oj1rDn83e+rY2+SPQalzglj/bG01C/fXCc3tDFKbVu/bUGKsDeLhHUUBe5ipcFlf
D8MTh0AVYVntn7+NH2jHooldUTfaJq6rn04Gc4FmsX0rtHKMLtH2k5F6sigwRhcM
5aPkDBCv/zQPAlCRV0nc3UrjL/kwb05COtlYqVQ3TciqboyFxi9KrYo2E0uw5U7V
8vdXV1HhiaMYHj4JRAlS
=jt2T
-----END PGP SIGNATURE-----

--C+ts3FVlLX8+P6JN--
