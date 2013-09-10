Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751751Ab3IJMMr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 08:12:47 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:49008 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751225Ab3IJMMp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 08:12:45 -0400
Date: Tue, 10 Sep 2013 13:11:57 +0100
From: Mark Brown <broonie@kernel.org>
To: Wei Ni <wni@nvidia.com>
Cc: Guenter Roeck <linux@roeck-us.net>,
        "khali@linux-fr.org" <khali@linux-fr.org>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <20130910121157.GJ29403@sirena.org.uk>
References: <20130909135022.GZ29403@sirena.org.uk>
 <20130909155043.GA18975@roeck-us.net>
 <20130909160237.GR29403@sirena.org.uk>
 <20130909161735.GC18975@roeck-us.net>
 <20130909203910.GV29403@sirena.org.uk>
 <522E9A85.9050803@nvidia.com>
 <522EA51C.90706@roeck-us.net>
 <522EB0AF.9030708@nvidia.com>
 <20130910101359.GX29403@sirena.org.uk>
 <522F02A4.7060702@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wvmAFhn+Ugdou746"
Content-Disposition: inline
In-Reply-To: <522F02A4.7060702@nvidia.com>
X-Cookie: Your present plans will be successful.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v3 1/2] hwmon: (lm90) Add power control
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wvmAFhn+Ugdou746
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Sep 10, 2013 at 07:29:40PM +0800, Wei Ni wrote:

> On my platform, it use palmas-regulator.c, ldo6 for this lm90 power
> rail. I checked this driver, it will handle ramp_delay except LDOx.
> Since I'm not familiar with this palmas device and driver, so do you
> mean I can set regulator-ramp-delay property in the DT for ldo6, but I
> really don't know what value should I set :(

Laxman just submitted a patch adding the ramp delay information which I
applied.  It seems like this is just a hack for your board and can
therefore be removed?

--wvmAFhn+Ugdou746
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSLwyKAAoJELSic+t+oim9EJ0QAJABKUsNKO5ZsmnJsLVUSgQA
gwqfjeFiV2Zt/1GQmIpqmYeEBnkHVdXzDkSrP26dlvKymzDEmxs3Fak2qZ1UeI3/
WpHpK/1kOgnVPlyL514Tx5PJAmM9mmHh3/Ry1HEeMsq6fVpydTj0UrS5z3xnVe1A
kPryp2w7zNaPnVIanyQleWhDZ99Dzqo4E9ZbF0tsogIXVGRbsQXR8P7WgXITCCh1
yW5fvFFypiXXMFoV/Ur9jORR7cawnvubiQDjgpSCE/PVEK9hEAUFN4/n+FJD4ej7
yiDrBWvb8XNtSeAyTHYhBRXMgISeNcWyrViNkpli2NjDz0c1TOvXEK1LmWhX3c9M
P6NgYaqv3TqoWwNQfBouuAMeXVSjlhgSA6rPLsFGWr9Dz29t1jdD0cm5FIJrXl7k
SeK1TCL19U1HnAzbuO8eegKDjdQWxYecFULX10G46rqa5lVRwq9V6TkYaPdytHsI
IxkuuE60ILJD95GlPTHGdh8rhv2LrKefcSCapVfpyNIpVU7uI87yTHSS50xT4Lc6
w6HHA9HOZEIWsit6pUeh0cB9ydY5SZG7Y2AGP0GaloKOqdAuulsyO6KByEglz9m2
MkHjxOBPHJ9tlaWFMC/heLBGAaNfyBoNwm4ct1kLACTq1EXIa0Kd0lNG9msxYyia
+wEJ6nOxHvPPcAaso47k
=RC+n
-----END PGP SIGNATURE-----

--wvmAFhn+Ugdou746--
