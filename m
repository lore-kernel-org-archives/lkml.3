Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932988Ab3GCSXP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 14:23:15 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:45168 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932660Ab3GCSXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 14:23:12 -0400
Date: Wed, 3 Jul 2013 19:22:54 +0100
From: Mark Brown <broonie@kernel.org>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        spi-devel-general@lists.sourceforge.net,
        Ryan Mallon <rmallon@gmail.com>, mika.westerberg@iki.fi,
        grant.likely@linaro.org, hsweeten@visionengravers.com
Message-ID: <20130703182254.GE27646@sirena.org.uk>
References: <201307021009.30230.hartleys@visionengravers.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4vXjQNnSxf1+t97G"
Content-Disposition: inline
In-Reply-To: <201307021009.30230.hartleys@visionengravers.com>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 07/11] spi: spi-ep93xx: remove 'dss' from per chip
 private data
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--4vXjQNnSxf1+t97G
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 02, 2013 at 10:09:29AM -0700, H Hartley Sweeten wrote:
> This value is only needed to set the bits per word for each transfer
> of a message. There is no reason to set the value in ep93xx_spi_enable()
> because ep93xx_spi_process_transfer() sets it again for each transfer.

Applied, thanks.

--4vXjQNnSxf1+t97G
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR1Gv7AAoJELSic+t+oim9Kk4P/1TK1/teZ5P2ZhfHQ/NDXtfK
Os53h2qwVfjYNZwosaJDaIulUToRDdUSVck4nPQX4YwkWo+1Fdpk6SU+cAoe4IQg
gnb8TLieMyBoh9VECTLLzvowbI7VY1Rtmlqx4I7nRHm2JfNVudh/3JnYA+GfcSLn
RmeoFFe6fW/zLWOsWHhinemn+Bvvjs2EM2f03256qggSRGht1on4LE/nR1hRbXfS
0mjNFqGSARrtVlLTl3kDmqkdtTiDmHJSw6i4jGVnFV/XozXxBuzFS7Z3qwZ7OJy1
KjJFbYVl+MPKduw/YDAQdRSkKCVEPgkdE2VLaUpNx3mJ3twh5WrgskV+MdKl4lj2
4wcYuHz0mTixFjyQ1XnD4xWnCMx4GLA6CAMKyt2fWMINCvQvPNlVBm4H8okYfDwL
ym2sX/jVr6mBQIuqtjBOw6WwIeJ2GmsLQHDJjtHm2mReptXjZcuuCnzmVxjm6gx/
qZwcr3PEAsD0gsKe2yxYQnPIGaT3JzNEY2BVRHLQRJ69lsvmNooE322Sx0KlkI8y
J/P6eZbFg/Uw3WJCd+b+QRfIjsjonCIWAtD34s7c9LPoCUoPnrPsJJKGDQotyl7+
dLXPaWek7UGYH1HB/ocNYt4iHCSF0OeotsLx1O11fkaMD1rbuZOuGnxskt96Iccs
vh8iDOgGy4eFg6ffSW24
=2v6/
-----END PGP SIGNATURE-----

--4vXjQNnSxf1+t97G--
