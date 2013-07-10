Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753416Ab3GJJJw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 05:09:52 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:49400 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178Ab3GJJJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 05:09:51 -0400
Date: Wed, 10 Jul 2013 10:07:03 +0100
From: Mark Brown <broonie@kernel.org>
To: Michal Simek <michal.simek@xilinx.com>
Cc: Michal Simek <monstr@monstr.eu>, Grant Likely <grant.likely@linaro.org>,
        linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <20130710090703.GD3179@sirena.org.uk>
References: <348754a6cc4e7e05c7062d1b8b681638870a6894.1373385910.git.michal.simek@xilinx.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EP0wieDxd4TSJjHq"
Content-Disposition: inline
In-Reply-To: <348754a6cc4e7e05c7062d1b8b681638870a6894.1373385910.git.michal.simek@xilinx.com>
X-Cookie: Your domestic life may be harmonious.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 193.120.41.118
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2] spi/xilinx: Simplify irq allocation
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--EP0wieDxd4TSJjHq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 09, 2013 at 06:05:16PM +0200, Michal Simek wrote:
> Use devm_request_irq() for irq allocation which
> simplify driver code.

Applied, thanks.

--EP0wieDxd4TSJjHq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR3SQ0AAoJELSic+t+oim9dxQP+wYCC2OZUf0Fz6a2aL7rgjXB
DC4o/u/5OtrKhWkJitDVJSTZ4MNEKdejJp+CUQwzCC1hp5CFc8VXS3IlETIEMxcy
bBv3QXtKUQ5DBOmLkYr+tVXt4W0Dr1is2Ct+xkGvOE1qDVZyZbSaMeFp25vwtN4P
mfgWZP7mOrC+4V0+TNIrQZJ+6IVx44NZyanxyARki9EJM3XcoapIv6GVQkHc7PK3
W4/ipix6iYj9W17TpHiZ7dkze7f1wGTupNOLB81ssgn3G2zwd2KhVf1UNuqsBgyj
3ZHDneVCKULbKO5cCbYjI4vWKLG93GxsVDVbMeikd5Sjfj3ECXHxZrEGwvmCPajE
9FOoQPGNG7E1N+Y0MAYB2Evxgb94yom6uNxW96kAgth05m+i+odB3WFmyQzCPKWH
WYt4zbpqs5vGuqNvq0T7gG3CqWojEaZE2fXfw2EFEoCQj4wLRXRUhy7CkMGvoC8R
YAM8dn10mom7vEHI2UOhs9HIU87SLE19yz8mBmu5wemK3qsnuDQZynYHzHMV3shC
75hZwstS5VyW77oVD1DhxbZuuruUlc5nSIjvaNyYx89g+kE8cV89FepF5YUmaZDy
YJaSFQBEiU9JCNBBvRUr97r7gnXyTkZ8YxwvOl8TSAi+7EBEte16c89Nrf+yf/hO
feQ4fVvi6k/PlEwgYm+X
=lWyL
-----END PGP SIGNATURE-----

--EP0wieDxd4TSJjHq--
