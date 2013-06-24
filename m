Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751812Ab3FXOaX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 10:30:23 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:53980 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973Ab3FXOaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 10:30:21 -0400
Date: Mon, 24 Jun 2013 15:30:17 +0100
From: Mark Brown <broonie@kernel.org>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lgirdwood@gmail.com>,
        Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org
Message-ID: <20130624143017.GN27646@sirena.org.uk>
References: <Pine.LNX.4.64.1306241246580.19735@axis700.grange>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Fl9V9vFrQUs+59QW"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1306241246580.19735@axis700.grange>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 2/2] regulators: max8973: initial DT support
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Fl9V9vFrQUs+59QW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 24, 2013 at 12:50:16PM +0200, Guennadi Liakhovetski wrote:
> This patch adds primitive DT support to the max8973 regulator driver. None
> of the configuration parameters, supported in the platform data are yet

Applied, thanks.  "regulator" not "regulators".

--Fl9V9vFrQUs+59QW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRyFf2AAoJELSic+t+oim9EVAP/RUrPNGbWW5UVNeotkX7ZILE
P1S78uuClgIHAC6yKKCi9tlUaUgkeDyPXFrSxOtGzYv7SecP2d8IBXgH8RpcbmMq
70ksMG7LELFmbRyJuRj9qq/H2P4osNXeGqoZQGR6qvibNT/ew4kNZwbt6D9hxiCF
H+CBQbQCtFTQPAZ4DpTl6PHFdIJPP02oTYNLUm/OBdlWlswnwLlvC4vmU7pRwIIw
6aK/K0X0gLHEdYbjg3olCia7xGoU8X+xIEQ9vlHF1v2LXQEtMaJbU5VFYp51PTLF
ga4oKGdXoyzW0w4h/Vwx858PsxO3lPf5ecVNWsuYG8aaQasnMkmpScuQJvmRPIvD
15rPouECxmH/knwkjYHyth5OtRt0gDbC7q10ZiitRqynVG4erKQvusKTG0WGveut
tWlCtr5M1ZfI3GxltZF2rwW/srv7oKFovqrKqt/vragnOMRROJ35XZSx5BjUMhBd
ryE3GZVJExr0ED645Gu87Yri9anIQEs9ffBt1tHW0Pg4BwaUqTVQgoaoTNxJydsL
MUvQigGocxH4n6UYd6PpyT1RYHRtXYmIMp9jNlapU5zLZJDcuKR9bV6LvJAYu0Fq
SgevCDC5O+BI+mMovBjykAwi2ohlNyuoMaOXi+piLGv9W7x2Qhak9G/crLx2U5YO
N97LCpmlgjahq+qfCCDs
=5Db0
-----END PGP SIGNATURE-----

--Fl9V9vFrQUs+59QW--
