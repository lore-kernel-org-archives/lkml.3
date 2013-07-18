Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932415Ab3GROzB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 10:55:01 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:47951 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754625Ab3GROzA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 10:55:00 -0400
Date: Thu, 18 Jul 2013 15:54:36 +0100
From: Mark Brown <broonie@kernel.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Message-ID: <20130718145436.GP22506@sirena.org.uk>
References: <1374157317.8329.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="J40Vvg1kvFCV4Ndf"
Content-Disposition: inline
In-Reply-To: <1374157317.8329.1.camel@phoenix>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: core: Allow fixed voltage range in multiple
 linear ranges
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--J40Vvg1kvFCV4Ndf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 18, 2013 at 10:21:57PM +0800, Axel Lin wrote:
> Current code does not allow fixed voltage range in multiple linear ranges.
> If someone does set range->uV_step == 0 in one of the linear ranges, we hit
> divided by zero bug. This patch fixes this issue.
> For fixed voltage range, return any selector means the same voltage.
> Thus just return 0.

Applied, thanks.

--J40Vvg1kvFCV4Ndf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR6AGpAAoJELSic+t+oim9LT0P/A5D9wBXU8tsga/Gc8QJdXlc
7YVlgNPn5euGC+5oylKiHybsmvfae/Vm1zRUFWPbdJ7SYbcqwx2vgjHNk20S0m6L
MDJgWqMAxP8ULgqsIhzccvKViNLX/WD5UT40O4Xxl7gLW+u9hEhpFG+zIa70XDwX
ulgSkDJFO4IisbgaVL5VsBqbZOLsWAbE+NE6SzmetMMtIKK+yGkdfOfO6bUaIkrt
+ymzdYtlRukjPyAJWFE3odt2HaRWv3y7azRGqgKOL5JrDZDp4HLOM87S2KQFSoPq
PYggG0M+WbeJb4iC46DsMQP/ET9QPpXyydSWChmjO6H4dgDb1Ovj29yPlMiCn5Ih
66bX4GADWDMbb+caMQWz4WYPuOy64wIOW8LK2TEni9euFQb94jUAqjBgyxwGY3XV
f5pQmO+bqpK4tl0mWjiaD3/nmoEBZLsRGJe7cPKp0S5chQBvHuTkwN4HX2x2uSNQ
emCCBKrF8KVpzcxJdfuVMMEeg0z+xzlWnUbL25i8zflzhDPfAL9W3QFMsph+O2RC
Jm+cu0Yi3kWN3hYr6JGCYmIKNi3QEYEMwnZFuPod9qtUVGlKkKz3F9aVywmo8IPG
W3wGTmW8iOE4K2N6NLR/qCMy/YThQr59mlTVhO8ZPRI+FxVKUmxYlGbutlLqce0R
TeO+yKGXAQBK3pO4eSSt
=cMZX
-----END PGP SIGNATURE-----

--J40Vvg1kvFCV4Ndf--
