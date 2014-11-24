Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753392AbaKXKdA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 05:33:00 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:35150 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954AbaKXKc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 05:32:59 -0500
Date: Mon, 24 Nov 2014 11:32:52 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Vivek Gautam <gautam.vivek@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        devicetree@vger.kernel.org, kgene.kim@samsung.com,
        dri-devel@lists.freedesktop.org, javier.martinez@collabora.co.uk,
        jg1.han@samsung.com, ajaykumar.rs@samsung.com,
        Kukjin Kim <kgene@kernel.org>
Subject: Re: [PATCH V2 RESEND] arm: dts: Exynos5: Use pmu_system_controller
 phandle for dp phy
Message-ID: <20141124103249.GA26217@ulmo.nvidia.com>
References: <1416807683-2257-1-git-send-email-gautam.vivek@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ew6BAiZeqk4r7MaW"
Content-Disposition: inline
In-Reply-To: <1416807683-2257-1-git-send-email-gautam.vivek@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ew6BAiZeqk4r7MaW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 24, 2014 at 11:11:23AM +0530, Vivek Gautam wrote:
> DP PHY now require pmu-system-controller to handle PMU register
> to control PHY's power isolation. Adding the same to dp-phy
> node.
>=20
> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
> Reviewed-by: Jingoo Han <jg1.han@samsung.com>
> Tested-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
> Cc: Kukjin Kim <kgene@kernel.org>
> ---
>  arch/arm/boot/dts/exynos5250.dtsi |    2 +-
>  arch/arm/boot/dts/exynos5420.dtsi |    4 ++--
>  2 files changed, 3 insertions(+), 3 deletions(-)
>=20
> diff --git a/arch/arm/boot/dts/exynos5250.dtsi b/arch/arm/boot/dts/exynos=
5250.dtsi
> index 0a588b4..bebd099 100644
> --- a/arch/arm/boot/dts/exynos5250.dtsi
> +++ b/arch/arm/boot/dts/exynos5250.dtsi
> @@ -732,7 +732,7 @@
> =20
>  	dp_phy: video-phy@10040720 {
>  		compatible =3D "samsung,exynos5250-dp-video-phy";
> -		reg =3D <0x10040720 4>;
> +		samsung,pmu-syscon =3D <&pmu_system_controller>;
>  		#phy-cells =3D <0>;
>  	};
> =20
> diff --git a/arch/arm/boot/dts/exynos5420.dtsi b/arch/arm/boot/dts/exynos=
5420.dtsi
> index 8617a03..1353a09 100644
> --- a/arch/arm/boot/dts/exynos5420.dtsi
> +++ b/arch/arm/boot/dts/exynos5420.dtsi
> @@ -503,8 +503,8 @@
>  	};
> =20
>  	dp_phy: video-phy@10040728 {
> -		compatible =3D "samsung,exynos5250-dp-video-phy";
> -		reg =3D <0x10040728 4>;
> +		compatible =3D "samsung,exynos5420-dp-video-phy";
> +		samsung,pmu-syscon =3D <&pmu_system_controller>;
>  		#phy-cells =3D <0>;
>  	};
> =20

It seems like these nodes have been in the Linux tree since 3.12 and
3.17, respectively and these changes break backwards-compatibility. Has
anyone thought about the possible consequences?

Although, looking more closely it seems like this isn't the first time
that backwards-compatibility was broken in these files, so perhaps
nobody cares...

Thierry

--ew6BAiZeqk4r7MaW
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUcwlRAAoJEN0jrNd/PrOhrXkQAJfG+54ckAxuZgIx2hUuIvVk
xGz7wC26FeexLtVt27p/Q+KPxqutwW0YKf8mNUKSpogmbQ5CFdojrpv/V268dWpP
wTEDPXu1EftLNT/NvSsimu5kOsZC/6447DQfmI39m/V3+dubodKOG76iRLbicGXY
l6xzTseCJUd47iM87aiSfUA0R3Gtr/GWpyn7/Q7Jx6PKOq3z2cucERxCK84CaQ37
60qbY5eKhkIfFs8c5Zrvo7gYD/GZn5wcV6l9RjBfIOrHvM+fVWQxps4UGQonPvNr
hG+8mRwxJrq13Jx5feeu1pE+Byxa9S43yJwo6nXkxJO/ddHE3rzQqXfQHc2jRFNx
7eD26kpLoOPSnKA5tPKExU5/P16YUPigmN1XWTuqs4bs5vcs6MGK6y2n4sDWukPu
6jzRJB8DmBwm9wAwk6LsL//ccHg1OJ5sLQx4ASo2uYmZHDIBjvQlpp/mkU0zqkJD
yhGiWsV3fEznPyZTtwAeOPWN/Kbmr4RQQEwl/OyXjeyd1iWpgfnybJSpKFqcQi8U
IVpz4EWy1CFzimVb2sawHtHlw/zaUxfzqHlMln0Qn0xJcghTYev1jwjSfwLxZGNI
0HzadBNOIyj0re7DcxXWF4dD4JkwUehqNZpppbiA3W/bKULwvdIIJVOIal4j4U4f
1xCFAuUr7ZPIuA9KyiFz
=rAYB
-----END PGP SIGNATURE-----

--ew6BAiZeqk4r7MaW--
