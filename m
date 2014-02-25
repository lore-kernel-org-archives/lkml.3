Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752954AbaBYDFN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 22:05:13 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:51256 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660AbaBYDFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 22:05:09 -0500
Date: Tue, 25 Feb 2014 12:05:00 +0900
From: Mark Brown <broonie@kernel.org>
To: Felipe Balbi <balbi@ti.com>
Cc: Andy Gross <agross@codeaurora.org>, devicetree@vger.kernel.org,
        Vinod Koul <vinod.koul@intel.com>, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, dmaengine@vger.kernel.org,
        Dan Williams <dan.j.williams@intel.com>,
        linux-arm-kernel@lists.infradead.org
Message-ID: <20140225030459.GN25940@sirena.org.uk>
References: <1393283500-18599-1-git-send-email-agross@codeaurora.org>
 <1393283500-18599-3-git-send-email-agross@codeaurora.org>
 <20140225000913.GA10801@saruman.home>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="t6FrQAmG0gROuB4j"
Content-Disposition: inline
In-Reply-To: <20140225000913.GA10801@saruman.home>
X-Cookie: You're at the end of the road again.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 121.174.50.227
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [Patch v7 2/2] dmaengine: add Qualcomm BAM dma driver
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--t6FrQAmG0gROuB4j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Feb 24, 2014 at 06:09:13PM -0600, Felipe Balbi wrote:

> > +	depends on ARCH_QCOM || (COMPILE_TEST && OF && ARM)

> do you really want to make it depend on ARM even when COMPILE_TEST=y ?

writel_relaxed() is unfortunately not generally available so it'd fail
to build on platforms like x86.

--t6FrQAmG0gROuB4j
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTDAhYAAoJELSic+t+oim9EXoP/0pAn6uqABX99rRXfhcQBd42
HTm3E2GiYSmHJS6Gz5NgdYIG/ieM/dhv36Enw6lVEzU97nFgRkRYt3juTUe/ZbXD
QVyFYySGedfWMdfExPHCeA5aO5JKvpzbIUHJoWrUoti4Rrpm5gZoIhiBuPZbXTX7
Txk5Xyi5Vo5K3E9qwVYitQg5BupNX9uc+UuCy+joDDJl9SLIGrG2NrcDT7GlzP8E
xKJAwM9U03E6DHu2aTp2w/ySOXOgY21A7ZDfT1kdrlLewpulPA3/AoNnDzkH+Osm
PU8bTwikRaRL7uUVFPoWKbSQYIFcu0HkhDkL7Ht1bw6BLX3YJiNyGx/ZgqkgcNEu
lkSwkFcpQYIiVLiwfMPgRlejIPao/GgV0S1eL6aEpGEYJSHGIBjUaivCfuJmFh8L
+RoK9zX2FgOEx3FunhZdkOmmad3hG2+FYsKuVlSy77H2PdSX3iv+ZC5oYFKEsWqM
nwWppsVt8HGwG/tSTa9ZzFhDPWjuH0hgS8tCFDUs1YQCsn6NaTRl8C88qPFWFeSJ
UTtMIutkyN6XigmsBzHbzGc7Bv8MQwtqUcEmg1HV9cVkaQI76D/WDkiibqElgSKE
3w0Bp85wpX7z8GPwme9TZpCGqAnxhcaw8LO9nyKIm1YWa2dO1+evE7Niaih8MdYs
Wr5wBU6DdsyzFd2SYSCW
=s909
-----END PGP SIGNATURE-----

--t6FrQAmG0gROuB4j--
