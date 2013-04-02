Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759749Ab3DBL1n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 07:27:43 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55175 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759646Ab3DBL1m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 07:27:42 -0400
Date: Tue, 2 Apr 2013 12:27:40 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@ingics.com>
Cc: Bengt Jonsson <bengt.g.jonsson@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>,
        Yvan FILLION <yvan.fillion@stericsson.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: ab8500: Staticize
 ab8500_ext_regulator_[init|exit] if !CONFIG_REGULATOR_AB8500_EXT
Message-ID: <20130402112740.GI23065@opensource.wolfsonmicro.com>
References: <1364862038.15806.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="QxIEt88oQPsT6QmF"
Content-Disposition: inline
In-Reply-To: <1364862038.15806.1.camel@phoenix>
X-Cookie: Today is what happened to yesterday.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--QxIEt88oQPsT6QmF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 02, 2013 at 08:20:38AM +0800, Axel Lin wrote:
> Fix below build errors:
>=20
>   LD      arch/arm/mach-ux500/built-in.o
> arch/arm/mach-ux500/board-mop500-regulators.o: In function `ab8500_ext_re=
gulator_init':

Lee?

--QxIEt88oQPsT6QmF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRWsB8AAoJELSic+t+oim9u0IP/3WqaZhU0i4gSavb2FIBIT1V
0IicliWgjs9sH6MhX6+wkRBDiU1VuFpLGOmhUDAohD0bQ58YW52zyOjdt3q/cB+Q
l5SXRcNt5Me/UuFnQLVP99E8NgHnx2WINy+2S4kZ9+IuFF4hCLDuyCl/7JQoe+NI
1Q+IdA6EtVPQ8HKSA2sTztHNaxATAeqTG7RHj1qO/cUwNB5z42+gpCkeXbE+TDNH
lhTTLkD6yLWZo4eHB+ftlhwRxSLCutJt7zU/R+aNQZRJ7VCln9K6x/aj2oxQjhOu
L9sVLgU4X/O8chVeAF2jhhSt/cfqh5yuKS72MXPkqWbwBu6JtaGZWiRtW5yIWnxt
e957NOSsCxijJCr+G2JKMV8+w3sJwfae23ZeCfwFbZ7QPK+G5QoLbpEeU1SiZ6Nm
Zm+Nmyq9zHp843DZLjC+XnY/9QfhbVNl5oQi52h4NFlxjVU592aWc5Po5Tkxi93i
N8Mb2twr+Dn0PtKZT2H4/AEB3NAvMLXY5Oxvcj0/yDMSUhyJO/r3A2GIGGergSnW
JKcU4v8ZAp/pDs7yGIDBSqOPL6OXtItN105oP0p0Gs4OpRF6kWFWduWINtajHw6N
/cvamgNYGu8e4PWo0l1jVE22tKiDG9OlBeVO+bLTDYC3baqsRA1i8O9b4n4kTaur
zysm1lVNehPBD6wSY6C9
=F7S2
-----END PGP SIGNATURE-----

--QxIEt88oQPsT6QmF--
