Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932541Ab3GBJbg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 05:31:36 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:39022 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932339Ab3GBJbf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 05:31:35 -0400
Date: Tue, 2 Jul 2013 10:31:30 +0100
From: Mark Brown <broonie@kernel.org>
To: Ashish Chavan <ashish.chavan@kpitcummins.com>
Cc: David Dajun Chen <david.chen@diasemi.com>,
        Ashish Jangam <ashish.jangam@kpitcummins.com>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
Message-ID: <20130702093130.GX27646@sirena.org.uk>
References: <20130701164833.GL27646@sirena.org.uk>
 <1372757513.28415.2.camel@matrix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="i4PQY6bUD8mHTt/C"
Content-Disposition: inline
In-Reply-To: <1372757513.28415.2.camel@matrix>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: Multiple DA9055 chips
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--i4PQY6bUD8mHTt/C
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 02, 2013 at 03:01:53PM +0530, Ashish Chavan wrote:
> On Mon, 2013-07-01 at 17:48 +0100, Mark Brown wrote:
> > It seems we have two drivers in mainline for da9055 on I2C.  We've got
> > one in sound/soc/codecs/da9055.c and one in drivers/mfd/da9055-i2c.c,
> > both registering themselves identically.  What's going on here?  Is this
> > a combined CODEC and PMIC, has someone decided to release two chips with
> > the same name or is one of the drivers misnamed?

> Yes, this is a combined CODEC and PMIC.

OK, in that case the CODEC driver is just plain broken then.  Did anyone
actually test this stuff?  Please fix.

--i4PQY6bUD8mHTt/C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR0p3vAAoJELSic+t+oim9ROQP/16p+njQaqCQ4WODW7mrlBJn
kaEJ/XfRMpP5b3OnsZ46Q2DK2S54le1RAnoeOihPPA5PI7jS8vbmiBRrmBAhNwMb
OIJ+qCFiq7V7qZHqnMUgiC0VraYR0E3xukipidP8NaRocfcdy5Hn48YVmZuYzLF1
ERjKxBfpAFxPQm4nPYnthbgpgYES0G6v27rm2NQ7fk+Mk2gHIgjCZuIHSDuNUCJ2
1TtZ+nGmlBudAgEiBdSUAAMou3l3Cx+W5QI7b60NAPy4myFPhh2qi5x5T1pNEcu2
t1IosELLwMrz/O5PYVwWaIJDd5e+I71j2VZEQWBJEdn0cDGhaPxNnV2iYE//pSDt
pl8fPV8CjOdqGguooKsW2ul6I7S9xTpZ5/xe3lDiXz3iILTZpd66AxJVWl9U5WpM
/6zOmgyUHHEIty2iSNyZWy06iFqwRQmfZPxu+5NSDIMVx4ETEDJP3TngZI5bZk/L
ARcq2wkx1u58xWk37JaHfrbPfuMoC6W5/kdjCJ7IBAqFKtjjApuQAbTXHDSYHOPg
9bF4a5CyLNpjqVqlzE1ApeD5TAM8ShZhK5+joLjsk6kxfY18XThHSHiLZiz8z4GK
P8LUB/sHRUssQWu7kVMFTtMSLgKkKi8lfHg7aaoB2DTXGNMgJHnopk5VlYpvRiNV
nQwzX2OiVk+3H163kon4
=UnbR
-----END PGP SIGNATURE-----

--i4PQY6bUD8mHTt/C--
