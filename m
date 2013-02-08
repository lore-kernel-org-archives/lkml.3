Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946046Ab3BHNOq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 08:14:46 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51068 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753644Ab3BHNOp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 08:14:45 -0500
Date: Fri, 8 Feb 2013 13:14:42 +0000
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
Subject: Re: [PATCH v3 09/10] spi/pxa2xx: add support for Intel Low Power
 Subsystem SPI
Message-ID: <20130208131442.GX8879@opensource.wolfsonmicro.com>
References: <1358850393-23111-1-git-send-email-mika.westerberg@linux.intel.com>
 <1358850393-23111-10-git-send-email-mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mu6rDKe19l+MneQx"
Content-Disposition: inline
In-Reply-To: <1358850393-23111-10-git-send-email-mika.westerberg@linux.intel.com>
X-Cookie: Stay away from flying saucers today.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mu6rDKe19l+MneQx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 22, 2013 at 12:26:32PM +0200, Mika Westerberg wrote:
> Intel LPSS SPI is pretty much the same as the PXA27xx SPI except that it
> has few additional features over the original:

Applied, thanks.

--mu6rDKe19l+MneQx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRFPo7AAoJELSic+t+oim9sq4P/RpuceBptkZPELxkY6TilzZG
o8j/zUFLoonZPVHawImsAGX88/vwzIYIFROerCVJ1ybvj2g10f3mcLxgRpQ4xgL/
Qq+fdi26ym9fPGXxVG2p3MiNqmXt/LJ4MXJ+6U8Ou2tphHzRbD1f7EVT2qfvdTVr
2fwjQxtUT7vrgQMMNFSmh+VEOrQbCrbBa/Yj0MQxK4jRExat0nadLGDGH2Gscmk1
NHmtVK0JmvvOjw64JGOyLNjdhyG8Qqeua5cnMkOGpSCnzNLpQJMEGJZU2oEfwm5C
icsT+zm1xOMpnA5/IUfC8wb0GRimYx9mynsk9YJLkgn2vDFa18DmG65rHqdHIJM5
oGuZXL4DcsYFKreGb9V8qJWG9wXZxLSN0XzMv0pzZXn1CRzJXfxPHNzmpcoa0oCJ
a3Zx5XyOz+buo7Lh3cEBwhxi5nk4ZF+zPa6tYAmllk8s82oBYFlJb3Y3U8ita87r
PKhDR0KpUSicP9P3FqGUFMtSMeimgSaM29CySGN5FSYAFfFrsmR30Qjn9E14w7Pa
QEUecsyC8O+QAHtoc44IcWzsmi6R8zbxWgdQNEciv3gQuCApm6FXqJrCn7DS+0MS
DCwS/iBy9PJR8NccO8jQq2SJo6fTld2ljnGxhMZ+BYXVNa3Li5LOjKy79dShKU5n
XfASAWdoIbAQejkwiksM
=YiOK
-----END PGP SIGNATURE-----

--mu6rDKe19l+MneQx--
