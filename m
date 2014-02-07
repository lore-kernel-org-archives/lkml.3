Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751529AbaBGQeR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 11:34:17 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:38312 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051AbaBGQeP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 11:34:15 -0500
Date: Fri, 7 Feb 2014 16:34:06 +0000
From: Mark Brown <broonie@kernel.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Message-ID: <20140207163406.GC1757@sirena.org.uk>
References: <1391767487-10017-1-git-send-email-k.kozlowski@samsung.com>
 <1391767487-10017-14-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NU0Ex4SbNnrxsi6C"
Content-Disposition: inline
In-Reply-To: <1391767487-10017-14-git-send-email-k.kozlowski@samsung.com>
X-Cookie: Colors may fade.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 13/15] regulator/mfd: max14577: Export symbols for
 calculating charger current
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--NU0Ex4SbNnrxsi6C
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Feb 07, 2014 at 11:04:45AM +0100, Krzysztof Kozlowski wrote:
> This patch prepares for changing the max14577 charger driver to allow
> configuring battery-dependent settings from DTS.

Acked-by: Mark Brown <broonie@linaro.org>

--NU0Ex4SbNnrxsi6C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS9Qr7AAoJELSic+t+oim905YP/RAASt2rAjvyB1K9/XJSxm+z
5qyyxw6KDxacmy9X39E1oZTnYFpC4+Q8BIbjckhSaUEGirNIuPgPPuaxJIliNvna
VuAqtHL9FOzeDWwHqyk4yEJMmb6/RqR/rQLy1jZN0q5gaYmm1WLpruaLvnK90lXO
5LMYVCreIrg1muZ8tnH1wkvfTFXiiGuDHa6vTpQphc0FEY9BDBqDAt6wFGtbbsP3
BUyEL9LlQ0ot3CeK7c+EGtO0TviwbZ5jLeFKQIGSWnLybVIP7/Vbmu2+6Zin11Sa
cQZhBBll/klzOXq3qI317uTwMOwJfninxtkT4pkw+RP6fSbfLNVm86D9cJ6tgr9V
JYr65khUNVIFH3VfnNPti72RB8wQ48KEi7NHYoLy1STFqpcksXkzF/fpklsI2PX5
ODKdZtVDmdez+tydHTqBtYEISegTw4I/J/eUIZEOXxdoNcsDWxDF70MP2kq7r3hS
JpjqnTQVx/Zd7/4Y9ZUA4g21FsfiY9bITQLkpLES1Rre1zYAIUVeKwTEZTL6Urmz
LzazDp6u7Mf91Fxc0sJbEBS8z/3MApgrXhUSQDT5LqLSTWYG2q7Xd0KNJOA0bOZ7
DY+c2cCSNBaIh57tJbOfrIDjENe/oevp6roWLm+RuRRIva8664BYX6IAnHsnbl6D
WvnJFgywxMLJZKcuCnc3
=SnxB
-----END PGP SIGNATURE-----

--NU0Ex4SbNnrxsi6C--
