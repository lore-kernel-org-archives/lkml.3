Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756922Ab3FUJyZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 05:54:25 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:37727 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500Ab3FUJyY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 05:54:24 -0400
Date: Fri, 21 Jun 2013 10:54:00 +0100
From: Mark Brown <broonie@kernel.org>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Jerome Blin <jerome.blin@intel.com>,
        Eric Miao <eric.y.miao@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Grant Likely <grant.likely@linaro.org>
Message-ID: <20130621095400.GM27646@sirena.org.uk>
References: <1371739462-21139-1-git-send-email-mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sMkrXc3gAYLRVOjR"
Content-Disposition: inline
In-Reply-To: <1371739462-21139-1-git-send-email-mika.westerberg@linux.intel.com>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] spi/pxa2xx: fix memory corruption due to wrong size used
 in devm_kzalloc()
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--sMkrXc3gAYLRVOjR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jun 20, 2013 at 05:44:22PM +0300, Mika Westerberg wrote:
> ACPI part of the driver accidentally used sizeof(*ssp) instead of the
> correct sizeof(*pdata). This leads to nasty memory corruptions like the one
> below:

Applied, thanks.

--sMkrXc3gAYLRVOjR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRxCK0AAoJELSic+t+oim90XwP/2aCGo3HlXkoOH/s9zCyb8Fy
/rWs0OigWEU+YuuZ3LEJ4NNMLVvB/MjGJb1A/4OSycwkxDfDvRw8RwUzyLgX6fp5
KWm5Oe/uQ613ZTnKb0eIOYXMxqyM659+lS4e/Khl80zg82jkdfy2jfZ7Q4LZ6BOw
61H7V3lJ4CLVIOyn2UgwHNPsszohn2jb2YJlmyFNK759f95Gx+F5fyQv28cKTQdh
F7+3htSK0HdE+V1n28C3pgcs1NaEx4qv5J0/E30Wr4TAtUOEqjsmOlSx5fDUR8WV
SvJvU6lOD+F+j+qldamDVr7mDNKEtI59g0EvbXUa8egem7qLlgiyR7HfYEcdkrI7
vM3UoUkvi54WaoRLSnldGs+ndzJvj+U/+TqtHdtGV+mCrrIOmW1RBfizDmuPdcQP
nIJQgGVXjAerXZrwMT1SH0i+IAKRrRWzHG7q9janVDx/Y2/MqCx6UdVjx5NOl6e4
781CeCyobhYK5bVOMcVbUE9MZGB83S2T+H9V9M/qg5+088qTsWXumjK6DbJtxY6/
1j9qJHxWJwjddu8QVKPQyWhXo5gRuAYEgVFuPeR+b8w+xXJOeYkWPx5GkCjbPfgD
oc7acKB92RzwCUBbiJKSaVPyKePfGRQDGLRT+bjnuHXGrqhAPTvNoWBkPA0k1qOK
pDfkspSha5xVxGMCK6Y5
=DoS+
-----END PGP SIGNATURE-----

--sMkrXc3gAYLRVOjR--
