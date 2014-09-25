Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752686AbaIYNaP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 09:30:15 -0400
Received: from top.free-electrons.com ([176.31.233.9]:58136 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751650AbaIYNaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 09:30:13 -0400
Date: Thu, 25 Sep 2014 15:25:27 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Chen-Yu Tsai <wens@csie.org>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Shuge <shuge@allwinnertech.com>,
        Meng Zhang <kevin@allwinnertech.com>, ctl@merrii.com,
        Gregory CLEMENT <gregory.clement@free-electrons.com>
Subject: Re: [PATCH v2 1/7] ARM: sunxi: Introduce Allwinner A80 support
Message-ID: <20140925132527.GF15315@lukather>
References: <1411570141-29960-1-git-send-email-wens@csie.org>
 <1411570141-29960-2-git-send-email-wens@csie.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UBYeLQbK9sqbzZRV"
Content-Disposition: inline
In-Reply-To: <1411570141-29960-2-git-send-email-wens@csie.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UBYeLQbK9sqbzZRV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 24, 2014 at 10:48:55PM +0800, Chen-Yu Tsai wrote:
> The Allwinner A80 is a new Cortex octo-core A7/A15 big.LITTLE SoC.
> While it's processor cores and interconnecting bus are new, it
> re-uses many peripherals found in earlier Allwinner SoCs.
>=20
> Signed-off-by: Chen-Yu Tsai <wens@csie.org>
> ---
>  arch/arm/mach-sunxi/Kconfig | 5 +++++
>  arch/arm/mach-sunxi/sunxi.c | 9 +++++++++
>  2 files changed, 14 insertions(+)
>=20
> diff --git a/arch/arm/mach-sunxi/Kconfig b/arch/arm/mach-sunxi/Kconfig
> index 1aaa1e1..72f222b 100644
> --- a/arch/arm/mach-sunxi/Kconfig
> +++ b/arch/arm/mach-sunxi/Kconfig
> @@ -42,4 +42,9 @@ config MACH_SUN8I
>  	select MFD_SUN6I_PRCM
>  	select RESET_CONTROLLER
> =20
> +config MACH_SUN9I
> +	bool "Allwinner A80 (sun9i) SoCs support"

With the new naming scheme, I wonder wether it makes sense to have the
A80 displayed here and in the machine definition.

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--UBYeLQbK9sqbzZRV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUJBfHAAoJEBx+YmzsjxAgUg4P/1sO1EJqScfXK5bdap15jrX5
+dD2k7gmYCZRMm6MecHjFF0VOXdixzfGdlt/mn35EHyYFDJYR8i62ideFIWt7CQo
jyGNGB5GQEZtq+1zUuOPfAAJsbv9h7WBR7+A4F5Peq++lxdr4FiQ/kooKdUmlhHu
VAZ1+DHspyb5UwyXMMXLGCdsgzBjwAqG8LOLFNxnyJAPVNyZ5eCl0ORMy+zTOW4r
/hZMG7JlVbhcJfFILHSB+mlYuAkLMCbyhrQ6OmM6AgE6qLrXtYUlt2VEscW1rtBu
orVLUCd8g2jR6Ze2frCOssbm6vppbByaZGStK7sARrf9uV5Zdj0HIWsIqFx4UmBN
ATMJ+7hocK4mo1TZvWw/NT3+yNf0e9shxGA2FgF5xJH4r51dHW+2AqZxyFGcpvYR
JTdjsVeRHoUz3mgOlPmQoQtgyYhQpfXmkJRYtaCNGxHRH3/tgssGDviguoTksSj+
mI6r2n+cuxyhZoEJhRhDxsCQJi9G79sl6LhGKam4QyQTo+qzPIOd2kmL+rlunJMu
099emO1TlgP5zrmJgrFt7J81yyKsKWmmFZqe+auNIKTeeX/tFPSWkAuO9KwpDgAE
/rMv5ByV9O/3bb9BYy0tjXowppIf9WjM6PzVue8i7oXPuWUbibtf7nAPh3vCy2AA
PyaDDleyvvcUHvK6mHPE
=syMK
-----END PGP SIGNATURE-----

--UBYeLQbK9sqbzZRV--
