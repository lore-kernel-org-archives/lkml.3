Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752920AbbATUFS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 15:05:18 -0500
Received: from down.free-electrons.com ([37.187.137.238]:59773 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751678AbbATUFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 15:05:12 -0500
Date: Tue, 20 Jan 2015 21:03:07 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Vishnu Patekar <vishnupatekar0510@gmail.com>
Cc: dmitry.torokhov@gmail.com, hdegoede@redhat.com,
        ijc+devicetree@hellion.org.uk, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com,
        linux-input@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH v4 4/5] ARM: sunxi: dts: Add A10/A20 PS2 pin muxing
 options
Message-ID: <20150120200307.GW4367@lukather>
References: <1421417021-3247-1-git-send-email-vishnupatekar0510@gmail.com>
 <1421417021-3247-5-git-send-email-vishnupatekar0510@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qndya+I13rh6QJ0p"
Content-Disposition: inline
In-Reply-To: <1421417021-3247-5-git-send-email-vishnupatekar0510@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qndya+I13rh6QJ0p
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 16, 2015 at 07:33:40PM +0530, Vishnu Patekar wrote:
> Signed-off-by: VishnuPatekar <vishnupatekar0510@gmail.com>
> ---
>  arch/arm/boot/dts/sun4i-a10.dtsi |   14 ++++++++++++++
>  arch/arm/boot/dts/sun7i-a20.dtsi |   14 ++++++++++++++
>  2 files changed, 28 insertions(+)
>=20
> diff --git a/arch/arm/boot/dts/sun4i-a10.dtsi b/arch/arm/boot/dts/sun4i-a=
10.dtsi
> index 2c31242..8fade3e 100644
> --- a/arch/arm/boot/dts/sun4i-a10.dtsi
> +++ b/arch/arm/boot/dts/sun4i-a10.dtsi
> @@ -629,6 +629,20 @@
>  				allwinner,drive =3D <0>;
>  				allwinner,pull =3D <0>;
>  			};
> +
> +			ps20_pins_a: ps20@0 {
> +				allwinner,pins =3D "PI20", "PI21";
> +				allwinner,function =3D "ps2";
> +				allwinner,drive =3D <0>;
> +				allwinner,pull =3D <0>;
> +			};
> +
> +			ps21_pins_a: ps21@0 {
> +				allwinner,pins =3D "PH12", "PH13";
> +				allwinner,function =3D "ps2";
> +				allwinner,drive =3D <0>;
> +				allwinner,pull =3D <0>;
> +			};
>  		};
> =20
>  		timer@01c20c00 {
> diff --git a/arch/arm/boot/dts/sun7i-a20.dtsi b/arch/arm/boot/dts/sun7i-a=
20.dtsi
> index f35c691..f9dd274 100644
> --- a/arch/arm/boot/dts/sun7i-a20.dtsi
> +++ b/arch/arm/boot/dts/sun7i-a20.dtsi
> @@ -866,6 +866,20 @@
>  				    allwinner,drive =3D <0>;
>  				    allwinner,pull =3D <0>;
>  			};
> +
> +			ps20_pins_a: ps20@0 {
> +				allwinner,pins =3D "PI20", "PI21";
> +				allwinner,function =3D "ps2";
> +				allwinner,drive =3D <0>;
> +				allwinner,pull =3D <0>;
> +			};
> +
> +			ps21_pins_a: ps21@0 {
> +				allwinner,pins =3D "PH12", "PH13";
> +				allwinner,function =3D "ps2";
> +				allwinner,drive =3D <0>;
> +				allwinner,pull =3D <0>;
> +			};
>  		};

Same thing here, we're using defines now for the values in ,drive and
,pull, please use them.

Thanks,
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--qndya+I13rh6QJ0p
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUvrR7AAoJEBx+YmzsjxAgPDcP+QHX4946KR2maCOdzyzno7Ug
SbSprBQDlaZZgBVM1eJWu6kNObNH/v42Iu5x1UgeGRSlO2R6oEUTtI0nWldxxHvu
3gYjiS9TaFKnVzbxhv7OVSv7rrxTyVVf7BCJpG3Yc2URpDswzLkCsFJmoP5pBKWT
wrWUNn0tL6waeo4J61TE/G0MYk3x32gqaRNM8WNmbgw8oJ0Z6FEblgqocmZbTT5b
LcARttwBVrUWFi7taqETdw5cPBu7VAcWqA/AOrB0xPikHUphUeQYuf3on4ky2EU/
gEoNedSrUtJS54zJdmRlv/LO0uvN/0KwdfSX8Qx3yLn47NiIqaLxhJYfgsebe+p9
lrBp0GMzSKHWKmWOG2Py9+WII24k29kCCUsdVEOCoJqdS9ZH9Mny5rge+p9zu8mA
Pk5FNt5yU3eqXoMXq0jEO/wgewdLJw4mNowZFYhNzRC9Rzrri+Cw+LznieJzphM+
hN5A9rEX7p/RBdQEpZeCa62Qnj2C3xSYZ8ov+2M0F2XCHITGz3ZTLTOJaeCYSJt3
XRfEpv6nlrzsOGRr7mN53pdzjXNoOPAO+PRA5d2qEyThbyObScHKHs55ck7Ab7Ln
ec4QEMExaX0G5VvoLU0dpNkuNl6Rg5OtI6sEwk/1RQrNfGU0gpstam/h3RBxwLJQ
FCDlRxf2a5ZE2D8t3LSh
=qYrF
-----END PGP SIGNATURE-----

--qndya+I13rh6QJ0p--
