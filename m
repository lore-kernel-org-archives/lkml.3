Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754146Ab3H1RaK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 13:30:10 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:40648 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753659Ab3H1RaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 13:30:08 -0400
Date: Wed, 28 Aug 2013 18:29:44 +0100
From: Mark Brown <broonie@kernel.org>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        David Jander <david.jander@protonic.nl>, linux-kernel@vger.kernel.org
Message-ID: <20130828172944.GP10783@sirena.org.uk>
References: <1377708911-694-1-git-send-email-lars@metafoo.de>
 <1377708911-694-2-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dUQzTuC3g77BtMOt"
Content-Disposition: inline
In-Reply-To: <1377708911-694-2-git-send-email-lars@metafoo.de>
X-Cookie: Snow Day -- stay home.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/3] regmap: rbtree: Reduce number of nodes, take 2
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--dUQzTuC3g77BtMOt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Aug 28, 2013 at 06:55:10PM +0200, Lars-Peter Clausen wrote:
> was initially added in commit 0c7ed856 ("regmap: Cut down on the average # of
> nodes in the rbtree cache"), but the commit had problems and so its effect was
> reverted again in commit 4e67fb5 ("regmap: rbtree: Fix overlapping rbnodes.  ").

I think your commit message got garbled here - the above are the first
three lines of the commit.  I like the approach here.

--dUQzTuC3g77BtMOt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSHjOFAAoJELSic+t+oim9BNcP/A+tH2rIyqO8UvthycqejF/A
noj49x5DQ2XjxFW4ZAA1CowHzYAb+Lh8NvlF4PpAc62Mc7bx7aXlNlpMigJp542Z
OoXsfFCpK805vyn4R09fUsSaP36ed9CGlU8o11Ge9D9lOzugAOniq7/ZOkEas1t3
FJsHZReHIkLRGeBiiqdJyAT7EpyAROxoMS+D+ZfJvYpRQiw62s5MTiDmb2bm7mNP
uXU7aje3A0NtUpmNUpm7A7eMY4gdBPB9dekIrkihjxYnZoRMgbkSY0E2RLC7BYGJ
nku1xash2cqgdc4BFoZA15O2XI2RonfSJmvNpBV5F89OTJbY+XwquuPtmYdm9CDM
wS1ihB/JuDVuw/dZXygeZxZItzvWtHNLr17R5IqANQYLwS7t6cYPvMaaWK+RRxSa
TlMxaNP2sOSOZ/L6RveOnfRW7E6ODje4cW4qrflc3om6gT2Qm0zrpEwRlc1uXxsP
5iPcDeEeRyDPPw2bctUR5nqyJHEN60JAENObE5KMxeTNvKimCkrPLo39SH2LFA8O
os+f7Hbyg2Z4YnQ9JSF//bHAkELWSc8hg49KFREKHKtZP5dmifQqIN1KclVLlYdS
BA9TzOv+f1vHAY2d+esmmCziEm7mbLamBRAtVIwPffYoG7nYDCdRwbPR3rDv4x/u
6WNtB09JeYwF8O4vXVc7
=R7Ep
-----END PGP SIGNATURE-----

--dUQzTuC3g77BtMOt--
