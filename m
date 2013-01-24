Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752869Ab3AXLTI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 06:19:08 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35658 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754380Ab3AXLSy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 06:18:54 -0500
Date: Thu, 24 Jan 2013 19:18:47 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, grundler@chromium.org,
        devicetree-discuss@lists.ozlabs.org, ben-linux@fluff.org,
        khali@linux-fr.org, naveen@chromium.org
Subject: Re: [PATCH 1/2] i2c-core: Add gpio based bus arbitration
 implementation
Message-ID: <20130124111845.GO4955@opensource.wolfsonmicro.com>
References: <1355464254-12768-1-git-send-email-ch.naveen@samsung.com>
 <1355464254-12768-2-git-send-email-ch.naveen@samsung.com>
 <50CB4E99.9060506@wwwdotorg.org>
 <20121215142135.GB22033@opensource.wolfsonmicro.com>
 <20130124111329.GC12933@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qse+WBH4guesipZ+"
Content-Disposition: inline
In-Reply-To: <20130124111329.GC12933@pengutronix.de>
X-Cookie: Tomorrow, you can be anywhere.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qse+WBH4guesipZ+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 24, 2013 at 12:13:29PM +0100, Wolfram Sang wrote:
> On Sat, Dec 15, 2012 at 11:21:36PM +0900, Mark Brown wrote:

> > also get things like read operations which appear as multiple
> > transactions on the I2C bus so require something higher level than what
> > multi-master provides.

> I don't get what you mean here. Can you elaborate?

A read is typically implemented as a write of the register address
followed by a read of the value, usually with the ability to free the
bus in between.  If two devices attempt to access the register map
simultaneously this results in the address going wrong.

--qse+WBH4guesipZ+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRARh8AAoJELSic+t+oim9WcYP+wWmw33S4AKN/3CeMXNRjY+s
CgiNqBwux+fQ1JfAqcTyJOp4pQLJVNewFZIZClvUN3t+7ZkgNnIImo2fEIc2vcol
AugQkOwVEkeBYKmY5S1R9bYymFyvv7CjdaMNv2w06hjOpwhHHcIpXIOlMi5efIXh
j58Kdl5VB6YJvyCUJGxywbiHYDTV4rb90fZWLfy7qwm81QoXhIsjc2GF+UX7iHXq
SSbI1F9r3KazOrxf+pA3Zl76qili06T61TUSrSVpLaYhhPjUwM84qBn4p0724DFT
tx3Ky5ZXBHYzrnZQpJ7ZERIqECOVd1AvSrwnhPS3l6S3MOxXjWZzG3BBA4H6GfRB
I01wMCFVZfuiXtcVC6zY5kTqN5aYIVyfX2JR8dKVSHEoi+e7Q2bbjxK0t0CU+s82
0zGRq+ZqT7KIeePHRTXkR7H3fFUZSgY/6O4BKa+gvoxzXUskmqwKhPYFyvAFrcKm
0k/4XfXmfXpXri7aiZudwDmH6NhGNJfsIodwY6QyoQBXZulmEGuSzXcSbt0IHTXa
1guFvK0Dja9GB7Oy6Vi7199qMYgbpOJ27Hu8+MTd6QiVsiVOEmguqWZ2DpM16Cic
WpZbaKwb3uiqbKo/OpanYHi6rcaJdkdghnWBDnCZXv0N12NHUgQaUpcbX8KORATa
nEas6DvWliPzPlCjPrNB
=MQZP
-----END PGP SIGNATURE-----

--qse+WBH4guesipZ+--
