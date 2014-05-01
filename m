Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752062AbaEAUa0 (ORCPT <rfc822;list-kernel77@spinics.net>);
	Thu, 1 May 2014 16:30:26 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:54504 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751481AbaEAUaY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 16:30:24 -0400
Date: Thu, 1 May 2014 13:29:32 -0700
From: Mark Brown <broonie@kernel.org>
To: Xia Kaixu <kaixu.xia@linaro.org>
Cc: linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        arnd@arndb.de, Liam Girdwood <lgirdwood@gmail.com>,
        Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Sangbeom Kim <sbkim73@samsung.com>, alsa-devel@alsa-project.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Message-ID: <20140501202932.GC3245@sirena.org.uk>
References: <1398770316-19715-1-git-send-email-kaixu.xia@linaro.org>
 <1398770316-19715-11-git-send-email-kaixu.xia@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0f/6N2HXQdCYc9N1"
Content-Disposition: inline
In-Reply-To: <1398770316-19715-11-git-send-email-kaixu.xia@linaro.org>
X-Cookie: Keep it short for pithy sake.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 209.133.115.210
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 10/15] ASoC: TLV320AIC23 and Simtec Hermes audio
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0f/6N2HXQdCYc9N1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 29, 2014 at 07:18:31PM +0800, Xia Kaixu wrote:
> From: Arnd Bergmann <arnd@arndb.de>
>=20
> This codec requires I2C to be enabled, so any other option
> that selects it should also depend on I2C.

Applied, thanks.  Please try to use meaningful subject lines.

--0f/6N2HXQdCYc9N1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTYq6jAAoJELSic+t+oim9AP8P/2jO3pzX1SgV/Q5Wd9wINa7H
rDf3Y2z3LhjoKBre5buUaB2H3h1JMmz43ZQfFoufe0lATkDGd7SK8DJMgj9xoFOS
j/P9tVZUOJc4s9SZhhy08VBL1uPDJ0rFJZMjCw2e2Z2HBM1j9YzhiWS8hb2cpFaE
WQ9ooHWBBZzKJ/qdx7/6WRhpooJe7eWu4uG3i1JygCFxbgYeNOxBs1iXgxMSWvlR
BLy9xw36YHiKbZ4cE1tXo0kbLYmG5UIY5K2vXRgA+g2lB/rYqUFV01GhiEM5EAbB
QHRd6W0PCjgDllohrqRfdYruSOxc84OdneGUMx4CwRxvmdfHBv5ryFp6u/KQoWPE
s50+HwqCnOT4S/MUhDiy8Tkd3g4nTPkmBGLj4XbFgvyKvkJbuiTLA/5zWJRcEtyv
OAP2jRI4JOY9jOQmQ1Vb4zth6eN0DzUxx+0SbrnlEY33VgkePxVaWgiIn00R1NON
4nJoJ/7dFzG6J7J8TploFMYHBL29UjLuwlrdOcVsK250vDYKHScV+MZs94Yw9Feq
km0Tdb8ATMgMECxZZarUfV8bgq7OKcT9EdL7LMkJAVEoMxhYcL98vHaPkQ8MdWul
lXkvqRZ7LaxPHr7tr/9dNTHY9jlxFjAo2xWzVBJmDBYNXnfD7fYvUXWBNnp08vc7
YyNxBzOZpMwA3VjH+Ubg
=Xri+
-----END PGP SIGNATURE-----

--0f/6N2HXQdCYc9N1--
