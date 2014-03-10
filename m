Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753197AbaCJJgg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 05:36:36 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:50110 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752983AbaCJJgf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 05:36:35 -0400
Date: Mon, 10 Mar 2014 09:36:29 +0000
From: Mark Brown <broonie@kernel.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Message-ID: <20140310093629.GK28112@sirena.org.uk>
References: <1394440371-29588-1-git-send-email-k.kozlowski@samsung.com>
 <1394440371-29588-7-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="s2LtGGIeHe+Td5YU"
Content-Disposition: inline
In-Reply-To: <1394440371-29588-7-git-send-email-k.kozlowski@samsung.com>
X-Cookie: Oh no, not again.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 7/8] regulator: max8952: Use managed regulator
 registration
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--s2LtGGIeHe+Td5YU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Mar 10, 2014 at 09:32:50AM +0100, Krzysztof Kozlowski wrote:
> Use managed devm_regulator_register to simplify the driver probe and
> driver remove functions. This allows removing from state container the
> pointer to regulator_dev returned on registering the regulator.

Applied, thanks.

--s2LtGGIeHe+Td5YU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTHYeZAAoJELSic+t+oim98tAP/iHUEcccB2Kj0iw/tG8wE8Q3
KAbN8afPnaxc0Y4T6QduDOGwBFtP0h9Owb0RRfx8HDrg6f3sIqi2zY3kpGuMRCbQ
QIen1mxICmVqCiSq5j9aM+O3DjQ0lrecHgk++kjivUnxS+MqZQ2gyrOJorZlbsHU
W5Z5B0+r9uqwKMz4gHFX+gnvTj+rtvnx33cmYW/ll4bozFAY9trrOyGF2+Pj0e+t
VUcvWbnI63n73j4zeZOm2Xb4MsgCE9pGbigeLF+jTV4jg9AAGtrtH2+b3eGjOJm8
nCDWwovy2vBMLJYfTp2vnUO/Fc1VYw8Ug6MMmIeBM5u7yktD81saVO2wl+4bGtko
oaZBCvnuBliUiuLaTkcOBUeyHQ6w4C0ykZEV/YpPOcBg166RHtQ9g1q9psZhq905
3/3HUNPHUF4ZWVYQYNrpJTVoukKr7JnCXn/qTitNTndRy0AL2Wdi+exnuxGd6HZ8
tNSFOW3WH5n77P4iDrR9lyouQhkiERUhCDahoiaOadMYhF3xnOvbjxhPe29A0NoE
zFPdmk02EawniFu9o06vhL0TvIJGr8hXHI0FBPH9l83RH0rGd3vn0y9chdmHGRjl
5xPQz44sd4V0A99NKT0wCM5mH42+Vtsb/YgNG99hTaA+vS226IccxDs9M1te6KUH
wCJEvpwelDbGdKJB/a+E
=slYc
-----END PGP SIGNATURE-----

--s2LtGGIeHe+Td5YU--
