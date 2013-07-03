Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932575Ab3GCRwF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 13:52:05 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:45955 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753057Ab3GCRwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 13:52:04 -0400
Date: Wed, 3 Jul 2013 18:51:57 +0100
From: Mark Brown <broonie@kernel.org>
To: Yadwinder Singh Brar <yadi.brar@samsung.com>
Cc: linux-kernel@vger.kernel.org, yadi.brar01@gmail.com, sbkim73@samsung.com,
        lgirdwood@gmail.com, sameo@linux.intel.com, rob.herring@calxeda.com,
        grant.likely@linaro.org
Message-ID: <20130703175157.GV27646@sirena.org.uk>
References: <1372072858-6559-1-git-send-email-yadi.brar@samsung.com>
 <1372072858-6559-2-git-send-email-yadi.brar@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8DDUPozX52++RchQ"
Content-Disposition: inline
In-Reply-To: <1372072858-6559-2-git-send-email-yadi.brar@samsung.com>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/4] regulator: s2mps11: Convert ramp rate to uV/us and
 set default ramp rate
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--8DDUPozX52++RchQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 24, 2013 at 04:50:55PM +0530, Yadwinder Singh Brar wrote:
> This patch makes driver to use uV/us as units of ramp_delay. It makes driver
> in compliance with regulator framework and make ramp rate precise.

Applied, thanks.

--8DDUPozX52++RchQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR1GS6AAoJELSic+t+oim9mT0P/RF4NMQD9zzgoK1w7PHbonNA
cZOx5O1ND/WGqubumYVvlXws0gBMGFj3aCMoNGamiGRthg1lcvaXIPrInzw8jYEH
L54evOok1slUgv1GCGNpMa9m5j+6keLw12NemUTgx+LXh0C4nz5VUzbC1fCBK3iR
1MT/ZTvH/YHT7vhxVWiuppuS/+as3llUqaxbOKDhbTxCO8u2N+RhoYyUdSsizTjQ
oSmhpwqqVNJzOMn8sWZOsiB6D7rh99SvhG3KPrQ6QNBw/sS2xb+FqBSTpULXgyWZ
bk9ZjWBGrnfFByxJYc4HJV6QeElmX7F9yjF+Wpd6U+0InK3+yzMWQBFYFj8tuw8S
7ENvR29nQdBSmdkQEw5RaNJVGRMn0a1hZigJgH+zaiHcrQF370YA8wSYJ5zbI3dc
fai62jnNb7a47VjNM2nk8ti6q111A5aSpDUD5fTC+0umJHZ+DNWsIwUWrYpn8gME
k1avK8wwsRCXeW4eNyGFBjg1B8kMsP7i5xQUC7oUIaZtbE+E6pKq1B2dgnNppPWX
PkCJ4iGU3g1k/R1CpeBALJNFKeEFckdF1PSveZYnShG0H1Ufzepx3yg4JpbKXFYJ
1nnNzkySMzaAy7J2FmZkQ/P2w8kzkrLd/EeUbehTYhFGDH/UvHikudQXjkJYLxJQ
qUN4ksY6yEd3H51KA8bO
=lQgO
-----END PGP SIGNATURE-----

--8DDUPozX52++RchQ--
