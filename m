Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755615AbaAWTwq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 14:52:46 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:58750 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753555AbaAWTwn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 14:52:43 -0500
Date: Thu, 23 Jan 2014 19:52:38 +0000
From: Mark Brown <broonie@kernel.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>
Message-ID: <20140123195238.GM11727@sirena.org.uk>
References: <1390486801-4839-1-git-send-email-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4ybNbZnZ8tziJ7D6"
Content-Disposition: inline
In-Reply-To: <1390486801-4839-1-git-send-email-linus.walleij@linaro.org>
X-Cookie: Please ignore previous fortune.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: ab3100: cast fix
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--4ybNbZnZ8tziJ7D6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 23, 2014 at 03:20:01PM +0100, Linus Walleij wrote:
> The AB3100 regulator driver emits a warning when compiled on 64bit
> systems like this:

Applied, thanks.

--4ybNbZnZ8tziJ7D6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS4XMDAAoJELSic+t+oim9dLcP/3eQlXJGRcl1omcoRosIZ4HO
HTOH6TyhBfNH2K+QvIc9n/co0IDZBhfDSA8gOZzUaEW4Cfj8vL7PYEc9EwGBZAQI
6ZNLSllTOZDMqQ8M3HsIGjlG3NchYgHaYa3q3LXQA7Ev08rn6QpvrtAI6lQz1QZ7
kWiotL1ZnoDGYOvfY+JukbH4p7Rr/q/xzEH12jq/jCpM0r1peGkmQk1wZEf8ckqd
ambJAmhU1jaa0jZKupQZu7+ZpWrpm3gwFKzC3FGlca7sXRGochPZrRdok14MQdch
UGNHASYIHxLSctBoSjC07FqdLovL+1blBlqCqd48wWTi3DmmAWfsZwSikO2f2jsM
gvV4G3EZ0S1pW/OWoh2X2J3uub2ge+2y+4yYLvUULnvHcFcVitVHO9ewaGFrEe1e
KhDCCenL+64rrKCcA5v82eEdgSi0QV39T0eV86s0y3MRNoxnUJ039SuHEKaZDvj/
qovW2IgHLrAd3x6SzEhz1ET5N0HxpLvReBc0hfHyuVUt8FD00hA7/iTDlPABxcrn
mgNZ2hSZvLtzKCxhkzMUOW8dXeTqAlY97bnVS0qBP2OyOpqOUgJ2OKq+FfoSvby3
idDmK+HdVv+zTqii9QFnyp904gf5hlZoCfnN1bi9k8igRvFfC1H6Hrkwf8J72JXT
EsI1xDMU44Ts5eVFDpNf
=QxUv
-----END PGP SIGNATURE-----

--4ybNbZnZ8tziJ7D6--
