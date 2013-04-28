Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755855Ab3D1BLp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Apr 2013 21:11:45 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:51923 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754773Ab3D1BLo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Apr 2013 21:11:44 -0400
Date: Sun, 28 Apr 2013 02:11:34 +0100
From: Mark Brown <broonie@kernel.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Robert Jarzmik <robert.jarzmik@free.fr>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Sangbeom Kim <sbkim73@samsung.com>, Cyril Chemparathy <cyril@ti.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Message-ID: <20130428011134.GC20197@sirena.org.uk>
References: <1367042288.7402.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="m51xatjYGsM+13rf"
Content-Disposition: inline
In-Reply-To: <1367042288.7402.1.camel@phoenix>
X-Cookie: You love peace.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 82.42.102.178
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: Remove NULL test before calling
 regulator_unregister()
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--m51xatjYGsM+13rf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Apr 27, 2013 at 01:58:08PM +0800, Axel Lin wrote:
> It's safe to call regulator_unregister() with NULL, thus remove the NULL test
> before regulator_unregister() calls.

Applied, thanks.

--m51xatjYGsM+13rf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRfHdCAAoJELSic+t+oim9Nb4P+wSW17sx8y7JtEdF3gLep0MQ
xmXTp5SurGze9hQpaHt9gCyCLxzBMVfWxtdotE6/FrSXNSndPbuoaEfTJH8cyvn6
Z+bZ+UrQY1q6JtJ5ydw8Rw3q0feio/J7xNZVRSVTplWdKFV0odpQkl+yzjj1iRgx
MEsmVoEbzUmWpSeEDZmb/v0kSKcJq7akZrsT4ZkefEKdzE5rX+lqWtrYjGnBsrEF
uYNF/jIXdKpwMUgdIR+RHBAbhUX/a3g8T+3482IZ3bpSxaN4Ld7ibDgqjZVvfMX3
vWvUi8uYsFGCETnysUNRR09V6YrKt/QCCTayX3HtC/uF1QaLtFXip6suhgyke3RK
tD+4n4fEPvagZHtXyZcN4qxfdN/lxgwYCkV0I0aJqsAlkMNVNLtNjdLUreeE1OLo
iqxM3QBOEVWsU2fKcYlbaqrtPAa/lI/EoJixZXEHH6KqMmHmnW6waQgPkpPmZUJn
KuGQ4sLgAgRpUDw2ImaEYQU9yyYTgLJhMCn9Bi45gcqGGN/2Su+l+5uk1XyCh4am
65DZ0VRb2iiiWo0DZE4Vs+M9a9+x6rQQ4qyGf2lg2Uo8g7UgltsBydtR+4AjNkuD
4LDefbNC8tVxbwubV7A4DwIG+mAkEqk+EBsY2dlJ+Yv5gRzuSfvGvOMtU+hkfq7g
1U23I9V6FLsifjfv0ky+
=XMXc
-----END PGP SIGNATURE-----

--m51xatjYGsM+13rf--
