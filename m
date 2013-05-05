Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751956Ab3EEKXg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 May 2013 06:23:36 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:38529 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751800Ab3EEKXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 May 2013 06:23:34 -0400
Date: Sun, 5 May 2013 11:23:07 +0100
From: Mark Brown <broonie@kernel.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: "Andrii.Tseglytskyi" <andrii.tseglytskyi@ti.com>,
        Nishanth Menon <nm@ti.com>, Liam Girdwood <lrg@ti.com>,
        linux-kernel@vger.kernel.org
Message-ID: <20130505102307.GV4945@sirena.org.uk>
References: <1367676147.5124.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Lez9QO3Seu3ycz0M"
Content-Disposition: inline
In-Reply-To: <1367676147.5124.1.camel@phoenix>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 82.42.102.178
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: ti-abb: Fix off-by-one valid range checking
 for abb->current_info_idx
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Lez9QO3Seu3ycz0M
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, May 04, 2013 at 10:02:27PM +0800, Axel Lin wrote:
> abb->current_info_idx is used as array subscript to access volt_table,
> thus the valid value range should be 0 ... desc->n_voltages - 1.

Applied, thanks.

--Lez9QO3Seu3ycz0M
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRhjMHAAoJELSic+t+oim9PsUQAJgTrFCw68kAezZEf6+kAYxI
4Ds5RVSsPDQufm292aEfOStMf/dMa1kOVnccaW56QKT9lllqmjnlZakfRGAV69+a
iLKDizsLevTdZp2OFMS1evXzp7NvDU82MTIp3pQAjkzir0tqvXVFgwRN4sADvA/b
bggSRhqGsAHBA79DuIE9l4VxHQGUCCqexQfFJwcmxf6ZDVpQIqWbhgWrZTNugtgH
SQwtedtCWVKo62lA5UmpIna9DeunOAFz0GUFNG+R9NQrkapo2rzOtRMrniQVT4Ax
0cvk0lqvKJBuNqokCXcrvDg/CyrvxcS45pMNb5bR4USIgXJKsJ+DvQdXYcoYjnJw
oQ22M5/iWQFoM7i9Qpyea0u56S7XCISMc1t/JknjRMWb4hMRezswRhiy32E//4Lu
n3/eNLUb72C8t/ekTCNNoVStWrFbsINhG6vOjeyIl/aKw39FobwFGpuIWpMaLIqe
6mPkKvZhqxR0r94Gn1is5Sdt3Xx0k+w+EYA1k03yWy+D7yejd34swEFj4+0a/tvz
I127GKU4YNUWKnoL53EH0ICY1X3wism1dtRIanyWkjdvAU+s2sacg2D93FrqBd/f
smnBFyRgfzTb78lUAUzIczhvZIEEhqE3lpGdjIc7kPDbgdxVSEjG8jQWCYXcw2f7
6sYjS58V8EK0Opz4iGeq
=H2m4
-----END PGP SIGNATURE-----

--Lez9QO3Seu3ycz0M--
