Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753814AbaBRCe1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 21:34:27 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:39883 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753112AbaBRCe0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 21:34:26 -0500
Date: Tue, 18 Feb 2014 11:04:04 +0900
From: Mark Brown <broonie@kernel.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, lgirdwood@gmail.com
Message-ID: <20140218020404.GG2669@sirena.org.uk>
References: <1392627817-26957-1-git-send-email-sachin.kamat@linaro.org>
 <1392627817-26957-8-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1xx5Q0+Cw+ObE54D"
Content-Disposition: inline
In-Reply-To: <1392627817-26957-8-git-send-email-sachin.kamat@linaro.org>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 106.188.99.154
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 8/9] regulator: tps6507x: Add missing of_node_put
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--1xx5Q0+Cw+ObE54D
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Feb 17, 2014 at 02:33:36PM +0530, Sachin Kamat wrote:
> Add of_node_put to decrement the ref count.

Applied, thanks.

--1xx5Q0+Cw+ObE54D
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTAr+RAAoJELSic+t+oim97UAP+gLC6RyVvv2vkcePGltX6Y+C
GKQPJDFdy76GqWI2JP4F2ETViOC9FsUOciq/JQkb2xioBKxzJ45WcIat5lH5wjyh
cHVno1ubNQPShl1B6BqlkSfdo3MC+/qx3mlrDQKWxuPSYTZ6VUKvKqdOl73/rcNT
DhfulAwb6pFLEul0QpC5xKqb/H6e5Bk0WF3wfuc8AMBW4+D2u7c/34QJv26IpGy9
PJb5PKlgccGZVQlmsmo2FcAm894ZGewG+02/+peU0etFnfqC/HbgZN1ZK7YBcult
P8AwNgTwe79ubmzzSZN5Jg2bfQnWjEkF/erdyaJBvtb8aO8ACLfxBRYiAmgsIQWZ
MqmsTiS5zvO67um+naIofQdLZSZYXzI5VVuv8pmgoNbtvY4Zcd873fzsGk3KWabe
kwKegkIsBkZahg944pyHdT9UDnospLkKYHUKD+lPVHSJr9DvCVUBbAm5vQ53XCRe
Gd6J832e+38MmniVAubSLgm+sDuxMlMSPIBHRnbMgy2GBQrtE+TgSMwUvxI8Mo8X
4pLNsF3g2zykd3/pAGg8kW1i1h4GiE6otv2ZzFJ4dBdqFxv/C6/R587WAQDXcnTb
XlVcoQq8YmBGIjDQ6jTz7fbphKvqnP3meKSmUbsktI3EXhjdAP5sgSTYz/AFO4lw
fTvMxi26YJAcHMB62wTU
=R9mo
-----END PGP SIGNATURE-----

--1xx5Q0+Cw+ObE54D--
