Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753640AbaEFQSl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 12:18:41 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:39653 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753425AbaEFQSj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 12:18:39 -0400
Date: Tue, 6 May 2014 11:16:27 -0500
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
Subject: Re: [PATCH 2/4] ARM: dts: am335x-evm: use phandles for USB and DMA
 refs
Message-ID: <20140506161627.GJ25849@saruman.home>
Reply-To: <balbi@ti.com>
References: <1398693512-5355-1-git-send-email-guido@vanguardiasur.com.ar>
 <1398693512-5355-2-git-send-email-guido@vanguardiasur.com.ar>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4wkndigzIeYF6Hbg"
Content-Disposition: inline
In-Reply-To: <1398693512-5355-2-git-send-email-guido@vanguardiasur.com.ar>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--4wkndigzIeYF6Hbg
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 28, 2014 at 10:58:30AM -0300, Guido Mart=EDnez wrote:
> Use phandles instead of unit adresses to reference usb and dma nodes.
> This makes the DT more robust and readable.
>=20
> Signed-off-by: Guido Mart=EDnez <guido@vanguardiasur.com.ar>

Acked-by: Felipe Balbi <balbi@ti.com>

> ---
>  arch/arm/boot/dts/am335x-evm.dts | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
>=20
> diff --git a/arch/arm/boot/dts/am335x-evm.dts b/arch/arm/boot/dts/am335x-=
evm.dts
> index 6028217..e802627 100644
> --- a/arch/arm/boot/dts/am335x-evm.dts
> +++ b/arch/arm/boot/dts/am335x-evm.dts
> @@ -331,28 +331,28 @@
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

--4wkndigzIeYF6Hbg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTaQrbAAoJEIaOsuA1yqRE7f4QAJ5CYqdobdBY8+3jfVncqo45
IRclizz5bgJl4BWdu6RNDIB1/wozXPKwZZyeGTIvU9seeWNIwXFn8ILNVrMfzBJm
kvmm8O25DTu+0DUepXxx3h12ix3sMrS/hZRlwwRx8hse3A8BV8bz0GakMFoXxufw
pQIllRA+nytoZKbZA4mzaWkm99q9hCbGNbbXoAIWZJLZSKgl/RtPomXzrpzDJx3W
Xr9hTSX336A3oUxTsamhmoSeRUTVhT48OLH/8LZlqt3awatS46ezCNOURsXCcIig
cZNAsKiGfObpAz7ePuoEc9k7mpCLQlo/FILSjDIkPRUT+dJkv+uyhS18HDp2axKd
irx4G251jaf4sWNSvKOsnzCAPGfToyER1MpUcU/vRLoTtJRNpXc6NBT9D8zjMsz7
MEOEce9ThQWRLzQO/sd5UKJ3LgFU4pehtNy1ynV0kDauSJltn4Uf9lL+AhO9YTpf
2PoQZ2TdUeAm/BP7QmAbbastilxVEhV1uvZzVCtbATtcQarbv7Xx1VbaGXhtDu1k
i/jbo2skG8np498L+pG8MzPDz7xchQP9HptgptBvaRmurdCY0+/MlTZZM58x7zsK
H2qc0Ww4kv+MgKz+RZfW5kYd9s9pMGvg2SFVuzc9Rtn60PSg0SOabNB1OcknbLXX
C3bOFuTahomaOcjos/bo
=60Dh
-----END PGP SIGNATURE-----

--4wkndigzIeYF6Hbg--
