Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755846Ab3JJPfZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 11:35:25 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:34486 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753980Ab3JJPfX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 11:35:23 -0400
Date: Thu, 10 Oct 2013 10:34:27 -0500
From: Felipe Balbi <balbi@ti.com>
To: Roger Quadros <rogerq@ti.com>
CC: <bcousson@baylibre.com>, <pavel@ucw.cz>, <aaro.koskinen@iki.fi>,
        <marek@goldelico.com>, <balbi@ti.com>, <tony@atomide.com>,
        <kishon@ti.com>, <bigeasy@linutronix.de>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] ARM: dts: omap3:  Adapt USB OTG to generic PHY
 framework
Message-ID: <20131010153427.GI28375@radagast>
Reply-To: <balbi@ti.com>
References: <1381152493-28055-1-git-send-email-rogerq@ti.com>
 <1381152493-28055-2-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Az4VpBrmI9+OyhK/"
Content-Disposition: inline
In-Reply-To: <1381152493-28055-2-git-send-email-rogerq@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Az4VpBrmI9+OyhK/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 07, 2013 at 04:28:13PM +0300, Roger Quadros wrote:
> The generic PHY framewrok expects different properties than the
> old USB PHY framework. Supply those properties.
>=20
> Fixes USB OTG port on GAT04 and N900 after the Generic PHY framework was
> merged in greg/usb-next. [1]
>=20
> [1] - https://lkml.org/lkml/2013/9/27/581
>=20
> Signed-off-by: Roger Quadros <rogerq@ti.com>

Acked-by: Felipe Balbi <balbi@ti.com>

--=20
balbi

--Az4VpBrmI9+OyhK/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSVskDAAoJEIaOsuA1yqRERbwP/3vq9oFVBAK1aJQIz7lIxXPh
n03Gtrxo2v0lsKIA6YAF4Yafml3/Mbcw+BNg9k/s/ZR9lUDevQ5d4WidUyN0ATa+
hBhw/dRxZOf9ucqrKs5EVXN3wUOLWRaW6u0cuqlJwlN6e3+dyHEFSJCJi5w599vU
FANezfeDpSgt3jEXM3KNj9bnkwPXs3j4uT+CvFCa6j5CjBJcL+0AIfgg1Ws3c3Wl
AIkmD9J+c63Bq1mdb9Ibw0LbwBuT21FWAYHeaCK+ziyoGfO4vRk2c9VIrpsvutDF
lrC45Q2lUQf7+W7djV6w5tDlfR1419QKq7rEIbzwiK8Wi+hrA5W9Af/LtUHvgCsz
BS7OuQ1XzRPyca32l/r7lXtINJLQcOQxHmj62Lw749etYAqzds52Q1HD/zx82xjP
fJOh2gcjV7JePAa59K+OPc+HT038Bb3ZH/tnS+4O6dty8aXymI+QMgzD0n568DQ3
0XwjTDYPs7Le0esoGzMFIb/lP1O6F45fScO+lZwMtROZbK4+v1+Q5hzGd7GuYNbG
ihWIhDIR+jHb+FYYvmTep6OUZTkB/WEjfVXXY47DcyzxdDA+MtlL96dL0PSGc3ma
VVUnBb+5F2cdY5OeNkX5ikVXmuE7ooMdN2qLD1cGZxfeUUiNlCKhGC6URSezKWGy
wOOcCvvmJPHFAcfKWZeq
=jiXS
-----END PGP SIGNATURE-----

--Az4VpBrmI9+OyhK/--
