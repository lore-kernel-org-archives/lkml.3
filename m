Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754204Ab3FJREj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 13:04:39 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:52879 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752095Ab3FJREh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 13:04:37 -0400
Date: Mon, 10 Jun 2013 18:04:18 +0100
From: Mark Brown <broonie@kernel.org>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        kyungmin.park@samsung.com, spi-devel-general@lists.sourceforge.net
Message-ID: <20130610170418.GN1403@sirena.org.uk>
References: <1370881346-28000-1-git-send-email-s.nawrocki@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UExESr5xZTMxdOWv"
Content-Disposition: inline
In-Reply-To: <1370881346-28000-1-git-send-email-s.nawrocki@samsung.com>
X-Cookie: Tomorrow, you can be anywhere.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 82.42.102.178
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH RESEND] spi: s3c64xx: Fix pm_runtime_get_sync() return
 value check
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UExESr5xZTMxdOWv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 10, 2013 at 06:22:26PM +0200, Sylwester Nawrocki wrote:
> If the device is already in a runtime PM enabled state
> pm_runtime_get_sync() will return 1, so a test for negative
> value should be used to check for errors.

Applied, thanks.

--UExESr5xZTMxdOWv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRtgcPAAoJELSic+t+oim9paoP/jkM2dFIJg/QPdlwbgxU4Rsi
5kgbSYlQUCPi1F7CNHc/ZZfeGY8WDslFzMRyTId0EbvdcvUKk0bYPx+qC107vawS
SQAZBB2e4YxGdCFlYkrE5dShXwq5kxoHIhdM4CqznU5Ktlf6gm1YRZ3D/UZUU5XN
FdIoG2AM+ZkBcH+5NKGhnLGuMe243LRd2rQ/KnpD1aDnzSYcKnnxkmzxODmpzgCR
7erigKIz49MeLUWO/STUbUoZfko5cBIiqrf/e3YET2/ThufJkOuI6is3d5uP8QtA
Ne3R9EOLNiIubtY1EdvCLbA6UflWEqoGIwgQsHktsh3J4rPq2EA8m16TmnlsrVbo
9GzLBPV4iNF4UCb7+NRKfmJdN+89r838OSpUjosdS4ab39ltQhZIRa7QdOwUJh4d
oOz4YcORuasqdnlA+e/dBVpuchTJCsT1GJJXGNGAOYtXJbgzI3+SDPcnP3ZjVluk
j+9HbJh1wUCKYS17E2+ffXrcOB3+fEP3RPNi0f9H+FccT/e/tZprFU5/iOHv3JoS
CCBMumhyAszMn+kkmujKlLn+oxEXy1H9Bx85+1bUsqRq5AFdWDxhyCMnoNQ476zr
9/pKiME/lmUKKT1mWTYhhkLF1/GgPqWNTSN+4Mlh2CekafqkFdiNHnyiQY438kLp
9R0im3GVhwLP/EyO63tf
=y3wE
-----END PGP SIGNATURE-----

--UExESr5xZTMxdOWv--
