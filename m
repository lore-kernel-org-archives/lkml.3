Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932500Ab3FRLpE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 07:45:04 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:33151 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932431Ab3FRLo4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 07:44:56 -0400
Date: Tue, 18 Jun 2013 12:44:36 +0100
From: Mark Brown <broonie@kernel.org>
To: Mikko Perttunen <mperttunen@nvidia.com>
Cc: wsa@the-dreams.de, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        linus.walleij@linaro.org
Message-ID: <20130618114436.GM1403@sirena.org.uk>
References: <1371551413-12346-1-git-send-email-mperttunen@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xluWKNDh2/FEVhBx"
Content-Disposition: inline
In-Reply-To: <1371551413-12346-1-git-send-email-mperttunen@nvidia.com>
X-Cookie: Tomorrow, you can be anywhere.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 82.42.102.178
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: tps51632: Get regulator name from i2c_client
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--xluWKNDh2/FEVhBx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jun 18, 2013 at 01:30:13PM +0300, Mikko Perttunen wrote:
> Commit "i2c: core: make it possible to match a pure device tree driver"
> changed semantics of the i2c probing for device tree devices.
> Device tree probed devices now get a NULL i2c_device_id pointer.
> This causes the regulator name to be set to NULL and the regulator
> registration to fail.

Applied, thanks.  Though it does seem like we should just be hard coding
this string anyway...

--xluWKNDh2/FEVhBx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRwEghAAoJELSic+t+oim9AIcP/jhoJ+Y5sS9W6S4Q+fmhHNCS
0vNN2LyEVmu9ktoWdQRbB9AV4tdbxPfRdOLgYbHLlef2NyliIYPexY+mOO5lL1gA
UQfr9i5HMFcriaTsAQlM81ySY5yis5L6GuP6iNwTLoCt8ozzcX91tj5B29WN+Gi5
Ta85fOG4TgtmqUVtp8wgqIfPh08JvEfZYUzh2mINt4F+BdHVt6P65FR6Mj1BtXU2
DvjEKAgPqxWZTDBIcOuLRms2D20Y1qkdBw5WK/iF0MgmTYWj8RkGAZkqsK19D8Yp
Zugrq4fx29+NsTfcnVJQ/wfpu/ZhPhhLy2Ix3cBGLZzx3pG1h+UkP5Uz6VVq6amM
L1IsrY/UR7KnU3abAg02ULUWZqseYF46qXf+7jSwANCM9KvrOshGo1g+GqyMB1rP
jc+OBFF0pNxCQ1ZBeoRh/9sKpKUAE+AD5p2gpEBnIWPeygRom1FIld3lBRgmbOot
Vv81xemhvpJxamSV8Xe1zm1vbptbJXKOJMKHriVFf1N28y3Dgmnikmcc5L3PjJlk
7pYfNE3t8kUpPG07O4gbT5sotnEGPtHcxbA7S8QTH+9n4xnBdgG92lv8wVnWmXRO
eMfBMuEIeDcPSWNT3PjPp+geUXGFytpLKzVY9NPkRwPGBanKWUPyInX8nHDjVcUR
WTkQr+ul/PJPWv4iCM0R
=iqjm
-----END PGP SIGNATURE-----

--xluWKNDh2/FEVhBx--
