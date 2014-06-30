Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756889AbaF3Sem (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 14:34:42 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:43613 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756399AbaF3Sel (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 14:34:41 -0400
Date: Mon, 30 Jun 2014 13:34:06 -0500
From: Felipe Balbi <balbi@ti.com>
To: Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>
CC: Felipe Balbi <balbi@ti.com>, <sebastian.hesselbarth@gmail.com>,
        <alexandre.belloni@free-electrons.com>,
        <thomas.petazzoni@free-electrons.com>, <zmxu@marvell.com>,
        <jszhang@marvell.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Kishon Vijay Abraham I <kishon@ti.com>
Subject: Re: [PATCH v2 05/12] usb: phy: add the Berlin USB PHY driver
Message-ID: <20140630183406.GT31442@saruman.home>
Reply-To: <balbi@ti.com>
References: <1403606121-6368-1-git-send-email-antoine.tenart@free-electrons.com>
 <1403606121-6368-6-git-send-email-antoine.tenart@free-electrons.com>
 <20140627155622.GL8069@saruman.home>
 <20140627160557.GA6622@kwain>
 <20140627230433.GC762@saruman.home>
 <20140630145211.GA29613@kwain>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="D+M1YvVlDncl3vD5"
Content-Disposition: inline
In-Reply-To: <20140630145211.GA29613@kwain>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--D+M1YvVlDncl3vD5
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 30, 2014 at 04:52:11PM +0200, Antoine T=E9nart wrote:
> Felipe,
>=20
> On Fri, Jun 27, 2014 at 06:04:33PM -0500, Felipe Balbi wrote:
> > On Fri, Jun 27, 2014 at 06:05:57PM +0200, Antoine T=E9nart wrote:
> > > Hi Felipe,
> > >=20
> > > On Fri, Jun 27, 2014 at 10:56:22AM -0500, Felipe Balbi wrote:
> > > > On Tue, Jun 24, 2014 at 12:35:14PM +0200, Antoine T=E9nart wrote:
> > > > > Add the driver driving the Marvell Berlin USB PHY. This allows to
> > > > > initialize the PHY and to use it from the USB driver later.
> > > > >=20
> > > > > Signed-off-by: Antoine T=E9nart <antoine.tenart@free-electrons.co=
m>
> > > >=20
> > > > since this is a brand new driver, it should go to drivers/phy inste=
ad.
> > >=20
> > > This PHY is used by a ChipIdea USB driver, which uses the provided
> > > common function for ChipIdea. These functions use the usb_phy framewo=
rk.
> > > That's why this PHY driver is there.
> >=20
> > right, but you can add support for the new PHY layer which would help
> > other users convert their PHY drivers to the new PHY framework.
>=20
> Adding the support for the new PHY layer in the common CI code is not
> complicated, but these functions also use some parts from usb hcd or usb
> otg which are only usb_phy compatible.
>=20
> Shouldn't these parts add the new PHY support first, to avoid ending up
> with a fairly big series, quite long to do and complicated to review?

sure, patches are welcome. :-)

--=20
balbi

--D+M1YvVlDncl3vD5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTsa2eAAoJEIaOsuA1yqREkAEP/235IN/u5ZOmX6Fl6qEwJx8U
R8AwZXOMzaie5vFm2rDwnixUeClUJBiCwONlR6PGGVrwx1lYw/dkOsUJmOZlfxiC
EGdFvt1Wi3zf+21oyBHP2RijhzfpQDsA4SJv7ppsOhjczmC6c3YEmr47EoP7UZ2h
8jU1Q8WTx2UVw5N8lzKNUKEhfOX7Ur0Kp/euQ/j5gpxnVd+eJgBy3omo9fPVNN1s
L+vN85lxp2DH6uY1NbiGVe0Jj0r+4tbKkUHmERg8Bf7ak/+ykaJaeVn+93Rbv01/
1OEpsno2QX6aKfIErC3uQGug70NQRUkKPmMtWhKvHxiNqXj+EiceQ74UThALBvbg
kP0qUPCDvbVK0afc8/PSnQxEmIyCqzk258DhVVQjJ1Mu3BZROuWGeMzxx3/5Imub
GQ5zZqSD6F18MmXEOvsu2epOE88bu3a0Z5Z5q2SMV51rgJ1gxuGCueCQZlTTSoVX
NmaFE0V1nBA8xqa8oqJEOQBlKcuKArEx0h31zAzECI3HiH0m2sJRkIkduPUitDsG
YWGHoWqskZYFbNWlL1o0+z6dZQXNtlavSPvnxgKD9liUuZwAq/kfQ7UjZ2Q0ZcSJ
rezjOPXLf0fdDisXeNifbvpmKyMMfDI5QdZn+5opXis/e0mZKwS+ecNsnV6XPgn9
CPo7MkLuCZE26NgUlzT9
=cvPO
-----END PGP SIGNATURE-----

--D+M1YvVlDncl3vD5--
