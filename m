Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754174AbaFITvG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 15:51:06 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:34343 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904AbaFITvE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 15:51:04 -0400
Date: Mon, 9 Jun 2014 20:50:49 +0100
From: Mark Brown <broonie@kernel.org>
To: Alexander Shiyan <shc_work@mail.ru>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lgirdwood@gmail.com>
Message-ID: <20140609195049.GI5099@sirena.org.uk>
References: <1402226789-25928-1-git-send-email-shc_work@mail.ru>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rbKG8BlqS9xyY7Uh"
Content-Disposition: inline
In-Reply-To: <1402226789-25928-1-git-send-email-shc_work@mail.ru>
X-Cookie: Ditat Deus.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/2] regulator: mc13xxx: Remove unused field "hi_bit"
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--rbKG8BlqS9xyY7Uh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Jun 08, 2014 at 03:26:28PM +0400, Alexander Shiyan wrote:
> Field "hi_bit" is not used anywhere in the driver.
> This patch removes this excess field.

Applied, thanks.

--rbKG8BlqS9xyY7Uh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTlhAWAAoJELSic+t+oim9ieYP/jmTf3dDk4GCtm4nNvzB6fjv
dbJWig3f+AZI2imzNoDURkUtft7udsAWUdmJ3srh5RqaI6Zv3ATratSuWe58SKGx
qATr8/4ytEiL5lTn7ADsEpgemCHMVH9Of3I7nF9xhCm83F5Z0riPKtBQEhVnjT6I
kpa1UR53S9WaMkTY+EXUa+zWdO3DZ/nV0N2ltVpX/5FwqPSVLJSBxIi0rddOYJhq
0t+ax05NJ5F4T3qN9SD0Hch5n6H81FWV+5hOqvCQnaJJomiVOxGzTWzuHq+u9Md1
qY5nuUFQB88lb/FII3UinI2M8p6t1cblc/qWjpxvfDNCwjAFfn+Tckgbbr36Pko8
s/+BETfzlX029PBXXkb0CMSYEzC53Ye1B130JyaOjKMfFzJ5/mv0/VgRPQmD+X3r
3wA5tke+bfkcR4qMClDT0p/P1dv0RsvPtloO30I2AzAX7KNxyEsCq42EaR8YUqQg
oMK1ZAM4QcXKtXZgalqprGrYNOf1KWYyq2/m/Z1XeV2M4Y28WJjZoPElcgHy/8Jc
/IbWqxn+9Uc/S+D3Q9YfOVKjC+NXbGc8E5jgnsEvmucJtHs4wAxPvp9FYXtgXNgk
v6G26vDflUuu2tNaI2thrzX+Ex5BFbfXvumFa8rRueVjTIfum5A1xn6Bab7xJfVE
9mAZCD/7xQMJuDQtKn7+
=kZp3
-----END PGP SIGNATURE-----

--rbKG8BlqS9xyY7Uh--
