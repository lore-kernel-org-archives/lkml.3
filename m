Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754375Ab3GXOfR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 10:35:17 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:50290 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754227Ab3GXOfO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 10:35:14 -0400
Date: Wed, 24 Jul 2013 15:35:11 +0100
From: Mark Brown <broonie@kernel.org>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: linux-kernel@vger.kernel.org, Eric Miao <eric.y.miao@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, linux-arm-kernel@lists.infradead.org,
        alsa-devel@alsa-project.org
Message-ID: <20130724143511.GG9858@sirena.org.uk>
References: <1374602524-3398-1-git-send-email-wsa@the-dreams.de>
 <1374602524-3398-25-git-send-email-wsa@the-dreams.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TT8SSM5c4BjMHFvZ"
Content-Disposition: inline
In-Reply-To: <1374602524-3398-25-git-send-email-wsa@the-dreams.de>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 24/27] sound/soc/pxa: don't check resource with
 devm_ioremap_resource
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--TT8SSM5c4BjMHFvZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 23, 2013 at 08:01:57PM +0200, Wolfram Sang wrote:
> devm_ioremap_resource does sanity checks on the given resource. No need to
> duplicate this in the driver.

Applied, thanks.

--TT8SSM5c4BjMHFvZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR7+YcAAoJELSic+t+oim9U3MP/RwgExqpspyfQgbBkYUgtjM0
jX/UL/Peb/+DKS/xcFsaHRVw3De/xq0NXP/5DEuA6ujZLEsX77/80k2dNvBfoxi9
P9+5Rf4qYyHkJFHEjEP3nZGUYisstV5ogdgWop40ZL+xBaqrH43JKEUA/nyoS0Dq
0P0CvdPbG7fukulEITl7d2xvgccJozMQB7Evx9ilwB2WdISfdOeB5ZHwu1EtGCuh
9ww6rLtocM6sOcCOFSwHsUKGWwm9386XG7RZBRIU2zH0MaB85EZB5/AhOONJ7P7q
yp20DLhgUZBzvw83ddyP8ydQO7guyADtgppUK/YsDXYVoHUMzeXJmYy9o9K7oU8o
AjMyFQxQF1Php3nX1t7p8Rw4pM9QU/5kJHRlo2x0iU02yIcLyFwKsryZ4pJc7g9M
evkSj1z+ZZ/P9XxtD5Bs67qNLU4hfFSyPIM4yQp3Tc3Odervi3cDbcZaetdfDlHl
kFWBiqSYV7bzQPszP4a3dmbv1m4jrzQ6a6WMn45ZBO+JQxdUABaMcgyybX+UEzf8
nZBfgSLOc2PV/KjMoJco7Gz30341k2GVVwUHFkeOO2yBRKHP8SkkdX410CXJ0fpV
ayoNjf12rsesI0rvsFw9y8Lbe0LGtIozNMRFY1dy6/PGnYobJXmIUsKCeZytbC6q
4oSz6R9op6V2W6dL54dP
=4Wl1
-----END PGP SIGNATURE-----

--TT8SSM5c4BjMHFvZ--
