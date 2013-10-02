Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753999Ab3JBL5Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 07:57:25 -0400
Received: from sauhun.de ([89.238.76.85]:38163 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753710Ab3JBL5X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 07:57:23 -0400
Date: Wed, 2 Oct 2013 13:57:20 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] misc: bh1780: probe from compatible string
Message-ID: <20131002115720.GE3059@katana>
References: <1380714407-22881-1-git-send-email-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tMbDGjvJuJijemkf"
Content-Disposition: inline
In-Reply-To: <1380714407-22881-1-git-send-email-linus.walleij@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--tMbDGjvJuJijemkf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 02, 2013 at 01:46:47PM +0200, Linus Walleij wrote:
> Currently the BH1780GLI I2C driver relies on the device tree node
> having the right name, but this is fragile. Use the compatible
> string to probe the driver instead.
>=20
> Cc: Wolfram Sang <wsa@the-dreams.de>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

Acked-by: Wolfram Sang <wsa@the-dreams.de>


--tMbDGjvJuJijemkf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSTAogAAoJEBQN5MwUoCm2UfUP/1En00sC02DI84YBMi4kR6I0
pUrGtaQ21L9pL8z07D+4ord928Kw8D/t3oiCJQldVcEI8UbYa0WKwZ8TsvfHoy+n
JCH1aRLCY5GvJHDPIDBtN3OgPnpmJr5xf88fNJ+E1F3lz8RWgK9FrlxgbgssFDQi
UkJ7o9G9xKk6Ni2+KrIg6WRbGEBt63DiT107kcms0hqvtPTqVgdDH7zf7AlPI1zD
pM3wpowufVZT41tnWib4xYIaVxjh9N1Qi+fpu4acWOeTX6jVbkGAoGrjSj226n8v
grXWqwRjJ+Q37xrmGQKhsj8z1Z/NdLMPSGtDqCelyJO8Mo0oRFqDLNoipa4J1lfS
9ZvTO/rr8rR/gx/tbU0jcMJAfaKSfMpPV/5oXRD/SvF9REr/5vYeMIZFJZLccX3e
GxKYnIr0MuLAO9Oc4If6e0xeHVGuWWKv9ommbydZMopotdo4TrywrhM0a7OCbLNc
dfFlfqEq7HiMLT0cnXyQd2tDMHiY1dV+2NtIh92T/RFTaRkk1uh50HpcbL4hlJrP
JeO/8r0MqlkBojBJi922mApAEUKEEM9mx20yDKl9kSc2eopDl55foZyKSWMYo0zG
xRi4b5m2o/UXcJXi6kTenVH3qiO3uDyhNP0G0SP0pvcc9Db6UqoErBiPPHhyF6W7
1CYBGLeF955A/Qmx/QQE
=SaBa
-----END PGP SIGNATURE-----

--tMbDGjvJuJijemkf--
