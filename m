Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756336Ab3FEOrl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 10:47:41 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:48512 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756254Ab3FEOrk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 10:47:40 -0400
Date: Wed, 5 Jun 2013 15:47:32 +0100
From: Mark Brown <broonie@kernel.org>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stephen Warren <swarren@nvidia.com>, Kevin Hilman <khilman@linaro.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Hebbar Gururaja <gururaja.hebbar@ti.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Wolfram Sang <wsa@the-dreams.de>
Message-ID: <20130605144732.GF31367@sirena.org.uk>
References: <1370439873-30053-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1XmnKQGVLLNJnMip"
Content-Disposition: inline
In-Reply-To: <1370439873-30053-1-git-send-email-linus.walleij@stericsson.com>
X-Cookie: Are you a turtle?
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 82.42.102.178
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/3] drivers: pinctrl sleep and idle states in the core
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--1XmnKQGVLLNJnMip
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 05, 2013 at 03:44:31PM +0200, Linus Walleij wrote:
> From: Linus Walleij <linus.walleij@linaro.org>
>=20
> If a device have sleep and idle states in addition to the
> default state, look up these in the core and stash them in
> the pinctrl state container.
>=20
> Add accessor functions for pinctrl consumers to put the pins
> into "default", "sleep" and "idle" states passing nothing but
> the struct device * affected.

Reviewed-by: Mark Brown <broonie@linaro.org>

--1XmnKQGVLLNJnMip
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRr0+BAAoJELSic+t+oim9trgQAJjQenbax5MvzvdqVbuPuoPF
RfWZVDmQ0KZYqIzPlzgwJC4ef5XO1X3Cl58L7DpT1LczlTRPe9ZGgqJfT4Ak70iw
qeBXkedQAAQVYNGmkIdBZqdiSyBOT/tU4nCL1a2r6aY2BgB426T1uSryN/sKm360
Zu9JEhU6yWBQOVRciPA5am6Dt+TYjVnfnbVjdCWjgzkapp17OTRqXz7yi4eRWqtl
puhDtNhgXLcffQOHN69SBag0CxY9WpwuhKq/bComcyGkvY60fXm7u3+eyMk8s8Vt
0sacHj7m72rRrBpm4s7WYUCS1o1SFEp7qEzp6jWWLoweUs9NTA3Oo0P+c4pXr2Wz
HWut4TWPBb0pO69UM1lo4Tj7zxPfAwg8nj28AOA7yVacw41NBKU8EV7Qn7Rq8DJK
I3Ej/OBNNLwtE5xAESKUfFp89lMFuVKAClhLcQUOduKtlYOx9MzQKJClcG/3eo5S
yQulyy9t6JgETXU5yKoDWicaSAE11wx7Q8Ln1HibcvxRwygsklRuE4MLi4e/M7BU
VhgCe7yA4S08Wc3gSDSB6Klpw5Y91PFxozxn9q48CGodntBkQp2Z9PlyIq5yQ+j6
HyJzm11t4pG5eFjq7I/JMwAIJhlGv1uznq6Sy8bCS8zd/bAMiHKiID7C1ntRFFs+
thTSMZeahvBtN0RkenlV
=OiYu
-----END PGP SIGNATURE-----

--1XmnKQGVLLNJnMip--
