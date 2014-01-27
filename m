Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754310AbaA0UD3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 15:03:29 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:60268 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754290AbaA0UD0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 15:03:26 -0500
Date: Mon, 27 Jan 2014 20:03:22 +0000
From: Mark Brown <broonie@kernel.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-spi@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Message-ID: <20140127200322.GG11841@sirena.org.uk>
References: <1390553044-11860-1-git-send-email-geert@linux-m68k.org>
 <1390553044-11860-6-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Q5Q2TEEGbX9oWZOX"
Content-Disposition: inline
In-Reply-To: <1390553044-11860-6-git-send-email-geert@linux-m68k.org>
X-Cookie: O.K., fine.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 05/14] spi: rspi: Abstract transfer_one() for RSPI and
 QSPI
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Q5Q2TEEGbX9oWZOX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 24, 2014 at 09:43:55AM +0100, Geert Uytterhoeven wrote:
> From: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
>=20
> Split off qspi_transfer_one() (which doesn't support DMA yet) from
> rspi_transfer_one().
> Replace the abstraction of send_pio()/receive_pio() by the abstracrion of
> transfer_one().

Applied, thanks.

--Q5Q2TEEGbX9oWZOX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS5ruHAAoJELSic+t+oim9OVwP/RUKKneqqsdAxda0ogJbni5a
opa1q2B7GCxPwv3Ld3zz+BbPId9QykreCp+prg2acAPnKly8syHHV1wLvuTkwaB/
YWwPq0plHlleCefhMLmCmXFJzJvnnkbMUpSnqWOhPyF6I5NTs1u59R5kWKU6tXwh
4OZsEoWQTjeK4MiwSJKG9I5X4QZ4rlAlchd+bA8DD1YvImsk5eV6A3c5UEwEce2c
hs5c6lGeUCU7R4hOG234g45Z0kjgKKBKOPlpj8qoxVzQyrlff6HuendWVGCp05zZ
a3j38yuKI3QWpoPPiQobyj8ULxNjBjOn+tb9/i+sWYD9KqCE5ODLzYhTJ45VLJUP
YYMkqLVwIleI16NdMSUO7Uy23o7qRdZqfwuU2gLondJDoZw+xlEbnZy0hx88cePD
Tm2JWaPTmhjkaxmnSyoOJKFwbWldG9mGbfspcC1SktlEXTs4E8Z2W+OBsqeme1t5
IbhvNPYxstUGXhKfoSS5HBsAF2YJMTh4PP62VEiX5tgiS9O6EGmXX2PvaM0QyZJH
bh8+vyZhMsmyyaqEt9nGq5SsecP2padwzxPkgUNu/J75OQsJl34kskJD3S630OyV
iqUExS2wM2HETFscwzRqxpPBrFRg48jg4+NyT+sscSS570lxwv7mfISWR7Iypz/z
36wB+4uSGtw8gPjjSTsr
=8kJe
-----END PGP SIGNATURE-----

--Q5Q2TEEGbX9oWZOX--
