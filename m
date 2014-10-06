Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752454AbaJFLBw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 07:01:52 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:57672 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752419AbaJFLBr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 07:01:47 -0400
Date: Mon, 6 Oct 2014 13:01:43 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Boris Brezillon <boris.brezillon@free-electrons.com>
Cc: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Andrew Victor <linux@maxim.org.za>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-pwm@vger.kernel.org, Rob Clark <robdclark@gmail.com>,
        linux-arm-kernel@lists.infradead.org, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mark Yao <mark.yao@rock-chips.com>
Subject: Re: [PATCH v7 11/11] ARM: at91/dt: enable the LCD panel on
 sama5d3xek boards
Message-ID: <20141006110142.GI25202@ulmo>
References: <1412175188-28278-1-git-send-email-boris.brezillon@free-electrons.com>
 <1412175188-28278-12-git-send-email-boris.brezillon@free-electrons.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="uJWb33pM2TcUAXIl"
Content-Disposition: inline
In-Reply-To: <1412175188-28278-12-git-send-email-boris.brezillon@free-electrons.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--uJWb33pM2TcUAXIl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 01, 2014 at 04:53:08PM +0200, Boris Brezillon wrote:
> From: Boris BREZILLON <boris.brezillon@free-electrons.com>
>=20
> Enable LCD related nodes.
>=20
> Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
> ---
>  arch/arm/boot/dts/sama5d31ek.dts | 20 ++++++++++++++++++++
>  arch/arm/boot/dts/sama5d33ek.dts | 20 ++++++++++++++++++++
>  arch/arm/boot/dts/sama5d34ek.dts | 20 ++++++++++++++++++++
>  arch/arm/boot/dts/sama5d36ek.dts | 20 ++++++++++++++++++++
>  4 files changed, 80 insertions(+)
>=20
> diff --git a/arch/arm/boot/dts/sama5d31ek.dts b/arch/arm/boot/dts/sama5d3=
1ek.dts
> index 04eec0d..6e605fe 100644
> --- a/arch/arm/boot/dts/sama5d31ek.dts
> +++ b/arch/arm/boot/dts/sama5d31ek.dts
> @@ -33,6 +33,10 @@
>  				status =3D "okay";
>  			};
> =20
> +			hlcdc: hlcdc@f0030000 {
> +				status =3D "okay";
> +			};
> +
>  			macb1: ethernet@f802c000 {
>  				status =3D "okay";
>  			};
> @@ -46,6 +50,22 @@
>  		};
>  	};
> =20
> +	bl_reg: backlight_regulator {

No need to repeat the labels if they're already in the .dtsi file.

Thierry

--uJWb33pM2TcUAXIl
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUMnaWAAoJEN0jrNd/PrOhqLQQAJ67GFu6Rg1ip1QQ1ZQ26b7C
QoQBfj0fTqI2Oxnfk88131BlNdAu6RkJV2rG4nYUKo/tOnf/+RSp3NF1XMNQelAC
NBnpYdq00/13HMPHepx6jKweJVLceT1q9WZu649Wiii8RKSnefefUq2VlfGCeLFW
ttKBQRXXqm90VmApN69AvyRb6hLAWCabZBYWerHKnUJ6hvIUcOMvVXBTNfWGX4O+
dkwYMXkVrOZAeB1DLwZx1ZSRin3hoInWH/7LqiOyBk2fKKl4Id056GYT2wgC1fIw
kIHxI548GqJstHEMipWl4sSWTUfeV9hn5pObPL8BsDGVo5Ax9XOg4cMpXMAbfqHm
/UOC1fhC9wIUfuZkrdlLzWKUAG73ar0qRDa1HK/pyNzL9FpG7SoucfW7oCNeGI0h
TJh+Hy4xSlcazN767f7ng5ViGOat2FfNgmBV00/DIYe502uv2Z2YquWqw45j5QfE
7Q2Izqnv1jJKNfxJq4vhA9czYOPgGUG9i4bS1kP3p3wFB1aLyu6MjzkRRjjHyjMq
vztfZiFZIeDSRg3BZ5wBbURLxayaNizcCMfcB19DjVLVMwUG/7BU+PNVA+BVS/59
m6iPjs+BqB/B8HoC+roZR41TaIOTPfR9hUeK6MzdsAry+eop/MlPwvvHyGDRgYmL
fKJF1ERoDy14oev9a6I2
=CONy
-----END PGP SIGNATURE-----

--uJWb33pM2TcUAXIl--
