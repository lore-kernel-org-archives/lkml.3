Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753888AbaBCSWA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 13:22:00 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:34776 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753018AbaBCSV5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 13:21:57 -0500
Date: Mon, 3 Feb 2014 18:21:52 +0000
From: Mark Brown <broonie@kernel.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>
Message-ID: <20140203182152.GG22609@sirena.org.uk>
References: <52ED901F.3010002@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rltfBdJX5ToILDSK"
Content-Disposition: inline
In-Reply-To: <52ED901F.3010002@roeck-us.net>
X-Cookie: PARDON me, am I speaking ENGLISH?
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: Would devm_regulator_enable be useful ?
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--rltfBdJX5ToILDSK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Feb 01, 2014 at 04:23:59PM -0800, Guenter Roeck wrote:

As previously mentioned please fix your mailer to word wrap at a
sensible limit.

> Seems to me it would be useful to have it, but then devm_clk_enable()
> doesn't exist either, so I wonder if there is a reason for not having
> it.

In both cases enabling and then leaving the resource enabled throughout
the runtime of the device isn't normally the best practice for using
them.  You usually want to enable and disable at runtime with mechanisms
like runtime PM when the device is idle rather than burning power all
the time and once you start doing that managed resources don't fit so
well.

--rltfBdJX5ToILDSK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS7949AAoJELSic+t+oim9rR4P/1Z02mh7Lyr6M/cG/yyl5ZOL
VcUTljBTgeB1SmIwGVc9KrYMZE7yrBD4xXuUM5Ods9L15stxqipWYGliFGnrfLPq
X+xJ/p6FjMTpJLsO9mUCI8XeRbiPPygBpjXOhunN7vXWwtCz+KBY0s42RLtvdpRx
lBbOuVSpOY2jYDN/k3zAc43YsBtDrxzh4t0gzCff1K9lgvorLzLMShClOjBEyaPf
yLTUcWx3XkBO3J85Pong3QzMrwnQXUN+R9/4M0qXwA1eBjJmlRFSOvOu5OBgla+N
GA7JepoPXb1csG6RBSoFrgVsS9O3tf62DM7huLAm9mRNbkkGvnU7sMGuQa7G3BQa
p8BtG430c1Yj9yI40t/+tPLFMkzsgGYSK+JOK8usBQtMyHJGcqULhlcmU1jOfKxr
rx7jqtC0uOy2cIbQLGB16jTCADnK4h4UXy2snGoM7RFPSe6xXuikAnTQeFyrVCeH
azX56APEj5r8unmm84NyTu5XosS+kmF8kJ7qkOo24cfk7hCMUaMw4974hYg4+eIy
rhaNi1zp770mj+WUrCv84RBy9IJmtsA3yWoIm+C22kWC01wtfFDkDFwVOS/kH8Ro
EM5tdPQW/Oi2a+A7Vx5vVCasw3dDhMYr05IlOFggvgTc/SOEvkyYrwothzogTgqi
aLBAjoD/UGXxNPR15v3c
=wSDT
-----END PGP SIGNATURE-----

--rltfBdJX5ToILDSK--
