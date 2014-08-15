Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751168AbaHOLmJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 07:42:09 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:36623 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750751AbaHOLmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 07:42:07 -0400
Date: Fri, 15 Aug 2014 12:41:47 +0100
From: Mark Brown <broonie@kernel.org>
To: Peter Griffin <peter.griffin@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        lgirdwood@gmail.com, ldewangan@nvidia.com, patches@linaro.org,
        lee.jones@linaro.org
Message-ID: <20140815114147.GK17528@sirena.org.uk>
References: <1408100984-11757-1-git-send-email-peter.griffin@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eB8m8Syz/ebyX72V"
Content-Disposition: inline
In-Reply-To: <1408100984-11757-1-git-send-email-peter.griffin@linaro.org>
X-Cookie: 98% lean.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: as3722: .name field initialized twice
 differently
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--eB8m8Syz/ebyX72V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 15, 2014 at 12:09:44PM +0100, Peter Griffin wrote:
> Regulator AS3722_REGULATOR_ID_LDO3 and AS3722_REGULATOR_ID_LDO4
> have there .name field initialised twice with different values.
>=20
> Looking at the code the second entry should have been .sname
> which is what this patch corrects.

This change appears to already be present in current code - please
submit against current code, or Linus' tree for bug fixes.

--eB8m8Syz/ebyX72V
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT7fH4AAoJELSic+t+oim9FbEP/3afdpg6MC0BT3p0GWWJBcI+
lsRWgN97L0b2zVDUxiUZGxHVC0Ke9HfkBxcuYTKII9K6i8vTMuk/4Ksbg6yqs7EW
ApyINS9nebmJJaFFm9N2y9Xcqn3jgrfhzgdVL9WAaiOrwSKIDA8wgqx/UYCwxrkc
ZvRz1etqx1KyLgOT0mYw1qBnYrYz3EzfasCWvSJuJifLB/t8ukzMv1v9vQZIWb+h
vevS2Qjt4madJXKfgneuwFngW/FonLHbzn9gUP4rGPjYasD1xhIeFHsCxYL1oMuX
lbm3CFfm+VfGAjeL9CwM+e9zWbYjh5XBc+spA8VJVLZQCoDoFQZScVOZ4udXPHJ3
7ARNwnl6JyCU9FG3VnmNJC+KLl7KPt4HEgx51IiaRd1mOJ9rlHqOeqwrFqXlZEXY
v9kn2XcMZY5arD48EuPGdFD/HNQWT+e7c+q5IugjTV8Arvkuok6Fsxp6Erm9vRI6
yMr97WHcaEaFiP8CuZukhnpy+qxbQ/E4HayHAPmUeSWAG5DHFmwMOw22kpz4hQ3V
fbiL5wVT5a1imgY9w+6L59197vDG30eXTr06I/XF240av17TDCcD1uLa5MWR94Fv
8CvzSLpz2WGa/mBTtCAtqHeN9HtZ+a+v1a0TFAMAF68GGFv73rwcgBdn25/wnsBh
1zXS7F3ComYsrtY/Lgqu
=5gp8
-----END PGP SIGNATURE-----

--eB8m8Syz/ebyX72V--
