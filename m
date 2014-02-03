Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752975AbaBCRbT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 12:31:19 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:34765 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751886AbaBCRbS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 12:31:18 -0500
Date: Mon, 3 Feb 2014 17:31:04 +0000
From: Mark Brown <broonie@kernel.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Jean Delvare <khali@linux-fr.org>, Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org
Message-ID: <20140203173104.GF22609@sirena.org.uk>
References: <1390846075-17415-1-git-send-email-broonie@kernel.org>
 <20140203104141.40cc04e5@endymion.delvare>
 <20140203110249.GA6392@sirena.org.uk>
 <20140203153512.3b1d14e4@endymion.delvare>
 <20140203154109.GB22609@sirena.org.uk>
 <20140203165210.GB30754@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KvB7u8NuoXBZIbZd"
Content-Disposition: inline
In-Reply-To: <20140203165210.GB30754@roeck-us.net>
X-Cookie: PARDON me, am I speaking ENGLISH?
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: core: Correct default return value for full
 constraints
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--KvB7u8NuoXBZIbZd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Feb 03, 2014 at 08:52:10AM -0800, Guenter Roeck wrote:
> On Mon, Feb 03, 2014 at 03:41:09PM +0000, Mark Brown wrote:

> > It's on a fixes tag so it'll go in next time I send stuff to Linus,
> > it'll go next time I send something to him.  That's usually about once
> > per release.  Especially if things are tagged for stable I like to try
> > to avoid sending them too quickly unless they're build breaks or
> > similar.

> We still have the lm90 driver failing in 13.3 for non-DT platforms.
> One should think that this has some level of importance. If a driver
> doesn't build or doesn't work makes little difference for the user,
> after all.

On the other hand it's a hardware monitoring driver which nobody managed
to notice problems with for pretty much an entire release cycle and a
fix in the core regulator lookup code which has the ability to break
boot prior to the console coming up if it goes wrong.  An extra week is
not going to be the end of the world here but helps ensure better
exposure of what hits stable.

--KvB7u8NuoXBZIbZd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS79JVAAoJELSic+t+oim9vHwP/0stlqDLuWHZ7ulB6B3EDLu+
HM3No9d6nK+zm6b9gWK9ZXEyNqx9rEFis/VECGaIl98sxzEm0hHWXGdSBFjO/Ud3
WqeR4SMPMngKMTJm54StD5OcU9Gji5QduUhAU3LELYN22ZA2veM8E1xulIBckZ2j
ob+lAwyrZLQcD8ay13JpPPqBCAKOGDN16kDen1ld2gJ2UrUHgHFwcPD+rn0Z80WF
I2WdVZQuiWiOD8/LvYouVghbMXxQlzA++sryL25SqfmdDMRT3kShKi3c+2jPeOnq
9xw7MklJWi6xHVU98K+nG4PBfuOcwCfFEFkTdp8NkkZIpXCkjs6EvYACbgVyMNJD
qQzURX3fpPC1joS31WCeSbWK6eHHXvDUqnZl+fmNPJ4QEw2vFN6efBNf8sroOlEk
e3xUXQgdC0cXfhIDzoNFgmdHI7eXpHYyj2WgLsvZ2A5jp3gVFkxx2ZVmKhdkMMrp
DAbvn65e6FpsXW4B5uYWXYs4NFf68M+4c/lkQKulhhn5IS0wGwVOXOwx9w0t1yG/
g9HHPuSb0kmu71tUKucCdLTsF4AKzoqK9IZtewtr/H0tmL8nMPsvVS7vP4s0Kz9V
qcaY2JSreL9+L0kiONrYuySkNLG9sR4X7wC9RlOYAn3OkCB8EtdW6x6KKImQl8vL
swn3b15DKr0+bfD+nx0T
=89Li
-----END PGP SIGNATURE-----

--KvB7u8NuoXBZIbZd--
