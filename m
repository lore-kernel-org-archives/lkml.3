Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752715Ab3IKMR7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 08:17:59 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:49528 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751831Ab3IKMR6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 08:17:58 -0400
Date: Wed, 11 Sep 2013 13:17:33 +0100
From: Mark Brown <broonie@kernel.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Matthias Kaehlcke <matthias.list@kaehlcke.net>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Message-ID: <20130911121733.GR29403@sirena.org.uk>
References: <1378009457.25863.3.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GsS1zwZ0euuFXuGH"
Content-Disposition: inline
In-Reply-To: <1378009457.25863.3.camel@phoenix>
X-Cookie: Your present plans will be successful.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: core: Refactor devm_regulator_get* APIs
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--GsS1zwZ0euuFXuGH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Sep 01, 2013 at 12:24:17PM +0800, Axel Lin wrote:
> The implementation of devm_regulator_get, devm_regulator_get_exclusive and
> devm_regulator_get_optional are almost the same.
> Introduce _devm_regulator_get helper function and refactor the code.

Applied, thanks.

--GsS1zwZ0euuFXuGH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSMF9aAAoJELSic+t+oim9vYUP/R++5zfA2a+llOUkstTWywQ0
srdS4ZYYlPaWm0MeWYZfWpBZ7GCHIEcxYD90X0Uy53Eomu20+Nvw3VyDu0KSdRfY
ya7cvuNYn/LBmoaWdDCTdsTKQ18OP2ZI0i9UgzNNQpPIGewVO86Gju8b7+uF0JjZ
AAkzPb1lTPdS7NxTdftH1DSa1xQMIxxtoYCZl7rIf/cyUGFXCtim4Iigwo+pBZAw
bQrmP94dLf5zwnPBnP/qoZKOgl/ljPnD4ouHlM0wQXjK4/OS2qph6aQM5wE/Y8Wp
Nj5LKQvnBmyP4IhSQvb7ymctvbT4zcN6fG4kPxgLFFpTK9apEEkd65talDumyX0A
vTPSPaNwTZ2wIS0qiwFwSRjVoK//Esj8RXgiXAOZOoO/tqUmcmMU/yChztn/KDhl
q9KwJowpTrlxU0fWoBfC3fYMEUxFQ3v0SZhDFDhEBbLnul54ZPEU6RvFlT5CT6S4
F4Yo8qwh/mlSLJE6E+Ynu/l8m0gXORtZMnPcndxR2zWyLVM18+HCeXKriiErI7a/
3jCTODT5YyUFbOaGH2T4ldwlIC/NxWkjLd8lZxsOI2i7C26R57tOEDctM05mGhL8
QasERhrC5KpQdOYqcx5PbtjFfDZZgpCjdb6z250ZWDHdYF/ZSWqb3AOWP0hBO5PU
Cm/K5xMKE1D3bSQ3BlbT
=H3Dc
-----END PGP SIGNATURE-----

--GsS1zwZ0euuFXuGH--
