Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754117AbaBLTZI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 14:25:08 -0500
Received: from top.free-electrons.com ([176.31.233.9]:46455 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753344AbaBLTZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 14:25:07 -0500
Date: Wed, 12 Feb 2014 20:22:43 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Chen-Yu Tsai <wens@csie.org>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        David Lanzendoerfer <david.lanzendoerfer@o2s.ch>,
        stable@vger.kernel.org
Subject: Re: [PATCH] pinctrl: sunxi: use chained_irq_{enter, exit} for GIC
 compatibility
Message-ID: <20140212192243.GC9812@lukather>
References: <1392049357-13225-1-git-send-email-wens@csie.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4jXrM3lyYWu4nBt5"
Content-Disposition: inline
In-Reply-To: <1392049357-13225-1-git-send-email-wens@csie.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--4jXrM3lyYWu4nBt5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 11, 2014 at 12:22:37AM +0800, Chen-Yu Tsai wrote:
> On tha Allwinner A20 SoC, the external interrupts on the pin controller
> device are connected to the GIC. Without chained_irq_{enter, exit},
> external GPIO interrupts, such as used by mmc core card detect, cause
> the system to hang.
>=20
> Cc: stable@vger.kernel.org
> Signed-off-by: Chen-Yu Tsai <wens@csie.org>

Acked-by: Maxime Ripard <maxime.ripard@free-electrons.com>

Thanks!
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--4jXrM3lyYWu4nBt5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJS+8oDAAoJEBx+YmzsjxAgLwcP/jYTeWFcouJMbap2vDPrAL1c
PSZ2fCG/HxkAGkKpS3OaLQK4DLxmg96NYim/X5CZf68bM9LIYsXX+3Wj70NGb0PH
+HfdyPZvlIEiwlp9Y59O3B8Sl0s5B19E0bWnSNiNRmBHsUkOyvexGGgHXGoYKLgH
RwDKfH9l7Kz64yOLl/LNiP3dx6r876AUYItaeeONV1zAFFn9YMu2pg0AMGguG90+
6PrcaTrnBGtZmJvii2dOqChg2xqiUEHctVyXgkk4c1wkm87Zdl9krTt6sQPolLz7
aNIQ3fDxJ8o5iujNBLKklH134U6JDQNFJ7uOVUlY3Vh+N0JvHwAG8opxj2t58RC2
0uWd24pa8PXOnnhD9xYcuuHXwNeelK0VrNFxE18xSl0ISceXFdevdFdtMBuLdDub
MFdhL9WlVMBsEv0ESS4GRX1AjvKbagJl5r4teP27L16OVPos3/o2hI+4ZG+8khfB
GjBf1mQGXOS1mbFjcQ6SYWvD3RgobiOL5f8BZVgdapQzh0xhe01OH8QoNk7bQKN3
IjOMR+vAHIOeT/6M0DzEk2dPmETuelYw82IWNgcFmqJjL4m3k5xCV+Hbz4Z8zTGV
aL9yOeJDaLX0WlA2SRchU9LNjDkrPy7/O01dOjixIYwrobBMZc/UDRA13+LpgTog
uugsTzNrZD8OaUdPnG7B
=IYHO
-----END PGP SIGNATURE-----

--4jXrM3lyYWu4nBt5--
