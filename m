Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754396AbaFRT0a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 15:26:30 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:36823 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752014AbaFRT02 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 15:26:28 -0400
Date: Wed, 18 Jun 2014 14:25:53 -0500
From: Felipe Balbi <balbi@ti.com>
To: Nishanth Menon <nm@ti.com>
CC: Felipe Balbi <balbi@ti.com>, Benoit Cousson <bcousson@baylibre.com>,
        <robh+dt@kernel.org>, <galak@codeaurora.org>,
        Tony Lindgren <tony@atomide.com>, <linux@arm.linux.org.uk>,
        Rajendra Nayak <rnayak@ti.com>, <r.sricharan@ti.com>,
        <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] arm: dts: am4372: let boards enable RTC and
 Watchdog
Message-ID: <20140618192553.GB4570@saruman.home>
Reply-To: <balbi@ti.com>
References: <1403106200-777-1-git-send-email-balbi@ti.com>
 <1403106200-777-2-git-send-email-balbi@ti.com>
 <53A1B677.9010909@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8P1HSweYDcXXzwPJ"
Content-Disposition: inline
In-Reply-To: <53A1B677.9010909@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--8P1HSweYDcXXzwPJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Jun 18, 2014 at 10:55:35AM -0500, Nishanth Menon wrote:
> $subject - ARM: dts:
>=20
> On 06/18/2014 10:43 AM, Felipe Balbi wrote:
> > by providing phandles to rtc and wdt nodes, we can
> > let boards enable rtc and wdt as necessary.
> >=20
> > Signed-off-by: Felipe Balbi <balbi@ti.com>
> > ---
> >  arch/arm/boot/dts/am4372.dtsi | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >=20
> > diff --git a/arch/arm/boot/dts/am4372.dtsi b/arch/arm/boot/dts/am4372.d=
tsi
> > index 49fa596..e3830d4 100644
> > --- a/arch/arm/boot/dts/am4372.dtsi
> > +++ b/arch/arm/boot/dts/am4372.dtsi
> > @@ -270,7 +270,7 @@
> >  			ti,hwmods =3D "counter_32k";
> >  		};
> > =20
> > -		rtc@44e3e000 {
> > +		rtc: rtc@44e3e000 {
> >  			compatible =3D "ti,am4372-rtc","ti,da830-rtc";
> >  			reg =3D <0x44e3e000 0x1000>;
> >  			interrupts =3D <GIC_SPI 75 IRQ_TYPE_LEVEL_HIGH
> > @@ -279,7 +279,7 @@
> >  			status =3D "disabled";
> >  		};
> > =20
> > -		wdt@44e35000 {
> > +		wdt: wdt@44e35000 {
> >  			compatible =3D "ti,am4372-wdt","ti,omap3-wdt";
> >  			reg =3D <0x44e35000 0x1000>;
> >  			interrupts =3D <GIC_SPI 91 IRQ_TYPE_LEVEL_HIGH>;
> >=20
> we might want to fix up any other similar nodes in dtsi as well, no?
>
> examples:
> cpu@0

and why would you want boards to mess with the cpu node ?

> dispc@4832a400

perhaps

> Might also be nice to have Fixes: to point out which commit was being
> fixed, no?

no other board enables those, so I wouldn't consider it a fix.

--=20
balbi

--8P1HSweYDcXXzwPJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJToefAAAoJEIaOsuA1yqREYlsP/jTjn3LSE6rGhNwkNzFhzXtG
5n1cP4fXSq+y6qKDIKUyWcugBBePxIe3/rHb0XlFPrFOmehaFSMrB9P3SDyJ4g4I
/TQdQeYoRldEaP1YMQeYgzegzSZFX0nxQ3/kQu4HweN8MoIFU9fJb8aXj0rZxLhZ
PfzbJkTb/W7D8TG/wRZFA1KEv2qTlu3jFihRubdlMD/Qt9eSVJdfGcIj+gKi6dY4
vmlCRbvtxF2h6E9W7Ib9yEmZqMyyZvHv7vUNsLTQHslRDqh42y9uP9Zfc6Inlxvv
QLM2R2UGhKHe+o69U5h6Nc2fL80aIQVZCom6qD24c52xwiztMbkvJFiSvhB6J59B
d7R+CWXWyTnimGJ8kQPV2dbMt9A7YRUNDO1SrF1NUBKF9T8pQLb/wT3TLjYPNuoC
imNmZ/YZLxbKHo9Svr6hsvJumKV+I3d/ujBJg7V0/7F+2sBhDxcD1Yun/hVsfc2j
7BKa7fzzctV4CAIVcCxmuH5nc/M1JaCyjOPVp5eeQQMZizdSgPMHd/KNPvxysmSV
j0HHy3na3APGKU/hq2mSCO4DrdLdEbAxNfv1el9jbhk4jgapdW7NxAZDo+M870HS
a6IMtv3E8l66nYNvGs1hw1SQc1DFfgepYZY/jP7CO9zEbu5oe3V8mQ2a13pxb1Ru
e1JCnROcGwxBZH+aVxKt
=C9cv
-----END PGP SIGNATURE-----

--8P1HSweYDcXXzwPJ--
