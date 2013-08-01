Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754677Ab3HALec (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 07:34:32 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:51083 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753193Ab3HALea (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 07:34:30 -0400
Date: Thu, 1 Aug 2013 14:34:13 +0300
From: Felipe Balbi <balbi@ti.com>
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Sebastian Sewior <bigeasy@linutronix.de>
Subject: Re: [ANNOUNCE] 3.10.4-rt1
Message-ID: <20130801113413.GK7918@radagast>
Reply-To: <balbi@ti.com>
References: <alpine.DEB.2.02.1308011215160.4089@ionos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="V3eawNQxI9TAjvgi"
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1308011215160.4089@ionos.tec.linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--V3eawNQxI9TAjvgi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Aug 01, 2013 at 01:24:10PM +0200, Thomas Gleixner wrote:
> Dear RT folks!
>=20
> I'm pleased to announce the 3.10.4-rt1 patch set.
>=20
> This is a mostly straight forward port of the 3.8 set. I had
> experimented with a new implementation detail, but I did not get it
> into a shape which would have made it applicable to RT.
>=20
> Known issues:
>=20
>       - SLAB support not working
>=20
>       - Untested on ARM and PPC (hapless victims^W^Wtesters are
>         welcome)
>=20
> I'm about to leave for my annual kids summer camp kitchen duty, so I
> let you fool around with the current pile.
>=20
> Sebastian will help out while I'm away, so please send tons of patches
> in the next couple of days and get this thing fixed before I
> return. All I'm going to look for in my mail backlog is a mail with
> the subject: 3.10.x-rty is perfect :)
>=20
> The RT patch against 3.10.4 can be found here:
>=20
>   http://www.kernel.org/pub/linux/kernel/projects/rt/3.8/patch-3.10.4-rt1=
=2Epatch.xz

Here's correct link:

https://www.kernel.org/pub/linux/kernel/projects/rt/3.10/patch-3.10.4-rt1.p=
atch.xz

> The split quilt queue is available at:
>=20
>   http://www.kernel.org/pub/linux/kernel/projects/rt/3.8/patches-3.10.4-r=
t1.tar.xz

and here:

https://www.kernel.org/pub/linux/kernel/projects/rt/3.10/patches-3.10.4-rt1=
=2Etar.xz

have fun on your kitchen duty ;-)

--=20
balbi

--V3eawNQxI9TAjvgi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR+ke1AAoJEIaOsuA1yqREXwkQAImn2JcuLNtyyPp8CTGswEEm
imrGTvBKE3XU1qIEjNvVJ9x0JmPoe81JTE/i2AenPE+hPfTd2aCFPYocM9YzsjIQ
gNHzVcHZWPFd4B2azwe95pnU8UwV7oRkIx7H798DhVkQTsI16f8yevhTQ5DN+mgN
N+2KlKcZLy28CT8tYCwEZrz/DyJkSqIX0ntvP7GOn+GWPi9w+USoTZ8/yOGDm6Uy
AzsqbKRBGL0oodmMnR4DZY+7c8DwFxF8gmYyZmBPDeekaFItApE6f2w9xGlAuzk6
jaV9VD09UwCftbFp6f1jWe0v43RxKiK2oRVfAxYdHMRCpMpZzBAdUxPv1JfhovFU
HW+QoFLkJJD5GL0mhe2jdpFmBGUfT1skJiDol+EMHUXpZ3fgzY9Gg1xu1xKnDwrM
g+VhlhM9slPTIc40QkUzNdBeUGohnljNFRiUW99jry0+4byeE1CZUzJId5BKfevb
Zl3Q991Yl6vI+Cz1uKjwWH3TGsIZr8Jufrl/BX2MJqYLJeQL6iG3Bd4EGg7UZuCg
y5UZvhR+ppZS3PfCQY8ZsPFoQYgc7SjptrzORXI8K23l4LyhRmmbbyzZ11lj1bKM
+6cpCZC8i1ZIagFmYkleTdGspTQXfO8OG758c3tVPPX1c9LNu4c9F3v9So660jdw
Jd7GMNW83dzK/6HSsq/o
=6dQQ
-----END PGP SIGNATURE-----

--V3eawNQxI9TAjvgi--
