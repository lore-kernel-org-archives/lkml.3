Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753450AbaEFQRj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 12:17:39 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:39591 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750962AbaEFQRh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 12:17:37 -0400
Date: Tue, 6 May 2014 11:16:53 -0500
From: Felipe Balbi <balbi@ti.com>
To: Guido =?iso-8859-1?Q?Mart=EDnez?= <guido@vanguardiasur.com.ar>
CC: LKML <linux-kernel@vger.kernel.org>, <bcousson@baylibre.com>,
        <tony@atomide.com>, <robh+dt@kernel.org>, <pawel.moll@arm.com>,
        <mark.rutland@arm.com>, <ijc+devicetree@hellion.org.uk>,
        <galak@codeaurora.org>, <linux@arm.linux.org.uk>,
        <linux-omap@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Ezequiel =?iso-8859-1?Q?Garc=EDa?= 
	<ezequiel@vanguardiasur.com.ar>
Subject: Re: [PATCH 3/4] ARM: dts: am335x-evmsk: use phandles for USB and DMA
 refs
Message-ID: <20140506161653.GL25849@saruman.home>
Reply-To: <balbi@ti.com>
References: <1398693512-5355-1-git-send-email-guido@vanguardiasur.com.ar>
 <1398693512-5355-3-git-send-email-guido@vanguardiasur.com.ar>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UeXZ3FjlYZvuln/G"
Content-Disposition: inline
In-Reply-To: <1398693512-5355-3-git-send-email-guido@vanguardiasur.com.ar>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--UeXZ3FjlYZvuln/G
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 28, 2014 at 10:58:31AM -0300, Guido Mart=EDnez wrote:
> Use phandles instead of unit adresses to reference usb and dma nodes.
> This makes the DT more robust and readable.
>=20
> Signed-off-by: Guido Mart=EDnez <guido@vanguardiasur.com.ar>

Acked-by: Felipe Balbi <balbi@ti.com>

> ---
>  arch/arm/boot/dts/am335x-evmsk.dts | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
>=20
> diff --git a/arch/arm/boot/dts/am335x-evmsk.dts b/arch/arm/boot/dts/am335=
x-evmsk.dts
> index ab23885..44b8d75 100644
> --- a/arch/arm/boot/dts/am335x-evmsk.dts
> +++ b/arch/arm/boot/dts/am335x-evmsk.dts
> @@ -364,28 +364,28 @@
>  &usb {
>  	status =3D "okay";
> =20
> -	control@44e10620 {
> +	&usb_ctrl_mod {
>  		status =3D "okay";
>  	};
> =20
> -	usb-phy@47401300 {
> +	&usb0_phy {
>  		status =3D "okay";
>  	};
> =20
> -	usb-phy@47401b00 {
> +	&usb1_phy {
>  		status =3D "okay";
>  	};
> =20
> -	usb@47401000 {
> +	&usb0 {
>  		status =3D "okay";
>  	};
> =20
> -	usb@47401800 {
> +	&usb1 {
>  		status =3D "okay";
>  		dr_mode =3D "host";
>  	};
> =20
> -	dma-controller@47402000  {
> +	&cppi41dma  {
>  		status =3D "okay";
>  	};
>  };
> --=20
> 1.9.2
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

--=20
balbi

--UeXZ3FjlYZvuln/G
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTaQr1AAoJEIaOsuA1yqRELgMP/08TnA+0ygwdhLvnv/kENDBV
fjgVCXjLwUy991enOg572OwqZWqXTAOWBBZRmDj8i3VJ3T27PHgnH2vlH/1cd35+
HgEO8EXNe1/EE5Jcp5ZSs7mFh/DsBJzvoevLW2ckKSuwoWFgOULr3YbE0sW1CI6o
SucCsQ0ePd2ZSG0LmSA1ISr/AKfVPPvb8N614WgPtg8wc27KjKmwUY33V8dRvjSO
Oc4D5jq6gUXRZcRDilyq0S7fnxe6VqY5nj/aYvTCrUXOesUXvTkRArZyKIT39mHj
hPqQ+yKRaCWbOk3OiOtpYZ3yEZeEuYsRmG6iToNuBGgK/2xe1zYbSkH1uCiVHW/B
XYpZl9wbzFk80LNXn92cjzklbBhRsRNn6EBdwpl5FQAZNtidLg9XBWDOIO966Wo2
rULACbamT6o8DgVt+WGJDWpzxczfCWDbJpZI9+TpoZLJ+xUX/OA9kF/Lh9EAKd56
wnCr8FFQ8On8qnCkatzSQEt0g+jmRo63hbsJLD6jakLTr1fQqC5uyyf1PidJYidL
sainci9Vw/tlI9mk25VDgbwSF1MlllZ+EOlXe5P3F9DdgGo+huVFicz2JlfRygbm
I/PBKy3rioSbn684koclpjkO7YIo0GB+ESM8dLcLQ7TPhICSMsObF7fVAZ5ACX/U
NhUPqfXct9YAnMK1SVdY
=Vexg
-----END PGP SIGNATURE-----

--UeXZ3FjlYZvuln/G--
