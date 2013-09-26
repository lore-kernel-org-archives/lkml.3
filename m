Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753150Ab3IZOsQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 10:48:16 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:39418 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027Ab3IZOsK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 10:48:10 -0400
Date: Thu, 26 Sep 2013 15:47:43 +0100
From: Mark Brown <broonie@kernel.org>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: mturquette@linaro.org, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Message-ID: <20130926144743.GQ19304@sirena.org.uk>
References: <1380203295-11030-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OxDG9cJJSSQMUzGF"
Content-Disposition: inline
In-Reply-To: <1380203295-11030-1-git-send-email-ldewangan@nvidia.com>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] clk: wm831x: get rid of the implementation of remove
 function
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--OxDG9cJJSSQMUzGF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 26, 2013 at 07:18:15PM +0530, Laxman Dewangan wrote:
> The remove function implemented for platform driver's remove callback
> just return 0 as part of its implementation.
>=20
> Remove this APIs and do not pass the valid .remove for platform driver.

Yes, this should have been done when the driver was coverted to
devm_clk_register()

Acked-by: Mark Brown <broonie@linaro.org>

--OxDG9cJJSSQMUzGF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSREkMAAoJELSic+t+oim960IP/R1vBr+r27GxeWFh1PXpcM+u
zrSWuBwPHfew5q0JD+FQT8CeuGQLWN/yAS7cVORB6frohp+ZrrEpGobuDNv7Q9BJ
GM2VKRJnbI+jTSFpWLmYfw8L9cmh+7R7mQ1ythRfYSN1rQkvIXrQIwEo0E1F4BqG
+1p5CNpjbpIkOyv9UXT1bgBjlH7HmddkAAfg2juRW7uMzwa4DIe4aWpBYtiyC2DI
aVo6AY1UU1x4j2Gx1hew2zITaiZNQzejF/7mn7tMLFwpnkDKBzlhir3ioqmXrcf5
UxQTYAgn31/WgeL4ORUAZvoyTCa3ayyRC85WlEgqAotVm6wsQpDPSpwpLcN2Snyu
HLP9AMf1l9thz5Xs3W7JZXs+zdvXkxVccIyYyjRUM9VJPdjSz0AJHgi14Mq/man+
bIDtURgeElo9x5TTmrRQcBGMUXJZEDj1IN6CsHqq7vPinOU+eL30pCQYxFIGRg17
t+aiiUs0dKz1VFIE8n7Ynll+qjCqI+ZK2tXkFuxtP+mLk6hf4QOvaij/DdDAx1ym
Ycy6OCeg4vwi+xCVMojoHJtstVUeDSKEqTJq3tdU92xxEojzj0S1F1CIf2syKPFa
J0/27hJGeJ+1A5hY8ZH6363BEyFkH9JR699W8qPDvOMxnIfaZ4ZllV5K1nOmzpiq
gk5YUFY+Ir+Pd8BUfu9J
=jAkk
-----END PGP SIGNATURE-----

--OxDG9cJJSSQMUzGF--
