Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757475Ab3K0Q3s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 11:29:48 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:50322 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757441Ab3K0Q3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 11:29:45 -0500
Date: Wed, 27 Nov 2013 16:29:22 +0000
From: Mark Brown <broonie@kernel.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Message-ID: <20131127162922.GE14725@sirena.org.uk>
References: <1385521101.29941.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3qTVFk/EjXyDmsv5"
Content-Disposition: inline
In-Reply-To: <1385521101.29941.1.camel@phoenix>
X-Cookie: Your supervisor is thinking about you.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH RESEND] regulator: lp3971: Convert to
 devm_regulator_register
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3qTVFk/EjXyDmsv5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Nov 27, 2013 at 10:58:21AM +0800, Axel Lin wrote:

> This patch was sent on https://lkml.org/lkml/2013/11/13/34 .
> Although you replied applied, it still not in your tree.
> So here is a resend.

It's there.

--3qTVFk/EjXyDmsv5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSlh3fAAoJELSic+t+oim9k2kP/jymQIhcMWcSrduAdFTUnmj2
1mZPGEykAQ3UFJKHYnsc0nlGsc1RAl5BPowCtaswJ501ADZrwW4Wnu41sNdHWdzw
jQrukiaImGZMN1AwRe99GQdKQxByC9m3+QFP3hGCIYLSFoad33Dhf7WfcW1dancg
4F5pS/s5gfxgs0KFvp70kbJOsC41toqrWL4IQ+TNquPJxOrTyVg5fQELLlCGEq1g
hkBdCnCuQKGAHnvTk7gOb6NSQTz2TPnCIbFIbaSdBVcnFXFJitVa7DvMyturmfvh
JHjCCRCglFiz4JV6hEHg+amyHi0RE79n/7Igb97Q8SkqnUK5sQda7D1E5GGbaP28
+oRWkrRy9y3kbHsCNYGtbGKcfMqig/MItpyTOmbqJeo63I2lgxMAtk3/XWSoogRi
0BkSmtzaeY+44RI62iY/16mwpLvzcu61YNXIh/xygn6NUkHUCLvG76pSHM6+C7f0
Q0TYdBiYGuljTcFF7TlqEt+RBszA4qsPRLRL3aJ2go0S65Ag0azlAl1SpOHOcOce
YlcIHq1WCL7/wNhntTZVhu7Kgbf5QqzMhRZ5WzX823QvkQ8D6Rrsn8gFkIl+Q+8e
/+s1UWxUOYHplMh1a6SQJJptPuVWT+rWAQScW/aUK4+Xr4sArQecJskITT5qlNcA
ArOdpEpRjTdjOtcexDyO
=X9yK
-----END PGP SIGNATURE-----

--3qTVFk/EjXyDmsv5--
