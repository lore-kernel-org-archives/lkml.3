Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754256Ab3BEJcN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 04:32:13 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:41824 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750844Ab3BEJcJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 04:32:09 -0500
Date: Tue, 5 Feb 2013 11:31:53 +0200
From: Felipe Balbi <balbi@ti.com>
To: Roger Quadros <rogerq@ti.com>
CC: <tony@atomide.com>, <linux@arm.linux.org.uk>, <sameo@linux.intel.com>,
        <balbi@ti.com>, <stern@rowland.harvard.edu>,
        <gregkh@linuxfoundation.org>, <eballetbo@gmail.com>,
        <javier@dowhile0.org>, <sshtylyov@mvista.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 17/30] ARM: OMAP3: 3630SDP: Adapt to ehci-omap changes
Message-ID: <20130205093153.GZ32118@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1359372631-8180-1-git-send-email-rogerq@ti.com>
 <1359372631-8180-18-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vM12nk/63StVgfqY"
Content-Disposition: inline
In-Reply-To: <1359372631-8180-18-git-send-email-rogerq@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--vM12nk/63StVgfqY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 28, 2013 at 01:30:18PM +0200, Roger Quadros wrote:
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

--vM12nk/63StVgfqY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRENGJAAoJEIaOsuA1yqREQKcP/RiAHUEbHOy6b0z1ezRteCK+
buXmIt5dTs9VOLrCr9NyTMQ4gK3JXcjI6dN3Nb8oMkWXl1qOOFLl/p9FQHVFjQgI
hkAB8AO3YH81LxX1n1roByEeZ1bHLzDEhlij9IykhnhF/BZm+4WdV6HXMNg2JQSu
tO2CTOjTxnzs3HJw/zbA2LoN29Tcf0eAw4gZfzktmAwRsU6VTLF6rigDieNfWGw9
5QJeoU24Ol9liuOvF6y3IGGTQEIi1V3lLNog3J0lpJgz5AZhHEvOaP0UJ0Jr2ClR
UuC7qiaVqla88McjhaEQehhR2/vCreqhgtiG/eINXT4xiGiBVzCdlFdV3FvWZzXe
d5yJoyO+l/8Fwm++rZDIne+GFH6iQ+Q1WMpImN1qS7IPF+q/cpKClbEr6l8ensCJ
Af94ygUguL7O7WC1Sa2B4Kh+iGHqb3i8xa8yhbFDNFaTY1P8wsPZ5POns05UeLpd
TLdbqGzuaVKXfqlL6oyoTzXbysCLDDfMog2a15+F4DhiK7b+Oyh5+k0shLqjRU2u
z+OX4H75V+mSO40oC0uqE60awaqaMyXgCBg5pc0oUxDqxeGbM90JQrHaCp+ajsC5
/AbjVb2YU3+PUf6veXPpNFf/cl17yymingkk3GUptWwrkEhhGD7CbVlT4bXcg5Kt
EGsdx4fSDhKwHZ95dLEV
=zBeC
-----END PGP SIGNATURE-----

--vM12nk/63StVgfqY--
