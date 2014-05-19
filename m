Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754637AbaESOKR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 10:10:17 -0400
Received: from top.free-electrons.com ([176.31.233.9]:52383 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752984AbaESOKO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 10:10:14 -0400
Date: Mon, 19 May 2014 16:05:55 +0200
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
Message-ID: <20140519140555.GJ29466@lukather>
References: <1399633911-7094-1-git-send-email-boris.brezillon@free-electrons.com>
 <1399633911-7094-4-git-send-email-boris.brezillon@free-electrons.com>
 <20140509135251.GY5767@lee--X1>
 <20140515151756.GX29258@lukather>
 <20140519092159.GE4978@lee--X1>
 <20140519092725.GE29466@lukather>
 <20140519133253.GJ4978@lee--X1>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vSsTm1kUtxIHoa7M"
Content-Disposition: inline
In-Reply-To: <20140519133253.GJ4978@lee--X1>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--vSsTm1kUtxIHoa7M
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 19, 2014 at 02:32:53PM +0100, Lee Jones wrote:
>=20
> > > > > > The PRCM (Power/Reset/Clock Management) block exposes several s=
ubdevices
> > > > > > in different subsystems (clk, reset ...)
> > > > > >=20
> > > > > > Add basic support for the PRCM unit with clk (AR100, AHB0, and =
APB0 clks)
> > > > > > and reset controller subdevices.
> > > > > >=20
> > > > > > Other subdevices might be added later (if needed).
> > > > > >=20
> > > > > > Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.=
com>
> > > > > > Acked-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> > > > > > ---
> > > > > >  drivers/mfd/Kconfig      |   8 +++
> > > > > >  drivers/mfd/Makefile     |   1 +
> > > > > >  drivers/mfd/sun6i-prcm.c | 134 +++++++++++++++++++++++++++++++=
++++++++++++++++
> > > > > >  3 files changed, 143 insertions(+)
> > > > > >  create mode 100644 drivers/mfd/sun6i-prcm.c
> > > > >=20
> > > > > [...]
> > > > >=20
> > > > > > +/*
> > > > > > + * Copyright (C) 2014 Free Electrons
> > > > > > + *
> > > > > > + * License Terms: GNU General Public License v2
> > > > > > + * Author: Boris BREZILLON <boris.brezillon@free-electrons.com>
> > > > > > + *
> > > > > > + * Allwinner PRCM (Power/Reset/Clock Management) driver
> > > > > > + *
> > > > > > + */
> > > > > > +
> > > > > > +#include <linux/mfd/core.h>
> > > > > > +#include <linux/module.h>
> > > > > > +#include <linux/of.h>
> > > > >=20
> > > > > Ah, now isn't that better?
> > > > >=20
> > > > > Acked-by: Lee Jones <lee.jones@linaro.org>
> > > >=20
> > > > How do you want to merge this? Do you want me to take it through
> > > > mach-sunxi tree, or do you want to take it in your tree?
> > >=20
> > > If Boris can tell me what needs to go in with this patch (or if it
> > > can go in on its own), I will create a(n immutable) branch from which
> > > you can pull into your tree.
> >=20
> > We don't have any runtime or compile time dependency on this, so you
> > can merge it through your tree. Unless something change, I don't have
> > to pull anything in my tree.
>=20
> When you say 'this', do you mean this patch, or this set?  If I can
> just apply this patch, that will be ideal?

I mean you can apply these two patches:
http://lists.infradead.org/pipermail/linux-arm-kernel/2014-May/256537.html
http://lists.infradead.org/pipermail/linux-arm-kernel/2014-May/256535.html

And it would be ideal :)

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--vSsTm1kUtxIHoa7M
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTeg/DAAoJEBx+YmzsjxAgWeUQAIojasaME+KlrNwdu1pfQjHa
2/AxXBjLEf38nGcuO17Lq3PZMYx1AhcMzBGhlGi6Vn5kBLzZ96J2vrGi/F+Dmlcw
KCYdQFBn/QxuTNRqPII9LWVE7d2m2wjHvpHJv2tkd2NmyLR6+hBA0EideHHUaW0Z
li/UC2p8/PKKPRpa+80LHhvRd70k/hbzPUT1JsdKcII0y/Y3QmuVdlbrfrZcCeGu
YWuhqRTEAk/P59xFzJNuO77EvgpGTKWG4OLZ63TrvaDC8fQeNhOfERdbqs10EIWt
LfvJDFdo1Ulo4rcnFBdJfN7psPD973boKmFL/UZggir4NwRgVr7mJjQcU9Pxv201
0fU4cr+XZ6kF6Kj3dMmtKMytCfdO1uAQ5qBT/PzoSH+OHFZ8Twf8Yp6wBlowAkXp
OYivozZC2tCG9ZCEKV4Pg1w6KoxyKbt+HftmbS6EvTUJTAYWS0P3dmKefbtqcNw7
jEcd+Ok98WYzEZbluV6BxH7uThelTQftzBw3znye2O2s04WT+WyhS+abSMIN4yLU
eqXdYPGkHMF21oN1isEP3vKrZbOKFAahgZ4UbZyCOoltCrquUreoMUuAX5kuUA6I
TS1zd72fAlmr5IxzXyDk9MycGEbC/NcWdPH5eWJiaNExTvAP+7qK0xmzm9XZ9mYe
cdr7xkA2RC1JGUfW48N2
=MHYB
-----END PGP SIGNATURE-----

--vSsTm1kUtxIHoa7M--
