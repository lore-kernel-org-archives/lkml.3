Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933219AbaFRBbE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 21:31:04 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:43129 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755104AbaFRBbC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 21:31:02 -0400
Date: Tue, 17 Jun 2014 20:30:05 -0500
From: Felipe Balbi <balbi@ti.com>
To: Tony Lindgren <tony@atomide.com>
CC: Felipe Balbi <balbi@ti.com>, Benoit Cousson <bcousson@baylibre.com>,
        Paul Walmsley <paul@pwsan.com>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Josh Elliot <jelliott@ti.com>, Darren Etheridge <detheridge@ti.com>,
        <devicetree@vger.kernel.org>, <robh+dt@kernel.org>,
        <pawel.moll@arm.com>
Subject: Re: [PATCH 2/2] arm: dts: add support for AM437x StarterKit
Message-ID: <20140618013004.GA16868@saruman.home>
Reply-To: <balbi@ti.com>
References: <1402676147-3711-1-git-send-email-balbi@ti.com>
 <1402676147-3711-3-git-send-email-balbi@ti.com>
 <20140613162334.GI8319@saruman.home>
 <20140613163118.GJ8319@saruman.home>
 <20140616072720.GX17845@atomide.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="X1bOJ3K7DJ5YkBrT"
Content-Disposition: inline
In-Reply-To: <20140616072720.GX17845@atomide.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--X1bOJ3K7DJ5YkBrT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Jun 16, 2014 at 12:27:21AM -0700, Tony Lindgren wrote:
> * Felipe Balbi <balbi@ti.com> [140613 09:33]:
> > On Fri, Jun 13, 2014 at 11:23:34AM -0500, Felipe Balbi wrote:
> > > On Fri, Jun 13, 2014 at 11:15:47AM -0500, Felipe Balbi wrote:
> > > > --- /dev/null
> > > > +++ b/arch/arm/boot/dts/am437x-sk-evm.dts
> > > > @@ -0,0 +1,539 @@
> > > > +/*
> > > > + * Copyright (C) 2014 Texas Instruments Incorporated - http://www.=
ti.com/
> > > > + *
> > > > + * This program is free software; you can redistribute it and/or m=
odify
> > > > + * it under the terms of the GNU General Public License version 2 =
as
> > > > + * published by the Free Software Foundation.
> > > > + */
> > > > +
> > > > +/* AM437x SK EVM */
> > > > +
> > > > +/dts-v1/;
> > > > +
> > > > +#include "am4372.dtsi"
> > > > +#include <dt-bindings/pinctrl/am43xx.h>
> > > > +#include <dt-bindings/pwm/pwm.h>
> > > > +#include <dt-bindings/gpio/gpio.h>
> > > > +#include <dt-bindings/input/input.h>
> > > > +
> > > > +/ {
> > > > +	model =3D "TI AM437x SK EVM";
> > > > +	compatible =3D "ti,am437x-sk-evm","ti,am4372","ti,am43";
> > > > +
> > > > +	aliases {
> > > > +		display0 =3D &lcd0;
> > > > +	};
> > > > +
> > > > +	vmmcsd_fixed: fixedregulator-sd {
> > > > +		compatible =3D "regulator-fixed";
> > > > +		regulator-name =3D "vmmcsd_fixed";
> > > > +		regulator-min-microvolt =3D <3300000>;
> > > > +		regulator-max-microvolt =3D <3300000>;
> > > > +		enable-active-high;
> > > > +	};
> > > > +
> > > > +	v33_fixed: fixedregulator-v33 {
> > > > +		compatible =3D "regulator-fixed";
> > > > +		regulator-name =3D "v33_fixed";
> > > > +		regulator-min-microvolt =3D <3300000>;
> > > > +		regulator-max-microvolt =3D <3300000>;
> > > > +		enable-active-high;
> > > > +	};
> > > > +
> > > > +	v18_fixed: fixedregulator-v18 {
> > > > +		compatible =3D "regulator-fixed";
> > > > +		regulator-name =3D "v18_fixed";
> > > > +		regulator-min-microvolt =3D <1800000>;
> > > > +		regulator-max-microvolt =3D <1800000>;
> > > > +		enable-active-high;
> > > > +	};
>=20
> Chances are these are not fixed regulators.. Typically the these
> come from external regulators controlled by GPIO pins. Sounds
> like you have the schematics so it would be best to verify it.
> If they come from something not yet supported, let's at least
> document it with comments.

sure, let me just make sure of it.

> Also looks like all the am43xx boards are using vmmcsd_fixed,
> might be worth checking those as well while at it.

I'll need help testing, but sure thing.

--=20
balbi

--X1bOJ3K7DJ5YkBrT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJToOucAAoJEIaOsuA1yqRE28wP/A0XxCLETw2Krn8BZNr6u1du
Vn3Pk37/u0FTs28UQd0pvO8aKF8EEO0DtIdd4iJE4i0TF3gZcyu6lh1iDM3MjOXL
a+3GXdODd1JC9rQm6E1LyWS+Tq/czDvbGYEoWlaTJiZF0ucW52PjfRusHbHG5aq4
+2riU/bxo8Xvdnfp1RKoA3lz62kdkzLq7vztf8j9UbVcyu4LKysKP6B7Uq//Sv/R
pwOZwiAIC9ikli/zkJNwuSvDHxQbISIFNJ+wNsUbEtZLRwDqXWt+RbmsBiIpKulN
oXzHAzgeNUF/zxiue/JyoduJj/Gey0vRUeBwipmCSdaIe3gCYMVvuDM3RgxGTzsP
/S3rDP3gp1oMbsaJdV+oCsPFoipclzsgYUNML2mTDBR/ffu6S1AsE8j/33Kzngvo
bwclCGHgcPLIbGICLwHei+XpPAuZvL5pJmd1ja8sL0JGrkQ1f4xzwkg+vuTD2ym6
BZEhGmB7XEkOPHJQgw+wVxveEi5qK05Df9kAwto1uPJHLV8UxocZGgUvkdFf7Qp4
XJI3wiiUQfWY3EXkw4soIROy1LU9s6IAHe6jwtCiBwfGQMe72JObK1Ljz3ftVLFY
fcCAPWnXwlZQHiORFImurVgtBQyUKGV4KmvuN04u2xsIF0t8UT9nklBH4sumlEqW
GVzWmBpcR1Z15EFbbCSg
=SETu
-----END PGP SIGNATURE-----

--X1bOJ3K7DJ5YkBrT--
