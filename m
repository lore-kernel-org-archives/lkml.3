Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756079Ab3EaPEJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 11:04:09 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:43828 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755722Ab3EaPEB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 11:04:01 -0400
Message-ID: <51A8BBBC.9000505@ti.com>
Date: Fri, 31 May 2013 11:03:24 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130404 Thunderbird/17.0.5
MIME-Version: 1.0
To: Eduardo Valentin <eduardo.valentin@ti.com>
CC: <tony@atomide.com>, <linux-omap@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv2 1/3] arm: introduce config HAS_BANDGAP
References: <1368629928-6723-1-git-send-email-eduardo.valentin@ti.com> <1368629928-6723-2-git-send-email-eduardo.valentin@ti.com>
In-Reply-To: <1368629928-6723-2-git-send-email-eduardo.valentin@ti.com>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="----enig2HRUFFUQUOVNQMBGMCLIG"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------enig2HRUFFUQUOVNQMBGMCLIG
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Tony, Russell,



On 15-05-2013 10:58, Eduardo Valentin wrote:
> Introduce HAS_BANDGAP config entry. This config is a
> boolean value so that arch code can flag is they
> feature a bandgap device.
>=20
> This config entry follows the same idea behind
> ARCH_HAS_CPUFREQ.
>=20
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Tony Lindgren <tony@atomide.com>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-omap@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>

Gentle reminder on this one.

> ---
>  arch/arm/Kconfig            | 3 +++
>  arch/arm/mach-omap2/Kconfig | 1 +
>  2 files changed, 4 insertions(+)
>=20
> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index d423d58..bcbdec9 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -174,6 +174,9 @@ config ARCH_HAS_CPUFREQ
>  	  and that the relevant menu configurations are displayed for
>  	  it.
> =20
> +config ARCH_HAS_BANDGAP
> +	bool
> +
>  config GENERIC_HWEIGHT
>  	bool
>  	default y
> diff --git a/arch/arm/mach-omap2/Kconfig b/arch/arm/mach-omap2/Kconfig
> index f49cd51..8620ab5 100644
> --- a/arch/arm/mach-omap2/Kconfig
> +++ b/arch/arm/mach-omap2/Kconfig
> @@ -4,6 +4,7 @@ config ARCH_OMAP
>  config ARCH_OMAP2PLUS
>  	bool "TI OMAP2/3/4/5 SoCs with device tree support" if (ARCH_MULTI_V6=
 || ARCH_MULTI_V7)
>  	select ARCH_HAS_CPUFREQ
> +	select ARCH_HAS_BANDGAP
>  	select ARCH_HAS_HOLES_MEMORYMODEL
>  	select ARCH_OMAP
>  	select ARCH_REQUIRE_GPIOLIB
>=20


--=20
You have got to be excited about what you are doing. (L. Lamport)

Eduardo Valentin


------enig2HRUFFUQUOVNQMBGMCLIG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlGou7wACgkQCXcVR3XQvP2pUQD/ULv7Q1oKzDK3Z5cQQ5HJ9MDW
xjyaCjvZpRVEsj/5Y1UBAOZjdgfjdlkjTBUvROwlyoYbUtZGIh74+/XzSguxfNnJ
=5wOj
-----END PGP SIGNATURE-----

------enig2HRUFFUQUOVNQMBGMCLIG--
