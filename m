Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752573Ab3AZHXq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2013 02:23:46 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49243 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751505Ab3AZHXp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2013 02:23:45 -0500
Date: Sat, 26 Jan 2013 15:23:37 +0800
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
Subject: Re: [PATCH v3 04/10] spi/pxa2xx: convert to the common clk framework
Message-ID: <20130126072336.GL10580@opensource.wolfsonmicro.com>
References: <1358850393-23111-1-git-send-email-mika.westerberg@linux.intel.com>
 <1358850393-23111-5-git-send-email-mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0FM4RQAc0jwHekq5"
Content-Disposition: inline
In-Reply-To: <1358850393-23111-5-git-send-email-mika.westerberg@linux.intel.com>
X-Cookie: Make a wish, it might come true.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0FM4RQAc0jwHekq5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 22, 2013 at 12:26:27PM +0200, Mika Westerberg wrote:
> Convert clk_enable() to clk_prepare_enable() and clk_disable() to
> clk_disable_unprepare() respectively in order to support the common clk
> framework. Otherwise we get warnings on the console as the clock is not
> prepared before it is enabled.

Applied, thanks.

--0FM4RQAc0jwHekq5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRA4RqAAoJELSic+t+oim9bX4P/2L2Hfc1ly8KOM2cy9sQ4mS4
64G3MpZ8IYIwpK8jHk9COyNRXiyp1pjHIcGG4eCTn5iAYNdx/48md/b4yggTpzP5
4TfafZuBb8g2gbobkZXyLVmPrRiBhAHaF8GizTKDWAvVQXpYr5h1Y3G0JzE+yCt5
rjdVUDN2UA1WyU4ANTUCKjUmzyX1Xu4QOYL3dIFWJn+5llubRz6LEdN1qQUNbGyV
5GjPLDCvUgylE2vq91uRurdUL2YXa+5q/VxbUkO+yj9EyT9pDcm8u6u754hV6Hvr
YctKlLX+6gKojWLEq/dc7c1nsl2p9FthBsi5NN2SQ0tDCvmLuajIFKTlOV1voRlS
fodnzvQRgoWqdffjb91TdOXi3+4J9G7vzusWlZ16wsZA2sDOHYroUnq6pcToODKJ
do/vr37psB0o1lUwL8Pnfwo1Vq92sszo/RCSoCr62J6/vCBDU2N4SFAQL3BToqv6
n7x0k7c5fkdszetvnidt1VXFSeVjfrhadvnVinP/IYAJGXV/pc1lO4JIuvBTFBMv
CgKgg5J7wRGzSOebXYikgJEVfcwJnyMJRTg3U3stzeRl/DDmh/fyrZd/oU1ZPRci
dZMoBxMCdadomNvRC921y8qVp6liVKhej1HyKdwvWdvhK7736Tbl88DkiJisyBxT
es8+NeAg6ROn7tMTfzdL
=Uie+
-----END PGP SIGNATURE-----

--0FM4RQAc0jwHekq5--
