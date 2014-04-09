Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933949AbaDIPkU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 11:40:20 -0400
Received: from top.free-electrons.com ([176.31.233.9]:33550 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933477AbaDIPkQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 11:40:16 -0400
Date: Wed, 9 Apr 2014 17:38:49 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Boris BREZILLON <boris.brezillon@free-electrons.com>
Cc: Randy Dunlap <rdunlap@infradead.org>,
        Emilio =?iso-8859-1?Q?L=F3pez?= <emilio@elopez.com.ar>,
        Mike Turquette <mturquette@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 14/15] pinctrl: sunxi: define A31 PL0/PL1 pins
Message-ID: <20140409153849.GK28585@lukather>
References: <1397051478-4113-1-git-send-email-boris.brezillon@free-electrons.com>
 <1397051478-4113-15-git-send-email-boris.brezillon@free-electrons.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="d6d1KVhp94hk3Jrm"
Content-Disposition: inline
In-Reply-To: <1397051478-4113-15-git-send-email-boris.brezillon@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--d6d1KVhp94hk3Jrm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 09, 2014 at 03:51:17PM +0200, Boris BREZILLON wrote:
> Define PL0/PL1 pins available on the A31 SoC.
>=20
> Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
> ---
>  drivers/pinctrl/pinctrl-sunxi-pins.h | 8 ++++++++
>  1 file changed, 8 insertions(+)
>=20
> diff --git a/drivers/pinctrl/pinctrl-sunxi-pins.h b/drivers/pinctrl/pinct=
rl-sunxi-pins.h
> index 3d60669..274cefa 100644
> --- a/drivers/pinctrl/pinctrl-sunxi-pins.h
> +++ b/drivers/pinctrl/pinctrl-sunxi-pins.h
> @@ -2818,6 +2818,14 @@ static const struct sunxi_desc_pin sun6i_a31_pins[=
] =3D {
>  		  SUNXI_FUNCTION(0x0, "gpio_in"),
>  		  SUNXI_FUNCTION(0x1, "gpio_out"),
>  		  SUNXI_FUNCTION(0x2, "nand1")),	/* CE3 */
> +	SUNXI_PIN(SUNXI_PINCTRL_PIN_PL0,
> +		  SUNXI_FUNCTION(0x0, "gpio_in"),
> +		  SUNXI_FUNCTION(0x1, "gpio_out"),
> +		  SUNXI_FUNCTION(0x3, "p2wi")),		/* SCL */
> +	SUNXI_PIN(SUNXI_PINCTRL_PIN_PL1,
> +		  SUNXI_FUNCTION(0x0, "gpio_in"),
> +		  SUNXI_FUNCTION(0x1, "gpio_out"),
> +		  SUNXI_FUNCTION(0x3, "p2wi")),		/* SDA */

If possible, I'd prefer to have this list as exhaustive as
possible.

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--d6d1KVhp94hk3Jrm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJTRWmJAAoJEBx+YmzsjxAggbYP/1M4fxdAcA9gWxq6EdoCVIpY
ewlL0RvAIZNUp4iycQ8lhavEojGxJLVKRW8aiqXTdvCp5OO1YBooTeXtZyWRyx9e
q9ExCwSkI1GyvYPBLekVtKyHCsqbolMuqwaGjeYinFU9J2wJPEmPv0nfF4KNWTSf
YnqR0FyIHcaKJdZUshnVvOK5RFuE26vcwTLyCr0CPqrhQNfH0sZKyTQVSvgSDGD/
SPMBpXc3nWAd2eAF46xahvSw/qtoT0U8gA2MSu0rpYSngCgzdcFM9W0i4ckuiHxQ
v2szMzfmLA/tzS4pVvgD+V0reoC7q503jrm5qVkq60iQrHGrHlw2wQ2FLzf5YsSF
wPIqtvuTJ5XGhIAhKBJOHn+NoYY8/geIIKbhl7+GWPPWin3EZgAseBOR5Hu3/O3e
UQ3/k/gg+uHyMA0mTyQO+xU8a4fAOE3wmfhdbpBkBxaqf7FMUVxUBqqs3+V7okJX
eqfZciL+RQ+ihTFWpuDoV5DZZ4SBHyeuzx5+PqrPP2ohMXb99CKzd1NqFr204E6x
kdmagzvol93hv/MdyISF15CIAmhf7YX2OB+uDkAPExY2pn6/yzdM0ddNkXWVPawG
8f7jopIBHIzmjRd4C0vrILMZAzDyRniM1Rdp8RlyNPJM1LwJChxwNYcTtSp4yEmW
9g9aH6WLMrhexzvsdMQN
=sumE
-----END PGP SIGNATURE-----

--d6d1KVhp94hk3Jrm--
