Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752696Ab3FXP0V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 11:26:21 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:37076 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752641Ab3FXP0Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 11:26:16 -0400
Date: Mon, 24 Jun 2013 16:25:53 +0100
From: Mark Brown <broonie@kernel.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, grant.likely@linaro.org, rob@landley.net,
        patches@linaro.org
Message-ID: <20130624152553.GT27646@sirena.org.uk>
References: <1372066617-23518-1-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lbYR4+J2RcKO0WXU"
Content-Disposition: inline
In-Reply-To: <1372066617-23518-1-git-send-email-sachin.kamat@linaro.org>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/1] of/documentation: Update s5m8767-regulator bindings
 document
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--lbYR4+J2RcKO0WXU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 24, 2013 at 03:06:57PM +0530, Sachin Kamat wrote:
> s5m8767 regulator is used on Exynos platforms which use pin controller
> to configure GPIOs. Update the example accordingly.

This smells bad, why does a driver using GPIOs through the GPIO API see
a change in the binding?

--lbYR4+J2RcKO0WXU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRyGT+AAoJELSic+t+oim9fecP/RSkd5vTH7/QxKdP/Xngg9wX
1ljG4MLhQNrBrfryROS7KpWNNwWBqK8+UpTtLa+za0xk5P6i4tGUNrj5TOcrdADi
aEr5fEQKCLfNvKG9IYKFRpdn9i/aW/von/2yKx/r6qDIYlCWwbRHJj68T5xSyXB6
zc3fE9SHhMxxqEfTkyd0uRxoD2dTGvT2I605kBbGqZTvIAl1RHXf2GrRzfy20hHa
jyEXuy0bZ6DNK/yPchhsS3kpnsiuW1vhyIfqL8GSt3ltxbAxxDX8q6KEjU64VASr
IHco5GvKfRUQbToDS6CtIjzMWDOJ5A1Td9QTsFZIK4TxDA4ADHt4Zag+AUs5DA3t
KVAsWXcbSF5LL/96Cy7Ajd4QiZILXp3YQK13mTsMJ4QRUnenWM8VyPgTltE+OA9N
lknf2jyu5tJl1el8tcs1YvUtjqAmSm5WCn/V9+BAvFlwcshwmZOyWm4pkAC7Lebr
xwGEHa8f69Hk0aYnbMGiLNV9m1BHHdXpOj/e+TIUmY347eZaS4PY0BnyYwZVkEO7
Tg927x9SEXGVGMmfP7slV1//cUL1xz+rLng1gOzgGKLty0IDL1XkbdWbLV0yfO9b
y3+q2hbTHSAmBpnSU4LVen4382zvw49xx/XqtRub7ydpKM8JnIYqI7uW8keeh79v
Q+EhP6qsMzxk+W/ZyHK6
=rsb+
-----END PGP SIGNATURE-----

--lbYR4+J2RcKO0WXU--
