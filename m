Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753261AbaCCEBB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 23:01:01 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:54643 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752263AbaCCEBA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 23:01:00 -0500
Date: Mon, 3 Mar 2014 12:00:55 +0800
From: Mark Brown <broonie@kernel.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: AnilKumar Ch <anilkumar@ti.com>, Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org
Message-ID: <20140303040055.GG2411@sirena.org.uk>
References: <1392990143.17821.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4B4+7MsODflw+h2f"
Content-Disposition: inline
In-Reply-To: <1392990143.17821.1.camel@phoenix>
X-Cookie: You too can wear a nose mitten.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 202.175.88.218
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: tps65217: Allow missing init_data for
 diagnostics
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--4B4+7MsODflw+h2f
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Feb 21, 2014 at 09:42:23PM +0800, Axel Lin wrote:
> The regulator core supports this to allow the configuration to be inspected
> at runtime even if no software management is enabled.

Applied, thanks.

--4B4+7MsODflw+h2f
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTE/50AAoJELSic+t+oim91WoP/3l1B+vTgdWr1x+5YOA6Gsik
fZQOQDt/S8lzO8iKeZqBqt9Fvee1GM22aoEtQACxIHLg55yRhrRooS6swhlygoLw
H3//y0IX+XKXWQafO5KYSHrhKp+Lc+uFL/Wyz7N3DrQObHMN25ksxLeLbBSOBIIw
Q84h46E9mBERicDLmOkexUHglrezsJWqlUEr9t1cjFrTGKSz+umhOzMDDgiOxYav
D0jyMYWe8PNNt9mztLOn1GJ9K8szBaXCGNqbFuYYV5fds/ZEf0Ff+lK+0fu+tX++
czrToHw3lJdkFP/lV6iOTGU7POh80rZY+U+taYfRm+BUgK1Fk0ZYQ9ITs+uCdp/U
F090oH7h6MkeEsNjJG/isfAV6ERvRLVurxpWsA0UH4N850Ob+51+cf2xk/AmpG/u
qJob+XMMDhppZfgy6ggv4hdR5fC85IMyAG/uKfbSc8iA7h435uXO+gxtqO5PO4JK
qMOGRKnbg4UbfkBLy25OB4hcGChP718MIpWweIxDh19n61OhBqFWJW2LiYZ94wEE
LFmFeK/c/S3645pSpWqcBzGpH9KvyVooi/Y7ywvtk6hMM//efM5fQGgI2QfBC0Na
VF3nwpg4WoSgtwUnfkXjrwwaDeck+8bEechu7WXOlYfa9RhDVhjAt4U2Rrz/bOIb
/n/5m/+d0SB7IzHPKPi1
=gayK
-----END PGP SIGNATURE-----

--4B4+7MsODflw+h2f--
