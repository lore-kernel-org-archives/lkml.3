Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933259Ab3FRSLd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 14:11:33 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:36406 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932812Ab3FRSLc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 14:11:32 -0400
Date: Tue, 18 Jun 2013 19:11:26 +0100
From: Mark Brown <broonie@kernel.org>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Eric Miao <eric.y.miao@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Grant Likely <grant.likely@linaro.org>
Message-ID: <20130618181126.GQ1403@sirena.org.uk>
References: <1371565785-31332-1-git-send-email-mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="QtaS+3lVuRodb1W+"
Content-Disposition: inline
In-Reply-To: <1371565785-31332-1-git-send-email-mika.westerberg@linux.intel.com>
X-Cookie: Tomorrow, you can be anywhere.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 82.42.102.178
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/2] spi/pxa2xx: use GFP_ATOMIC in sg table allocation
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--QtaS+3lVuRodb1W+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jun 18, 2013 at 05:29:44PM +0300, Mika Westerberg wrote:
> pxa2xx_spi_map_dma_buffer() gets called in tasklet context so we can't
> sleep when we allocate a new sg table. Use GFP_ATOMIC here instead.

Applied, thanks.

--QtaS+3lVuRodb1W+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRwKLLAAoJELSic+t+oim9ENIQAIwrBNkBFOHYbF8VmYnsXz7y
702jVs9P2y93/gCpiqISbiiyVhGMaLKisdPTQnIOxGwiIy/jR85yZynkkgSmRoVX
fsChey5bWIzWImRcYsSeUfSOQ3TR8eThcGpLxgrpxLO+UtY7HHRGOHcdanK52DS+
qBgfALTO0VqEZu02r1RYSPn4Lgx5Tw7ThEm+wa8UvMQKdwQYXnaUGnx5ol+9H6OY
RIsBJUKutewGGrltK6jmLb8VONwbYBQdVkm6LZTwWmUeVNU0qA6HmL6JJuiKqUnj
3WHDDrKlS90NuKaBp+1LYAfgNlao3yCqeN3hpHPA5XPAW+NpzuUE+iKrPBQ7rM9L
NwSaMbOBFkmdJMGl5XB84lc+QFpgRqoQJj9efLsKKP3pQK2nYlKJkim3uf89auOp
UFlqLJpoM9v55sONeAZnB1StgHaNtsRLCIm1bbx8eb7zp0u7mj4ZMNmApKmDeE7N
fpsuAbtTIuXMEGj/HkB9LVHkcCPT1HT8InHYXpvxSNOKdaDEk20y9PuQWz3xQ5Gz
Hocumdlx1XwalqQGd6rbTJUK4FLXwmF7hoetSax9AbFPFE/evuFLhjDdLLmeQaox
D5KxQwyocGhlHmaTN2tDgBPjKADvpgPgIuB7xKVGMqWhLBZRMacGqPljNWCwx/7c
aMwlMH3XCh5i3y3zt/2E
=rc0e
-----END PGP SIGNATURE-----

--QtaS+3lVuRodb1W+--
