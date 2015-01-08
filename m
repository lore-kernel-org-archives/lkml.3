Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757371AbbAHSiJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 13:38:09 -0500
Received: from sauhun.de ([89.238.76.85]:45930 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757353AbbAHSiF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 13:38:05 -0500
Date: Thu, 8 Jan 2015 19:38:00 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: kbuild test robot <fengguang.wu@intel.com>
Cc: kbuild-all@01.org, Lars Poeschel <poeschel@lemonage.de>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [wsa:i2c/quirks 10/11]
 drivers/i2c/busses/i2c-viperboard.c:357:27: sparse: symbol 'vprbrd_quirks'
 was not declared. Should it be static?
Message-ID: <20150108183800.GC29629@katana>
References: <201501090239.gPJgrJIE%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="aT9PWwzfKXlsBJM1"
Content-Disposition: inline
In-Reply-To: <201501090239.gPJgrJIE%fengguang.wu@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--aT9PWwzfKXlsBJM1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 09, 2015 at 02:07:53AM +0800, kbuild test robot wrote:
> tree:   git://git.kernel.org/pub/scm/linux/kernel/git/wsa/linux i2c/quirks
> head:   b1d39af8ae21f4930854b0656aa83a83fd38049e
> commit: 5f7099010eda61b777ba84cf9b64dc8428846d25 [10/11] i2c: viperboard:=
 make use of the new infrastructure for quirks
> reproduce:
>   # apt-get install sparse
>   git checkout 5f7099010eda61b777ba84cf9b64dc8428846d25
>   make ARCH=3Dx86_64 allmodconfig
>   make C=3D1 CF=3D-D__CHECK_ENDIAN__
>=20
>=20
> sparse warnings: (new ones prefixed by >>)
>=20
>    drivers/i2c/busses/i2c-viperboard.c:128:35: sparse: incorrect type in =
assignment (different base types)
>    drivers/i2c/busses/i2c-viperboard.c:128:35:    expected unsigned short=
 [unsigned] [usertype] addr
>    drivers/i2c/busses/i2c-viperboard.c:128:35:    got restricted __le16 [=
usertype] <noident>
>    drivers/i2c/busses/i2c-viperboard.c:201:34: sparse: incorrect type in =
assignment (different base types)
>    drivers/i2c/busses/i2c-viperboard.c:201:34:    expected unsigned short=
 [unsigned] [usertype] tf1
>    drivers/i2c/busses/i2c-viperboard.c:201:34:    got restricted __le16 [=
usertype] <noident>
>    drivers/i2c/busses/i2c-viperboard.c:202:34: sparse: incorrect type in =
assignment (different base types)
>    drivers/i2c/busses/i2c-viperboard.c:202:34:    expected unsigned short=
 [unsigned] [usertype] tf2
>    drivers/i2c/busses/i2c-viperboard.c:202:34:    got restricted __le16 [=
usertype] <noident>
>    drivers/i2c/busses/i2c-viperboard.c:237:35: sparse: incorrect type in =
assignment (different base types)
>    drivers/i2c/busses/i2c-viperboard.c:237:35:    expected unsigned short=
 [unsigned] [usertype] addr
>    drivers/i2c/busses/i2c-viperboard.c:237:35:    got restricted __le16 [=
usertype] <noident>
>    drivers/i2c/busses/i2c-viperboard.c:300:35: sparse: incorrect type in =
assignment (different base types)
>    drivers/i2c/busses/i2c-viperboard.c:300:35:    expected unsigned short=
 [unsigned] [usertype] len
>    drivers/i2c/busses/i2c-viperboard.c:300:35:    got restricted __le16 [=
usertype] <noident>
>    drivers/i2c/busses/i2c-viperboard.c:325:35: sparse: incorrect type in =
assignment (different base types)
>    drivers/i2c/busses/i2c-viperboard.c:325:35:    expected unsigned short=
 [unsigned] [usertype] len
>    drivers/i2c/busses/i2c-viperboard.c:325:35:    got restricted __le16 [=
usertype] <noident>
> >> drivers/i2c/busses/i2c-viperboard.c:357:27: sparse: symbol 'vprbrd_qui=
rks' was not declared. Should it be static?
>=20
> Please review and possibly fold the followup patch.

Development branch noise, please ignore.


--aT9PWwzfKXlsBJM1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUrs6IAAoJEBQN5MwUoCm2GFMP/jmmXWoFTOzmP+sc5BHTjIv1
3BKyyihK+EzXNa7MeLltXBqPOXBFECpcDjWo/FFkaWh48vhk/bLGDUyw7RI3VyRo
lzuI94gQs5Ap5TPQQ9sgzBsuoi5oOxMtxc5dliHK9UZA+pxYjK3dSCrv0WvOjZ8l
NESgdnkaPkLi90Hi03jS9da4lQ0fyy84iwzNsguc0uPop03Gpb16BqtTLIGeMPpA
BX9nwKy4mOKQpwFX92iD1jAW1sp82KKKHxLxa5IqN4rskWimPpV5r5WGCjJuNlSs
2GhlokV8cEn8asZVeX9/NqCiMR6rFP9eGJdz/sbb17AXdlkxHSFU+MQuQhJDEWNj
1KaahhYbsdCKZM5k9ul7CTUl5UfEbDA5j8sDKWqwkS92RktqBiKRGhWiD1SYDh+X
JZeag1/yYvqoJlJPJLSq2OtD8o4Rfd+5NMIF39wkVPiQYq5DVZijwOIJgFEIdiOi
t2VxtASxRTDsw6RgU3Vs1I6AFiDRXbeDS7nrIIznSDITN4oxuvLQFlc4baV/ojXk
yCQyCB4RrmUe5yRGKtRWgOUder5W7X9F+i3lEehcXIpIZKfCRU59XRY8bIt6Y0Gq
sL7sHFytUgpZEb8goUFsdbj8SaMrZizGt5k79hIqmimVFymSH47KFw7HQg+QnV9K
xZRQLcmvbbPBFSWzEWCR
=V9Yt
-----END PGP SIGNATURE-----

--aT9PWwzfKXlsBJM1--
