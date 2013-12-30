Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755734Ab3L3L72 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 06:59:28 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:51266 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755503Ab3L3L71 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 06:59:27 -0500
Date: Mon, 30 Dec 2013 11:59:02 +0000
From: Mark Brown <broonie@kernel.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Wenyou Yang <wenyou.yang@atmel.com>, Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org
Message-ID: <20131230115902.GK31886@sirena.org.uk>
References: <1387899682.11622.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RVLHdg3qhy1T2deX"
Content-Disposition: inline
In-Reply-To: <1387899682.11622.1.camel@phoenix>
X-Cookie: Go climb a gravity well!
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: act8865: Rmove unneeded
 regulator_unregister() calls
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--RVLHdg3qhy1T2deX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Dec 24, 2013 at 11:41:22PM +0800, Axel Lin wrote:
> This is not required because current code use devm_regulator_register() to
> register regulators.

Applied, thanks.

--RVLHdg3qhy1T2deX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSwWADAAoJELSic+t+oim9IzkP/3Iie0AjHcih3+DwScyaXERX
D4Mua+D4Vz3MJGOIDMbkOSN8InskOeFda1Qho8XsoKtdu2d2Mx9+Hq94ShxSl/br
6YFj/cNHHEJrNFU0PyA2qX/MdomGWvnSaQL1QryUqBpdsSjPIkobFVgqGZtaXEjF
Gnk1yteZPXUyHdYAGCMa5zvoEPqSDLQptB9wF7LIqQSfqP32iaNlXr34qPP5N1qP
iHN9Iro8MysP4P7dNJl6Ua+sJMhMBcXUZI5fcEfxsDJr8hi0R30MxDFtQEoZWzsz
qKVo5gFh7nvBfi0/2PEJW+2YC1DIXCu6+ZRAqZz96LKdndXunfXeEpWkAnA4r0xS
ZYt5N27J2ic56NGsdXXnJRkBJFAe9H0qv9qmVqoBdMs4nezIYizFH/gvisVChRjl
w74iE+hnhqrXIRw3TzdOKzLZskAF4EhuaMdbQli+2EXAb9jUwmK5+85n4Z+/H3Sf
GffZwDxbiiLLlr162w4u89d7yobBz7+0ChrU6cOCrsYYAHQhJlzOo8S267E6tVrE
aTJYFlHovzmPhRMWnBN7hrdNDHLRdfetfYGEWk/ZC0JsEFt5Is7U0JPONuAEvruT
4z9a8hvr+cAIvdPgUENiIEnuD3xkJqxOCf0sApfBBhF4TEzZe1isUS5gRLjSyvAE
ioVSL1iCILGkTR+FDJj9
=vRwI
-----END PGP SIGNATURE-----

--RVLHdg3qhy1T2deX--
