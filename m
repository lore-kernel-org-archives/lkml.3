Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946399Ab3BHMNv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 07:13:51 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55417 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1946347Ab3BHMNt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 07:13:49 -0500
Date: Fri, 8 Feb 2013 12:13:47 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        Eric Miao <eric.y.miao@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, chao.bi@intel.com,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>, cxie4@marvell.com,
        ytang5@marvell.com
Subject: Re: [PATCH v3 06/10] spi/pxa2xx: add support for DMA engine
Message-ID: <20130208121347.GU8879@opensource.wolfsonmicro.com>
References: <1358850393-23111-1-git-send-email-mika.westerberg@linux.intel.com>
 <1358850393-23111-7-git-send-email-mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="O0IT7rLmWuveAsNR"
Content-Disposition: inline
In-Reply-To: <1358850393-23111-7-git-send-email-mika.westerberg@linux.intel.com>
X-Cookie: Stay away from flying saucers today.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--O0IT7rLmWuveAsNR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 22, 2013 at 12:26:29PM +0200, Mika Westerberg wrote:
> To be able to use DMA with this driver on non-PXA platforms we implement
> support for the generic DMA engine API. This lets user to use different DMA
> engines with little or no modification to the driver.

Applied, thanks.

--O0IT7rLmWuveAsNR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRFOv0AAoJELSic+t+oim94DMP/jcFoiTJ4zB4em7cm4XFmGjZ
zWpc4GgaSiLBelhCLwqm/INeVrB1oRnwHSz2hYLmrQVoZ5buXP2bBDNKMBQ6S3uY
Wzg9iynyoD+y/gzSq5sF9zgezeOfD2/eQkMxrAI5YlqO+7GCB1Il+72et+blcnZz
wy7icX9HpvHg4ZNA/YcUKC+0BXr5cFmmQr4kVHR0ODXNI6a3dguuloN75i/MAz9J
ftMs7HzR0NEkXAvW0U3e6VpGnR8h/14eGCIlUwP6GRqJeNEeia5fGrh17hQsinbz
YNzCg54Ok8DOMm9PzjnAaMiEm69UNVvcTOmG8pAFq6Ip8ovhxFztJ5TjjAKcp/fI
kgEUWcJ+sBLfCfG+ryI+cGcckNcTttA1y5Mer2+zFuPXPalI9N/B2YIBlWOHUA8+
CEnXmG4RDYoabOC6ps9npnXX0UzRc6CZXWmOC+bwOTNAff63/wU/ybHhw3aF8hl2
YR4QkZm5rhnuO7U4zLt6z0ZK+mjoggQuObCbTR4pVARCpNhz+ppZxtfBPs6/+2x7
GhcABqKbUdYQCRKJ6fjeEm+t7auIJHmDfO6rE60yeiToBFHhWJxTgxIMQPkdpvwx
6tBejPj9WGYf1PnJHtXJIqzD/jn63Nx9O7RoRtlFw09kvCqPrNTINp6LcQp6l7dv
xPnkXkOzN4sM2QNOV/wJ
=B4PF
-----END PGP SIGNATURE-----

--O0IT7rLmWuveAsNR--
