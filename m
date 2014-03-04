Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756622AbaCDIYb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 03:24:31 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:55266 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756434AbaCDIY2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 03:24:28 -0500
Date: Tue, 4 Mar 2014 15:37:10 +0800
From: Mark Brown <broonie@kernel.org>
To: Linus Torvalds <torvalds@linux-foundaton.org>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lgirdwood@gmail.com>
Message-ID: <20140304073710.GD13126@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="d01dLTUuW90fS44H"
Content-Disposition: inline
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 202.175.88.218
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [GIT PULL] regulator fixes for v3.14
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--d01dLTUuW90fS44H
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit acc3d5cec84f82ebea535fa0bd9500ac3df2aee9:

  regulator: core: Change dummy supplies error message to a warning (2014-02-21 08:35:31 +0900)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regulator.git tags/regulator-v3.14-rc5

for you to fetch changes up to 66fda75f47dc583f1c187556e9a2c082dd64f8c6:

  regulator: core: Replace direct ops->disable usage (2014-02-25 10:31:45 +0900)

----------------------------------------------------------------
regulator: Fixes for v3.14-rc5

A couple of fixes here which ensure that regulators using the core
support for GPIO enables work in all cases by ensuring that helpers are
used consistently rather than open coding in places and hence not having
GPIO support in some of them.

----------------------------------------------------------------
Markus Pargmann (2):
      regulator: core: Replace direct ops->enable usage
      regulator: core: Replace direct ops->disable usage

 drivers/regulator/core.c | 48 ++++++++++++++++++++----------------------------
 1 file changed, 20 insertions(+), 28 deletions(-)

--d01dLTUuW90fS44H
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTFYKeAAoJELSic+t+oim9AH0P+gISAb06A8zCbW3fdOHITcVw
/gvDCHIhwok9ZhL8+HJN3FJSP0gJ7zl0i8qakZoLNw+lwy4e7F+AXo2hlAn22BcQ
1o/p5c6Czuq7ZESV4CuOTPnigiH3P46HXEHAmluK/+fnmJPvay6X9SERvzvZGqGc
aBEcD11IYqknAFznju893KaznX4gqHIKeTZsAP9KGHdF1H/MgtKH7EnYkypU1t8W
KDj26LURYK3k/zxDQ11JEcH8veeftvkidZ7JhvP7IO5UOEfrzI4+fx4EQ/eyvxzU
tcsQMtsOSU7vZdEVsFvC78gvKlbkYqdc/GRi1hVnnMtSohKdm5RgldSnZX4RqrSF
Z3o0zfQVFuWBUkwUSlw3vEj53JnXzyf2KvB1X8ouqp/xPFS4eXVn8YUjkbU+6sCW
yieBmlF1TuGjdwfpoO7LF30P8ggZytsOKRP7sFJrvAom9/vHBtVH5Lt/UvG3udMk
K+EmTCvzdDFfnsL2LlE24mAISPF7bfKhBL05ARzozH9nUKMoKUWhDwsVVH95sqWt
cMH4xg/WcbGZ3p9B8M9AwL4HfVHpCI3/Y0wXJWPA/BWnLEisFXPmEq6fAYUwixnd
2Ft6iRZBvUJ5JBvCoPgYP6Rvgxp5l2xKNENEgQf+yYgFn8gP5wA+N3Nb2t9+jZKd
KciyElco/PATX4PfL0NZ
=KRQl
-----END PGP SIGNATURE-----

--d01dLTUuW90fS44H--
