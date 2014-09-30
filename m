Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752111AbaI3Mpj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 08:45:39 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:54572 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752049AbaI3Mpi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 08:45:38 -0400
Date: Tue, 30 Sep 2014 13:45:22 +0100
From: Mark Brown <broonie@kernel.org>
To: James Ban <james.ban.opensource@diasemi.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>,
        Support Opensource <support.opensource@diasemi.com>,
        LKML <linux-kernel@vger.kernel.org>,
        David Dajun Chen <david.chen@diasemi.com>
Message-ID: <20140930124522.GE4273@sirena.org.uk>
References: <201409300310.s8U3AUfe031634@krsrvapps-01.diasemi.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="a+b56+3nqLzpiR9O"
Content-Disposition: inline
In-Reply-To: <201409300310.s8U3AUfe031634@krsrvapps-01.diasemi.com>
X-Cookie: So you're back... about time...
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH V1] regulator: DA9211 : Fix a bug in update of mask bit
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--a+b56+3nqLzpiR9O
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Sep 29, 2014 at 04:59:20PM +0900, James Ban wrote:
> This is a patch for fixing a bug about mask bit operation.

Applied, but please try to make sure that your changelogs are more
descriptive - what is the bug?  Please also use subject lines matching
the style for the subsystem.

--a+b56+3nqLzpiR9O
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUKqXhAAoJECTWi3JdVIfQV5kH/RLv+gMNGS0+FlTKThY2lLSZ
7tjkVX5VSuDVwZYVictVXjQ/NA5GnO18zPLESv5+uhSy8/XMz1+Fmy8Qrfp1+h+l
8OvfJVWlrvuu/fpY+LUKfIc7ReZ1gGsgcrXvcaLx9VvefEbpNJtoIIAZ11q2nZNC
U7IWl1kHTVcMvb9I2T1bEHzvj146SoA9IJohDkMf8pXIAZWJPifKy1ORgZXoZv6o
f48Yv9FPeZ0BrXYaZ4s6SYw/+m0d2OTQhGN0V1HrXhxPUZZhaNMiDu9GM8Qgoq27
tYd2a5ZZoLkI2t0FrXxVop0y4NDOTLac9qeh9nRwP7f3FS5XA0eKUFh88nZ6sNU=
=dVRO
-----END PGP SIGNATURE-----

--a+b56+3nqLzpiR9O--
