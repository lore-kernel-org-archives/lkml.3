Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754816AbaLHWUI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 17:20:08 -0500
Received: from down.free-electrons.com ([37.187.137.238]:40201 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752540AbaLHWUE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 17:20:04 -0500
Date: Mon, 8 Dec 2014 23:15:09 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: vishnupatekar <vishnupatekar0510@gmail.com>
Cc: linux-sunxi@googlegroups.com, dmitry.torokhov@gmail.com,
        linux@arm.linux.org.uk, leafy.myeh@newbietech.com, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [PATCHv2 1/3] sunxi:dts-bindings:input:ps2 bindings for A10/A20
 ps2.
Message-ID: <20141208221509.GM8739@lukather>
References: <1417907719-26775-1-git-send-email-VishnuPatekar0510@gmail.com>
 <1417907719-26775-2-git-send-email-VishnuPatekar0510@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BHMq0+oGliEfCAkH"
Content-Disposition: inline
In-Reply-To: <1417907719-26775-2-git-send-email-VishnuPatekar0510@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--BHMq0+oGliEfCAkH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Sun, Dec 07, 2014 at 04:45:17AM +0530, vishnupatekar wrote:
> A10 and A20 have same PS2 addresses, clocks, interrupts.
> added compatible as allwinner,sun4i-a10-ps2.
>=20
> Signed-off-by: vishnupatekar <VishnuPatekar0510@gmail.com>

You should have your real name here.

> ---
>  .../bindings/input/allwinner,sunxi-ps2.txt         |   23 ++++++++++++++=
++++++
>  1 file changed, 23 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/input/allwinner,sun=
xi-ps2.txt
>=20
> diff --git a/Documentation/devicetree/bindings/input/allwinner,sunxi-ps2.=
txt b/Documentation/devicetree/bindings/input/allwinner,sunxi-ps2.txt
> new file mode 100644
> index 0000000..3a8919a
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/input/allwinner,sunxi-ps2.txt
> @@ -0,0 +1,23 @@
> +* Device tree bindings for Allwinner A10, A20 PS2 host controller

> +A20 PS2 is dual role controller(PS2 host and PS2 device). These
> +bindings are for PS2 host controller. IBM compliant IBM PS2 and
> AT-compatible keyboard and mouse can be connected.

This should be wrapped to 80 chars.

> +Required properties:
> +
> + - reg             : Offset and length of the register set for the devic=
e.
> + - compatible      : Should one of the following:
> +                     - "allwinner,sun7i-a20-ps2"
> +                     - "allwinner,sun4i-a10-ps2"
> + - interrupts      : The interrupt line connected to the PS2.
> + - clocks          : The gate clk connected to the PS2.
> +
> +
> +Example:
> +	ps20: ps2@0x01c2a000 {
> +		compatible =3D "allwinner,sun7i-a20-ps2";
> +		reg =3D <0x01c2a000 0x400>;
> +		interrupts =3D <0 62 4>;
> +		clocks =3D <&apb1_gates 6>;
> +		status =3D "disabled";
> +	};
> --=20
> 1.7.9.5
>=20

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--BHMq0+oGliEfCAkH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUhiLtAAoJEBx+YmzsjxAgRlMP/09cg3KTM/GxiCueSGkULDVQ
YoUhLDJ4REyIZ+Wl0PIc3kE7oL5gdUhIVVk7pFyylTOxkHwF3tqxNBLJ6gfoFFdM
e+RcNiFzOrzrBtVJwbH702UcmgGIh/fVd6whH/WqDhofoEMTVHf7XhiojyZfLS3I
JN3w3B1/b4F3xHesaYiY6i8wtG1vOePSbJsypiFQsyb9BFFI6zRt8nXcSc7BzjLL
IWwkrycorVYSJWZbX2Z3qVMu/8Bwo3/kLtCjfcB7RBZxVzE0aNR/t++6N8+Au5G4
gwiq87qtN83e6Nm9E76iJ07E+UxiJ1QXj2NT1Vr2FF9NBtxK5GL1eu/PnMx59KoU
+zQeJXuQO0ETnwNYUZcSYuPqcwWruOABq3H1nnIBQdN0o74FsAufKpdJnxCb3HY6
Qz+IY32yw7P3LTV1Z35UQ6uSsVoUcvJ1ewkb+u/BrnFhweKgwCn93ByWajybKuK1
IM5ab0nihSpZSZUmbmeMknpUgYEClCHnXMa1Q/ELa20DR5OjHk4IbNC3GtD3tlhj
tRS3ER5EUDWZvy3B2VHluIPFbYiOgNRVyUlXcs/RhYmEhIPjo6DrC5D2+1U6w03i
Jt/HibnDn2bnwbpXwBjPZvWUHW7zrEVh3bw3f8WJzGEqWX45MqMtuoI2wEbimh3Z
A2X3WPrReI2MCi32bZXN
=OWGM
-----END PGP SIGNATURE-----

--BHMq0+oGliEfCAkH--
