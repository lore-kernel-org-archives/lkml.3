Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753834AbaBSN6p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 08:58:45 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:43985 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753490AbaBSN6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 08:58:43 -0500
Date: Wed, 19 Feb 2014 22:08:50 +0900
From: Mark Brown <broonie@kernel.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, lgirdwood@gmail.com
Message-ID: <20140219130850.GW2669@sirena.org.uk>
References: <1392720071-13503-1-git-send-email-sachin.kamat@linaro.org>
 <1392720071-13503-5-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="No0c70i2q7XZ5BBl"
Content-Disposition: inline
In-Reply-To: <1392720071-13503-5-git-send-email-sachin.kamat@linaro.org>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 106.188.144.10
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 05/15] regulator: max8925: Do not hardcode return value
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--No0c70i2q7XZ5BBl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 18, 2014 at 04:11:01PM +0530, Sachin Kamat wrote:
> Propagate the error value returned by the function instead.

Applied, thanks.

--No0c70i2q7XZ5BBl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTBKzfAAoJELSic+t+oim99KoP/0tBv76Wu88QoOt+tKQ0mnZY
3ub+MjtEp8/NqKz3WZoi8VrzwxE4WRz2xU0HpwLhRBf96JDLydvGV3mePTRit2fr
+03KotQP/tVUJdq/i2BXlNFvREZVstObipDOlMj2Y8cyZLGjtTYyD1I8M9NE5Fvm
NcnGeo+pa4Cc4VWXY2ANCZU9jFCZkdDID2IGUHTKsjxz5gRbNppra8Vtp6PoFJ2g
PFEP5i1sxmfaSEwwK9aSwMhhfd9BQxcAyxocod0JjLJsgWikrgxCf0+FYfoE8zhE
k4UUHd5+DxsDl6sLDcdD46vKGuNG+g6tydyIGHskMZbD+J3L4sexPM9A0G2a0Yb/
GkBtPv9+mB95wajkMwX0PQ7O5bYWoCz0LADRVwniJpG+8EkCNjXIQgQgzkwMeUPf
TULBnGkFO8nJRgFHP7hRTNJBmJAB/h9upgh5hDEiLZHcTh8HALbkK+Lu2IqQablx
DuBzguwcfKZLtNHg5BsDhG71FKTxGcEnPGpKreVo+DuBT1owssOQDOZNd3XEfcaC
SP0MaJ/W7qXZUNo5rQfbMK0ecrbVouoMH4SO0qxUkdP11O15dnVaZuJlQ5daYH0h
30Yw+i00M7pLxsVQ35QeFCh3Jx6XXn7/nULeC5thg//obt8Oo3BAgXMVB78WRHAy
QNkBryKciUSQKzQxcMhv
=TfVg
-----END PGP SIGNATURE-----

--No0c70i2q7XZ5BBl--
