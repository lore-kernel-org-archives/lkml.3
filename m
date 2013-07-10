Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754785Ab3GJROb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 13:14:31 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:46185 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754497Ab3GJROa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 13:14:30 -0400
Date: Wed, 10 Jul 2013 10:14:23 -0700
From: Thierry Reding <thierry.reding@gmail.com>
To: Wei Ni <wni@nvidia.com>
Cc: khali@linux-fr.org, swarren@wwwdotorg.org, linux@roeck-us.net,
        lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH v2 2/2] ARM: dt: t114 dalmore: add dt entry for nct1008
Message-ID: <20130710171422.GC15665@dhcp-172-17-186-34.nvidia.com>
References: <1373455798-2944-1-git-send-email-wni@nvidia.com>
 <1373455798-2944-3-git-send-email-wni@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WfZ7S8PLGjBY9Voh"
Content-Disposition: inline
In-Reply-To: <1373455798-2944-3-git-send-email-wni@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--WfZ7S8PLGjBY9Voh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jul 10, 2013 at 07:29:58PM +0800, Wei Ni wrote:
> Enable thermal sensor nct1008 for t114 dalmore.

Nit: "Tegra114 Dalmore"

> diff --git a/arch/arm/boot/dts/tegra114-dalmore.dts b/arch/arm/boot/dts/tegra114-dalmore.dts
[...]
> +		nct1008: nct1008 {
> +			compatible = "onnn,nct1008";
> +			reg = <0x4c>;
> +			interrupt-parent = <&gpio>;
> +			interrupts = <TEGRA_GPIO(O, 4) IRQ_TYPE_LEVEL_LOW>;
> +		};

The "nct1008:" label isn't needed here either.

Thierry

--WfZ7S8PLGjBY9Voh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJR3ZZuAAoJEN0jrNd/PrOh8YgP/Rf4Laut/ArWOVHytrwPkR8d
t0CBBLY36I4/LkbB1VUuonXBgkdT9ty5lNdlBCknJd+6kkFQcd5ROHOrPIMudCh3
/mIENzDfzY9FicPbPscV6/SLBS+0+4WNah3dXM+loXznd1I4dWL7aTPzP8hZd3Qo
qCNntLogPhIuCy0dGSO5y94j2i/pRv8Jps4SSH35QonrMzERUQh6WRyo+Xdfm8bf
M7FugL/zLj4+tX4dAE3Fu8MCSFDOq9LX4CKa3f2GABrQu2v7ENYEQNJT9YnnZ85y
vaiNwAY6Y6va0H4+Pu9XePRuOoaM++rzX87pFsuGnLiuW2CndGK/IfyPRnXDZLl2
DV3xVOSQGmkPpGBAnzCNQrasMmHiBXEx+8lESt6ykAIWdMTiWWrJhqAG7FwLhdF1
zQ+AyDR2GkX3kjLXgKOU/qv/GvueTsro8bdCDP4B5Cwav2dM1iLT4R4SIcEiI9EJ
dttdBvviUyYMptg9owqjnelr4C/sBrKO/8sfxvxt0fDWtIXut0f6XmK3zToqcMyV
mQN/5q5ZpM8q4mzRcGuLEt2u6M6tNY3cj8NS/E6cDpKGXiU0YhTynm5eM2tUkDXJ
pL6bORW627J+PnL7nyjZcc5IBcQRph54f/CIauB9W3cP00J5l0WVu6CC0C/HigrW
ICWsJwsHhTcbH4vkLAlF
=88wX
-----END PGP SIGNATURE-----

--WfZ7S8PLGjBY9Voh--
