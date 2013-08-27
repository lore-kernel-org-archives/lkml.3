Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753838Ab3H0P2D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 11:28:03 -0400
Received: from top.free-electrons.com ([176.31.233.9]:37110 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753524Ab3H0P2C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 11:28:02 -0400
Date: Tue, 27 Aug 2013 17:27:57 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: oliver+list@schinagl.nl
Cc: arnd@arndb.de, gregkh@linuxfoundation.org,
        linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
        linus.walleij@linaro.org, linux-kernel@vger.kernel.org,
        andy.shevchenko@gmail.com, tomasz.figa@gmail.com,
        Oliver Schinagl <oliver@schinagl.nl>
Subject: Re: [PATCH 2/2] Add sunxi-sid to dts for sun4i, sun5i and sun7i
Message-ID: <20130827152757.GK2695@lukather>
References: <1377612785-7868-1-git-send-email-oliver+list@schinagl.nl>
 <1377612785-7868-3-git-send-email-oliver+list@schinagl.nl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SLauP2uySp+9cKYP"
Content-Disposition: inline
In-Reply-To: <1377612785-7868-3-git-send-email-oliver+list@schinagl.nl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--SLauP2uySp+9cKYP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Oliver,

Please prefix your patch with "ARM: sunxi: dt:"

On Tue, Aug 27, 2013 at 04:13:05PM +0200, oliver+list@schinagl.nl wrote:
> From: Oliver Schinagl <oliver@schinagl.nl>
>=20
> This patch shall add support for the sunxi-sid driver to the device
> table for sun4i, sun5i and sun7i.
  ^ tree    ^ A10, A13 and A20
>=20
> Signed-off-by: Oliver Schinagl <oliver@schinagl.nl>
> ---
>  arch/arm/boot/dts/sun4i-a10.dtsi | 5 +++++
>  arch/arm/boot/dts/sun5i-a13.dtsi | 5 +++++
>  arch/arm/boot/dts/sun7i-a20.dtsi | 6 ++++++
>  3 files changed, 16 insertions(+)
>=20
> diff --git a/arch/arm/boot/dts/sun4i-a10.dtsi b/arch/arm/boot/dts/sun4i-a=
10.dtsi
> index b2bd6e1..179e024 100644
> --- a/arch/arm/boot/dts/sun4i-a10.dtsi
> +++ b/arch/arm/boot/dts/sun4i-a10.dtsi
> @@ -267,6 +267,11 @@
>  			reg =3D <0x01c20c90 0x10>;
>  		};
> =20
> +		sid: eeprom@01c23800 {
> +			compatible =3D "allwinner,sun4i-sid";
> +			reg =3D <0x01c23800 0x10>;
> +		};
> +
>  		uart0: serial@01c28000 {
>  			compatible =3D "snps,dw-apb-uart";
>  			reg =3D <0x01c28000 0x400>;
> diff --git a/arch/arm/boot/dts/sun5i-a13.dtsi b/arch/arm/boot/dts/sun5i-a=
13.dtsi
> index 7363211..999fdb3 100644
> --- a/arch/arm/boot/dts/sun5i-a13.dtsi
> +++ b/arch/arm/boot/dts/sun5i-a13.dtsi
> @@ -223,6 +223,11 @@
>  			reg =3D <0x01c20c90 0x10>;
>  		};
> =20
> +		sid: eeprom@01c23800 {
> +			compatible =3D "allwinner,sun4i-sid";
> +			reg =3D <0x01c23800 0x10>;
> +		};
> +
>  		uart1: serial@01c28400 {
>  			compatible =3D "snps,dw-apb-uart";
>  			reg =3D <0x01c28400 0x400>;
> diff --git a/arch/arm/boot/dts/sun7i-a20.dtsi b/arch/arm/boot/dts/sun7i-a=
20.dtsi
> index fb81e78..bcf32b4 100644
> --- a/arch/arm/boot/dts/sun7i-a20.dtsi
> +++ b/arch/arm/boot/dts/sun7i-a20.dtsi
> @@ -217,6 +217,12 @@
>  			reg =3D <0x01c20c90 0x10>;
>  		};
> =20
> +		sid: eeprom@01c23800 {
> +			compatible =3D "allwinner,sun7i-sid";

I'd prefer to have sun7i-a20-sid here. We usually mention the soc name
as well in the compatible when it's not the good ol' A10.

> +			reg =3D <0x01c23800 0x200>;
> +		};
> +
> +

Drop the extra line

Thanks,
Maxime

>  		uart0: serial@01c28000 {
>  			compatible =3D "snps,dw-apb-uart";
>  			reg =3D <0x01c28000 0x400>;
> --=20
> 1.8.1.5
>=20

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--SLauP2uySp+9cKYP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSHMV8AAoJEBx+YmzsjxAg8yUP/2q/TeDEQkyukwV6MwGplGSA
NosnqPie1j+11i7FO8a5+qJLb9tA8dZcmAGJ3v28EHWwD6sTlPXqmzF0GjfPMkow
Ia1tW3ZT3XVtV4iTwVaPRz4FGNLCl88WEZ1hTTM0DcCxKueHm/gLiH53fkP5O3fc
C9bcFeQDVWUm5mCG8e/1fOIVXWjoUETg78FCMsNmSXsRinh+Hv4dIMWsgZ0FBLaP
U3qQCGuWoB62vRnWz2zu9+RF21A5HZwTlsNLHOHJQuJCiYSk0E7DnHiJF7oI5lIc
q9DYtfmb34OPB7mHo564+1eyfTX8eOVWR2NNE86AeZq6ituQ/nNTqopQ12O5E390
9fgU+KVViktPiqZDPXheL9oQxv6o0olMcYMK/xJmADS27uShcZO65VRQIk1AGNpZ
YkyGbuchH1MH8uLM60609Vp8B2688i3kTksXVcS+v8EOG+Yz/3FWS75kSC4EW0Tf
2WbFaYfH+MPgL9DpxYFK5iA6syn1KIIJFbzrY2sblsiB01j/vvvvHFj5dug73gIA
MQASZFstRlP74A/6JbKC1zfOCQEG9UGJHc62DMnl63IS/Uey8kkbnW4QYgzLML6I
3UN0yJqDDJHHvlJOCbrRXlUrg/80F/nmxif++1RkLEIA5a327wufb0w0zoHNsAjo
Vgsqedq+RwtZ/k/HaQze
=atDs
-----END PGP SIGNATURE-----

--SLauP2uySp+9cKYP--
