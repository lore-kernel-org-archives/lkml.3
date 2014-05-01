Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752521AbaEABao (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 21:30:44 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:53412 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834AbaEABal (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 21:30:41 -0400
Date: Wed, 30 Apr 2014 18:30:06 -0700
From: Mark Brown <broonie@kernel.org>
To: Xia Kaixu <kaixu.xia@linaro.org>
Cc: linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        arnd@arndb.de, Liam Girdwood <lrg@slimlogic.co.uk>,
        Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Sangbeom Kim <sbkim73@samsung.com>,
        Lars-Peter Clausen <lars@metafoo.de>, Timur Tabi <timur@tabi.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-input@vger.kernel.org,
        alsa-devel@alsa-project.org
Message-ID: <20140501013006.GJ3245@sirena.org.uk>
References: <1398770316-19715-1-git-send-email-kaixu.xia@linaro.org>
 <1398770316-19715-2-git-send-email-kaixu.xia@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZG+WKzXzVby2T9Ro"
Content-Disposition: inline
In-Reply-To: <1398770316-19715-2-git-send-email-kaixu.xia@linaro.org>
X-Cookie: Keep it short for pithy sake.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 12.104.145.3
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 01/15] ASoC: CS42L51 and WM8962 codecs depend on INPUT
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ZG+WKzXzVby2T9Ro
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 29, 2014 at 07:18:22PM +0800, Xia Kaixu wrote:
> From: Arnd Bergmann <arnd@arndb.de>
>=20
> Building ARM randconfig got into a situation where CONFIG_INPUT
> is turned off and SND_SOC_ALL_CODECS is turned on, which failed
> for two codecs trying to use the input subsystem. Some other=20

Applied, but...

> Cc: Mark Brown <broonie@kernel.org>
> Cc: Liam Girdwood <lrg@slimlogic.co.uk>
> Cc: Ben Dooks <ben-linux@fluff.org>
> Cc: Kukjin Kim <kgene.kim@samsung.com>
> Cc: Sangbeom Kim <sbkim73@samsung.com>
> Cc: Lars-Peter Clausen <lars@metafoo.de>
> Cc: Timur Tabi <timur@tabi.org>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-samsung-soc@vger.kernel.org
> Cc: linux-input@vger.kernel.org
> Cc: alsa-devel@alsa-project.org

=2E..please don't include noise like this in patch submissions, especially
with such long lists (which still manage to miss the driver maintainers
concerned).

--ZG+WKzXzVby2T9Ro
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTYaObAAoJELSic+t+oim9Ti8P/i/b7F8wQ6kejlOzNt3cByTY
Pravalwg7r1A0jQ/4Y6x33K1fzV/uZ0zVncUtyhybjXF0ZKklfUP4ZVvTHVrU/o4
u7QkehQfge3cgSa1hBrq+w+jsY6PHtlQeiJ4rAUdkWpdgkG4/PWcdHovt6QqbQrW
qrwhBp+7JHKICThHiyUjbahTBQHtHb9OSjBm6eJWqqKqUfbAc0TBhu+aWdLj3vQL
lCXRr7kdtthq2G8lgbOemEnPDhWlgernUn71k3iKEl2OnRfDNNDe92jxu2HN+6Pk
a1hgL3pGkhCY4auKxD3eg+jfAVW4OtNDQHgIEk8jj3+/j1Dn98CanxWtMAirlfmt
fQbuBNU88so8bJ47lWwZ3Ydb2GVdkmMhFc/K4Sum5sbqG3f6jik5Bogh+IbTg5UQ
RSVqrHyWZcDG9ltrsi0xg8Mj7DNGEA4t0Q2Df3ryzVvUVIBtoaJ9xt0JiVtRCCs/
5O3zy/6iCq/YI2ed+eYMv3DwNGsdEOcOC46QFEFWlJcj20i82zmjTfMm726NNEEw
oBiVZ6haNv1Iorq4rLIxfpH5SF5hEXpLyWJ/abF/lFjzBanE8Co9arNIvDh/x2Nx
OpSgmcZHaiDhkJZwVNk/yH3FfUS5yXt32IL/UDiL2XQNxFErk6k1RkUJMhNAS8jx
GNuq8VV8/l0enRFOuiPE
=tZkN
-----END PGP SIGNATURE-----

--ZG+WKzXzVby2T9Ro--
