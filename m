Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752586AbaAQQIa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 11:08:30 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:56051 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752205AbaAQQI1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 11:08:27 -0500
Date: Fri, 17 Jan 2014 16:08:21 +0000
From: Mark Brown <broonie@kernel.org>
To: Nishanth Menon <nm@ti.com>
Cc: devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <20140117160821.GV17314@sirena.org.uk>
References: <1389900750-27625-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tYlHSoJ8Aop8eNG2"
Content-Disposition: inline
In-Reply-To: <1389900750-27625-1-git-send-email-nm@ti.com>
X-Cookie: We have DIFFERENT amounts of HAIR --
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: ti-abb: Add support for interleaved LDO
 registers
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--tYlHSoJ8Aop8eNG2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 16, 2014 at 01:32:30PM -0600, Nishanth Menon wrote:
> Certain platforms such as DRA7 have quirky memory maps such as:
> PRM_ABBLDO_DSPEVE_CTRL	0x4ae07e20
> PRM_ABBLDO_IVA_CTRL	0x4ae07e24
> other-registers
> PRM_ABBLDO_DSPEVE_SETUP	0x4ae07e30
> PRM_ABBLDO_IVA_SETUP	0x4ae07e34
>=20
> These need the address allocation to be either shared OR unique
> allocation per register instance.

Is there a system controller involved here by any chance?

--tYlHSoJ8Aop8eNG2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS2VVyAAoJELSic+t+oim9XwoQAIjGJfqR+6qVUUGLZJFGfFmh
ucGBlJvtAcU/1j+tYln5lGGvUAaurt/LF6/Yltjq0j1pyZ7PdiOoTdL6J7x/s4ZN
oZFuD6FGp5mxRmTXOOhLCT8YCK4BvBlNzPf7OvcPsHnTgHwOQl0XdiHCprWT7fNx
DJhRdOp3blcoVhA7yCb+VtGQTY+0f2dMT/I2LISe7GWh6cFxlQX0CJKSlHDJLqYY
sqRp23v03+R7jq5c5a3WHQJZER8TQzHG4yuE1aY8huZPzYsxQM5Dq95i2qbbXuuC
Yfwhbfbh9DKU4NY159Eoy+pOIwpgCOwSciPlAroiK8KxkuzZDDqPCeRV39BVr0aR
cLrqv2C83lsb7u2wixGlrfmRPGv8+Ldm2zvas9zucFrBf/b86C4h6cV3dwmZ4xjV
lpKWSYzAg+84v2SMpCkeys54xH7dGWNP3qWARbiG/x1uGJDzgaxdoRu/C3O5jyiZ
WgxSfhe8pOK9OtcnMZTkkWrYyhS2iN6CqAvw8keApROB8g7cSwMC2NwEHpmcSqaT
oB6onsG+CqGyYbTk1kVB8OgBHZy5j300qeGcBRo9jTwqnWltDj7YX91qK5VwPyuo
H4uKWsLzzu+ZchhaQC4euuoPG7114EQ28cCA5wfjkdrAssuEnbhs/zNbqNdj3+f5
hSv/toVbOeiBoe3v0i/x
=kV/j
-----END PGP SIGNATURE-----

--tYlHSoJ8Aop8eNG2--
