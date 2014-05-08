Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752812AbaEHDRj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 23:17:39 -0400
Received: from top.free-electrons.com ([176.31.233.9]:35213 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751542AbaEHDRh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 23:17:37 -0400
Date: Wed, 7 May 2014 22:11:49 -0500
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Boris BREZILLON <boris.brezillon@free-electrons.com>
Cc: Emilio =?iso-8859-1?Q?L=F3pez?= <emilio@elopez.com.ar>,
        Mike Turquette <mturquette@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Chen-Yu Tsai <wens@csie.org>, Philipp Zabel <p.zabel@pengutronix.de>,
        Shuge <shuge@allwinnertech.com>, kevin@allwinnertech.com,
        Hans de Goede <hdegoede@redhat.com>,
        Randy Dunlap <rdunlap@infradead.org>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, dev@linux-sunxi.org
Subject: Re: [PATCH v2 5/7] clk: sunxi: add PRCM (Power/Reset/Clock
 Management) clks support
Message-ID: <20140508031149.GN7047@lukather>
References: <1399483554-8824-1-git-send-email-boris.brezillon@free-electrons.com>
 <1399483554-8824-6-git-send-email-boris.brezillon@free-electrons.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3hAdtgBjtgL7p0NQ"
Content-Disposition: inline
In-Reply-To: <1399483554-8824-6-git-send-email-boris.brezillon@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3hAdtgBjtgL7p0NQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 07, 2014 at 07:25:52PM +0200, Boris BREZILLON wrote:
> The PRCM (Power/Reset/Clock Management) unit provides several clock
> devices:
> - AR100 clk: used to clock the Power Management co-processor
> - AHB0 clk: used to clock the AHB0 bus
> - APB0 clk and gates: used to clk peripherals connected to the APB0 bus
>=20
> Add support for these clks in a separate driver so that they can be probed
> as platform devices instead of registered during early init.
> This is needed to be able to probe PRCM MFD subdevices.
>=20
> Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>

Acked-by: Maxime Ripard <maxime.ripard@free-electrons.com>

Thanks!
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--3hAdtgBjtgL7p0NQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJTavX0AAoJEBx+YmzsjxAg+1gQAKopdXxjzj9RVSMSMR2q2Fxb
luB8mtq/A8rIHieCLQKVJ04G+3e9d13mrWzml5Uyst1oiIr72y9YcZlIjevYDVSC
AjPxE4M28BuINGki1jw6TREGfbKWWbcOWgQdwbUN3Qt9SC8KlejXsszVwmHQyqfg
E0McrjqWSt5BNREOc44Z2NUDQDZuDYRh3IHodi6+guYfT449zyT+3E1cbbQaq3g8
CoWML0BUXFgCafOrU+0KlmoT03spRtKYpafnRPWGCmn/yUFFZQ5nBNSvUsTrFRGj
i5sDcm+HS7X99ONWShUYG9vYyLCwiUBDMKe0wyGgTbW0Dqonl79BqrTbbXeEgaN2
CFiNaFpWgPGFKbYR56uP/54kiFa9y+b+zeF8Bsfqvu5WAlfTdy8VblNodan2QtUD
9YEbzXMC4VY0ACyMfGrxBsLRMowLqyO3bVqKHogCIY6Ji/I9zewuwY2t49wGnDvP
xHBvopM4Z+C2ecD4JgPk2eVo582WZHz7DXJaGMQe0gHrYGV7YquJZPNVdDq5dqHs
+IsFI22guZypXWJyO4Yx+IwWlTPwzBNfT+tnYA0/jsPn9+h2RdA45ewIHK/KSrk9
nG5kVU6B04zh+Bf7PTDsEfyabcfaau0hXZZo1/WSblxUysy2bSBnr/UhZdPSVtG0
nPH2Zu1yknnWwv3azPK7
=NU5X
-----END PGP SIGNATURE-----

--3hAdtgBjtgL7p0NQ--
