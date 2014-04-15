Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754737AbaDOOaI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 10:30:08 -0400
Received: from top.free-electrons.com ([176.31.233.9]:41004 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751006AbaDOOaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 10:30:05 -0400
Date: Tue, 15 Apr 2014 16:26:26 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Chen-Yu Tsai <wens@csie.org>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Alexandre Courbot <gnurou@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>, linux-gpio@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com
Subject: Re: [PATCH 3/7] net: rfkill: gpio: use
 clk_prepare_enable/clk_disable_unprepare
Message-ID: <20140415142626.GE3207@lukather>
References: <1397544101-18135-1-git-send-email-wens@csie.org>
 <1397544101-18135-4-git-send-email-wens@csie.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SNIs70sCzqvszXB4"
Content-Disposition: inline
In-Reply-To: <1397544101-18135-4-git-send-email-wens@csie.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--SNIs70sCzqvszXB4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 15, 2014 at 02:41:37PM +0800, Chen-Yu Tsai wrote:
> rfkill-gpio calls clk_enable() without first calling clk_prepare(),
> resulting in a warning and no effect. Switch to clk_prepare_enable()
> and clk_disable_unprepare.
>=20
> Signed-off-by: Chen-Yu Tsai <wens@csie.org>

Acked-by: Maxime Ripard <maxime.ripard@free-electrons.com>

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--SNIs70sCzqvszXB4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJTTUGSAAoJEBx+YmzsjxAgltsP/25whL2Q+l/Vks71a1UiTrhM
7S8uB+SizMEbO6n0hhZIAOZnP1R+X/owngIBfoK+CDYrjLREszCNwgepClaxLvNk
mP8usqbhoUv+NNqhunB5ZAxgEwK8YEXIF2LT+R7gOTlkVJlJib0JXgIdS9wTkt3P
wB75DJqAhfc3KZFDMvL+Qri85tyYbk+U81NLwAcUVyXCMRcBgIwRrRZ696hjlDDx
sLl5LJy81LrvcxCmPPl8cG8ZgCaynpQ4WCWfeKB7KDbrYb6rym0oDVgZ14eqC0yP
lrn5zXiIK/hK7CuJEHSoLXY36pnS3Ib1PIRyAU/OdB3Rlq3h0So+PlcNBA62OLO+
TOnIi3Qetq3gLhJ2u6KcOOVJa8UbYHmpGLP6iZhvIImz58i1RpaPoKbQV76zyiyB
9Qx7nCOpazS8BjaVQsWo3JjBZGzK5nPVZzVhK4Fagy6rCQj5yv2yIHbsPpKuAU/V
ImmVsiWHMXbtlwH5hCDA3grNvXcmgzbt5th4bh8C5gg2TXLGJETTJ45OgO7ONTin
PwPtLeau5el9VzX03giXcgArMumnkB1UHZ0dTRErCtNIaRaoWeJQO4EOKksRcqtZ
KIBEkDaWJAV1hn7feM3KxJeSI6QjplROHwxWdLPo3OC6Vl3SyjHiJiOKd/xrjTKw
KzCpKQ2LpTh+GLkrJdVh
=p77M
-----END PGP SIGNATURE-----

--SNIs70sCzqvszXB4--
