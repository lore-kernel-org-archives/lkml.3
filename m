Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754479Ab3JJKpO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 06:45:14 -0400
Received: from mail-bk0-f49.google.com ([209.85.214.49]:58612 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752256Ab3JJKpM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 06:45:12 -0400
Date: Thu, 10 Oct 2013 12:43:07 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
Cc: Mike Turquette <mturquette@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ian.campbell@citrix.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Paul Walmsley <pwalmsley@nvidia.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH 2/5] clk: tegra: Add periph regs bank X
Message-ID: <20131010104306.GB6735@ulmo.nvidia.com>
References: <1380878014-22088-1-git-send-email-pdeschrijver@nvidia.com>
 <1380878014-22088-3-git-send-email-pdeschrijver@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JP+T4n/bALQSJXh8"
Content-Disposition: inline
In-Reply-To: <1380878014-22088-3-git-send-email-pdeschrijver@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--JP+T4n/bALQSJXh8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 04, 2013 at 12:12:41PM +0300, Peter De Schrijver wrote:
> Tegra124 has an extra bank of peripheral clock registers. Add it to the
> generic peripheral clock code.
>=20
> Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
> ---
>  drivers/clk/tegra/clk.c |   10 ++++++++++
>  1 files changed, 10 insertions(+), 0 deletions(-)
>=20
> diff --git a/drivers/clk/tegra/clk.c b/drivers/clk/tegra/clk.c
> index c8c84ce..0240dc3 100644
> --- a/drivers/clk/tegra/clk.c
> +++ b/drivers/clk/tegra/clk.c
> @@ -57,6 +57,8 @@
>  #define RST_DEVICES_CLR_V		0x434
>  #define RST_DEVICES_SET_W		0x438
>  #define RST_DEVICES_CLR_W		0x43c
> +#define RST_DEVICES_SET_X		0x290
> +#define RST_DEVICES_CLR_X		0x294

Perhaps sort these numerically rather than alphabetically? Also I don't
see where the CLK_OUT_ENB_X, CLK_OUT_ENB_{SET,CLR}_X or RST_DEVICES_X
registers are defined. Perhaps they were part of some other patch or a
series that this depends on?

> =20
>  /* Global data of Tegra CPU CAR ops */
>  static struct tegra_cpu_car_ops dummy_car_ops;
> @@ -109,6 +111,14 @@ static struct tegra_clk_periph_regs periph_regs[] =
=3D {
>  		.rst_set_reg =3D RST_DEVICES_SET_W,
>  		.rst_clr_reg =3D RST_DEVICES_CLR_W,
>  	},
> +	[5] =3D {
> +		.enb_reg =3D CLK_OUT_ENB_X,
> +		.enb_set_reg =3D CLK_OUT_ENB_SET_X,
> +		.enb_clr_reg =3D CLK_OUT_ENB_CLR_X,
> +		.rst_reg =3D RST_DEVICES_X,
> +		.rst_set_reg =3D RST_DEVICES_SET_X,
> +		.rst_clr_reg =3D RST_DEVICES_CLR_X,
> +	},
>  };

Thierry

--JP+T4n/bALQSJXh8
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSVoS6AAoJEN0jrNd/PrOh+JcP/R7i6KO0eQ3qB8atCTy882V0
7BiM7uvauXCnqJcEL2t6S+FWiCR2yQ9I3fhYLxbuzk+mCNHDGYkCyOx8DJLMJIQ7
wppZ+E4wxxoy8VvkShPoM/Uacf8JfMaRtqDtFpgM+UE1TS36OIrzY1efZ8F3xgVL
/UeEhQWpYJysT7qTWYNr3IkmD2I2Rx/0x4BnuAdEOYiTXOux/pjFHu8vQjT19XnB
Y+IGhm5U64WzaoUEXSt1IQYPXHrQVvKsF8YfHt7OrBgaQZg/qZ49Q2BJenz0dxQ+
RCcpZuKRgxDGAWWRqGk1F2M0Ulm4bjDNZfX1NtIFAjb3UJifUCVCbTiyPd0RTdO8
0dhOhdNUZ2iGGhO54WMLJ+XDUZZxWi7QF6n04y3e3U/Yr7oY7MFt2VPaulAW5/yI
cbM4zMYZyy2arav6SghpYBkEXfmLXJcJbPgRhwacK0Zk/W0Cwf1Mnbt4fKODhipr
m8kbJL4asS3hj9Bb4cL12ir8Wevl6xzT258+/6ffc65Y2Jxp3kPKDssv+gfKzdU7
RJiwTtWRoKiG0aJWqP+Y5BgHUeAgT7iaTO3aQBZPFO70VwBw4mfujfCmXDxRCIvy
uRkpofKb/9oquZVM5LaowgxxUHHSLMBqHoiTri2npwocvcqj2OomH5RjTsib/C+r
jYWmbEM8klgbndDvheLX
=Xdo5
-----END PGP SIGNATURE-----

--JP+T4n/bALQSJXh8--
