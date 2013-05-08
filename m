Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755507Ab3EHMnU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 08:43:20 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:40725 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754169Ab3EHMnT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 08:43:19 -0400
Date: Wed, 8 May 2013 13:42:46 +0100
From: Mark Brown <broonie@kernel.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, lgirdwood@gmail.com,
        sundar.iyer@stericsson.com
Message-ID: <20130508124246.GP7478@sirena.org.uk>
References: <1368011110-4049-1-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MXXuyh5iveicsfl4"
Content-Disposition: inline
In-Reply-To: <1368011110-4049-1-git-send-email-sachin.kamat@linaro.org>
X-Cookie: You have no real enemies.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 212.183.132.60
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/1] regulator: dbx500: Make local symbol static
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--MXXuyh5iveicsfl4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, May 08, 2013 at 04:35:10PM +0530, Sachin Kamat wrote:
> power_state_active_get is used only in this file. Make it static.
> While at it also move this function definition inside the
> CONFIG_REGULATOR_DEBUG macro as it is called only from within it.
> This also avoids further build warning related to unused definition.

Applied, thanks.

--MXXuyh5iveicsfl4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRikhCAAoJELSic+t+oim9p+oP/j9td+Xmtg+CCBRLGMA6v9Ki
oGGHa0jNJNxZJQxYFSOXucZYTQnZKtkUH5RXjDtHfU18oV6Mx8pOMjs4zmnNFxZP
mnYMPnPXGEVAyV3zGIsDvf0lmaMO/1J7xtkg0NRSFx8UWBazuoL05QGgRqgQQt3r
6oY3wPrBHdrNqxY83cqce4aNuJ9Y65goY39MZyiKdPMyj5YvG7xO8Kc18q2Qc4J1
N2rxu2qZChMyk63ws8lijmxKKsOtcxmV5jN39yxYUj4wx+UOYB7HaBpfLmaynOjq
kar7FCtnSIS/oaj2lHFdUoVeaJ75QkXqPXdDZ4RpI6wXliA+CYHoojDlLf1TakeP
/i3baAtL3wxpGUj141aOuuTZElT8F7oRnYLZK1j0M9+vtBttd9KSshiKLhbcZxr9
tUC9yfCTUbbwJAFbhvKKB1znnlk8QHgzNcMuXgHN4L1abxWIJu0GjWqRh5LWGtpl
PtnU9qW8g214zP9RVrUG4ee9b/sxOX6YKN2bHJ5vY+VZE3qxJbIwkGeQhPX+SVeE
mICBJYscagOqJWeYh10OiqUXl7aiA5zP/GgqvRN9E7w7EKTOXL/gdgmBv5CmqG1u
kVINjf7sbsNdkcEsKGM3rBF0XzKwvkuaChj7C/1Uj8wIb4YiFFlzBk0kKrepKLkf
Mz5Lhd15a6WFniw+y3oP
=0dPd
-----END PGP SIGNATURE-----

--MXXuyh5iveicsfl4--
