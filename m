Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752991AbaEHDUU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 23:20:20 -0400
Received: from top.free-electrons.com ([176.31.233.9]:35237 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752327AbaEHDUS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 23:20:18 -0400
Date: Wed, 7 May 2014 22:09:02 -0500
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Boris BREZILLON <boris.brezillon@free-electrons.com>
Cc: Emilio =?iso-8859-1?Q?L=F3pez?= <emilio@elopez.com.ar>,
        Mike Turquette <mturquette@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Chen-Yu Tsai <wens@csie.org>, Philipp Zabel <p.zabel@pengutronix.de>,
        Shuge <shuge@allwinnertech.com>, kevin@allwinnertech.com,
        Hans de Goede <hdegoede@redhat.com>,
        Randy Dunlap <rdunlap@infradead.org>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, dev@linux-sunxi.org
Subject: Re: [PATCH v2 3/7] mfd: add support for sun6i PRCM
 (Power/Reset/Clock Management) unit
Message-ID: <20140508030902.GM7047@lukather>
References: <1399483554-8824-1-git-send-email-boris.brezillon@free-electrons.com>
 <1399483554-8824-4-git-send-email-boris.brezillon@free-electrons.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fDP66DSfTvWAYVew"
Content-Disposition: inline
In-Reply-To: <1399483554-8824-4-git-send-email-boris.brezillon@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--fDP66DSfTvWAYVew
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 07, 2014 at 07:25:50PM +0200, Boris BREZILLON wrote:
> The PRCM (Power/Reset/Clock Management) block exposes several subdevices
> in different subsystems (clk, reset ...)
>=20
> Add basic support for the PRCM unit with clk (AR100, AHB0, and APB0 clks)
> and reset controller subdevices.
>=20
> Other subdevices might be added later (if needed).
>=20
> Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>

Acked-by: Maxime Ripard <maxime.ripard@free-electrons.com>

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--fDP66DSfTvWAYVew
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJTavVNAAoJEBx+YmzsjxAgFpMP/3ArSkZZhg42co4ng3x9qKtn
sIFoDNH6TMDMR7Tuj5tL6+gjnm/s1rQwF+t60CW/1dNjtEPQdqKumHj394N7CCPq
0R1e3GF4XS8+DpLjUUuTBCS/l61soJ5lt52HVAq/BtrwzmBrR8FpiAqfVUotIzmc
J3pHaZP94H7CMMCwfKz16nyRyn2w/MDgl0COu/7GrTRSuO6Rl1mCr55s6hfPDAMj
HF0CZkmjFqqCrsZ3w1pd2pUsSuyrWpllj5JnsLYnIt38ovkOQUyl7nxII55/BCOj
Ez/J3ciK8y+OrqGm2qx99SF9oYpQE7xJA12bG6qHcWiPhdkFFoI/FVAyPI4iTMFQ
2WFi2QoDqLYjRY+mQw5dxjaWRE6b/3g7ET5TA53UtNVlUmTLjcc0Dm5jbdjjz1cQ
KvWpLJ5LZ/ocj0+ZkaGjnW0PwsJXAbypURjzddlSGX2WTpcEoLdsjCxT9amPLmK5
9GGddt7gQjEIoV3Ic7N20sRojP4nsCvm4jkg7LQwdbVE4x+WWHl8Z6T0GB6dd+3x
pczPybv3eBKJHHo22peSqcbUvatve27U4th3FcZxBj3G7K8JesExj3/rmYTconoC
sIwlAr+Dq++IlLHX3YQZVI+gxMnMojrtowIrceK/ZIRWx9Slt6sRXA5mzNGnjAfg
6MpH9IfY2+Vpanp52YW3
=ulZe
-----END PGP SIGNATURE-----

--fDP66DSfTvWAYVew--
