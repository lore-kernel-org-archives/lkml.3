Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751588AbaEYTm3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2014 15:42:29 -0400
Received: from top.free-electrons.com ([176.31.233.9]:33493 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751170AbaEYTmY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2014 15:42:24 -0400
Date: Sun, 25 May 2014 20:46:37 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Chen-Yu Tsai <wens@csie.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mike Turquette <mturquette@linaro.org>,
        Emilio Lopez <emilio@elopez.com.ar>,
        Linus Walleij <linus.walleij@linaro.org>, linux-serial@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Luc Verhaegen <libv@skynet.be>
Subject: Re: [PATCH 19/22] ARM: sunxi: Add earlyprintk support using R_UART
 (sun6i/sun8i)
Message-ID: <20140525184636.GN10768@lukather>
References: <1400831485-28576-1-git-send-email-wens@csie.org>
 <1400831485-28576-20-git-send-email-wens@csie.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="uMPAU7A2Er6+wvsD"
Content-Disposition: inline
In-Reply-To: <1400831485-28576-20-git-send-email-wens@csie.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--uMPAU7A2Er6+wvsD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, May 23, 2014 at 03:51:22PM +0800, Chen-Yu Tsai wrote:
> sun6i/sun8i have a UART in the RTC block group, which can be used
> as an early console. This is most useful on sun8i as UART0 is muxed
> with MMC0, which is not available if we boot from MMC.
>=20
> Signed-off-by: Chen-Yu Tsai <wens@csie.org>
> ---
>  arch/arm/Kconfig.debug | 10 ++++++++++
>  1 file changed, 10 insertions(+)
>=20
> diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
> index eab8ecb..9e22708 100644
> --- a/arch/arm/Kconfig.debug
> +++ b/arch/arm/Kconfig.debug
> @@ -694,6 +694,14 @@ choice
>  		  Say Y here if you want kernel low-level debugging support
>  		  on Allwinner A1X based platforms on the UART1.
> =20
> +	config DEBUG_SUNXI_R_UART
> +		bool "Kernel low-level debugging messages via sunXi R_UART"
> +		depends on ARCH_SUNXI

It should rather depend on MACH_SUN8I.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--uMPAU7A2Er6+wvsD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTgjqMAAoJEBx+YmzsjxAg/aIQAJE2zxfOsXS85Br6iceb6YRJ
gBNG3L83F1beFXUuIL2B+ptBTJx6xeRjxnkpVCrWEzAdzhI/9ny9cwDgJCNGl0gy
WrcG/aHyps68muQZKVhv68C/OYrGzAZcBc2o9+Me8J5riPwHP8WRqW+BOx8J6aIL
MV15bJAsaPQOyGADy+oXqGvHsNokt3D2MnjHL61nkkOx55XkdTNkge7Yi7L3jI6x
wwLdkKi9wQgc4/RqZM7fuHWth3M0o6mB6kQQhVgqAm68mKVlAqtA7cxWeo19GHEl
jzXzgrMngjKti7sPx0JPe9J5OnLbd2YO5M9t8E1Av1rPUhcYfGjSXRe0FJSHp5Jx
7/PEdkAS0LivxX3lO6XzTytkTbX0TJJwhFjKVXvXboRrz9cvMK6wtKqrQ2bv1HIL
zs4gZ+1i8Md3rpr5PMylWpqnkbAO5OeBE3hgY7gf+ia/LCIrXFCEbNmZhEEpXCHD
YfvWxl+5W/HvA54cx5VmacmG4InoyE3PZYdn7+RFJG+odjHoSLebOFn5CGca5S59
4Keu0y9WjSZ6hw+EaCNeSCTrBtCT/+Kiyt/U+zxnL09UY4e+a03UvGPuYhXbX7u7
uZhc8ycMpAuDAC/QC7EJy05SaFg3yy8msG6Iq59XLZrBUl5fpdURO29/t8LSnw7u
AOztEeoNmMDDxuE10HNM
=N9BP
-----END PGP SIGNATURE-----

--uMPAU7A2Er6+wvsD--
