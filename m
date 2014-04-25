Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753586AbaDYQS1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 12:18:27 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:60194 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752139AbaDYQSW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 12:18:22 -0400
Date: Fri, 25 Apr 2014 11:18:03 -0500
From: Felipe Balbi <balbi@ti.com>
To: George Cherian <george.cherian@ti.com>
CC: <linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <balbi@ti.com>, <rogerq@ti.com>, <kishon@ti.com>, <rob@landley.net>,
        <galak@codeaurora.org>, <ijc+devicetree@hellion.org.uk>,
        <mark.rutland@arm.com>, <pawel.moll@arm.com>, <robh+dt@kernel.org>,
        <tony@atomide.com>, <anatol.pomozov@gmail.com>,
        <bcousson@baylibre.com>
Subject: Re: [PATCH v5 2/5] ARM: dts: am43xx clock data
Message-ID: <20140425161803.GU29632@saruman.home>
Reply-To: <balbi@ti.com>
References: <1395223803-4714-1-git-send-email-george.cherian@ti.com>
 <1395223803-4714-3-git-send-email-george.cherian@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="iytlPraCFSCqrfnM"
Content-Disposition: inline
In-Reply-To: <1395223803-4714-3-git-send-email-george.cherian@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--iytlPraCFSCqrfnM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 19, 2014 at 03:40:00PM +0530, George Cherian wrote:
> Add USB and USB PHY reference clock data
>=20
> Signed-off-by: George Cherian <george.cherian@ti.com>

Acked-by: Felipe Balbi <balbi@ti.com>

> ---
>  arch/arm/boot/dts/am43xx-clocks.dtsi | 32 ++++++++++++++++++++++++++++++=
++
>  1 file changed, 32 insertions(+)
>=20
> diff --git a/arch/arm/boot/dts/am43xx-clocks.dtsi b/arch/arm/boot/dts/am4=
3xx-clocks.dtsi
> index 142009c..5171d3e 100644
> --- a/arch/arm/boot/dts/am43xx-clocks.dtsi
> +++ b/arch/arm/boot/dts/am43xx-clocks.dtsi
> @@ -653,4 +653,36 @@
>  		clocks =3D <&clk_32768_ck>, <&clk_32k_tpm_ck>;
>  		reg =3D <0x4260>;
>  	};
> +
> +	usb_phy0_always_on_clk32k: usb_phy0_always_on_clk32k {
> +        	#clock-cells =3D <0>;
> +	        compatible =3D "ti,gate-clock";
> +	        clocks =3D <&usbphy_32khz_clkmux>;
> +	        ti,bit-shift =3D <8>;
> +	        reg =3D <0x2a40>;
> +	};
> +
> +	usb_phy1_always_on_clk32k: usb_phy1_always_on_clk32k {
> +        	#clock-cells =3D <0>;
> +	        compatible =3D "ti,gate-clock";
> +	        clocks =3D <&usbphy_32khz_clkmux>;
> +	        ti,bit-shift =3D <8>;
> +	        reg =3D <0x2a48>;
> +	};
> +
> +	usb_otg_ss0_refclk960m: usb_otg_ss0_refclk960m {
> +		#clock-cells =3D <0>;
> +	        compatible =3D "ti,gate-clock";
> +		clocks =3D <&dpll_per_clkdcoldo>;
> +	        ti,bit-shift =3D <8>;
> +	        reg =3D <0x8a60>;
> +	};
> +
> +	usb_otg_ss1_refclk960m: usb_otg_ss1_refclk960m {
> +		#clock-cells =3D <0>;
> +	        compatible =3D "ti,gate-clock";
> +		clocks =3D <&dpll_per_clkdcoldo>;
> +	        ti,bit-shift =3D <8>;
> +		reg =3D <0x8a68>;
> +	};
>  };
> --=20
> 1.8.3.1
>=20

--=20
balbi

--iytlPraCFSCqrfnM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTWoq7AAoJEIaOsuA1yqREzNEP/02qpimll/4CLC1JI0N3pD04
cnN6Ta0jqqq8GZ94kcunXk0ApvrfV8Ns4CFFwNNa3LycHpc5yiEHiUJeYq2+dH1c
FpH0tlmHai7+0RaPUHSPPrDJXA1y2hdFpwpVSRP5FIiiS8ORqNIiC01vqDEHVCXy
BMO2OIsLJxdEI6fTdnHMrjtwyNktWoUlwt6qAzvcoHE9xw7mi62Q7t4WOZ6Jvsir
5hN8sOsqtyZqLpmpFHL9xaqJ517ZuwWFYMApnpQ39+iYiYalp7+IBxxpaR3oKD5i
VuNbOZNpvLrxvd0lMHs5UYmA+C+9hvQHoUbviLjSSfGz97VKWG9KD4tqlnsTk5HP
2AniHYdqAxPHP4T/N/AIma7I8IxxgLbN/kpgGBHXC8Th08TXGwk+W0/ipBZ3Pu3H
OFXCSPQky1gyfFdMvIR/W8nLeROkABtkDmeJh+Vn98wzDBwpQ+J6QGlPE974xNr1
ecFfr8plV6Vm9uBhYNLhf6m1hc2gcqd5NCh3uiVEQRPVkJ/iMIukWjVBmh+7F0Ob
7DVyeAPZ3wUC+Jux7jb7ygnEwo/UFzmfKDpWWfU6tF42gZzLSPsOZSvqcRhnGsI9
vmOo1zSkJfnVksiBtdSKH1ykzTe2iLCfeqSmWOIWkxVGJa60F1svsjys6KT9Vu3/
If7tT6KtbUXSAe9kr4qT
=BeiK
-----END PGP SIGNATURE-----

--iytlPraCFSCqrfnM--
