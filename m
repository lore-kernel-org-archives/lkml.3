Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754242Ab3BEJ00 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 04:26:26 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:51055 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751901Ab3BEJ0X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 04:26:23 -0500
Date: Tue, 5 Feb 2013 11:26:12 +0200
From: Felipe Balbi <balbi@ti.com>
To: Alan Stern <stern@rowland.harvard.edu>
CC: Roger Quadros <rogerq@ti.com>, <tony@atomide.com>,
        <linux@arm.linux.org.uk>, <sameo@linux.intel.com>, <balbi@ti.com>,
        <gregkh@linuxfoundation.org>, <eballetbo@gmail.com>,
        <javier@dowhile0.org>, <sshtylyov@mvista.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3 10/30] USB: ehci-omap: Use PHY APIs to get the PHY
 device and put it out of suspend
Message-ID: <20130205092612.GS32118@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1359453032-20604-1-git-send-email-rogerq@ti.com>
 <Pine.LNX.4.44L0.1301291026020.1507-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Bk6L21jbBNK7V1Rv"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1301291026020.1507-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Bk6L21jbBNK7V1Rv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 29, 2013 at 10:30:05AM -0500, Alan Stern wrote:
> On Tue, 29 Jan 2013, Roger Quadros wrote:
>=20
> > For each port that is in PHY mode we obtain a PHY device using the USB =
PHY
> > library and put it out of suspend.
> >=20
> > It is up to platform code to associate the PHY to the controller's
> > port and it is upto the PHY driver to manage the PHY's resources.
>=20
> s/upto/up to/
>=20
> > Also remove wired spacing around declarations we come across.
>=20
> s/wired/weird/ -- not that people care about misspellings in the=20
> Changelog.  You don't have to resubmit the patch just to fix these two=20
> items.
>=20
> > Signed-off-by: Roger Quadros <rogerq@ti.com>
>=20
> Acked-by: Alan Stern <stern@rowland.harvard.edu>

Acked-by: Felipe Balbi <balbi@ti.com>

--=20
balbi

--Bk6L21jbBNK7V1Rv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRENA0AAoJEIaOsuA1yqREF98P/1QrTjTYm2YBbseWt6Eo5xYh
idktpjAaU5LnW5R3jkCpF24hlFEz+Irkuv5vcakoC/r6OAvmrfkVwQOluTZhmbYK
zUKIB0EDQcrkKttkoJeCYEqYbxWswdCUdb3ymHZx0kNReni2UhAFpJL+AUQ6X2+r
VMkuyxnHS81XpppSuaGNoQy3HESN6byqx+HFohxFQAue23/0R5WVAnOcQ4xyeVAI
xJRFWnz+gaesP0rNUKC/RU0c+HbUhsPzsYrPy51Frx76kcWQAIGNuHhidXiV4cPX
TmFhtLgGc69EZ3LRDh40SzBKAgCin++p4uKSomGVEXau1sEVT+7rVzdM5F+tlfKd
C75W2ERzW3rO9OvvMyJKaHBkNDeX+G7w+Ukd0xOR3mqYk7BJpNkQb74cHKoc71du
YoHlWdWbY+qBMDfEp8HUcfi5RGRm9d7oj+AGrCnHyhieEjz3PKDpyMiKejyJVAde
PcdsNYpWHagmsh7ZeTWnPWt8cPxGK+CE/xYdetfmafEp7FiqYmfcg3ueN7zNlz0y
V/99HVbYa8+X4aeAAPKgx1BC4rx6kFDS5u3rLjMX2tFJiakR1s1/HeZFufms3jO2
k+qBBinb/mFEkGLa60WxfQ9Veh09hf/N2AcO/BokBnV9LDD9fd08Jt8r7JD9hNKs
JIsacvbMVlKAGJnPzaOk
=4xze
-----END PGP SIGNATURE-----

--Bk6L21jbBNK7V1Rv--
