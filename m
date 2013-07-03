Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932921Ab3GCSVa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 14:21:30 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:40660 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932837Ab3GCSV3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 14:21:29 -0400
Date: Wed, 3 Jul 2013 19:21:25 +0100
From: Mark Brown <broonie@kernel.org>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        spi-devel-general@lists.sourceforge.net,
        Ryan Mallon <rmallon@gmail.com>, mika.westerberg@iki.fi,
        grant.likely@linaro.org, hsweeten@visionengravers.com
Message-ID: <20130703182125.GZ27646@sirena.org.uk>
References: <201307021008.22347.hartleys@visionengravers.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jX8Pshh5UTBtMvDS"
Content-Disposition: inline
In-Reply-To: <201307021008.22347.hartleys@visionengravers.com>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 05/11] spi: spi-ep93xx: use devm_clk_get()
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jX8Pshh5UTBtMvDS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 02, 2013 at 10:08:21AM -0700, H Hartley Sweeten wrote:
> Use devm_clk_get() so that the clk_put() happens automatically when
> the last reference to this driver is dropped.

This doesn't apply against current code - always submit against the
relevant development tree, in this case topic/ep93xx.  I've applied it
with a manual fixup.

--jX8Pshh5UTBtMvDS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR1GuiAAoJELSic+t+oim96iAQAIttbyXm8MIujbH6XhN42a6j
QimGI1v07oP+tQi6sr4fjF7VgHE8ClQFesd7SlXgVhMgb+E0TW5+aIN9+bbW3mj+
eJLkvAxhSsLGgX7EotxPKjLMTtWRmLgViJTEf0BaaYTzzBKia/D/wVzw3fiscc6o
CiczqjHWEbzsro+Q9f+S1oX6gideCgCyiwY5/IRCZ5LNzcxLxutVUwg7ZU0XSgSC
lzT9OC97cMnfaKNBrzPFRqT9KPPG6KbsVx3mq8Bm5m/wg+uVEpQBBTOOAuq/Q0Lf
SpmCSUSmmNLE/5pNmgurti5AAIn+kfjTTTjth0/1czzRMM/aIaWUK3qPqO3EqOF+
44QcKk/QZsyB5q934+HYH8+XN7ngrqt5g0PR24L9XWF8D2Dgz8m6BXXWLr+VJ6r9
IaNV7z2EOtqTqvO/iMkNE2SGUKvQlORDgbZUFUI61Q2BGGZ3vbLOxQGo/ONRZgrF
TwbZHuv8VUY9BGQaB5amL9wl66I0qy0vhxKsnNdevP14Pq1aydqBDhDXFAgkDRnZ
T2zHhaWHMjEM29jD3zJBslcvl8e7O5ZTivjTyIByiDSFUr4BeJslcHrDQS1qMSJo
QdkSVawpV4ucoakFxuH8M8WTsXzaNvRlQk5OOjZdQ8FkjNnr5KyAaj+JGgR86jb6
z1coaBQjEU4vyOHltouy
=CKSv
-----END PGP SIGNATURE-----

--jX8Pshh5UTBtMvDS--
