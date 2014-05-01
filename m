Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751963AbaEADaK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 23:30:10 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:53489 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750848AbaEADaJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 23:30:09 -0400
Date: Wed, 30 Apr 2014 20:29:56 -0700
From: Mark Brown <broonie@kernel.org>
To: Xia Kaixu <kaixu.xia@linaro.org>
Cc: linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        arnd@arndb.de, Liam Girdwood <lgirdwood@gmail.com>,
        alsa-devel@alsa-project.org
Message-ID: <20140501032956.GN3245@sirena.org.uk>
References: <1398770316-19715-1-git-send-email-kaixu.xia@linaro.org>
 <1398770316-19715-3-git-send-email-kaixu.xia@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8MZM6zh5Bb05FW+3"
Content-Disposition: inline
In-Reply-To: <1398770316-19715-3-git-send-email-kaixu.xia@linaro.org>
X-Cookie: Keep it short for pithy sake.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 12.104.145.3
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 02/15] ASoC: davinci: add dependencies for
 SND_SOC_TLV320AIC3X
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--8MZM6zh5Bb05FW+3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 29, 2014 at 07:18:23PM +0800, Xia Kaixu wrote:
> From: Arnd Bergmann <arnd@arndb.de>
>=20
> This codec requires I2C to be enabled, so any other option
> that selects it should also depend on I2C.

Applied, thanks.

--8MZM6zh5Bb05FW+3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTYb+wAAoJELSic+t+oim9CVcP/2A7fEDGGCLEgXtA75X9gcXO
+wg/OLnEZ+EPIBB6/Z+8u7t//fHKRg4sBljiR3FiYJSZqniDXAWxQFp4cbq5te1r
6P3GxCP4AuNcf6A+4DMrjm27W6ExXeJODEijeqi+wEu4IA+TPvVskvPWDKvNZrzu
Rl3qWItfEQSkvsN+/qfDxBJxA0YriFIGAX/Mvm5X01AunElcXhv3me/up3KRemeX
TARcjU4YL/fm5wVNhs2YlgGENRFdX21OBk635/Ylx3s0nqqUhRrk6h5ALC70GpjM
HEuo9+SZu+BcrDfoRfDUBjgAxz0m+2jWJYBsblflvwE7ocMztyJUxgePpCnH1b7w
ZTZca2/ch5yrazskXmfHn2rrtB4oUbTglTQcW+zJPIOHM/MgyQQJaqJ9oeVEdHiw
01tudrqMagBp+OxQ7ne4Pz7gvaYqPZziFD48JbNz869XrNf4e+2QUrluHjeS54U4
tU3kMr0a29tBwK7K5yTjExeTjaM7RG1ZWE/SZ9zElR98SYcizW2uwbvzWFax4JP1
4D9wvfjfybYvneHO6Ly8dYquzeHSb2jduwbGLgMXd9ygxEWEClTOjSgAZnBJnBZ/
c4/yod/1L2KzBmcJ+OYd683EfzA3ZDspNPFuBrU2H8ZlYa78opwgXns3PpHALoCH
1r4E82WI8IkmsRwcvSBN
=u3fq
-----END PGP SIGNATURE-----

--8MZM6zh5Bb05FW+3--
