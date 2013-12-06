Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759285Ab3LFO1O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 09:27:14 -0500
Received: from mail-bk0-f54.google.com ([209.85.214.54]:63339 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753282Ab3LFO1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 09:27:09 -0500
Date: Fri, 6 Dec 2013 15:26:05 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Stefan Agner <stefan@agner.ch>
Cc: swarren@wwwdotorg.org, dev@lynxeye.de, lee.jones@linaro.org,
        lgirdwood@gmail.com, broonie@kernel.org,
        kai.poggensee@avionic-design.de, sameo@linux.intel.com,
        linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 1/3] mfd: tps6586x: add version detection
Message-ID: <20131206142605.GA32363@ulmo.nvidia.com>
References: <cover.1386333697.git.stefan@agner.ch>
 <7812fb79beac0a6a409090f43d129893f9f93b5b.1386333697.git.stefan@agner.ch>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wac7ysb48OaltWcw"
Content-Disposition: inline
In-Reply-To: <7812fb79beac0a6a409090f43d129893f9f93b5b.1386333697.git.stefan@agner.ch>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wac7ysb48OaltWcw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 06, 2013 at 01:51:45PM +0100, Stefan Agner wrote:
> Use the VERSIONCRC to determine the exact device version. According to
> the datasheet this register can be used as device identifier. The
> identification is needed since some tps6586x regulators use a different
> voltage table.
>=20
> Signed-off-by: Stefan Agner <stefan@agner.ch>
> ---
> Changes since v4:
>   - Use variable named version instead of ret
>=20
> Changes since v2:
>   - Avoid moving devm_kzalloc
> ---
>  drivers/mfd/tps6586x.c       | 50 +++++++++++++++++++++++++++++++++++++-=
------
>  include/linux/mfd/tps6586x.h |  7 +++++++
>  2 files changed, 49 insertions(+), 8 deletions(-)

I think I also already gave my Reviewed-by on both this and 2/3, neither
of which changed significantly enough to warrant that to be dropped. In
general it's fine to keep Reviewed-by and Acked-by as long as you're
only changing minor things.

Thierry

--wac7ysb48OaltWcw
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSod59AAoJEN0jrNd/PrOhsEUQAKmjMP5uhsTLl3Esvqt19Hvp
wKUMBdy7whuA6Rqpxwj9UQxLZ/1AV6gixd+CLiBHDOHmiv2CyFe6T9T5iTzHguj6
0kqicTp0pGgzOZ/dj3shyqI9sttsAjBg1B8+oiU5Eo6twyIAMhHj7JOhdT1/AyI4
wwB+LanGw3zzjts2eoxbU+HmKH2BUGXRTiuZRAueSAAQ0LbdIUmxC66HCt8eAfMr
795bBZMWXMms2yYcaWBgdj/PvCSvbuDWDeX/lNsMUj7RWLcJ1bXEDDNKPWBKdKei
jf/VpQxpTSq/jRaMRj8Y8DHVgOioERCUYegFJXeP/OTAvUkV9Gje9nm2/slUWyiC
oaX3qV4nFLlnBYVC3A2RuX2mn1rXDXyvYFq7OLsR4BAlcWxiOCAJzWs4U7So5et6
dQKQcBQ2DKsbi+8fYoDtDAg4aM4RpIXx2vpBB+ZjU8FQGuB64jc8vocmL0SfO6r9
7ax2qWHqUIvOpXHa8AqB5PO4MNBxFoSGb+fdKDFObcB05Bsga+OENTR0bh/BriCG
XZAYmYAGsoqpBc/LWe2PnpPALjXKZsK0w5O5sF4FLgKo60/MB2GBQwy0Vs8xzGEk
n36jVcAkJaPL2yWfDuIydwDOF2aH2l2yk7Z+uIcH1wrId1plyKqkRE5CBDAecP4H
gJs2esY/3QskK1TO6C43
=4o3E
-----END PGP SIGNATURE-----

--wac7ysb48OaltWcw--
