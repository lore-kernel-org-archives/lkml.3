Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760755Ab3JPPiL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 11:38:11 -0400
Received: from mail-bk0-f49.google.com ([209.85.214.49]:63295 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752234Ab3JPPiJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 11:38:09 -0400
Date: Wed, 16 Oct 2013 17:35:51 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
Cc: mturquette@linaro.org, pgaikwad@nvidia.com, swarren@wwwdotorg.org,
        rob.herring@calxeda.com, pawel.moll@arm.com, mark.rutland@arm.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-tegra@vger.kernel.org
Subject: Re: pull request for tegra clocks (resend with some CCs added this
 time)
Message-ID: <20131016153550.GA22451@ulmo.nvidia.com>
References: <20131015153620.GA12721@tbergstrom-lnx.Nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NzB8fVQJ5HfG6fxh"
Content-Disposition: inline
In-Reply-To: <20131015153620.GA12721@tbergstrom-lnx.Nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--NzB8fVQJ5HfG6fxh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 15, 2013 at 06:36:20PM +0300, Peter De Schrijver wrote:
> The following changes since commit a0cf1abc25ac197dd97b857c0f6341066a8cb1=
cf:
>=20
>   Add linux-next specific files for 20130927 (2013-09-27 18:48:50 +1000)
>=20
> are available in the git repository at:
>   git://nv-tegra.nvidia.com/user/pdeschrijver/linux.git tegra-clk-patches=
-0
>=20
> Andrew Chew (1):
>       clk: tegra: Set the clk parent of host1x to pll_p
>=20
> Mark Zhang (3):
>       clk: tegra: Correct sbc mux width & parent
>       clk: tegra: Fix vde/2d/3d clock src offset
>       clk: tegra: Set the clock parent of gr2d/gr3d to pll_c2
>=20
> Peter De Schrijver (3):
>       ARM: tegra114: add missing clocks to binding
>       clk: tegra: replace enum tegra114_clk by binding header
>       clk: tegra: PLLE spread spectrum control
>=20
> Thierry Reding (1):
>       clk: tegra114: Rename gr_2d/gr_3d to gr2d/gr3d

I think this pull request is missing the initialization of the display
controller clocks (TEGRA114_CLK_DISP1 and TEGRA114_CLK_DISP2) from
Mikko's Dalmore HDMI series.

Thierry

--NzB8fVQJ5HfG6fxh
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSXrJWAAoJEN0jrNd/PrOhtqgQAKSzixdiJv7Ex4ifObEg7vAE
yd5wAhjdCPhr/VA1CgydmMwR5sHojLzB9yiOhAgeHoBnTyxg/dw+NnfiYfJ0XxpF
2pY4LTzEqRP0pgWBulML1uc2UcskVCBsIAUE+/vEfNBhf2dtEIyyOjqTxdCpgufy
GK77qSa3sHHwIntkwuIq54mZpI4p5vC2h/qCHoODvBeODHH3rk+hkm1SwE2V7vO5
6eZr6DXzzCVnjznXr4L7Y6K0+9HxSX9QzFoOYHR89n72qW7ChMvGOZgEawEWLwok
ELEYNI2So/oynDV1C8ZCd91PMZaRtCClMIZ0k3Twd01DNA9aLMmK3uXQsLZ7Vdvo
mhbN1+eynn68lKc6jSfwxloalpeZLBYWZ4Wh7uhXQdZY3RS6mU9mmGmR2ibiB1le
qyHhZJvVHZNE9HYvGxfCSLdulsRSTdUSCUNxhYtaYzKDS5TvtNE85+tSA5Gj2Xnv
cfwEp6hSt8vD70DCF+7eoNtVXVcJKH5R29MEq2E7qOHHidxQaQ78uK3wFRVOMT/C
xFg/ZR16ukeeVwsyv/ayLqv88kHv9ayIg3wzlPf9pKMU+AQlgTJZtcMTh5KQNU88
hD+cQ7QSB04fm42lumCWAYhDPjLA7YwkQPm4ZMGHFwCBUmQMnuq6JSm2zdtOfaUu
LV2FuhsG1UJ+Rv/m9bhM
=Vjv1
-----END PGP SIGNATURE-----

--NzB8fVQJ5HfG6fxh--
