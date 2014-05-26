Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752485AbaEZO32 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 10:29:28 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:43202 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752097AbaEZO31 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 10:29:27 -0400
Date: Mon, 26 May 2014 15:29:09 +0100
From: Mark Brown <broonie@kernel.org>
To: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <20140526142909.GI22111@sirena.org.uk>
References: <1401105925-16528-1-git-send-email-geert+renesas@glider.be>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1L8KfrJLwTPQW+5h"
Content-Disposition: inline
In-Reply-To: <1401105925-16528-1-git-send-email-geert+renesas@glider.be>
X-Cookie: You are standing on my toes.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 92.40.248.185
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] spi: core: Ignore unsupported spi-[tr]x-bus-width
 property values
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--1L8KfrJLwTPQW+5h
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, May 26, 2014 at 02:05:25PM +0200, Geert Uytterhoeven wrote:
> Rejecting unsupported values of spi-tx-bus-width and spi-rx-bus-width
> may break compatibility with future DTs. Just ignore them, falling back
> to Single SPI Transfers.

Applied, thanks.

--1L8KfrJLwTPQW+5h
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTg0+yAAoJELSic+t+oim9CSQP/AyAxAKzrVa2XCsaQjX90ol9
xj4QjxCOceKwSvCIAM2Kyqe4g/BRM+3aS9xbsT3EIPNLDJHL04Bj4ISFInd8UIxt
lH5uNPaHcc0VqpeA4IzJM9vUsjtexDS7JTHPxfAzp3+MUpU3hPyhIgsqshmXiojn
BYrb60/NDkwGjvqd/2YYjhArQ2CfNOhTf6z1a4EIwcPtaNlXO3OYJ24NNrIQLHxi
D+VVJaAairJ7QcSsA/FhzQK8h9lVuJtBMEJwANzW2AVpd1wtKoVaUMCM6H1azM0u
nFvCGgOY9mBqw25LKypGMRsIy4TL/9BTtvx5AVn7sHYA98XzGDk+Xuq+HbqxCjvm
vdHvFVSgBJPXft+sz3q3WZnQyW1tFerC2YEVXLRKH5Re7jsjookMv2BPL5NVu8iL
IHsN128s7FEIAheXbWq977sd0rhAB2ESchc4D3SrZxyYoF5NrLL31+Zz/TCD80s0
zJaDsIRQF9qZTNrbvhn/SxVZwXbM+3fXEIzJNDzZy6RqDMNUuWN3/1iVHiGnluD+
cgRK70GErLX63BG8KSPsp7R5Vc595+3wgP8AbFbxtxc7Yxyf3g/3dpF2hhDAl25V
1Qt6A71SJ1ApfM7J5fbXj2uerNP2gfT1OsFyH9VBVmkekhS1C1YdQDVewNDJzqiC
sAYMI/ZeK3M7uQY8yE6H
=CYcy
-----END PGP SIGNATURE-----

--1L8KfrJLwTPQW+5h--
