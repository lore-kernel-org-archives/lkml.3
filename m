Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752279AbaJ0Qn1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 12:43:27 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:32945 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752178AbaJ0QnX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 12:43:23 -0400
Date: Mon, 27 Oct 2014 11:42:14 -0500
From: Felipe Balbi <balbi@ti.com>
To: Romain Perier <romain.perier@gmail.com>
CC: <heiko@sntech.de>, <devicetree@vger.kernel.org>, <broonie@kernel.org>,
        <lgirdwood@gmail.com>, <linux-kernel@vger.kernel.org>,
        <grant.likely@linaro.org>, <robh@kernel.org>, <mark.rutland@arm.com>,
        <johan@kernel.org>, <linux-pm@vger.kernel.org>, <linux@roeck-us.net>,
        <lee.jones@linaro.org>, <balbi@ti.com>, <robh+dt@kernel.org>,
        <pawel.moll@arm.com>, <ijc+devicetree@hellion.org.uk>,
        <galak@codeaurora.org>, <linux@arm.linux.org.uk>,
        <swarren@wwwdotorg.org>, <thierry.reding@gmail.com>,
        <gnurou@gmail.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH v2 07/10] ARM: dts: tegra: Use standard power-off
 property in tps65911 for tegra30 apalis
Message-ID: <20141027164214.GF14253@saruman>
Reply-To: <balbi@ti.com>
References: <1414427215-14380-1-git-send-email-romain.perier@gmail.com>
 <1414427215-14380-7-git-send-email-romain.perier@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7cm2iqirTL37Ot+N"
Content-Disposition: inline
In-Reply-To: <1414427215-14380-7-git-send-email-romain.perier@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--7cm2iqirTL37Ot+N
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 27, 2014 at 04:26:52PM +0000, Romain Perier wrote:
> Signed-off-by: Romain Perier <romain.perier@gmail.com>
> ---
>  arch/arm/boot/dts/tegra30-apalis.dtsi | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/arch/arm/boot/dts/tegra30-apalis.dtsi b/arch/arm/boot/dts/te=
gra30-apalis.dtsi
> index a5446cb..ced4436 100644
> --- a/arch/arm/boot/dts/tegra30-apalis.dtsi
> +++ b/arch/arm/boot/dts/tegra30-apalis.dtsi
> @@ -412,7 +412,7 @@
>  			#interrupt-cells =3D <2>;
>  			interrupt-controller;
> =20
> -			ti,system-power-controller;
> +			system-power-controller;

this board is broken until this patch is applied.

--=20
balbi

--7cm2iqirTL37Ot+N
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUTnXmAAoJEIaOsuA1yqREfDMP/j7ucJq3vB78FGIOTHhaE8NC
bd9AawfKX6pK1rH7K9gqQGn/KEk4IjUSRxNIjQwwyYmWN3dU9Ouox9qcp3fVVTj7
R74o7v6eJxZIGncKIrEOqUVnmbDuWKCArzZIk+ssd8FnJnTiDDi4AxWCBofcTZVb
HSEi8JqwjVkU+Sie8CerWa/YrUsOX0nnVeTzYGAGraXY80iFkl5yRx/g2w8hwuAy
XAwn+AyPzqCFLl2lVX2FTXHdBQQ/asyKxDrh9KTLP2B3kY6bILluP6XOYaiqDPwk
Xffk6hwziypeddH7Gao5iS/zlB3SophXfXPmwa0PUDae3CHPMirGQyXSG++V6rCD
xX8Tfd+eX8v1FehBLAffb/zm8Kj/YpFz8VxMbvQqux7Se1AAcqiWO143jY1eijyz
oExG7eQG2bWsTHidCROmJ7k4eJRFkreUEOka6CNPD/1cbF8HTQxrdZ3RhyQc7HXz
pb9pY8EY1c3Xd3x4cjWkPWdaPnFmyu6+5LC7lgrrkl8fpnrMIDaze39E/vL1iDLd
7PG0AAQ+ki/CNOAjwb2tysC0MFJtWDVPeOq8w8zebXfqQyo9fCGBllFlc+eaNpKP
e8rAaBKy4/2cjj+y6Ch7RZ33Z6QwbQZsFTMr1UYBcbDZepggZfNs97Y7YvRdo4T/
roJIHiMccfxOBcTCF8LW
=YXmf
-----END PGP SIGNATURE-----

--7cm2iqirTL37Ot+N--
