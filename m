Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755461Ab3H1Mao (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 08:30:44 -0400
Received: from mail-bk0-f49.google.com ([209.85.214.49]:63333 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753988Ab3H1Mam (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 08:30:42 -0400
Date: Wed, 28 Aug 2013 14:30:08 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Mikko Perttunen <mperttunen@nvidia.com>
Cc: tbergstrom@nvidia.com, dri-devel@lists.freedesktop.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] ARM: tegra: Add hdmi to Tegra114 Dalmore device tree
Message-ID: <20130828123008.GC32254@ulmo>
References: <1377686459-16634-1-git-send-email-mperttunen@nvidia.com>
 <1377686459-16634-6-git-send-email-mperttunen@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Md/poaVZ8hnGTzuv"
Content-Disposition: inline
In-Reply-To: <1377686459-16634-6-git-send-email-mperttunen@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Md/poaVZ8hnGTzuv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Aug 28, 2013 at 01:40:59PM +0300, Mikko Perttunen wrote:
> Add hdmi node to Dalmore device tree to supply Dalmore-specific

s/hdmi/HDMI/

> diff --git a/arch/arm/boot/dts/tegra114-dalmore.dts b/arch/arm/boot/dts/tegra114-dalmore.dts
[...]
> +	host1x {
> +		hdmi {
> +			status = "okay";
> +
> +			vdd-supply = <&vdd_hdmi_reg>;
> +			pll-supply = <&palmas_smps3_reg>;
> +			nvidia,ddc-i2c-bus = <&hdmi_ddc>;

I prefer to use a blank line to separate "standard" from
"vendor-specific" properties.

> +			nvidia,hpd-gpio = <&gpio TEGRA_GPIO(N, 7) GPIO_ACTIVE_HIGH>;

Other .dts files split this so it doesn't exceed 80 characters. I'm not
sure how useful that is as a general rule for DT source files, though.

>  	i2c@7000d000 {
>  		status = "okay";
>  		clock-frequency = <400000>;
> @@ -1169,6 +1184,8 @@
>  			regulator-min-microvolt = <5000000>;
>  			regulator-max-microvolt = <5000000>;
>  			enable-active-high;
> +			regulator-always-on;
> +			regulator-boot-on;

This warrants at least a mention in the commit message.

Thierry

--Md/poaVZ8hnGTzuv
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSHe1QAAoJEN0jrNd/PrOhUEEQALTRdp0a0ujfpSDkqXgGimz/
rNCATrIasfn44HWxrTLZ+VN2Fw117PFr8HPaNfZNI8bx6CWK1Jy7bc0pxUPoFKxg
1wk74esVdPBazVfQplI9dYh+VyBf5ZEQ5Nu+fDiZJ4a3osUwm970UKqfGnUgP4zD
qH0n6ztQQXBnCc/vJoRwr/uc4tVUBsg7tDWLQp/HVttsHldNTMRkO9vj8zlOhBaB
ZU4ZLapHYGIcC1YCNXG3dVvP0sA7VNU7bc/eoDeemodNj+2fnlHJ7atWc04hv3cF
KX+jCyHbQFMZx5OD8BCBeOpzOKW71B4cq9RmXC6A+HKC5qT2Ray5QH46sx941zf1
vrLhiwsi9TeU1k9eJF92pXOODb/gRzl5N4AN1BE959/1fQLSjygth/i8PXz5uQza
XAl+DjEdPLIt1KsSRu6S/NTPMHpyW0itAGuxgG86PsRfxWi1sb0S7LAQpKEHKCp8
6sp3K3vhizdHCYiRyHbMOFHGtLN7z6KF8qlqgzGROdK4IU/MeHOmxUYknnKmjRk7
em0PyHOEyrPlnNn/f0HrBjVCXf7BSepyjYJ6+ZUFp0YAtoeRpQS1vumqeE39RAH3
pp4cO21zFF2LNGjTlYVBdn3yUZZWPvXTWxOQrWJhbcelU1cDu4xN9lfHkpwYWsEh
sm0sTTCCvPU/ct71ltMI
=hwyi
-----END PGP SIGNATURE-----

--Md/poaVZ8hnGTzuv--
