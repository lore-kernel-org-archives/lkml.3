Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755323Ab3HBUOY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 16:14:24 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57221 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753591Ab3HBUOX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 16:14:23 -0400
Message-ID: <1375474450.32254.18.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [26/84] ARM: OMAP: RX-51: change probe order of touchscreen and
 panel SPI devices
From: Ben Hutchings <ben@decadent.org.uk>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Sebastian Reichel <sre@debian.org>, Aaro Koskinen <aaro.koskinen@iki.fi>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org, Felipe Balbi <balbi@ti.com>,
        Pali =?ISO-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        Tony Lindgren <tony@atomide.com>,
        Joni Lapilainen <joni.lapilainen@gmail.com>
Date: Fri, 02 Aug 2013 22:14:10 +0200
In-Reply-To: <1375349525.3556.14.camel@deadeye.wl.decadent.org.uk>
References: <lsq.1375276989.521602504@decadent.org.uk>
	 <51F9F6DF.5070306@ti.com>
	 <1375349525.3556.14.camel@deadeye.wl.decadent.org.uk>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-Gx22QkluaSHVPwy9ew3x"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 151.218.101.46
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Gx22QkluaSHVPwy9ew3x
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2013-08-01 at 11:32 +0200, Ben Hutchings wrote:
> On Thu, 2013-08-01 at 08:49 +0300, Tomi Valkeinen wrote:
> > Hi,
> >=20
> > On 31/07/13 16:23, Ben Hutchings wrote:
> > > 3.2.50-rc1 review patch.  If anyone has any objections, please let me=
 know.
> > >=20
> > > ------------------
> > >=20
> > > From: Aaro Koskinen <aaro.koskinen@iki.fi>
> > >=20
> > > commit e65f131a14726e5f1b880a528271a52428e5b3a5 upstream.
> > >=20
> > > Commit 9fdca9df (spi: omap2-mcspi: convert to module_platform_driver)
> > > broke the SPI display/panel driver probe on RX-51/N900. The exact cau=
se is
> > > not fully understood, but it seems to be related to the probe order. =
SPI
> > > communication to the panel driver (spi1.2) fails unless the touchscre=
en
> > > (spi1.0) has been probed/initialized before. When the omap2-mcspi dri=
ver
> > > was converted to a platform driver, it resulted in that the devices a=
re
> > > probed immediately after the board registers them in the order they a=
re
> > > listed in the board file.
> >=20
> > I'm not really familiar with this issue, but:
> >=20
> > The commit 9fdca9df was merged to v3.5. Has that also been backported t=
o
> > 3.2? If not, I don't think this patch is needed for 3.2, as the patch
> > causing the problem is not in 3.2.
>=20
> It has not, but Sebastian reported that 3.2 was broken in the same way
> so perhaps the blame was wrongly assigned in this commit message.
> Sebastian, can you confirm that it is fixed with 3.2.50-rc1?

I'm deferring this until it's confirmed to actually fix the problem.

Ben.

--=20
Ben Hutchings
This sentence contradicts itself - no actually it doesn't.

--=-Gx22QkluaSHVPwy9ew3x
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUfwTEue/yOyVhhEJAQpVQhAA0xjvp2tKxqcpoXYj/hJkGM+QW1+qsjFf
JYxL/86HbB3ccyrjoGj5O//9ClJjTqVVhKGNNge7tMddAbdy12CRaBr1TQQZ3xX4
F/zqV8w88mMwK8pbl36kEo7L6YY/pCN9iHOo1h7pMGU6CpkuQz6ZLf4Ry3+yFyJS
axNzfXL2DxfNGd2PX43iq5AEDcVTQwl/4/h8i34WELt1bLPylTfOC/stNP8Wh2GY
dNV9p3P3ZPlc4nsGe5RrSuFKxxHslQV8cYyDIoqn4F2tcTPoMROiqZCr7FkTD95/
GjpdAmnRtRjHPza6DzkkGLxaSJJGHsVPdNwSi4N3Ai4IX20Wd/GceY0Egc9jZtF4
WcjEuz4YoYYo3+TbFrsjGEkStfraHscPyWMBTGv11Nu6/womeguKip/0NGUVOGpA
DUa+LwMbsqLezjNesQr6cwWtPUZHePPyR2TVRIRrh3EfgictV66FK9g3V594VYPE
BvDVqZlHEaE60EoD29tFBi62354wyrcSv8MKDSFFIhmoebeEPMGzyopHMLHqU1lg
ipp3YQHGxtwxi1rnNT+jUnIC0yCa8Bnvnnlc6hH8ooxTzX0KPbdiCcJUa7bTv6go
EgFK/UmgnBME0FRaf6ie0aMEWyUYPbFY3eqK1EWg6/JPJ9rSU6htl1TOTOaXHMQo
fpzvpDM/nP4=
=sIry
-----END PGP SIGNATURE-----

--=-Gx22QkluaSHVPwy9ew3x--
