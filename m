Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751977AbaAPTn3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 14:43:29 -0500
Received: from sauhun.de ([89.238.76.85]:33884 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751811AbaAPTnZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 14:43:25 -0500
Date: Thu, 16 Jan 2014 20:43:03 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Shinya Kuribayashi <skuribay@pobox.com>
Cc: rmallon@gmail.com, mika.westerberg@linux.intel.com,
        Romain.Baeriswyl@abilis.com, rob.herring@calxeda.com,
        pawel.moll@arm.com, mark.rutland@arm.com, swarren@wwwdotorg.org,
        ijc+devicetree@hellion.org.uk, rob@landley.net,
        pierrick.hascoet@abilis.com, vgupta@synopsys.com,
        christian.ruppert@abilis.com, chiau.ee.chew@intel.com,
        khali@linux-fr.org, rafael.j.wysocki@intel.com,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        romainba@abilis.com
Subject: Re: [PATCH 1/2] i2c designware make SCL and SDA falling time
 configurable
Message-ID: <20140116194303.GC4127@katana>
References: <20130828153429.GB7066@ab42.lan>
 <1381244455-3836-1-git-send-email-romainba@abilis.com>
 <20131009075538.GQ3521@intel.com>
 <5255FAB5.7080803@gmail.com>
 <525A85D6.3090608@pobox.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="da4uJneut+ArUgXk"
Content-Disposition: inline
In-Reply-To: <525A85D6.3090608@pobox.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--da4uJneut+ArUgXk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> >You can also use the gcc-ism, which is a bit more concise:
> >
> >	sda_falling_time =3D dev->sda_falling_time ?: 300;
>=20
> +1

ditto


--da4uJneut+ArUgXk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJS2DZHAAoJEBQN5MwUoCm2qmMP/i30l5qC0IveqNude9EHHU2i
GdLGveQ6xKL5rvqytQ/u13psjSWf+ba+gnUv8+tY2ExlH9s2tNEdwWtBfU+tVhhw
GImF3z+Lau8NA0bOA5VBkLQUnEmFKb2N9IJ29uEi6CGFAWdvRcQfT8ohvjvGC99J
UChSq9LJeo28BNp2lOR86TM0UzoWvzAS+Qzb7q55VJxgYvmg+LZWJhb0AKm8Za5w
5hInrXOLPd6m4yNj17Tl/V2nGES46n28D7ZPYjp02Tf4Xkjpcx0/A9xIhDl3gq2h
3uJk65kq6iyqgHYgv2B7C092zF8YjSBp3r8vAWCOACx90rKdYKkeRzRRDfCc/FP4
7HqWK33kXHAcBJYBz6mp1Vjt05plaF498OF0Wp+ONn+SSxtlSvUFwhAKx6Qu2cg+
M+tiuuAvFmTB+w4+cALNeoE7uRCyXUzcNP+J8LBcnatcdBzoyEDVCgsSKY+fgLXW
xchSNFMh8h4Bla2yef9vJjZhHI+5C5VBvpCUfRFCu+EPhNGamiymuDA4vw/jhUk6
7LdDj1ElTQgdaNnbxEPo9uTsBuyud3qHOgbdhXvsXPWxkPoHy2uZWk4e92KqHmzk
GTL9lPcx80lkSWm40ntB/jyjXOy7B6nkd+Ba1D2XCjZc5Mcd2I1k+OysMrqqe+4c
JSZjPYBNI2zYIPiuoZN8
=kRrR
-----END PGP SIGNATURE-----

--da4uJneut+ArUgXk--
