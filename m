Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751351AbaK0SqF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 13:46:05 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:41165 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750861AbaK0SqC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 13:46:02 -0500
Date: Thu, 27 Nov 2014 18:45:44 +0000
From: Mark Brown <broonie@kernel.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Lee Jones <lee.jones@linaro.org>, Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Kukjin Kim <kgene@kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Message-ID: <20141127184544.GD7712@sirena.org.uk>
References: <1417087253-12306-1-git-send-email-k.kozlowski@samsung.com>
 <1417087253-12306-4-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RtgGjXQ2kxhQeAcX"
Content-Disposition: inline
In-Reply-To: <1417087253-12306-4-git-send-email-k.kozlowski@samsung.com>
X-Cookie: Celebrity voices impersonated.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v4 3/7] regulator: of: Parse ena-gpios property from DTS
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--RtgGjXQ2kxhQeAcX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Nov 27, 2014 at 12:20:49PM +0100, Krzysztof Kozlowski wrote:

> +	constraints->ena_gpio = of_get_named_gpio_flags(np, "ena-gpios", 0,
> +							&gpio_flags);
> +	if (gpio_is_valid(constraints->ena_gpio)) {

No, this isn't sensible - in what way would an enable control GPIO be a
constraint?  The whole reason we have separate constraint and config
structures is that these are different things.  Keep the GPIO setup in
the configuration.

--RtgGjXQ2kxhQeAcX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUd3FXAAoJECTWi3JdVIfQQJEH/R1aQvgsi1/2ZrlcnqxUo59H
UoTLEbE51P0zusADbV9oHGuwNfBfXMdi/yd6tfisgWYsd2XDbziq9DZyOmUyqymE
8wgiPqzxCKL0FPFatJQJ06XhVrc5nhjzbvi1TM3T2cIplhGRjkx9PHPUPVWxjyTY
bWcBXOhCmUN+kW1PvpV24+OFMqOLOM8NBwcFHpZpBSkP+N4uYIBw39ErqRLgd5ec
nYUMTYLw5JskSyiTjAI9srpVYcsAIM/0fyUBcxU/+xJwY0tqw5ELJw3jvW79qNkB
5QD/k/jlNRGeogvszq6Sur7d8Vh7BtptXUZXpYgcrVHzJaEWLz3/JlgWyhvVviQ=
=3zNe
-----END PGP SIGNATURE-----

--RtgGjXQ2kxhQeAcX--
