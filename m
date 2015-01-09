Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933032AbbAILUC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 06:20:02 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:48672 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755109AbbAILT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 06:19:58 -0500
Date: Fri, 9 Jan 2015 12:19:55 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Paul Walmsley <paul@pwsan.com>
Cc: linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexandre Courbot <gnurou@gmail.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Bill Huang <bilhuang@nvidia.com>, Stephen Boyd <sboyd@codeaurora.org>,
        Allen Martin <amartin@nvidia.com>,
        Paul Walmsley <pwalmsley@nvidia.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 4/4] clk: tegra: Add support for the Tegra132 CAR IP block
Message-ID: <20150109111954.GB16465@ulmo>
References: <20141216203813.22980.2301.stgit@chromeos-P9X79>
 <20141216203829.22980.64446.stgit@chromeos-P9X79>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5/uDoXvLw7AC5HRs"
Content-Disposition: inline
In-Reply-To: <20141216203829.22980.64446.stgit@chromeos-P9X79>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5/uDoXvLw7AC5HRs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 16, 2014 at 12:38:29PM -0800, Paul Walmsley wrote:
> From: Paul Walmsley <pwalmsley@nvidia.com>
>=20
> Tegra132 CAR supports almost the same clocks as Tegra124 CAR. This
> patch mostly deals with the small differences.
>=20
> Since Tegra132 contains many of the same PLL clock sources used on
> Tegra114 and Tegra124, enable them in drivers/clk/tegra/clk-pll.c when
> the kernel is configured to include Tegra132 support.
>=20
> This patch is based on several patches from others:
>=20
> 1. a  patch from Peter De Schrijver:
>=20
> http://lkml.iu.edu/hypermail/linux/kernel/1407.1/06094.html
>=20
> 2. a patch from Bill Huang ("clk: tegra: enable cclk_g at boot on
> Tegra132"), and
>=20
> 3. a patch from Allen Martin ("clk: Enable tegra clock driver for
> tegra132").

Doesn't this technically require Signed-off-bys from each of the above,
then?

> diff --git a/drivers/clk/tegra/clk-tegra124.c b/drivers/clk/tegra/clk-teg=
ra124.c
[...]
> +/**
> + * tegra124_132_clock_init_pre - clock initialization preamble for T124/=
T132
> + * @np: struct device_node * of the DT node for the SoC CAR IP block
> + *
> + * Register most of the clocks controlled by the CAR IP block, along
> + * with a few clocks controlled by the PMC IP block.  Everything in
> + * this function should be common to Tegra124 and Tegra132.  XXX The
> + * PMC clock initialization should probably be moved to PMC-specific
> + * driver code.  No return value.
> + */
> +static void __init tegra124_132_clock_init_pre(struct device_node *np)

I would've personally named this tegra124_clock_init_pre(). In the past
we've named these functions after the first chip that needed them and if
later chips remained compatible they would simply use the one from an
earlier chip. That's consistent with the naming of compatible strings
and doesn't require changes to the function names if yet another SoC
generation were to need the same functionality.

Thierry

--5/uDoXvLw7AC5HRs
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUr7laAAoJEN0jrNd/PrOhNFQP/3RosVxdWzeuXBcBue1zU6BO
c8RTiqR8xMbzZ6qkG6AD8h+scS+rM7myFTK6l4+/+Hdy+ffVJ9/gNsmLbsm36omS
604X68lA+0mwCjiwZBkgMGHRj6Ex1nIREJIyqa3E3h0zQb60oh1FCBPX34Bym014
Ua46kIafV8yq3W/XXljV7qs3D37BWl4fIUXNXXrKSqQdVxz0E5NEhnAi2+xSbawm
lsqvtvkmXMhfXMrIGWhevpTF4tN90f+7w3/cPnv+wVwoEa9x1vtBIBHXHk5qnt1A
ziFz7DmKlC6CM7bY15Q05OKSzzWqQUbQzZMTiUKj7BNfHxMAPL+fiEBiRgO8+W4Y
lGRHm+Id2N7y41KWf3H4tZo2x8zwgecq24Fte3RvqlNxu61jFyR0wp2hPG/FRKxn
L9vjFUpmmzB2dPNjHd8b6ktX2SkX2h1EAcdhEIiGfoWrMzroEo9bRVfLI7SyCcY+
HwF1W3eLgYVdJu2vInSbGzc2maLcYQ8LOpLYi1mFg639kLdgLTbVDZgyty7KrXdE
U5w1EyeGR//WGSKOOjJVRwCBtVh6iyBa+MnNobRSmbiJvRlG8FqFGXb2dCOS5d6W
FKQ7uBZdvxkbg3tCsVANt4Q34X4epWjy7+PBiB7Tec5/WS9ouQNy7i+r54u3GFQz
tcTMOE2IConCBjacex3y
=uk6Z
-----END PGP SIGNATURE-----

--5/uDoXvLw7AC5HRs--
