Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752089AbaEKEaU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 00:30:20 -0400
Received: from top.free-electrons.com ([176.31.233.9]:52021 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751302AbaEKEaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 00:30:13 -0400
Date: Sat, 10 May 2014 12:08:09 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH v3 2/3] ARM: sunxi: drop CONFIG_COMMON_CLK_DEBUG
Message-ID: <20140510160809.GN7047@lukather>
References: <1399618669-6830-1-git-send-email-prabhakar.csengg@gmail.com>
 <1399618669-6830-3-git-send-email-prabhakar.csengg@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Fm6XlJPzS/ViAqAU"
Content-Disposition: inline
In-Reply-To: <1399618669-6830-3-git-send-email-prabhakar.csengg@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Fm6XlJPzS/ViAqAU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 09, 2014 at 12:27:48PM +0530, Lad, Prabhakar wrote:
> From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
>=20
> this patch drops CONFIG_COMMON_CLK_DEBUG option
> as this config option is now obsolete.
>=20
> CC: Maxime Ripard <maxime.ripard@free-electrons.com>
> CC: Olof Johansson <olof@lixom.net>
> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Applied, thanks!

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--Fm6XlJPzS/ViAqAU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJTbk7oAAoJEBx+YmzsjxAget8P/i+A1O34pFxaA7YXkBEEdzKZ
6wJIXc2m2lKwQgIr6c6BUWLnvDDEcPnaQtH+F35Kn8KRVWSBTpauvsZoqEb773X/
MSS/5Lj6iy4YgMCKuT9UCE8hrbTqE1BjWiy9JM1u4KIdnU8GygsSowmQ1S1sb6je
3almuvXoJ+BqxHV7OS4DSl4wVQobSyP9t/K7JCiSwOf1MCzor4iZDWuigqm+PkYp
Of7u5i8t3Gw80Kkz254dLpnrzSOvLsSHfduF4dv6H2Ecjx0JSVWkd4JgYHMdpTVQ
/XAgRGXHUzCUr+uV537BCPAkgbFKrIpqNP3+oJNVW/P4Wrx3ekgcOclEB+rGMGQH
kal/I1oag2uw41fV0AiQXsVgcemSgX7RzKkugPLRCyAjMyMn0GuNPAT/1y+HRTf1
8o+dOw3yLlojVS85XUp3j0nbxSH/CiNfw44vGnGdkNDeiXMjDFDd4Lpb6Yngo8CB
kfTmmZaNY/6buJKv498lX+3LIh/2/8T0H6lTjqiPjsMJ7wrwcH23hTRDZa5NKF2T
srdAN25g5rcOY9s2lR0ugBnTplLRQodUOHriKZ9Ag0EqlpXG4/tIcohT+H/hZ8r1
w1rr0T6yPDBuRDCiXp9aqd55fpUu/eucaAQndo2jx0rZ3qSSJQHEyEfNukrqJkvm
NqHtFWIrFvg9VF5U4Rb6
=zW3A
-----END PGP SIGNATURE-----

--Fm6XlJPzS/ViAqAU--
