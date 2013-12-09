Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761421Ab3LISOp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 13:14:45 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:48355 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760380Ab3LISOn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 13:14:43 -0500
Date: Mon, 9 Dec 2013 18:14:37 +0000
From: Mark Brown <broonie@kernel.org>
To: Michal Nazarewicz <mina86@mina86.com>
Cc: Thierry Reding <thierry.reding@gmail.com>,
        Laxman Dewangan <ldewangan@nvidia.com>, linux-spi@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <20131209181437.GS29268@sirena.org.uk>
References: <1385745164-10534-1-git-send-email-mpn@google.com>
 <1386516911-26388-1-git-send-email-mina86@mina86.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lJC5CbBzX055ExrY"
Content-Disposition: inline
In-Reply-To: <1386516911-26388-1-git-send-email-mina86@mina86.com>
X-Cookie: It's clever, but is it art?
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 0/3] spi: tegra: use u32 for 32-bit register values
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--lJC5CbBzX055ExrY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Dec 08, 2013 at 04:35:08PM +0100, Michal Nazarewicz wrote:
> This series has only been compile-tested, but it does not introduce any
> behaviour changes.

Applied, thanks.  Like Stephen says please do make sure your commits do
as they're described...

--lJC5CbBzX055ExrY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSpgiKAAoJELSic+t+oim907sP/3g9BRQZFFxuiz2/RxzEwqzU
0vXk+T+pmTYUf4pyI9vkKkG05zGbQcBWNpx2ZYa/yDL0B7vpJwN2JQG+H4ORwDHs
/a/OUMfc1X0nbjysVAu6Iu5bR2PSFDEimp+o0PQAoj+2VWaLJOj3tPodh/vR2F1m
44LjeXnXR7UMy8UhIADwPJQ2nytB1/ld/chHi98/bZS1ubJKK4+pcQ8cgmwYP9tl
70CQeEG7DdVNjTMpkmJ2r4+LEBt1WGWz593xsxhzuxMPxDad3XP7dC8WXloONTZB
gApozafF3jNKfb7SeL/K+Gkve+QebP4wqo5xq+vSDM1uvFPLWr8tDPVH0XXFF8OT
w5FWBfPFgjTjPbvOa95QZrQbIW3kaE0LI0GFQRsrrY9OXOQIaSTPD49plgrCLcDf
JiwbnqNQLwZkTt/Hw2tqJBo2nNubquLDydMSBXMI+fOYvUXAMfvt+jOI62Kx2x8J
On0EuBH+HC1k3/8GhD/9DT9/EFZ1FYfuH+M4+yHcq3Sp/Vcl5eoS6BQxzzyhqvTa
N9BdmwKHUc6lYmBTlsnWdOJwULfeNnPtqo5x3g3O8EveNo4JRs/KbKmLM1QAtvV7
yqXztJjVaqS74SS9b2FWguOxI9oQBQ7TI/8xpjrtF7tIwNx1SAZ+yYK2zXsi//ly
lHIDyERCLkCW5TAvFYYL
=aidW
-----END PGP SIGNATURE-----

--lJC5CbBzX055ExrY--
