Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752134AbaEUI01 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 04:26:27 -0400
Received: from sauhun.de ([89.238.76.85]:46099 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750883AbaEUI0Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 04:26:25 -0400
Date: Wed, 21 May 2014 10:26:21 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Kaushal Butala <kaushalkernelmailinglist@gmail.com>
Cc: Shawn Guo <shawn.guo@freescale.com>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH-v2] SMBus block read support to imx_i2c
Message-ID: <20140521082621.GF2708@katana>
References: <20140402083046.GB8753@dragon>
 <1396616170-6659-1-git-send-email-kaushalkernelmailinglist@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="i3lJ51RuaGWuFYNw"
Content-Disposition: inline
In-Reply-To: <1396616170-6659-1-git-send-email-kaushalkernelmailinglist@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--i3lJ51RuaGWuFYNw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 04, 2014 at 02:56:10PM +0200, Kaushal Butala wrote:
> The smbus block read is not currently supported for imx i2c devices.
> This patchset adds the support to imx i2c bus so that blocks of data
> can be read using SMbus block reads.(using i2c_smbus_read_block_data()
> function from the i2c_core.c.). Tested with 3.10.9 kernel.
>=20
> Reviewed-by: Shawn Guo <shawn.guo@freescale.com>
>=20
> Signed-off-by: Kaushal Butala <kaushalkernelmailinglist@gmail.com>
> ---
> v2:
> Updated after review comments from Shawn Guo. Removed unnecessary parenth=
esis
> around 'block_data'.
>=20

Applied to for-next, thanks!


--i3lJ51RuaGWuFYNw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJTfGMsAAoJEBQN5MwUoCm2lcAP/jjdMdzV/3TT/D55D8Qz2UD5
dWH5vvWFJiJ4csIt2gl3NrhGMxoswUV1sweoIVmySWQhK4HYPNQaILye4R+zY0ru
1hq/7WFeDgalJXYQGC/5YFZWby3DVFYWmMKcfU5z/8YlsNPXkb8wYBh/D3cEX7Fg
k/QNl1OZ47GOJ96iODDr6jYGCo6ekcHGx9AoaDUJd2Fpa4pyoyU/aZXDGE93eeRk
2MBNhQdi/+EetldYx5GLfStLFf+arU3kaA/QBjyQzWdXZsroF9yK+rCJ8hlG+uk8
GJEUCO6ljBShRJcs3zQ4XB5YZaX8EEpPob1DXRoq13iYxQPAudr6VPR4/svuG5lY
wJ0mn93/BaakV8VUSPINM8Fp6Cplz0y0xIVinoh4vB7wu/tGMm+ms7kU2lzuFIxq
5MjxznKTeghucbAi0zXwGLkNBWlxim7LyCBLZ6Y6IAnMITDkQRo4wlM+wDipFC/v
dxApcGtLWPYp9q0R42Qoqe0/MNIv+nw3LN03oOEqQF3oRJMHNVLXjtiHSy2J1TzD
97S7NcUBhBak0tkvxkgBwFxg1bOm6Ys4C2ah67XWz07FxdxpjHVIp3beQoU5i7QK
W8r9nAv/6xTwKP/SwwJZ2sB7P36NBuhYJh0O5L6Cmke+zRbONcLefR53NUjCBrPY
9pLZBJ5MrYkhJaOlNaxq
=PjCS
-----END PGP SIGNATURE-----

--i3lJ51RuaGWuFYNw--
