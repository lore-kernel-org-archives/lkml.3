Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753483AbaBOKKY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Feb 2014 05:10:24 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:60714 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753413AbaBOKKV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Feb 2014 05:10:21 -0500
Date: Fri, 14 Feb 2014 20:57:43 +0000
From: Mark Brown <broonie@kernel.org>
To: Laszlo Papp <lpapp@kde.org>
Cc: Lee Jones <lee.jones@linaro.org>, Linus Walleij <linus.walleij@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Jean Delvare <jdelvare@suse.de>, Guenter Roeck <linux@roeck-us.net>
Message-ID: <20140214205743.GV4451@sirena.org.uk>
References: <1392177760-17959-1-git-send-email-lpapp@kde.org>
 <20140212175018.GJ28112@sirena.org.uk>
 <CAOMwXhNd69KMDcBLjfiw16T3bWWki-Dvxbz+zhgNe6OESnVaSw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0TE6JTYfnDoP1Y15"
Content-Disposition: inline
In-Reply-To: <CAOMwXhNd69KMDcBLjfiw16T3bWWki-Dvxbz+zhgNe6OESnVaSw@mail.gmail.com>
X-Cookie: Your lucky color has faded.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 175.45.49.105
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v6] mfd: MAX6650/6651 support
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0TE6JTYfnDoP1Y15
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Feb 14, 2014 at 09:02:20AM +0000, Laszlo Papp wrote:
> On Wed, Feb 12, 2014 at 5:50 PM, Mark Brown <broonie@kernel.org> wrote:
> > On Wed, Feb 12, 2014 at 04:02:40AM +0000, Laszlo Papp wrote:

> >> +const struct regmap_config max665x_regmap_config = {
> >> +     .reg_bits = 5,
> >> +};

> > This would normally be static too, and I'd *really* expect to see a
> > val_bits set here.  I'm a bit surprised this works without one.

> Makes sense, thanks. Shall I also set the .max_register or any other
> mandatory variables in here?

It's better to set max_register since that makes the debug features of
the regmap API more useful but it's not required, only reg_bits and
val_bits are absolutely required.  In general the more complete the
description of the register map in the driver the better.

--0TE6JTYfnDoP1Y15
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS/oNEAAoJELSic+t+oim9+n4QAI3SFYvhvZL9vRQBY4t3vT3h
i67xXFIFNPfT+NIlnW1Z3MaXp/yufLCtNsSoF8vbVatNw9DbL8FfqQ/RmRCqmzbW
ceXTnnKV5SLnXIEFqM57Cit9FxzahDQlLBnGeOnxxGjymH6mTJgqbPF3GqdCgAE9
E800l1AgXs/vi6fw0ZzyJyFzR+jLFdEd7HE/mQIvrG+aIV3U0hXCc6a9fvgUdam7
ElF9ZnyDizQ1qNLpKFB/uDdA1Oi7LOktfqzqHyiAqsi6IGrjYfocxp2h+7NeWJr2
2CBF5TuGycXb1Bxj8LBs2Ps+q3/aQhSTfjRVbzzecBKERbbCnw3jENOTaaqbT/zS
yJyknrU9xpSeGx4em4xdFO1NMLJQ93mQoNvUBwenyY1Px/btPx+mSVA7w/uTDskg
DHJfzH65VnTcRWEXcDQ8+CAw45gSHm/WR+CKWsaxkyjOMVUX8syn666zuc6UmYjg
hroVpYD6n9jhmj+Do7N8yoYHJ/ASA3ToPc9hQBlrmZ4VcyVyqv1LfrDuRJdw0hj5
VcloaX4w0nHAgqqHwUer0GNN7HIoMcWrfO6jIkLYKpqHxY0YvzS/WVJwwlclxGNX
uq9w7/S0hV9ZeHfnQB8Dr/7yyg8Kzc6r702Nb4BmdllSZsyxrcsQAy+3gkln30b0
8hv3xZXjWuJoNbMUs2VT
=5czf
-----END PGP SIGNATURE-----

--0TE6JTYfnDoP1Y15--
