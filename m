Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934283Ab3E1OYE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 10:24:04 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:46760 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934123Ab3E1OYC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 10:24:02 -0400
Date: Tue, 28 May 2013 10:23:41 -0400
From: Mark Brown <broonie@kernel.org>
To: Fabio Baltieri <fabio.baltieri@linaro.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Lee Jones <lee.jones@linaro.org>,
        Ola Lilja <ola.o.lilja@stericsson.com>
Message-ID: <20130528142341.GJ3660@sirena.org.uk>
References: <1369750599-10795-1-git-send-email-fabio.baltieri@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="x0KprKst+ZOYEj2z"
Content-Disposition: inline
In-Reply-To: <1369750599-10795-1-git-send-email-fabio.baltieri@linaro.org>
X-Cookie: Today is what happened to yesterday.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 212.183.140.31
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: ux500: Ensure consistent configuration between DAIs
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--x0KprKst+ZOYEj2z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, May 28, 2013 at 04:16:39PM +0200, Fabio Baltieri wrote:
> Current implementation of mop500_ab8500 allows for inconsistent sample
> rate and channel count configuration between the playback and recording
> interfaces, through in the hardware the two MSP controllers share
> common clock and frame sync signals.

Applied, thanks.

--x0KprKst+ZOYEj2z
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRpL3pAAoJELSic+t+oim9GhUQAIkWggGVxh3E/d2TpEni6f6v
nrqNvyxUWk28+tUpfXyrBbwLLOIzjfc4TTQJ/BsE2vinWnblt0MGVf/E8qZJXf2N
w58KEfR7kwEZVp6Qr2yMnBTY1bt4LwDqDN+OIB8BwXf63BwjadDIIlBLOZTGEYuk
AtphDEZoC60y0tLcanATBJnezEVdwOIl/Ocrv7MV82GGlGFg/APXTojd8e7gYDjj
IqaYLs4lmVkS2qT+sUE4abY1gtxqXg8lUSicglRG/igEQhk7O6GDAnp1OZQwv0Em
96DgdVZwTtVHbFQE/QOwopZlAJO+OGssFjj/J39D/H/M8zjKjfAajP4SEna3M0Hu
dpEw4SzexwgdkZfW//Bbg3y9Jc05ahq22JXcAWvgeM85ZODczLniEvmHdxLTvHOZ
DbdNLWQbj/B1IoZZ+2hCsejcMCkM+h8Ib95u7ju3NGccrV/vfA6wUsx7MFqk0c5u
mp3TNEVHi8n9X9nz76hwhaUX6nyiGWhzb7Z84ofYhsfx5D3JsbKQnZCGHA8ekzm3
z7YDWlJYiyWcGAJaAPteSGjrzg3iS7l6vdNRoLt+hLA2sf5uqJNvnV1G4lDlCEKt
nYqEM/f4zKZy6HCPU2LUQh/ojpPEL8cGMvNS0t3JWQWUM1XPLJzhoJU35P1pXbjW
yCgdLK2Fm0RmDJE54dXQ
=wPXg
-----END PGP SIGNATURE-----

--x0KprKst+ZOYEj2z--
