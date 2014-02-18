Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754124AbaBRCfD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 21:35:03 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:39921 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752680AbaBRCe7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 21:34:59 -0500
Date: Tue, 18 Feb 2014 11:02:22 +0900
From: Mark Brown <broonie@kernel.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, lgirdwood@gmail.com
Message-ID: <20140218020222.GE2669@sirena.org.uk>
References: <1392627817-26957-1-git-send-email-sachin.kamat@linaro.org>
 <1392627817-26957-6-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Ca0e2zgpnh8/XhnM"
Content-Disposition: inline
In-Reply-To: <1392627817-26957-6-git-send-email-sachin.kamat@linaro.org>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 106.188.99.154
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 6/9] regulator: max8660: Add missing of_node_put
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Ca0e2zgpnh8/XhnM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Feb 17, 2014 at 02:33:34PM +0530, Sachin Kamat wrote:
> Add of_node_put to decrement the ref count.

Applied, thanks.

--Ca0e2zgpnh8/XhnM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTAr8rAAoJELSic+t+oim9xYQP/0as0tv+LAQdQovaTti5t0/J
aGnULcqhd2XxJhmy6re7Q5MjKucwxo7GDdAwTu7dl5xMygsWQS87KV5Gr5ikadjl
Lr8m2OtLUcPds1V0y6e9H3DVIFhwMpx0CUkNrHUxwBpP1KtiuqM2XgG+rRennCUJ
9fjUkzICDQXoxwLPDEm4Pj+E9IOtOYM9qD7458vAp98oGnppBvxfYOow8bz9U2rs
Lvgx6AyvZ4vHqwOL93mR3pM7UJSQGkbQBny6j89WXB9VIiSX1cFK3lB5H0Oqp8w3
12Bz/Y4N/4UKMUs1PWR+DVy7EpZhl8DT6uqy2JM3nr64y7og4CUQ+VP4Nl6b+K1y
TMhXcfdHfeN3SuO318BG0G0sfRBmvd79i9TmMtaQBykSogimEBWo7TanfQqksOzM
YOiVyc4RdSkDrTMjvxSEYCE2tExlqKtiDf5CbXVJu+JP8K45LXr7iLsB3+F0+IXS
bhByDKjKff4UqxtfUdE/AHnRAqvBzCg4T53LNt4+n31eM4DtjcCZ69+crKoYfboU
ynjotOkbxDGGNvAchmS2x24vvXcgtsSActd8fuLlsRgcjm7pweMiuVdCIZq+3L3E
su4vVRKgcRwrD59TuXJ5sjpKAAioZV8uhPo0e+jG35ZgIpC0cPJz3C9Ag9UKp5IG
LgNHwkvep0cGm5iFQ/RB
=pXsO
-----END PGP SIGNATURE-----

--Ca0e2zgpnh8/XhnM--
