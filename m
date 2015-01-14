Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753806AbbANSlD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 13:41:03 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:40876 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343AbbANSlA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 13:41:00 -0500
Date: Wed, 14 Jan 2015 12:39:43 -0600
From: Felipe Balbi <balbi@ti.com>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
CC: Felipe Balbi <balbi@ti.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Arnd Bergmann <arnd@arndb.de>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Jean-Jacques Hiblot <jjhiblot@traphandler.com>
Subject: Re: [PATCH 08/12] usb: gadget: at91_udc: Remove non-DT handling code
Message-ID: <20150114183943.GO16533@saruman>
Reply-To: <balbi@ti.com>
References: <1421252524-24452-1-git-send-email-alexandre.belloni@free-electrons.com>
 <1421252524-24452-9-git-send-email-alexandre.belloni@free-electrons.com>
 <20150114173812.GI16533@saruman>
 <20150114183516.GN3843@piout.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OxpYUbrsx40GOZXC"
Content-Disposition: inline
In-Reply-To: <20150114183516.GN3843@piout.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--OxpYUbrsx40GOZXC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 14, 2015 at 07:35:16PM +0100, Alexandre Belloni wrote:
> On 14/01/2015 at 11:38:12 -0600, Felipe Balbi wrote :
> > On Wed, Jan 14, 2015 at 05:22:00PM +0100, Alexandre Belloni wrote:
> > > From: Boris Brezillon <boris.brezillon@free-electrons.com>
> > >=20
> > > Since non-DT board support has been removed from the at91 architectur=
e we
> > > can safely remove non-DT handling code.
> > >=20
> > > Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
> > > ---
> > >  drivers/usb/gadget/udc/Kconfig    |  1 +
> > >  drivers/usb/gadget/udc/at91_udc.c | 16 ++--------------
> > >  2 files changed, 3 insertions(+), 14 deletions(-)
> > >=20
> > > diff --git a/drivers/usb/gadget/udc/Kconfig b/drivers/usb/gadget/udc/=
Kconfig
> > > index b8e213eb36cc..366e551aeff0 100644
> > > --- a/drivers/usb/gadget/udc/Kconfig
> > > +++ b/drivers/usb/gadget/udc/Kconfig
> > > @@ -32,6 +32,7 @@ menu "USB Peripheral Controller"
> > >  config USB_AT91
> > >  	tristate "Atmel AT91 USB Device Port"
> > >  	depends on ARCH_AT91
> > > +	depends on OF || COMPILE_TEST
> >=20
> > will this build with !OF builds ?
> >=20
>=20
> It should, I'll check but it doesn't matter because it depends on
> ARCH_AT91 which selects OF.

Missed that line :-)

Acked-by: Felipe Balbi <balbi@ti.com>

--=20
balbi

--OxpYUbrsx40GOZXC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUtrfvAAoJEIaOsuA1yqREQJ0QAJKdH8Ww4uqdjDbn8kqS6Kyf
Vl2cH4pZRU1KQmxxG8n66+YBprqLB/b89QQXOTBde17H/S8xXagfxe7sBLOn8k2p
nEgf+bl0BJRwQu8LsZyWY9NJpfbht22RH0hU+KvlTp5gHAD38DcqdvbazqhXp6OK
k9G/zcK8JanwAKZewCiM6LHfpvcDJ0xMzTKjmezSMQNe4n7R9a9ejJm5/e7sJpAO
mdbGEg0tX5xe39QrMpndmBD9HaadqLNW4W4DA21gRoAKSk3DM7/ynJZK8t4Zx8A9
7cOY0RQ5YEkX5uvUmlWo7scEuVWfF1fqvJ7KMoigVL86Y335iOu+qAyC5qjjxiO0
p/himGKHge/zBm4NmDcG3ujiWv0KZJSudzPqdEYiH98jmCJN4g9d4e+GV/pSdW/U
gWj/UuF7KxJC+YzI6uQlhnFkPa4SzHX4nte6NdhET0nfnjGX64w9CLZwQzpZ+qMG
QW+qvDX8iOX2Yi7Qx3UTuIjqUQ1Yp5AQxFbzgT/6q8PLNJZx9ZZ83LgyoItKnJc5
C8RC9Vx5K55T+A75PXGs/CW+bD9ZX5SWaMoErFBBtBWrjwY/E9Rp6z9GKVebXtIx
VvHqk/l0bBgTFyol2hJxdF1+5soalkmCqwh1gFNkGO/rJzrUFH5XYoA64tQrLv4r
UGmK7tUXYdpmJAa3M8Tf
=Ng/J
-----END PGP SIGNATURE-----

--OxpYUbrsx40GOZXC--
