Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756824Ab3GYR3a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 13:29:30 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:34797 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756699Ab3GYR32 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 13:29:28 -0400
Date: Thu, 25 Jul 2013 20:28:55 +0300
From: Felipe Balbi <balbi@ti.com>
To: Roger Quadros <rogerq@ti.com>
CC: <balbi@ti.com>, <benoit.cousson@linaro.org>, <p.zabel@pengutronix.de>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/6] usb: phy-nop: Use RESET Controller for managing the
 reset line
Message-ID: <20130725172855.GJ25415@radagast>
Reply-To: <balbi@ti.com>
References: <1374137590-17865-1-git-send-email-rogerq@ti.com>
 <1374137590-17865-2-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nhAUiXSLan16V5i8"
Content-Disposition: inline
In-Reply-To: <1374137590-17865-2-git-send-email-rogerq@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nhAUiXSLan16V5i8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 18, 2013 at 11:53:05AM +0300, Roger Quadros wrote:
> Till now we were modelling the RESET line as a voltage regulator and
> using the regulator framework to manage it.
>=20
> [1] introduces a GPIO based reset controller driver. We use that
> to manage the PHY reset line, at least for DT boots. For legacy boots,
> will still need to use the regulator framework for reset lines.
>=20
> [1] - http://thread.gmane.org/gmane.linux.drivers.devicetree/41348
>=20
> Signed-off-by: Roger Quadros <rogerq@ti.com>

that's not in mainline yet, right ? Is it guaranteed that it will hit
v3.12 merge window ?

--=20
balbi

--nhAUiXSLan16V5i8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR8WBWAAoJEIaOsuA1yqRE8YAQAKmrsoVWo9oxn0i8AyLUDTZ9
tGW/gmR9kgVwYAzEP2BPIUXkICUJO36u4rcWUiC8bPdEgRt2m6wMw8kYccIeVPdE
M7uvw2NdYaJv0WepU96MXErHyFSCkSitJ2SwXZzOJINOZapm3wOIOSxzfoQFuWhl
vKPbW4eD1biBf7yIrIuVUFE5YkdRp6kOg7+UFMkaYySF4sedHezjvQNmUzvxcCkI
jI90k5z4YwjUgtcL9VIacUO1bWc12NumZZstwrb33z51qxQWHxbBGmncaNTQy3YZ
gWu4qiLjs8i7U/Riedf5/0nBYQPQj+YIlkgl9ielbPNqPAstcmLQFEQ4+pglR3Hc
M7HlisziiO4ihM/9c+Y1zRfHhV2qmgpZWieL/GjHIR4tHIZhxkC3m9wAH5Ho8Fxo
1lCzi28UBWeL8/i/Z/361dIqSSs8AZMOITY/bvmbpsX93vHZhhuIqq7M/C/XMtI9
Ab4jTgCF6ATDxEIOL79UX0kOa86OSbQPVFzpj7HQncd0ewbsT+CpqUHvACWdIkp2
Pbcp0Kh+Vdc4Kffxys2HNaDQbY4zsRBvq5Xyp2uOjAHG64geqq8ZWx70bvE/n9nZ
bj00QjTq0F3R4o2je+dttIzbFlJXWP59zNGcOiSSWuPJrJS7P8vA9Up3eTIp2vZ2
agYOaluw0L017s8y9+6X
=KYMJ
-----END PGP SIGNATURE-----

--nhAUiXSLan16V5i8--
