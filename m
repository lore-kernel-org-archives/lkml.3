Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753545AbaJGND3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 09:03:29 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:45438 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752281AbaJGND2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 09:03:28 -0400
Date: Tue, 7 Oct 2014 15:03:20 +0200
From: Markus Pargmann <mpa@pengutronix.de>
To: Mark Brown <broonie@kernel.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, kernel@pengutronix.de
Subject: Re: [PATCH 1/5] regulator: Add ena_gpio_valid config
Message-ID: <20141007130320.GF5042@pengutronix.de>
References: <1412626635-7404-1-git-send-email-mpa@pengutronix.de>
 <1412626635-7404-2-git-send-email-mpa@pengutronix.de>
 <20141007115335.GW4609@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nHwqXXcoX0o6fKCv"
Content-Disposition: inline
In-Reply-To: <20141007115335.GW4609@sirena.org.uk>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 14:49:06 up 27 days,  5:36, 92 users,  load average: 0.05, 0.07,
 0.05
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: mpa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nHwqXXcoX0o6fKCv
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Oct 07, 2014 at 12:53:35PM +0100, Mark Brown wrote:
> On Mon, Oct 06, 2014 at 10:17:11PM +0200, Markus Pargmann wrote:
> > Most drivers do not set the ena_gpio field of struct regulator_config
> > before passing it to the regulator core. This is fine as long as the
> > gpio identifier that is passed is a positive integer. But the gpio
> > identifier 0 is also valid. So we are not able to decide wether we got a
> > real gpio identifier or not.
> >=20
> > To be able to decide if it is a valid gpio that got passed, this patch
> > adds a ena_gpio_valid field that should be set if ena_gpio is a valid
> > gpio and should be used. It is a preperation patch for multiple patches
> > that adapt the drivers and fix the regulator core checks for this field.
>=20
> This should be part of the patch adding meaningful behaviour for the
> flag, it's pointless separately.

I tried to keep the series bisectable while having different patches for
the drivers and the core. By splitting this 'ena_gpio_valid' field into
a seperate patch, the rest of the drivers will still compile and work
until the core condition was changed to ena_gpio_valid.

But I can squash the three patches into one.

Best regards,

Markus

--=20
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

--nHwqXXcoX0o6fKCv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJUM+SYAAoJEEpcgKtcEGQQN9sP/2HWHHSEINaqWeuZOU3in1NV
UHwuJAU/SNZO01y+mXXoRdAItYxG+ncN9c3qTH2iQm8MGNbabU5KuEw/7fnkmWhv
ttwREdiDt3Q/ozfXXkJm5+R8bGvuXH6OHHGjit14UqzLvU+F1vdL4W9FlPMYwMEi
ldngxurWek2kRAmKaib370eYs7KUGT8s3bvQSHE625zxLl3g8kewOk8N20L9kjnU
dfMjh2dwyO6coLW97SDo13IATdBoKO18dWChFupimfvmjwg6FpIcDsMtt48yrck6
N3s5uac9WDvo84nlyWo3usVDyIm3bdMUv86sMJAip3/VZLJxrKrLKNQTJq3/ai94
dTRH7OU3dwTnvziVJtuiHwk1udfsNGcoFbP9IiJDk3DVx7YnoNKkG3okhYKBlteV
v/bnuxymsRPtuJ8MwMKv0jML5K9GIXVd14rnerHnXc2zLH6t9u/GszRGqkNgPee+
rf2OWvbFBVLqNe54QYr+YW/Q+QtpaPQw25oItSPpbem+4mXpsOsdOFReFyySMH8R
12Ti6SOixP2/Satd0cHYAYOeCm7fRi+WZ3AF/gRnrRJt0U9PwEDMidiutSSQEFl3
Qa4HH5Rxxsox9vOB0MWgiXETqNdlardfsDozoEAJN1AKt5FNQJhqWO+B26bb7+Kg
hbbYa5YH3yA8lGzLDiK3
=UYEs
-----END PGP SIGNATURE-----

--nHwqXXcoX0o6fKCv--
