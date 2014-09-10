Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751478AbaIJLqr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 07:46:47 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:60895 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860AbaIJLqq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 07:46:46 -0400
Date: Wed, 10 Sep 2014 12:46:32 +0100
From: Mark Brown <broonie@kernel.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <20140910114632.GE7960@sirena.org.uk>
References: <1410309876.18009.0.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tVmo9FyGdCe4F4YN"
Content-Disposition: inline
In-Reply-To: <1410309876.18009.0.camel@phoenix>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 81.132.226.177
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: isl9305: REGULATOR_ISL9305 needs to select
 REGMAP_I2C
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--tVmo9FyGdCe4F4YN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Sep 10, 2014 at 08:44:36AM +0800, Axel Lin wrote:
> Fix ERROR: "devm_regmap_init_i2c" [drivers/regulator/isl9305.ko] undefined!

Applied, thanks.

--tVmo9FyGdCe4F4YN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUEDoXAAoJECTWi3JdVIfQ30kH/i3OeJYP1fWkV1q/JVGYqv6X
Gp7CIl1xl09CqH6tNp1AxDtd+scIpbur5D2ZG+mKWAWxmhAOf8cyP26xE8v8Bont
Ap0RQi7UTobAs4i509ZemhttY70CRvT+YU2tIIza4JPowgBCXDM5BxiFjKmMZL2B
cu8XyuNyzDoP0Js3YZ0sKEWNGRQ8d0rc/zDkzx0wzRjYxSr6grg/NqXriz2noAQr
Sm55c+6vnKzaXL6h2C3LjGU6UoqgSaSYbUh2lR9Bx+fvgGPv4p+N6GB3Q0c3Ezcg
YPboSrJ1LzWuZeu+KZU/E4kiFUmaUHIjZ8/3Altu8NgOChVMadjk4luTBu6RVxc=
=WZGJ
-----END PGP SIGNATURE-----

--tVmo9FyGdCe4F4YN--
