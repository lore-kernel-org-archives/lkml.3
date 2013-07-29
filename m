Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752837Ab3G2Lk5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 07:40:57 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:48197 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752710Ab3G2Lk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 07:40:56 -0400
Date: Mon, 29 Jul 2013 12:40:31 +0100
From: Mark Brown <broonie@kernel.org>
To: Niels de Vos <ndevos@redhat.com>
Cc: devicetree@vger.kernel.org, linux-spi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Shawn Guo <shawn.guo@linaro.org>
Message-ID: <20130729114031.GV9858@sirena.org.uk>
References: <1375083485-14785-1-git-send-email-ndevos@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="uNJFlvTGIAMG9JN+"
Content-Disposition: inline
In-Reply-To: <1375083485-14785-1-git-send-email-ndevos@redhat.com>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] spi-imx: expose module alias for loading from device-tree
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--uNJFlvTGIAMG9JN+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jul 29, 2013 at 09:38:05AM +0200, Niels de Vos wrote:
> Enable auto loading by udev when spi-imx is compiled as a module.

Applied, thanks.

--uNJFlvTGIAMG9JN+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR9lSsAAoJELSic+t+oim9uEYP/iJzy5caX1uxNcOFT9VYiC15
6KcuU4snL3dH7SIgpZCOZCV4SzPJQVuGg6VwLLaVQsBeu/8MKLeenRcZWEhHMcw6
GPf5YQeb9DftPzQZzXbQU+3AQgaGbs77wk8m4F+f2GveeyKIwNkaTuxJv8YbuJ7G
/nC8TWefNuSwzSl4jJy7Cj/ZBppwcCWoyg+ErY9xK1XfjjQMbIk3nmLXdGs+6l5C
ZBy7vKimxj2cL/3cvSjnRvX7wMDM3aMDkKhj6yn3B3t4MGqf51aXTxbAB6QB/z4Q
nm62YJ4tGKNK6E5RgoX2EP6gemjybCFeqXdftyGY61mVO09Z+3xxCd8Id1LonmY2
aSXp01EuIcK9Kw8GBIrrqg1NSccqH7pJzlfVv1iK0T9eJ28KKs/iaBUpXd9kOCE/
v6g7adAX0OmeiDBo5L3wbIZDMBwsrxkyWfBrT+RtBQ2SWIKMfe2PMcx+Q2NhH9ai
MsyXP9pAIZ1TJJeAq8NFXTJVaaISZE9i5OnRwDZbtqTL4m4tcELYc3/xGcL2g/VZ
1iLpXusCgWhlowhMnRJUTuBSzr2MlXreuGJlT6ymPCWDIQInMEPJ0uF1fbtc2wvb
yBXEYXEYvityVg2az5iZiseJxntZqaaUGLEvLID3+3Rq98w9+8y71p4Q/lGW/cmT
dX25UXlu63S0vV39oc1g
=tmTf
-----END PGP SIGNATURE-----

--uNJFlvTGIAMG9JN+--
