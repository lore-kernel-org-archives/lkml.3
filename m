Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753651Ab3GAK2B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 06:28:01 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:43048 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752776Ab3GAK2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 06:28:00 -0400
Date: Mon, 1 Jul 2013 11:27:57 +0100
From: Mark Brown <broonie@kernel.org>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        spi-devel-general@lists.sourceforge.net,
        Ryan Mallon <rmallon@gmail.com>, mika.westerberg@iki.fi,
        grant.likely@linaro.org
Message-ID: <20130701102757.GF27646@sirena.org.uk>
References: <201306281143.35130.hartleys@visionengravers.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Sup2ovFryIwBP1d4"
Content-Disposition: inline
In-Reply-To: <201306281143.35130.hartleys@visionengravers.com>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 3/8] spi: spi-ep93xx: always handle transfer specific
 settings
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Sup2ovFryIwBP1d4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jun 28, 2013 at 11:43:34AM -0700, H Hartley Sweeten wrote:
> __spi_async(), which starts every SPI message transfer, initializes
> the bits_per_word and max speed for every transfer in the message.
> Since the conditional test in ep93xx_spi_process_transfer() will
> always succeed just remove it and always call ep93xx_spi_chip_setup()
> to configure the hardware for each transfer in the message.

Applied, thanks.

--Sup2ovFryIwBP1d4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR0VmpAAoJELSic+t+oim9uW4P/3TXg3PiLXlD6JrY1r2+ISNK
pVcygDG6ID7GMQo2x/MI6h5z+EFla/+DxNOJ+IFzuVEO4GTVpayApQI0Ppf5m9uJ
R6cQBeX5fUFMIzisgUNnFePENcWh1O5heNUaM3xD4NrRPrzJAPtZE7MqBwMOJxcB
EpGkh9jIHcAWpUB9QXhIap9OWrqY1JhLl65aI5Z5tP9uaOZgHAwzHypGuO0nFLOF
Q4+Rf8VsETzpH/NxVHLyYhh0xTZVZ/WFsue656IQ4fSwwKcs8soaQKTEHDz9Gs5x
1Fpl6V5ekvueP6G/g7kIgylBt4kY4DtUhDLWzvN1ND/P+xk+wv1DkhKSyGhun6XY
zGjQtUQGrGkb8jv2yB2SjWkarwP7CPuhUFFa1rOKiaa8Cqw+syinccuh+q70fLtA
1n4yUM42XxpKSeKYXpeABJyAZMqY+0uXuQaQ7sxfQFfBENfaqRSoESh409XVdMXr
CvjGhNo3kUY/hO6bDre20oYFrRaOqADEnrRZXRzGl+h76lp5E4YNMl4s44sKEgiF
lc5Q9Ia6GA/kJZCqP+dud7doXxGjopg1bSGn7/3Pdcx484kAGZKVS+R+JndPdhHd
YbjRdeS239YLP2JwUMjE5S2/ziRH/CcUp9mRQf2AwpzncMKFIw+qkNI4EgPcSzxW
tmWzrSCjhNWpaK/oBU/N
=1SJH
-----END PGP SIGNATURE-----

--Sup2ovFryIwBP1d4--
