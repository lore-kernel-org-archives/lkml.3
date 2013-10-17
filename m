Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753594Ab3JQXdS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 19:33:18 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:54517 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753253Ab3JQXdQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 19:33:16 -0400
Date: Fri, 18 Oct 2013 00:33:04 +0100
From: Mark Brown <broonie@kernel.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-spi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Message-ID: <20131017233304.GU2443@sirena.org.uk>
References: <1382026006-15544-1-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9YwYHZa7lvWObeAc"
Content-Disposition: inline
In-Reply-To: <1382026006-15544-1-git-send-email-k.kozlowski@samsung.com>
X-Cookie: Time and tide wait for no man.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] spi/s3c64xx: Add missing pm_runtime_set_active() call in
 probe()
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9YwYHZa7lvWObeAc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Oct 17, 2013 at 06:06:46PM +0200, Krzysztof Kozlowski wrote:
> Mark device as PM runtime active during initialization to reflect
> actual device power/clocks state. This reduces the enable count for SPI
> bus controller gate clock so it can be disabled when the bus controller
> is not used.

Applied, thanks.

--9YwYHZa7lvWObeAc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSYHOtAAoJELSic+t+oim9GNYQAIU2gx2qmWF+dE3DgG3SGi5/
ItHxs7D8RKgzin6DfapOrQvzOozyZYUu6PmNx3l428LWucwc9+RW3abRUYquWHzs
BvdKdOHMJtsmptYVtXP3+mM6xGi3MTznc9QXR2Iq0iG8AdouYPnf4g4UOLQE0jpb
cBLagCfoIsk9+sal85cDh3JMQgU3NDlc+rq4nrtLTDNvomE6PFH/zrRXiCIEGs1y
Z8KeDrUS4OTU+1tQcVc6UybbTAZlEcAGMQYTbxjzfQ8QEfdjIEyM51Dt8+vwF1Zf
vnTW0cm8+rOyfie3Oz8Rtc5FHCbklU6HwVFi8NBMODPi7JWvRzzfHcRdjNkrJP4/
LXiziiPGgqUS0+N+hPyAFCksJGDE233VN6gPz1EskUXCYU8XM12+HQGhmIvLEZXE
CiLnq77muOmCNHLM4LvN8YeoDfKbKcHHxgfTXHTLCS5O0+R1/YZZYguWO2neFTwh
ZyTh15X636SoRC+SmxDAF/ZD5vn9qyan1KMietZaSnRnvKId9KLePZsEFXIxqaQd
Ih6lus6Fm8M7UwBkzVyCanMbHnj46FlRAbEFUQp2bAbD68L6UQGD4j6W7a+VTF2+
dgdmySbEkfVCidyPInfljoao+Q4Us3z4bm9aitpMfJp78WFz5EQa45HAvRAKwaFm
flXa4ECq9yKvCyGhDwM0
=MZk/
-----END PGP SIGNATURE-----

--9YwYHZa7lvWObeAc--
