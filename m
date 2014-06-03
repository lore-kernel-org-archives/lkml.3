Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754709AbaFCNPI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 09:15:08 -0400
Received: from top.free-electrons.com ([176.31.233.9]:46099 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754667AbaFCNPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 09:15:03 -0400
Date: Tue, 3 Jun 2014 15:12:04 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Mark Brown <broonie@kernel.org>
Cc: carlo@caione.org, Boris Brezillon <boris@free-electrons.com>,
        lgirdwood@gmail.com, lee.jones@linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kevin.z.m.zh@gmail.com, sunny@allwinnertech.com,
        shuge@allwinnertech.com, zhuzhenhua@allwinnertech.com
Subject: Re: [PATCH 3/5] regulator: axp20x: Update the bindings to use a
 local parent regulator
Message-ID: <20140603131204.GJ27722@lukather>
References: <1401297069-7423-1-git-send-email-maxime.ripard@free-electrons.com>
 <1401297069-7423-4-git-send-email-maxime.ripard@free-electrons.com>
 <20140528185051.GB22488@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ai3I8gwHc37+ASRI"
Content-Disposition: inline
In-Reply-To: <20140528185051.GB22488@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ai3I8gwHc37+ASRI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 28, 2014 at 07:50:51PM +0100, Mark Brown wrote:
> On Wed, May 28, 2014 at 07:11:07PM +0200, Maxime Ripard wrote:
>=20
> >  		axp_vcore_reg: dcdc2 {
> > +			vin-supply =3D <&axp_ipsout_reg>;
>=20
> >  		axp_ddr_reg: dcdc3 {
> > +			vin-supply =3D <&axp_ipsout_reg>;
>=20
> >  		axp_rtc_reg: ldo1 {
> > +			vin-supply =3D <&axp_ipsout_reg>;
>=20
> >  		axp_analog_reg: ldo2 {
> > +			vin-supply =3D <&axp_ipsout_reg>;
>=20
> >  		axp_pll_reg: ldo3 {
> > +			vin-supply =3D <&axp_ipsout_reg>;
>=20
> >  		axp_hdmi_reg: ldo4 {
> > +			vin-supply =3D <&axp_ipsout_reg>;
>=20
> >  		axp_mic_reg: ldo5 {
> > +			vin-supply =3D <&axp_ipsout_reg>;
>=20
> This is saying that every single regulator on the device is powered by a
> (presumably) single input called "vin".  This would certainly be an
> unusual package design...  As ever the name of the supply should follow
> the name of the pin on the device.

Not exactly. Each regulator has its own input pin, named
<regulator_name>in in the schematics, with the exception of LDO2 and
LDO4 that share the same pin.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--ai3I8gwHc37+ASRI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTjcmkAAoJEBx+YmzsjxAgQ58QAJomYp3WRAvP29ELx1IdAx+O
RbUhCVKnMXTFehe+Bg6cNmEYL6qw5cB5VGzh9+KtIlHWyk8clBCfYpg2L3nse9CD
i+/cllFystXf0CXEiX7INKZwohqcR4TjqbzM2eMxcxmRnmOp3GH01LmLGNR/bbxa
v6C2UB8Vw/gMv+QRynH5UaDg/mTPGLVA8KnDKJsjXRiiYkUNYkk/fwmeVHNZtCEm
OG6ejwYxiSx9kUIfcJkUyQv0Or08zqZ27NcfsVTFXsgos5u68Gmy4iJI8Rg+9a4v
wCxDboHtx/OPt09S7oPmnvXwS2iWCB3j6BJAXnGSBXqEjNABl49mfvl69H470ibV
/44CpH8iUXvVtcweooKKXQoEV9RDeyA0yDt0x40wh408VQTawDTTS8G/XnAY8XMm
JixO/9zroEc1fTZ46ft4PzzO6oGZ3DD9FKvAnHBQrrRO2GpXHt3AEZYMLoKsdYBs
XSYJxvjVuLtoMK0eGANa0Mi4MoVW1Sv1UghL11VyfPGtiGNkdpqv/niTiTrKEsUh
ePCkaEfLDI1CiSpID2JKuHgRPXE0VKaLSVpCfs90gtREREg8SUk/ClA1uTmZZ9qI
b8H+xPUe7r5TF8lDuUQJ7doMdh/9uYNDL+nw83NVu3xeVAH1hPljXN+qMLOm8724
bSBmydxRy4IIQy+gOPeR
=dM67
-----END PGP SIGNATURE-----

--ai3I8gwHc37+ASRI--
