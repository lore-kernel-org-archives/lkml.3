Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752082AbaFVKvL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 06:51:11 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:53374 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751570AbaFVKvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 06:51:08 -0400
Date: Sun, 22 Jun 2014 11:50:51 +0100
From: Mark Brown <broonie@kernel.org>
To: Bjorn Andersson <bjorn.andersson@sonymobile.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Josh Cartwright <joshc@codeaurora.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Message-ID: <20140622105051.GL24291@sirena.org.uk>
References: <1402594402-30374-1-git-send-email-bjorn.andersson@sonymobile.com>
 <1402594402-30374-4-git-send-email-bjorn.andersson@sonymobile.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2EnvhqpWJq810sZn"
Content-Disposition: inline
In-Reply-To: <1402594402-30374-4-git-send-email-bjorn.andersson@sonymobile.com>
X-Cookie: This is NOT a repeat.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 3/3] regulator: qcom-rpm: Regulator driver for the
 Qualcomm RPM
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2EnvhqpWJq810sZn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jun 12, 2014 at 10:33:22AM -0700, Bjorn Andersson wrote:
> Driver for regulators exposed by the Resource Power Manager (RPM) found in
> Qualcomm 8660, 8960 and 8064 based devices.

This is fine but it looks like it'll need some respins due to the I/O
code.

--2EnvhqpWJq810sZn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTprUIAAoJELSic+t+oim9+aMP/1rRJJ6riyZspLVftj9xPVBY
mNoQRKFPTBp7IDaCoS/m6P8aTCWNqHLm+LfGOnUnPyfMSVr5TpbscRHLTGCNCEvo
lDioIL/ZmxTcAhRByTwmmOQPhoD2SrN1svIjghfVd130iw+ByrzlDSG2Bl/bhfDE
5HYiksKz/pno7IrsM2oAHu0i3q3JrML8zv14b5/Nsn+1lm5aRHPamHFxp0zD/dlA
ZDdL02MYhD71ECwX7GuQRz0Gk4V4Svdyf+b8uBTX6di1vkUqz/IrfYjtaPQorTWp
bJf6thFOJQKO1O0pKIqqWGFlJp6kLzkvyMTu5AF2N2eWIZO9ALagJi3ak7Q5+MhE
PS8B92RH6XgrR38J0fkjBQca0RSZvblBDO0D6gSSmnG9eBR9H+OzPywtj1U7LDdn
vlI3z0Tdl6Te7AMUf+gzTfA/hZKsIzNwMb3v+CsFIy6oVU9xdcdD86ONdZqwLL5k
6JNBwUtzQHqatFg71tTCZD4iSQQNuQ//y6T1YK1aIXsT45zuF2cdZYGpxuc12+Ne
MToxjx3Zwk3tj4b1vtYDc9s9ogr8lfsLVRKK+QqyDgcBrGyJhckis79W8FcWHp2H
oGi8XVamNch8O/l8BizRuc0FUTw9lJ5gno5Oahld9J8r+hX9pDHHxgR54Ds2HL9d
Onp7eVLI6pDIIOMkJNtZ
=+aZk
-----END PGP SIGNATURE-----

--2EnvhqpWJq810sZn--
