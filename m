Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751696Ab3CZVTc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 17:19:32 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49764 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751172Ab3CZVTb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 17:19:31 -0400
Date: Tue, 26 Mar 2013 21:19:23 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Aaro Koskinen <aaro.koskinen@iki.fi>
Cc: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        Eric Piel <eric.piel@tremplin-utc.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Tony Lindgren <tony@atomide.com>
Subject: Re: Driver lis3lv02d_i2c not working on Nokia RX-51
Message-ID: <20130326211923.GM18316@opensource.wolfsonmicro.com>
References: <201302170046.26569@pali>
 <201303242345.00176@pali>
 <20130324230435.GE18316@opensource.wolfsonmicro.com>
 <201303261602.40219@pali>
 <20130326205319.GK14155@blackmetal.musicnaut.iki.fi>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/YEZ/b5VMxfka8q2"
Content-Disposition: inline
In-Reply-To: <20130326205319.GK14155@blackmetal.musicnaut.iki.fi>
X-Cookie: Your aim is high and to the right.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/YEZ/b5VMxfka8q2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 26, 2013 at 10:53:19PM +0200, Aaro Koskinen wrote:

> From: Aaro Koskinen <aaro.koskinen@iki.fi>
> Date: Tue, 26 Mar 2013 21:34:22 +0200
> Subject: [PATCH] OMAP: RX-51: add missing regulator supply definitions fo=
r lis3lv02d
>=20
> Add missing regulator definitions for lis3lv02d accelerometer. Fixes
> the following probe issue:

Reviewed-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

This is exactly the sort of thing I'd expect to see the board doing.

--/YEZ/b5VMxfka8q2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRUhDTAAoJELSic+t+oim9J2EP/jviaq4yYYgCZ+0OBmONZeGC
rrwoWRA6ic5pavhroQeHG1m0BfM4IrlChUgivRNe/RjUle9uuWoBLb7yts0BxS7l
EyxK6/eCA3oNFX3Hwe+aB9ksOTNIo7q9RdhJTf2mWxGz5u48ExRurBPmOn5zmTHi
pDncMy1dXcAWYIlp9DaVDkINX7OTQoLaOnI8nUCmJai24GePZDDvaShn+wBXBBiQ
qNRngN7ww2kvUOz6O2OcaigN2Yn9DoffRTB11PirZgqtmyJZOCaJv4/gdin4EGMH
8hplv/VVcUdegQ5knsJ5NiL7NBfwZ3sFcIjGTogA5Oerrbgd6rrD0l2VSuyQybxd
ssA5OonFflrJn1NJzWgc6p6WhYMG0PIcitwSBqTf0s/R0dqQes/rN4HGeo5ng6AG
z33n6L0oQEZuvjFJ+PgnYpbm/Q2ZzCAjzMdcL11sZSZpVZmhqkZ2WCErRv36iZME
QDJV3x52PuavijL3tV045pR7M7TefX5WkeOw8zUuqMMyeyiqrFCH86z2lXiDwDo1
GLvKNb7S1pL+lxTtwLWeA6jWnXIqKcitdpH0q6dGToIq0zF5pA2T5hJWSmhWUyjF
5pvhlgx48JH+kkBF5Gntm4XIqIJanuZoZGS+R1Ja7/nRTpOHSccQ6y2DhP+1pryd
TzxHrAueTeOv3TlmCmjV
=aDF+
-----END PGP SIGNATURE-----

--/YEZ/b5VMxfka8q2--
