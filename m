Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754844Ab3EHLCJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 07:02:09 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:51672 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753519Ab3EHLCH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 07:02:07 -0400
Date: Wed, 8 May 2013 12:01:49 +0100
From: Mark Brown <broonie@kernel.org>
To: Fabio Baltieri <fabio.baltieri@linaro.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Lee Jones <lee.jones@linaro.org>,
        Ola Lilja <ola.o.lilja@stericsson.com>
Message-ID: <20130508110149.GF7478@sirena.org.uk>
References: <1367997261-32048-1-git-send-email-fabio.baltieri@linaro.org>
 <1367997261-32048-5-git-send-email-fabio.baltieri@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="uTCAFClMX+U9tLbX"
Content-Disposition: inline
In-Reply-To: <1367997261-32048-5-git-send-email-fabio.baltieri@linaro.org>
X-Cookie: You have no real enemies.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 212.183.132.60
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 4/6] ASoC: ux500: Update tx tdm slots configuration
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--uTCAFClMX+U9tLbX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, May 08, 2013 at 09:14:19AM +0200, Fabio Baltieri wrote:
> Update ab8500-codec and mop500_ab8500 tx slot configuration to reflect
> the actual one used by STE.  Also update a wrong comment in the process.

This seems wrong, the individual chip drivers should just be doing
whatever they're being told by the machine driver.  Sounds like there's
two fixes needed here - one is to change the TDM API so that the chip
drivers are just implementing configuration supplied by the machine
driver and the other is to change the configuration being done to
whatever is desired.

--uTCAFClMX+U9tLbX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRijCaAAoJELSic+t+oim9GdIP/R386MXcblkwRNYfmfuR/pCO
5ddNnbLhgcuZ5KJ3/1b2WI18F7RhkhkmH3U4F9kJ/bIFRQIEXlRarZtRktardVlI
G9lQXLWTCPkg9g3s0ClFfivijkuFP29irkvK+PwmxTElam8Fx63t7KWRkXCdXsa2
GR+nPN/KZc5pagSzdPjX2xa4knjFtWxNZc7FHVOOHKqsb9RHbfBYM+xBm5nffIWO
ZJaQpakS6LNrX64nJIwSHM2QAA0KCZIh3yCn2auSQs/Zu5OKj7ouEqb0gkOpIurN
6PXVYYpPx5+11c/oMay0tdEDlOIbaUyk7QO82WVtgz3OP+vp5q63bZXgf8NhY4Qh
bOv8u/LWwy33wGKYo92d+bkK6nIK3Izy7szETFAIWysqlUku9KCT4BKbVwLK1ED/
9b9X3Myzmh8Cuj6b9I695XuOmfvXiqsqq0Cwtna2SJbnz3Fzi6alijGbmB5KuV1R
I96RQF+CSm44lI9UkciCHU4Sqt0eOdNMXDdYtRsEPgmArGeVwdD+ycSwcZgUA0Kf
So+21dNcbHYaaoNL7vK5AYJrvbQoNu2CAQl+BXG2VB8TAG2IeZg3pR9gvts7TZ9J
7BEeLxHiXCIjfjel13WGybUx93Tuus8EcWhxD+lufIhc85kwdWSCjFI+lj5fc11V
hcXeHUxB1HMNGtD92RVR
=fXJI
-----END PGP SIGNATURE-----

--uTCAFClMX+U9tLbX--
