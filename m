Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753853AbaBTL5l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 06:57:41 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:47313 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752355AbaBTL5k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 06:57:40 -0500
Date: Thu, 20 Feb 2014 20:57:30 +0900
From: Mark Brown <broonie@kernel.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, lgirdwood@gmail.com,
        Mike Rapoport <mike@compulab.co.il>
Message-ID: <20140220115730.GK2669@sirena.org.uk>
References: <1392886403-10640-1-git-send-email-sachin.kamat@linaro.org>
 <1392886403-10640-17-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="snEQXr8jLQjqMUIL"
Content-Disposition: inline
In-Reply-To: <1392886403-10640-17-git-send-email-sachin.kamat@linaro.org>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 106.188.156.234
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 17/23] regulator: tps6586x: Remove redundant error message
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--snEQXr8jLQjqMUIL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 20, 2014 at 02:23:17PM +0530, Sachin Kamat wrote:
> kzalloc prints its own OOM message upon failure.

Applied, thanks.

--snEQXr8jLQjqMUIL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTBe2nAAoJELSic+t+oim9m1UQAI0eJwL7aAtIKFq92dI9R8lG
1l9JqIY9qjzz8W8ulX0RkFy6GQIJniSvnshFQFU/rvpJGNw/gcD0wzpcxSRxGx0Q
7WvF92cFrOSyxP8WzHa5dP7RHnVrZ8Lg8R/5IEW/NbdhLR2PqRZtDWOQeR6DeGgH
g+r3RWhPCR3Vd9tb6fzAVPoieNBvJhaheDppPiglK+yWNI4kKVCqvYVZThzMvIpL
pFLvG+ruTRq7Fs56GFACRrYNWcmwT5IY27RtwfWAzOMUhJGjelWSGRMKSmuFB5Wp
BnHb7LCyS7BVOaxHt6Z/GWJIQOP2MGyiCZXhs+uodQNl2jqS2XJhopTVB85uxzBI
+Hn+ZPl2tIVXmsjT4dAJ6Syfo757M1vv/IdpSJB01vPaSHE6+M5mnA33QyhJSWN9
s2+JCYi8QF9e9xvH7Xzh6Cay+0U3XsWcynpLrxzbfIT40jpyuUCKrRx9FWOQ2Vjm
FgM4z8VSuBIC0HMlLQbYXjnN+osiPY9heYaO1IpLaFT5B64ml8okuFjSCMJdNt1H
cUVbugDq5565WbWKGLe3NIY4W8TqjFtgKQwcCd6SQPG3EYARClZ/ksgsCHLGgwcx
MB279SscAVeaaT/OHv2WQIVcGVCMFcA4ngPGi9x7Mu4XEoOGaqFROKg/DRW1EiiI
I7RCywWwVvs4dktaAmSj
=y9aB
-----END PGP SIGNATURE-----

--snEQXr8jLQjqMUIL--
