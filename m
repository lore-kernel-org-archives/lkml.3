Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758535Ab3BSJSL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 04:18:11 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:37788 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757774Ab3BSJSD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 04:18:03 -0500
Date: Tue, 19 Feb 2013 11:17:28 +0200
From: Felipe Balbi <balbi@ti.com>
To: "Mohammed, Afzal" <afzal@ti.com>
CC: "Balbi, Felipe" <balbi@ti.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>, Marc Zyngier <marc.zyngier@arm.com>,
        Nicolas Pitre <nico@linaro.org>,
        "Shilimkar, Santosh" <santosh.shilimkar@ti.com>,
        Will Deacon <will.deacon@arm.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Landley <rob@landley.net>, "Nori, Sekhar" <nsekhar@ti.com>,
        "Syed Mohammed, Khasim" <khasim@ti.com>
Subject: Re: [PATCH, RFC 7/8] ARM: dts: am4372: initial support
Message-ID: <20130219091728.GF23197@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <cover.1361186097.git.afzal@ti.com>
 <c9c131c0508b875c0893e8557504372a1564568a.1361186097.git.afzal@ti.com>
 <20130218182240.GA10755@arwen.pp.htv.fi>
 <C8443D0743D26F4388EA172BF4E2A7A93EAA85B2@DBDE01.ent.ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IvGM3kKqwtniy32b"
Content-Disposition: inline
In-Reply-To: <C8443D0743D26F4388EA172BF4E2A7A93EAA85B2@DBDE01.ent.ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--IvGM3kKqwtniy32b
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 19, 2013 at 10:10:17AM +0100, Mohammed, Afzal wrote:
> Hi Felipe,
>=20
> On Mon, Feb 18, 2013 at 23:52:40, Balbi, Felipe wrote:
> > On Mon, Feb 18, 2013 at 05:08:16PM +0530, Afzal Mohammed wrote:
>=20
> > > +		uart1: serial@44e09000 {
> > > +			compatible =3D "ti,am4372-uart","ti,omap2-uart";
> > > +			clock-frequency =3D <48000000>;
> > > +			reg =3D <0x44e09000 0x2000>;
> > > +			interrupts =3D <0 72 0x4>;
> >=20
> > missing ti,hwmods ??
>=20
> It is a deliberate omission. For minimal bootconsole booting, hwmod
> help is not required. Hwmod details would be added gradually later,
> current series doesn't register hwmod.

understood, thanks

--=20
balbi

--IvGM3kKqwtniy32b
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRI0MoAAoJEIaOsuA1yqREcWwP/0SaFx29vPQKn8AsgF5j9IPF
1m5/CxsFSpR3C+voOuJWLW/5JxYHWKiHNucYPyvoyafhFIj3nNrJERW6Bq5PGSSP
v+AhwNdsQczPSSgaCK+LM/dkssgAoGU8hjbrzSxAAXFYQmfATJqJBAmEDyWfrz4+
OJrAEAs76InLiC1eYaOgQQIPiHTEsPoWRYxHYQV2O+QKMwn9uMxinVauIVHZ1+2H
6mKUm1D7HMU7VudxytoMFDfPhDoNR4wlKg3Ri3mXhNG7zy0avyUxPkOyMo+1ycXM
cQ9HuZNLSNSdoVLuQtcidvNp439eZ0sn/8hZvZLx24PMD2G3laG0ZgIztpgMAhGy
kC6vE6+r4J3XH/Me1KftAkA3o1d58+lzzaF7NcplgC50HpwNvhSg1vhz4S5dA6BW
Q2KUpEkco7bv2p3vrpPcBjukfb4ISBUSIq4wYMvhrTiSLh/HDBw9WO3A4Kkwwk1w
CusS1IfhmmuTPJQ5aNchBCk1CQRZCQZnWH/hVg6uR04TH28hJSBCT2nzLuHmG53U
eRdmJqdzfjt5XA8yPbMspkrJKJLOcbLCzTZPb+gzAjr0JVfeTwtF+l+7N9cYH5oY
qGwNpZmxGCd8IfjPPRbKcnCngQCJT2VtVjQ0ACaunKsjsUZaVtS8lOEMkVK6F2WX
Dj7fH/YDqoaKjrdQbdx/
=SA+Y
-----END PGP SIGNATURE-----

--IvGM3kKqwtniy32b--
