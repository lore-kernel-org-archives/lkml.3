Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755279AbaAHKww (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 05:52:52 -0500
Received: from ring0.de ([91.143.88.219]:60960 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751456AbaAHKwt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 05:52:49 -0500
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
	* -0.0 NO_RECEIVED Informational: message has no Received headers
Date: Wed, 8 Jan 2014 11:52:44 +0100
From: Sebastian Reichel <sre@debian.org>
To: Roger Quadros <rogerq@ti.com>
Cc: bcousson@baylibre.com, tony@atomide.com, balbi@ti.com, arnd@arndb.de,
        linux-omap@vger.kernel.org, linux-usb@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>, "Kristo, Tero" <t-kristo@ti.com>
Subject: Re: [PATCH v4 1/5] mfd: omap-usb-host: Update DT clock binding
 information
Message-ID: <20140108105244.GA21607@earth.universe>
Mail-Followup-To: Roger Quadros <rogerq@ti.com>, bcousson@baylibre.com,
	tony@atomide.com, balbi@ti.com, arnd@arndb.de,
	linux-omap@vger.kernel.org, linux-usb@vger.kernel.org,
	devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
	Samuel Ortiz <sameo@linux.intel.com>,
	"Kristo, Tero" <t-kristo@ti.com>
References: <1389161742-10533-1-git-send-email-rogerq@ti.com>
 <1389161742-10533-2-git-send-email-rogerq@ti.com>
 <20140108090808.GB16313@earth.universe>
 <52CD23E0.8030400@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="jRHKVT23PllUwdXP"
Content-Disposition: inline
In-Reply-To: <52CD23E0.8030400@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jRHKVT23PllUwdXP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Jan 08, 2014 at 03:39:36PM +0530, Roger Quadros wrote:
> > What about the other clocks acquired in drivers/mfd/omap-usb-host.c? Sh=
ouldn't
> > all of those be provided by via the DT phandle?
>=20
> All those clocks are identically named across the OMAP SoCs and are uniqu=
e for each
> SoC, so providing DT phandle for all of them is not required.
>=20
> The init_60m_fclk was renamed to l3init_60m_fclk in OMAP5, and hence the =
need for
> this binding.

I understand the intention of this patch. I was just wondering if
all the clocks should be referenced from DT even if that is not
strictly needed at the moment. This would make clocks similar to
other resources like regulators, gpios, irqs, ...

Having the clocks referenced from DT looks cleaner to me. It means I
can check the DT file for any resources used by a driver. It also
creates some kind of consistency in the kernel.

> > Should the clk_get be changed to of_clk_get()/of_clk_get_by_name() in t=
he
> > driver? This would potentially remove the need of the init_60m_fclk nam=
e.
>=20
> If we use of_clk_xxx() then we'll need to update DT nodes for OMAP4 and O=
MAP3 as
> well to explicitly provide the clock phandle.

I'm aware of this.

-- Sebastian

--jRHKVT23PllUwdXP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBCAAGBQJSzS38AAoJENju1/PIO/qaYBQQAJwK7bcy6P0pe/RwjZons0Yp
IOeiux+lm0IAJRJZRwReHlmCKTT6T+ZNFubNqDhJh48w93fOOzerp1X829N0oMXv
7W44n0u5mCh1GBkERwfNvo8ZaSmhuQYsAoS/VQ0ySXNRAQbGu65+lSgu+iKJTlPk
l8J12zx/0rg+zV16OZhfs5YUGi08WkIr6E6aVpMhutw6poX+7DIY7UCtzA9X7hvE
AnvbB4Mv3g3vivHicxYQz2iK0hWRSrMkpjnyPJRBSDYSd6iRmOdKc03zCEJG20yn
KT0T+8+Hli5+sN83UjHUgZ0Qxt+LdCVenyBBQqTXdIcjlK5JKF8yYaJu/gLqx6yd
ypcGgW4cZRP5wKH9swru6cHlvMH04IiA0r+HryaNYquFvHvEe+iC0t9mf/S4gvTx
q0aigQ7wlcgDvvR5TFs+GyyZlgixplrY5sKWmJhXjGUUs6Ds3maJ/tbBSzda6B2c
2AOJOohnV02dNTCoYNrYLoMaUAqryLuZ1hQcRTY/qODtoUUMf+FgJhsPirHnCDem
bSuvzBJTzoZRxLJWGmWjzaZ3upz2Y0XZo4wYsUIU00fBGUXGXJyeFyg2K7bH8y5I
PDjK7xP3mQCemyfLtp1FGz0jUAPbjLVdHfrWH6Ajj9S4OBihKpNt+qj6RH9kmP5g
ty4FY3VgK3wDTDIQzo+f
=cuWS
-----END PGP SIGNATURE-----

--jRHKVT23PllUwdXP--
