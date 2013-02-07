Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161137Ab3BGStd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 13:49:33 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58190 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161066Ab3BGStc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 13:49:32 -0500
Date: Thu, 7 Feb 2013 18:49:06 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org, linus.walleij@linaro.org,
        Bengt Jonsson <bengt.g.jonsson@stericsson.com>
Subject: Re: [PATCH 04/49] regulator: ab8500: Added get_optimum_mode on
 regulators with idle mode
Message-ID: <20130207184906.GC8879@opensource.wolfsonmicro.com>
References: <1360148051-7560-1-git-send-email-lee.jones@linaro.org>
 <1360148051-7560-5-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CblX+4bnyfN0pR09"
Content-Disposition: inline
In-Reply-To: <1360148051-7560-5-git-send-email-lee.jones@linaro.org>
X-Cookie: Stay away from flying saucers today.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--CblX+4bnyfN0pR09
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 06, 2013 at 10:53:26AM +0000, Lee Jones wrote:
> From: Bengt Jonsson <bengt.g.jonsson@stericsson.com>
>=20
> With this change, Vtvout, Vintcore12, Vaux1, 2 and 3 regulators
> support DRMS (Dynamic Regulator Mode Switching) which will
> dynamically handle requests for max current consumption from
> several consumers and select a suitable regulator mode.

Applied, thanks.

--CblX+4bnyfN0pR09
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRE/ccAAoJELSic+t+oim9GrMP/1TWJWZcCfP0r6evmvI2Ydbf
+EG0oki2pTlEJQbJo6q0r4kj6kBx3gs16GyZJkl+f/DhlkA9ngrE6GPSoV7U2TQY
S9YNpqnHBxIE7mqAWCr8o+FFlMgv6Vg/30e7CdgPreVSF+V8cmjJwY8KI7Zd366s
Wd5cxzzFl6RkwxGfW8y9gKJ2TMc8kSjeaYG0kdD4q2aVQuv4bC7FW0vLZpCv4gZg
IA7zVy6EJl9x31NYnYsBGfVmHlubKTFGTcqf8tw9k45ClWgDB1WibtmHT2AFpBO6
N3HBM8TMMLZ3nRRUCsAHx5CGoq5n5n5W1jSNBxKxE3vzzlVQCH1h7osF0G22KdTn
k6E2c0z0JvT9PuUbYvXGTzqFAFy3evJQ9w9KgJ3NITo2Y8ofcR7TGQz7CpFaq3AR
u54VUkST8zqUHKOm9Ie4BMcVzy26Wv8+1PymXUvvO/HaouMV+7tGLR+kpxobPiid
aznPrQxfIVB3PvA3ibVN+3nZiPx4SPh1e+kOfmXJaKXE3pgRar3zlfanZLGCkTmT
vg8rES6NRqGCf9i+13c7hm/kvxADoxUuFar3cFh/xRlCLjCTU9rkAYEXtH3OhDwC
EoZ/p8pAKy+hGuGz62NNkDyGXY0wIIIS+GmqLPDDDV5E1GLSCtQdEFEIZksQgGr4
7PMFgovSscokylnt7eti
=Cwjd
-----END PGP SIGNATURE-----

--CblX+4bnyfN0pR09--
