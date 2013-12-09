Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761349Ab3LIRmx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 12:42:53 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:58408 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755914Ab3LIRmw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 12:42:52 -0500
Date: Mon, 9 Dec 2013 17:42:27 +0000
From: Mark Brown <broonie@kernel.org>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Liam Girdwood'" <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        "'Robin Gong'" <b38343@freescale.com>,
        "'Axel Lin'" <axel.lin@ingics.com>,
        "'Tim Harvey'" <tharvey@gateworks.com>
Message-ID: <20131209174227.GG29268@sirena.org.uk>
References: <000a01cef251$c79ea9e0$56dbfda0$%han@samsung.com>
 <000e01cef252$7423b3e0$5c6b1ba0$%han@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LuH5Zozo3bmn6wjd"
Content-Disposition: inline
In-Reply-To: <000e01cef252$7423b3e0$5c6b1ba0$%han@samsung.com>
X-Cookie: It's clever, but is it art?
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 5/6] regulator: pfuze100: use devm_regulator_register()
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LuH5Zozo3bmn6wjd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Dec 06, 2013 at 04:11:58PM +0900, Jingoo Han wrote:
> Use devm_regulator_register() to make cleanup paths simpler,
> and remove unnecessary remove().

Applied, thanks.

--LuH5Zozo3bmn6wjd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSpgEAAAoJELSic+t+oim9ANwQAJUgvJwo3Z1eqDiSQ5qBo+E0
ERzvvaImPmxuqN3kbQJZL/hPqtUILJgNE9tvtvclbdcRRTKMJZ8hh6A+yG6HQaIi
36X3o0nlEKmxnf/aAc3xJPa9O7tHzvrLlxeImTkBigAZYUu714idO4gtMHWUO/mz
GT2cf08mTuNXTfqGkJxMagRGKDUCpuju6Dysu4ya+fxOjfZIy3tM+4xS1vukA7pj
rc1tMx55Es/7BiFxB+f+LnukzBLXzhhrOBFrTa5HQtDHZnCaL3IkRrBW52/mJfSo
G4RlXQTmaArBXEuEhiqQZpAoBD0rc1tqYDqnYz3W6P2gUmy/aX4hkJvrgML8cxlK
kinD2tm68CJtp7AfvQvEnyi0aITLNdN+1cVzC752jR3sOd0JJvArcwbWDYqUiT5h
eQNy6jGFramwq7aQSAnTE/bW0i9pNygV4M1c4onSN4y/iI16id8QQ+zuNaPPwSgn
GJIZ9kvFcdBqnrk+AhAmpYg6Cu8zY4F84NRNXNeUudPV3fehEu1QcAF3lI+AmMcY
ICzqhr6D9QZrGzZoHpcmhPiXGJoZFTiT36dUzOMyjMoVRSKBWDs/wrSY8Jr2c0KZ
ghanxmzZZf+RFfRLFO0V/3DVpCA49z+ZJ1avEQrLMDdPboXTjjXVuyUyktAYh3fX
d4Zq8q8SYpOu5uSt2vsv
=QJNJ
-----END PGP SIGNATURE-----

--LuH5Zozo3bmn6wjd--
