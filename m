Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752915AbaEOPUH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 11:20:07 -0400
Received: from top.free-electrons.com ([176.31.233.9]:57307 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751660AbaEOPUE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 11:20:04 -0400
Date: Thu, 15 May 2014 17:17:56 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Emilio =?iso-8859-1?Q?L=F3pez?= <emilio@elopez.com.ar>,
        Mike Turquette <mturquette@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Chen-Yu Tsai <wens@csie.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Shuge <shuge@allwinnertech.com>, kevin@allwinnertech.com,
        Hans de Goede <hdegoede@redhat.com>,
        Randy Dunlap <rdunlap@infradead.org>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, dev@linux-sunxi.org
Subject: Re: [PATCH v3 3/7] mfd: add support for sun6i PRCM
 (Power/Reset/Clock Management) unit
Message-ID: <20140515151756.GX29258@lukather>
References: <1399633911-7094-1-git-send-email-boris.brezillon@free-electrons.com>
 <1399633911-7094-4-git-send-email-boris.brezillon@free-electrons.com>
 <20140509135251.GY5767@lee--X1>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dZJOqldIUwtPuZvk"
Content-Disposition: inline
In-Reply-To: <20140509135251.GY5767@lee--X1>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--dZJOqldIUwtPuZvk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Lee,

On Fri, May 09, 2014 at 02:52:51PM +0100, Lee Jones wrote:
> > The PRCM (Power/Reset/Clock Management) block exposes several subdevices
> > in different subsystems (clk, reset ...)
> >=20
> > Add basic support for the PRCM unit with clk (AR100, AHB0, and APB0 clk=
s)
> > and reset controller subdevices.
> >=20
> > Other subdevices might be added later (if needed).
> >=20
> > Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
> > Acked-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> > ---
> >  drivers/mfd/Kconfig      |   8 +++
> >  drivers/mfd/Makefile     |   1 +
> >  drivers/mfd/sun6i-prcm.c | 134 +++++++++++++++++++++++++++++++++++++++=
++++++++
> >  3 files changed, 143 insertions(+)
> >  create mode 100644 drivers/mfd/sun6i-prcm.c
>=20
> [...]
>=20
> > +/*
> > + * Copyright (C) 2014 Free Electrons
> > + *
> > + * License Terms: GNU General Public License v2
> > + * Author: Boris BREZILLON <boris.brezillon@free-electrons.com>
> > + *
> > + * Allwinner PRCM (Power/Reset/Clock Management) driver
> > + *
> > + */
> > +
> > +#include <linux/mfd/core.h>
> > +#include <linux/module.h>
> > +#include <linux/of.h>
>=20
> Ah, now isn't that better?
>=20
> Acked-by: Lee Jones <lee.jones@linaro.org>

How do you want to merge this? Do you want me to take it through
mach-sunxi tree, or do you want to take it in your tree?

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--dZJOqldIUwtPuZvk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTdNqkAAoJEBx+YmzsjxAgo68P/R8ljDUlMvla5sKEcygm+Y2M
eY9cbZtItF7S3vdB/x+nik6aBgts5Jo4V/qDfRt078GaYLIUrqkKI0vsP0CpQu0z
y7Y11xLwp1n6okdlV2IMwChXLgg86FlwAPbV2h/cotUaL5fbcCKOeCVdv0vyuoVI
OO/Q3X48LPHguEGOM3WD1hysV6JAsSDVShuh732pm9EOFmHehSoVoDfQt6cVuHk1
JY86pz/s7xW6gnqJEzkd5AyB/jaGZrXj8XmiNvMrzvqI4ety37qUU0/QSHNRGHJV
d3Tl5RB65CGugiXAV8IplZRb8NSRK4M/W9/5NYu0JD7TYBHDTiMrkHXWgZT/zJPm
Yz+YcJtZyMadyNGi07gIyGz3kvI0P55tPsq6BrhfDqMzouZoH7Cua2qhi5nMJ7ks
6N1B97TKvJKDNOy2h6GJuGtDnBSalXReDM6iyCFtUghWPaZoxLN2CX9eZJ8foV0r
2w67HjgtOn6qbOe/4fOknqQ2MyAYehL9Q7Hu5xlT1NbD2UfKwhlxBK5W6kbnj+jC
opuupSBgFlgzm5dp5MiaRA+sONDeynVTTshu52XZh0qiFcDdQKwJ0uEIVNsRRN0W
F1aBs5sqj2UXGZ20yymahCVuxwjx8BjoN4i/PZcL3WqLsYSVQQgVBpWED7JWRSVn
p5a4/SnkButY/67nWucM
=DRx+
-----END PGP SIGNATURE-----

--dZJOqldIUwtPuZvk--
