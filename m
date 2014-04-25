Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753843AbaDYQSz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 12:18:55 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:33112 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752359AbaDYQSt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 12:18:49 -0400
Date: Fri, 25 Apr 2014 11:18:27 -0500
From: Felipe Balbi <balbi@ti.com>
To: George Cherian <george.cherian@ti.com>
CC: <linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <balbi@ti.com>, <rogerq@ti.com>, <kishon@ti.com>, <rob@landley.net>,
        <galak@codeaurora.org>, <ijc+devicetree@hellion.org.uk>,
        <mark.rutland@arm.com>, <pawel.moll@arm.com>, <robh+dt@kernel.org>,
        <tony@atomide.com>, <anatol.pomozov@gmail.com>,
        <bcousson@baylibre.com>
Subject: Re: [PATCH v5 4/5] ARM: dts: am437x-gp-evm: Enable USB
Message-ID: <20140425161827.GW29632@saruman.home>
Reply-To: <balbi@ti.com>
References: <1395223803-4714-1-git-send-email-george.cherian@ti.com>
 <1395223803-4714-5-git-send-email-george.cherian@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tpZe61tYkA9f+p/0"
Content-Disposition: inline
In-Reply-To: <1395223803-4714-5-git-send-email-george.cherian@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--tpZe61tYkA9f+p/0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 19, 2014 at 03:40:02PM +0530, George Cherian wrote:
> Enable
> 	- USB PHY
> 	- USB
> for am437x-gp-evm
>=20
> Signed-off-by: George Cherian <george.cherian@ti.com>
> Acked-by: Roger Quadros <rogerq@ti.com>

Acked-by: Felipe Balbi <balbi@ti.com>

> ---
>  arch/arm/boot/dts/am437x-gp-evm.dts | 18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
>=20
> diff --git a/arch/arm/boot/dts/am437x-gp-evm.dts b/arch/arm/boot/dts/am43=
7x-gp-evm.dts
> index df8798e..9e57538 100644
> --- a/arch/arm/boot/dts/am437x-gp-evm.dts
> +++ b/arch/arm/boot/dts/am437x-gp-evm.dts
> @@ -125,3 +125,21 @@
>  	pinctrl-0 =3D <&mmc1_pins>;
>  	cd-gpios =3D <&gpio0 6 GPIO_ACTIVE_HIGH>;
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

--tpZe61tYkA9f+p/0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTWorTAAoJEIaOsuA1yqREjyoP/RkMddPrZKtmpJxfsCaLIXSO
wH+omSC7dw6WEpeMkM8wDvloimHI7ZaXEJnDLwh51v8o2Z7X7kGChATpYGCQzi1W
R4kss4dmxdFwbPFBdFoPlwKSX0bz/07c8g5uccrWHaX5eNh1zV9h9is5IDszRzTb
mK42nhmZ6RyF5255jQ9rfFf80QVZQJaDwn58/E77SVfsUYB0VjTu6IEF7eQgN5BK
cY3c5jy6mgS4oCXIZQaF5zhtGMuBqtqpINiGjybBJvoefFrETbT5/fHIMXxcbJbS
7NUEsYpf3JZi7p8ifE2qwRSele3JcF49yb0AFXv5QJW80ExRv3brJ0V2et1LfQpq
r24+FXu7rbRFT+8XcsV9YPO5d9z8rd8JXsYmE/g/V1hp/UgFbKCY1RbXzx1/IR4Q
wcGn09/clXjS1RnWzpD+GrB+XdH2AjU/z/2EAB8Nsmy8X/VJt/Nx4jfyanneY9QL
fAjoDehCKGLM+DnbDb4wLjlqF49hJSpT5zOR0S8oosT6PfLZGb4UUCxu37q/yYi2
EqQ8od8OQrlbccYD6OZerQUKOjZacfxwsfuXCbL6ujdAFuoxC5I5yU6eXqeRQB59
kZMpbACLRkwtATeViZMTdSnDyjcrIFyB0LDtDPPe0T44aICL1m/g0O//xVajCt1/
0T7YNqFnAqex9czwmFzd
=xzOI
-----END PGP SIGNATURE-----

--tpZe61tYkA9f+p/0--
