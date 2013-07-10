Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754780Ab3GJRN3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 13:13:29 -0400
Received: from mail-ee0-f50.google.com ([74.125.83.50]:62826 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754402Ab3GJRN1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 13:13:27 -0400
Date: Wed, 10 Jul 2013 10:13:20 -0700
From: Thierry Reding <thierry.reding@gmail.com>
To: Wei Ni <wni@nvidia.com>
Cc: khali@linux-fr.org, swarren@wwwdotorg.org, linux@roeck-us.net,
        lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH v2 1/2] ARM: dt: t30 cardhu: add dt entry for nct1008
Message-ID: <20130710171319.GB15665@dhcp-172-17-186-34.nvidia.com>
References: <1373455798-2944-1-git-send-email-wni@nvidia.com>
 <1373455798-2944-2-git-send-email-wni@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eAbsdosE1cNLO4uF"
Content-Disposition: inline
In-Reply-To: <1373455798-2944-2-git-send-email-wni@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--eAbsdosE1cNLO4uF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jul 10, 2013 at 07:29:57PM +0800, Wei Ni wrote:
> Enable thermal sensor nct1008 for t30 cardhu.

Nit: "Tegra30 Cardhu"

> diff --git a/arch/arm/boot/dts/tegra30-cardhu.dtsi b/arch/arm/boot/dts/tegra30-cardhu.dtsi
[...]
>  				};
>  			};
>  		};
> +
> +		nct1008: nct1008 {

I don't think it's very likely that this chip will need to be referenced
by a phandle, in which case the "nct1008:" label can be dropped. Even if
it was used at some point in the future, it's better to add it at that
time.

Thierry

--eAbsdosE1cNLO4uF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJR3ZYvAAoJEN0jrNd/PrOhbrkP/2e6u1DFpkaI19FxiXu1zh38
Wk1hbEfwC0UA/v2Pmxfo3yVtCpu7vgj8bm3tJ/qUVdLs2r1xmAdbBc7AhfN2qnat
OcX1OnnZ734R9Ob6/Em8hAZOwjnVYbBtzqFLBEkgPGDD84hog6VdltUZX+WzFZtJ
S+mfYgBkxap0/8bYZniPwOVvGyFBvLuKNJRwyGz6mGmjNkmmj672QyCDa/LaIBFr
FvHvhsLtHfkn8re36COyO0ZRKB3/dwZbjkr6ccJcQYSgLuYo5oGaoOHu41O2iqd2
saGIf1nyy5OhVtjINI4pJkk+DeX2mem5ggnYPy8Kg/HoyS68VcpzbCANYMjZwKG/
0cMNw1ckRoWIZ144AaCS8xbt+4SB9L8vNCRQ1gmWRxZVUy/goUNEca1N3W65vNgB
Iva5bMXxShU8nem/W/hiFux7MMmTlo4ymax3R0XpazQF6BObKfqSqqTZK1BkmTsx
R2lsqdTJw9qNHStAHyKxxlWABbdyizC0ErOTvxH4QatVpnYvBT0f1pWZFVslxII6
tY94zV0v7HI/dY3c8C+lpPl7Suz6U0PEjffS0FIB5c511WmHyAMDYtZVs45r/4xI
ODYPQYKRhob0ekv0oeyK3eUu66rWdY96qwSiI9lKI+unXvkXQwfpujWvbPcQsu8z
w8fPMJQBoSFAwdM0wIPh
=e6gy
-----END PGP SIGNATURE-----

--eAbsdosE1cNLO4uF--
