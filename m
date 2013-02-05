Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754913Ab3BEJeD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 04:34:03 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:51849 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751424Ab3BEJd7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 04:33:59 -0500
Date: Tue, 5 Feb 2013 11:33:47 +0200
From: Felipe Balbi <balbi@ti.com>
To: Roger Quadros <rogerq@ti.com>
CC: <tony@atomide.com>, <linux@arm.linux.org.uk>, <sameo@linux.intel.com>,
        <balbi@ti.com>, <stern@rowland.harvard.edu>,
        <gregkh@linuxfoundation.org>, <eballetbo@gmail.com>,
        <javier@dowhile0.org>, <sshtylyov@mvista.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 24/30] ARM: OMAP3: omap3evm: Adapt to ehci-omap changes
Message-ID: <20130205093347.GG32118@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1359372631-8180-1-git-send-email-rogerq@ti.com>
 <1359372631-8180-25-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wQkw7DhpL9hyPo7K"
Content-Disposition: inline
In-Reply-To: <1359372631-8180-25-git-send-email-rogerq@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--wQkw7DhpL9hyPo7K
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 28, 2013 at 01:30:25PM +0200, Roger Quadros wrote:
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

--wQkw7DhpL9hyPo7K
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRENH7AAoJEIaOsuA1yqREqNsP/38yfZLdL48brXlCrmEcroSd
DHtCjEwdVP3UWftzyEPGbefIdFtRQ3mizhP8twyIxWuGMlxdiEFqCN5Rl8VawwwP
vpRJ0P95xS88XdGESHLMRGkg7KukMx/ayEtMZqWV+nC41cIFlVIzJGKQRkS9YEgn
15T14PwyVsR0DpffpFlMlIgZ6HaQYY6RLxWMXJhr2N1O4MVIOR6eQ/1pL3ZArcvq
FCFlB+a8txZzMpv4R2TWOu3qkDc569mGzJhWJuL6GZkLvNLVQ7XPfOn8Oei46lLX
1zxvmgV2yVMsVXZIv3/AtdIa1qYPgFYO0P5SPQ/Uvq/X1fB1QYKxVKMPuHxIL93v
c46ygLC/ndPFqA4kXadZyh1Kj7TJQH+zn4rcRbvLlzdOyldb+p6PZfR5Z6fi7G7k
rR4lj5euX9mNDjpEzvh2+3OgJEvEV82/tp4XZzGqhdSDv0EScuAs+PJKDRJX2EYB
P2lhJrGZMwMJp1eocOLe6R59SjUgAh6ZoX6xjioAP8PQ5LQp/infUfnjggwwcl5R
wBQDpwMVLd75pQ2VDVdBCBMvJZsbjiQVuYp/2dZQPRmmQmSKFJTnYfeOQriR1dul
v/+XSZ5VEt5RxPVrMsX2PiZEiyz3L9Ry12IgS5oxQfM+GUFFMZTBtsC5PtP8ahmd
lCBEp02N/w7qkVeAnu1l
=iCWa
-----END PGP SIGNATURE-----

--wQkw7DhpL9hyPo7K--
