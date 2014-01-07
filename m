Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751158AbaAGLpJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 06:45:09 -0500
Received: from top.free-electrons.com ([176.31.233.9]:58485 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750747AbaAGLpC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 06:45:02 -0500
Date: Tue, 7 Jan 2014 12:40:55 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de, Roger Quadros <rogerq@ti.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Alexandre Courbot <gnurou@gmail.com>
Subject: Re: [PATCH v2 2/2] reset: Add GPIO support to reset controller
 framework
Message-ID: <20140107114055.GA10151@lukather>
References: <1389030903-27684-1-git-send-email-p.zabel@pengutronix.de>
 <1389030903-27684-2-git-send-email-p.zabel@pengutronix.de>
 <20140106181422.GS3144@lukather>
 <1389088341.4815.9.camel@pizza.hi.pengutronix.de>
 <20140107111954.GA2849@lukather>
 <1389094089.4815.22.camel@pizza.hi.pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OXfL5xGRrasGEqWY"
Content-Disposition: inline
In-Reply-To: <1389094089.4815.22.camel@pizza.hi.pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--OXfL5xGRrasGEqWY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 07, 2014 at 12:28:09PM +0100, Philipp Zabel wrote:
> Am Dienstag, den 07.01.2014, 12:19 +0100 schrieb Maxime Ripard:
> > > I was under the (wrong) impression that gpiod_direction_output takes a
> > > logical value as gpiod_set_value does. Will fix that.
> >=20
> > I don't think gpiod_set_value does either unfortunately.
>=20
> It does, and Alexandre (added to Cc:) suggested that
> gpiod_direction_output probably should, too.  I'll send a patch.

Ah, yes, I was looking at 3.12, and this has been changed in 3.13.

Nevermind then.

Thanks!
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--OXfL5xGRrasGEqWY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJSy+fHAAoJEBx+YmzsjxAgELgP/AsYzEchUDwx/ATOu9B6oXMm
pce2L0oi9OfMJ5p+arLVNFqQOfri3SUia59hm1nnh5JNUvhLRNgmaGsecLmg9BMp
mBGIccVZa78zaDU5sOMGTEfJfgsANZG+BHCmY39+gASYsI2ury27InEGARjq+6AO
ZNc76hv2KXQbmYr1aNercyn0/bfV8ohRqitMKZVO6Y0NeTLHk2Fit1yJbVlBGsqs
z0zS5yT73YPXYl1cQVaXGahK+FOrZgkbiDvKscAQOtDsD+6/jYf1c4dprS8U6tDk
nqIHCqcme8GI9pX3jTmiUBJsikeA5c3DO0VA54JcmaNMMhh2lQa52Hn8FymKuxiV
DHEgYscywDv9maiDwmmGUi+e+lxqFQAPmA7Dp3okFUZPaVuoRd+d4XB7q/1f5Y0Y
bVy0S0CujPEaJtvKwDW6i+CrJYmW9I6G/xQbvKo7rpFLh2y+XNwLrAGW60KQQdmP
aR18u/VU5dnnoT5W1MaxzsimAgy6ej6XdDvkA92BXobQ7siEOumVN9Ffxv0/L+TF
9gN2DZu7jtiHCOVcMA9szwqJ4uXkp5PgT87l07gcliFZZd9uKO1DroS7FOrr5Ixh
8VP/SujAzE7MU01fwvUX7CdB6kGWWbI92j+iDtt9suy/+F5zDPtL94SbGG5nw0VL
LuEjrZ6fxTzWOm7/c29x
=ol9G
-----END PGP SIGNATURE-----

--OXfL5xGRrasGEqWY--
