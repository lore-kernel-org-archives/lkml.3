Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753062AbaKQOTS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 09:19:18 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:43204 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752424AbaKQOTQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 09:19:16 -0500
Date: Mon, 17 Nov 2014 14:18:36 +0000
From: Mark Brown <broonie@kernel.org>
To: gyungoh@gmail.com
Cc: sameo@linux.intel.com, lee.jones@linaro.org, jg1.han@samsung.com,
        cooloney@gmail.com, lgirdwood@gmail.com, jack.yoo@skyworksinc.com,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        grant.likely@linaro.org, robh+dt@kernel.org, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        pawel.moll@arm.com, heiko@sntech.de, jason@lakedaemon.net,
        shawn.guo@freescale.com, treding@nvidia.com, florian.vaussard@epfl.ch,
        trivial@kernel.org, linux@roeck-us.net, andrew@lunn.ch,
        jic23@kernel.org
Message-ID: <20141117141836.GA2722@sirena.org.uk>
References: <1416213190-20935-1-git-send-email-jack.yoo@skyworksinc.com>
 <1416213190-20935-8-git-send-email-jack.yoo@skyworksinc.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="f8lmXUvqnCdFQPaI"
Content-Disposition: inline
In-Reply-To: <1416213190-20935-8-git-send-email-jack.yoo@skyworksinc.com>
X-Cookie: Today is what happened to yesterday.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 149.254.181.233
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [RESUBMIT PATCH v7 7/9] regulator: sky81452: Modify Device Tree
 structure
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--f8lmXUvqnCdFQPaI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Nov 17, 2014 at 05:33:08PM +0900, gyungoh@gmail.com wrote:

>  	np = of_get_child_by_name(dev->parent->of_node, "regulator");

> +	ret = of_regulator_match(dev, np, &sky81452_match, 1);

Don't open code this, use regulators_node and of_match as previously
advised.

--f8lmXUvqnCdFQPaI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUagOhAAoJECTWi3JdVIfQ2VAH/2B+tKW5DSX6DFwzPi1EjGdz
IfzTeXCQVn3FrpHu0f3jgC6BXupOW88CTtUQ5fYL8FLW9jxbdxLkridMqLZnPpNA
lN8wkUSsCCrcUdC22lnYoir767FxihprzoCQdCji/NoatZx51QWDYkrvvVoArDOH
gi4pH5jj9Cqmd7xDoz/Um5kkGOlBCnxi9uKpOvTCuvy3vLs2vvzRgARekfTNt1y2
lYyaj2qwBV3h4QxWsPH+XOL580xDRF/xIvldVNJHY54O/tBFX34Hua6fGnJOxrYM
/DjZNW9CvPESFajchTa1c/WZf/5kVQpQ5zocVaA1OuBSVG3PyLv6N0YXi8WzHvU=
=yhq5
-----END PGP SIGNATURE-----

--f8lmXUvqnCdFQPaI--
