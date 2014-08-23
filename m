Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751757AbaHWOy3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2014 10:54:29 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:57064 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056AbaHWOy2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2014 10:54:28 -0400
Date: Sat, 23 Aug 2014 09:54:04 -0500
From: Mark Brown <broonie@kernel.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: atull <atull@opensource.altera.com>, jdelvare@suse.de,
        lm-sensors@lm-sensors.org, lgirdwood@gmail.com,
        linux-kernel@vger.kernel.org, delicious.quinoa@gmail.com,
        dinguyen@opensource.altera.com, yvanderv@opensource.altera.com
Message-ID: <20140823145404.GI24407@sirena.org.uk>
References: <1408741894-24879-1-git-send-email-atull@opensource.altera.com>
 <1408741894-24879-2-git-send-email-atull@opensource.altera.com>
 <20140822214417.GC24407@sirena.org.uk>
 <alpine.DEB.2.10.1408221927370.2334@shineypoop>
 <53F89E8C.3070200@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Vl4kNlnRfHfswxag"
Content-Disposition: inline
In-Reply-To: <53F89E8C.3070200@roeck-us.net>
X-Cookie: If you can read this, you're too close.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 208.59.64.2
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 1/2] pmbus: add regulator support
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Vl4kNlnRfHfswxag
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Aug 23, 2014 at 07:00:44AM -0700, Guenter Roeck wrote:
> On 08/22/2014 05:31 PM, atull wrote:

> >of_get_regulator_init_data() will only have an error if it cannot alloc
> >the regulator_init_data struct.  That's why I did -ENOMEM.  If there
> >is no platform data and nothing about the regulator in the device tree, we
> >should end up with a zeroed out regulator_init_data.

> Yes, but if OF is not defined it will return NULL as well. Unless I am
> missing something, that means that the code will now fail if there is
> no platform init data and OF is not configured.

Indeed, and that's the more interesting case than running out of memory.

--Vl4kNlnRfHfswxag
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT+KsIAAoJELSic+t+oim9UfEP/AyHQIanF6o+ovN7+Iv1Jeaf
zo3e968+924k+YlGk5/zHc/tzngmqeqR5PXi1me6/T4n6Hnk8ABrNLoY+KBOzGY1
GYibzPyipy0e/xTe/J59dD+7choWDCovs8vl66g97fPzAAYWkNUnl2/fKLOBo/4a
kkkdnYT3hTADmtxBddJMxr4l75Un0abpUHEuLboLlk1M9mGlp3rRQjEf1r3IXmEQ
dFEwKe8wHYEsyGe7FQXzNG/OTdTrSWPkHih2yLkgd3p+e6h5XFkqXTfxEFF2UwhJ
iQe97YyzaiKJSKzA9FdnXVvba0Y+w/Awp7ortoFhd5wX9wHBCUSV5XuA74tFbiR9
A5u40FFbktakjASKRKjJxqhf4dqy+gqr2rDbioXXKla9CuM4jfQ3QdF/D0//6O/K
QxSN9+4klb23lTgf6T5YK+IIkp5Y5ODdIPkjSVFj+vOrHUxh1OcH64tdtJn43qG1
Ibb5EvP2WxXiFBbKmgdSV6CyroExzNpvZFEMeCGnwdOh4I+hnsG4vKzCeqQpnRuw
P7VSRJlTEyBTonctVgBauDHcIpBdO1w18PA2pUm+T67qnvEPLyIMGbUOEcA3W+U5
c9nLxul1oQiFsUlEXp+CTaMIyqWwOOb7Wz9Y+RgevHQO/rl+QaUMNen7obGT40+q
JAJ1sJmiYELyr3pq+FWd
=m80y
-----END PGP SIGNATURE-----

--Vl4kNlnRfHfswxag--
