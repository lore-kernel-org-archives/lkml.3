Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751644AbaKYWck (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 17:32:40 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:38741 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751469AbaKYWcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 17:32:39 -0500
Date: Tue, 25 Nov 2014 22:30:33 +0000
From: Mark Brown <broonie@kernel.org>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Russell King <linux@arm.linux.org.uk>,
        Lars-Peter Clausen <lars@metafoo.de>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Message-ID: <20141125223033.GB7712@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Rk0iZ/hcy/ffkUgl"
Content-Disposition: inline
X-Cookie: Celebrity voices impersonated.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v3] ASoC: Remove 'const' from the device_node pointers
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Rk0iZ/hcy/ffkUgl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Nov 25, 2014 at 12:14:48PM +0100, Jean-Francois Moine wrote:
> As Russell King's explained it, there should not be pointers to
> struct device_node:

OK, found a user that needs this so applying now.  Please do try to make
your changelogs clearer about why things are being done, it's often hard
to figure things out which slows everything down.

--Rk0iZ/hcy/ffkUgl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUdQMIAAoJECTWi3JdVIfQNMMIAIRgbJ15GllUxbX/oRsey/Z9
WJW18LkmYh4Zd9yq5StSvYXSR+JdXVxek56u/FP2WZRcxnAycAzu8RkS1dtuUqrs
iIsNnfk0IeZuIa8rs8URgcFZKI4ryGpCWmG6fshaHnbeEBaGuBhabHB2zrXDMp5T
WJhT8ySfNRFpWVcMd3dGu9i6EN7JsFAKDKazBUCMw/wtvZnqJaLhWWHOwODA1dbl
sBcfUBuc01AdYNyGKMNBnhgwHQav0MomrDRMeIKqjlzL6BD4Ul1FrQuieVJHbRSO
7ddl9rqnmHpLGBgeNuvlltf4JH4i2zqxDu1XRingStG+acoYsow75DwoHG7cnrY=
=tsIg
-----END PGP SIGNATURE-----

--Rk0iZ/hcy/ffkUgl--
