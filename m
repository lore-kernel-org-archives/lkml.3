Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754165AbaA0Sh4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 13:37:56 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:60105 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753815AbaA0Shz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 13:37:55 -0500
Date: Mon, 27 Jan 2014 18:37:49 +0000
From: Mark Brown <broonie@kernel.org>
To: Fabio Estevam <festevam@gmail.com>
Cc: linux-kernel@vger.kernel.org, Fabio Estevam <fabio.estevam@freescale.com>
Message-ID: <20140127183749.GF11841@sirena.org.uk>
References: <1390585698-31661-1-git-send-email-festevam@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vKFfOv5t3oGVpiF+"
Content-Disposition: inline
In-Reply-To: <1390585698-31661-1-git-send-email-festevam@gmail.com>
X-Cookie: O.K., fine.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: gpio-regulator: Remove unneeded OOM error
 message
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--vKFfOv5t3oGVpiF+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 24, 2014 at 03:48:18PM -0200, Fabio Estevam wrote:
> From: Fabio Estevam <fabio.estevam@freescale.com>
>=20
> There is no need to print an OOM message after devm_kzalloc, since there =
is
> a generic OOM message in place.

Applied, thanks.

--vKFfOv5t3oGVpiF+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS5qd6AAoJELSic+t+oim9K3cP+gOW4xjfUREV91E/fpyodEp/
dzgPofOC/8PLEABGmp+sSlOUZOuW+XuxJ33E+1s9lurvLpFeW6f4g4qk2UbUA9xI
JJ37AiW2CNyzMzfvHbUqzPa1n6UuzPdb+NBwiJKcl4v2+pRjuz3pWpfxm7uzy03F
JxTDoNdEx2LFOei2CntR2tABJwIt3cYb+qFuE0eeLvhp6NKNlwklmOGF0/toPBir
PaXWuT0Oe/6BNzjSjZuh8/YiaWwgTSfforQZNVFIu1Hre36fcp3Rk8E6zOqOeJDQ
FoLQ0U3SQ54R72V+fUI1E7nuqEEQf5HM8PJhGYimCxx6nlisov/hfQ7jmZa0ZZ8l
S89TII1ouoHWujHHUzPLjLCKj33yWUO14W9f/0zmh8oQpIJ9UNSv6oFuh+IbPSfh
OBLXgeFoRwbdVQySzkrkFwDmr86UNuoz8ip5Z9uIJbXjBSjWjpmgSAdqArtEKy7C
NIgy5FcTJBypdavQBWvy+ge2o4hN8ahRunFG5MVz67itYPsSPiXZX1ig/nFhh1p9
0eKy4uzw2EIUtTXDX50ix6nvBbwwvLjLUWjVV9hpHiNx8TKo8xKKOKtYkct1zsqC
FO5J8cMHf1i11lfraSBb2MZhOR0y0tyys/4fNeSDGMQQfDrd1oa79cWZimVA2IPQ
71K80iGxdsvrRFziZN32
=lApL
-----END PGP SIGNATURE-----

--vKFfOv5t3oGVpiF+--
