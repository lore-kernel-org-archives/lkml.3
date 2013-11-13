Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757991Ab3KMN01 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 08:26:27 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:41581 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756880Ab3KMN0Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 08:26:24 -0500
Date: Wed, 13 Nov 2013 13:26:15 +0000
From: Mark Brown <broonie@kernel.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Message-ID: <20131113132615.GI878@sirena.org.uk>
References: <1384325546.7101.2.camel@phoenix>
 <1384325714.7101.4.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DwoPkXS38qd3dnhB"
Content-Disposition: inline
In-Reply-To: <1384325714.7101.4.camel@phoenix>
X-Cookie: Long life is in store for you.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 149.254.183.27
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/2] regulator: lp3972: Convert to devm_regulator_register
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--DwoPkXS38qd3dnhB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Nov 13, 2013 at 02:55:14PM +0800, Axel Lin wrote:
> Both num_regulators and **rdev are no longer required after this conversion,
> thus remove them from struct lp3972.

Applied, thanks.

--DwoPkXS38qd3dnhB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSg330AAoJELSic+t+oim9tO0P/15SPhnbv4tz+p5zyrEPIGtK
G8Q+00C3AVuyWO5pvPcUAz3ZL3XDCeg8PFTEDf01iOUU0UvO3YPHV+18dDs1RVvH
ZmYlsYl4KP5WLqMN08ayUiLX0GWidgh2i84fwJAEcTchuAXIGge58KvKVzDP4vz0
ruh2KCrX+VhknmEo0i4jZyoG9mf9JnBbTOp1o0PXl40HaQZVgziv5EjnzuUE0saa
BXHBZtEmuHELMxXMyqze2o1GdfuSFVX8TCzzRT68U27x5WiZkBKQxJVEocAzCkMT
XcXwnfljvHqLWp2oi2+jh+Qi+ne02QuvySfrlCk479wqciJh0IvII7iSNEPgpzpW
uL7K+5HH4i2W4hcDSZCJpHI4I5Pv6DfdHvF5mCpwQEgIdoGhKnPUhVAc6FAZkpMq
kZG3Il2YplJPx3kgNB04ckkvi8PhpqiRbXwvvPlkgwQcKFtPk8iNEKUwEkZRReZ8
zBMw2TxwrDfsknOjdLSTJjG+c1GeHAtKhcE5WCpV33lXfCQjDBGojnOiMah8hCEp
DEDE266CHhdIkeV4el2ApvSY5IKoSHBvJI5CYLuZDs+oJ57z1pSnkrEX7j0rFPF9
mEBXcTd5nRZJiMOcKmZHoz7pKTj2nbQyjoIU2BYfiPKAiAs7rW7vNpmqHrWng5f2
Br1Nd+wsIuijjG+wHSAA
=tNwd
-----END PGP SIGNATURE-----

--DwoPkXS38qd3dnhB--
