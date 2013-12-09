Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760595Ab3LIRoq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 12:44:46 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:48282 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754146Ab3LIRom (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 12:44:42 -0500
Date: Mon, 9 Dec 2013 17:44:39 +0000
From: Mark Brown <broonie@kernel.org>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Liam Girdwood'" <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Message-ID: <20131209174439.GH29268@sirena.org.uk>
References: <000a01cef251$c79ea9e0$56dbfda0$%han@samsung.com>
 <000c01cef252$1b341040$519c30c0$%han@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mew6/suNvUayQDfo"
Content-Disposition: inline
In-Reply-To: <000c01cef252$1b341040$519c30c0$%han@samsung.com>
X-Cookie: It's clever, but is it art?
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 3/6] regulator: fixed: use devm_regulator_register()
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mew6/suNvUayQDfo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Dec 06, 2013 at 04:09:29PM +0900, Jingoo Han wrote:
> Use devm_regulator_register() to make cleanup paths simpler.

This has the same issue as the gpio regulator - it needs a more complete
conversion to devm to be safe due to the use of other resources by the
regulator while it's running.  The conversion looks straightfoward
though.

--mew6/suNvUayQDfo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSpgGDAAoJELSic+t+oim9lrUP/00/B8e2zGEcmzo67Gn1CwON
z3gduN9D6bs/4HucY4AbhJk6Qc+QwPzGVVJxYQMD2odNUn/2AwkhbZJhAhd2WfNr
t86nTJL55AlGvGCR6LIP1pp4/qyyuhf0vteWTTntZxBUkjFATy2qid9VaF66bFiK
3f/7LrweJjLK28on3VUaTEX3t3wDsZREtmUJ5qta+ghdsb94DIXEW/lr6dXBppSQ
BQDcjnFaCtVsNMibQGvJm9NrqMxd92mwLaW2/ORtUHkHJ9F4T7mSq+7yEJ/KEB7E
p8C9LGuxX2/BR/btqV8qbTzyWzqlm5J0xHyNpsbmqu0OGEC0GsfyDFqW6jANGAFC
0gWCIWFWMbwBmgUC4XSFhMa0MZY1DbBEbHTpMCQV9t8UJwr0DEkOhWkKM1zbFuS/
Ioj+eDpLd4xUswwD2CTeJzY9RYf1NkponuZ7BVNFp5NU3lm43sduilAWXsctAZKh
LKLT/6vG2Z3ylgNLWCuFnAD0Yo5D4FZ+SZKwS7Z5zea0VUM9o5jYr3DSMqth7Rh/
wLniVRl6Nvy+8gibBf2XsJ5LsdPvUrmpmCXyodXxDsSpu35ozzdohqQC/vL0tqFL
HHho6FZl4qxEk01n6ByIdVuiQKtCdnABSazp9tvGfUIeSs2fHvIbo31OGKnvjJek
NtDlda7cZj8uUu0b/3Zy
=1UGS
-----END PGP SIGNATURE-----

--mew6/suNvUayQDfo--
