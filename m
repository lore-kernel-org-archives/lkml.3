Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932711Ab3BSK5R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 05:57:17 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:44356 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932641Ab3BSK5O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 05:57:14 -0500
Date: Tue, 19 Feb 2013 12:56:33 +0200
From: Felipe Balbi <balbi@ti.com>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
CC: Afzal Mohammed <afzal@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Russell King <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>, Marc Zyngier <marc.zyngier@arm.com>,
        Nicolas Pitre <nico@linaro.org>, Will Deacon <will.deacon@arm.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Landley <rob@landley.net>, Sekhar Nori <nsekhar@ti.com>,
        Syed Mohammed Khasim <khasim@ti.com>
Subject: Re: [PATCH, RFC 5/8] ARM: OMAP2+: am43: Kconfig
Message-ID: <20130219105633.GN23197@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <cover.1361186097.git.afzal@ti.com>
 <5951ba90110b97fb494743e1aedf26aaa92b97a9.1361186097.git.afzal@ti.com>
 <5123537B.8050709@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yK/6QRnH3Zanb0EF"
Content-Disposition: inline
In-Reply-To: <5123537B.8050709@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--yK/6QRnH3Zanb0EF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 19, 2013 at 03:57:07PM +0530, Santosh Shilimkar wrote:
> On Monday 18 February 2013 05:08 PM, Afzal Mohammed wrote:
> >Add Kconfig option for AM43 family of SoC's, these are ARM Cortex A9
> >based (SMP configuration with 1 core).
> >
> >Signed-off-by: Afzal Mohammed <afzal@ti.com>
> >---
> >  arch/arm/mach-omap2/Kconfig | 11 +++++++++++
> >  1 file changed, 11 insertions(+)
> >
> >diff --git a/arch/arm/mach-omap2/Kconfig b/arch/arm/mach-omap2/Kconfig
> >index 49ac3df..683fbaa 100644
> >--- a/arch/arm/mach-omap2/Kconfig
> >+++ b/arch/arm/mach-omap2/Kconfig
> >@@ -141,6 +141,17 @@ config SOC_AM33XX
> >  	select MULTI_IRQ_HANDLER
> >  	select COMMON_CLK
> >
> >+config SOC_AM43
> >+	bool "TI AM43"
> >+	depends on ARCH_OMAP2PLUS
> >+	default y
> >+	select CPU_V7
> >+	select HAVE_SMP
> You don't need this

actually, this is needed for CONFIG_SMP_ON_UP

--=20
balbi

--yK/6QRnH3Zanb0EF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRI1phAAoJEIaOsuA1yqREYwwQAKjMwrUzLNukfn2riXws4I8W
6fi16GEdNQmLSjy/F8R8zB7liN/2yYi3cB5Q1E+YRCqyHQjXb5l3wPKvCrrHsMH/
JCnP6BgbMBEKEEOqdjbFFOGexGvyS2ST757/hmifN8i1/zz1z1jJ1l3wprP+MBHe
uPqmym7KVuWtbfeTHygjHmRdQ5KPRN5D+5MpK1QL/Vmt6FzPl31xH0k2i01X0qOn
MGOj0EbeRnixhzaZSDg/N7Vts5wt3rLyoJII5nWVY7h0ZJgpcOsm+E7SGytPd5Ve
no3AoAcrT5hPuW2e5L1h63ftaaYwN6BqiZi/n0UxsbtmUaArgyRUMSCrnhIkb0Ps
u4CELAiqddTMFbYRLc3ms1bMMB1ye0X6YHeCCf9wCxxjYIYuV4T/EOurVFprp38A
PwOse7JcZneZ25v2zilF9rikE/RoC7JlGFyXPygatzUTtVbpULR2DUWQm1+yC8Y0
d+T1TGLhfLMJJ1xAKWw4tegA8kgIU+Ui6Sm/JWsDsvzmySLsc8CXcDaf8xSO7Sj4
rRCw0/X21P2QrQ9mjD0yA02ADNFC6KgiqSMUTMw+AzawmjxMH3n0fo3+22KpwBeH
t/wKSK40OQTqV+mtDVRwpHQ3EIx0Wt9cISTyhAFr0tdEr4zrmCGIbCCxBwTg6003
7XWntEvtBqd+K6eaDXM0
=GxrB
-----END PGP SIGNATURE-----

--yK/6QRnH3Zanb0EF--
