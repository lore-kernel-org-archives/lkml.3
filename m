Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752488AbaAQMKM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 07:10:12 -0500
Received: from top.free-electrons.com ([176.31.233.9]:55316 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751537AbaAQMKF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 07:10:05 -0500
Date: Fri, 17 Jan 2014 13:06:41 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, Gerardo Di Iorio <arete74@gmail.com>,
        dev@linux-sunxi.org, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: sunxi: change the AllWinner A1X to sunxi
Message-ID: <20140117120641.GA3867@lukather>
References: <20140109153404.GA21055@kvmhost>
 <20140115091006.GF3377@lukather>
 <3612364.BZBltgonI0@wuerfel>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XsQoSWH+UP9D9v3l"
Content-Disposition: inline
In-Reply-To: <3612364.BZBltgonI0@wuerfel>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--XsQoSWH+UP9D9v3l
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Arnd,

On Wed, Jan 15, 2014 at 10:40:56AM +0100, Arnd Bergmann wrote:
> On Wednesday 15 January 2014 10:10:06 Maxime Ripard wrote:
> > On Thu, Jan 09, 2014 at 04:34:04PM +0100, Gerardo Di Iorio wrote:
> > > Change the AllWinner A1X SOCs to Allwinner Sunxi SOCs
> > >=20
> > > Signed-off-by: Gerardo Di Iorio <arete74@gmail.com>
> > > ---
> > >  arch/arm/mach-sunxi/Kconfig | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > >=20
> > > diff --git a/arch/arm/mach-sunxi/Kconfig b/arch/arm/mach-sunxi/Kconfig
> > > index 547004c..adb2574 100644
> > > --- a/arch/arm/mach-sunxi/Kconfig
> > > +++ b/arch/arm/mach-sunxi/Kconfig
> > > @@ -1,5 +1,5 @@
> > >  config ARCH_SUNXI
> > > -       bool "Allwinner A1X SOCs" if ARCH_MULTI_V7
> > > +       bool "Allwinner Sunxi SOCs" if ARCH_MULTI_V7
> >=20
> > I wonder if the sunxi (apart the weird letter case) is actually
> > needed. Maybe we can just put "Allwinner SoCs" (it would be great if
> > you could fix the SoCs case too).
>=20
> If you want to have exact naming, try to find something that excludes the
> old Sun3i (F20) and earlier chips (unless someone is already planning
> to work on them). Maybe also mention the "Boxchip" name, although that
> seems to be falling out of use these days.

I'm not sure that's good to exclude chips. We have a number of SoCs we
don't support even on later families (A31s, A23, mostly). I'm not sure
we want to have an ever growing list of SoCs supported (or
not-supported).

"sunXi" would be fine I guess, or "A-series" like suggested on IRC.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--XsQoSWH+UP9D9v3l
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJS2RzRAAoJEBx+YmzsjxAgD7EP/0GIXbmLyAU6HzZwDWc/n/l0
s0AigP+0meLmeRjbMmUlb5hWZm/XramWsL2diXfFNBmb4yACQiAR9knWbKUfkEXM
Mh6Y+/n4eZ9EehnVmjKQDEMEeROzqRsRygMJmr6qT2OhwAZqfzEQ6zQI8LzUGafR
CWdAXHIOOXOj9ZGSZhqbv+0ieig+KuhJIVAcvDLTwPaYU0JvqCkIlmrDcV4vvBI6
8VGi/uSIxE03W211VleG4psh5MjiI4+hMyK+FnByTMyxMMEePQf5vFY2E/DejQAm
bGbo4/D7r8WJszMuCApCXiT/R0UH74Mlj15Tbs6Y0I9s0+m4o3f9UQCDDbPydrZ5
c5oFEkIzplh/VTjm49wvT53KDoy21RFn1pvu5xRurlvs5aovSL6PNaxUfUMZypz3
S4NYZZbYHgZG/Wl9gJyp3LNOJYfjHofN+ADq1Q0u3AeEw2akAUQy6hTlXpcM/kqO
09Z5Oj6p0yR9XZa10vZ2FAcWN8WrQcFtsNH/xifagNvNmCeh6eKQ+hgx7q2iknZH
wX0sGcUO/jq1Ukr7OpveO5ZCTllkDFXw9LIVUvqkdQqO2vrxbBmrTYyoODjkgisl
BMZOE9PoICJ29jeNrrdBwRUy+yVEC9Zkpj7O8SR64IM9buZZwDM1LtEvDQfjITCy
vt5uqLsC6+IATA7hBvoP
=E81I
-----END PGP SIGNATURE-----

--XsQoSWH+UP9D9v3l--
