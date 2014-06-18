Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756046AbaFRXYB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 19:24:01 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:48641 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752276AbaFRXX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 19:23:59 -0400
Date: Wed, 18 Jun 2014 18:23:27 -0500
From: Felipe Balbi <balbi@ti.com>
To: Felipe Balbi <balbi@ti.com>
CC: Nishanth Menon <nm@ti.com>, <devicetree@vger.kernel.org>,
        <linux@arm.linux.org.uk>, Josh Elliot <jelliott@ti.com>,
        Tony Lindgren <tony@atomide.com>, Rajendra Nayak <rnayak@ti.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Darren Etheridge <detheridge@ti.com>, <r.sricharan@ti.com>,
        <robh+dt@kernel.org>, Benoit Cousson <bcousson@baylibre.com>,
        <galak@codeaurora.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 2/2] arm: dts: add support for AM437x StarterKit
Message-ID: <20140618232327.GC9855@saruman.home>
Reply-To: <balbi@ti.com>
References: <1403106200-777-1-git-send-email-balbi@ti.com>
 <1403106200-777-3-git-send-email-balbi@ti.com>
 <53A1BADD.7050309@ti.com>
 <20140618193113.GC4570@saruman.home>
 <53A20A7D.3060508@ti.com>
 <20140618231923.GA9855@saruman.home>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/Uq4LBwYP4y1W6pO"
Content-Disposition: inline
In-Reply-To: <20140618231923.GA9855@saruman.home>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--/Uq4LBwYP4y1W6pO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

(side note)

On Wed, Jun 18, 2014 at 06:19:23PM -0500, Felipe Balbi wrote:
> > >>>+		interrupt-controller;
> > >>>+		#interrupt-cells =3D <2>;
> > >>>+
> > >>>+		dcdc1: regulator-dcdc1 {
> > >>>+			compatible =3D "ti,tps65218-dcdc1";
> > >>>+			/* VDD_CORE limits min of OPP50 and max of OPP100 */
> > >>>+			regulator-name =3D "vdd_core";
> > >>>+			regulator-min-microvolt =3D <912000>;
> > >>>+			regulator-max-microvolt =3D <1144000>;
> > >>>+			regulator-boot-on;
> > >>>+			regulator-always-on;
> > >>>+		};
> > >>>+
> > >>>+		dcdc2: regulator-dcdc2 {
> > >>>+			compatible =3D "ti,tps65218-dcdc2";
> > >>>+			/* VDD_MPU limits min of OPP50 and max of OPP_NITRO */
> > >>>+			regulator-name =3D "vdd_mpu";
> > >>>+			regulator-min-microvolt =3D <912000>;
> > >>>+			regulator-max-microvolt =3D <1378000>;
> > >>>+			regulator-boot-on;
> > >>>+			regulator-always-on;
> > >>>+		};
> > >>>+
> > >>>+		dcdc3: regulator-dcdc3 {
> > >>>+			compatible =3D "ti,tps65218-dcdc3";
> > >>>+			regulator-name =3D "vdds_ddr";
> > >>no voltage ?
> > >
> > >has no users in kernel. Also, it comes out with default, and correct,
> > >voltage.
> >=20
> > Device tree is description of hardware, not just who uses what in OS
> > of interest.
>=20
> then we should start "fixing" every single DTS in the kernel because I'm
> sure even LEDs and keypads are tied to some sort of supply, as is the
> case with this board. No driver will use it though.
>=20
> Also, I couldn't find anywhere which voltage is dcdc3 outputing and
> there's no shunt anywhere (other than a 0 ohm resistor) to measure
> voltage. So I kinda have my hands tied here.
>=20
> (goes review schematics)
>=20
> actually there's 0.05 ohm sense resistor. Hopefully it's easy to access.

1.35v

--=20
balbi

--/Uq4LBwYP4y1W6pO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJToh9vAAoJEIaOsuA1yqREIvwP+wZd5LlwXyKmBkl3lSk7dbv+
JCuWUYRO2TrpTIZiTrf+fs0eBcd0rjnNa3cah3Tvba9tl0l3pspgs1arxQMI892c
kU45fyFUFmvDezvdndVuuaXAiNG0NiUieTdcOj2vR+hVts9YnzTbvnlMWVOraDFz
JqLRieof8/mQBDAYd7oesnTZgwvK/JmeQAIA9W012Ajko5DmpZfxODntudB3HNtK
Y6ZqXNWCLPAfeOnUgF0/mjfNT69YZLo1pvSxqsT9F1jUv0nLmjFk+4Dgx+G4Xi3Q
UVhBV2O7647aFyxczJE9LnmNfhPX1LCPntKj5l5IDbqXt7m/Q6SSf/3TaXIYEWPZ
dnXjVgRELhx06JMyd8pH1di/X/qncgXDW92RGjdj38fq6MudBsfhHWIGNJJD5aR0
r+YXfI9Ivm8Qz/FCgeSjoUpFtFYDzzgXnlcsOyVvRMJrJer84/gUIlI1Lofo8xsB
iHChrUM3BYCVg4q0mm8VJyb2UtD1A9h3xoOQsE924q5yBr4IHcAtep9uR77z6dXs
MkXX76YoWEHgO1IrAALDaFEL+2hn7hKs/JWOk4OgPTz5nEluax1usNqJZbCUYTYB
vYNDaDvIo2MqFqj9zXIEdEptFnnAP0zhA6RXAHuReM4kPqXtGzP7dP6MUpbtaOVu
7IbhazpGcHYgDpCrMouL
=5O9P
-----END PGP SIGNATURE-----

--/Uq4LBwYP4y1W6pO--
