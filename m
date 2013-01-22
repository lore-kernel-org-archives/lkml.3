Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752591Ab3AVGle (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 01:41:34 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53329 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751127Ab3AVGld (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 01:41:33 -0500
Date: Tue, 22 Jan 2013 15:41:23 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Vincent =?iso-8859-1?Q?Stehl=E9?= <v-stehle@ti.com>
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: Re: [PATCH] regmap: debugfs: Fix compilation warning
Message-ID: <20130122064121.GC1766@opensource.wolfsonmicro.com>
References: <1358779015-25735-1-git-send-email-v-stehle@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/e2eDi0V/xtL+Mc8"
Content-Disposition: inline
In-Reply-To: <1358779015-25735-1-git-send-email-v-stehle@ti.com>
X-Cookie: You have taken yourself too seriously.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/e2eDi0V/xtL+Mc8
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 21, 2013 at 03:36:55PM +0100, Vincent Stehl=E9 wrote:
> This fixes the following compilation warning:

> -	unsigned int i, ret;
> +	unsigned int i, ret =3D 0;

This sort of fix is not a good idea, you're just shutting the warning up
without any sort of analysis explaining why it's generated in error.  If
it's generating a spurious error that's a compiler bug.

--/e2eDi0V/xtL+Mc8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQ/jSGAAoJELSic+t+oim91toP/3tBWupSMuVDE2ttvLGCbEV9
bgBlf3thfwZ9sSlcpJQLvzWCSMrp9OPZ0e9rt+IdFqaq/4u70LyJD6RBlBv/IADU
oqaknMpPBDqAcpVM0RbPqWzF7q1Bp2olTxuB8rRb+8qcl1C6mg8e151sSkqivbtI
sZhi/6UkuvxDoYWsJ8KcFH1qwpIOm9pDb3TuVsZ3Oawk8UakgyBipiPopJaWl3k2
qlggtAOf5mhbs/+Afh4+fPq/gDiov/t20YMG6kjv5PNcewrtdY8UCET+b4ukA9gE
/Z8D3Hr7vzDo9Qy87Qbos+YWYxFsTKga5wrll0X3wvZz2lVrtqajjeEXWd2rLPi9
yDyooOCVzeBdtw3VgjyPYjECEUMRH3zUh1KnPZypMg3k+OEQcg2ciD2iWpp77PM+
TAuUj7sfZv0c2XnMthUJRxz33W8WMPjC5S1OQC403PHTlS4Eaqi2m2gvPbkFgFdh
MJpfNMoTL29/sXPi6jEyG9gF83rWKBq7Mt0zIXARVtsEkMmU0jzfGcG7lasujOGH
Oz5B3QliFpmj1y7lq28aHuaCKF2PDaKrRzcU5QqLi9+hSWHM8sZLiJrHFvtoKk2o
h1mfvoo+CarKwC7ewhaVJ3lgZ6w2Ej4P6HT1lIP5wc3HnbiFz4uL56oFsaQqtsWc
1WXq0mcr6ciyCaRl0XQv
=0w1V
-----END PGP SIGNATURE-----

--/e2eDi0V/xtL+Mc8--
