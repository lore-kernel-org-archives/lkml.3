Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946381Ab3BHMNc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 07:13:32 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55406 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1946347Ab3BHMNb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 07:13:31 -0500
Date: Fri, 8 Feb 2013 12:13:29 +0000
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
Subject: Re: [PATCH v3 05/10] spi/pxa2xx: break out the private DMA API usage
 into a separate file
Message-ID: <20130208121329.GT8879@opensource.wolfsonmicro.com>
References: <1358850393-23111-1-git-send-email-mika.westerberg@linux.intel.com>
 <1358850393-23111-6-git-send-email-mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/FJxnyttrH06HRq2"
Content-Disposition: inline
In-Reply-To: <1358850393-23111-6-git-send-email-mika.westerberg@linux.intel.com>
X-Cookie: Stay away from flying saucers today.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/FJxnyttrH06HRq2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 22, 2013 at 12:26:28PM +0200, Mika Westerberg wrote:
> The PXA SPI driver uses PXA platform specific private DMA implementation
> which does not work on non-PXA platforms. In order to use this driver on
> other platforms we break out the private DMA implementation into a separate

Applied, thanks.

--/FJxnyttrH06HRq2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRFOviAAoJELSic+t+oim9ksoQAJ5D4hk1C6GaNjmHxYKk7Wja
FgHEyUa5wUHMQUJUNklUa9vrYLUCbjMsLxJoH5H/i9+IUI7XURDoxx7pLNdyVq6y
OxPWF5D3gt9kKEa82qV11sM3hwVk5JZJqMJh3KExl11n+L/0wqTDcwgJFpbb+ihQ
LhcF31s7SBSENuZ0i7Vd2aHgc2z82WNimQg6teq734FsojrTt8ndUT6oOgeuyl0G
6zYofZobvc/PcKFYPM1wtCohEOTxQEYkzkAlCaFoq166EjWIU422+UcGkh//8Xps
rob78zrR0L/Lmf9iDFo00S/TZ628sdsUlBIRzsLEVky/hQf/0pppxyXn1pcj8Vbp
+887m439nfBoM+B7jVq+0fEN+cBain2DtKWy93SIZjevbEybFQ7bqOumbf1NiPGi
yf7U0d2RNvjF7sIeKVN6CFywsLwo36SFX0RIANPH3yXbzss86y+gnXYHge+W3zCS
TUO5zVcv9BpxXQuFzkKpHO2PC8z6EGhRfJ1YFJzdf8E0eHgURB+t1RKWtYh+ud/c
Q2Q+Xt/+pkjSNBipeaTbqixTI2oO6qyE73mYCyyPDuq0x90U45WzcX5299YpGZ+P
sRY7ECC6leJL5G42b1El50k7E7gmkVO4VS0L+D7JxD9Cdy4zo71jBQ7OGWzOHAYn
m/2k2DfL49axdzISocIK
=b0/U
-----END PGP SIGNATURE-----

--/FJxnyttrH06HRq2--
