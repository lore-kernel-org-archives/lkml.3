Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754088Ab3FGJJc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 05:09:32 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:48789 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753255Ab3FGJJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 05:09:29 -0400
Date: Fri, 7 Jun 2013 10:09:23 +0100
From: Mark Brown <broonie@kernel.org>
To: Paul Walmsley <pwalmsley@nvidia.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, Andrew Chew <achew@nvidia.com>,
        Matthew Longnecker <mlongnecker@nvidia.com>
Message-ID: <20130607090923.GH31367@sirena.org.uk>
References: <alpine.DEB.2.02.1306070753420.32163@utopia.booyaka.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+plSmdOTvOCX/8Oy"
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1306070753420.32163@utopia.booyaka.com>
X-Cookie: Are you a turtle?
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 82.42.102.178
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: core: add regulator_get_linear_step()
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+plSmdOTvOCX/8Oy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 07, 2013 at 08:06:56AM +0000, Paul Walmsley wrote:

> Applies on v3.10-rc4.  Will be used by the upcoming Tegra DFLL clocksourc=
e=20
> driver, which will build its own table of voltage-to-VSEL values by=20
> querying the regulator framework.

Can you show the code please?

--+plSmdOTvOCX/8Oy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRsaM6AAoJELSic+t+oim9s+EQAIo1T9CipQV4RuC0ONe6h/yh
erpT87tehwzWJLstitDRsh26EVt523IEv55yV/P8OE4Z2cG6lhzrNMTR+KfJQQtE
ahU6DjoxtCFlclJJ+5jnFFRzAQnsZopeK3WgAh0FReYde18VUUg9PL1A8iRIOwH8
nVoIkuSl6gH3IcFMZxwExSo2g/cZjcKBfP12RD4Ajko757suGmVWwJnlG3GXw7pr
2auSB8EFqn2q6YzHaZ8wGwMnPYSb4CKGAQ3Yn5V0rA5MmmzKLRwWZ/7IyP+IxHKz
urg0pCeXFHuN4qOiQrK2Ua8DPpAoEi2akgp/TN3sZOHX9cv4M1I0RBaLZldyYeZN
LP3lW57xAVyBUEDKMr9V95VkE3OcmD7wB7pVma2IfbOIGWAJUMXLDbC2BzHAkRC/
zhNRWkRguO6MTj/9lR2tnv+5rDBFYayFzXLZaMiusLR/xVO/2q9FBeUA1IBwqFry
tRK09sBQqVP9J4WVUYQQx9Nu8ygke/BivJuhqNbf657zMSNCzjgwzg1rRXvYr1VR
y1ujDUFEiq9KqzhhjyulVVE4OirWKT5MvNXKTS/nKeu5gvjBbg73CkVj5nQGLIgu
nExxyQp8SALyTgNqgn/QC287CYXuFuW2QC557D3Of7d9oEU+Zv9GzLrh6Y5x+DPy
NzAS6GSdnJlmqmdDGoP9
=D1qQ
-----END PGP SIGNATURE-----

--+plSmdOTvOCX/8Oy--
