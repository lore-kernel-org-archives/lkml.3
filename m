Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754867AbaDOOaL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 10:30:11 -0400
Received: from top.free-electrons.com ([176.31.233.9]:41013 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751116AbaDOOaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 10:30:05 -0400
Date: Tue, 15 Apr 2014 16:27:00 +0200
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
Subject: Re: [PATCH 4/7] net: rfkill: gpio: fix reversed clock enable state
Message-ID: <20140415142700.GF3207@lukather>
References: <1397544101-18135-1-git-send-email-wens@csie.org>
 <1397544101-18135-5-git-send-email-wens@csie.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2FkSFaIQeDFoAt0B"
Content-Disposition: inline
In-Reply-To: <1397544101-18135-5-git-send-email-wens@csie.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2FkSFaIQeDFoAt0B
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 15, 2014 at 02:41:38PM +0800, Chen-Yu Tsai wrote:
> rfkill-gpio has clk_enabled =3D blocked, which is true when rfkill
> blocks the device. This results in calling clock enable/disable at
> the wrong time. Reversing the value fixes this.
>=20
> Signed-off-by: Chen-Yu Tsai <wens@csie.org>

Acked-by: Maxime Ripard <maxime.ripard@free-electrons.com>

Thanks!
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--2FkSFaIQeDFoAt0B
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIbBAEBAgAGBQJTTUG0AAoJEBx+YmzsjxAg6CEP93OnZUrmCgxusnW1kCg8OUN3
OJXIJEg+vKvI3AkFuKDN5l5CVmWngT1TnaRj4TvPOza1YaL+TorEIKIxZUEhj+QV
AP1ViZW+xUJhC6Ky6dYKp3UI7s3xh28Vev6tuPI+G26B+FfAwTp0nVmujXyBT0cD
CL3CgLCCS5SBBaZonIIL9roHdhBoZJUseFyXNSCmYDBnp0keMxpz3CBs5WnFaE0o
3vE+KUWoYy90WzbxiZjxaqxAiHOHL2gkev0XQFusvr31ZeZ15KkdZILfo9YXVhTT
/u0XkQXh1D16QKZWnoW072pNwZSm/XezbSLUp+XJRVETa3X6PI7GNyhba0U7i8J6
Q0gqZAUC2chIRBzcR0P9rYqAQztDjxFRwSJIiYB+z470Igw0t3VSFg4VQY3NKpP0
g1XIM320KquxHsDxY0jNw7ITTxYDIEzj+mbJYPgvO4coommUbuTfVInp/+a6jlXi
byiALmU4Ol8qv9vhU7FTaeQiC/TbVcwp8PF4rKGojb1CRg10vTDDFbZNkUCrZcSI
noZSGdzKgOymtUN/SQFnA83m19lAUJkjJnVfZ32JGCNq97oBiL9DmGDSHpCnhsl7
4eA9srwBuZmbS9cTJTCoMhKUpUq6DXI8yZ487jikrmtZTSrUD1reC27PK9heh/rE
DhFHwxwBAR3+gTbpBdU=
=7eiL
-----END PGP SIGNATURE-----

--2FkSFaIQeDFoAt0B--
