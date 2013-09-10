Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753830Ab3IJQwE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 12:52:04 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:55607 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752017Ab3IJQwB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 12:52:01 -0400
Date: Tue, 10 Sep 2013 17:51:53 +0100
From: Mark Brown <broonie@kernel.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Laxman Dewangan <ldewangan@nvidia.com>, rob.herring@calxeda.com,
        mark.rutland@arm.com, rob@landley.net, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        lgirdwood@gmail.com
Message-ID: <20130910165153.GQ29403@sirena.org.uk>
References: <1378811888-2268-1-git-send-email-ldewangan@nvidia.com>
 <1378811888-2268-2-git-send-email-ldewangan@nvidia.com>
 <522F3691.3090805@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="i/YlyGmJHSYJ/xms"
Content-Disposition: inline
In-Reply-To: <522F3691.3090805@wwwdotorg.org>
X-Cookie: Your present plans will be successful.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/2] regulator: core: add support for configuring turn-on
 time through constraints
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--i/YlyGmJHSYJ/xms
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Sep 10, 2013 at 09:11:13AM -0600, Stephen Warren wrote:

> > +- regulator-enable-time: Turn ON time for regulator(in uS)

> Bike-shedding slightly: This isn't really the time it takes to enable a
> regulator, but the time the voltage takes to become stable, or settle.
> Perhaps name the property regulator-settle-time/regulator-settle-delay?

The normal term would be ramp delay.  It's not usually the time taken to
completely settle, it's usually quoted as the time taken to reach within
some proportion of the target voltage.

--i/YlyGmJHSYJ/xms
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSL04mAAoJELSic+t+oim9Y2MQAJ0XCscbJlcsgpNA3BIDk0zF
QRSS8Vu107NYU8YZHnArv+58f4N/POocYr0QTZQOFHTF21OG7Vyd9nMy8tBjugbM
TIsB7Ui/0AfpR2pQ7RNPRC/T1RuWlEnBYERHfvuaLrZq5KV36rdimq9WlQ01fuRt
nJItcwLVSoz8d8RzgaUZ2T9VP2ucGPTgXP19jizqBECGUhrnQkCtxYdAqYqyEAQL
M5X/sTEvjTEJw8fepRS4qeNPjzFZ8fRIXb9gYlQJ+8aWRAatff+a1JXY4KqgOgFL
DqdV4uklnHFlhgXSQxpthBG+nd5C1mg4H6fAb4KZ8il5HtRO+GTKw+s3YClcVYJ3
5mp90Yo55VBlbDHE9G0iNb96HNIU8XcqDagTgydkm2tVHsPT63wdQb28gb5M05/c
sSbFoQA5VlynL+Q5yAnlChoDYwaVLthfG1LswdRdy8unVJCB3bfXs4pkkTYs809b
jRnRo0KM92vyAlpYXoeexIJYYD4Hcsl2M/s8YH1NbHYdPe7FJA0pnjuPlpR+qUzg
iSKHsE3k4HCOI/DEnoTSNdGBK/sRO+fKDm1mMvVdmHrPc5jNbYKDIJny3cRD94VH
i0AJe/ht/+N9s7+3ENsbE+T3C9qNelhhl3NflAnntdQnfnkg55doCgWYUbYfR9Ye
fMQQC0vGd7QjBpAWtLa5
=WxUD
-----END PGP SIGNATURE-----

--i/YlyGmJHSYJ/xms--
