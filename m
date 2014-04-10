Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030790AbaDJMuL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 08:50:11 -0400
Received: from top.free-electrons.com ([176.31.233.9]:38859 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030775AbaDJMuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 08:50:08 -0400
Date: Thu, 10 Apr 2014 14:47:05 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Boris BREZILLON <boris.brezillon@free-electrons.com>
Cc: Randy Dunlap <rdunlap@infradead.org>,
        Emilio =?iso-8859-1?Q?L=F3pez?= <emilio@elopez.com.ar>,
        Mike Turquette <mturquette@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>, Chen-Yu Tsai <wens@csie.org>,
        Hans de Goede <hdegoede@redhat.com>, Shuge <shuge@allwinnertech.com>,
        kevin@allwinnertech.com, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, dev@linux-sunxi.org
Subject: Re: [PATCH v2 5/5] ARM: sunxi: update the default ARCH_NR_GPIO for
 sunxi arch
Message-ID: <20140410124705.GT28585@lukather>
References: <1397132747-13917-1-git-send-email-boris.brezillon@free-electrons.com>
 <1397132747-13917-6-git-send-email-boris.brezillon@free-electrons.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RvrrZ8vH9xW05bsQ"
Content-Disposition: inline
In-Reply-To: <1397132747-13917-6-git-send-email-boris.brezillon@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--RvrrZ8vH9xW05bsQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 10, 2014 at 02:25:47PM +0200, Boris BREZILLON wrote:
> The A31 SoC has PL and PM banks, we thus need to increase the default
> ARCH_NR_GPIO when building for the sunxi architecture.
>=20
> Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>

Acked-by: Maxime Ripard <maxime.ripard@free-electrons.com>

Thanks!
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--RvrrZ8vH9xW05bsQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJTRpLJAAoJEBx+YmzsjxAg9qMP/RMAOMaSgB/Z0rFJLb93zJU2
qn26/Foju8Y1te1DQIh9v2o/XQY4o7iu9JvA/awPlmdFokAKAznrjt3V7uGAbkeb
G/kykCRngSzDLjJdabuWI20okAQYZkSyNUnnxrhKpbrnGOOPmOWWrS8govQe8Ard
kUquPO7zPKaRIRnJEd8MixXmIk2ygWw8+XZMLh5g0TpWpeMhWB2sRSQsP/B55rZz
jVYorzjfVss9LX3Ihdig+yn7TqCZ6q/+gPFLAxIquQK521aZPR9rZXd1U4zwKZS6
NnaQBQP02jv84/EflXXJjm9qNGAkpTceMzdCoJNP5nTuu5Xve6Ug1/FFlkfq9QJG
CMAcYLlKHhNtHebiCYeXyRWZBf/MweQ/ECY/e60bJ2Mw1u2sSUSwFTGHmTzLL9a9
AVB6UybntqRQxP0Bul/Bztzrq0zGOx/4cP1jMKs/el0EQZRqgQLaMOwP7vybDgb6
XpvNQBUJ9A5bH/XML3JWcjuVD6KcDU5pogzqAZSmKiqkfU48D7o5SAfnOYMwywNM
bO1Wqv7Dqf4qk/POJFbRSYwPSxyNOAZq70z+JHw9bdMW3HdCV4L2gabsNZeVaD2V
+J/Uu6bnZQlFPcL/VgCRiWUVyksgX88b6GxPsnITfLCnCB0i+qmHNmmEWazyti1E
QY2PFq20wsv0+lq5MVzC
=KQTm
-----END PGP SIGNATURE-----

--RvrrZ8vH9xW05bsQ--
