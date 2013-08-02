Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754746Ab3HBKcA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 06:32:00 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:47101 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754081Ab3HBKb6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 06:31:58 -0400
Date: Fri, 2 Aug 2013 11:31:54 +0100
From: Mark Brown <broonie@kernel.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>
Message-ID: <20130802103154.GN9858@sirena.org.uk>
References: <1375394937-8785-1-git-send-email-swarren@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gmV4GtKPOP/GPF6K"
Content-Disposition: inline
In-Reply-To: <1375394937-8785-1-git-send-email-swarren@wwwdotorg.org>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] spi: fix SPI_BIT_MASK so it always fits into 32-bits
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gmV4GtKPOP/GPF6K
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 01, 2013 at 04:08:57PM -0600, Stephen Warren wrote:
> From: Stephen Warren <swarren@nvidia.com>
>=20
> On a 64-bit platform, ~0UL fills 64-bits, which causes SPI_BIT_MASK(32)
> not to fit into 32 bits. This causes a warning when the result is assigned
> to a 32-bit variable. Use ~0U instead to prevent this. This fixes:

Applied, thanks.

--gmV4GtKPOP/GPF6K
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR+4qXAAoJELSic+t+oim9464P/jfYhA0Y6chhTj+6tB9h8/Fh
5vLBdnz6g5AMb9/D/OeVXcsqQoJ4a1W+C+WMsMO9a93XuHw/7CiLryrNrBbm/R/J
Iy5Ul1jb9Ais6nG/gu7b1alyE/5wLZoKkgynFq9nJxKgLdbDJhE1+vNOpZf3j0Uq
uOtQ2POzIH12C2wYMD0dri9O030CRYH6geUyT0bOZj8ETALYHWSSoHslqPQj/iWr
Ph18Yc2PqXDuaM2nZeOPyqAx1+1JREEqxKVsoCxQ1sy4PiWyT1KtRPhQ9BMwfhoj
Val+xfWXiMIzj+6+9BREATaon/3fl5GvM4E5DNYTIGWtuN0/FdvK/Cdmv6rXoAtn
PqWUNvZq7GDmVeE3XFS7cB0ZCyJQZd4kef6mJtbszHYFdg1VsTjP2pMiSB0xYLx0
usFZ3v/CxUkkjCVBg5J7RwAeVeyYg52BqBk6kTR5SJsVaoKXr2kPI2uK7DwNwNao
6aKkfNd3T25Q2nxkxNpu1VKrI7auwjmIy2xCqyIvm8mv6UMNAoGHhtuVkWwRVVq5
UyoaMBUbCOTgfVud3hLlX2cmb6hBUZlCmOwFFPgpFLFodcv9TFguYCZDHgs+n3Gz
OC4uCioUu2/OJdWQYrbiqRDRh41yfca8kZXRAdpaQftqs4lPqrqBZkGOOpjApx5k
Y+BcSkJmkq6w5AXd8zd/
=XDw4
-----END PGP SIGNATURE-----

--gmV4GtKPOP/GPF6K--
