Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751226AbaDOJ3g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 05:29:36 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:33626 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750909AbaDOJ3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 05:29:34 -0400
Date: Tue, 15 Apr 2014 10:29:11 +0100
From: Mark Brown <broonie@kernel.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Balaji T K <balajitk@ti.com>,
        Florian Vaussard <florian.vaussard@epfl.ch>, Stefan Roese <sr@denx.de>,
        linux-kernel@vger.kernel.org
Message-ID: <20140415092911.GK12304@sirena.org.uk>
References: <1397534528.23871.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Tv3+oRj6D9L8lW+H"
Content-Disposition: inline
In-Reply-To: <1397534528.23871.1.camel@phoenix>
X-Cookie: You will be successful in your work.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: pbias: Convert to use
 regulator_[enable|is_enabled]_regmap
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Tv3+oRj6D9L8lW+H
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Apr 15, 2014 at 12:02:08PM +0800, Axel Lin wrote:
> Since commit ca5d1b3524b4d
> "regulator: helpers: Modify helpers enabling multi-bit control",
> we can set enable_val setting for device that use multiple bits for control
> when using regmap enable/disable/bypass ops.

Applied, thanks.

--Tv3+oRj6D9L8lW+H
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTTPvjAAoJELSic+t+oim95ykP+wfcGi1BSk/EOdQvsWnTfhWe
Eau0DjseISzE2TCQK1f2jutJvyP3XXRUri748Lt2bWbms/pTopgaUk9r1Z397l0V
RN5fSldehNpVMJzh/vuQ4Eu9TWWHMyn+KqhMHUgKteTVVKo/bjN+s8BZEqmlqJ6B
MMFRLv5ZUaZe3CBOSAvS7H1yxmWGRan/eEFvIcdG/uRGyPeZSiV9PyNTdKqG7efo
gAtnbJa8Bd36biO8wIX1A84huK3+OFyOpV4ki6WcXfonlNfxRoLya6Q06AsOCNus
4l5ObxORFIcS6/SXYvVqntNMyio4osJMfLJq+a0BfHDuLYs4mSzlkmxNneppUmWG
wHkykBMdOXGYqHIJ148u04XtYSqeo8Wgi1IMO2tIYKzE3Alj87Ub2YuLOviJU7rL
JQTTHaUeWYIbGIzgNtQLKvSenGzaLpFSmtL6qUCI9eGKim1GTUIC+UhvPQeYyVwb
x5W23tbibr2YptZAFIgUzq/heFt+zxJCa9Xwe01vm1/GQLsAwhdUykFkUZbXugj4
CKj53fBS2eSHscm7l1gKahkQJRZWcFCl/Fusi4XxjbEqJBf14Qo4xaYZCZyB2ohQ
B+PHBJhbawHFXL31LjYV2x8Bn/mLrZsXnQZ5ifg5zbTNNMd19Gq7NIKP1Op5jZNj
j4tHGMLbjTjeUKElPCkk
=0sJp
-----END PGP SIGNATURE-----

--Tv3+oRj6D9L8lW+H--
