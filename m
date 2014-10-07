Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932300AbaJGTS2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 15:18:28 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:56272 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754325AbaJGTS1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 15:18:27 -0400
Date: Tue, 7 Oct 2014 21:18:19 +0200
From: Markus Pargmann <mpa@pengutronix.de>
To: Mark Brown <broonie@kernel.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, kernel@pengutronix.de
Subject: Re: [PATCH 1/5] regulator: Add ena_gpio_valid config
Message-ID: <20141007191819.GI5042@pengutronix.de>
References: <1412626635-7404-1-git-send-email-mpa@pengutronix.de>
 <1412626635-7404-2-git-send-email-mpa@pengutronix.de>
 <20141007115335.GW4609@sirena.org.uk>
 <20141007130320.GF5042@pengutronix.de>
 <20141007161933.GH4609@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="smOfPzt+Qjm5bNGJ"
Content-Disposition: inline
In-Reply-To: <20141007161933.GH4609@sirena.org.uk>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 21:12:53 up 27 days, 12:00, 84 users,  load average: 0.13, 0.14,
 0.12
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: mpa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--smOfPzt+Qjm5bNGJ
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 07, 2014 at 05:19:33PM +0100, Mark Brown wrote:
> On Tue, Oct 07, 2014 at 03:03:20PM +0200, Markus Pargmann wrote:
> > On Tue, Oct 07, 2014 at 12:53:35PM +0100, Mark Brown wrote:
>=20
> > > This should be part of the patch adding meaningful behaviour for the
> > > flag, it's pointless separately.
>=20
> > I tried to keep the series bisectable while having different patches for
> > the drivers and the core. By splitting this 'ena_gpio_valid' field into
> > a seperate patch, the rest of the drivers will still compile and work
> > until the core condition was changed to ena_gpio_valid.
>=20
> > But I can squash the three patches into one.
>=20
> No, I think this is missing the point a bit - if we need to introduce
> this such that all drivers are instantly buggy without an update that's
> probably an indication that we're introducing compatibility problems.

Yes, it was designed to not be compatible with the old way of setting up
ena_gpio. But I think it shouldn't be a problem to get it backwads
compatible. I will fix the series and send the next version with one
core patch and another one which adds ena_gpio_valid to the drivers.

Thanks,

Markus

--=20
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

--smOfPzt+Qjm5bNGJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJUNDx7AAoJEEpcgKtcEGQQ7ewP/jbtD3595Kl3kMEaTH/c+Ajl
gFaRvvOin6uam7qZcCzQEPpMmxWYa8YMDqPA4DWB1/sYsr1YWcmIFf9QI9LD/tcl
ebXedXXWvj8kHKyLFLzouvhnYjbFaztRQApRl95EmEtvbnoLhnVhXN0XadoAfevH
0axX/+ceo+KDkwgphRKy+yHcXnhlKtoG2efnLi04J6YwnnLtIBTqAUEfIC/+JI9G
jX7KgCFApTfONOQ3n/X5xytv/bFNIIdM41j5/8xTR4ukKNeaE3oly0E55H+LndMW
WI58hqguYs7xBq24I619I0gYjYZlgG1gcybK/F+3JKSnbUtBUbmUdEeurEM7ABZT
fA0iL8bG5lYLXZtJbcHJSs8KZGzRCTQ6RTXY9z7HWT/8a48tDyryiL/VckorX7BB
S4AuiHWocrGbWhelpPygDvSSB9qmxHv/HZ4mmE2pDbFvm2A7P9dxTRQF4gRKCf77
nDl8F7JwL/Rq6Ea8zEL3nj79FuMCKk1KUP7GdeGgSdmffV8eJ3W7WjDe73kpl2CN
scmTr2o/nih9ee1QOSO06HrMgqMf8LMpsL0ru93jxv5pB/+Gk/UmqsRIurKI4pft
3y8nOID8qtOLXno93Xhqcyew5h/9xvgcrIN0trqrqU4ckcTpHmu24F3SxpH6JqEU
ZM6ffvBu82ex3Xyebvqf
=G7XW
-----END PGP SIGNATURE-----

--smOfPzt+Qjm5bNGJ--
