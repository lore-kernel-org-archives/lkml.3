Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754493AbaBSQ2m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 11:28:42 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:55337 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754472AbaBSQ2k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 11:28:40 -0500
Date: Thu, 20 Feb 2014 01:28:25 +0900
From: Mark Brown <broonie@kernel.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, lgirdwood@gmail.com
Message-ID: <20140219162825.GP2669@sirena.org.uk>
References: <1392720071-13503-1-git-send-email-sachin.kamat@linaro.org>
 <1392720071-13503-7-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="blo/x4cKJaGaeGcC"
Content-Disposition: inline
In-Reply-To: <1392720071-13503-7-git-send-email-sachin.kamat@linaro.org>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 106.188.144.10
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 07/15] regulator: lp3971: Do not hardcode return value
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--blo/x4cKJaGaeGcC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 18, 2014 at 04:11:03PM +0530, Sachin Kamat wrote:
> Propagate the error value returned by the function instead.

Applied, thanks.

--blo/x4cKJaGaeGcC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTBNumAAoJELSic+t+oim9JF4QAIpnDYCBDmQ+pUWTMa6WRZEu
YhO+ZJZ1UgGYPjgAmzJvEtfTghGqRUuej5f6ZH3cqsQaeQmfpG/nHkGxDGKU7jpy
9L9BwwGXnh9p6wuP7nlL7ulxpSO1TpmwuccjD/MiJ7mFKAomCPHcm72ixppuNWCT
4AeisPPwzPBaC83/76c3ii0NdXkaO6aMxvEdF7lsQFzaxlzMT0GN+viWk3kJf6/J
e46Qhzy4fJBrgx+kVHOnbEF2zYm+FH87H/x7BQXck55cYGKQr82KDhjzAiOIXgw3
7r1rRickxdwok1wLIF+Z97siP67Soy1bHx5UX92ib3Y6kJvULzJIvUo7pSgArc5i
z44uE0aIAIJ3DMSawuY1ZQjCZAvXonQvPG3/3U0q+WY650xQGg4jK61mAvglo+1X
MclFyBXxabhpt+MB8ya61rA0tGSP62HVdRU3VRs5GYTCH0zeFYDDjxuAxrotNVsF
JhHXvaDlFeccxD1RaM2Id4/SwulUYcq1ds88ecUPM+dBI6uH25HZ2z1f6n6l3rZc
Z4bR+NJidXc/4+NYl9YwYsvjUg4QuUIxpjmPvLPBpI3IZfoHtaQsnUxK+xQsu7Be
gsDbfelvQLIYzyYCeD5IZxQoS1pOxbgCfu/SOMqmkax4DubPt3wVlj74tBNP6C7K
VwXxtq1cjwP4H7Sb9zMI
=wNG/
-----END PGP SIGNATURE-----

--blo/x4cKJaGaeGcC--
