Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753077Ab3BEJbh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 04:31:37 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:37338 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750844Ab3BEJbe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 04:31:34 -0500
Date: Tue, 5 Feb 2013 11:31:00 +0200
From: Felipe Balbi <balbi@ti.com>
To: Roger Quadros <rogerq@ti.com>
CC: <tony@atomide.com>, <linux@arm.linux.org.uk>, <sameo@linux.intel.com>,
        <balbi@ti.com>, <stern@rowland.harvard.edu>,
        <gregkh@linuxfoundation.org>, <eballetbo@gmail.com>,
        <javier@dowhile0.org>, <sshtylyov@mvista.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 14/30] ARM: OMAP2+: omap4panda: Adapt to ehci-omap
 changes
Message-ID: <20130205093100.GW32118@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1359372631-8180-1-git-send-email-rogerq@ti.com>
 <1359372631-8180-15-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mz5eWKkhz39mMVQV"
Content-Disposition: inline
In-Reply-To: <1359372631-8180-15-git-send-email-rogerq@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--mz5eWKkhz39mMVQV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 28, 2013 at 01:30:15PM +0200, Roger Quadros wrote:
> Model RESET and Power for HS USB Port 1 as GPIO fixed regulators
> and link them to the 'nop-usb-xceiv' PHY by making them as "reset"
> and "vcc" supplies.
>=20
> The RESET and Power will then be managed by the PHY driver.
>=20
> Signed-off-by: Roger Quadros <rogerq@ti.com>

Acked-by: Felipe Balbi <balbi@ti.com>

--=20
balbi

--mz5eWKkhz39mMVQV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRENFUAAoJEIaOsuA1yqREHdwP/0rUYzb7C1cB/f9QE+T0FRL+
jEu1Maw65hwALXeHKwCLpkkMzDsvFZShCAoihnLvIZEtqx7vddmhDXPNSh0t9YCY
c6zehStGbw6GJQW+6tbFgcSJyOMl6wNMOFHjlehstYfu8YNnLEQ5X/et+wd4duMw
aXDie7z9tCbf+i1FR4R6DVYRuB7smoWv5kHpS8Nei5p3MDnVRDSEo4TrMwxbj35l
T7U8aUHu0zDCvzQQZ2stXnlhEZHRPuVP+pDF9p9w/yp1AcdwgQgDaAdtP3xYx79k
DSTec/I3w5c2KNQszbI2M8SE4VK4rOD59dcbCi1Bk/yK7a8tXg+YBviyD8EAEiL0
6hRmDZ1bg2rxhbUKKiXljdbeBcuec8O9Q6k4VeAVhRd2zNnwqba9B1ZBy5hyUR3A
KuS3OOGpqZXmzD9lwxKCgM/Y9EIKMvbQtoJ/vHVoWIT5MaSAe2EJ0YrKztqWSVlX
Z1ghLUTX/Vpa37FlcNVEWVr2t3zWhpNRYyJtBsrpycXjZhGCnUS7I8qhYITPceMY
HDgD8sZ8b0qZKB00ccsTblt6DX6TXqXlHFiLa1WbKDCc9Vi4W7kJa4O5ADJF0O4+
Wjq0NR2a3bRwSnVzp6rT6TYMjuQO0mivwxa20Exyt2pJAGm1VhKc2QR8CP7oDiI5
Z9L3YXQWWJNzkr4yfQoZ
=aNCE
-----END PGP SIGNATURE-----

--mz5eWKkhz39mMVQV--
