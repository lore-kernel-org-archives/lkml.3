Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753139Ab3HAJcO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 05:32:14 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51304 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751732Ab3HAJcN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 05:32:13 -0400
Message-ID: <1375349525.3556.14.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [26/84] ARM: OMAP: RX-51: change probe order of touchscreen and
 panel SPI devices
From: Ben Hutchings <ben@decadent.org.uk>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>, Sebastian Reichel <sre@debian.org>
Cc: Aaro Koskinen <aaro.koskinen@iki.fi>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, akpm@linux-foundation.org,
        Felipe Balbi <balbi@ti.com>,
        Pali =?ISO-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        Tony Lindgren <tony@atomide.com>,
        Joni Lapilainen <joni.lapilainen@gmail.com>
Date: Thu, 01 Aug 2013 11:32:05 +0200
In-Reply-To: <51F9F6DF.5070306@ti.com>
References: <lsq.1375276989.521602504@decadent.org.uk>
	 <51F9F6DF.5070306@ti.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-w2cnhGfG+YTi7gTAvd3M"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 151.216.67.181
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-w2cnhGfG+YTi7gTAvd3M
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2013-08-01 at 08:49 +0300, Tomi Valkeinen wrote:
> Hi,
>=20
> On 31/07/13 16:23, Ben Hutchings wrote:
> > 3.2.50-rc1 review patch.  If anyone has any objections, please let me k=
now.
> >=20
> > ------------------
> >=20
> > From: Aaro Koskinen <aaro.koskinen@iki.fi>
> >=20
> > commit e65f131a14726e5f1b880a528271a52428e5b3a5 upstream.
> >=20
> > Commit 9fdca9df (spi: omap2-mcspi: convert to module_platform_driver)
> > broke the SPI display/panel driver probe on RX-51/N900. The exact cause=
 is
> > not fully understood, but it seems to be related to the probe order. SP=
I
> > communication to the panel driver (spi1.2) fails unless the touchscreen
> > (spi1.0) has been probed/initialized before. When the omap2-mcspi drive=
r
> > was converted to a platform driver, it resulted in that the devices are
> > probed immediately after the board registers them in the order they are
> > listed in the board file.
>=20
> I'm not really familiar with this issue, but:
>=20
> The commit 9fdca9df was merged to v3.5. Has that also been backported to
> 3.2? If not, I don't think this patch is needed for 3.2, as the patch
> causing the problem is not in 3.2.

It has not, but Sebastian reported that 3.2 was broken in the same way
so perhaps the blame was wrongly assigned in this commit message.
Sebastian, can you confirm that it is fixed with 3.2.50-rc1?

Ben.

--=20
Ben Hutchings
Who are all these weirdos? - David Bowie, about L-Space IRC channel #afp

--=-w2cnhGfG+YTi7gTAvd3M
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUforFee/yOyVhhEJAQqzGxAAk2uw7RupkR7YUUM3nP9keCSDX3kmo4p0
X8QscqynHMleCq9DkGZVzFeOThpMmvCbPIwIvuO5TbN1Wzw5p6ZRb5866v8bEVKo
8DOSHocV/dNJubpkBPL7tbX18322I8dRmdblv/bRqmUEq8u/1jDxbAz6SYaq4kxT
ZqX62GPYpv9ScKR26xm7zvwYwWu1agX9wHHrmVqSrlj+6zmXdwVp2CDeEw3AVuCu
HvTqkFkThuwWAlYVTRf/mKipwAzCLzNV9zRGNGZwrNl5C//4reak2RsMphzCXs/G
wkP5xaRCO9CSidUvt+jwzbse0eEcswNVW8l1g2mY91Cl+ZujUnylyCiEhWQUSbbj
wm/PfRh+G0v7JL9hoI1Gx1QcwDc34ZhbFf+kGwFCkDP49HxayQWDwg7acsa5q+mI
UrIcrgt+THthlQD+bQ2OOaQN0TVwlN+T1fLKd79y+/M/BEPswIRbgeqmlH3SA8ZG
8lGzsVEdw1GrhcwmcRuLLyDH0YGZZ8ZTWEjvT97XGZfgsyyh3mYboXwmOC+XG4zL
4KnaoG3W5Uk8iCa0EiBdMDG5a7g+iMEfZrGbPKEgbXvgN+N0pw//vcfOt84v2edm
kmaMYht0RLVCpJ26IDvnBe957xbcSw+Lcmn4Hhy0/axtJPMd3rVTxpaJW6i0fmdZ
P6ohCgEMA8M=
=H5Aw
-----END PGP SIGNATURE-----

--=-w2cnhGfG+YTi7gTAvd3M--
