Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758625Ab3HJRT3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Aug 2013 13:19:29 -0400
Received: from top.free-electrons.com ([176.31.233.9]:48841 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752440Ab3HJRT2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Aug 2013 13:19:28 -0400
Date: Sat, 10 Aug 2013 19:19:23 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] ARM: sunxi: DTSI cleanups
Message-ID: <20130810171923.GI2911@lukather>
References: <1375608844-13159-1-git-send-email-maxime.ripard@free-electrons.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3E9L5busH6ECpa9r"
Content-Disposition: inline
In-Reply-To: <1375608844-13159-1-git-send-email-maxime.ripard@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3E9L5busH6ECpa9r
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Aug 04, 2013 at 11:33:58AM +0200, Maxime Ripard wrote:
> Hi everyone,
>=20
> This small patchset removes the useless reg property in the soc bus that =
is not
> required for the simple-bus we're using.
>=20
> It also fixes the base address of this bus in the node name that was wron=
g from
> the start.
>=20
> Maxime
>=20
> Maxime Ripard (6):
>   ARM: sun4i: a10: Remove useless simple-bus reg property
>   ARM: sun4i: dt: Fix A10 SoC bus base address
>   ARM: sun5i: a10s: Remove useless simple-bus reg property
>   ARM: sun5i: dt: Fix A10s SoC bus base address
>   ARM: sun5i: a13: Remove useless simple-bus reg property
>   ARM: sun5i: dt: Fix A13 SoC bus base address
>=20
>  arch/arm/boot/dts/sun4i-a10-cubieboard.dts       | 2 +-
>  arch/arm/boot/dts/sun4i-a10-hackberry.dts        | 2 +-
>  arch/arm/boot/dts/sun4i-a10-mini-xplus.dts       | 2 +-
>  arch/arm/boot/dts/sun4i-a10.dtsi                 | 3 +--
>  arch/arm/boot/dts/sun5i-a10s-olinuxino-micro.dts | 2 +-
>  arch/arm/boot/dts/sun5i-a10s.dtsi                | 3 +--
>  arch/arm/boot/dts/sun5i-a13-olinuxino.dts        | 2 +-
>  arch/arm/boot/dts/sun5i-a13.dtsi                 | 3 +--
>  8 files changed, 8 insertions(+), 11 deletions(-)

Applied to my sunxi/dt-for-3.12 branch.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--3E9L5busH6ECpa9r
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSBnYbAAoJEBx+YmzsjxAgQl8P/2UI4PStWmOTczSxOASGrSXK
UPPysDmLPRxz+gxs0nyMbZE/9nhYaJ3nureCBMqlDVg/6sibI3EGCY2dU3b3MA9w
J2tGsjX+Qe1HNcjdP//J3Qi4CZXKmxm0lhvXq+1WD8HRRUUZQytGLV0A63XK7zd/
/R3YMJtnY5fi73WtjkKAMLswmtD5EywGOl69FqtkKcgBwNEnf8X+w7r2rzwWQFX+
r2Ls/sSd1OrF8s21gTZuu9Y3+N1ps5F0mszPxz5Iqazjbh8Ag9+8ALtPjwXJoext
+9gRtNGWCB5ng8kBb+7zX/9O1ewyhjhCcrYoFTWF+m0ZeK+Tl/nZEyPHuD1xfXhs
pGLDpiMOz+rLfwNcaNSwd/IfWPp2sT8hvHv/Ku6hGnqBnK9hNZIo3GfrfNxjSHLP
U6hw2QgmJsmk6ZQGHMGycViAGQbUsM2QDKYdpyiQa9RQjdLXeHdHSNKUkSkxe5u2
ci5xkEK8kOT2y0F4Qj2Ct01mTomTFjVc6UqFXNrkDhHm7W2PoSOE5jssx9u9gKNt
BHTGTI9hDtcyU0pahDlVjrdUxoFmPdS5wwwZ3H8TGSSfgOTsz+6N/ZL8eMVWGULY
aF2seOEkdwON78f4OpGeLtIAJx7kuZWwCZiuXHyrz+BsbeUb6bQkYu3UHxIKpQBn
4s5Kqd46ztZvaPkhswx+
=aCKH
-----END PGP SIGNATURE-----

--3E9L5busH6ECpa9r--
