Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932893AbaHVRRN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 13:17:13 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:40408 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932393AbaHVRRK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 13:17:10 -0400
Date: Fri, 22 Aug 2014 12:16:41 -0500
From: Felipe Balbi <balbi@ti.com>
To: Dan Murphy <dmurphy@ti.com>
CC: <devicetree@vger.kernel.org>, <linux-input@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <dmitry.torokhov@gmail.com>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2] doc: dt/bindings: input: Fix drv260x binding document
Message-ID: <20140822171641.GE27616@saruman.home>
Reply-To: <balbi@ti.com>
References: <1408727539-15996-1-git-send-email-dmurphy@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BQPnanjtCNWHyqYD"
Content-Disposition: inline
In-Reply-To: <1408727539-15996-1-git-send-email-dmurphy@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--BQPnanjtCNWHyqYD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 22, 2014 at 12:12:19PM -0500, Dan Murphy wrote:
> Update the drv260x dt binding document:
> - Change the node name to the devices function not the
> device name.
> - Add vbat-supply to the example.
> - Fix indentation of the example.
>=20
> Signed-off-by: Dan Murphy <dmurphy@ti.com>

Reviewed-by: Felipe Balbi <balbi@ti.com>

> ---
>=20
> v2 - Address comments on indentation, node declaration, add vbat-supply,
> removed description as it did not make sense - https://patchwork.kernel.o=
rg/patch/4765141/
>=20
>  .../devicetree/bindings/input/ti,drv260x.txt       |   23 ++++++++++----=
------
>  1 file changed, 11 insertions(+), 12 deletions(-)
>=20
> diff --git a/Documentation/devicetree/bindings/input/ti,drv260x.txt b/Doc=
umentation/devicetree/bindings/input/ti,drv260x.txt
> index a9c8519..ee09c8f 100644
> --- a/Documentation/devicetree/bindings/input/ti,drv260x.txt
> +++ b/Documentation/devicetree/bindings/input/ti,drv260x.txt
> @@ -1,6 +1,4 @@
> -Texas Instruments - drv260x Haptics driver family
> -
> -The drv260x family serial control bus communicates through I2C protocols
> +* Texas Instruments - drv260x Haptics driver family
> =20
>  Required properties:
>  	- compatible - One of:
> @@ -37,15 +35,16 @@ Optional properties:
>  			  3.2 v.
>  Example:
> =20
> -drv2605l: drv2605l@5a {
> -		compatible =3D "ti,drv2605l";
> -		reg =3D <0x5a>;
> -		enable-gpio =3D <&gpio1 28 GPIO_ACTIVE_HIGH>;
> -		mode =3D <DRV260X_LRA_MODE>;
> -		library-sel =3D <DRV260X_LIB_LRA>;
> -		vib-rated-mv =3D <3200>;
> -		vib-overdriver-mv =3D <3200>;
> -};
> +haptics: haptics@5a {
> +	compatible =3D "ti,drv2605l";
> +	reg =3D <0x5a>;
> +	vbat-supply =3D <&vbat>;
> +	enable-gpio =3D <&gpio1 28 GPIO_ACTIVE_HIGH>;
> +	mode =3D <DRV260X_LRA_MODE>;
> +	library-sel =3D <DRV260X_LIB_LRA>;
> +	vib-rated-mv =3D <3200>;
> +	vib-overdriver-mv =3D <3200>;
> +}
> =20
>  For more product information please see the link below:
>  http://www.ti.com/product/drv2605
> --=20
> 1.7.9.5
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

--=20
balbi

--BQPnanjtCNWHyqYD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJT93r5AAoJEIaOsuA1yqREoboP/0qCml1IzbBPQvnhyOwo9bx0
Pus2zWyA/NAHXKI65HC4nh+9bqvKpiB8HUAyjtMBm6PcpEiYzx/4ewXKB7RmSPAS
bVRrgrRyrsR25Q43tm+u+mC1GhhfDAZ/5583XHhV/QHbtyf9nmgf5x34PvFGx3uO
3KDMOpu5CTpmb0p+Awa/VL33Uk9GojtVx/68kVnEzk3gg9/IOp26KiOcWpvhXMmU
wOAN8BlfGMcZHXAOwbxPeIa39qm+rYLU6A003uVZQj+YMISIUk8Z2s1QjjNkkUX7
4EmXMBlnvVP9k5nrUApHXMNcpFT7Gcaj6FJMor2PV1z6y+W7CFiSVuq1KCc0svuy
uYCJ7q0sBY1Dzl3WeoDqdxR/Lqa9nMl2+kZ/YHg4HbGXrWNZ3vARf3FonArXPRps
4tX468FaLzDzJa+Hl5k1gwdzXNH6iH1gofcDCde2myl4MGhKSyiKspZlY7mVgEK+
esgLZhI4FPTrrfZhdMBJz+hsJqXL8jo8rGG2QSK+hY2csg7HeTtvzg9pd8LKfiEZ
A5fAEVScMD3BRX0wsbh52bKpeUvLBTdnGxyApzqO9Ej/VGmuOrzAJ3agPY/L+Mur
hs3ITvhPHH2c+10vn46rZyE+PdOriL43TKOxnRzOMr7Ex77zn/kB91KaSPNPz7Z1
nKf+V6na1P8HPUjMQM9T
=P+xf
-----END PGP SIGNATURE-----

--BQPnanjtCNWHyqYD--
