Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752608AbaBCPlX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 10:41:23 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:34738 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134AbaBCPlW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 10:41:22 -0500
Date: Mon, 3 Feb 2014 15:41:09 +0000
From: Mark Brown <broonie@kernel.org>
To: Jean Delvare <khali@linux-fr.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org, Guenter Roeck <linux@roeck-us.net>
Message-ID: <20140203154109.GB22609@sirena.org.uk>
References: <1390846075-17415-1-git-send-email-broonie@kernel.org>
 <20140203104141.40cc04e5@endymion.delvare>
 <20140203110249.GA6392@sirena.org.uk>
 <20140203153512.3b1d14e4@endymion.delvare>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JwDyboxUGYfjwwUw"
Content-Disposition: inline
In-Reply-To: <20140203153512.3b1d14e4@endymion.delvare>
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


--JwDyboxUGYfjwwUw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Feb 03, 2014 at 03:35:12PM +0100, Jean Delvare wrote:

> Ah, I see it in your tree. But it's not in 3.14-rc1. As this fixes a
> regression, it would be great to have it upstream ASAP, so that it can
> propagate to 3.13-stable.

It's on a fixes tag so it'll go in next time I send stuff to Linus,
it'll go next time I send something to him.  That's usually about once
per release.  Especially if things are tagged for stable I like to try
to avoid sending them too quickly unless they're build breaks or
similar.

--JwDyboxUGYfjwwUw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS77iSAAoJELSic+t+oim919kQAJ34xyr0h0/ElmzK89pxshp6
NfR0HSjjRHitY5TTH55S+DvnxYTPw+qk2BcHBWp3nzSBdtfTgA+FP7/xL1VqLgyn
BWKKkB4ASvs9T4LTFaJ7ldttQcrQAf7fYl0j32M34Kqgj1ZaxVKt/PQj61r/fG2y
WrU8asDM5Wb89dVJeZnE7gS0bErNMcKU6ReeQhPjXf3X4bxi9dsOEohDeCaf2jey
W0HEKB71gCHrBqjTT6cP11Pc7QtXfGQwriqeWqkLKB4zvZ3G+xKawXwPWwf0q6y9
B5FW3P+/YqXLF2byqU/2g09n4tf+kYqVqj2Ymvz+W08oWCMAHKoL7XrRbuA/6DZ3
2JMy2YRQjejkBPb5rBEb/RSckPDlXZ2nOE+RPZN7iyCGCGtf+uNeOakEBAmJsnhH
jyxlMPrNNMnMkBhdQ1HeLiSBjsq6faa5OMpLiAN9TXNimKfWqedu0OsWrDFxi2UL
ZWxsrgg2o5thuvAB7QVlCWvE04kRubdhjtpKfHBlyYsIVV7JyVHvsdiGNi+/MBqR
DMfT0cf3AdTIbQbN3uYyyXY1RBU5nowX/vVXrfUNBAENpqUbSDNKXeWqpcBD45uL
oZMzVLXHMjmdeDtCaEThUNED7huzjqU9pAaF04VWhUqgzz62vLpKcgj5XAytWE78
uty/BDyxRSXJnivrhv+r
=Fg87
-----END PGP SIGNATURE-----

--JwDyboxUGYfjwwUw--
