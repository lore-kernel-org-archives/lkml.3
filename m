Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754820Ab3G2MWg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 08:22:36 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:60184 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751494Ab3G2MWe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 08:22:34 -0400
Date: Mon, 29 Jul 2013 15:22:18 +0300
From: Felipe Balbi <balbi@ti.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
CC: <balbi@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <george.cherian@ti.com>
Subject: Re: [PATCH 2/4] usb: phy: add am335x pieces to generic phy
Message-ID: <20130729122218.GG24801@radagast>
Reply-To: <balbi@ti.com>
References: <1374869757-923-1-git-send-email-bigeasy@linutronix.de>
 <1374869757-923-3-git-send-email-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DWg365Y4B18r8evw"
Content-Disposition: inline
In-Reply-To: <1374869757-923-3-git-send-email-bigeasy@linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--DWg365Y4B18r8evw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 26, 2013 at 10:15:55PM +0200, Sebastian Andrzej Siewior wrote:
> This patch copies the phy support bits from dsps into the generic phy
> driver. Most code can be re-used except for the on/off.
> The additional am335x can be removed once we have a phy driver that does
> more than this.
>=20
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

this is good too, but looking at the amount of am335x-specific code in
the driver now it makes me wonder if we want to convert phy-generic.c
into a library...

--=20
balbi

--DWg365Y4B18r8evw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR9l56AAoJEIaOsuA1yqREKWwP/iiZANFI1EHxgbQDDZSQs+Pm
ePtf3Q8uB5g+g/WyrDHydqDpqgBJAb2xFihblQIIf8ByU7/ewMrHnnmo000gArHi
Y3l7IfvxMnXwc1HBG6KXHH//MF7VbOXGGjqLE9vROGIj6qzMddv6Su/iCh4MgiLd
C8CezeCLDLBYWu5cgbWN4/cKsjFv3AG6QpJ+X4mRU8JDA3E35GhLuQyPfKamcUlI
RCqiJiIqKjzcA7zRf4gUGXhRNchS2c5MJ3BFhUDXGOQt/bzArY6ySRxckXGo1xss
jwJpnxxOEHw1XcmIjWU5bYxhKBfzlDeUYYyBgUgyzte4QA5d14kStyrj2RkdvJab
RD6jc8vbYghBkP/Yg7zuZ2P8eAnTpfZq+ygNZr66jGYWVQ+GFA9F3fSYmX6Q92NK
opU/3pgOzodgSv+y1FEk43GIbj2LbyozyiLR5qH+3XiXy2QTfCUpGNBYsKETucXr
/E7j9KF1UagfGwchFsJ1P1VB5TkvrjMQp50BQmGsPsgkumyncRHxScwH4xI48VaS
YfHJpSZe9E0H8xl3CYzT6uE34Iy9yaw5Y0DH45dIu3+yPxJWDZXn1PaiYViouYB/
cPX3zzv8yuiJkhyVr02sIX0K1pvgJZBdu29jHVdgjk0ee1nMzzrrcCgGJn8oslh7
znVO734enI2u+FK1/eaS
=GbWZ
-----END PGP SIGNATURE-----

--DWg365Y4B18r8evw--
