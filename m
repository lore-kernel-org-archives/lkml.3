Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965343AbaGPHcL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 03:32:11 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:34169 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934102AbaGPHcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 03:32:08 -0400
Date: Wed, 16 Jul 2014 09:32:01 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Russell King <linux@arm.linux.org.uk>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>, Joseph Lo <josephl@nvidia.com>,
        Alexandre Courbot <acourbot@nvidia.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Tuomas Tynkkynen <ttynkkynen@nvidia.com>, devicetree@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 4/6] clk: tegra: add nvidia,tegra132-ccplex-clk binding
Message-ID: <20140716073200.GE7978@ulmo>
References: <1405437890-6468-1-git-send-email-pdeschrijver@nvidia.com>
 <1405437890-6468-5-git-send-email-pdeschrijver@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WBsA/oQW3eTA3LlM"
Content-Disposition: inline
In-Reply-To: <1405437890-6468-5-git-send-email-pdeschrijver@nvidia.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--WBsA/oQW3eTA3LlM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 15, 2014 at 06:24:34PM +0300, Peter De Schrijver wrote:
> Tegra132 has a few new clocks for the CPU complex (ccplex).
>=20
> Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
> ---
>  .../bindings/clock/nvidia,tegra132-ccplex-clk.txt  |   27 ++++++++++++++=
++++++
>  include/dt-bindings/clock/tegra132-ccplex.h        |   12 +++++++++
>  2 files changed, 39 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/clock/nvidia,tegra1=
32-ccplex-clk.txt
>  create mode 100644 include/dt-bindings/clock/tegra132-ccplex.h
>=20
> diff --git a/Documentation/devicetree/bindings/clock/nvidia,tegra132-ccpl=
ex-clk.txt b/Documentation/devicetree/bindings/clock/nvidia,tegra132-ccplex=
-clk.txt
> new file mode 100644
> index 0000000..1441e36
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/clock/nvidia,tegra132-ccplex-clk.=
txt
> @@ -0,0 +1,27 @@
> +NVIDIA Tegra132 ccplex clocks

Perhaps: "NVIDIA Tegra132 CPU complex (ccplex) clocks". Otherwise this
file doesn't expand the ccplex abbreviation at all and it may not be
obvious to everyone.

> +This binding uses the common clock binding:
> +Documentation/devicetree/bindings/clock/clock-bindings.txt

clock-bindings.txt is in the same directory as this file, so a slightly
better wording would be:

	This binding uses the common clock binding as described in the
	clock-bindings.txt file in this directory.

Note that these absolute paths may not remain the same when the device
tree bindings are moved out of the kernel tree.

> +The Tegra132 ccplex clock module on Tegra132 is the HW module responsible
> +for the ccplex related clocks.

The end repeats the beginning of this sentence, so its information
content is rather low. Maybe the last part of this sentence could be:
"... responsible for the CPU and related clocks".

> diff --git a/include/dt-bindings/clock/tegra132-ccplex.h b/include/dt-bin=
dings/clock/tegra132-ccplex.h
[...]
> +#define TEGRA132_CCPLEX_CCLK_G 1
> +#define TEGRA132_PLL_X 2
> +#define TEGRA132_CCPLEX_CLK_MAX 3

Maybe these should use TEGRA132_CLK_ as prefix for consistency with the
CAR binding?

Thierry

--WBsA/oQW3eTA3LlM
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTxipwAAoJEN0jrNd/PrOhXRsP+wUmTSZ+S/1VYWQ50sZCQtSh
SM3OSy96drsNEJehN6kRezqC4QaLqv31xDVUgocqac8mJwkUNtb8ZNGmB0g9ORYe
ce0oDBGrIKwPo+E8NvFUenYNR4Me6IuAa705SpaElON6EhRyz4IHHLGgEj/z08J/
GjA+3ZQFpJ+i7WRICuAMr/f6b0AomLU6+Amvokxt0RITqHSCo98kTlzz2vbrduEk
kqn25w3wOZ7FywGw9J+Nj7ODF7LdOUksKj16hy9g5LGv82LjEj/jdtos5NoW3SE8
PEMe03tW4PouZcV3D+cfrlimarBr0zuhzGnp3JoU+yN0ZN+HgI8g4fsCuJmwe374
/3sLZbCsWrqwvBGaMZrE508SYxkrbJHtko1IrKSWLFMs5gvUF8hef3I9cjvuZl3r
yOQoUoCpYpyNpI2aoj1kU2M/9doorPAJGDgxGbjkR3Rb8WeuihXfqCuMY6XD1YC6
6yLXPWoM5wa6WLd/RB8M6AOuf1P4coUuN0lm9nZGRNfms9mYn9jVzn9F7SlPb0ZD
/uHGXXiUrZEX0gNl+JqmuijBnNIRl/+0YNpJ65M9VEy6GWM1GxsvTXQQ0UubF/Sf
qbwBMntO//bexAI6hrVjiocF5SO6P2CLaaDafpdOHjRe+i4hYcVU4Hr6GKTMdveU
EQFYkxP0Ovyte9QGogYh
=GaJ/
-----END PGP SIGNATURE-----

--WBsA/oQW3eTA3LlM--
