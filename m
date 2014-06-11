Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752169AbaFKJuG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 05:50:06 -0400
Received: from top.free-electrons.com ([176.31.233.9]:60418 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750757AbaFKJuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 05:50:04 -0400
Date: Wed, 11 Jun 2014 11:46:27 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: hdegoede@redhat.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] phy: sun4i: depend on RESET_CONTROLLER
Message-ID: <20140611094627.GF4254@lukather>
References: <1400871088-16894-1-git-send-email-maxime.ripard@free-electrons.com>
 <20140611091035.GD4254@lukather>
 <539824F9.6050302@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xJK8B5Wah2CMJs8h"
Content-Disposition: inline
In-Reply-To: <539824F9.6050302@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--xJK8B5Wah2CMJs8h
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 11, 2014 at 03:14:25PM +0530, Kishon Vijay Abraham I wrote:
> Hi,
>=20
> On Wednesday 11 June 2014 02:40 PM, Maxime Ripard wrote:
> > Hi Kishon,
> >=20
> > On Fri, May 23, 2014 at 08:51:28PM +0200, Maxime Ripard wrote:
> >> The driver depend on the reset framework in a mandatory way. Make sure
> >> reset_control_get is defined by adding this dependency in Kconfig
> >>
> >> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> >> Reported-by: Arnd Bergmann <arnd@arndb.de>
> >=20
> > Ping?
>=20
> Will queue once -rc1 is tagged.

Ok, thanks.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--xJK8B5Wah2CMJs8h
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTmCVzAAoJEBx+YmzsjxAguskQALr1kaQkhjNpYDHn+mOg0FaQ
Z62srh8S+Q4TgwXejxu7ULo2yaHz7GmVC8exzSrnmPY+CV9ceuJqjpg4ma65YQy6
4t9Uo7yIl8X4vz4mxs50rEayFGw5BtkQvpZMzhqbKE2KNs7MBmVpxlQsyiU7+y5v
aRfzxlI/63KLkHp+qaEh1lQmE5eGtqcFe9Od45M5luQuapzcyKESOZZQ1qH46eDI
2I+Wd5dMLwaY1gnFV5zsa1UmX95PNa4VKFOHMFEzuUS4Jith/tPiMuwcwDx6n3PR
BQwlUSbFYg9NgVWARhDt4PQgvcXNLha3vgft7RZZjHydHMsD1gYL75R8Puyom/cl
15cPmH9gzZiWMgWnyLURc7XKfZDfSJ4Ptif1W3ciirUgVbXsbhAERr7aUuAKq/OB
ato1nDXu3XLDNZVurZSH+pkX2LIvd2y2JObgOQI/n/EVO9w1SCpVdzrlt8Nz6LuJ
fRN2K61rzlrZlIGB9VxUDNw/mxBQuQZZ2tM4jVmoN57ZGN7pJ/80Mn/shfnFy7BT
jVmRYq8Ys5FYYXYQ4k4Ljmnpo0NWwd/TQohAbnXr4LNItc5CONzxS7aO6Rk9XbXj
gcU3zTHw55z6SZOgk76fflE1ykaPahDCY6aDQLMp6EJwPaYOQio7IY9aagD5q4Hw
N8EkjjU4lrdKCfltDWp7
=V32Q
-----END PGP SIGNATURE-----

--xJK8B5Wah2CMJs8h--
