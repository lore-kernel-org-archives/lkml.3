Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752175Ab3AZHWx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2013 02:22:53 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49223 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751337Ab3AZHWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2013 02:22:50 -0500
Date: Sat, 26 Jan 2013 15:22:42 +0800
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
Subject: Re: [PATCH v3 02/10] spi/pxa2xx: fix warnings when compiling a
 64-bit kernel
Message-ID: <20130126072241.GJ10580@opensource.wolfsonmicro.com>
References: <1358850393-23111-1-git-send-email-mika.westerberg@linux.intel.com>
 <1358850393-23111-3-git-send-email-mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qVyHzDF4yf4A8jkR"
Content-Disposition: inline
In-Reply-To: <1358850393-23111-3-git-send-email-mika.westerberg@linux.intel.com>
X-Cookie: Make a wish, it might come true.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qVyHzDF4yf4A8jkR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 22, 2013 at 12:26:25PM +0200, Mika Westerberg wrote:
> Fix following warnings seen when compiling 64-bit:

Applied, thanks.

--qVyHzDF4yf4A8jkR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRA4Q5AAoJELSic+t+oim9uLkP/0Ubl7F+wu52TyxXcbVppHiv
0Sia6e023axnrCcVBJyz0k5UlEFysko29+qxPqmaTiH6uDTVnRSBalUpp8mr4/jx
GutFpWCNYbGpDlIqMl9TsBfxS6Jy9Z9li7pMBFJnpLxO3R123X9RWdRuA1hvTbeF
JXQnpczQ4uYS1Z8d0d/s4H4YxdUPqWQMk6olAWLbiGWyn79FKx1HRkX+iT++cxuw
rA4J65gWkh7QaiWlZHsRi9OEaoepign/wyeKZjKqcwuKL4xwLAbXjcsjY5ejUnLh
JUxS61bW8WcG/w0rDzF46UVNqyo9/83OxpWKGLiJ1v4SKwKNuu5GI6O8WFwKE12/
4WnbdQ0foP+3IsbTMQvXjKM+HXT+YNlkNgxpgc27Nuu1et9mYBgMdNdEdJZBXWk9
oQyt8lrBdFXlPX7oVXGCSHfkS94LgW1Ox8ZpVP6mSpxIXU1+5EuyhhhDvdueeyuj
1nny6rgjxxkrP2QaZ1SwI8iste3RH8har69OhsuDxKN6/llklSOMgrVhiIfl/s/3
61WItpV8ljqsYnOCU2Wt1fwJ98FjvG3mZ2H0hJCzzRVpckDxr9Wg+Ev9L0Gz+qED
iUeWE0Ygehw/8tw7SFjdd77vfoJFgdHOGIGVMd3HU85OLdME0IkuOPfLz3SUPvWr
91S7UBnAKMVD6ODYO7gf
=/okC
-----END PGP SIGNATURE-----

--qVyHzDF4yf4A8jkR--
