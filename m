Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752596AbaL2ROr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 12:14:47 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:54541 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751528AbaL2ROp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 12:14:45 -0500
Date: Mon, 29 Dec 2014 17:14:33 +0000
From: Mark Brown <broonie@kernel.org>
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
Cc: linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Message-ID: <20141229171433.GD17800@sirena.org.uk>
References: <1418725315-25621-1-git-send-email-iivanov@mm-sol.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FBzHcVv9FDoUuQV5"
Content-Disposition: inline
In-Reply-To: <1418725315-25621-1-git-send-email-iivanov@mm-sol.com>
X-Cookie: You have no real enemies.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 86.128.155.20
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] spi: qup: Add SPI_CPOL configuration support
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--FBzHcVv9FDoUuQV5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Dec 16, 2014 at 12:21:55PM +0200, Ivan T. Ivanov wrote:
> Device support SPI_CPOL, but driver have missed to add
> support for this configuration.

Applied, thanks.

--FBzHcVv9FDoUuQV5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUoYv5AAoJECTWi3JdVIfQBToH/3LpACz0ln+PYeIQxc034Yqd
34llPbVHgwvdw12E5V32s+M+LwlSO9zMccEY/b11MM39ceEHoZlUi5nUqD19Pz/f
JmBCc62KLbQ0+Qtal1BFmuKSknMWbw9ewBdvdRh6sdnMfE6n7rHUxEKnsds4X63E
9jPPUu4apOYFVqM2c4IReuyzJrDwEADcKnYTvjy/aPtz+UmdE9s8yRqYbb8NPh2t
LDeU2mM/UVVjctHM/INBQj1fEfeWKqW6Hhq8CDgt7bvbaBthMirDWuGvUCGRbJip
xzZD0TYPAYO/7KAwSG+1DkRo2ppvfmeZARlwlZ+wmxqf/TlQ1CfZwPGhbqefah8=
=B2x2
-----END PGP SIGNATURE-----

--FBzHcVv9FDoUuQV5--
