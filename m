Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754546AbaBGNtY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 08:49:24 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:41674 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751521AbaBGNtW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 08:49:22 -0500
Message-ID: <52F4E45B.1020107@ti.com>
Date: Fri, 7 Feb 2014 15:49:15 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Christoph Fritz <chf.fritz@googlemail.com>, Tero Kristo <t-kristo@ti.com>
CC: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <pali.rohar@gmail.com>, <pavel@ucw.cz>,
        Nishanth Menon <nm@ti.com>
Subject: Re: OMAP: clock DT conversion issues with omap36xx
References: <52E697C0.6000202@gmail.com> <1390848104.4936.62.camel@mars>	 <52E772A3.4090401@ti.com> <1390901735.2963.8.camel@lovely>	 <52E77D03.8090001@ti.com>  <52E7B361.2030601@ti.com>	 <1390928565.4904.88.camel@mars> <1390994505.5023.32.camel@mars>	 <52F10C3D.7000507@ti.com> <1391767923.4937.110.camel@mars>
In-Reply-To: <1391767923.4937.110.camel@mars>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="NcpriOprTl94TspshvlCtVsBcVD13T1eW"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--NcpriOprTl94TspshvlCtVsBcVD13T1eW
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi,

On 07/02/14 12:12, Christoph Fritz wrote:

> Yes, your patch fixes the issues for sys_clkout2. Thanks! If you want,
> you can add my:
> Tested-by: Christoph Fritz <chf.fritz@googlemail.com>
>=20
> Below is my clock fix for dss:
>=20
> From b90a62128068e1b6b0ba2a11c5cc0c8e587cf301 Mon Sep 17 00:00:00 2001
> From: Christoph Fritz <chf.fritz@googlemail.com>
> Date: Fri, 7 Feb 2014 10:51:15 +0100
> Subject: [PATCH] ARM: dts: omap36xx: fix dpll4_m4_ck tree
>=20
> OMAP36xx has different hardware implementation for the dpll4_m4_ck tree=

> compared to other OMAP3 variants. Reflect this properly in the dts file=
=2E

I rebased the DSS DT branch on top of v3.14-rc1, and I'm trying to get
beagle-xM working. Pinmuxing was wrong, but after fixing that, the
clk_set_rate for dss fclk failed. I applied Tero's and your patches, but
now when starting omapdss I see:

[   19.704193] omap clock: module associated with clock
dss1_alwon_fck_3430es2 didn't enable in 1000
00 tries

I wonder if I'm still missing some patch?

 Tomi



--NcpriOprTl94TspshvlCtVsBcVD13T1eW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJS9ORbAAoJEPo9qoy8lh71iPoQAKAfom2Pza7m6QY8ueOJ8lID
V97/UDuFJoJZTYzYY04HDWifVdGfDH1sz89lRaZ0xSbBf1wSr/foLr0xuWUQOaIr
pT7N5SywBsNw2jG+aRhp0XoqdSY0Pdw8tq/m4fz+vrP2L64/V9eTEtgUgT5Ctz3B
0fEWgCv6tOEUPLq+NidMZO3iQQEtkUY0lAWxdxQSNFbGGbVkH2iGLeouRta85ncN
DLAbBKmYRhMmciWT16Wf+hmDxfrr3dodecnRoM6iTqaZkf3+lhnaaojKhF49Pegj
XZUuhoyJKrml5Xoo8wAFSMRP3ceYl/GUGiI1HG3JUXftvHB9nfJI9y9gZCOGQZXi
6oVR2kSRAeVQd+MUy7O1UQA4SE5ROF5E6aqrtBkSLmUhjQjCRRluZJNXyKVpb5uW
Z/MH/Jn0EyEU7Ga/2Klq2VYqh4rOXFkQoE5IANgTY3AJ+N6yPd2/RRmzTQKc+4NI
wnm1xojcVCNQ9uaN2By5v2mU5qxfuOsX2ltjY8qgthpboVlTkqlg9MKQJPzLgYFY
feX/owhk1KQZV81TMDOHaQREphoO1N0ynD2BL/YNOhd9rHdh0nbqoVKbtAty8wYs
xEWARf2Qd8ewM6GHRCsREsWMqT57JsqKCLHEEL+WFMziZRPb3aHV/v1BH7V0qsHz
kEx1qvhTRIwhkSZ3nF5g
=tZKF
-----END PGP SIGNATURE-----

--NcpriOprTl94TspshvlCtVsBcVD13T1eW--
