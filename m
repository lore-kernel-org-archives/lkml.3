Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751400Ab3F3LkK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jun 2013 07:40:10 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:36851 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945Ab3F3LkH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jun 2013 07:40:07 -0400
Date: Sun, 30 Jun 2013 12:40:01 +0100
From: Mark Brown <broonie@kernel.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Srinivas KANDAGATLA <srinivas.kandagatla@st.com>,
        linux-kernel@vger.kernel.org
Message-ID: <20130630114001.GP27646@sirena.org.uk>
References: <1372553937.3107.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BT+d3GSIvIc4kUSA"
Content-Disposition: inline
In-Reply-To: <1372553937.3107.1.camel@phoenix>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] pinctrl: st: Remove unnecessary use of of_match_ptr macro
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--BT+d3GSIvIc4kUSA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Jun 30, 2013 at 08:58:57AM +0800, Axel Lin wrote:
> This is a DT only driver and st_pctl_of_match is always compiled
> in. Hence of_match_ptr is unnecessary.

Applied, thanks.

--BT+d3GSIvIc4kUSA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR0BkOAAoJELSic+t+oim92ZgP/3e6ZWNyxiYwOpXmRLk8c+CL
R9GRY05vQEAJ4Ic/swS8vF3VBEEQ8tRnkEXuxya5HldzI0G11K7RF0baXKbvTtBn
OzPZd2HiQKOhNdYPnk92N550iwDa4MUqWK7cVS+jEFaGRvq0rGLJ4INuz9jiKjsv
YbV1JHSCznrBh234XZBd3Q1CKZNv/s1+01lvkATvmhcGhUIImvay1h1vudR/A9Uu
oxoFgnPdu2mZdEGXq9VuNeXo1K8LRg6hqRleeQLpXO9kMPbO0OWEPcZpzlzNcTyj
cgPM1tkAjeDYmP/A2dOU/6EuQfEMTw9+3Pqtiu1asGmuVv/q1FHB03cCbVnrWB/f
da9FMIJ1+ROH4FvvjPWtT2YM9hP/5ALQZQCcI5shoFcRy1XYWKCcBlETEzYibzUi
nyTd2Ks6e5frXKU5AHrDp69Up1mJevum0BFgrmp6nVQOgH3RHViLJ7hDKfYfJWz3
wj8moIPkW3hc0O1x8jQlDEgTGzGalAvviGTunzzliltQ6xY8nhfx6kDVrV10IUrw
l47ZONSk2Lrs4YeifXC3rnVyn/knLKJUrQGydn0IEX3SlzPEE4H+lzlxQdnTkdFF
wnWfjc6CKXYeaV3yfS++Wzd8SXddUvZSqZ196nqeOkAyYAPp4dB5Kszh/e2WbGBr
7hIeOOiqCpaEC36Brkmh
=MiKc
-----END PGP SIGNATURE-----

--BT+d3GSIvIc4kUSA--
