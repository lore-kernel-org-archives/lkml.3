Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755529AbaEIOtE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 10:49:04 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:39332 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744AbaEIOtC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 10:49:02 -0400
Date: Fri, 9 May 2014 15:48:43 +0100
From: Mark Brown <broonie@kernel.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: Alexander Shiyan <shc_work@mail.ru>, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>
Message-ID: <20140509144843.GO12304@sirena.org.uk>
References: <1398926883-21778-1-git-send-email-shc_work@mail.ru>
 <20140509113030.GV5767@lee--X1>
 <1399643769.716496780@f345.i.mail.ru>
 <20140509141840.GZ5767@lee--X1>
 <20140509143054.GN12304@sirena.org.uk>
 <20140509143629.GA5767@lee--X1>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mHuN3Uv9+U713CGJ"
Content-Disposition: inline
In-Reply-To: <20140509143629.GA5767@lee--X1>
X-Cookie: You will be successful in your work.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/2] mfd: mc13xxx: Do not use platform data with
 devicetree
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mHuN3Uv9+U713CGJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, May 09, 2014 at 03:36:29PM +0100, Lee Jones wrote:

> > Why not just pull the tag instead?  I haven't looked at the patch but
> > don't they need to go in together anyway.

> Only functionally.  They are orthogonally buildable apparently.

Working code seems important to bisection too...

--mHuN3Uv9+U713CGJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTbOrIAAoJELSic+t+oim9KTEP/2m6PE42xK07EdHOKUaipUMh
+WkoYfKYPbVmx0A72QR+585Ttl5SScR/F8qG8zH9SMJ3wnRDOlBwCSfiXQwy6M7y
mJgq1KwHLQtLVALkgOD1TLY0FOcU5s/ZvR5MAmz1Ln8kpjY1HHEFGWXzkdc128Q9
U7sQdYIeoNFJgL+RpfG1OU4kTEbZpivUpjzOWyOun4bPEWLMBY/o31N4RCYsTr9Q
p0bm5baWqgtl81FoDRJqc8QB906LvCgNo+z/pVQDgv/1adRPXlPxwx/EEUVp75fW
zY/+07BN/ppK6DdJgohVWbYAsNoIcgc3uM5GZlRMke4lOnKfVx4Znx1z+9QckNE5
Rtalp9WXkpqa7S1WOUhyje/0OFduxrNtfwamMmw24p0xidJquEwgUJ/MBeQrRvex
yNGhwmkhpMU09VXVXYToP5XZ/ANFRO7qXD8AwM+Wpd+XpNg95JOMTnR3gY9XQEui
VdasCv2+sA8IKNE+tkwULhB/6f7fSTGfEcGAOO7mHyvN0Y7hnGoDhI7uVH0z6c9N
nRH+omPvA1Nwi3R5QPyfA3lIPmqq48tNzS6kQCuxW3VzAN4Rg7ZtqEyHAsfJqGpc
7UvwqC8SHj7ckSZjYyEEnh6OIxTZsrPs3Su/b3zSwSQr/csBPLSoHPlOOaiysGq6
0vqhdW5nNjvaJ8iroFzh
=2hOb
-----END PGP SIGNATURE-----

--mHuN3Uv9+U713CGJ--
