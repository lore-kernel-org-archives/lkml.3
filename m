Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752520Ab3GHMKG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 08:10:06 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:34860 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751874Ab3GHMKE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 08:10:04 -0400
Date: Mon, 8 Jul 2013 13:09:42 +0100
From: Mark Brown <broonie@kernel.org>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        spi-devel-general@lists.sourceforge.net,
        Ryan Mallon <rmallon@gmail.com>, mika.westerberg@iki.fi,
        grant.likely@linaro.org, hsweeten@visionengravers.com
Message-ID: <20130708120942.GY27646@sirena.org.uk>
References: <201307021010.00977.hartleys@visionengravers.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="J8GFDhnWlpbYgExo"
Content-Disposition: inline
In-Reply-To: <201307021010.00977.hartleys@visionengravers.com>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 193.120.41.118
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 08/11] spi: spi-ep93xx: don't bother calculating the
 divisors in ep93xx_spi_setup()
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--J8GFDhnWlpbYgExo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 02, 2013 at 10:10:00AM -0700, H Hartley Sweeten wrote:
> The divisors needed to generate the SPI clock are calculated per
> transfer based on the t->speed_hz. There is no reason to calculate
> them in ep93xx_spi_setup().

Applied, thanks.

--J8GFDhnWlpbYgExo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR2qwDAAoJELSic+t+oim9fjkP/iyb/dE08+wHNPySYZrsCKoL
BOIMpgYr3mwJf1+Ps0LU/q1F6T/6VsOKgUZvIjK8Bucd5+jEKbyT1sLZKXGGf+Hg
8ZChJ/aCJ6Bx3POY0w5xRIFjMfs+ddew2reEev7wHTQzaQMSRMMjhCf5SQimx9Bn
i+VXorXm2jIXFRh2lqjBDixdX/cs0Tgz+3y9B7/UB/AK/p5gWf9UO+YKBijyJfOi
m3mGU1FZMCaDuKj+VZA8hmX3GeTP96+ZPfD4Yy2aqDq9Z9d9gsGnTz/D+XZYhruI
fikDxuzigtQ2DMG2SmPDFJKyQQuUMGHyFMX/4Yqyg2QdTq5IDREYOHE+612Q2Bky
SFWOaec3lhs9tKvGQ//LbE+/gZ+RKz50B35fjdYnheP4TK4Gi47bGBUIrwLcFYSg
sJhIiXOFAGnf0iXHwZOo0RjNUvdnT2mP9jlRxTZRJivzDtZiO4s4rbiS6x93exQ3
GeetryqMQo/7Qn5WbIvg/mPzh+f6PR2KMsZPeMNbxLIzIb43O8jBbv5KSE0ydEXc
3EDG2B+waDZ8LtLq2yEgzNIfbPa9dXW+ysdUzcqqHKDkE0HPP1YvOSvScWkvv0WF
Xdpk0+yRvzuCAXH2pDHG77llKYzwN3b2/u2pduG5FjfxMP7oWf2KN6ZnuMNCYEFK
kvLpCKdqZ2p/K6QgxsYi
=+UIB
-----END PGP SIGNATURE-----

--J8GFDhnWlpbYgExo--
