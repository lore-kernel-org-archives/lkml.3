Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751823AbaEASoo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 14:44:44 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:54243 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806AbaEASol (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 14:44:41 -0400
Date: Thu, 1 May 2014 10:59:58 -0700
From: Mark Brown <broonie@kernel.org>
To: Xia Kaixu <kaixu.xia@linaro.org>
Cc: linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        arnd@arndb.de, Liam Girdwood <lgirdwood@gmail.com>,
        Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Sangbeom Kim <sbkim73@samsung.com>, alsa-devel@alsa-project.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Message-ID: <20140501175958.GM3245@sirena.org.uk>
References: <1398770316-19715-1-git-send-email-kaixu.xia@linaro.org>
 <1398770316-19715-8-git-send-email-kaixu.xia@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qwymS7QpGZeA8tRa"
Content-Disposition: inline
In-Reply-To: <1398770316-19715-8-git-send-email-kaixu.xia@linaro.org>
X-Cookie: Keep it short for pithy sake.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 209.133.115.210
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 07/15] ASoC: UDA1380 needs I2C
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qwymS7QpGZeA8tRa
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 29, 2014 at 07:18:28PM +0800, Xia Kaixu wrote:
> From: Arnd Bergmann <arnd@arndb.de>
>=20
> The UDA1380 driver needs I2C to be enabled, so=20
> SND_SOC_SAMSUNG_H1940_UDA1380 and=20
> SND_SOC_SAMSUNG_RX1950_UDA1380 also=20
> require this.

Applied, thanks.

--qwymS7QpGZeA8tRa
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTYoubAAoJELSic+t+oim9SKkP/i/mW3krmQuLRPbiLtWFQv7/
S7fHSiJuHsocoXF0JGHYqb6lSdbPKMKOu2VqNWpRzDmMNIhGG+fg/rTif55SKqBU
SjMkSwMo+y+1tpvVz3iFMYmeRBIns1TjUhp5NnkvvzZI5ZFnl9UxKDa4B7wAg1Uk
kbkQEyGrSwHQ+ShJFYjhbsFks4zLCgerKZeeaocpsd2LueODQktXp3b70uK1q48h
oVzRdwzuZ4vxkSwZ0z3CP9lrXI85RLlMBtUCgo+fqUiBNKGJ4fjJGKIoYX9gs1xM
PTKDcccvTVupZhxELksc3VJus5kxh2sF/4UGoF5wuRh/Hco5DgDoAr3MpkcLLpKd
Mz8Typog3lClUrHtc2baxYmT5SAbjvExb+Ayf8Bz/SL0fuqYtH9C9TDptu+qPyVY
en3dFu8ojbtiMZDp1INUhCjFGov+DIlAAyZG4XBUws8hawGq9rmv0ycfzwbmur3I
tqlI8HoZI5E1GvJOaTL5y47QO/TUWxHzEJTQv5rN9dD6+rTaW5Dy3KzD6zd2xbzN
c5egL/dgRl0q0F/hhRqR9jlTF6yEjFnKJlSSJwkdRcEyZHLRiPB+OQczlaXI75L2
E0XuaVLJcy/SUYZQpwkRbVSX3N4KWyk8asxA8HXTmDVm1fTNj3LhfDj3mmcunbpg
aEZChTMJ9OKWIuaWC673
=OOS1
-----END PGP SIGNATURE-----

--qwymS7QpGZeA8tRa--
