Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753654Ab3BEJks (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 04:40:48 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:37789 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751815Ab3BEJkp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 04:40:45 -0500
Date: Tue, 5 Feb 2013 11:40:31 +0200
From: Felipe Balbi <balbi@ti.com>
To: Roger Quadros <rogerq@ti.com>
CC: <tony@atomide.com>, <linux@arm.linux.org.uk>, <sameo@linux.intel.com>,
        <balbi@ti.com>, <stern@rowland.harvard.edu>,
        <gregkh@linuxfoundation.org>, <eballetbo@gmail.com>,
        <javier@dowhile0.org>, <sshtylyov@mvista.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 29/30] ARM: OMAP: zoom: Adapt to ehci-omap changes
Message-ID: <20130205094031.GL32118@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1359372631-8180-1-git-send-email-rogerq@ti.com>
 <1359372631-8180-30-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GviraxgP0A7vmYdC"
Content-Disposition: inline
In-Reply-To: <1359372631-8180-30-git-send-email-rogerq@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--GviraxgP0A7vmYdC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 28, 2013 at 01:30:30PM +0200, Roger Quadros wrote:
> Add platform device for 'nop-usb-xceiv'. This will be used as a
> PHY for HS USB Port 2, so provide binding information for it.
>=20
> Model RESET for HS USB Port 2 as GPIO fixed regulator and link
> it to the 'nop-usb-xceiv' PHY.
>=20
> Signed-off-by: Roger Quadros <rogerq@ti.com>

Acked-by: Felipe Balbi <balbi@ti.com>

--=20
balbi

--GviraxgP0A7vmYdC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRENOPAAoJEIaOsuA1yqREUlkP/AgJA1VcelbcekzcM+YdYT2o
1zfkioofUhZBSWpjxSRhvzdb/7LPBqkuBNgE85LoH4rBF7tcxlfrlGXjR66FkTsw
BoQy+Vha8hZJPmZaRpldTT6zKs+3VYrt5cLRO/uAgY8eAeX2tyOgRT0K1pKu/QXS
qhyB0gqLtvhpl9DjaroQS97B4uY+pW12MThKElgbQ2cAr0M0YXnvABFG21hzmMq0
qcxTXzPqOk8AIoiK3wJZeCgcpopqH+kw/22Z132DM+cXKDmjYnd3aMcc/2PAWx7I
8oEwC0q0NHNVQRmT7KWaUGMDwKdHJRhzMHgU0KARGjOmNZdwHFqxteEWPYxwb9dl
wzw8NaamZCYk0lnHLkU+WI9LkXV9IYT1EaNGmhhXzI/hXmpLwADIn6ClyQBxaHyX
rZ+mvCfkUyOwy9OtU4mMqGXTDz82wz/jpzOpGDPSPjuI95esQ5EgTsq+pCv9cgvb
W3Pm26VhsRToo54VR+aA20ETJMazLT+ojROMCKA3GUWyUBx3mDxELxk1wKtnjiHH
j3WqBF2TySb2aWcLZZi4OzWX+tkrhHw3KQ3jFGDQi6S8fNH0ZDT/LgEOH+JbLNbd
H3TUlz/MoN0hEMoThKwikLdYhkwLCCzLSrBtgnFeRkqen6O5LNkrOnM7rZjNbumH
ILuryyuO6wBxo3hJ+t9m
=ziZ1
-----END PGP SIGNATURE-----

--GviraxgP0A7vmYdC--
