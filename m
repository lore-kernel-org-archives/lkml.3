Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753376Ab3AXKAz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 05:00:55 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56865 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753233Ab3AXKAl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 05:00:41 -0500
Date: Thu, 24 Jan 2013 18:00:34 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@ingics.com>
Cc: AnilKumar Ch <anilkumar@ti.com>, Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] regulator: tps65217: Fix using wrong dev argument
 for calling of_regulator_match
Message-ID: <20130124100002.GD4955@opensource.wolfsonmicro.com>
References: <1358994450.20257.1.camel@phoenix>
 <20130124045246.GA4955@opensource.wolfsonmicro.com>
 <CAFRkauDdbYH2jm_TXypjhe0rWyEOpS-JqZ1G4-WZmFKFJngbkw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lc9FT7cWel8HagAv"
Content-Disposition: inline
In-Reply-To: <CAFRkauDdbYH2jm_TXypjhe0rWyEOpS-JqZ1G4-WZmFKFJngbkw@mail.gmail.com>
X-Cookie: Tomorrow, you can be anywhere.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--lc9FT7cWel8HagAv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 24, 2013 at 04:22:59PM +0800, Axel Lin wrote:

> This patch does not change "node" argument ( the second parameter of
> of_regulator_match()), so it should not break the OF bindings.

Ugh, right - the argument is just confusingly named when the context is
missing.  No problem.

--lc9FT7cWel8HagAv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRAQYuAAoJELSic+t+oim9dFcP/ixixIbOw/c1jpXDc2u5zWG8
OMZV50y2P8aWR788uB4ZY69Xp0a6gpy3zAnjEguO+FMvWxyoXVV/V5UAbuxHrGUO
7k1Y+4n01MoRC5EIr3jy1MXtQ6mNWZOgIyy4v0aqXYLMDgEQQT/tpT+18qV5LzXZ
ZhQ5HdfKyfwaVApbAccFnS+m1KjxQqJBRWQot4QjEzj1h+QwA+mqh0sPl5IiXJ++
29MambetJ4x4SllPKzC/4EX8ulM7vceKC7SUa01yHhM2dqDGnRdig8ut33wyIMVW
imbszuqWBBdQXLr7Rs0ailN28/pR1ocnHqyR9naySYcV/US1RYXFXSEmBbwXT427
qV//e5WV4e1S/BR8m/xnxC9kIut69V4FIZZhtFYpQ/HwDpi48hVC3a4LTAz/pd+i
v5UAMOT9/aib6cugGkyy3XatoPzv47T/PnI2w/5pb/PZ5gaWQ78maysUdbv7VIj1
kC6+ajlwbL15VahjrW6NUvRmN+lEvoLOvqyXhggtqWvDRbZOKJq9CduYsSCJ3fsY
OMcah0E5MUnkZbzGcmk6uEh637yfqhDeGibWQmo3nPG3baZ2w8Fzin2IWFwkLOgS
ZMKVakhtkteYTH7r6ZT+KJi8MFHt/7E0Qyufr5niAowe2UrZ/p54yl5W2cfYM09G
kGLxGLVbuZ+ewnOGOwYR
=iFxc
-----END PGP SIGNATURE-----

--lc9FT7cWel8HagAv--
