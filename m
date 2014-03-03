Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752125AbaCCCJ1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 21:09:27 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:54528 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751452AbaCCCJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 21:09:25 -0500
Date: Mon, 3 Mar 2014 10:09:22 +0800
From: Mark Brown <broonie@kernel.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Sangbeom Kim <sbkim73@samsung.com>, Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Yadwinder Singh Brar <yadi.brar@samsung.com>
Message-ID: <20140303020922.GZ2411@sirena.org.uk>
References: <1393581710-17754-1-git-send-email-k.kozlowski@samsung.com>
 <1393581710-17754-3-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WeojGOqAOUQyw5FN"
Content-Disposition: inline
In-Reply-To: <1393581710-17754-3-git-send-email-k.kozlowski@samsung.com>
X-Cookie: You too can wear a nose mitten.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 202.175.88.218
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/3] regulator: s2mps11: Constify regulator_desc array
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--WeojGOqAOUQyw5FN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Feb 28, 2014 at 11:01:49AM +0100, Krzysztof Kozlowski wrote:
> Constify the regulator_desc 'regulators' array.

Applied, thanks.

--WeojGOqAOUQyw5FN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTE+RPAAoJELSic+t+oim99SYQAIq5KPXY9NUpmURYijr7Zt1c
VI+n6xO/FbvIjP5UtZSk3U120h4arKrycry98isU1JO1zimxS6qhAvMUqJfeoQzK
a3KBZtkZZ4APJCzfmhFC92sskrTZQZACidkW4dYNQqsX+/DhRSKwvD3xD4r3Prw3
JQuRgVUQD/i8wakbdWctKlF8wby0icPjouH3fCfXoA+NokdPneyuM2yGBCavDAv4
RxVyjPpZNkJzMYXO0A5MOHuL8nSDgN9o4ZuWsZi7F8lwX1oxUomELNaYO3VfxSiL
0KVqILClIsIUfuZdY2kZW7n7tstaxuk72Ej/sY6xyvSgL62dI6MOS/g9r0uIo7gz
hPpz/XIQDH9GV/Q0XGZJVqh4w1q/IIKCULNh2hEbTLFzbLWTIW6KzsAZ1Zkjl6Gi
ImpWCjp7yspwNi6fER9xFflE3ZukdlDf7j8HafDvWOXiOzjIgcT3h9VwIcyCYCzS
a62RfpaLyb3D2Z44CRrzGrBEKLRRNWpUN+4nNNvLphxL6/YiGd37k95mjZgr6vGd
FT2olNciS2MXdZoDcem18rChVeJGt3ZUVSv/M3xxxq3cqOuv+m218XH5toz6eas1
ymXtZwl8krIt3gTeJ/ErOymXA+SZPHEXlypqW4cJ2aoQLmvkqwKviyWJXeI9My4W
A9WhMH5wstvgfSoM5Puo
=/m07
-----END PGP SIGNATURE-----

--WeojGOqAOUQyw5FN--
