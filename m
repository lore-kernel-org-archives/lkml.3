Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758841Ab3BGPzK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 10:55:10 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53655 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758166Ab3BGPzH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 10:55:07 -0500
Date: Thu, 7 Feb 2013 15:55:04 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/49] ARM: ux500: Update displays in vaux1 consumer list
Message-ID: <20130207155504.GX4720@opensource.wolfsonmicro.com>
References: <1360148051-7560-1-git-send-email-lee.jones@linaro.org>
 <1360148051-7560-10-git-send-email-lee.jones@linaro.org>
 <CACRpkda=HMwnip8EziZewMPmRb19gc9E1_vJHtAUJ+UjFJ6byQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3h0UNLyY10zL13pE"
Content-Disposition: inline
In-Reply-To: <CACRpkda=HMwnip8EziZewMPmRb19gc9E1_vJHtAUJ+UjFJ6byQ@mail.gmail.com>
X-Cookie: Your domestic life may be harmonious.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3h0UNLyY10zL13pE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 07, 2013 at 04:34:18PM +0100, Linus Walleij wrote:
> On Wed, Feb 6, 2013 at 11:53 AM, Lee Jones <lee.jones@linaro.org> wrote:

> > Add 3 more specific consumers pertaining to the displays found
> > on the u8500 and ST User Interface Boards (UIBs).

> > Signed-off-by: Lee Jones <lee.jones@linaro.org>

> This look correct,
> Acked-by: Linus Walleij <linus.walleij@linaro.org>

> Do you want me to merge the ux500 portions into the ux500
> maintenance tree?

Lee indicated that splitting them up from the regulator changes causes
bisection issues.

--3h0UNLyY10zL13pE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRE85OAAoJELSic+t+oim90wcP/iTgzxb9QF2L05l4ibmjm2fs
922bzj8EsalFGsGrUvM8kRQXv8nyIVnHxvuZcefYGn1xDEDGp1j/AnWClE+meWuQ
sy4EuQVXCHV6yZlCYXenNpzGQYH8nyqJv7n7BZ7iHu5uXxklDPzBG8R8qnEaxagC
SoDs8zFkN3nYzhAJRLafXHjYCRgiG0Or6cEjauR9rQQcxufyCJ2g13LJMHqXDfun
RVGGwsuRvbBdKAT8hTUtZGqBT/sVQwoiq4myulaqqMceW7Zxro6kXxoEqEeKZeYO
ahDj6vhyoStqVYRx/NnvucggPKbXDOfUj7pFjKiWmPkMfYv4N0/s8m47HOe6eB/K
QMytPQWhklt2fmEm94ltal9yXzk918dYew0ZMucYI6b7zZsB1DF9X8KOcgxV4wup
ptKhPnRl/wm+S0DVuhVD0+TykibTmSLQm35XYVoDK61hH2A4q9QmjIGWUIIyyTFI
Hr2EUkEOI5IFIkVM1x/K1c9yMr0I7biSPMm3vOYkpvUIYkaEOQk/5Dsyb7oF6VBc
zVYzzpA0TDOzZy6dbA5lSDES9bbslcdJhgxyhGQM6xoyVN/TaDvKk1p19ZXp7mm7
YpSCAX38Zbqli23LiGRtGuJ7DKxezHMZtrdl2qrWxzaDQl1Kxlf607Ja76NDE0al
KrUoDsAGDZXSK/TQGv0W
=NeO0
-----END PGP SIGNATURE-----

--3h0UNLyY10zL13pE--
