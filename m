Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756545Ab3DWPaA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 11:30:00 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:49751 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755856Ab3DWP37 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 11:29:59 -0400
Date: Tue, 23 Apr 2013 18:29:21 +0300
From: Felipe Balbi <balbi@ti.com>
To: Arnd Bergmann <arnd@arndb.de>
CC: <balbi@ti.com>, Lee Jones <lee.jones@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linus.walleij@stericsson.com>, <mian.yousaf.kaukab@stericsson.com>,
        <linux-usb@vger.kernel.org>
Subject: Re: [PATCH 06/10] usb: musb: ux500: add device tree probing support
Message-ID: <20130423152921.GE15177@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1366729394-11406-1-git-send-email-lee.jones@linaro.org>
 <201304231714.06326.arnd@arndb.de>
 <20130423151533.GD15177@arwen.pp.htv.fi>
 <201304231727.10696.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fTrra2YUagINO7SV"
Content-Disposition: inline
In-Reply-To: <201304231727.10696.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--fTrra2YUagINO7SV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Apr 23, 2013 at 05:27:10PM +0200, Arnd Bergmann wrote:
> > > > +Required properties:
> > > > + - compatible : Should be "stericsson,db8500-musb"
> > > > + - reg        : Offset and length of registers
> > > > + - interrupts : Interrupt; mode, number and trigger
> > > > + - mode       : One of; "host", "otg", or "peripheral"
> > >=20
> > > I think we don't have any precedent for this combination of "mode" pr=
operty
> > > and contents. You could either try to match ehci-omap.txt and do
> >=20
> > there is dr_mode which other folks are using. Let's use the same thing.
>=20
> On that topic, should we support the same property in am35x.c and=20
> musbhsdma.c? They currently use an integer rather than a string.

certainly :) I also plan to add dr_mode support for dwc3.

--=20
balbi

--fTrra2YUagINO7SV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRdqjRAAoJEIaOsuA1yqREa/oP/im2ooGUi9LpmD2wZZMTPS/W
Z0MfP6LRpri4nlHpPQMCr0XXMOQWIiQ1r8FsKbkUSsHR8dfqgtSyTvCvGxFH4S0y
7KX3FcCBF+Bcl1xcfRGHYSGmg6Dki2xCzERYLfUTgjBV+gjE4L9mK/4Qs5WGXxT1
Z0toNBENsFH0/H1sLZjfiiwgmU0WlsKcKk5lOVGlVsMkIQdD1JeWDplqqoUseAnn
I8Wfcoq6RIFIntj7uRvgmUX5a5cgLYjHQ/VmyDf6yy93fy1XwRRT9CzRQR7nZKrn
nLhk+KUq+jIZrgbxTHe1AdtQEx/e1AeuHdKGkjB3Zv2HPopse+YnEDmwPUTdTcMc
0EiTF8Z+keat1+8K2MCkyTY0RN/2aeappUsWnm819htxZhdpPUholdMW/eaJViz1
EcX4YDVh9/nQ38OhG/XPgmJ4FcI9TmcWPVTGimL0nvk6YlqV9wW4UYESttEWK5oN
5D4fnHZgvxfLyyMb7p2J7hwBl4tmV6vhoCUBf8LDBQ5dV78hFcAfFTkmes90khUG
BLlV3Z8+IfBN1IbD0F9gQKhNCNpv3AKq+/8SpIUKyEtjeGKYai1H3uXUilQYz2/2
WPgCYTG80nGf/MtUYVymFcv/DBCJNl17ULPemzojpR+kxmXpkI2LT2RCh/qej1RD
wuIcMCalJ/9W7A1WeF5Q
=zTN5
-----END PGP SIGNATURE-----

--fTrra2YUagINO7SV--
