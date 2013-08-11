Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754740Ab3HKSH1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Aug 2013 14:07:27 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:53384 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754331Ab3HKSHY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Aug 2013 14:07:24 -0400
Date: Sun, 11 Aug 2013 19:06:48 +0100
From: Mark Brown <broonie@kernel.org>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: Eric Miao <eric.y.miao@gmail.com>, kernel-janitors@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, linux-arm-kernel@lists.infradead.org,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Message-ID: <20130811180648.GA11327@sirena.org.uk>
References: <1376239917-15594-1-git-send-email-Julia.Lawall@lip6.fr>
 <1376239917-15594-2-git-send-email-Julia.Lawall@lip6.fr>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PNTmBPCT7hxwcZjr"
Content-Disposition: inline
In-Reply-To: <1376239917-15594-2-git-send-email-Julia.Lawall@lip6.fr>
X-Cookie: There is a 20% chance of tomorrow.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/16] sound/soc/pxa/mioa701_wm9713.c: Avoid using
 ARRAY_AND_SIZE(e) as a function argument
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--PNTmBPCT7hxwcZjr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Aug 11, 2013 at 06:51:42PM +0200, Julia Lawall wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
>=20
> Replace ARRAY_AND_SIZE(e) in function argument position to avoid hiding t=
he
> arity of the called function.

Applied, thanks.

--PNTmBPCT7hxwcZjr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJSB9K1AAoJELSic+t+oim9cVkQAI35kkM/JfHY2JsYDv+7wdiT
evmDTrMnHjTYs//jsFWdJhTxjFm1hTNA33R9kQDlUWKX0mMqAziaDdFSzSglry6Z
IWneLx+chfjs0VkZiMb1cIIaBTDQl82g6vnvaFLVTA+n1wbZQ8uunt42O8MLS+Kz
mPXHN/PrN0sPbPzZHrnKQh201dpbHs77/qEEymDHbiy19k46J7EPnUq6Y2O1Lf+A
lJyv4S4qbrSyr/4GDmxCvhCPBrPaAa5zIOQh1pxkckPYc1SB2+cqlrXLuv0jV6Q+
O5O5z4dqEWFggima9+74DY0iYcv+wJgtTX0CeTA5zEtxB/ET6YiNCn0J4Chzqf82
rVtjbH5YCmOXDqO1WTQo7gC08xK7r3OJPfZqI5+lEvkwlahVVZY/NPrAilCZMmj+
Mld4BT1IwsQoyWDaiWF9bS46j1bDko30tFOQ9T23AjMvWFKh0ap0p+5MxVixzJk1
5b0NFgitgKYTYKKDkOE3QQXo47p0EMCKT+kM+2H05gYrRsiCK+QS+Etr8/HnDBuv
AAKasq7xsUOkDvwXP/gTaplhDfFyUSizw2mWgucz5yT2j08ymAtOuRhLsWi457dJ
y16x9nhB0Rd+eaNiF03TxOHVWF7BWchujBF6aWzjnBIektpMMiqz3qqma12/KI2d
gyA6Ljl5n7wo/KE2T+LA
=aixY
-----END PGP SIGNATURE-----

--PNTmBPCT7hxwcZjr--
