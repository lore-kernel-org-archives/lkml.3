Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946387Ab3BHMOc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 07:14:32 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55427 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1946345Ab3BHMOb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 07:14:31 -0500
Date: Fri, 8 Feb 2013 12:14:29 +0000
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
Subject: Re: [PATCH v3 07/10] spi/pxa2xx: add support for runtime PM
Message-ID: <20130208121429.GV8879@opensource.wolfsonmicro.com>
References: <1358850393-23111-1-git-send-email-mika.westerberg@linux.intel.com>
 <1358850393-23111-8-git-send-email-mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="b3OyYALfe3DXUU4J"
Content-Disposition: inline
In-Reply-To: <1358850393-23111-8-git-send-email-mika.westerberg@linux.intel.com>
X-Cookie: Stay away from flying saucers today.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--b3OyYALfe3DXUU4J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 22, 2013 at 12:26:30PM +0200, Mika Westerberg wrote:
> Drivers should put the device into low power states proactively whenever the
> device is not in use. Thus implement support for runtime PM and use the
> autosuspend feature to make sure that we can still perform well in case we see
> lots of SPI traffic within short period of time.

Applied, thanks.  I keep thinking we should just put the basic get/put
around transfers into the core, I can't see any SPI controllers needing
anything different.

--b3OyYALfe3DXUU4J
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRFOwdAAoJELSic+t+oim9lxYP+QHeQChNi5nEgV0oTgvr5JU5
B6l4RiEtQEEd1Uw/Tm3jsdwspvtLUqJwE6gQIfNBHnHpYegLdI7uMGpabDxHGSlP
ikrjgbjc+cnZTFpIyzdDv3AVyIqYA717e5IJ8By8MLlW5+uJm9xko/q/lX5ZhuiZ
u4pNzFbBWUlhkuxueHtJXm61ASxHu1Zz4obigngTpPxA46HAZW+5P6nz3z5Yu/gb
o0oMj58yskR4LHFs6kUdmu38YRBLPuMOUoD5+9aD/6ZcoPLLdVUDPvXZUSYuMESO
aS0UNmbBVb++TZlOBbkn9Lp3B1KHIA+8nbyVEycgbkJkMjwEY/TZuPLANjqaOYYd
2UyzUwbWKmRy04T4KdFjcDSsGdD+tmyQI2sDHfS7imvWfFLQZqy6Qf1ZZeWQPQ9K
CQ4zB5FKOyJWu1X5RmAy75QoQPwsrSBgA5Ml+h0Dflyzac58P2zhBKKxlHCQ9UvQ
YwU42HTOYbtB2T9WtmpsbbpctQwtZHGEQ0vRPmv/xdCYBB9ApO5goD+WdfVbvJrl
Ic3QLCYS7fdguHV2ZE1emhYsYeNmEm5zac+ATKxIsfFxppDeAAJ9Mf9BX0PTs1JV
Fo5PW3zZkMjHaUoZlkNGj2eEWTWO1W5Ffgoi/F+QYboSdfJm5JSQQGQZgy0AGNHh
6uUB3GJvV7wKeOOIPqbP
=rVZH
-----END PGP SIGNATURE-----

--b3OyYALfe3DXUU4J--
