Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752684AbaBJMuo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 07:50:44 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:39941 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752151AbaBJMun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 07:50:43 -0500
Date: Mon, 10 Feb 2014 12:34:54 +0000
From: Mark Brown <broonie@kernel.org>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <20140210123454.GY1757@sirena.org.uk>
References: <1391893281.19595.3.camel@x220>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cDkCB6tn7aZ2Gopm"
Content-Disposition: inline
In-Reply-To: <1391893281.19595.3.camel@x220>
X-Cookie: Colors may fade.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] spi: omap2: use SUPERH, not SH
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--cDkCB6tn7aZ2Gopm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Feb 08, 2014 at 10:01:21PM +0100, Paul Bolle wrote:
> Commit 0079aae0f1e6 ("spi: omap2: Add build dependencies for
> writel_relaxed()") added an optional Kconfig dependency on SH. That
> Kconfig symbol doesn't exist. Apparently SUPERH was intended. Use that.

Applied, thanks.

--cDkCB6tn7aZ2Gopm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS+MdqAAoJELSic+t+oim9f+8P/A7PuVwrsU1oCk9DkpwnDPiI
AguG7+yMLFG2d9tk6JJr5zImdpGxFNRpMStnj2UxQuqaktwXPQ1SsLUMqdqoHbqt
szK5Z6D7T7ZUehO8sqIB5H9YeCyIyPLnuASfc3xEtnGSWovBU5V/PxgS6z4RnKKJ
CW7c44JqmQB2qn6NXyQhZKveb/6qvA5oCHhGm2vWIwnEHP/HRv+l3WdUEyXv1V1J
X2KCcGSWqg3qn+olABqSHhdGvD1iyZ9tWJSrEMqNa0E8mVAoUNXKWmZvsIojYryo
GG4dpXGyjvHvr7BVuBRwYQzXF3otZMx7hofyz/ZjnBchVGs3HgPe4dK3HkTJEZQg
RHn7UMDssNGExVgWgHbJW2emvOZnGkllvE8KTvbt8aOFEgRAh/Mli4uKeh4tiL7Y
UCE6lXTtHg5cbXpE/qbgczBBz/XRmiRq0ThBKdrNdZPF2nOQeqZmaqW1QM513Iqz
3k18pBkudEhGEOtA4r0905aBVoOnJuGY0vGBhrKvfs0m4+bN1bSeuXLD3UUmr9xQ
TR3TWMvat9sFGB1C4cZanfmOIrCt9v724bXSHxexeb+XpqN3hQsOhTuZrN441uPO
Q4hViLw/HTx4vQL9dpAupm+jajYjuqkam1Yvl601gdXVADg+Ssfc1FLtvUQz/RNA
voDyRn1br+gPohoA9GX6
=gACo
-----END PGP SIGNATURE-----

--cDkCB6tn7aZ2Gopm--
