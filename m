Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756120AbaBGMwk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 07:52:40 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:37765 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753030AbaBGMwf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 07:52:35 -0500
Date: Fri, 7 Feb 2014 12:27:16 +0000
From: Mark Brown <broonie@kernel.org>
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
Cc: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        linux-spi@vger.kernel.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <20140207122716.GH32298@sirena.org.uk>
References: <20140206175059.GW32298@sirena.org.uk>
 <1391759007-25305-1-git-send-email-iivanov@mm-sol.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9Z5hYcGq4mWDMhAr"
Content-Disposition: inline
In-Reply-To: <1391759007-25305-1-git-send-email-iivanov@mm-sol.com>
X-Cookie: Take it easy, we're in a hurry.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH RESEND 1/2] spi: qup: Add device tree bindings information
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9Z5hYcGq4mWDMhAr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 07, 2014 at 09:43:27AM +0200, Ivan T. Ivanov wrote:
> From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
>=20
> The Qualcomm Universal Peripheral (QUP) core is an
> AHB slave that provides a common data path (an output
> FIFO and an input FIFO) for serial peripheral interface
> (SPI) mini-core.

Please fix the formatting of this document so the lines are less than 80
columns, it's hard to read as is.  Otherwise this is fine.

--9Z5hYcGq4mWDMhAr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIbBAEBAgAGBQJS9NEhAAoJELSic+t+oim9OQAP9j3gLolKvvxmmPyjxkAEKqU0
+OsKBHIzMFLjFnkXj+V7KGSQ6scRjcVAVs9yx8bRmP6UDypjcVEnGlrhHkl6jJl9
1eN4FhdGCr7KisjqZ/dMIdu/1fZY/635MPONyCrNBvsNBpJowVPzrAcLir2USRaK
9MopL4rdfbHL8oEXqhaWp5FqxP0M3bVIR81W1IBAwqub5NqN+JdPOoRIdufU3i5D
fmYD7sVL+Sl5rj+xpBHsdp5Vq4dsgDtSVwroE+hUoSXhJddsFy8/lfHbpD4wP3y8
y8ThnNexS8NKbG8tEpWajDrY4aBSVtYEwYhNHI60mu6V5T+ns2tXryuzLbc+jHhp
gTYs5JGQ21BZqJLh1aoI0/SFXt5daA6V2ZaXrWr7rpWAgQ24CbjbsVO7cQm4Ki/l
6ycsoiocXYjIXxLBS31m3OMxP8P0r9K/bkq0n6g0FudlYn6UfWrTXeuoH9ScoonJ
5PrEbIK3S4nQvzJjtz+xE8fHw7rX7qskhn+gwzxk7HgdYvBfgF8wwtMgxo/pFFzM
hiCKBrS3ECs9CE2mQQr0rSI64thjChDvnjWfIuUu5P0JVvxbdX8Pfr8ZuJ9sVyD5
y6dslz9aK/u0q5B7N0KUSVS7F9AJaf0FP7uUVW7gUlLyZAfALhQYRCa+zGH0CKUn
sftJI5v7DXhu3CzEfG0=
=Erxw
-----END PGP SIGNATURE-----

--9Z5hYcGq4mWDMhAr--
