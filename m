Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755982Ab3GCLMx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 07:12:53 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:48024 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754070Ab3GCLMw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 07:12:52 -0400
Date: Wed, 3 Jul 2013 12:12:24 +0100
From: Mark Brown <broonie@kernel.org>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: linux-spi@vger.kernel.org, Eric Miao <eric.y.miao@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Grant Likely <grant.likely@linaro.org>, linux-kernel@vger.kernel.org
Message-ID: <20130703111224.GJ27646@sirena.org.uk>
References: <1372847106-32698-1-git-send-email-mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="B4aku7JZbowIR6OO"
Content-Disposition: inline
In-Reply-To: <1372847106-32698-1-git-send-email-mika.westerberg@linux.intel.com>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] spi/pxa2xx: enable DMA on newer Intel LPSS silicon
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--B4aku7JZbowIR6OO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jul 03, 2013 at 01:25:06PM +0300, Mika Westerberg wrote:
> There is an additional bit in the Intel LPSS SPI private registers that
> needs to be set in order to be able to use DMA with the SPI controller.
> Enable this as well.

Applied, thanks.

--B4aku7JZbowIR6OO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR1AcVAAoJELSic+t+oim9wgsQAILOBMchPxxbVF3bq5Io30+y
gl+TWZ2GuQlxi9sGg4BLztV3+XGhtmF819I62jJWkOdwtQepkHXUGEPP4fA5JnkS
zWA5wLdl2cWPqPHqezOgW0/EQ+O/MmzOmhOcXS8qLhGuRjsz261HZZGKcV7x5fur
/6ppC1qwQPZFbM1kNYw8S4y3tp2kWEbdYrkhwfNFBme1H20vfDpEYfZvHr20Yo1A
iiWlCJEQDWyhIGb+IRAeIhELCJUaVkjsvXJTGzVpcZ51U7hitLSPkdX4tFWjSXVT
Z/57OUbmMZzQeNw1nLq1NMmO7wz6E3BKGThpB7cFaG+4X0KIjpdJO1E9DsYfYa52
PYc8d+xBe06i9oBDF+lzGGhRmapJvFr/2fX+++fkKFZcrFm3kVeFzPGgMFB+BLrT
DSe5SsrmJLRly3iArCYeg9f8DLMq+2bQMWZujENpr8dSSZpQnrdFql6CHsRMShI/
s3N8Ki0+Cr6PoLpTy1yRIny8Qd3CpOTHLKXAL/pQFbWvi9tr9lhlRDmEaUjL+OgB
mlxEnhIIQFqliAYadX/QC5LwZRBKwHEzEbZO13RQf4TlNlJ4VLT3YjrJMVT3ID4I
Dp7dUHrfwTSN/1sR70ofpvel6pvQXBjuGfdLDXAXzGTsHVPlGEe42XMHkPqGbelt
BE6fbbL3lSW9jDOoW6Sb
=6neb
-----END PGP SIGNATURE-----

--B4aku7JZbowIR6OO--
