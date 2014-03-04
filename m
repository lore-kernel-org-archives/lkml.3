Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756832AbaCDJJG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 04:09:06 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:55303 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756687AbaCDJI7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 04:08:59 -0500
Date: Tue, 4 Mar 2014 17:08:54 +0800
From: Mark Brown <broonie@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lgirdwood@gmail.com>
Message-ID: <20140304090854.GG13126@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="w/VI3ydZO+RcZ3Ux"
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


--w/VI3ydZO+RcZ3Ux
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

--w/VI3ydZO+RcZ3Ux
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTFZgJAAoJELSic+t+oim9+yAP/j6cZRXJYgACubvP4PMbYPmM
HpT7FhsXOiAftPeYrqqP17zeJ6oV0yxsl3Wz4ONM7RKIooIDoJodxdvAvOlsK9I4
mFkxojxb223WiXQ12irAsRWsDaSQhf19waqZiNYbmJtFurjwJw2WxVzYx46cosQr
y3w8Xhz+Yyv2LqzAFoZP3juLR1w4OHQgdBfG5p5+dP+p972iwW1+H2wt8nsXPmNz
7TCzUzSzLhEw8QUgnfNqkfUGfQbKTexw2jkcW1LA/cU3tAWFK/mjTd9+JpMNukuF
xAmuz0lIQjmvNZYnMBkveqnSqUe3je3w+VnQ4IVc7UEnUf8MMPUtQ+/Fs0QaQCTo
H72AhTzUXpYlnHWe0T88jc9erQ18brenQq5W9FfT+omf57J3B2lYV30N5KWDYpbT
CEc6GBMq8I+8HozlRkG77USQBTNNgLep3UKM9DvcKM4XGxmG7bLP6PSuEGuAdAsh
dTt+7BhJHQAz9k9SfoFZNeb/mS1gcTdpN2Q2P77Jpo8t2e0XsNxLLZ2eeQ2eD+VM
yHZ3dk8JuDF+sA0SbgTG2oN8jcHJHABvcKAwArmZGkHg7sAFbWHG/0aEepBY9UK8
YHj5sJ5GXpegX2YBD68eEZWaz4EWoItjp6zdATvJ0I/3AzWRpY3EqDrkb4uu5GzT
W3iWOsRrAxzjYMbjDjmU
=WEgF
-----END PGP SIGNATURE-----

--w/VI3ydZO+RcZ3Ux--
