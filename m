Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752352Ab3BRSXS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 13:23:18 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:59573 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751634Ab3BRSXQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 13:23:16 -0500
Date: Mon, 18 Feb 2013 20:22:40 +0200
From: Felipe Balbi <balbi@ti.com>
To: Afzal Mohammed <afzal@ti.com>
CC: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Russell King <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>, Marc Zyngier <marc.zyngier@arm.com>,
        Nicolas Pitre <nico@linaro.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Will Deacon <will.deacon@arm.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Landley <rob@landley.net>, Sekhar Nori <nsekhar@ti.com>,
        Syed Mohammed Khasim <khasim@ti.com>
Subject: Re: [PATCH, RFC 7/8] ARM: dts: am4372: initial support
Message-ID: <20130218182240.GA10755@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <cover.1361186097.git.afzal@ti.com>
 <c9c131c0508b875c0893e8557504372a1564568a.1361186097.git.afzal@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HlL+5n6rz5pIUxbD"
Content-Disposition: inline
In-Reply-To: <c9c131c0508b875c0893e8557504372a1564568a.1361186097.git.afzal@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--HlL+5n6rz5pIUxbD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Feb 18, 2013 at 05:08:16PM +0530, Afzal Mohammed wrote:
> +		uart1: serial@44e09000 {
> +			compatible =3D "ti,am4372-uart","ti,omap2-uart";
> +			clock-frequency =3D <48000000>;
> +			reg =3D <0x44e09000 0x2000>;
> +			interrupts =3D <0 72 0x4>;

missing ti,hwmods ??

--=20
balbi

--HlL+5n6rz5pIUxbD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRInFwAAoJEIaOsuA1yqRE28MP/3E3Dj63dULqlnF+vytnOoft
VE60mB7NGEU6lehR41LCXcLiZK5CH5XNUynuC+eUykTzGjh7Tcx3u+MLTg0nkzra
Nns/6ohhnALowcAVwAoXHI3HspY6r/YAAmybR/XXrB8LOSKKFiZq5Ak4q/+iYupD
Ic66WpaGV85NDX8TELFgeRLCZo0TxT/mAaA3RkdVNf7tJtQF1cPbVi+fdJLGvq4j
UqeXwp/YbWycIn+6dydWJxAslGIPi5V4ll9/cdhC5oY/ot8awe+moM55O2HxBuLK
FAeKldpm4yQCDXcECMAQKhClo7rwuZ7GqvDMxxcii2sxBywVS0wdgyz6EF422Ost
Nrws6fTfBWfKJy961xHEYx6h7OtXpiV1mvE5LCso1aGOTeiE1C4+a2miwpBMxE+1
meLzMSbTRswASX3wim0bMxsWg2A6A9NGHQbTG2F8C31Euzi8smDSsMQfOc/sh6ij
kERgQam5l8EvWaRqCi2OGvsIQ/1rfHjp3+HjzaG+tO1z5n93TGL1gmU3UEoYeXBT
iWE8plppPMwJp+d9apjFnG+hvKGZyjAkd4uHb9xAs5fj6B27NdLtk3TkBQTb35gO
B9lzOmDdNOua957cFxgnHM6yVqPtliJAvxLxuO2t9Sbr9RUb/zRQjGwOzQOCsGIu
+pU3un+qlAboiNmh4jiX
=Gbnv
-----END PGP SIGNATURE-----

--HlL+5n6rz5pIUxbD--
