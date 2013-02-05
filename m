Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754789Ab3BEJd0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 04:33:26 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:37459 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754516Ab3BEJdX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 04:33:23 -0500
Date: Tue, 5 Feb 2013 11:33:09 +0200
From: Felipe Balbi <balbi@ti.com>
To: Roger Quadros <rogerq@ti.com>
CC: <tony@atomide.com>, <linux@arm.linux.org.uk>, <sameo@linux.intel.com>,
        <balbi@ti.com>, <stern@rowland.harvard.edu>,
        <gregkh@linuxfoundation.org>, <eballetbo@gmail.com>,
        <javier@dowhile0.org>, <sshtylyov@mvista.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 22/30] ARM: OMAP: devkit8000: Adapt to ehci-omap changes
Message-ID: <20130205093309.GE32118@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1359372631-8180-1-git-send-email-rogerq@ti.com>
 <1359372631-8180-23-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="95nVhCDQCgPWiQqT"
Content-Disposition: inline
In-Reply-To: <1359372631-8180-23-git-send-email-rogerq@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--95nVhCDQCgPWiQqT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 28, 2013 at 01:30:23PM +0200, Roger Quadros wrote:
> Add platform device for 'nop-usb-xceiv'. This will be used as a
> PHY for HS USB Port 1, so provide binding information for it.
>=20
> Signed-off-by: Roger Quadros <rogerq@ti.com>

Acked-by: Felipe Balbi <balbi@ti.com>

--=20
balbi

--95nVhCDQCgPWiQqT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRENHVAAoJEIaOsuA1yqREyD4P/2fC+JNSp70aZa1Dvn+jofIr
yPYhz0jRx2kQzl+o4zCy2kywwRg24EwX9gCfcPdM5GeFaipPmM4qZYCWgluXoZY+
OKFleyc0Kf90q9fPSUvj9wNQYm7dUDx7+9dgRmUhCCzo5HN7mV+6dm++K2IcOPsR
W889EdTKT0naRuDG45AGCv3USYnuceTiLtX77MTEv8RgY3Mi1M5OtCiOFYbNYcUs
A7KkyUujl1KVHhfsHheuZAORXVyE08xW4j+lVlRTw/8E94zGguKiUpPsVgW44XJb
bEs7px0Dl6NlVtW46e+pTLyW5MHTIMSnOE/OxKIjzaMk0SjJ+pH/f/NExL5F/kw3
vsW+quvFJyV3JmxgTjtptA6tgZlx5av/B5g4OlEbBZ2iWfyKiIi95tPl2h0jm/gz
iGDLY9U+vVyji/0PHe36FYRgbz873HTIR/E5mDrDXiO5DPYQc7Dp0s50ncvLeu6m
n+Doabmh9NLb6x4Pp+jG1gtrlYcrL98Xkvo8wMVd7oKKrXwpcf6uAKSMzZ4xUXtX
mPFKsKrQiWisbo8cVmjEHk+1UAlZfH3/6MU8SrklNPZWPGHUNsatZnJfRcCEx9LB
8hNfSOEYuJ3Bg19Jz4W6G1RwbZIP93OZXjDcMNfAwamFtCeQb3NN0kj1CzJdxPum
FGdy8P5ejMykAAHmEBtg
=kkVM
-----END PGP SIGNATURE-----

--95nVhCDQCgPWiQqT--
