Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752428AbaJ0Qnt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 12:43:49 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:44618 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751593AbaJ0Qnq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 12:43:46 -0400
Date: Mon, 27 Oct 2014 11:42:42 -0500
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
Subject: Re: [PATCH v2 08/10] ARM: dts: tegra: Use standard power-off
 property in tps65911 for tegra30 beaver
Message-ID: <20141027164242.GG14253@saruman>
Reply-To: <balbi@ti.com>
References: <1414427215-14380-1-git-send-email-romain.perier@gmail.com>
 <1414427215-14380-8-git-send-email-romain.perier@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7lMq7vMTJT4tNk0a"
Content-Disposition: inline
In-Reply-To: <1414427215-14380-8-git-send-email-romain.perier@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--7lMq7vMTJT4tNk0a
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 27, 2014 at 04:26:53PM +0000, Romain Perier wrote:
> Signed-off-by: Romain Perier <romain.perier@gmail.com>
> ---
>  arch/arm/boot/dts/tegra30-beaver.dts | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/arch/arm/boot/dts/tegra30-beaver.dts b/arch/arm/boot/dts/teg=
ra30-beaver.dts
> index cee8f22..4abaf7f 100644
> --- a/arch/arm/boot/dts/tegra30-beaver.dts
> +++ b/arch/arm/boot/dts/tegra30-beaver.dts
> @@ -188,7 +188,7 @@
>  			#interrupt-cells =3D <2>;
>  			interrupt-controller;
> =20
> -			ti,system-power-controller;
> +			system-power-controller;

and this... likewise to all others. You should add regressions midway
through your series and you can't simply drop a DT binding which has
been shipped on stable kernels.

--=20
balbi

--7lMq7vMTJT4tNk0a
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUTnYCAAoJEIaOsuA1yqREBS8P/jPPfbvcXnY+L6I58XTJ2XuU
h0BzLU3n7XGD1IG/FepWFjp9cGmvupntCEIBPCwmTVyxskxnlmWmzDTUiYIVi10n
ei4gPK4vOeKUDBEMV8E9GwYo0sb0m4PoqTC1RLpsJGgULSPZ2Xjc2UIjrUx4xx4Y
0CUyPmzyAyberR9MaM/Vol9wn6umuWaQJWk0CKfb7Ff/Kobi562v6oUAw7kr+F7d
793RsS8nx/jhcUmjGjVcKv2fAIUucVZmzXwkAKpafRR4Ihl0pwH98tJ2dXpUqCAJ
ViriysXqX308nLIcE4KW5oVwN2tILnNA8VblV+7kefrosYyKgV8k7zcNXR7+5f1N
yANGyIwTUmNO2GA5PeTCN9Ag30abZI+PeMVyqgbuc9BymMl2TmmJHzD3q/eb6JrC
XAR4MNqhpTt4fLC+VKexZ/nB24BEH+NSRstg1U6fKB0e73gaX5wJENeDxiyX2Vhm
3PZRiXr1Dpq/E4cmfkxPp/7rOsLR+/wYngeYuJsCg4j+VcbfrJII2JfGR2t5EGyP
2rE3pChv5S0/jXqz3ts2REN3jf/dqPbi8jYPtATUgQ2zspuDSMsMhl3A3JzPo5nb
SFr1//cms9GyaH7BInsC9LZTY+7XU6RAQivDknpI43BVFbGtOh2r/qhxDEOYktRM
yvVxI0tJrWj5OYgOTNyM
=ic8H
-----END PGP SIGNATURE-----

--7lMq7vMTJT4tNk0a--
