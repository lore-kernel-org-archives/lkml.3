Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752827Ab3JEWpV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Oct 2013 18:45:21 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:45652 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752494Ab3JEWpU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Oct 2013 18:45:20 -0400
Date: Sat, 5 Oct 2013 23:44:54 +0100
From: Mark Brown <broonie@kernel.org>
To: linux-next@vger.kernel.org
Cc: Thierry Reding <thierry.reding@gmail.com>, linux-kernel@vger.kernel.org
Message-ID: <20131005224454.GA21581@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vtzGhvizbBRQ85DL"
Content-Disposition: inline
X-Cookie: Penalty for private use.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: linux-next: Tree for Oct 4
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--vtzGhvizbBRQ85DL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi all,

Better late than never I've uploaded today's linux-next tree to the
master branch of the repository below:

        git://gitorious.org/thierryreding/linux-next.git

A next-20131004 tag is also provided for convenience.

Each merge was tested with x86_664 allyesconfig.  A few new conflicts
and build test failures came up along the way - these have all been
reported.

Thanks,
Mark

--vtzGhvizbBRQ85DL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSUJZiAAoJELSic+t+oim9Cv4P/1jVgCbk77VpUv7BPA536mo0
WFc7cmj+KGyDL4PrwhRcN0VJeB1B9oC5SSddW2jqfPnDi3Ysajvlx3W4sOSPiKca
TH4vpXaPGXXXngbQ5kU2C2t3KVgGSn65uu/kbA6Cgm7Z5adovGXJiUg5r3m9ff8F
0Jg63Q/X6hMYOiUuijeuJd6I/hk6bJVvwCe3QBs6qLA+hGRveMhpn5o1293Hj0N0
GJUL4g8zmDxk7Ls4xDEylI/5C7+raV69rEYhygP/wT3a8a/KtUm4ELL7Irhq+emA
LxcwtyLGAs6IOzbPgqLaTvJhKgdfUaOA9pP+1cY+QkNkuepkYhC+1x9K4WbQ3A47
royC2COf5DJiE+EmlI7xISyVl5aXZx1zd1mKzGzTHMeF5P0ngaiETD/8a+Lr+6F/
RtrQWRLUevhJJryfGP46TMeiKxC7cLGS2DqgrL4c872cMU6WYcqQI2zLQFAL1Onv
o+c2JfNbRn0KwZuVW4JRSIoRRUPpmEuRheDSinJc2WrNgYJGvR5PBjeqVCnONwES
fKsaeN117zTnSwHPhDqCrg4Su2+pVivb2GgW1RChj//vlTC2DCG1IvgP5AFLnmUc
nCfYP582joFTQaZM1vRopnohtVBTOp8Kg7ToAoKZP5vuz6bLkTt+vo3HG8Nwsbq/
dUb6RGfMAv/2KEv8Spma
=j70u
-----END PGP SIGNATURE-----

--vtzGhvizbBRQ85DL--
