Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758848Ab3GZMse (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 08:48:34 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:37709 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757545Ab3GZMsb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 08:48:31 -0400
Date: Fri, 26 Jul 2013 14:48:28 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Mike Turquette <mturquette@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>, albert.u.boot@aribaud.net,
        Emilio Lopez <emilio@elopez.com.ar>, linux-kernel@vger.kernel.org,
        shuge@allwinnertech.com, linux-sunxi@googlegroups.com,
        kevin.z.m.zh@gmail.com, sunny@allwinnertech.com,
        Olof Johansson <olof@lixom.net>, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 05/10] ARM: sunxi: Add Allwinner A31 DTSI
Message-ID: <20130726124828.GD3056@lukather>
References: <1374618312-19001-1-git-send-email-maxime.ripard@free-electrons.com>
 <1374618312-19001-6-git-send-email-maxime.ripard@free-electrons.com>
 <20130726123747.7c88d976@skate>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5gxpn/Q6ypwruk0T"
Content-Disposition: inline
In-Reply-To: <20130726123747.7c88d976@skate>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5gxpn/Q6ypwruk0T
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Thomas,

On Fri, Jul 26, 2013 at 12:37:47PM +0200, Thomas Petazzoni wrote:
> Dear Maxime Ripard,
>=20
> On Wed, 24 Jul 2013 00:25:07 +0200, Maxime Ripard wrote:
>=20
> > diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
> > index 641b3c9..1482533 100644
> > --- a/arch/arm/boot/dts/Makefile
> > +++ b/arch/arm/boot/dts/Makefile
> > @@ -210,7 +210,8 @@ dtb-$(CONFIG_ARCH_SUNXI) +=3D \
> >  	sun4i-a10-mini-xplus.dtb \
> >  	sun4i-a10-hackberry.dtb \
> >  	sun5i-a10s-olinuxino-micro.dtb \
> > -	sun5i-a13-olinuxino.dtb
> > +	sun5i-a13-olinuxino.dtb \
> > +	sun6i-a31-colombus.dtb
>=20
> Wrong patch for this chunk. The colombus .dts is added in PATCH 06/10.

Indeed, it was already pointed out by Emilio.

> > +	soc@01c20000 {
> > +		compatible =3D "simple-bus";
> > +		#address-cells =3D <1>;
> > +		#size-cells =3D <1>;
> > +		reg =3D <0x01c20000 0x300000>;
> > +		ranges;
>=20
> Just curious, what are these reg and ranges properties for?

The fdt parsing code seem to be needing a ranges property, since it
prints a warning if it's not set.

For the reg one, honestly, I don't have a strong argument on this. The
platforms I'm used to did it that way, so did I. The documentation of
simple-bus doesn't seem to mention it, so maybe it's not needed at all.

I find it pretty convenient though to have the size and range where the
different IPs are located in.

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--5gxpn/Q6ypwruk0T
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR8nAcAAoJEBx+YmzsjxAgJDkP/1iRCkYIKPph30gK3jzh5n6z
gzCLanQt2/aOsv+zh7ut3aXBlRuknE+kiqlkDmkCxAjJgvvd0rTs9JdJa4F2yMb5
ZSlthLRgV8/EvgIyk7ujeatH5g9SnVvZ+LnSL1KlAHBTiZ+z3B4RuxjT+lJeHOSg
jCzogNZJwgn45dYcFTTEQUy2Xj0xRx/QqNpqFz87Nu3D9YQwbD0VH4huql8RYDNX
s/ty2rVGM/1NB3so5urNrtU5zAi+v+iM3YXyZ2FgAnVc3AahWqsbQ68V2qyneaEH
GQgj1pwM6yzBwHwUebzpXqQCQ8OmVemFlnr8+8+GQvU5OVco//qxJEaQZ4DiXMaM
xranoAYUU3VL7ts9gsMCSDnXqB0FpiDj5CgeJ0fGXtEYOsKRvATJa5BvzvMndTC+
qpOTe29KeZPi5gIW7JayzJrMOi2nhHI+0nOxakPdIUtRrZPURvyKJ4Uxzk0gDjKw
Ly9WbvLdMUts2RRhcZ5tgC+CXPpbbl6Jumtqb1omtGch/julXcWiO40J7NVePJ7K
YB7cvwDOr2FzT0tdRWj99wspvk8iyAg9DbhrezAIg+LDX4ZzrWahkIykUBOlnBXu
LDGZvUPJyTol1Jo9Jl70ObYxtbVMJYFHoN9PulnZ+g/0jQCHVrVc2Av5W3LE4pDl
nR+ijGWmsRqok22vF2s0
=h5FC
-----END PGP SIGNATURE-----

--5gxpn/Q6ypwruk0T--
