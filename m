Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946408Ab3BHMOv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 07:14:51 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55437 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1946345Ab3BHMOt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 07:14:49 -0500
Date: Fri, 8 Feb 2013 12:14:47 +0000
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
Subject: Re: [PATCH v3 08/10] spi/pxa2xx: add support for SPI_LOOP
Message-ID: <20130208121447.GW8879@opensource.wolfsonmicro.com>
References: <1358850393-23111-1-git-send-email-mika.westerberg@linux.intel.com>
 <1358850393-23111-9-git-send-email-mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="L0mHLbha4YKvhGtu"
Content-Disposition: inline
In-Reply-To: <1358850393-23111-9-git-send-email-mika.westerberg@linux.intel.com>
X-Cookie: Stay away from flying saucers today.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--L0mHLbha4YKvhGtu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 22, 2013 at 12:26:31PM +0200, Mika Westerberg wrote:
> This is useful when testing the functionality of the controller from userspace
> and there aren't any real SPI slave devices connected to the bus.

Applied, thanks.

--L0mHLbha4YKvhGtu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRFOwwAAoJELSic+t+oim97tEP+wc1WgU4HO+bvS6zx4FOtf76
p+4Aq8yYq5OiA2hAQFOBv/PgK0YmxWjd9eHDARuPbcGURFekK92n0EQ7Rx73cALQ
TWxN/B5N7wxcRlTzxvcfL/j+rMo3OXE5PBAJqeAb+C0nlXDB1B7Zx+yrP1iq1jtX
VjW7sgE+qUaSiBH2qNAAQolVK5AVJLEz2WiVm8z9R1YutWP8Qx6RGLFdMm1dyfnA
+IHuTqIQJtagNVIY+7y4KGw7fDr5ruCvar80uGJMHf8C2ir4YyLYKpTQfuKcL5TN
x5Z5q8ojeWdt7Vkz7qGoJhjiUE1ALkUEsP8c8B1lSiJ08P+uCG3KtaJadsDmTrPa
+Rl+SQ8WZbP57gNZ2MIKrdgLM56Srx09bHGTzlq+yl/awYdvuU+nGBgXMEXJiL0B
UmnSglJHnRae0DN1SDxTROGpZwG6kucHz6FxV8CUkKeomdwpm0810V14LusylXMA
GlEl1ZvnE9bOcvxDdtYUZzPPW/dLNRkAaIbjVq56JBt3XapVWJF1yhoDUyVvLYoi
CwfcPcrp53dFSDmNWsvXP/lakF5SylMHvz2wttfJ4bXjjUGpdUCa4EPv2sfpFAWs
+2DJyGly+eZOKJVZikX07KbI0q5GfVHyrEbFivhWJKxqGyCP4ncz+qcwUtCZn4Nz
AqTEsSEajN4LyDVoEo0v
=fnXI
-----END PGP SIGNATURE-----

--L0mHLbha4YKvhGtu--
