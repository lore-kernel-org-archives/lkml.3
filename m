Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754248AbaA0UCu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 15:02:50 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:60262 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754228AbaA0UCr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 15:02:47 -0500
Date: Mon, 27 Jan 2014 20:02:42 +0000
From: Mark Brown <broonie@kernel.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-spi@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Message-ID: <20140127200242.GE11841@sirena.org.uk>
References: <1390553044-11860-1-git-send-email-geert@linux-m68k.org>
 <1390553044-11860-4-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="djTb5EnuS5qMpC9h"
Content-Disposition: inline
In-Reply-To: <1390553044-11860-4-git-send-email-geert@linux-m68k.org>
X-Cookie: O.K., fine.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 03/14] spi: rspi: Abstract 8/16-bit Data Register access
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--djTb5EnuS5qMpC9h
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 24, 2014 at 09:43:53AM +0100, Geert Uytterhoeven wrote:
> From: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
>=20
> Add rspi_{write,read}_data(), to abstract 8-bit (QSPI, and RSPI on RZ/A1H)
> versus 16-bit (RSPI) Data Register access.

Applied, thanks.

--djTb5EnuS5qMpC9h
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS5rtfAAoJELSic+t+oim9GR8QAIVQ5aMYdo7xM1q4Tz1ADKTn
n0AgThGhXhu0SV0ejaChXXA06FVh2ai91YdV8S4q/0hIQmrdPmcI1HtkZHrt/gcY
7gDlGf87LOjcbLwwqa5vM31Trbc0FIvH4s5o5IeFh51NLftPctRJMl0iBZ36SW0U
lcHNOB+QjODZZ/L6KAFmhyysJFcwvLScQujIwW0gkP9Knq8qRTrutRhtnB9Y0+Ci
Dc2t0hiIBb2Qca9TRdbsTmfWiBt1zZs9+DrWyEyDrA2yWgia/fKgfuXQVN8oZI6Q
oA6a2Nrov3DJrlLO/Ox6UWL0NLewPXs9WcelsPZzzUXwmQqmjZak8gpm1i4Vm02q
4JWfqJ8OuBk9NC1zDflfF8d5rXFIs6VYP8BIcpkjHSkDtoIRFRw6EfD1ZZ8p6DNA
5KYeHThkkoovZv5hUhJcOHXK/OQKHoD+aRIJxXbmEg52uENy7a0HdSms9F5Ek46r
LAUATn4fHnl/Bc+el2AcFk2Z+Pz1EPiyfKIY/mllLb5yWuCkPlCpJ2IE+xF/tDcl
GmwKgrnY0BbtvPCDYWxZswNCSWr5NOGeKz49CT7dT0UL6N4EwJcNff43hlRwhNFT
jpOsd4uroNIMq5XdkEud3p2V9mNNbHWHBkvEl7YwZnVVE919HitJc3gJZZrKUGD/
74GIZIx2BiKRGJBxB1hc
=BC/O
-----END PGP SIGNATURE-----

--djTb5EnuS5qMpC9h--
