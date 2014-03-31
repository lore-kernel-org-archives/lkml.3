Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753870AbaCaOuo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 10:50:44 -0400
Received: from top.free-electrons.com ([176.31.233.9]:46275 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754013AbaCaOuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 10:50:06 -0400
Date: Mon, 31 Mar 2014 16:47:31 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Thierry Reding <thierry.reding@gmail.com>, linux-pwm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] ARM: sun7i: dt: add PWM support
Message-ID: <20140331144731.GI26751@lukather>
References: <1396267649-18009-1-git-send-email-alexandre.belloni@free-electrons.com>
 <1396267649-18009-4-git-send-email-alexandre.belloni@free-electrons.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="16qp2B0xu0fRvRD7"
Content-Disposition: inline
In-Reply-To: <1396267649-18009-4-git-send-email-alexandre.belloni@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--16qp2B0xu0fRvRD7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 31, 2014 at 02:07:28PM +0200, Alexandre Belloni wrote:
> Adds the PWM bindings for the Allwinner A20.
> Also adds the pinctrl descriptions for both PWM channels.
>=20
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> ---
>  arch/arm/boot/dts/sun7i-a20.dtsi | 22 ++++++++++++++++++++++
>  1 file changed, 22 insertions(+)
>=20
> diff --git a/arch/arm/boot/dts/sun7i-a20.dtsi b/arch/arm/boot/dts/sun7i-a=
20.dtsi
> index 6f25cf559ad0..0dd15fcb8955 100644
> --- a/arch/arm/boot/dts/sun7i-a20.dtsi
> +++ b/arch/arm/boot/dts/sun7i-a20.dtsi
> @@ -366,6 +366,20 @@
>  			#size-cells =3D <0>;
>  			#gpio-cells =3D <3>;
> =20
> +			pwm0_pins_a: pwm0@0 {
> +				allwinner,pins =3D "PB2";
> +				allwinner,function =3D "pwm";
> +				allwinner,drive =3D <0>;
> +				allwinner,pull =3D <0>;
> +			};
> +
> +			pwm1_pins_a: pwm1@0 {
> +				allwinner,pins =3D "PI3";
> +				allwinner,function =3D "pwm";
> +				allwinner,drive =3D <0>;
> +				allwinner,pull =3D <0>;
> +			};
> +
>  			uart0_pins_a: uart0@0 {
>  				allwinner,pins =3D "PB22", "PB23";
>  				allwinner,function =3D "uart0";
> @@ -446,6 +460,14 @@
>  			clocks =3D <&osc24M>;
>  		};
> =20
> +		pwm: pwm@01c20e00 {
> +			compatible =3D "allwinner,sun7i-pwm";
> +			reg =3D <0x01c20e00 0xc>;
> +			clocks =3D <&osc24M>;
> +			#pwm-cells =3D <3>;
> +			status =3D "disabled";
> +		};
> +

Can you make this two separate patches? One for the muxing options and
one for the introduction of the new IP.

Thanks!
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--16qp2B0xu0fRvRD7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJTOYACAAoJEBx+YmzsjxAgqxEP/jP/Xf4b7e5yIKWnXc7szMse
E3gtR26EL8FZjkbYVoxKb7OXfb9avuvHBb7yewm0Csbld+OIzIrF3GRuBR1NydRa
1B4ZvzM3WEzq6kS60k6ZiZiUewfai5+o+Ouq+Gg3mHK69H6VJndZ37jZttF7Dw2h
YVkIBICa2DVjEOfOa/2JgXAvooPd9kA6dtqXeXriTnGOcLIlqnQDTNnV59rbfepo
yMuuPngdzBn4B8qBH/cDUzMozKOZ1RBBlFe4UiqFgdk8g5UonU01MAAKi7DVvvWZ
83gAEtbdyRbIkKfbMOLq5/LrenM7YWzal3WdYtk857Ih2FoLxXqviSlr1dtcD/aH
7K0lQzmWrexQr/U08UfNCVKTlFaLheO//Qdg2fepcRuuFo7XqZUk3X9fsaC3iCrh
XPTxOWT+OLfHVXncvwkdFagPpzLBxrgwstddsCNChtnoGHTEgyRwkNpDlddY2RwM
c8NhG4m1NQBY1eJnUiXLR8FGr4zB9VchQTRyYJ5uBUtYWccisLGANFAaC82GjYa4
Ox1wz5WkFEGzuRK8D7ETyPFj5yESL+7YMtKFFl1Y4+2mSgyOOCvYOvksEBd8mYXg
ViYp2fmz7r6PFtsBdcngN50ovJtj/takpEezD2n7IToASowoSN6gTilPhRS9MsEu
1oQLzS6pE2dK/2WFDpLl
=MXUn
-----END PGP SIGNATURE-----

--16qp2B0xu0fRvRD7--
