Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755237AbaLVPKq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 10:10:46 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:44063 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754768AbaLVPKo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 10:10:44 -0500
Date: Mon, 22 Dec 2014 15:10:25 +0000
From: Mark Brown <broonie@kernel.org>
To: Beomho Seo <beomho.seo@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        lgirdwood@gmail.com, cw00.choi@samsung.com, inki.dae@samsung.com,
        sw0312.kim@samsung.com
Message-ID: <20141222151025.GY17800@sirena.org.uk>
References: <1418901216-19030-1-git-send-email-beomho.seo@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FvpZCdL3V2P9482l"
Content-Disposition: inline
In-Reply-To: <1418901216-19030-1-git-send-email-beomho.seo@samsung.com>
X-Cookie: You have no real enemies.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 31.51.36.65
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: rt5033-regulator: Use
 regulator_nodes/of_match in the descriptor
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--FvpZCdL3V2P9482l
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Dec 18, 2014 at 08:13:36PM +0900, Beomho Seo wrote:
> This patch is add regulator_nodes/of_match in the regulator descriptor
> for using information from DT instead of sppecific codes.

>  drivers/regulator/rt5033-regulator.c |    8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)

This isn't replacing existing code with use of the framework, it's
adding new bindings where there were none before so it needs to add a
binding document too.

--FvpZCdL3V2P9482l
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUmDRgAAoJECTWi3JdVIfQynIH/2xAjbwTHL8cbNpaumgU7CQf
R+BFNItfngflNMPBm6LIlkp7Y9aAjbHinvwHXe57KhN5ei/mFyOcGdXdYArrUrwz
C8Z/O2j5NFlj9lbcOozAAyclAkQKwJkA+Sih5DolEC9RNNP/l59fhaYZnKTu5QBp
LXM+ZfK43onmC55uG6Ku/BQ3oHbJT/3efSi8HRezX3fwGAiM6Rnd9fBC+Ha2QHGq
4RBQVYYejOkXYcs+XWhkQ88iqxDczh4wsBuQsIYD/X/ciiBpYpMX3iK88R5UTVDG
J4SrvbuseEwRehxe/nvQKah136M5BnldRZNqleAkYuzOPj8LIjEdLcpchX5M10Y=
=dlST
-----END PGP SIGNATURE-----

--FvpZCdL3V2P9482l--
