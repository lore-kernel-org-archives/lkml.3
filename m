Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756598AbbAZTL0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 14:11:26 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:35031 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753120AbbAZTLY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 14:11:24 -0500
Date: Mon, 26 Jan 2015 19:11:07 +0000
From: Mark Brown <broonie@kernel.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Milo Kim <milo.kim@ti.com>, Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <20150126191107.GC21293@sirena.org.uk>
References: <1422239113.8261.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="NJ3lxSTgSwfmyg6j"
Content-Disposition: inline
In-Reply-To: <1422239113.8261.1.camel@phoenix>
X-Cookie: My LESLIE GORE record is BROKEN ...
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: lp872x: Remove **regulators from struct lp872x
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--NJ3lxSTgSwfmyg6j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jan 26, 2015 at 10:25:13AM +0800, Axel Lin wrote:
> Current code is using devm_regulator_register(), so we don't need to store *rdev
> in struct lp872x for clean up.
> Also clean up lp872x_probe() a bit to remove unnecessary goto and num_regulators
> variable.

Applied, thanks.

--NJ3lxSTgSwfmyg6j
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJUxpFKAAoJECTWi3JdVIfQuTgH/AieWyUWPrR0XC0F53dKimrg
qMN6z3urB92gAhjvDEQuHXLJG7Xsy9oCvnd3GLlaIqBMy720yxelYDuvYhBGhvHp
xZ2VOnDbjfPsBl9jC+tBs0M+RkX454AUlt33jirwDoh2J6xDvK3JJcjfHlS01g3n
FjkcEqzsyJzqoDEpgmbcVUVQL9EtP4UZPrM3cRgNnjcOb6w36Z3F6f+pMg2j4laj
TCkw76hKJHxv3ZWPHBRZZkDXGPvY0c+zFUp4wGR19DH42FX30hstIteJy+EIZ6El
uq6iFl6vbD0tbqqcxFjsPqH3XN+nWJgEYBjWkTgQDOu4sUOaKYF1scS3mHFOP5c=
=O22y
-----END PGP SIGNATURE-----

--NJ3lxSTgSwfmyg6j--
