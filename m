Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753657Ab3IWLFr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 07:05:47 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:59090 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752856Ab3IWLFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 07:05:46 -0400
Date: Mon, 23 Sep 2013 12:05:43 +0100
From: Mark Brown <broonie@kernel.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Message-ID: <20130923110543.GC21013@sirena.org.uk>
References: <1379922860.20251.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BCQW4u8rtOzpP30D"
Content-Disposition: inline
In-Reply-To: <1379922860.20251.1.camel@phoenix>
X-Cookie: Give him an evasive answer.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: wm831x-ldo: Fix max_uV for gp_ldo and aldo
 linear range settings
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--BCQW4u8rtOzpP30D
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Sep 23, 2013 at 03:54:20PM +0800, Axel Lin wrote:
> Fix the linear range settings in commit 5ff26a14c3331
> "regulator: wm831x-ldo: Convert to use linear ranges".

Applied, thanks.

--BCQW4u8rtOzpP30D
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSQCCDAAoJELSic+t+oim9mawQAId24/AlJ9UdZK949csPWxxl
LWvEa1iiduMTDuJ57fMeSV3ztlEKaSXBoJGE+UJ8fYnHX/MVIQ63aIxaN2hJt+Gr
23EnyzPiMvtahj+6vu4558c/b+aZcHUZrW/lOpNqVmsCRyWv8WftDTgK2KI6YGKD
wY2oWVW8QX3SQHltgSALbyiCNADRe0wsl79SXvbDTg5GYwLnkiUcvEklb634ZXR3
WFCbJD+VqTDYEAnnq31wju9JP/k5BKH97oO9YsJ5G2UbsCyI0Th1tdg51vEHr0uP
9oFh5I9s+HXoNs0pp82Z43xUT4tjkiGITsvQuW2pW0duT4B7LZAPkDKIhpXUArHV
y+JcK2dQbu6UpnuPWHyLQAKoiMv7zGmgiF6UJkGYMoP8cUbXmihgwAT7xs+h80NM
1t8pYeHnfBuj2EuFYfHv+ti6OYl27qz+ZJiPyhwOjbP/Jjr1k/Ec6vAKvM0836Nd
GEDgUz1BMYA7kJOsFoJelbLMYxXdY8Po1isGCilC1l8LQennz017rss9PyrXikgI
8rHyQqCcl44DmzWLHZyQm3R5rex8X8gXGxtruzqT21nNform8dZ8ExcfID/D9uHg
pMFMR/5cQN+qolm5ISBwgcKZWg9XyMz/TUkSogbMmCRm5JPRVXvl629AP/GmLgcG
wf73vzwtAPfzSC6twsw0
=fS7Y
-----END PGP SIGNATURE-----

--BCQW4u8rtOzpP30D--
