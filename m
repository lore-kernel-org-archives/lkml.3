Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754586AbbAUQyN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 11:54:13 -0500
Received: from mail.kernel.org ([198.145.29.136]:52775 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754325AbbAUQxC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 11:53:02 -0500
Date: Wed, 21 Jan 2015 17:52:50 +0100
From: Sebastian Reichel <sre@kernel.org>
To: Adam Thomson <Adam.Thomson.Opensource@diasemi.com>,
        Lee Jones <lee.jones@linaro.org>, Jonathan Cameron <jic23@kernel.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Hartmut Knaack <knaack.h@gmx.de>,
        linux-iio@vger.kernel.org,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-pm@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>, devicetree@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org,
        support.opensource@diasemi.com
Subject: Re: [PATCH v6 0/7] Add initial support for DA9150 Charger &
 Fuel-Gauge IC
Message-ID: <20150121165250.GG13715@earth.universe>
References: <cover.1421854282.git.Adam.Thomson.Opensource@diasemi.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="PyMzGVE0NRonI6bs"
Content-Disposition: inline
In-Reply-To: <cover.1421854282.git.Adam.Thomson.Opensource@diasemi.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--PyMzGVE0NRonI6bs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Jan 21, 2015 at 03:46:25PM +0000, Adam Thomson wrote:
> This patch set adds initial support for the Dialog DA9150 Integrated Char=
ger &
> Fuel-Gauge IC. The device also provides GPIO and GPADC functionality.
>=20
> In this patch set the following is provided:
>  - MFD Core support and DT bindings documentation.
>  - IIO GPADC support and DT bindings documentation.
>  - Power Supply Charger support and DT bindings documentation.
>  - Update to MAINTAINERS file to add DA9150 files to Dialog support list.
>=20
> To keep patch submission from being too large, support for GPIO and Fuel-=
Gauge
> will come after initial support patches are accepted.
>=20
> This patch set is baselined against the v3.19-rc5 kernel version.
>=20
> Changes in v6:
> - For GPADC driver, Use lower case extended names for IIO GPADC channels,=
 and
>   remove extended names for GPIO related channels.
> - For charger driver, revert to no devm IRQ request/free functions as ord=
ering
>   is important, and probe failure scenario was not being correctly covere=
d. A
>   helper function for free IRQs has been added to make code cleaner.

Probably a devm_ variant of power_supply_register should be created,
but for now this is ok for me.

Jonathan, Lee: I assume you are ok with the whole patchset going
through the power supply subsystem?

-- Sebastian

--PyMzGVE0NRonI6bs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJUv9lcAAoJENju1/PIO/qaIKIP/14eqxi1ase5m88E13nRORfJ
3OB3fQIYR0V5yEJCUCAWYAxhYdfiSuVVsZBAyYCPnz2Njae6DPoMNJgcyca1U2S+
8PqyIlp2PSYOixTHECTXWC/XwS4Y7sk3tc1WVqgoy1x8tCCuAw0shGMyCN87P7U9
ouNBTgNtF0k/V577HrDjwkgKaC78tdh+h5IeomPpYzQjE7l4MyA1TgNk8UT+v9CB
jLkzDs8VLThcCnB5GKmRfFOYZMbTs1mtv3D1IoLRJ65M0QEn8kU9Id4YHdwhmNqk
g7cJe1s+ep7VExJ+qCoVyKnGfZmycDK7KzZ3A4rGUz3KPaxsqI5EAS9/cKiugMCM
PfI9XhIF31Sw6/erXxfNhTJmueKiSo7yf3tx1ZA3Geg7aR8bSU3SaEbYXOHfiKRj
A6RjfmAFhBx3N2cJxhylxU0ZiRkZUtVr+KIGDlezYap8md2W94dKFZlegCYN+Y5Q
/VgKwHVGzXuG2t14k+oek4p0GTYIy8IbnSC4zGZr9qCUOfT6yKzSx/mC81MVPsfD
9jobcopwL9lghFx44mYwrwgbautZOxmNFrC0j1EMXHlXqcDH1cNvHh1jevdi0LzJ
srJvcNVz4xDewvrY4Qhhup31Jj6FTX5bqmqF7Z/JNj5tYu2nJajW2cmS1I93kx4R
/80/ZvrMX6/NDajDv4gy
=G8aH
-----END PGP SIGNATURE-----

--PyMzGVE0NRonI6bs--
