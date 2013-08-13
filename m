Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756927Ab3HMKTi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 06:19:38 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:33967 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752756Ab3HMKTh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 06:19:37 -0400
Date: Tue, 13 Aug 2013 11:19:33 +0100
From: Mark Brown <broonie@kernel.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: "Joseph(Yossi) Hanin" <yhanin@marvell.com>, Yi Zhang <yizhang@marvell.com>,
        Chao Xie <chao.xie@marvell.com>, Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org
Message-ID: <20130813101933.GT6427@sirena.org.uk>
References: <1375579408.3588.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qTHmjVnu9F9eZWgO"
Content-Disposition: inline
In-Reply-To: <1375579408.3588.1.camel@phoenix>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: 88pm800: Fix checking whether num_regulator
 is valid
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qTHmjVnu9F9eZWgO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Aug 04, 2013 at 09:23:28AM +0800, Axel Lin wrote:
> The code to check whether num_regulator is valid is wrong because it should
> iterate all array entries rather than break from the for loop if
> pdata->regulators[i] is NULL.

Applied, thanks.

--qTHmjVnu9F9eZWgO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJSCggyAAoJELSic+t+oim9bSYP/0IHXWhN2Zue/txVQ+OH+h3L
s2z2sXWPTwvUDSyFZXT4cuACDZlz2ECidr7HFgw2QOuGSFWxwBBvz4gEuZeW21VU
KI0zKqWQhPW/ePfpDcp2rzORswigxpJ1RfCCEy9xwEbSCjTCLMDy3ONUWWhtdmLz
jBRjxa0gJjRs26LgtpQwislMDUb/BNd2P9WDEBuMWxYF86kjSaEbZdd5N+qyCBFG
GQWxXlcr5yMTG0sUgfhjQrLGlNItD9hYN3YoEEQjvRjXKKMpO0oroOtf5ssvYTVL
z3aqtqSI43u3zS4mcq73aO57GfK/uRZnN1uiYdfM62o6t26oT5qPFhy7qcuXVSSv
CuLAKZf+2tbKyuy0CcHsABGHgmTvNfAp20a0avHJnpabCQrAyx2Imq8bw5RekrZg
exyQUtoIx4ijiD5szmF7fhEESD0BgC+WWejRgJlqR1SrGjZUZ0BvsoT3XkX+xdq+
gLmEJSY23jifUHtQeAMIqWPxVYau4ySV+1PsdF8RM5so0/0ZHtv0VwY7gAK8jGUe
htdbwKkS9aIpFp+ptRAnjFqa2KNm/8xpbIsdR5kCd5RAJZukUXOYqgTav9CpALrz
F3ZI0cVd8WbIJUTDW/izAZdYWWvUNiPzt3RDYeaCeueym/QSicQzUx/SZ/KRnQDX
0ei4tgLM8G8aSDsTXkgj
=z3wL
-----END PGP SIGNATURE-----

--qTHmjVnu9F9eZWgO--
