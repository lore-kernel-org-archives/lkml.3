Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754927Ab3BEJfm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 04:35:42 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:41835 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754435Ab3BEJcQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 04:32:16 -0500
Date: Tue, 5 Feb 2013 11:32:06 +0200
From: Felipe Balbi <balbi@ti.com>
To: Roger Quadros <rogerq@ti.com>
CC: <tony@atomide.com>, <linux@arm.linux.org.uk>, <sameo@linux.intel.com>,
        <balbi@ti.com>, <stern@rowland.harvard.edu>,
        <gregkh@linuxfoundation.org>, <eballetbo@gmail.com>,
        <javier@dowhile0.org>, <sshtylyov@mvista.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 18/30] ARM: OMAP: AM3517crane: Adapt to ehci-omap changes
Message-ID: <20130205093206.GA32118@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1359372631-8180-1-git-send-email-rogerq@ti.com>
 <1359372631-8180-19-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="va9XEZk9/dJ5GUjX"
Content-Disposition: inline
In-Reply-To: <1359372631-8180-19-git-send-email-rogerq@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--va9XEZk9/dJ5GUjX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 28, 2013 at 01:30:19PM +0200, Roger Quadros wrote:
> Add platform device for 'nop-usb-xceiv'. This will be used as a
> PHY for HS USB Port 1, so provide binding information for it.
>=20
> Model RESET and Power for HS USB Port 1 as GPIO fixed regulators
> and link them to the 'nop-usb-xceiv' PHY.
>=20
> Signed-off-by: Roger Quadros <rogerq@ti.com>

Acked-by: Felipe Balbi <balbi@ti.com>

--=20
balbi

--va9XEZk9/dJ5GUjX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRENGWAAoJEIaOsuA1yqREB1gP/iesvIurp9NkH/KAzXPruuad
yeQia6Sowsio0h2qsZi11nucFxH5yBl5SMWsID5fqliQNkEuC0N7MT7CteJAhoYa
zYT6HCLQrHn5D3ilKUBXKlEpl/PAlsn8Smg6hmtecKkRL56qBkYHWGKR6lVhBjx9
sokSX9ecNxpl3oDK5L8mGnjtPZ4WxMjrRelaCZZBZaYNW7ZDEchtcs+k+IHMLkRl
9onUD+Nd//VsEPJyq5SUnltgtcazBfw4SnzldkBt5Ew+UulvfiES7QWYRAHodsSY
NYkVgrlFeN26AJJo+ARnysigIrSZjZBClcee398Y1LPZdvJseob9VOEqtWnVSuZl
ienz1mw54MTCXtBlaGreMsDs8PASexR7aUgehuuChyyedepk2DmX2WAVEKJ8+gcs
iZq68L+UtrKiLxzjfAb9pwPjZoBhVUbeEu86tgW3bcziIQ9mA6+dXn4nBmtTWkPd
cmg4toAom8PW/ymNgEPuT8U118iDcrVVwALDgXQx6f2fXhRDn8GwUe/zto68zW+P
SHrwDZTPHvLnFvLLFk4nHSOokaDQcuG/grt/RE46/nAQctbc+5wRkgEGBvlNRBup
5xMxh3LbTjIyqU/i5xskCXkT9Em0KsRTa4gxuBehTcNkjLA6TEoe3s5UIv+EkTJc
v0JewXhbP0RcBA0OQdXW
=hZ5C
-----END PGP SIGNATURE-----

--va9XEZk9/dJ5GUjX--
