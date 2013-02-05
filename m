Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754806Ab3BEJcs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 04:32:48 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:51699 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751629Ab3BEJco (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 04:32:44 -0500
Date: Tue, 5 Feb 2013 11:32:31 +0200
From: Felipe Balbi <balbi@ti.com>
To: Roger Quadros <rogerq@ti.com>
CC: <tony@atomide.com>, <linux@arm.linux.org.uk>, <sameo@linux.intel.com>,
        <balbi@ti.com>, <stern@rowland.harvard.edu>,
        <gregkh@linuxfoundation.org>, <eballetbo@gmail.com>,
        <javier@dowhile0.org>, <sshtylyov@mvista.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 21/30] ARM: OMAP3: cm-t3517: Adapt to ehci-omap changes
Message-ID: <20130205093231.GD32118@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1359372631-8180-1-git-send-email-rogerq@ti.com>
 <1359372631-8180-22-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FSGgxso9lj1d9SFz"
Content-Disposition: inline
In-Reply-To: <1359372631-8180-22-git-send-email-rogerq@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--FSGgxso9lj1d9SFz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 28, 2013 at 01:30:22PM +0200, Roger Quadros wrote:
> Add 2 platform devices for 'nop-usb-xceiv'. These will be used
> as PHYs for HS USB ports 1 and 2 so provide binding information
> for them.
>=20
> Model RESET for HS USB Ports 1 and 2 as GPIO fixed regulators and
> link them to the 2 PHYs we just created.
>=20
> Signed-off-by: Roger Quadros <rogerq@ti.com>

Acked-by: Felipe Balbi <balbi@ti.com>

--=20
balbi

--FSGgxso9lj1d9SFz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRENGvAAoJEIaOsuA1yqRE0IQP/iawHF8r1s/swLVmHH6weMxk
Tp5l1ZGS4q3QsL0A5B23um+boIx6fadN/uB+rEKV3r62Jc5jx1rA6Ymco9ZQQqjO
D/B3rDLrRmFAqLqIJfZdAWAO0ROzqFyJbL5XZxnR7LreuQArsc8gwP7IlEAyh4zx
X+YOKUWLIyK8Vd1rgPf31NapaOTyC46p7L5zSZSszCKUb0w5//76dGDYZUvpDywZ
IRJcLmDVQz3ZP4UsC2gdUdlISL/d+qWdCLTcCe5K5+GWvZbgpqNiYYNTk0koTsip
8x5P2I7BELrAcLYPJfNshWKxb6mqIqv6aCz1LbfP7V9YEhoA3JEHnl+dwYI8GzY/
mLKeNPUG/QBALpaQ8YLwY8vw0G0j8JEPcKEAHdioFPbADveGokH6LEXHC5qrKObf
DXEh/fPqu3P5TSsYsF5lvRXWgPXJrEl6JmjHJDhOJae+y4LDXUgQ/mRJP72M/RsD
IpyqJfTMLRf8cNO6OODuPVTswj87oGL7ls48/iRZueNvPDSZvSFUZX5G2CJsQMnT
dHwgcmW52HaaHuzvVGKqw61PEfhqWsH7+tVBEmeSTQSuNAzsWhiDpRA6qrXPQHFc
boCG+iVfZeP71BCnAoM+AoT8TYMqqu2zNsmSAs1qO++wP+urDYf6+wDQZK4nWFAD
Z9Hs68AEGzNdueJCGm1c
=8eWr
-----END PGP SIGNATURE-----

--FSGgxso9lj1d9SFz--
