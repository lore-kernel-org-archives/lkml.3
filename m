Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932773Ab3BSMli (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 07:41:38 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60558 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932712Ab3BSMlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 07:41:37 -0500
Date: Tue, 19 Feb 2013 12:41:33 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: J Keerthy <j-keerthy@ti.com>
Cc: lgirdwood@gmail.com, linux-kernel@vger.kernel.org, gg@slimlogic.co.uk
Subject: Re: [PATCH 4/4] regulator: palmas: Change the DT node property names
 to follow the convention
Message-ID: <20130219124133.GC23508@opensource.wolfsonmicro.com>
References: <1361164460-3251-1-git-send-email-j-keerthy@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="H8ygTp4AXg6deix2"
Content-Disposition: inline
In-Reply-To: <1361164460-3251-1-git-send-email-j-keerthy@ti.com>
X-Cookie: Reply hazy, ask again later.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--H8ygTp4AXg6deix2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 18, 2013 at 10:44:20AM +0530, J Keerthy wrote:
> DT node properties should not have "_". Replacing them by "-".
>=20
> Signed-off-by: J Keerthy <j-keerthy@ti.com>

This must need an update to the binding document too, and probably any
DT files that ended up getting merged for it?

--H8ygTp4AXg6deix2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRI3LNAAoJELSic+t+oim9i5gQAIfI0oZPEQz7dOgbQ2qkzTHs
1d9nKiIbE6adFgfzuwFdoaqGivc7TT+BwN4rLKwYBjw3UyUfAsOckf4NMSWm7eqd
iebpM4KEBAL3yQpAB1dDkUKrIUnBioFa5aCPQCAh+zh1Wtv7ztC0zIqfZRyjpsmb
cEOJYMfKd4OlD2EQ25KL4VCzarkM9hDjwtSnWxHcFYj2xrQJY19pPUPDrnmn9IGq
wMjAFeW6RCcLHcv7XwThp41PcI+KyWIGf1NM2yAJdUbOyk8zfAjrExdzJEo4T3Bp
V+NsDrEtx4DNWyEPkWEXQ8bEapNnLAGaUDGJFSo3B4BEg99/DNXbcJRR3bEaL367
y4zi6n1MZHaoxk5PdRaeAmjJej7a20IUzIqgwSFtiFDlLdZLHy0IrQ9KZKT789kI
qt18KEnO5mY+wLSISFS1RYvAxdsgefyVUT9GmlJfJn55JTz1SjefmqUoZmyP3sDf
Zh8TtEkyq5/U5e2JXQXlwVmRvvpJK5QgrofACJp/8FtonqpCkw9pA5MLcGfyNW52
3fyQJazhPAk406JYcVuh0fpa3+FRGtho7yth7V5RRBqPH+80kIOtbbeOy2mjP9nK
gDZxZMyGsSgWQ7JAd95un8aO8QAmUr9/jgFF3a3Rga/FoWvQetEPY74jxZIDCHqC
RikFZaZVRL0VX4hI3gzJ
=uv4H
-----END PGP SIGNATURE-----

--H8ygTp4AXg6deix2--
