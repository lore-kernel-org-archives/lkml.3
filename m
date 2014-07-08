Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754813AbaGHNlw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 09:41:52 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:52770 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754076AbaGHNiv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 09:38:51 -0400
Date: Tue, 8 Jul 2014 08:38:37 -0500
From: Felipe Balbi <balbi@ti.com>
To: Keerthy <j-keerthy@ti.com>
CC: <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <mark.rutland@arm.com>,
        <galak@codeaurora.org>, <robh+dt@kernel.org>, <linux@arm.linux.org.uk>,
        <balbi@ti.com>, <tony@atomide.com>, <kishon@ti.com>,
        <broonie@kernel.org>
Subject: Re: [PATCH v2 4/7] ARM: dts: AM437x: Fix i2c nodes indentation
Message-ID: <20140708133837.GF25811@saruman.home>
Reply-To: <balbi@ti.com>
References: <1404814597-4404-1-git-send-email-j-keerthy@ti.com>
 <1404814597-4404-5-git-send-email-j-keerthy@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1Y7d0dPL928TPQbc"
Content-Disposition: inline
In-Reply-To: <1404814597-4404-5-git-send-email-j-keerthy@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--1Y7d0dPL928TPQbc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 08, 2014 at 03:46:34PM +0530, Keerthy wrote:
> Fix i2c nodes indentation.
>=20
> Signed-off-by: Keerthy <j-keerthy@ti.com>

Reviewed-by: Felipe Balbi <balbi@ti.com>

> ---
>  arch/arm/boot/dts/am437x-gp-evm.dts |   13 ++++++-------
>  1 file changed, 6 insertions(+), 7 deletions(-)
>=20
> diff --git a/arch/arm/boot/dts/am437x-gp-evm.dts b/arch/arm/boot/dts/am43=
7x-gp-evm.dts
> index 003766c..85ca430 100644
> --- a/arch/arm/boot/dts/am437x-gp-evm.dts
> +++ b/arch/arm/boot/dts/am437x-gp-evm.dts
> @@ -257,16 +257,15 @@
>  };
> =20
>  &i2c0 {
> -        status =3D "okay";
> -        pinctrl-names =3D "default";
> -        pinctrl-0 =3D <&i2c0_pins>;
> +	status =3D "okay";
> +	pinctrl-names =3D "default";
> +	pinctrl-0 =3D <&i2c0_pins>;
>  };
> =20
>  &i2c1 {
> -        status =3D "okay";
> -        pinctrl-names =3D "default";
> -        pinctrl-0 =3D <&i2c1_pins>;
> -
> +	status =3D "okay";
> +	pinctrl-names =3D "default";
> +	pinctrl-0 =3D <&i2c1_pins>;
>  	pixcir_ts@5c {
>  		compatible =3D "pixcir,pixcir_tangoc";
>  		pinctrl-names =3D "default";
> --=20
> 1.7.9.5
>=20

--=20
balbi

--1Y7d0dPL928TPQbc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTu/RdAAoJEIaOsuA1yqRECTsP/2Lyn3PYaINT9bj7C6GKzsAy
oBbf9bop2uOHTN/zsRRly1nKvCk2mjv7ljXbYX4a+iQ2z1bIKHMtbpF1HDqZUKKV
OznZNIdPwpMdDm1vVk/c/MuBsczmYqfZ3LlxR+BNW3xi5kMQAsdcvDQk8MkCsOZs
hd4RUtaeTMcCTPwZtyDpvGsbvf1rOwavncqKl5qDCDrNLLdZvS25ctjqYPMzaOlx
E1TW/r3YAKSkiCkx/KiTVpamGXi9mWdMSzVEH2QLbCmzF0jjwf7qSC/amOL3/kAC
DtJSBjPu3gBesAG5k/NAXWz4ltybHnHAWFIcFbcgQyXyWX09mrnSPPwdIT6ROeDR
64E1hpKx1h0lUTe7sLccJMiOqerecHVIx5+VV0lZMqTZJ9JJa2nBpqFsuCr6f/HY
0Usa49jsGiG4gqBdT53hWHWsg/DQ1jKBDHOfndMcBNT/2vcS9y+Q+YKdykcS3Y9I
Nt9BP/hFypBpNHAVaPFlPawnS0WqQMJ24pbSFEf8LurISIPHX2c5NPuk4RvCiZsS
v+LnNm4CdQJ7Dnl+177h/sDvMYiHB/8iYOBCleqYdVkTiMwTNg4MIGj5xahxMvIM
fo5LSsP+NM1IY3kCExCuNU6DXSQV2G9G0Oe5sGcLAZ+N8w5KTmE/1zSY8xYSPi13
BDxXrc8iLlx25E//XtCR
=lLrm
-----END PGP SIGNATURE-----

--1Y7d0dPL928TPQbc--
