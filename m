Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752171AbaEADcF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 23:32:05 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:53512 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750848AbaEADcC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 23:32:02 -0400
Date: Wed, 30 Apr 2014 20:31:41 -0700
From: Mark Brown <broonie@kernel.org>
To: Xia Kaixu <kaixu.xia@linaro.org>
Cc: linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        arnd@arndb.de, Liam Girdwood <lgirdwood@gmail.com>,
        Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Sangbeom Kim <sbkim73@samsung.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, alsa-devel@alsa-project.org
Message-ID: <20140501033141.GP3245@sirena.org.uk>
References: <1398770316-19715-1-git-send-email-kaixu.xia@linaro.org>
 <1398770316-19715-5-git-send-email-kaixu.xia@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CKf/2jVYos1l2hij"
Content-Disposition: inline
In-Reply-To: <1398770316-19715-5-git-send-email-kaixu.xia@linaro.org>
X-Cookie: Keep it short for pithy sake.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 12.104.145.3
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 04/15] ASoC: samsung-idma: avoid 64-bit division
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--CKf/2jVYos1l2hij
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 29, 2014 at 07:18:25PM +0800, Xia Kaixu wrote:
> From: Arnd Bergmann <arnd@arndb.de>
>=20
> dma_addr_t may be 64 bit wide, which causes a build failure
> when doing a division on it. Here it is safe to cast to an
> u32 type, which avoids the problem.

Applied, thanks.

--CKf/2jVYos1l2hij
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTYcAaAAoJELSic+t+oim9yfsP/2dC3/Wc0zGmJAL2sQRpvJHk
Fa9FP8Z/Kp8MtqH/TzdbQWDGlS47Xl+NrNQp5x5nmdZUwdQPOCV4g2phecJ9+mq5
//UQEFZhwcqMcKWJHY1fiTnpdCRIH59iAAVHP9lRssb0BlxkttLu2qXrIJDinAAd
QqufN9364FBf+36/Bk+6R6C5gYDRAWt0dXghmm2igSm0buoiCRiWUhuuFnzyibrr
lZoxbl2LSRDSnUoarniAiZYqX21pYrUJVKJ1nBcn65Nz0JRizR9ATdBmvxq/+oPY
SFDPCoXKa4V/pb5DYM4973O4OjSZxmJpJeCNRg/hekTkJ11UIcmPlMR8k5A3QR2h
ahnhPlHi6seyVoslwYym0V2nYt9eKTeuZmzBd1HDy774qjBS1udJwzCZQ5vTznQn
0JyRRWwSdj+apOOOgqVdFzDzAlRRzPBUsHG+zpOdrwgqVHP1Hq/Mqn+se52lmvA4
ZKtj1GwhDPpoWriXl592hZ90Ozqh1YCxQmmHzK50/8lQ+cYmbKaTzXcO9GlDFllR
tXbHj7lxglKo/bBUQemxB3IEdf4vtdLfE8ftAKUB/pTCMprXRGjuuHdTeJGD4NKw
i1pdenzuBMeH5i6dDkuVcfH0zFeP48rSDogKRAv5wC2SGidk/7ysYurtbrKtrFqm
xMPeiam5klK/UvhcknWk
=N28X
-----END PGP SIGNATURE-----

--CKf/2jVYos1l2hij--
