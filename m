Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754073Ab3LTTvt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 14:51:49 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:32993 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751024Ab3LTTvs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 14:51:48 -0500
Date: Fri, 20 Dec 2013 19:51:24 +0000
From: Mark Brown <broonie@kernel.org>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arm@kernel.org, Mike Turquette <mturquette@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Grant Likely <grant.likely@linaro.org>, Rob Herring <robh@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, kernel@pengutronix.de
Message-ID: <20131220195124.GD31886@sirena.org.uk>
References: <1387568343-8754-1-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hjFmXiTvfEJBEd4m"
Content-Disposition: inline
In-Reply-To: <1387568343-8754-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Cookie: Go climb a gravity well!
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] MAINTAINERS: take maintainership for Energy Micro efm32
 SoCs
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--hjFmXiTvfEJBEd4m
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 20, 2013 at 08:39:03PM +0100, Uwe Kleine-K=F6nig wrote:
> Signed-off-by: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>

Acked-by: Mark Brown <broonie@linaro.org>

> Hello,
>=20
> I think this can best go in via armsoc, but needs acks for clk, clocksour=
ce,
> spi and tty/serial.
>=20
> Best regards
> Uwe
>=20
>  MAINTAINERS | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
>=20
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 95648eb..28c69a6 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -867,6 +867,21 @@ S:	Maintained
>  F:	arch/arm/mach-ebsa110/
>  F:	drivers/net/ethernet/amd/am79c961a.*
> =20
> +ARM/ENERGY MICRO (SILICON LABS) EFM32 SUPPORT
> +M:	Uwe Kleine-K=F6nig <kernel@pengutronix.de>
> +L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
> +S:	Maintained
> +F:	arch/arm/boot/dts/efm32*
> +F:	arch/arm/configs/efm32_defconfig
> +F:	arch/arm/include/debug/efm32.S
> +F:	arch/arm/mach-efm32/
> +F:	drivers/clk/clk-efm32gg.c
> +F:	drivers/clocksource/time-efm32.c
> +F:	drivers/spi/spi-efm32.c
> +F:	drivers/tty/serial/efm32-uart.c
> +F:	include/dt-bindings/clock/efm32-cmu.h
> +F:	include/linux/platform_data/efm32-*
> +
>  ARM/EZX SMARTPHONES (A780, A910, A1200, E680, ROKR E2 and ROKR E6)
>  M:	Daniel Ribeiro <drwyrm@gmail.com>
>  M:	Stefan Schmidt <stefan@openezx.org>
> --=20
> 1.8.5.1
>=20
>=20

--hjFmXiTvfEJBEd4m
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJStJ+5AAoJELSic+t+oim96d0P/01o2Hc2zZ/CeQuV9iuGRRrY
tZx3TIxEfw0/ZiUrLq0oCq3mPdcyjErJAOlpnAo1U4vkntThJBd608sK6mEWdIr6
ameIOLkaZ+I65onbvnH7ZpM93FPWjZf2mcZSR3P+vQot6RWxXDvnC6ZJFhj95e9N
9oaMmKBmj3fzy3dlztJI7mzXCGMoMQmxIimud63QOeVosVUs/ys0q1NiaAruB8lK
GeDlSs/LXzh6CiaY92gDDLcwCDlh1m7YHf84xRKO3Lm3JEwDa3wJB9IJFKx7yYTw
NH28saIWVlHYPmw4MN4gShVQSd8HdHAqG8Qs+XmNVONLxy4S5xrufEFxzvpQc+4f
MfBnMM2SRXdjOjucx6EpLe89XxHRRWGT5RRvdekOxWggs3Qu9B2+kmZaHi/nanH/
8+uFVb1/gFGYV5s2y3FV+G6/qDSXO23kwE4loxemdsM/L7XT7LS27vv84p18QSmT
4Mrtu7kfGwPq3ssPQp1tnftWLSMcRzoRMeLjrRaf76vOkbm0GBzqkvWxtHYa49uF
s4VH2xihWwlu7h2v1Yn5qy4i5skr0xIVtjX8OGjvsga08810TMwheOgVYD/DEM50
2rd9AjDfkvPN2vPZaJqtuTM5vNk8Rf2ltvzUFpobuqGVK4GTJs0nPvZTGXwFPmFz
WExGJRH0sGT1K4NBKiXN
=VQLG
-----END PGP SIGNATURE-----

--hjFmXiTvfEJBEd4m--
