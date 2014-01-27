Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754320AbaA0UIh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 15:08:37 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:60289 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754213AbaA0UIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 15:08:36 -0500
Date: Mon, 27 Jan 2014 20:08:31 +0000
From: Mark Brown <broonie@kernel.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-spi@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Message-ID: <20140127200831.GN11841@sirena.org.uk>
References: <1390553044-11860-1-git-send-email-geert@linux-m68k.org>
 <1390553044-11860-13-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="aglTZS2R0flMmvQN"
Content-Disposition: inline
In-Reply-To: <1390553044-11860-13-git-send-email-geert@linux-m68k.org>
X-Cookie: O.K., fine.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 12/14] spi: rspi: Use NULL as the clock ID
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--aglTZS2R0flMmvQN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 24, 2014 at 09:44:02AM +0100, Geert Uytterhoeven wrote:
> From: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
>=20
> There's only one RSPI/QSPI clock, so we can use NULL as the clock ID

Applied, thanks.

--aglTZS2R0flMmvQN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS5ry8AAoJELSic+t+oim9+/EQAJzqq6Q3+qAC0xWTGL8W8vm3
sXQG1XPX2SiaKI4Wj9aVo/NFMmf59ASkMm2SqU7Ns+z6ZXeAqi1CrAr0wE9/iAn0
7UhV9g3x6uhryBSSKXkAf905+C6S7KNS9lIsKUhFfs0zO+OWL4iXpHJlQh0K/DK2
68bZ51eBRD9oMd29ddJTjQ4j96KJz2cZU70HWovISbnz1z0CaPQpGfKrUwuZvfOY
XXAE6jHW9sWa5/D8083xf2gazYevogRggrGh8HkT8kLWd3QgzmzIMCz8+yj/ZF3j
hJ+dNIz7CkbTKcbIGe8pnHIGVy0S8EJQ1jVv1tNdpqHQgVsdMHSd8vwLkuAxIE9W
NiY41nzaPHN1l9uaVlAEIatgBw+pP5gSJLSkwjqcY+r/w4Q4bZr+ufpnVBqjab/l
b+YDE9TvxD688oTIt6VOmgP8FuIHwsV/7uGT4gorGMzxvvm7xcdoNhc4kk92xl/U
5VxBUgSz/Fy5D9kmcNdTm0wbjDxZTwr7kBS6fZCq7Nu02ccVaUwNWJJ15sp80nWX
D4h31T6nRSel8Ux2f3vR1yPX3RWWCh1ECmGqzyg1W5qZ1rqBAC6NhNknA01yDIYK
6ElWrQfxh9m76EdWhqDxe2wddVjPQ5rpsswqA5mdIYTvmInQ01+33M1clZrE9rdZ
Q9R81XxEz6EKHSMZpT/e
=POqp
-----END PGP SIGNATURE-----

--aglTZS2R0flMmvQN--
