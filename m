Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753208Ab3LBR72 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 12:59:28 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:53547 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752879Ab3LBR71 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 12:59:27 -0500
Date: Mon, 2 Dec 2013 17:59:15 +0000
From: Mark Brown <broonie@kernel.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Balaji Rao <balajirrao@openmoko.org>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Message-ID: <20131202175915.GO27568@sirena.org.uk>
References: <1385785263.24696.2.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="QG/O2cIMOuWJCdDl"
Content-Disposition: inline
In-Reply-To: <1385785263.24696.2.camel@phoenix>
X-Cookie: Boycott meat -- suck your thumb.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [RFT][PATCH] mfd: pcf50633: Correct device name for pcf50633
 regulator
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--QG/O2cIMOuWJCdDl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Nov 30, 2013 at 12:21:03PM +0800, Axel Lin wrote:
> Change the device name of the regulator function to the one chosen for
> MODULE_ALIAS. This fixes kernel auto-module loading for the regulator function.

Applied, thanks.

--QG/O2cIMOuWJCdDl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSnMpwAAoJELSic+t+oim9WGAP/jhF3+sj4/WXjLVU0dwHN2Q2
iqKwlPH0nLNDm+eCcewCjg4OPYyGN8MgzVwQceyJ2JMkJh3R2H6UeEZUU3HzeagF
kJxXV2cooakJpK159n7P8gSeDB08sKVNUTM6kFzcg/LXIK8fDMZf4S31w53X/Rja
ePqhsgWWnlIoElqn8fYsIBlYP4lu97q34qq2mcULrwttOByiwL1tXq7zCCcU0LPs
5+C5M7+FHaZXMna74mBktTjzZ9BruKyyHfIY6qrkfbhs3dady/KjVJ77i3YzCnG4
jERU2CyF0AeTtubWnFaDaHCl7kpvpA6bp8Hf7X6THIu/JWiOn98pYm/NC7YNpcmy
PNMyez2b057EIL3DIVI7QXhzp79srROEdoeZQUVYxXXUVQyvDWYriJv4THBgzNsT
6LV5nBQSDQWctE8nrVQuR58yRfkFmraYKyBLqRGDQhNynEk8tNiGCrM//KuI/5f+
TBA9M3qKR01NGEtLe5zP1FgxbDtfAZ3gpQT1zGX3xonDKhWGe7atwnQUmppSTXiX
Uvhf3lvGLz+iE+V8LYoXCcxKewzn7A5jFXzWgAnalgekMeYuO7+68oKo146jDBQc
P/+IZoAxZ/7sT37sIUwlvy2s3AuGw+EIHiHIrgNLinios+D6mggvzO3KyORyxIVS
XfwKYd5cBXyFVdvijoLy
=kZTz
-----END PGP SIGNATURE-----

--QG/O2cIMOuWJCdDl--
