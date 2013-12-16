Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753416Ab3LPLSN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 06:18:13 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:53107 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752663Ab3LPLSM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 06:18:12 -0500
Date: Mon, 16 Dec 2013 11:17:48 +0000
From: Mark Brown <broonie@kernel.org>
To: Stephen Engelman <stephen.engelman@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Sangbeom Kim <sbkim73@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Message-ID: <20131216111748.GB3185@sirena.org.uk>
References: <CAJuevmANPg28tBovqT7PFBHorjVeh0SiBEkcmfocJMwy8NX5fg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zx4FCpZtqtKETZ7O"
Content-Disposition: inline
In-Reply-To: <CAJuevmANPg28tBovqT7PFBHorjVeh0SiBEkcmfocJMwy8NX5fg@mail.gmail.com>
X-Cookie: Yow!  I threw up on my window!
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] REGULATOR: s2mps11: fix regmap, renamed to regmap_pmic
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--zx4FCpZtqtKETZ7O
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Dec 15, 2013 at 09:37:19PM -0800, Stephen Engelman wrote:
> Change regmap to regmap_pmic.  This is needed for commit
> 3e1e4a5f3a324502c27c4e8808e06ac2ea842360 ("mfd/rtc: s5m: fix register
> updating by adding regmap for RTC") to rename regmap to regmap_pmic in
> include/linux/mfd/samsung/core.h.

This has still already been fixed by one of the Samsung guys.  Please
don't resend quite so quickly.

--zx4FCpZtqtKETZ7O
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIbBAEBAgAGBQJSruFZAAoJELSic+t+oim9D+wP93VDZZuXyGF+3n8D/f5po8W2
7BfA7JbT1euC4FK5ZVuFyA8zj36BZdq6SqUy3Re2IBRUvSeYSd/fflwqR2nCucA4
UJgZesKKOvIrwE4k2EjL4V3vjMScDc/z0zFs4Y0zYOB1VTlStw2xUqfgs7XJYi+r
66IB33MGr22BaqujYa/khbbJ+YwMfxqXTcAZTNv61jDlG6S3wS2AM8H8o+Fxgthb
x7cn0FYwyXJKRPKootSi1ExB20ob+AWIjOci8Z/2Ez9TAs3IbaCDOYVEWRvrpiit
mAX4doFcMVliK3Gmu7W2QTIHS7LhmmYQ+br7EHUOj3q8Xk8kmcMjo1TFjdxZO3r+
b7aY5Fxmm66ODrOjASkAiLC5JAz66EcKGhVF8omVz5i85j1t/dva5FMntx4j1oaV
iZ+NcRHfqRcwSxwTcTgAVHZ7PmReaLZglWDh75EhwIi7QxMPCLJGJd1ai069LyIn
IQy6elCQxdRjJfPgrvxX47/zusL81qXjOMTQUQxQd/tszxZQGpl2d0Hb4/d+ckgZ
dqKEJO3EDyZfYwhBf3Ddv6PowQqoObcw56DElXayr9q0JPW/NkgAetjj6u6araLl
Wfl9tG3zlOzT+e2JPphCGUK5GMEsF5mZk2/ZgmVtZEYflcQYcxJn4ZInS+Awrrh+
+SFve2P0Cnsm3MrypAs=
=dBW2
-----END PGP SIGNATURE-----

--zx4FCpZtqtKETZ7O--
