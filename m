Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753876AbaDYQTE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 12:19:04 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:53196 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752783AbaDYQS7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 12:18:59 -0400
Date: Fri, 25 Apr 2014 11:18:37 -0500
From: Felipe Balbi <balbi@ti.com>
To: George Cherian <george.cherian@ti.com>
CC: <linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <balbi@ti.com>, <rogerq@ti.com>, <kishon@ti.com>, <rob@landley.net>,
        <galak@codeaurora.org>, <ijc+devicetree@hellion.org.uk>,
        <mark.rutland@arm.com>, <pawel.moll@arm.com>, <robh+dt@kernel.org>,
        <tony@atomide.com>, <anatol.pomozov@gmail.com>,
        <bcousson@baylibre.com>
Subject: Re: [PATCH v5 5/5] ARM: dts: am43x-epos-evm: Enable USB
Message-ID: <20140425161837.GX29632@saruman.home>
Reply-To: <balbi@ti.com>
References: <1395223803-4714-1-git-send-email-george.cherian@ti.com>
 <1395223803-4714-6-git-send-email-george.cherian@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YG0IFkGWIt6MbjRk"
Content-Disposition: inline
In-Reply-To: <1395223803-4714-6-git-send-email-george.cherian@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--YG0IFkGWIt6MbjRk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 19, 2014 at 03:40:03PM +0530, George Cherian wrote:
> Enable
> 	- USB PHY
> 	- USB
>=20
> for am43x-epos-evm
>=20
> Signed-off-by: George Cherian <george.cherian@ti.com>
> Acked-by: Roger Quadros <rogerq@ti.com>

Acked-by: Felipe Balbi <balbi@ti.com>

> ---
>  arch/arm/boot/dts/am43x-epos-evm.dts | 18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
>=20
> diff --git a/arch/arm/boot/dts/am43x-epos-evm.dts b/arch/arm/boot/dts/am4=
3x-epos-evm.dts
> index 167dbc8..1a4946a 100644
> --- a/arch/arm/boot/dts/am43x-epos-evm.dts
> +++ b/arch/arm/boot/dts/am43x-epos-evm.dts
> @@ -367,3 +367,21 @@
>  	pinctrl-0 =3D <&spi1_pins>;
>  	status =3D "okay";
>  };
> +
> +&usb2_phy1 {
> +	status =3D "okay";
> +};
> +
> +&usb1 {
> +	dr_mode =3D "peripheral";
> +	status =3D "okay";
> +};
> +
> +&usb2_phy2 {
> +	status =3D "okay";
> +};
> +
> +&usb2 {
> +	dr_mode =3D "host";
> +	status =3D "okay";
> +};
> --=20
> 1.8.3.1
>=20

--=20
balbi

--YG0IFkGWIt6MbjRk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTWordAAoJEIaOsuA1yqRE6nAP/2Fosa5jEQXbJ/j6GbQTe3md
4ZM6VlIGOcjoQmRIW4VsVvw/N8eLy4VHDOfAuz0a/d6UXcT6iwPz/x2snneoiL1c
5kYCasr6qz+6btIVda191q8I9IWA9iDijyMQ4pNcHyWH7JcnlUp2K4MzWMSlir4u
Fe1CRP6Mt0e2jL2GzQqMhta2px2vzPnbghcIYat7U7kHMTiuw6NNYQ4I4TSDFE86
0tcwoHMtT8SOeOIgbZBZpHiPoS4yxJWMalmqbn3CWo1nsddA/Wu70+zL0LZK7B7P
75hobfrzI+6cRiF5xsXGT43O6InoPGAl6Htb6egtO2U8+DaibYGg/8h5iYkHNKbT
CpenRNqUEoUQb4fghvEVOpAH+MJ54fgeMVF7Y5Yjo530Bgb0BHo0ZoWyYgWO4HfV
FXwYLGpTy+qKy3I8G2MT4iTw9AzOZDR7kMT+fdrKTHyTHbhsOmU0nGasNFxQAwna
7yAHig55tbrC9sLxFVd2MklsqszZaY1n5YnexMQvPrUzG+C+yJrv2aJ1eSvjJj+c
1d/WllWR3yEiJCdYW8yNhcASnxlYd/hmBG9vGcZInisj6OT7VC+CTbDRO1P5Js8h
ceBDlW05uIQout13r8xSxpyoEMvVMRABjFcC7zsa1shD78t7E8YX/5RsuWl0VNzp
SBxg8ICWk0lKIpiddTom
=yBV0
-----END PGP SIGNATURE-----

--YG0IFkGWIt6MbjRk--
