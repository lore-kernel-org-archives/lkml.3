Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755886Ab3FRJoY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 05:44:24 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:54355 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752965Ab3FRJoW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 05:44:22 -0400
Date: Tue, 18 Jun 2013 12:42:23 +0300
From: Felipe Balbi <balbi@ti.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
CC: <grant.likely@linaro.org>, <tony@atomide.com>, <balbi@ti.com>,
        <arnd@arndb.de>, <swarren@nvidia.com>, <sylvester.nawrocki@gmail.com>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-usb@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <akpm@linux-foundation.org>,
        <rob.herring@calxeda.com>, <rob@landley.net>, <b-cousson@ti.com>,
        <linux@arm.linux.org.uk>, <benoit.cousson@linaro.org>,
        <mchehab@redhat.com>, <cesarb@cesarb.net>, <davem@davemloft.net>,
        <rnayak@ti.com>, <shawn.guo@linaro.org>, <santosh.shilimkar@ti.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <nsekhar@ti.com>
Subject: Re: [PATCH v7 3/9] usb: phy: twl4030: use the new generic PHY
 framework
Message-ID: <20130618094223.GR5461@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1371113039-5784-1-git-send-email-kishon@ti.com>
 <1371113039-5784-4-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JB7KW7Ey7eB5HOHs"
Content-Disposition: inline
In-Reply-To: <1371113039-5784-4-git-send-email-kishon@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--JB7KW7Ey7eB5HOHs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 13, 2013 at 02:13:53PM +0530, Kishon Vijay Abraham I wrote:
> Used the generic PHY framework API to create the PHY. For powering on
> and powering off the PHY, power_on and power_off ops are used. Once the
> MUSB OMAP glue is adapted to the new framework, the suspend and resume
> ops of usb phy library will be removed.
>=20
> However using the old usb phy library cannot be completely removed
> because otg is intertwined with phy and moving to the new
> framework completely will break otg. Once we have a separate otg state ma=
chine,
> we can get rid of the usb phy library.
>=20
> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>

Reviewed-by: Felipe Balbi <balbi@ti.com>

--=20
balbi

--JB7KW7Ey7eB5HOHs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRwCt+AAoJEIaOsuA1yqREpsgP/iZqMS7nQkt4OiwdxmC64x0V
QSROtHubVNGtSCi+D/ITULGiPUBl/8ZOkqHO7S3+9QFR/MnKtC7fk15Y/xNF4eqw
7uwUSEWFfgmb4YdUvZulvhZ6t8C/RYIr72gdpDwwnVxbII2rQz4hw36zhgQw/1uB
kZYKiWW3t9tCpqGEKJdtmIAKIuPYgZpTBM+jaPbPSJGpubri1wa8f0MebeiV6DER
rBjX4ZL7VmUQrM/UV2kca1tJOcQdEWAzG/RXZvLN2VUY45ARV7i8A5JcpjGSfHoC
wCSw/chelJcbFoKAn+N4cHgGprwKQ6B5mf2+6ZtMNiZ5D5AJ0XqVqcAS1Zknc9cL
U7idC6gSrY6W28YgbN9CkjmpBBv/9B60pEjXlhp5Wpshksf/XMtPDnpIWST2dWs3
gH/6w3/yeeAjFzkCc7DPpcUm2DExEj6LQmFxJZsi05ctwPrHcPGnEMiQM1ijPbtA
4iY9b1JSALzqzLYceQ7aRtBHzqRFPDWJLA21zoeTALNPHZDY/QQ8PdsJXhd53qBJ
TGgcX0Fh+KZEhL6p2zHbEZ8Axf8G/eUlRrLc8/AywDTTWIc+rZKUFBcQpP+IPyjc
fnoGFgSN+Jv6F7ghvgdJFjXQ0bMadlpwUJYqk6jZHdrVB+sCnu4UqcGsJ7Ypl1Yw
4ebjTrnW8ZX1oZQEIkjS
=NLXE
-----END PGP SIGNATURE-----

--JB7KW7Ey7eB5HOHs--
