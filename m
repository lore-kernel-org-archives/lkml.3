Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754981Ab3LDIVa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 03:21:30 -0500
Received: from mail-bk0-f52.google.com ([209.85.214.52]:33702 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754383Ab3LDIVY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 03:21:24 -0500
Date: Wed, 4 Dec 2013 09:20:24 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: rob.herring@calxeda.com, swarren@wwwdotorg.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        linux@arm.linux.org.uk, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 1/2] ARM: tegra: Add header file for pinctrl constants
Message-ID: <20131204082023.GA19943@ulmo.nvidia.com>
References: <1386076567-14283-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bp/iNruPH9dso1Pn"
Content-Disposition: inline
In-Reply-To: <1386076567-14283-1-git-send-email-ldewangan@nvidia.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--bp/iNruPH9dso1Pn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 03, 2013 at 06:46:06PM +0530, Laxman Dewangan wrote:
> This new header file defines pincontrol constants for Tegra to
> use from Tegra's DTS file for pincontrol properties option.
>=20
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
> ---
> Changes from V1:
> - Get rid of lots of macro and converge it to TEGRA_PIN_ENABLE/DISABLE.
> - Change macro name for PULL UP/DOWN/NONE.
>=20
>  include/dt-bindings/pinctrl/pinctrl-tegra.h |   40 +++++++++++++++++++++=
++++++
>  1 files changed, 40 insertions(+), 0 deletions(-)
>  create mode 100644 include/dt-bindings/pinctrl/pinctrl-tegra.h

I like this a lot. One minor nit below.

> diff --git a/include/dt-bindings/pinctrl/pinctrl-tegra.h b/include/dt-bin=
dings/pinctrl/pinctrl-tegra.h
> new file mode 100644
> index 0000000..e5f02f8
> --- /dev/null
> +++ b/include/dt-bindings/pinctrl/pinctrl-tegra.h
> @@ -0,0 +1,40 @@
> +/*
> + * This header provides constants for TEGRA pinctrl bindings.

"TEGRA" -> "Tegra"

Other than that:

Reviewed-by: Thierry Reding <treding@nvidia.com>

--bp/iNruPH9dso1Pn
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSnuXHAAoJEN0jrNd/PrOhEIwP/0LQmXk7DxjSxWUik/gXsZpU
6qCp2DzIy5HJiQqi9Wsi5GhbU1LKAHf+qtgaCdlXlMow9v6wMHpovjqcvvFlJGie
wRTWjS9mQ2gTkjmUMuiOLnC5WrPfkMYES/9hHm6tIIdGYshtT8Xm4Hiyj8zyMyzt
6hVtpRfJnZD621EwGEzCZeXdoL15gRbIDvE1Lqu11uUIhhwC/73JSDEkG+U0mdx9
zN0phyZcvyq+SiLj75+m+yNHCHvF1ggUDRsfvmIBOUF4EPfJY43VbtNoU7MoRjLW
q0tB46jK/xNYzkjxl6exnVaZg7vWm8314eurxS8ZO2NigTtPyTOqHwE8zkLum8EK
G1aUHR9NXl9LCS8AjMs1ypR7QnQbdRXEgENzm2oxS0t6YuJd2SeY99hyYUSDNTko
PlvVbQHQuFuIybP36tqERpMy+AB//+LrwxBqEdhfq3NydjPa6oHpb8nf74c05AqM
iVNBMMuJDTZ7g6cvN7PUcW0U4LUj3wDNqPWHLW7eV7iJLS8ZLzSkmFKsgk8MyqPS
zEconvWVE+DWT4xqAYGPIiDfJwuhPw9/rH9gX0sdFMIgxxdnkA21N4n0UMPTy+vL
CljOen/8Emq70fwF8Pg48FuFGJZgsBDH5uthMwOl9YiE34JiHCjdr0auLyJ4eGHe
x34FvzqCb0NG2WKtifXr
=LkLM
-----END PGP SIGNATURE-----

--bp/iNruPH9dso1Pn--
