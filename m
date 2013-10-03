Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753801Ab3JCLAF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 07:00:05 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:52413 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751710Ab3JCLAB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 07:00:01 -0400
Date: Thu, 3 Oct 2013 11:59:43 +0100
From: Mark Brown <broonie@kernel.org>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Jean Delvare <khali@linux-fr.org>, Guenter Roeck <linux@roeck-us.net>,
        Jonathan Cameron <jic23@kernel.org>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-spi@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>
Message-ID: <20131003105943.GJ27287@sirena.org.uk>
References: <1380292469-17347-1-git-send-email-lars@metafoo.de>
 <20130927183456.GM19304@sirena.org.uk>
 <5245D2A0.4090909@metafoo.de>
 <20130927192233.GN19304@sirena.org.uk>
 <5245E420.2030207@metafoo.de>
 <20130929123019.GT19304@sirena.org.uk>
 <524D4967.4030300@metafoo.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/8E7gjuj425jZz9t"
Content-Disposition: inline
In-Reply-To: <524D4967.4030300@metafoo.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/3] spi: Add a spi_w8r16be() helper
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/8E7gjuj425jZz9t
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Oct 03, 2013 at 12:39:35PM +0200, Lars-Peter Clausen wrote:
> On 09/29/2013 02:30 PM, Mark Brown wrote:

> > I think that's probably the way to go, the API seems to error prone as
> > it is.

> It looks as if for the ads7871 the wire order is actually little endian.

Why do hardware engineers get all the best drugs?

> endian word. Maybe we can merge this series as it is, then add a LE version
> for the ads7871 and STMPE driver and afterward remove the wire-order
> spi_w8r16().

Yeah, that's probably about as good as it gets.

--/8E7gjuj425jZz9t
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSTU4cAAoJELSic+t+oim9mN0P/iBFTv8hp1fyqVL45aFnfntO
KH3MuqlJURq8FMjcgeQL4YEQxm28zt5ay7je6fApyZF2NqS5bU+C76isJM75kElq
u2vXKbALTQna0OhGwlzxp7wdkDzbHrN25i1xYlmE6JaglwQ8rNMCjAhVQXwwH06i
Tk16a+pOAXJCrX8K9WbYadz4pWTYcU04Ea1YZPheFPMaLweO7NzLdI7cY30jmZdH
AfFMLhF7aHd2Lpa/z1l6hFuqlHnL1xH0BDAsxruhginbpGDebRjHiVdumBcOjBT8
F62mLrDDlFlWm1wGaC9Thm7kkbD+42q2/ntTsk5H1iCe931LizqnS/iSnE7iGJMx
kaCw0nBosmQ7zDF+2YIIzKlhgU+crR5nuA27b9z4dn6ropxPSd8YMvSUPJ3fEzFQ
7dSBiBuwIXJugRv/LY01Vdg/648f8NEmBF1Pqzrv5a0pEwAOttNEVl2mJGlzWJsO
9sL0tbnunM3D3iCOv72f9PGQb1cCN/Kz8ZlZ3fGsXeCRtoXCg/VenbkMpkEd8Z0t
DeeiFQefPZ1XWnr6CqXCkmFlvByxfLdaHu1mDGFtNTR39ma2+3JWll/QDsE4SUWO
5Cc8N6LfGl1jRFw3oMojMxnYIapDnBSblUuP9Iyly3mDk69f37MJycqV/XzxgEyp
5CvxULPf5VObA/ve/tZo
=sOEF
-----END PGP SIGNATURE-----

--/8E7gjuj425jZz9t--
