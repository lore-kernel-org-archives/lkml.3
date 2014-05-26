Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752739AbaEZPrL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 11:47:11 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:43384 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751599AbaEZPrJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 11:47:09 -0400
Date: Mon, 26 May 2014 16:46:53 +0100
From: Mark Brown <broonie@kernel.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        Robert Baldyga <r.baldyga@samsung.com>
Message-ID: <20140526154653.GB22111@sirena.org.uk>
References: <1400655168-19739-1-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Q3LtICoXRyWKz3HA"
Content-Disposition: inline
In-Reply-To: <1400655168-19739-1-git-send-email-k.kozlowski@samsung.com>
X-Cookie: You are standing on my toes.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 92.40.248.185
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v3 RESEND 1/2] mfd: max77693: remove unnecessary wrapper
 functions
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Q3LtICoXRyWKz3HA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 21, 2014 at 08:52:47AM +0200, Krzysztof Kozlowski wrote:
> From: Robert Baldyga <r.baldyga@samsung.com>
>=20
> This patch removes wrapper functions used to access regmap, and
> make driver using regmap_*() functions instead.

Acked-by: Mark Brown <broonie@linaro.org>

--Q3LtICoXRyWKz3HA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTg2HqAAoJELSic+t+oim9fisQAJmb+kQfQ8jftPSmbvBAGDi6
NeE12jYDpmoYP/Uk0sWAoSOYf2jraqgN3vp081rSWG1RQEaifxBvhaewd5LwEz93
8R7zbh2hqZs8+ymZJHvouOoSkHgzeaHadTjQEcO3XB6J5OISsPYj1KN62B27jIWT
GJnDU21olktwnpe9YvEc10eyoyszMz6/oHjfwxgi53Nmc/pQFtDDw8dlPpvF3zCa
QlD8rSyAhJR1WSpYwVHOx5IzLg2RIMvYdKuyRO/ja6zmDvRjUnPVGyJ1try5qUsi
rCbHLmRu7SrKaICVUM1a0DL7BRadMVOeK3yUuspYn32pI1ld6ezUwdY5j/KXYD1c
trA+QE5KT9qi6PPy704uwWD/J1atcOkjYS03qwzawhIi96ju3Ud5mwtNyhgVga5F
PfPLApGyoWio2Eaorc7bS2X3xQcIAbQwADKpJ9TqhFQCqdY3EdxaxjIc+MhcwBgU
30KhTlECMn8/mev55oU0KsBKKehh+FLfktVrj+yLZnYzOSZPfqLx/MPLlP1u6g6n
R8ORAK65wYoqqYPl/hsrzx1358w3e5w5D2TiKR32YPKn949bdk8blALtkPusMlzG
9BimkP4pzw3NGKzIy7kFjKqJyKqhhbt/kJfr48j0icfqtn12duqPDrEcSY79niJY
pGhNzmxTLLOLcpS6qXet
=OUhf
-----END PGP SIGNATURE-----

--Q3LtICoXRyWKz3HA--
