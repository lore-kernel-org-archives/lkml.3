Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752727AbaCJKbG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 06:31:06 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:56637 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752229AbaCJKbD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 06:31:03 -0400
Date: Mon, 10 Mar 2014 10:30:52 +0000
From: Mark Brown <broonie@kernel.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Wenyou Yang <wenyou.yang@atmel.com>, Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org
Message-ID: <20140310103052.GU28112@sirena.org.uk>
References: <1394284747.12881.4.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vXXM0T2D4JjNJBTG"
Content-Disposition: inline
In-Reply-To: <1394284747.12881.4.camel@phoenix>
X-Cookie: Oh no, not again.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: act8865: Remove unnecessary *rdev[] from
 struct act8865
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--vXXM0T2D4JjNJBTG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Mar 08, 2014 at 09:19:07PM +0800, Axel Lin wrote:
> Now we are using devm_regulator_register(), so we don't need the *rdev[] array
> to store return value of devm_regulator_register. Use a *rdev variable is
> enough for checking return status.

Applied, thanks.

--vXXM0T2D4JjNJBTG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTHZRYAAoJELSic+t+oim9NTQP/jK2tBjPiFaJLRqmTuyeTBnP
3d6oIDEBM0G8IIdYy4aY3pSxE9NMnJHuv/G12SEYGhIQkV1gbg6QvbY8kDSe45aw
UD5joypcwAPajlXRG8797BvYCwQj+GuerEtjJjYS7mHss6treBwBU9d/vpgwqeCc
t3CWMaTLUlAiybsIBgC8MtIX2MBMpbTwaJsdPzO5pZECa0NjGIaJSWPo6/vwYsNr
xAk4NnpToSinkRRWTSueSLFcM8nNd9D4Utb4VZvFhEqjjrxpHe/zeUN8tgDVh/+W
Q5Y7cE3J6+0IOvDoVDcnjNmSaudc/js223asyQhTUzp4xqlX2VucNjq6fSYrjf6S
VwMDHFJCoHmVIed55VRuDVp5cRi7ZMs2Ki/RxOID1twvPvJTKWNZKttLBLbrgpFv
HZUwYIGNiwwWDY6yc+kb/5dWh6HESPsgaWA8mHDjTAkg5mwnshDvePxz5bjXW6tY
w2eRO2O2ukxemS7qmywy0twWAq6npnXA+xlehCXRj52unXiBE6twDtitBn2GY5Zb
MBIqVpLnL0bb5rQ/srcnxrXYZQsMF7/n95GubHG6sZLMM7Rg5oxTGFHFIxdKJXH+
dZ5XFvpTwRfpbkHvOc1/YpBycynD/LoRKk/bn4J5O8w6D4B6yhx1BKHdVnUi8zV1
cni2CgGoxrDeI4AFY0CD
=pJ+a
-----END PGP SIGNATURE-----

--vXXM0T2D4JjNJBTG--
