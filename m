Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754520Ab3BEJcU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 04:32:20 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:37384 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751011Ab3BEJcJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 04:32:09 -0500
Date: Tue, 5 Feb 2013 11:31:26 +0200
From: Felipe Balbi <balbi@ti.com>
To: Roger Quadros <rogerq@ti.com>
CC: <tony@atomide.com>, <linux@arm.linux.org.uk>, <sameo@linux.intel.com>,
        <balbi@ti.com>, <stern@rowland.harvard.edu>,
        <gregkh@linuxfoundation.org>, <eballetbo@gmail.com>,
        <javier@dowhile0.org>, <sshtylyov@mvista.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 15/30] ARM: OMAP3: Beagle: Adapt to ehci-omap changes
Message-ID: <20130205093126.GX32118@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1359372631-8180-1-git-send-email-rogerq@ti.com>
 <1359372631-8180-16-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BtNCO5h84ExDStzY"
Content-Disposition: inline
In-Reply-To: <1359372631-8180-16-git-send-email-rogerq@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--BtNCO5h84ExDStzY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 28, 2013 at 01:30:16PM +0200, Roger Quadros wrote:
> Add platform device for 'nop-usb-xceiv'. This will be used as a
> PHY for HS USB Port 2, so provide binding information for it.
>=20
> Model RESET and Power for HS USB Port 2 as GPIO fixed regulators
> and link them to the 'nop-usb-xceiv' PHY.
>=20
> Signed-off-by: Roger Quadros <rogerq@ti.com>

Acked-by: Felipe Balbi <balbi@ti.com>

--=20
balbi

--BtNCO5h84ExDStzY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRENFuAAoJEIaOsuA1yqRENAwP/jKEpD70rKdvKT7MjaCGY2ys
SIJe0C5eQ4Ev7/PmmPCRyf/XWiHSwvkHHKwk0C41UhD2A/sii0UToAN082CAJlkl
zeCjx10qG3L6rX9ujP5aElYcXXURyjl6OicL4ke/ImngbzWSiAOObzyTROUvR8Yp
zRYemLD0LHbwDmg/DYc2GZLzG/hHLLwh0VCkuwE24oYBLxyMEC65HQ+7iBAuOh9m
MtDpcej41pKWar1qFd21DOSEH2WpvFdUkKt7xfgFgRI5si0y8x99OCIfnLIOA9gP
XdTE5dbOq99us5jt13SdGsCwdnRceoDfnnMaiAmfyyPurPKIawVOtiMTyJRmP3SI
Jvb4kMIevhzYOfotqbZqqcL7FViMN9w5vEsrZYt2G18DcTvI7gWWGn/JWJBbYAP8
YL5rAq5t05r79j3o7bmUWn0nqmIyvNQp82SXEmYglE+0hzVcMr9baQZwBGkINRQt
rVfVsb/l5000TJFnO6Q/cDypM1izHeedjQ5mogISdVBiuN096FE1p9WTeCIHqUU0
4KCxzu0MeuphEKfHOR747xTIt/uUdDJkBku92+2OFluk0UYUsjxLA6BVkIEe1kCn
Kbu55rkBnaEiBl93MpPvw8UC3oDRVyMsSEo2ByyqwLrwgd4pnEVrfDaeUvKQqCaq
PR/O9T/lZ39AsNsAH5dc
=J6sw
-----END PGP SIGNATURE-----

--BtNCO5h84ExDStzY--
