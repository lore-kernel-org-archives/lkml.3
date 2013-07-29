Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757289Ab3G2QCG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 12:02:06 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:54714 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756986Ab3G2QCF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 12:02:05 -0400
Date: Mon, 29 Jul 2013 17:01:57 +0100
From: Mark Brown <broonie@kernel.org>
To: Ashish Chavan <ashish.chavan@kpitcummins.com>
Cc: lrg <lrg@ti.com>, alsa-devel <alsa-devel@alsa-project.org>,
        David Dajun Chen <david.chen@diasemi.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "kiran.padwal" <kiran.padwal@kpitcummins.com>
Message-ID: <20130729160157.GZ9858@sirena.org.uk>
References: <20130705114456.GV27646@sirena.org.uk>
 <1373031306.3233.131.camel@matrix>
 <20130705133752.GX27646@sirena.org.uk>
 <1373270091.11222.12.camel@matrix>
 <20130708112613.GQ27646@sirena.org.uk>
 <1373542576.9286.101.camel@matrix>
 <20130717103651.GP22506@sirena.org.uk>
 <1374482594.13726.11.camel@matrix>
 <20130722100211.GP9858@sirena.org.uk>
 <1375110386.21326.6.camel@matrix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5dN7yJDGW7BLmQKo"
Content-Disposition: inline
In-Reply-To: <1375110386.21326.6.camel@matrix>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [alsa-devel] [PATCH] ASoC: codecs: da9055: Update driver name to
 fix breakage due to pmic driver with same name
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5dN7yJDGW7BLmQKo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jul 29, 2013 at 08:36:26PM +0530, Ashish Chavan wrote:

> produced as a standalone codec device soon, and we hope the driver can
> be re-used directly without changes. Is this the reason why we see only
> a handful examples of suggested implementation in kernel?

Well, it's a very unusual hardware design choice to have multiple I2C
endpoints in a single physical chip.

With regmap it should be very straightforward to reuse the same driver
for both standalone and non-standalone versions, just a small amount of
glue code in the CODEC driver I'd expect.  Usually the bus level code is
tiny.

--5dN7yJDGW7BLmQKo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR9pHyAAoJELSic+t+oim9xFYP/1p3PQhPfBq50DZQEQzcIQ13
gNMjDh1XmkrysHQt0uumKEyJE7jyoWC1T1TydIiGXKn8X4fx6oLp9HJ0kpiUeXoa
xMaeZOt0Sq1pXvRBDXXBDjlCTopQbI1NwoKd73Td/wD+a1W6XsuverMGrjDmncnm
nXVKAGaBEkhXkeNDrRuFieh1pVYoTdrsOOqhWwwL//SNIfYixvvPZg/hlPC+28fO
vt3zYVCKmB88towYJgUOsKIXjyOAEzLILTOBSzdRZPcw/CuN4ZRGpAhNVHC1BslV
Gw4QygGIibDReoSJTVy/ReLBYNibPEkHk6X09mwMvbTkPYckzErsCuRHwk6alGRE
f53FuZRxBgnuTYJ9vrePBjGlSzDJ02CnUCGPZ+58SrU38RFL4EJrb6uoPipeunp9
PGdoYbApMsaPdbjw15Rtketk7vJqe4eiv4vSqx5+IHGLx+ck93A2Ion+swLdZseC
29v0T6IBYYcbP1LbuStPMnfIzSZAx2KIm8TssQPlQhVWRzUAg5mAN13NeqHrB6s6
I003nElUEwjGg6uLIIgjPceUgTg3SZaABt0dOaSX3Eqc7oPN3PsyMLEMNEstFxFw
zlXK4TltEypAIiJobtCSVPXJs1+TKyHvjG10WIZiVMcaxAIqfcQcEOPPBNfNGn3N
jT4yfs1aYIw2aSEYPmVn
=t8ME
-----END PGP SIGNATURE-----

--5dN7yJDGW7BLmQKo--
