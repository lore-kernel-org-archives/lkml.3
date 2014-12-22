Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754987AbaLVShY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 13:37:24 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:44277 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754403AbaLVShU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 13:37:20 -0500
Date: Mon, 22 Dec 2014 18:36:53 +0000
From: Mark Brown <broonie@kernel.org>
To: Laurentiu Palcu <laurentiu.palcu@intel.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Johan Havold <johan@kernel.org>,
        Octavian Purdila <octavian.purdila@intel.com>,
        linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <20141222183653.GJ17800@sirena.org.uk>
References: <1418046749-6023-1-git-send-email-laurentiu.palcu@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="aRzsUE0Mp86t8N62"
Content-Disposition: inline
In-Reply-To: <1418046749-6023-1-git-send-email-laurentiu.palcu@intel.com>
X-Cookie: You have no real enemies.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 31.51.36.65
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v8] spi: add support for DLN-2 USB-SPI adapter
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--aRzsUE0Mp86t8N62
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 08, 2014 at 03:52:29PM +0200, Laurentiu Palcu wrote:
> This adds support for Diolan DLN2 USB-SPI adapter.
>=20
> Information about the USB protocol interface can be found in the
> Programmer's Reference Manual [1], see section 5.4.6 for the SPI
> master module commands and responses.

Applied, thanks.

--aRzsUE0Mp86t8N62
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUmGTEAAoJECTWi3JdVIfQFFUH/1iza1WA9N1zScAtu+o3oEDl
/xx9ISaS4l25lC7BSkb6h3ZRN/MhL/HWNJHuc40qYeAAzra+OThtm46fHReQIJQp
c27RAMvfWP++jNROEswDfs9LLpJzKZ+kCEDCZyrlXNwj4Y0XLmLG5cC/TaPy/Odk
sUbW6uQZ1y+gsnJHqLCNjgUuVhMZPGLbZyaCxUjDUq8B+AZKpqIF3w8ET0RQMARV
bJdzyTtxxgYLHaGvqKVkJoi0rkBerzNbZ5vUYhDgjHqZv0cqPTf8eFK3S6GtaYPc
lJvPYFXA7mHpA0k7vnbPf9uJgP4eqZsg8HjzmZtYslVf9sKVYQA29vdCpvfXTnw=
=obdd
-----END PGP SIGNATURE-----

--aRzsUE0Mp86t8N62--
