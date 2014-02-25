Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752830AbaBYX4q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 18:56:46 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:51901 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751785AbaBYX4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 18:56:45 -0500
Date: Wed, 26 Feb 2014 08:50:04 +0900
From: Mark Brown <broonie@kernel.org>
To: Markus Pargmann <mpa@pengutronix.de>
Cc: Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel@pengutronix.de
Message-ID: <20140225235004.GF2927@sirena.org.uk>
References: <1393322627-26543-1-git-send-email-mpa@pengutronix.de>
 <1393322627-26543-2-git-send-email-mpa@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bGR76rFJjkSxVeRa"
Content-Disposition: inline
In-Reply-To: <1393322627-26543-2-git-send-email-mpa@pengutronix.de>
X-Cookie: You will be married within a year.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 121.174.50.227
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/2] regulator: dummy: Should be always-on
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--bGR76rFJjkSxVeRa
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 25, 2014 at 11:03:46AM +0100, Markus Pargmann wrote:

> Regulator dummy does not have any enable operations. So it is always_on.

Applied, thanks.

--bGR76rFJjkSxVeRa
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTDSwpAAoJELSic+t+oim9UuMP/2UqHo9ReJDJ/wxrQP/4VDia
8FDywJRsPAHjg/sg0m2KLCrdPPfXSOk4BRFEltrPJWJNmbFHVd1hsOA1pkVFeEWx
N51yI+LR8ADCOuMElfacnlsMp8G+i+U6kSJsefIWVo7zM2phRsOaKuLAHYRZN/ZY
y9fVTX3auPi7ruJI97KJvtutCAiyjq8KffxtBj4ue0m6defDcqOjrBejw1rDYX+w
7vXU1yztEv8xf18lQdI36AxssNAi0kiRudv4esoZBTHvqDUZcefDXkFJzYcumy2P
Gh/InYDz5JVqKFGFHzAwP5aJZIfkDfty28fsv8j1NvrxZti9R3GerWnth2jxGPnW
Jl69QA4DzpIxkz4eEow8vX6S5c9xabaMFPr9RIAckT0V+LdRWcCfKWUkVb+F/NGC
5+pyiNQ4k3OONWnomN+dDekJvI5iyWDy8o1i1m/PYMp5jSRitMdK5BHhvsxiYyuO
x/hTphlnZGV0MQKC1NFlkJGd3ColTG4PhFfx54pNq4S4Gc7WRwFetsY+uSkhKLEG
6KR+toQXlOPdiswlMJIWdYu3MgrnpQURcYE5Fns0bxydWKEG8kqoheAROFewbDUM
XcCCh8p8jflQPbIO9iP2jrN88VXD/BeAFclYEdnQ9IbP+GCXmxQGFWiBojSAxEaT
LNu+B/thbmzFG7QZ9rYd
=0orZ
-----END PGP SIGNATURE-----

--bGR76rFJjkSxVeRa--
