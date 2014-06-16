Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754798AbaFPNZH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 09:25:07 -0400
Received: from top.free-electrons.com ([176.31.233.9]:55352 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751478AbaFPNZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 09:25:04 -0400
Date: Mon, 16 Jun 2014 15:24:19 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Alexander Bersenev <bay@hackerdom.ru>
Cc: linux-sunxi@googlegroups.com, david@hardeman.nu,
        devicetree@vger.kernel.org, galak@codeaurora.org,
        grant.likely@linaro.org, ijc+devicetree@hellion.org.uk,
        james.hogan@imgtec.com, linux-arm-kernel@lists.infradead.org,
        linux@arm.linux.org.uk, m.chehab@samsung.com, mark.rutland@arm.com,
        pawel.moll@arm.com, rdunlap@infradead.org, robh+dt@kernel.org,
        sean@mess.org, srinivas.kandagatla@st.com, wingrime@linux-sunxi.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
Subject: Re: [PATCH v9 4/5] ARM: sunxi: Add IR controllers on A20 to dtsi
Message-ID: <20140616132419.GA9757@lukather>
References: <1402250893-5412-1-git-send-email-bay@hackerdom.ru>
 <1402250893-5412-5-git-send-email-bay@hackerdom.ru>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cNdxnHkX5QqsyA0e"
Content-Disposition: inline
In-Reply-To: <1402250893-5412-5-git-send-email-bay@hackerdom.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--cNdxnHkX5QqsyA0e
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Jun 09, 2014 at 12:08:12AM +0600, Alexander Bersenev wrote:
> This patch adds records for two IR controllers on A20
>=20
> Signed-off-by: Alexander Bersenev <bay@hackerdom.ru>
> Signed-off-by: Alexsey Shestacov <wingrime@linux-sunxi.org>
> ---
>  arch/arm/boot/dts/sun7i-a20.dtsi | 18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
>=20
> diff --git a/arch/arm/boot/dts/sun7i-a20.dtsi b/arch/arm/boot/dts/sun7i-a=
20.dtsi
> index c057c3e..fe1f8ff 100644
> --- a/arch/arm/boot/dts/sun7i-a20.dtsi
> +++ b/arch/arm/boot/dts/sun7i-a20.dtsi
> @@ -763,6 +763,24 @@
>  			interrupts =3D <0 24 4>;
>  		};
> =20
> +		ir0: ir@01c21800 {
> +			compatible =3D "allwinner,sun7i-a20-ir";
> +			clocks =3D <&apb0_gates 6>, <&ir0_clk>;
> +			clock-names =3D "apb", "ir";
> +			interrupts =3D <0 5 4>;
> +			reg =3D <0x01c21800 0x40>;
> +			status =3D "disabled";
> +		};
> +
> +		ir1: ir@01c21c00 {
> +			compatible =3D "allwinner,sun7i-a20-ir";
> +			clocks =3D <&apb0_gates 7>, <&ir1_clk>;
> +			clock-names =3D "apb", "ir";
> +			interrupts =3D <0 6 4>;
> +			reg =3D <0x01c21c00 0x40>;
> +			status =3D "disabled";
> +		};
> +
>  		lradc: lradc@01c22800 {
>  			compatible =3D "allwinner,sun4i-lradc-keys";
>  			reg =3D <0x01c22800 0x100>;

I'm fine with this patch, but it doesn't apply, since the above node
doesn't exist. Please rebase on top of v3.16-rc1 and resend the patch.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--cNdxnHkX5QqsyA0e
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTnvADAAoJEBx+YmzsjxAgrvIP/ivUAegnXZuO7abzCG8lZ1gU
FdLXWuoyU8ONZ3RQm2gdPvxECugIySP3n8U3VExhCY/k2zW2IkIEUPUqRfvo80EU
LQvkGvXqJBK7iXUOxxP7zbyPaBnHwZpt7rnzXqw1+0fXLe0ulTkYv89efmnukzkA
yLMIK72qnaKGKEd28Zj7kL+DqvCOi62VMOa0djpx07k20Eepln6gCG4rPsRkymjP
vf4qXHd3UlZUlpZ0Cp8HrCOStajOfCI2rwdV2JnAxHNd76MrddM/G0huWfP5viAz
pfdC6KdsuNzhIjnaP76zqV9kauQuDHr7j9sqNa6wFGod4MjM0MiXh8lyreohpknG
bF3pD9QHHamOy7D596Ti8OnOWRkpBp/w5BzIpB2l0hCBV7yLQiHurkVSMtava60E
HLZB1cuqkmaXYSwa3seUIhixV5g3+jIqJPVas6w81bJv8+PeV/xaNfFEqtHcnPgc
e1NrB/lAr+9/gcqxZZqMCV0NLKobHpjZuR4jLj2NL2n+82c27FBBU/PR94iur82S
Xb3Qe7UDT+dD7j1NS5Yd0DhrSrfIwjA7LpgTq7lDbYpwZ3nCdms/Rwo3+mu/Jq9f
2YYswRz/naYPOAIMvJCEzAfsJzLchbos/u8ndKNwRiQZJErlsGogf61N2FrhK1ci
zRpar6kTkTLKPJUhto3S
=skBL
-----END PGP SIGNATURE-----

--cNdxnHkX5QqsyA0e--
