Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754902Ab3FGKSu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 06:18:50 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:43495 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752796Ab3FGKSs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 06:18:48 -0400
Date: Fri, 7 Jun 2013 11:18:45 +0100
From: Mark Brown <broonie@kernel.org>
To: Paul Walmsley <pwalmsley@nvidia.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, Andrew Chew <achew@nvidia.com>,
        Matthew Longnecker <mlongnecker@nvidia.com>
Message-ID: <20130607101845.GM31367@sirena.org.uk>
References: <alpine.DEB.2.02.1306070753420.32163@utopia.booyaka.com>
 <20130607090923.GH31367@sirena.org.uk>
 <alpine.DEB.2.02.1306070920010.32163@utopia.booyaka.com>
 <20130607095936.GK31367@sirena.org.uk>
 <alpine.DEB.2.02.1306071000330.32163@utopia.booyaka.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="luEVMvTx1SoZptjd"
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1306071000330.32163@utopia.booyaka.com>
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


--luEVMvTx1SoZptjd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 07, 2013 at 10:03:22AM +0000, Paul Walmsley wrote:

> The IP block has an I2C controller embedded in it that autonomously sends=
=20
> set-voltage commands (across a range of voltages) to the PMIC.  To enable=
=20
> that, the driver must first initialize the IP block with a=20
> voltage-to-selector table.

Ah, right - a one of those!  OK, makes sense, I'll apply.

--luEVMvTx1SoZptjd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRsbOCAAoJELSic+t+oim9jeUP/2Ha1w4ZvNtVZBVuZrlf2lmT
YooYnBLJVc1FIh8KQCdV39KMV5pGqLB2wt189cI5sojUU72R0ewHeNi/6cTeYFii
vm65aN4lEMa+PZmTwpME/dvKTyFXa2EXEC8ylCTCJT0xVSaoI7T6XZ9XkhHC8wm3
NXKpNbKVnsBL52atAaxImM9LIbp3BJfjPLsegKlQ9XFdPvcC4oG+luUZbz+CWzgy
GF86e+5c5MYhxsnxwsYxyKHz2XJWF/0+EDxWyTH9jcYBXdy/eJMVPKKqNzwN4T1x
wXDHZQJIvn/kPJsWJVOjPfQ/WxGzygg5ZihuBF7a4pD3CtExKF3EO/38XD++xHEm
RSuptHUK6FVZq3lWGP8I6RCpYShxuUmjTPJloepMxU+7F270glvnhz2FlfSCS6BR
Vjn8f5wBc/8qV/fKn0Qg9tSnxywLCncZkWCVAH5AuGVmdE94Kr58pUaZ7eeZ/to3
unojWOlOneImF6DdbUlLYbjDzAFqaDoHjY/zZJ3P0koHsMoYGWOSSlVZGs511fri
dta+WX7JCCE64kWSByHJQzcgmmMMz9Xz9W+JpPUmUWXK4DrQeU+We+wZyTJeo9+n
NeclnJfLfYtIk821VTR/dzTpLms9lGruBAraPFu1862d30Q/YCZ54F4psTgyyxpP
XkJ2vaZfwIz2bfTNIu+3
=f+6y
-----END PGP SIGNATURE-----

--luEVMvTx1SoZptjd--
