Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753688AbaBESiW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 13:38:22 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:36411 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720AbaBESiU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 13:38:20 -0500
Date: Wed, 5 Feb 2014 18:38:14 +0000
From: Mark Brown <broonie@kernel.org>
To: Adam Thomson <Adam.Thomson.Opensource@diasemi.com>
Cc: Lee Jones <lee.jones@linaro.org>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Guenter Roeck <linux@roeck-us.net>
Message-ID: <20140205183814.GI32298@sirena.org.uk>
References: <cover.1391614923.git.Adam.Thomson.Opensource@diasemi.com>
 <6a398d176b0b2bf8792d27bd5e2995fd96afb32d.1391614923.git.Adam.Thomson.Opensource@diasemi.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="poJSiGMzRSvrLGLs"
Content-Disposition: inline
In-Reply-To: <6a398d176b0b2bf8792d27bd5e2995fd96afb32d.1391614923.git.Adam.Thomson.Opensource@diasemi.com>
X-Cookie: Take it easy, we're in a hurry.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/8] ASoC: da9055: Fix device registration of PMIC and
 CODEC devices
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--poJSiGMzRSvrLGLs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Feb 05, 2014 at 05:48:32PM +0000, Adam Thomson wrote:
> Currently the I2C device Ids conflict for the MFD and CODEC so
> cannot be both instantiated on one platform. This patch updates
> the Ids and names to make them unique from each other.

Acked-by: Mark Brown <broonie@linaro.org>

--poJSiGMzRSvrLGLs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS8oUTAAoJELSic+t+oim96VoP/1zBrLQmM7cWSXMxK2kl+5wR
Qz0bZD7TA0E9UMpn7MJBzFB/N6KZ2THQhl0qujW+UGa6etd+UN4v2V24ItA7Zpad
Qko0TZn52adJpi1+iktqZqhilDf3ivvwFl9zs6cs5+sh73r/PdsvPQKVkkhjgbfF
iF48GxW1cf9N9WHrK1nK/qXRJs5hluHC8rhaufF4tlADMR9GtdSRI1glyIrY7KCx
uvpwRjLHZaIkHjCFP9UBzHd+ebQTguB36Y8MDUlvwZwiaiBxZ2Ta2mNi8LimJFWX
vDPJMW8dO2qMl46xgQGMICl2Z/z9Q5YFtsAf3je2PW5ejXMilj6b3CxWBy/bLU5N
/F0wEqKW7RG49wqJLrIsXtsR74EmYGUVNorcBEgV3hheX4jZnBF/8rKGBALalxY/
yAApYJ/S8YPPPA2YFwLLumD4rB5okvivufIxepAPTJqZ9Eg9z+vSulOOgZROBPQD
cImpLg1XlyRqrFbsWaBCAXguontn30mPEUo7e0/wfENurDZCZTvL0kRSXhXjS3EG
gQmcVvQuj+WHg3rEQQ7jBiC8zmMvmBayQEt1Iisqy0+8rqqVsHg8iJcK1Wyt2qWn
zAI/NIsY/G9lyLDd4fqeqKQf6CK0sKIZIEgsQGh22iZ84wPnO8nx91PtdMOkTDr1
O2h5sKKkC9g/29dI3wjT
=ZMIu
-----END PGP SIGNATURE-----

--poJSiGMzRSvrLGLs--
