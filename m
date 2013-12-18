Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752103Ab3LRTX7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 14:23:59 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:50752 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751866Ab3LRTX4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 14:23:56 -0500
Date: Wed, 18 Dec 2013 19:23:44 +0000
From: Mark Brown <broonie@kernel.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Anton Vorontsov <anton@enomsg.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Kyungmin Park <kyungmin.park@samsung.com>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>, Lee Jones <lee.jones@linaro.org>
Message-ID: <20131218192344.GO31886@sirena.org.uk>
References: <1386329534-14186-1-git-send-email-k.kozlowski@samsung.com>
 <1386329534-14186-3-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XMHqbYJb993HXwLR"
Content-Disposition: inline
In-Reply-To: <1386329534-14186-3-git-send-email-k.kozlowski@samsung.com>
X-Cookie: Go climb a gravity well!
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v7 2/3] regulator: max14577: Add regulator driver for
 Maxim 14577
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--XMHqbYJb993HXwLR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Dec 06, 2013 at 12:32:13PM +0100, Krzysztof Kozlowski wrote:
> MAX14577 chip is a multi-function device which includes MUIC,
> charger and voltage regulator. The driver is located in drivers/mfd.

Applied, thanks.

--XMHqbYJb993HXwLR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSsfY9AAoJELSic+t+oim9adQP/3blzLFS3925w6BUWS8dfhaQ
/Ym06Wtc5JBMLr7h07XJsMVer/Yj4kWi1Il6KA8gzjY3kxAhMYlZhoX8gacxj1BW
cu+I8rePvCzvTV5haOZDJkH24LBCggbfdzwV7LRqfyJUkWVDC5561j+L/W/v9Vm7
zBU/IRsLkPRBzcunhOBRI+zia08pc9m48nQPxGyRG4Tj0mU+4bCLW/9CI9pKVTA3
a3+h+hoyVmHNo1N5ktJeVe/dEWC+JL3ZWALaLj5t9NO9MV9hV4JJ9a+fNqmte0dB
Yt2PBFl+JR24xMTcHpusQZ8UXLlN2AdQIGaqgWUOAzzwmL3a64h94huTQeDhWo/t
I0vlLPwZ5LyiAlWPXnDEDyWTiUrKdTGE5qMcwRBr29CSxVBcHy3X8LAHEmQvZPs7
LPwLkVSjS9S0XnAAWpbU5FzzRRysASQ7RgMjMupTIvbvwMvWAAbVpItOef7hWdX5
JlAugExgkCmclWQx4A5anaj+S5GvP6Oc3nvpZ1IirnsY4956+7Wsc30fkE9j9+GU
77UZ9yeX6rDogQ8ulusPdSs4OeOzX3EmT8JdxftyuxlDxHQKCxKWvoDNnN3ST4B3
0ZQAYTJRPOvQBdRIHZbxLv4yQp3XF1onSsWpOG4IVhodQbHkXCrf5H2pT4qgve2X
EsjAtGJ3bFox2S++FaNa
=JFJ5
-----END PGP SIGNATURE-----

--XMHqbYJb993HXwLR--
