Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752474AbbATUFO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 15:05:14 -0500
Received: from down.free-electrons.com ([37.187.137.238]:59766 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751557AbbATUFL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 15:05:11 -0500
Date: Tue, 20 Jan 2015 21:02:16 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Vishnu Patekar <vishnupatekar0510@gmail.com>
Cc: dmitry.torokhov@gmail.com, hdegoede@redhat.com,
        ijc+devicetree@hellion.org.uk, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com,
        linux-input@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH v4 3/5] ARM: sunxi: dts: Add PS2 nodes to dtsi for A10
 and A20
Message-ID: <20150120200216.GV4367@lukather>
References: <1421417021-3247-1-git-send-email-vishnupatekar0510@gmail.com>
 <1421417021-3247-4-git-send-email-vishnupatekar0510@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6qFdnjy6dKaiDX/E"
Content-Disposition: inline
In-Reply-To: <1421417021-3247-4-git-send-email-vishnupatekar0510@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--6qFdnjy6dKaiDX/E
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Vishnu,

On Fri, Jan 16, 2015 at 07:33:39PM +0530, Vishnu Patekar wrote:
> Signed-off-by: VishnuPatekar <vishnupatekar0510@gmail.com>
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>

Why is there Hans Signed-off here?

> ---
>  arch/arm/boot/dts/sun4i-a10.dtsi |   16 ++++++++++++++++
>  arch/arm/boot/dts/sun7i-a20.dtsi |   16 ++++++++++++++++
>  2 files changed, 32 insertions(+)
>=20
> diff --git a/arch/arm/boot/dts/sun4i-a10.dtsi b/arch/arm/boot/dts/sun4i-a=
10.dtsi
> index 7b4099f..2c31242 100644
> --- a/arch/arm/boot/dts/sun4i-a10.dtsi
> +++ b/arch/arm/boot/dts/sun4i-a10.dtsi
> @@ -795,5 +795,21 @@
>  			#address-cells =3D <1>;
>  			#size-cells =3D <0>;
>  		};
> +
> +		ps20: ps2@01c2a000 {
> +			compatible =3D "allwinner,sun4i-a10-ps2";
> +			reg =3D <0x01c2a000 0x400>;
> +			interrupts =3D <62>;
> +			clocks =3D <&apb1_gates 6>;
> +			status =3D "disabled";
> +		};
> +
> +		ps21: ps2@01c2a400 {
> +			compatible =3D "allwinner,sun4i-a10-ps2";
> +			reg =3D <0x01c2a400 0x400>;
> +			interrupts =3D <63>;
> +			clocks =3D <&apb1_gates 7>;
> +			status =3D "disabled";
> +		};
>  	};
>  };
> diff --git a/arch/arm/boot/dts/sun7i-a20.dtsi b/arch/arm/boot/dts/sun7i-a=
20.dtsi
> index e21ce59..f35c691 100644
> --- a/arch/arm/boot/dts/sun7i-a20.dtsi
> +++ b/arch/arm/boot/dts/sun7i-a20.dtsi
> @@ -1093,5 +1093,21 @@
>  			#interrupt-cells =3D <3>;
>  			interrupts =3D <1 9 0xf04>;
>  		};
> +
> +		ps20: ps2@01c2a000 {
> +			compatible =3D "allwinner,sun4i-a10-ps2";
> +			reg =3D <0x01c2a000 0x400>;
> +			interrupts =3D <0 62 4>;
> +			clocks =3D <&apb1_gates 6>;
> +			status =3D "disabled";
> +		};
> +
> +		ps21: ps2@01c2a400 {
> +			compatible =3D "allwinner,sun4i-a10-ps2";
> +			reg =3D <0x01c2a400 0x400>;
> +			interrupts =3D <0 63 4>;

We recently switched to using includes and defines for these hardcoded
values.

Could you switch to it as well?

Thanks,
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--6qFdnjy6dKaiDX/E
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUvrRHAAoJEBx+YmzsjxAgd+MQAIeWkPb+Y0OxAQTHfVDXzZZD
90nOSCgFYdZhRAfHs/lD79f5VIM3A7Sj3Apcoicm79Dcft15l/Kt1QJuvUVsZd8Z
3ZWV/ffLPvksDFJB15cmsrBgXN3hrdJAqS7B9kGgdNTQp9/5mJQ7N3unqrUqEV7l
oOdlfw5eGw4LYMmsf54r3wsa6alzBLzo5rlU9YR9/II5KMbAQqjh9D01dJz7YGel
iJdY7HkOn8b4eB24N7jeoVHa2jpEzzfM/+d9FWTQ0MDkwuKtJ72XNO6NbqJ/q/UQ
UrJpxZZmKdjxFiBDEOzNATZWHLHY0IYmBtqwJelhsyDkV3a4IZV82evPmVVM65Tv
rSV8vZDIzYlMz2UF/ttoBaQOtfVqbeHPGZ7O+VDAz0F1x9xQh/EEpXXTb16sDi42
fLZFqW6dW9JId9wmNutUC/Q4zp+mCahkGkLtdQRZuOAQ+T3wlvoqbeWf38NOUCSo
U6Ir2pDtgj+l66eON6ofauuT3SXBy7TR7e+GIoT7WLncB8IXWGyJ/SL2oPayf02P
wUfTIimgB2mpl/ggytx4nw1a3vi2UttltEmCidfqffB0wVif0CmqmyVadWifvjN2
4x2IllNWC7lioE7oNaDoP0QOtfmC8oVeVJFvIJ9gdr3cVvqeijg9SflcDG9WYh57
IoZgpuSxr6BQdZoP8TWE
=0AWI
-----END PGP SIGNATURE-----

--6qFdnjy6dKaiDX/E--
